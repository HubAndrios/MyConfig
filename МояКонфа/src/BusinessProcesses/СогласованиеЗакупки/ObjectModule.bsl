#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет строку с результатом согласования рецензента в ТЧ РезультатыСогласования
//
// Параметры:
//   ТочкаМаршрута         - ТочкаМаршрутаБизнесПроцессаСсылка.СогласованиеЗакупки - точка, в которой находится бизнес-процесс.
//   Рецензент             - СправочникСсылка.Пользователи                         - исполнитель задачи по согласованию.
//   РезультатСогласования - ПеречислениеСсылка.РезультатыСогласования             - результат согласования.
//   Комментарий           - Строка                                                - комментарий рецензента.
//   ДатаИсполнения        - Дата                                                  - дата выполнения задачи по согласованию рецензентом.
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
	
	Если БизнесПроцессы.СогласованиеЗакупки.ИспользуетсяВерсионированиеПредмета(Предмет.Метаданные().ПолноеИмя()) Тогда
		НоваяСтрока.НомерВерсии = БизнесПроцессы.СогласованиеЗакупки.НомерПоследнейВерсииПредмета(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		ЗаполнитьБизнесПроцессНаОснованииЗаказаПоставщику(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьБизнесПроцесс();
	
КонецПроцедуры

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
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ДокументПредмет.Проведен
		|				И ДокументПредмет.Согласован
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЕстьОшибкиСогласован,
		|	ВЫБОР
		|		КОГДА (НЕ ДокументПредмет.Проведен)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЕстьОшибкиПроведен,
		|	ДокументПредмет.Статус КАК Статус,
		|	ДокументПредмет.Ссылка КАК Предмет
		|ИЗ
		|	Документ.ЗаказПоставщику КАК ДокументПредмет
		|ГДЕ
		|	ДокументПредмет.Ссылка = &Предмет");
			
		Запрос.УстановитьПараметр("Предмет", Предмет);
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		// Документ не проведен - нет смысла начинать согласование
		Если Выборка.ЕстьОшибкиПроведен Тогда
			
			ТекстОшибки = НСтр("ru='Согласование не может быть начато, т.к. документ %ДокументПредмет% не проведен'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ДокументПредмет%", Выборка.Предмет);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"Предмет",
				,
				Отказ);
				
			Возврат;
			
		// Документ уже согласован - нет смысла начинать согласование
		ИначеЕсли Выборка.ЕстьОшибкиСогласован Тогда
			
			ТекстОшибки = НСтр("ru='%Предмет% в статусе ""%Статус%"" не нуждается в согласовании'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%", Выборка.Предмет);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%",  Выборка.Статус);
			
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
	
	Если НЕ ОбщегоНазначенияУТ.ПроверитьСогласующегоБизнесПроцесс(Справочники.РолиИсполнителей.СогласующийКоммерческиеУсловияЗакупок) Тогда
		ТекстСообщения = НСтр("ru='Не указан %РольСогласующего%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%РольСогласующего%", Справочники.РолиИсполнителей.СогласующийКоммерческиеУсловияЗакупок);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	Если НЕ ОбщегоНазначенияУТ.ПроверитьСогласующегоБизнесПроцесс(Справочники.РолиИсполнителей.СогласующийЛогистическиеУсловияЗакупок) Тогда
		ТекстСообщения = НСтр("ru='Не указан %РольСогласующего%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%РольСогласующего%", Справочники.РолиИсполнителей.СогласующийЛогистическиеУсловияЗакупок);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	Если НЕ ОбщегоНазначенияУТ.ПроверитьСогласующегоБизнесПроцесс(Справочники.РолиИсполнителей.СогласующийФинансовыеУсловияЗакупок) Тогда
		ТекстСообщения = НСтр("ru='Не указан %РольСогласующего%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%РольСогласующего%", Справочники.РолиИсполнителей.СогласующийФинансовыеУсловияЗакупок);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	Если НЕ ОбщегоНазначенияУТ.ПроверитьСогласующегоБизнесПроцесс(Справочники.РолиИсполнителей.СогласующийЦеновыеУсловияЗакупок) Тогда
		ТекстСообщения = НСтр("ru='Не указан %РольСогласующего%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%РольСогласующего%", Справочники.РолиИсполнителей.СогласующийЦеновыеУсловияЗакупок);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаЗавершения = ТекущаяДатаСеанса();
	
КонецПроцедуры

Процедура ПроверкаОтклоненияОтУсловийСоглашенияОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	ЗакупкиСервер.ПроверитьНеобходимостьСогласованияУсловийЗакупки(
		Предмет,
		ЕстьОтклоненияОтЦеновыхУсловий,
		ЕстьОтклоненияОтФинансовыхУсловий,
		ЕстьОтклоненияОтЛогистическихУсловий);
	
	Записать();
	
КонецПроцедуры

Процедура ОбработкаРезультатовСогласованияОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПредметОбъект = Предмет.ПолучитьОбъект();
	
	НеобходимоСогласовать = (Не ПредметОбъект.ПометкаУдаления И Не (ПредметОбъект.Проведен И ПредметОбъект.Согласован));
	
	// Если документ уже согласован - ничего делать не требуется
	Если НеобходимоСогласовать Тогда
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Предмет);
		Исключение
			
			ТекстОшибки = НСтр("ru='В ходе обработки результатов согласования не удалось заблокировать %Предмет%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%",        Предмет);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ВызватьИсключение ТекстОшибки;
				
		КонецПопытки;
		
		ПредметОбъект.Согласован = Истина;
		
		Если ПредметОбъект.Статус = Перечисления.СтатусыЗаказовПоставщикам.НеСогласован Тогда
			ПредметОбъект.Статус = Перечисления.СтатусыЗаказовПоставщикам.Подтвержден;
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
	ФормируемыеЗадачи.Добавить(Задача)
	
КонецПроцедуры

Процедура ОзнакомитьсяСРезультатамиОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	Результат = Истина;
	
КонецПроцедуры

Процедура СогласоватьЦеновыеУсловияПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СогласоватьДокументПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура СогласоватьЦеновыеУсловияОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	СогласоватьДокументОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат);
	
КонецПроцедуры

Процедура СогласоватьФинансовыеУсловияПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СогласоватьДокументПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура СогласоватьФинансовыеУсловияОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	СогласоватьДокументОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат);
	
КонецПроцедуры

Процедура СогласоватьЛогистическиеУсловияПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СогласоватьДокументПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура СогласоватьЛогистическиеУсловияОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	СогласоватьДокументОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат);
	
КонецПроцедуры

Процедура ПодвестиИтогиСогласованияПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура ПодвестиИтогиСогласованияОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьБизнесПроцессНаОснованииЗаказаПоставщику(ДокументОснование)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗаказПоставщику.Ссылка КАК Предмет,
	|	ЗаказПоставщику.ДатаСогласования КАК ДатаСогласования,
	|	ВЫБОР
	|		КОГДА ЗаказПоставщику.Приоритет В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					Приоритеты.Ссылка КАК Приоритет
	|				ИЗ
	|					Справочник.Приоритеты КАК Приоритеты
	|				УПОРЯДОЧИТЬ ПО
	|					Приоритеты.РеквизитДопУпорядочивания)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Высокая)
	|		КОГДА ЗаказПоставщику.Приоритет В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					Приоритеты.Ссылка КАК Приоритет
	|				ИЗ
	|					Справочник.Приоритеты КАК Приоритеты
	|				УПОРЯДОЧИТЬ ПО
	|					Приоритеты.РеквизитДопУпорядочивания УБЫВ)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Низкая)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВариантыВажностиЗадачи.Обычная)
	|	КОНЕЦ КАК Важность,
	|	ЗаказПоставщику.Статус КАК Статус,
	|	(НЕ ЗаказПоставщику.Проведен) КАК ЕстьОшибкиПроведен,
	|	ВЫБОР
	|		КОГДА ЗаказПоставщику.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовПоставщикам.НеСогласован)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЕстьОшибкиСтатус
	|ИЗ
	|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
	|ГДЕ
	|	ЗаказПоставщику.Ссылка = &ДокументОснование");
	
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

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Предмет") Тогда
		
		ТипПредмета = ТипЗнч(ДанныеЗаполнения.Предмет);
		
		Если ТипПредмета = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
			ЗаполнитьБизнесПроцессНаОснованииЗаказаПоставщику(ДанныеЗаполнения.Предмет);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьБизнесПроцесс()
	
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

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
