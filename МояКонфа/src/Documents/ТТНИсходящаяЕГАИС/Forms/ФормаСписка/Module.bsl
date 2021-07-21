
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Грузоотправитель", Грузоотправитель, СтруктураБыстрогоОтбора);
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ТТНИсходящаяЕГАИС" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И ТипЗнч(Параметр.Ссылка) = Тип("ДокументСсылка.ТТНИсходящаяЕГАИС") Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусЕГАИСВФормахДокументов)) Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "Грузоотправитель",
	                                                                       Грузоотправитель,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "Ответственный",
	                                                                       Ответственный,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияЕГАИСОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Грузоотправитель",
	                                                                        Грузоотправитель,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Грузоотправитель));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Ответственный",
	                                                                        Ответственный,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Ответственный));
	
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
Процедура ПередатьДанные(Команда)
	
	НачатьВыгрузкуДокумента(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ТТН"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьАктОРасхождениях(Команда)
	
	НачатьВыгрузкуДокумента(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ПодтверждениеАктаРасхожденийТТН"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтказатьсяОтАктаРасхождений(Команда)
	
	НачатьВыгрузкуДокумента(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ОтказОтАктаРасхожденийТТН"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияЕГАИСКлиент.ВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
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

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НачатьВыгрузкуДокумента(ВидДокумента)
	
	ОчиститьСообщения();
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыЗапроса = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(ВидДокумента);
	ПараметрыЗапроса.ДокументСсылка = Элементы.Список.ТекущиеДанные.Ссылка;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПослеПередачиДанныхЕГАИС", ИнтеграцияЕГАИСКлиент);
	ИнтеграцияЕГАИСКлиент.НачатьФормированиеИсходящегоЗапроса(
		ОповещениеПриЗавершении,
		ВидДокумента,
		ПараметрыЗапроса);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	СписокОшибочныхСтатусов = Новый СписокЗначений;
	СписокОшибочныхСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиВЕГАИС);
	СписокОшибочныхСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиОтказаОтАктаРасхождений);
	СписокОшибочныхСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиПодтвержденияАктаРасхождений);
	СписокОшибочныхСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиАктаОтказа);
	СписокОшибочныхСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиПодтвержденияЗапросаНаОтменуПроведения);
	СписокОшибочныхСтатусов.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиОтказаОтЗапросаНаОтменуПроведения);
	
	СписокСтатусовПередается = Новый СписокЗначений;
	СписокСтатусовПередается.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПередаетсяВЕГАИС);
	СписокСтатусовПередается.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПередаетсяОтказОтАктаРасхождений);
	СписокСтатусовПередается.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПередаетсяПодтверждениеАктаРасхождений);
	СписокСтатусовПередается.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПередаетсяАктОтказа);
	СписокСтатусовПередается.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПередаетсяПодтверждениеЗапросаНаОтменуПроведения);
	СписокСтатусовПередается.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПередаетсяОтказОтЗапросаНаОтменуПроведения);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусОбработки.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных(Элементы.СтатусОбработки.ПутьКДанным);
	ОтборЭлемента.ВидСравнения    = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение  = СписокОшибочныхСтатусов;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЕГАИССтатусОбработкиОшибкаПередачи);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусОбработки.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение   = Новый ПолеКомпоновкиДанных(Элементы.СтатусОбработки.ПутьКДанным);
	ОтборЭлемента.ВидСравнения    = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение  = СписокСтатусовПередается;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЕГАИССтатусОбработкиПередается);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");

КонецПроцедуры

#КонецОбласти