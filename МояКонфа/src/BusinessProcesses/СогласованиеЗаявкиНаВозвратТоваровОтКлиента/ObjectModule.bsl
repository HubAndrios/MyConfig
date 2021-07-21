#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет строку с результатом согласования рецензента в тч РезультатыСогласования
//
// Параметры:
//   ТочкаМаршрута         - ТочкаМаршрутаБизнесПроцессаСсылка.СогласованиеЗаявкиНаВозвратТоваровОтКлиента - точка, в которой находится бизнес-процесс.
//   Рецензент             - СправочникСсылка.Пользователи - исполнитель задачи по согласованию.
//   РезультатСогласования - ПеречислениеСсылка.РезультатыСогласования - результат согласования в точке маршрута.
//   Комментарий           - Строка - комментарий рецензента.
//   ДатаИсполнения        - Дата  - дата выполнения задачи по согласованию рецензентом.
//
Процедура ДобавитьРезультатСогласования(Знач ТочкаМаршрута,
	                                    Знач Рецензент,
	                                    Знач РезультатСогласования,
	                                    Знач Комментарий,
	                                    Знач ДатаИсполнения) Экспорт
	
	НоваяСтрока                       = РезультатыСогласования.Добавить();
	НоваяСтрока.ТочкаМаршрута         = ТочкаМаршрута;
	НоваяСтрока.Рецензент             = Рецензент;
	НоваяСтрока.РезультатСогласования = РезультатСогласования;
	НоваяСтрока.Комментарий           = Комментарий;
	НоваяСтрока.ДатаСогласования      = ДатаИсполнения;
	
	Если БизнесПроцессы.СогласованиеЗаявкиНаВозвратТоваровОтКлиента.ИспользуетсяВерсионированиеПредмета(Предмет.Метаданные().ПолноеИмя()) Тогда
		НоваяСтрока.НомерВерсии = БизнесПроцессы.СогласованиеЗаявкиНаВозвратТоваровОтКлиента.НомерПоследнейВерсииПредмета(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Дата согласования должна быть не меньше даты документа
	Если ЗначениеЗаполнено(ДатаСогласования) И ДатаСогласования < НачалоДня(Дата) Тогда
		
		ТекстОшибки = НСтр("ru='Дата согласования должна быть не меньше даты бизнес-процесса %Дата%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Дата%", Формат(Дата,"ДЛФ=DD"));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ДатаСогласования",
			,
			Отказ);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Предмет) Тогда
	
		Запрос = Новый Запрос("
			|ВЫБРАТЬ
			|	ВЫБОР
			|		КОГДА
			|			ДокументПредмет.Проведен И ДокументПредмет.Согласован
			|		ТОГДА
			|			ИСТИНА
			|		ИНАЧЕ
			|			ЛОЖЬ
			|	КОНЕЦ КАК ЕстьОшибкиСогласован,
			|	ДокументПредмет.Ссылка КАК Предмет
			|ИЗ
			|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ДокументПредмет
			|ГДЕ
			|	ДокументПредмет.Ссылка = &Предмет
			|");
			
		Запрос.УстановитьПараметр("Предмет", Предмет);
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		// Документ уже согласован - нет смысла начинать согласование
		Если Выборка.ЕстьОшибкиСогласован Тогда
			
			ТекстОшибки = НСтр("ru='%Предмет% не нуждается в согласовании'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%", Выборка.Предмет);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"Предмет",
				,
				Отказ);
				
			Возврат;
				
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента") Тогда
		ЗаполнитьБизнесПроцессНаОснованииЗаявкиНаВозвратТоваровОтКлиента(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьБизнесПроцесс();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДатаНачала            = Дата(1,1,1);
	ДатаОкончания         = Дата(1,1,1);
	РезультатСогласования = Перечисления.РезультатыСогласования.ПустаяСсылка();
	ЕстьОтклоненияОтЛогистическихУсловий = Ложь;
	ЕстьОтклоненияОтФинансовыхУсловий    = Ложь;
	ЕстьОтклоненияОтЛогистическихУсловий = Ложь;
	
	РезультатыСогласования.Очистить();
	
	ИнициализироватьБизнесПроцесс();
	
КонецПроцедуры

Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаНачала = ТекущаяДатаСеанса();
	
	Если НЕ ОбщегоНазначенияУТ.ПроверитьСогласующегоБизнесПроцесс(Справочники.РолиИсполнителей.СогласующийЗаявкиНаВозвратТоваровОтКлиентов) Тогда
		ТекстСообщения = НСтр("ru='Не указан %РольСогласующего%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%РольСогласующего%", Справочники.РолиИсполнителей.СогласующийЗаявкиНаВозвратТоваровОтКлиентов);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаЗавершения = ТекущаяДатаСеанса();
	
КонецПроцедуры

Процедура ПроверкаОтклоненияОтУсловийСоглашенияОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	ПродажиСервер.ПроверитьНеобходимостьСогласованияУсловийПродажи(
		Предмет,
		ЕстьОтклоненияОтЦеновыхУсловий,
		ЕстьОтклоненияОтФинансовыхУсловий,
		ЕстьОтклоненияОтЛогистическихУсловий);
	
	Записать();
	
КонецПроцедуры

Процедура ОбработкаРезультатовСогласованияОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПредметОбъект = Предмет.ПолучитьОбъект();
	
	// Документ уже согласован - ничего делать не требуется
	Если Не ПредметОбъект.ПометкаУдаления И Не (ПредметОбъект.Проведен И ПредметОбъект.Согласован) Тогда
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Предмет);
		Исключение
			
			ТекстОшибки = НСтр("ru='В ходе обработки результатов согласования не удалось заблокировать %Предмет%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%",        Предмет);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ВызватьИсключение ТекстОшибки;
				
		КонецПопытки;
		
		ПредметОбъект.Согласован = Истина;
		Если ПредметОбъект.Статус = Перечисления.СтатусыЗаявокНаВозвратТоваровОтКлиентов.НеСогласована Тогда
			ПредметОбъект.Статус = Перечисления.СтатусыЗаявокНаВозвратТоваровОтКлиентов.КОбеспечению;
			ПредметОбъект.ДатаСогласования = ТекущаяДатаСеанса();
		КонецЕсли;
		
		Попытка
		
			ПредметОбъект.Записать(РежимЗаписиДокумента.Проведение);
			РазблокироватьДанныеДляРедактирования(Предмет);
			
		Исключение
			
			РазблокироватьДанныеДляРедактирования(Предмет);
			
			ТекстОшибки = НСтр("ru='Не удалось записать %Предмет%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%",        Предмет);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки
		
	КонецЕсли;
		
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ЗаменаПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЗаявкаНаВозвратЗаменяющиеТовары.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ЗаявкаНаВозвратТоваровОтКлиента.ЗаменяющиеТовары КАК ЗаявкаНаВозвратЗаменяющиеТовары
		|ГДЕ
		|	ЗаявкаНаВозвратЗаменяющиеТовары.Ссылка = &Ссылка
		|");
	
	Запрос.УстановитьПараметр("Ссылка", Предмет);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Результат = Истина;
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЕстьОтклонениеОтЦеновыхУсловийПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = ЕстьОтклоненияОтЦеновыхУсловий;
	
КонецПроцедуры

Процедура ЕстьОтклонениеОтФинансовыхУсловийПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = ЕстьОтклоненияОтФинансовыхУсловий;
	
КонецПроцедуры

Процедура ЕстьОтклонениеОтЛогистическихУсловийПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = ЕстьОтклоненияОтЛогистическихУсловий;
	
КонецПроцедуры

Процедура ДокументСогласованПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = (РезультатСогласования = Перечисления.РезультатыСогласования.Согласовано);
	
КонецПроцедуры

Процедура ОзнакомитьсяСРезультатамиПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	Задача.Исполнитель = Автор;
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура СогласоватьЗаявкуНаВозвратТоваровОтКлиентаПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура ОзнакомитьсяСРезультатамиОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	Результат = Истина;
	
КонецПроцедуры

Процедура СогласоватьДокументПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура СогласоватьДокументОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	Результат = Истина;
	
КонецПроцедуры

Процедура ПодвестиИтогиСогласованияПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура ПодвестиИтогиСогласованияОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	Результат = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

// Заполняет согласование на основании установки цен номенклатуры.
//
// Параметры
//	ДокументОснование - ДокументСсылка.ЗаказКлиента - Ссылка на заказ клиента
//
Процедура ЗаполнитьБизнесПроцессНаОснованииЗаявкиНаВозвратТоваровОтКлиента(ДокументОснование)
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ЗаявкаНаВозвратТоваровОтКлиента.Ссылка      КАК Предмет,
		|	ЗаявкаНаВозвратТоваровОтКлиента.Статус      КАК Статус,
		|	НЕ ЗаявкаНаВозвратТоваровОтКлиента.Проведен КАК ЕстьОшибкиПроведен,
		|	ВЫБОР
		|		КОГДА
		|			ЗаявкаНаВозвратТоваровОтКлиента.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаВозвратТоваровОтКлиентов.НеСогласована)
		|		ТОГДА
		|			ЛОЖЬ
		|		ИНАЧЕ
		|			ИСТИНА
		|	КОНЕЦ КАК ЕстьОшибкиСтатус
		|ИЗ
		|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаявкаНаВозвратТоваровОтКлиента
		|ГДЕ
		|	ЗаявкаНаВозвратТоваровОтКлиента.Ссылка = &ДокументОснование
		|");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	МассивДопустимыхСтатусов = Новый Массив();
	МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыЗаказовКлиентов.НеСогласован);
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		Выборка.Предмет,
		Выборка.Статус,
		Выборка.ЕстьОшибкиПроведен,
		Выборка.ЕстьОшибкиСтатус,
		МассивДопустимыхСтатусов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры

// Заполняет согласование заказа клиента в соответствии с отбором.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Структура со значениями отбора
//
Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Предмет") Тогда
		
		ТипПредмета = ТипЗнч(ДанныеЗаполнения.Предмет);
		
		Если ТипПредмета = Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента") Тогда
			ЗаполнитьБизнесПроцессНаОснованииЗаявкиНаВозвратТоваровОтКлиента(ДанныеЗаполнения.Предмет);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Инициализирует согласование установки цен.
//
Процедура ИнициализироватьБизнесПроцесс()
	
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Создает и заполняет задачу исполнителя
//
// Параметры:
//	ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка.СогласованиеЗаявкиНаВозвратТоваровОтКлиента
//
// Возвращаемое значение:
//	Созданная задача - ЗадачаОбъект.ЗадачаИсполнителя
//
Функция СоздатьЗадачу(Знач ТочкаМаршрутаБизнесПроцесса)
	
	Задача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
	
	Задача.Дата                          = ТекущаяДатаСеанса();
	Задача.Автор                         = Автор;
	Задача.Наименование                  = ТочкаМаршрутаБизнесПроцесса.НаименованиеЗадачи;
	Задача.Описание                      = Наименование;
	Задача.Предмет                       = Предмет;
	Задача.Важность                      = Важность;
	Задача.РольИсполнителя               = ТочкаМаршрутаБизнесПроцесса.РольИсполнителя;
	Задача.ОсновнойОбъектАдресации       = ТочкаМаршрутаБизнесПроцесса.ОсновнойОбъектАдресации;
	Задача.ДополнительныйОбъектАдресации = ТочкаМаршрутаБизнесПроцесса.ДополнительныйОбъектАдресации;
	Задача.БизнесПроцесс                 = Ссылка;
	Задача.СрокИсполнения                = ДатаСогласования;
	Задача.ТочкаМаршрута                 = ТочкаМаршрутаБизнесПроцесса;
	
	Возврат Задача;

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
