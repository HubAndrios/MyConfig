
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	//Получение ФО
	ИспользоватьПартнеровКакКонтрагентов = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов");
	ИспользоватьДоговорыСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСКлиентами");
	
	// Установка отборов.
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("Контрагент",  Контрагент);
		СтруктураБыстрогоОтбора.Свойство("Месяц",  Месяц);
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокСчетовФактурыНаОформление,
		"Организация", Организация, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокСчетовФактурыНаОформление,
		"Контрагент", Контрагент, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокСчетовФактурыНаОформление,
		"Месяц", Месяц, СтруктураБыстрогоОтбора, , ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
		
	ПараметрыЗапроса = ПараметрыЗапросаСчетаФактурыКОформлению();
	Для Каждого ТекПараметр Из ПараметрыЗапроса Цикл
		СписокСчетовФактурыНаОформление.Параметры.УстановитьЗначениеПараметра(ТекПараметр.Ключ, ТекПараметр.Значение);
	КонецЦикла;
	
	ЗаполнитьСписокСчетаФактурыКОформлению();
	
	Если Параметры.Свойство("ОтображатьСтраницуКОформлению") Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаКОформлению;
	КонецЕсли;
	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаГлобальныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(Отказ, СтандартнаяОбработка, ПараметрыПриСозданииНаСервере);
	// Конец подсистема "ОбменСКонтрагентами".
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	
	Если Не ПроверкаКонтрагентовВызовСервера.ИспользованиеПроверкиВозможно() Тогда
		Элементы.ЕстьОшибкиПроверкиКонтрагентов.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами 
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
	// Подсистема "ОбменСКонтрагентами".
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец подсистема "ОбменСКонтрагентами".
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец подсистема "ОбменСКонтрагентами".
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаКОформлению Тогда
		
		МассивТипов = ТипыДокументовОснованийКОформлению();
		МассивТипов.Добавить("СчетФактураВыданный");
		
		Для Каждого ТипДокумента Из МассивТипов Цикл
			Если ИмяСобытия = "Запись_" + ТипДокумента Тогда
				Элементы.СписокСчетовФактурыНаОформление.Обновить();
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ГруппировкаСпискаКОформлению = Настройки.Получить("ГруппировкаСпискаКОформлению");
	Если ГруппировкаСпискаКОформлению = Неопределено Тогда
		ГруппировкаСпискаКОформлению = Новый Структура;
	Иначе
		ЗаполнитьСписокСчетаФактурыКОформлению();
	КонецЕсли;
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		Настройки.Удалить("Организация");
		СтруктураБыстрогоОтбора.Свойство("Контрагент", Контрагент);
		Настройки.Удалить("Контрагент");
	Иначе
		Организация = Настройки.Получить("Организация");
		Контрагент  = Настройки.Получить("Контрагент");
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокСчетовФактурыНаОформление, 
		"Организация", Организация, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокСчетовФактурыНаОформление, 
		"Контрагент", Контрагент, СтруктураБыстрогоОтбора, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОформитьСчетФактуру(Команда)
	
	ВыделенныеСтроки = Элементы.СписокСчетовФактурыНаОформление.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Укажите документы-основания для формирования счета-фактуры.'"));
		Возврат;
	КонецЕсли;
	
	МассивСсылок = Новый Массив;
	ПерваяСтрока = Истина;
	РезультатПроверки = Новый Структура("Организация, Контрагент, Валюта, Исправление, Корректировка");
	
	РазныеОрганизации = Ложь;
	РазныеКонтрагенты = Ложь;
	РазныеВалюты      = Ложь;
	РазныеТипы        = Ложь;
	
	ЕстьГруппировка = ТипЗнч(ГруппировкаСпискаКОформлению) = Тип("Структура") 
		И ГруппировкаСпискаКОформлению.Количество() > 0;
	
	Для Каждого ДокументПродажи Из ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ДокументПродажи) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеСтроки = Элементы.СписокСчетовФактурыНаОформление.ДанныеСтроки(ДокументПродажи);
		
		Если ПерваяСтрока Тогда
			ПерваяСтрока = Ложь;
			ЗаполнитьЗначенияСвойств(РезультатПроверки, ДанныеСтроки);
		Иначе
			РазныеОрганизации = РазныеОрганизации Или РезультатПроверки.Организация <> ДанныеСтроки.Организация;
			РазныеКонтрагенты = РазныеКонтрагенты Или РезультатПроверки.Контрагент <> ДанныеСтроки.Контрагент;
			РазныеВалюты      = РазныеВалюты Или РезультатПроверки.Валюта <> ДанныеСтроки.Валюта;
			РазныеТипы        = РазныеТипы Или РезультатПроверки.Исправление <> ДанныеСтроки.Исправление
			                     Или РезультатПроверки.Корректировка <> ДанныеСтроки.Корректировка;
		КонецЕсли;
		
		Если ЕстьГруппировка Тогда
			
			ОтборыСписка = ПараметрыОтбораОснованийСчетаФактуры(ЭтаФорма);
			ЗаполнитьЗначенияСвойств(ОтборыСписка, ДанныеСтроки);
			СписокОснований = ПолучитьОснованияСчетаФактурыКОформлению(ОтборыСписка);
			
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивСсылок, СписокОснований.ВыгрузитьЗначения());
			
		Иначе
			МассивСсылок.Добавить(ДанныеСтроки.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	ОчиститьСообщения();
	
	Если РазныеОрганизации Или РазныеКонтрагенты Или РазныеВалюты Или РазныеТипы Тогда
		
		ТекстСообщения = НСтр("ru='Реквизиты документов, на основании которых регистрируется счет-фактура, не совпадают:'")
			+ ?(РазныеОрганизации, Символы.ПС + НСтр("ru='- организация'"), "")
			+ ?(РазныеКонтрагенты, Символы.ПС + НСтр("ru='- контрагент'"), "")
			+ ?(РазныеВалюты, Символы.ПС + НСтр("ru='- валюта документа'"), "")
			+ ?(РазныеТипы, Символы.ПС + НСтр("ru='- реквизиты ""Исправление"", ""Корректировка""'"), "") + Символы.ПС 
			+ НСтр("ru='Необходимо изменить реквизиты документов-оснований или зарегистрировать по документам с расхождениями отдельные счета-фактуры.'");
			
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
		
	КонецЕсли;
	
	СоздатьДокументыСчетФактура(МассивСсылок, ДанныеСтроки);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаЖурналПродажиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючНазначенияФормы", "СчетаФактурыВыданные");
	ОткрытьФорму("Обработка.ЖурналДокументовПродажи.Форма.СписокДокументов", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокСчетовФактурыНаОформление,
		"Организация",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно, ,
		ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокСчетовФактурыНаОформление,
		"Контрагент",
		Контрагент,
		ВидСравненияКомпоновкиДанных.Равно, ,
		ЗначениеЗаполнено(Контрагент));
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстГруппировкаСчетовФактурыНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ГруппировкаСпискаКОформлению", ГруппировкаСпискаКОформлению);
	
	Оповещение = Новый ОписаниеОповещения("ОбработкаНастройкиГруппировкиСчетовФактуры", ЭтотОбъект);
	
	ОткрытьФорму(
		"Документ.СчетФактураВыданный.Форма.НастройкиГруппировкиОснованийКОфомлению",
		СтруктураПараметров,
		ЭтаФорма, , , ,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСчетовФактурыНаОформлениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекДанные = Элемент.ТекущиеДанные;
	
	Если ТипЗнч(ГруппировкаСпискаКОформлению) = Тип("Структура") И ГруппировкаСпискаКОформлению.Количество() > 0 Тогда
		
		ОтборыСписка = ПараметрыОтбораОснованийСчетаФактуры(ЭтаФорма);
		ЗаполнитьЗначенияСвойств(ОтборыСписка, ТекДанные);
		
		СписокОснований = ПолучитьОснованияСчетаФактурыКОформлению(ОтборыСписка);
		Если СписокОснований.Количество() = 1 Тогда
			ПоказатьЗначение(, СписокОснований[0].Значение);
		Иначе
			
			ОткрытьФорму(
				"ОбщаяФорма.ПросмотрСпискаДокументов",
				Новый Структура("СписокДокументов, Заголовок",
					СписокОснований,
					НСтр("ru='Документы-основания счета-фактуры (%КоличествоДокументов%)'")
					),
				ЭтаФорма
				,,,,,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		КонецЕсли;

	Иначе
		
		ПоказатьЗначение(, ТекДанные.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.СчетФактураВыданный.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(,МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСчетовФактурыНаОформлениеСрок.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокСчетовФактурыНаОформление.Срок");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = Константы.СрокВыставленияСчетаФактуры.Получить();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныйДокумент);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.СписокДата.Имя);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиСтраницыСчетаФактурыКОформлению()
	
	НетГруппировки = ГруппировкаСпискаКОформлению = Неопределено Или ГруппировкаСпискаКОформлению.Количество()= 0;
	
	Элементы.СписокСчетовФактурыНаОформлениеНомер.Видимость                 = НетГруппировки;
	Элементы.СписокСчетовФактурыНаОформлениеВидОснования.Видимость          = НетГруппировки;
	Элементы.СписокСчетовФактурыНаОформлениеКоличествоДокументов.Видимость = Не НетГруппировки;
	
	ВидимостьЭлемента = НетГруппировки И Не ИспользоватьПартнеровКакКонтрагентов;
	Элементы.СписокСчетовФактурыНаОформлениеПартнер.Видимость = ВидимостьЭлемента;
	
	ВидимостьЭлемента = (НетГруппировки Или ГруппировкаСпискаКОформлению.Свойство("Договор"))
		И ИспользоватьДоговорыСКлиентами;
	Элементы.СписокСчетовФактурыНаОформлениеДоговор.Видимость = ВидимостьЭлемента;
	
	ВидимостьЭлемента = НетГруппировки Или ГруппировкаСпискаКОформлению.Свойство("Менеджер");
	Элементы.СписокСчетовФактурыНаОформлениеМенеджер.Видимость = ВидимостьЭлемента;
	
	ВидимостьЭлемента = НетГруппировки Или ГруппировкаСпискаКОформлению.Свойство("Месяц");
	Элементы.СписокСчетовФактурыНаОформлениеМесяц.Видимость = ВидимостьЭлемента;
	
	Элементы.СписокСчетовФактурыНаОформлениеОрганизация.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Элементы.СписокСчетовФактурыНаОформлениеВалюта.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	
	Если Не НетГруппировки Тогда
		Элементы.СписокСчетовФактурыНаОформлениеСсылка.Видимость = Ложь;
	КонецЕсли;
	
	ТекстГруппировкаСчетовФактуры = "";
	
	Если НетГруппировки Тогда
		ТекстГруппировкаСчетовФактуры = НСтр("ru='Настройка группировки документов-оснований'");
	Иначе
		
		ТекстГруппируемыхПолей = "";
		
		Для Каждого ПолеГруппировки Из ГруппировкаСпискаКОформлению Цикл
			ТекстГруппируемыхПолей = ТекстГруппируемыхПолей + ПолеГруппировки.Значение + ", ";
		КонецЦикла;
		
		ТекстГруппируемыхПолей = Лев(ТекстГруппируемыхПолей, СтрДлина(ТекстГруппируемыхПолей) - 2);
		
		ТекстГруппировкаСчетовФактуры = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Документы-основания сгруппированы по: %1'"), ТекстГруппируемыхПолей);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокСчетаФактурыКОформлению()
	
	УстановитьТекстЗапросаСчетаФактурыКОФормлению();
	
	УправлениеЭлементамиСтраницыСчетаФактурыКОформлению();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстЗапросаСчетаФактурыКОФормлению()
	
	ТекстЗапроса = ТекстЗапросаДанныхОснованийКОформлениюСчетФактур();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеКОформлению.Организация КАК Организация,
	|	ДанныеКОформлению.Контрагент КАК Контрагент,
	|	ДанныеКОформлению.Валюта КАК Валюта,
	|	ДанныеКОформлению.Договор КАК Договор,
	|	ДанныеКОформлению.Менеджер КАК Менеджер,
	|	ДанныеКОформлению.ДатаПродажи КАК ДатаПродажи,
	|	ДанныеКОформлению.Месяц КАК Месяц,
	|	ДанныеКОформлению.Исправление КАК Исправление,
	|	ДанныеКОформлению.Корректировка КАК Корректировка,
	|	ДанныеКОформлению.Действие КАК Действие,
	|	ДанныеКОформлению.Номер КАК Номер,
	|	ДанныеКОформлению.Ссылка КАК Ссылка,
	|	ДанныеКОформлению.ВидОснования КАК ВидОснования,
	|	ДанныеКОформлению.Партнер КАК Партнер,
	|	ДанныеКОформлению.Сумма КАК Сумма,
	|	ДанныеКОформлению.Срок КАК Срок,
	|	ДанныеКОформлению.КоличествоДокументов КАК КоличествоДокументов
	|ИЗ
	|	(" + ТекстЗапроса + ") КАК ДанныеКОформлению
	|
	|//ТекстГруппировки";
	
	Если ТипЗнч(ГруппировкаСпискаКОформлению) = Тип("Структура") И 
			ГруппировкаСпискаКОформлению.Количество() > 0 Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
			"ДанныеКОформлению.Сумма",
			"СУММА(ДанныеКОформлению.Сумма)");
			
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
			"ДанныеКОформлению.Срок",
			"МАКСИМУМ(ДанныеКОформлению.Срок)");
			
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
			"ДанныеКОформлению.КоличествоДокументов",
			"КОЛИЧЕСТВО(ДанныеКОформлению.КоличествоДокументов)");
		
		МассивПолейКУдалению = Новый Массив;
		МассивПолейКУдалению.Добавить("Номер");
		МассивПолейКУдалению.Добавить("Ссылка");
		МассивПолейКУдалению.Добавить("ВидОснования");
		МассивПолейКУдалению.Добавить("Партнер");
		
		Для Каждого Поле Из МассивПолейКУдалению Цикл
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
			"ДанныеКОформлению." + Поле,
			"НЕОПРЕДЕЛЕНО");
		КонецЦикла;
		
		ПоляВозможнойСвертки = Новый Массив;
		ПоляВозможнойСвертки.Добавить("ДатаПродажи");
		ПоляВозможнойСвертки.Добавить("Договор");
		ПоляВозможнойСвертки.Добавить("Менеджер");
		ПоляВозможнойСвертки.Добавить("Месяц");
		
		ТекстДополнительныхПолейГруппировки = "";
		
		Для Каждого ПолеСвертки Из ПоляВозможнойСвертки Цикл
			
			ПутьКПолю = "ДанныеКОформлению." + ПолеСвертки;
			
			Если ГруппировкаСпискаКОформлению.Свойство(ПолеСвертки) Тогда
				ТекстДополнительныхПолейГруппировки = ТекстДополнительныхПолейГруппировки + "
				|	" + ПутьКПолю + ",";
			Иначе
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ПутьКПолю,
					?(ПолеСвертки = "ДатаПродажи", "МАКСИМУМ(ДанныеКОформлению.ДатаПродажи)", "НЕОПРЕДЕЛЕНО"));
			КонецЕсли;
			
		КонецЦикла;
		
		ТекстГруппировки = 
		"СГРУППИРОВАТЬ ПО
		|	ДанныеКОформлению.Организация,
		|	ДанныеКОформлению.Контрагент,
		|	ДанныеКОформлению.Исправление,
		|	ДанныеКОформлению.Корректировка,
		|	ДанныеКОформлению.Действие,
		|	%1
		|	ДанныеКОформлению.Валюта";
		
		ТекстГруппировки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстГруппировки, ТекстДополнительныхПолейГруппировки);
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ТекстГруппировки", ТекстГруппировки);
		
		СписокСчетовФактурыНаОформление.Порядок.Элементы.Очистить();
		
		КомпоновщикНастроек = СписокСчетовФактурыНаОформление.КомпоновщикНастроек;
		ИдентификаторПорядка = КомпоновщикНастроек.Настройки.Порядок.ИдентификаторПользовательскойНастройки;
		ПользовательскийПорядок = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ИдентификаторПорядка);
		Если ПользовательскийПорядок <> Неопределено Тогда
			ПользовательскийПорядок.Элементы.Очистить();
		КонецЕсли;
		
	КонецЕсли;
	
	СписокСчетовФактурыНаОформление.ТекстЗапроса = ТекстЗапроса;
	
КонецПроцедуры

&НаСервере
Функция ТекстЗапросаДанныхОснованийКОформлениюСчетФактур(Разрешенные=Ложь)
	
	ШаблонЗапроса = "
	|
	|ВЫБРАТЬ %Разрешенные%
	|	ТребуетсяОформлениеСчетаФактуры.Организация КАК Организация,
	|	ТребуетсяОформлениеСчетаФактуры.Контрагент КАК Контрагент,
	|	НАЧАЛОПЕРИОДА(ДанныеОснования.Дата, ДЕНЬ) КАК ДатаПродажи,
	|	НАЧАЛОПЕРИОДА(ДанныеОснования.Дата, МЕСЯЦ) КАК Месяц,
	|	ДанныеОснования.Номер КАК Номер,
	|	ДанныеОснования.Ссылка КАК Ссылка,
	|	ТИПЗНАЧЕНИЯ(ДанныеОснования.Ссылка) КАК ВидОснования,
	|	ДанныеОснования.Партнер КАК Партнер,
	|	ДанныеОснования.Договор КАК Договор,
	|	ДанныеОснования.Менеджер КАК Менеджер,
	|	ДанныеОснования.СуммаДокумента КАК Сумма,
	|	РАЗНОСТЬДАТ(НАЧАЛОПЕРИОДА(ДанныеОснования.Дата, ДЕНЬ), &НачалоТекущегоДня, ДЕНЬ) КАК Срок,
	|	ЛОЖЬ КАК Исправление,
	|	ЛОЖЬ КАК Корректировка,
	|	&ТекстНовыйСчетФактура КАК Действие,
	|	1 КАК КоличествоДокументов,
	|	ТребуетсяОформлениеСчетаФактуры.Валюта КАК Валюта
	|ИЗ
	|	РегистрСведений.ТребуетсяОформлениеСчетаФактуры КАК ТребуетсяОформлениеСчетаФактуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.%ИмяДокумента% КАК ДанныеОснования
	|		ПО ТребуетсяОформлениеСчетаФактуры.Основание = ДанныеОснования.Ссылка
	|{ГДЕ
	|	ТребуетсяОформлениеСчетаФактуры.Организация.* КАК Организация,
	|	ТребуетсяОформлениеСчетаФактуры.Контрагент.* КАК Контрагент,
	|	ТребуетсяОформлениеСчетаФактуры.Валюта.* КАК Валюта,
	|	НАЧАЛОПЕРИОДА(ДанныеОснования.Дата, ДЕНЬ) КАК ДатаПродажи,
	|	НАЧАЛОПЕРИОДА(ДанныеОснования.Дата, МЕСЯЦ) КАК Месяц,
	|	ДанныеОснования.Договор.* КАК Договор,
	|	ДанныеОснования.Менеджер.* КАК Менеджер,
	|	ЛОЖЬ КАК Исправление,
	|	ЛОЖЬ КАК Корректировка}
	|";
	
	ШаблонЗапросаЗаписьКнигиПродаж = "
	|
	|ВЫБРАТЬ %Разрешенные%
	|	ТребуетсяОформлениеСчетаФактуры.Организация КАК Организация,
	|	ТребуетсяОформлениеСчетаФактуры.Контрагент КАК Контрагент,
	|	НАЧАЛОПЕРИОДА(ДанныеОснования.Дата, ДЕНЬ) КАК ДатаПродажи,
	|	НАЧАЛОПЕРИОДА(ДанныеОснования.Дата, МЕСЯЦ) КАК Месяц,
	|	ДанныеОснования.Номер КАК Номер,
	|	ДанныеОснования.Ссылка КАК Ссылка,
	|	ТИПЗНАЧЕНИЯ(ДанныеОснования.Ссылка) КАК ВидОснования,
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Менеджер,
	|	ДанныеОснования.СуммаДокумента КАК Сумма,
	|	РАЗНОСТЬДАТ(НАЧАЛОПЕРИОДА(ДанныеОснования.Дата, ДЕНЬ), &НачалоТекущегоДня, ДЕНЬ) КАК Срок,
	|	ЛОЖЬ КАК Исправление,
	|	ЛОЖЬ КАК Корректировка,
	|	&ТекстНовыйСчетФактура КАК Действие,
	|	1 КАК КоличествоДокументов,
	|	ТребуетсяОформлениеСчетаФактуры.Валюта КАК Валюта
	|ИЗ
	|	РегистрСведений.ТребуетсяОформлениеСчетаФактуры КАК ТребуетсяОформлениеСчетаФактуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаписьКнигиПродаж КАК ДанныеОснования
	|		ПО ТребуетсяОформлениеСчетаФактуры.Основание = ДанныеОснования.Ссылка
	|{ГДЕ
	|	ТребуетсяОформлениеСчетаФактуры.Организация.* КАК Организация,
	|	ТребуетсяОформлениеСчетаФактуры.Контрагент.* КАК Контрагент,
	|	ТребуетсяОформлениеСчетаФактуры.Валюта.* КАК Валюта,
	|	НАЧАЛОПЕРИОДА(ДанныеОснования.Дата, ДЕНЬ) КАК ДатаПродажи,
	|	НАЧАЛОПЕРИОДА(ДанныеОснования.Дата, МЕСЯЦ) КАК Месяц,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Менеджер,
	|	ЛОЖЬ КАК Исправление,
	|	ЛОЖЬ КАК Корректировка}
	|";	
	МассивТипов = ТипыДокументовОснованийКОформлению();
	
	ТекстЗапроса = "";
	
	Для Каждого ИмяТипа Из МассивТипов Цикл
		
		Если Не ПравоДоступа("Чтение", Метаданные.Документы[ИмяТипа]) Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстЗапросаДляТипа = СтрЗаменить(ШаблонЗапроса, "%ИмяДокумента%", ИмяТипа);
		Если ИмяТипа = "КорректировкаРеализации" Тогда
			ТекстЗапросаДляТипа = СтрЗаменить(ТекстЗапросаДляТипа, "ЛОЖЬ КАК Исправление",
				"ВЫБОР
				|	КОГДА ДанныеОснования.ВидКорректировки = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИсправлениеОшибок) ТОГДА
				|		ИСТИНА
				|	ИНАЧЕ ЛОЖЬ 
				|КОНЕЦ КАК Исправление");
			ТекстЗапросаДляТипа = СтрЗаменить(ТекстЗапросаДляТипа, "ЛОЖЬ КАК Корректировка",
				"ВЫБОР
				|	КОГДА ДанныеОснования.ВидКорректировки = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КорректировкаПоСогласованиюСторон) ТОГДА
				|		ИСТИНА
				|	ИНАЧЕ ЛОЖЬ 
				|КОНЕЦ КАК Корректировка");
			ТекстЗапросаДляТипа = СтрЗаменить(ТекстЗапросаДляТипа, "&ТекстНовыйСчетФактура",
				"ВЫБОР
				|	КОГДА ДанныеОснования.ВидКорректировки = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИсправлениеОшибок)
				|		ТОГДА &ТекстИправлениеСчетФактуры
				|	КОГДА ДанныеОснования.ВидКорректировки = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КорректировкаПоСогласованиюСторон)
				|		ТОГДА &ТекстКорректировкаСчетФактуры
				|	ИНАЧЕ &ТекстНовыйСчетФактура
				|КОНЕЦ");
		ИначеЕсли ИмяТипа = "ЗаписьКнигиПродаж" Тогда
			ТекстЗапросаДляТипа = ШаблонЗапросаЗаписьКнигиПродаж;
		КонецЕсли;
		
		Если Разрешенные Тогда
			ТекстЗапросаДляТипа = СтрЗаменить(ТекстЗапросаДляТипа, "%Разрешенные%", "РАЗРЕШЕННЫЕ");
			Разрешенные = Ложь;
		Иначе
			ТекстЗапросаДляТипа = СтрЗаменить(ТекстЗапросаДляТипа, "%Разрешенные%", "");
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса + "
			|ОБЪЕДИНИТЬ ВСЕ" + ТекстЗапросаДляТипа;
		
	КонецЦикла;
	
	ТекстЗапроса = Сред(ТекстЗапроса, 16);
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаНастройкиГруппировкиСчетовФактуры(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		ГруппировкаСпискаКОформлению = Результат;
		ЗаполнитьСписокСчетаФактурыКОформлению();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументыСчетФактура(Основания, ДополнительныеПараметры)
	
	СтруктураЗаполнения = Новый Структура;
	Если Основания.Количество() = 1 Тогда
		СтруктураЗаполнения.Вставить("ДокументОснование", Основания[0]);
	Иначе
		СтруктураЗаполнения.Вставить("ДокументОснование", Основания);
		СтруктураЗаполнения.Вставить("Дата", ДополнительныеПараметры.ДатаПродажи);
	КонецЕсли;
	
	СтруктураЗаполнения.Вставить("Корректировочный", ДополнительныеПараметры.Корректировка);
	СтруктураЗаполнения.Вставить("Исправление",      ДополнительныеПараметры.Исправление);
	
	ПараметрыФормы = Новый Структура("Основание", СтруктураЗаполнения);
	
	ОткрытьФорму("Документ.СчетФактураВыданный.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОснованияСчетаФактурыКОформлению(ОтборыСписка)
	
	ТекстЗапроса = ТекстЗапросаДанныхОснованийКОформлениюСчетФактур(Истина);
	
	Запрос = Новый ПостроительЗапроса(ТекстЗапроса);
	ПараметрыЗапроса = ПараметрыЗапросаСчетаФактурыКОформлению();
	Для Каждого ТекПараметр Из ПараметрыЗапроса Цикл
		Запрос.Параметры.Вставить(ТекПараметр.Ключ, ТекПараметр.Значение);
	КонецЦикла;
	
	Для Каждого ТекОтбор Из ОтборыСписка Цикл
		ЭлОтбора = Запрос.Отбор.Добавить(ТекОтбор.Ключ);
		ЭлОтбора.Установить(ТекОтбор.Значение);
	КонецЦикла;
	
	Запрос.Выполнить();
	Результат = Запрос.Результат.Выгрузить();
	
	СписокВозврат = Новый СписокЗначений;
	СписокВозврат.ЗагрузитьЗначения(Результат.ВыгрузитьКолонку("Ссылка"));
	
	Возврат СписокВозврат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыОтбораОснованийСчетаФактуры(Форма)
	
	СтруктураОтбора = Новый Структура("Организация, Контрагент, Валюта, Исправление, Корректировка");
	Для Каждого ПолеГруппировки Из Форма.ГруппировкаСпискаКОформлению Цикл
		СтруктураОтбора.Вставить(ПолеГруппировки.Ключ);
	КонецЦикла;
	
	Возврат СтруктураОтбора;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТипыДокументовОснованийКОформлению()
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить("АктВыполненныхРабот");
	МассивТипов.Добавить("ВозвратТоваровПоставщику");
	МассивТипов.Добавить("ВыкупВозвратнойТарыКлиентом");
	МассивТипов.Добавить("КорректировкаРеализации");
	МассивТипов.Добавить("ОтчетКомитенту");
	МассивТипов.Добавить("ОтчетКомиссионера");
	МассивТипов.Добавить("РеализацияТоваровУслуг");
	МассивТипов.Добавить("РеализацияУслугПрочихАктивов");
	МассивТипов.Добавить("ПередачаТоваровМеждуОрганизациями");
	МассивТипов.Добавить("ВозвратТоваровМеждуОрганизациями");
	МассивТипов.Добавить("ОтчетПоКомиссииМеждуОрганизациями");
	МассивТипов.Добавить("ЗаписьКнигиПродаж");
	
	Возврат МассивТипов;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПараметрыЗапросаСчетаФактурыКОформлению()
	
	Параметры = Новый Структура;
	Параметры.Вставить("НачалоТекущегоДня", НачалоДня(ТекущаяДатаСеанса()));
	Параметры.Вставить("ТекстНовыйСчетФактура", НСтр("ru = 'Новый'"));
	Параметры.Вставить("ТекстИправлениеСчетФактуры", НСтр("ru = 'Исправительный'"));
	Параметры.Вставить("ТекстКорректировкаСчетФактуры", НСтр("ru = 'Корректировочный'"));
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

#КонецОбласти
