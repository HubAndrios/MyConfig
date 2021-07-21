
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Записано Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	Элементы.ОбменНаСервере.Видимость = НЕ ОбщегоНазначения.РазделениеВключено();
	Элементы.РабочееМесто.ПодсказкаВвода = НСтр("ru = 'Сервер 1С:Предприятия'");
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не Записано
		И Не ЗначениеЗаполнено(Запись.РабочееМесто) Тогда
		МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
		Запись.РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_КлассификаторОрганизацийЕГАИС" Тогда
		
		ЗаполнитьДанные();
		
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Записано = Истина;
	
	Запись.РабочееМесто = ТекущийОбъект.РабочееМесто;
	РабочееМестоКеш     = ТекущийОбъект.РабочееМесто;
	
	ОбменНаСервере = ТекущийОбъект.ОбменНаСервере;
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФормЕГАИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Ссылка КАК ОрганизацияЕГАИС
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	КлассификаторОрганизацийЕГАИС.Код = &КодВФСРАР");
	Запрос.УстановитьПараметр("КодВФСРАР", Запись.ИдентификаторФСРАР);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ОрганизацияЕГАИС = Выборка.ОрганизацияЕГАИС;
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Перед записью настройки обмена нужно запросить информацию по собственной организации из ЕГАИС.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		
	КонецЕсли;
	
	ТекущийОбъект.ОбменНаСервере = ОбменНаСервере;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	РабочееМестоКеш = Запись.РабочееМесто;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ИдентификаторФСРАР", Запись.ИдентификаторФСРАР);
	
	Оповестить("Запись_ПараметрыПодключенияЕГАИС", ПараметрыОповещения, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТребуетсяПроверкаНаДубли = (РабочееМестоКеш <> Запись.РабочееМесто);
	
	Если ТребуетсяПроверкаНаДубли Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Поле1
		|ИЗ
		|	РегистрСведений.НастройкиОбменаЕГАИС КАК НастройкиОбменаЕГАИС
		|ГДЕ
		|	НастройкиОбменаЕГАИС.ИдентификаторФСРАР = &ИдентификаторФСРАР
		|	И НастройкиОбменаЕГАИС.РабочееМесто = &РабочееМесто");
		
		Запрос.УстановитьПараметр("ИдентификаторФСРАР", Запись.ИдентификаторФСРАР);
		Запрос.УстановитьПараметр("РабочееМесто",       Запись.РабочееМесто);
		
		Если НЕ Запрос.Выполнить().Пустой() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Настройка обмена для организации с кодом ФСРАР %1 уже существует'"),
					Запись.ИдентификаторФСРАР),,
				"Запись.ИдентификаторФСРАР",,
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИдентификаторФСРАРПриИзменении(Элемент)
	
	ЗаполнитьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбменНаСервереПриИзменении(Элемент)
	
	ПриИзмененииВариантаПодключения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКодФСРАР(Команда)
	
	Если ПустаяСтрока(Запись.АдресУТМ) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не указан IP-адрес (или доменное имя) компьютера с установленной службой УТМ.'"),,
			"АдресУТМ",
			"Запись");
		Возврат;
	КонецЕсли;
	
	Если Запись.ПортУТМ = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не указан порт доступа к УТМ.'"),,
			"ПортУТМ",
			"Запись");
		Возврат;
	КонецЕсли;
	
	ТранспортныйМодуль = Новый Структура;
	ТранспортныйМодуль.Вставить("ИдентификаторФСРАР", "000000000000");
	ТранспортныйМодуль.Вставить("РабочееМесто"      , Запись.РабочееМесто);
	ТранспортныйМодуль.Вставить("АдресУТМ"          , Запись.АдресУТМ);
	ТранспортныйМодуль.Вставить("ПортУТМ"           , Запись.ПортУТМ);
	ТранспортныйМодуль.Вставить("ОбменНаСервере"    , Запись.ОбменНаСервере);
	ТранспортныйМодуль.Вставить("ФорматОбмена"      , ПредопределенноеЗначение("Перечисление.ФорматыОбменаЕГАИС.V1"));
	
	ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОрганизаций");
	
	ВходныеПараметры = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(ВидДокумента);
	ВходныеПараметры.ИмяПараметра = "СИО";
	ВходныеПараметры.ЗначениеПараметра = "000000000000";
	
	ИнтеграцияЕГАИСКлиент.НачатьФормированиеИсходящегоЗапроса(
		Новый ОписаниеОповещения("ПолучениеКодаФСРАР_Завершение", ЭтотОбъект),
		ВидДокумента,
		ВходныеПараметры,
		ТранспортныйМодуль,
		Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДанные()
	
	ДанныеСопоставления = ИнтеграцияЕГАИСПереопределяемый.ДанныеСопоставленияОрганизацииЕГАИС(СокрЛП(Запись.ИдентификаторФСРАР));
	
	ОрганизацияЕГАИС = Справочники.КлассификаторОрганизацийЕГАИС.ПустаяСсылка();
	
	Если ЗначениеЗаполнено(ДанныеСопоставления.ОрганизацияЕГАИС) Тогда
		
		ОрганизацияКонтрагент = ДанныеСопоставления.Организация;
		ТорговыйОбъект        = ДанныеСопоставления.ТорговыйОбъект;
		ОрганизацияЕГАИС      = ДанныеСопоставления.ОрганизацияЕГАИС;
		
		Если ЗначениеЗаполнено(ДанныеСопоставления.Организация)
			И ЗначениеЗаполнено(ДанныеСопоставления.ТорговыйОбъект) Тогда
			
			Строка1 = Новый ФорматированнаяСтрока(
				НСтр("ru = 'Организация:'"));
			
			Строка2 = Новый ФорматированнаяСтрока(
				Строка(ДанныеСопоставления.Организация),
				Новый Шрифт(,,,,Истина),
				ЦветаСтиля.ЦветГиперссылкиГИСМ,
				,
				"КомандаОткрытьОрганизацию");
				
			Строка3 = Новый ФорматированнаяСтрока(
				НСтр("ru = 'Торговый объект:'"));
			
			Строка4 = Новый ФорматированнаяСтрока(
				Строка(ДанныеСопоставления.ТорговыйОбъект),
				Новый Шрифт(,,,,Истина),
				ЦветаСтиля.ЦветГиперссылкиГИСМ,
				,
				"КомандаОткрытьТорговыйОбъект");
				
			МассивСтрок = Новый Массив;
			МассивСтрок.Добавить(Строка1);
			МассивСтрок.Добавить(" ");
			МассивСтрок.Добавить(Строка2);
			МассивСтрок.Добавить(Символы.ПС);
			МассивСтрок.Добавить(Строка3);
			МассивСтрок.Добавить(" ");
			МассивСтрок.Добавить(Строка4);
			
			ТекстСопоставление = Новый ФорматированнаяСтрока(МассивСтрок);
			
		Иначе
			
			Строка1 = Новый ФорматированнаяСтрока(
				НСтр("ru = 'Организация ЕГАИС не сопоставлена с организацией
				           |или торговым объектом предприятия.'"),,
				ЦветаСтиля.ЦветТекстаТребуетВниманияГИСМ);
			
			Строка2 = Новый ФорматированнаяСтрока(
				НСтр("ru = 'Сопоставить.'"),
				Новый Шрифт(,,,,Истина),
				ЦветаСтиля.ЦветГиперссылкиГИСМ,
				,
				"КомандаОткрытьОрганизациюЕГАИС");
			
			МассивСтрок = Новый Массив;
			МассивСтрок.Добавить(Строка1);
			МассивСтрок.Добавить(" ");
			МассивСтрок.Добавить(Строка2);
			
			ТекстСопоставление = Новый ФорматированнаяСтрока(МассивСтрок);
			
		КонецЕсли;
		
	ИначеЕсли НЕ ПустаяСтрока(Запись.ИдентификаторФСРАР) Тогда
		
		Строка1 = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Организация ЕГАИС не найдена по коду ФСРАР
			            |в классификаторе организаций.'"),,
			ЦветаСтиля.ЦветТекстаТребуетВниманияГИСМ);
			
		Строка2 = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Запросить из ЕГАИС'"),
			Новый Шрифт(,,,,Истина),
			ЦветаСтиля.ЦветГиперссылкиГИСМ,
			,
			"КомандаЗапроситьОрганизациюЕГАИС");
			
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(Строка1);
		МассивСтрок.Добавить(" ");
		МассивСтрок.Добавить(Строка2);
		
		ТекстСопоставление = Новый ФорматированнаяСтрока(МассивСтрок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииВариантаПодключения()
	
	Если ОбменНаСервере = 0 Тогда
		Подсказка = НСтр("ru = 'Подключение к УТМ будет осуществляться с компьютера пользователя'");
	ИначеЕсли ОбменНаСервере = 1 Тогда
		Подсказка = НСтр("ru = 'Подключение к УТМ будет осуществляться с компьютера, на котором установлен сервер 1С:Предприятия'");
	КонецЕсли;
	
	Элементы.ОбменНаСервере.Подсказка = Подсказка;
	
КонецПроцедуры

&НаКлиенте
Процедура РабочееМестоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		СтандартнаяОбработка = Ложь;
		МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
		Запись.РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстСопоставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "КомандаОткрытьОрганизацию" Тогда
		ПоказатьЗначение(, ОрганизацияКонтрагент);
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "КомандаОткрытьТорговыйОбъект" Тогда
		ПоказатьЗначение(, ТорговыйОбъект);
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "КомандаОткрытьОрганизациюЕГАИС" Тогда
		ПоказатьЗначение(, ОрганизацияЕГАИС);
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "КомандаЗапроситьОрганизациюЕГАИС" Тогда
		Если Модифицированность Тогда
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Продолжить'"));
			Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена'"));
			
			ПоказатьВопрос(
				Новый ОписаниеОповещения("ЗапросОрганизацииЕГАИС_Подтверждение", ЭтотОбъект),
				НСтр("ru='Настройка обмена будет записана.'"),
				Кнопки);
		Иначе
			НачатьФормированиеЗапросаНаЗагрузкуОрганизации();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросОрганизацииЕГАИС_Подтверждение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗаписатьНастройкуОбмена() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ИдентификаторФСРАР", Запись.ИдентификаторФСРАР);
	
	Оповестить("Запись_ПараметрыПодключенияЕГАИС", ПараметрыОповещения, ЭтотОбъект);
	
	Прочитать();
	
	НачатьФормированиеЗапросаНаЗагрузкуОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьФормированиеЗапросаНаЗагрузкуОрганизации()
	
	Отбор = Новый Массив;
	Отбор.Добавить(Новый Структура("Поле, Значение", "ИдентификаторФСРАР", СокрЛП(Запись.ИдентификаторФСРАР)));
	Отбор.Добавить(Новый Структура("Поле, Значение", "РабочееМесто", Запись.РабочееМесто));
	
	ДоступныеМодули = ИнтеграцияЕГАИСВызовСервера.ДоступныеТранспортныеМодули(Отбор);
	Если ДоступныеМодули.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОрганизаций");
	
	ВходныеПараметры = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(ВидДокумента);
	ВходныеПараметры.ИмяПараметра = "СИО";
	ВходныеПараметры.ЗначениеПараметра = СокрЛП(Запись.ИдентификаторФСРАР);
	
	ИнтеграцияЕГАИСКлиент.НачатьФормированиеИсходящегоЗапроса(
		Новый ОписаниеОповещения("ЗапросОрганизацииЕГАИС_Завершение", ЭтотОбъект),
		ВидДокумента,
		ВходныеПараметры,
		ДоступныеМодули[0]);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросОрганизацииЕГАИС_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") ИЛИ НЕ Результат.Результат Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИСКлиент.СообщитьОЗавершенииФормированияИсходящегоЗапроса();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеКодаФСРАР_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Позиция = СтрНайти(Результат.ОписаниеОшибки, "RSA");
	
	Если Позиция <> 0 Тогда
		НачалоКода = СтрНайти(Результат.ОписаниеОшибки, "[",, Позиция);
		КонецКода = СтрНайти(Результат.ОписаниеОшибки, "]",, Позиция);
		
		Если НачалоКода <> 0 И КонецКода <> 0 Тогда
			НачалоКода = НачалоКода + 1;
			Запись.ИдентификаторФСРАР = Сред(Результат.ОписаниеОшибки, НачалоКода, КонецКода - НачалоКода);
			Модифицированность = Истина;
			
			ЗаполнитьДанные();
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ЗаполнитьДанные();
	ПриИзмененииВариантаПодключения();

КонецПроцедуры

&НаСервере
Функция ЗаписатьНастройкуОбмена()
	
	НачатьТранзакцию();
	Попытка
		
		СоздатьЭлементКлассификатора();
		
		Результат = Записать();
		Если Не Результат Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'ЕГАИС'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	ЗаполнитьДанные();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СоздатьЭлементКлассификатора()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Ссылка КАК ОрганизацияЕГАИС
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	КлассификаторОрганизацийЕГАИС.Код = &КодВФСРАР");
	Запрос.УстановитьПараметр("КодВФСРАР", Запись.ИдентификаторФСРАР);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизацияОбъект = Справочники.КлассификаторОрганизацийЕГАИС.СоздатьЭлемент();
	ОрганизацияОбъект.Код = Запись.ИдентификаторФСРАР;
	ОрганизацияОбъект.ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V1;
	ОрганизацияОбъект.СоответствуетОрганизации = Истина;
	ОрганизацияОбъект.Записать();
	
КонецПроцедуры

#КонецОбласти