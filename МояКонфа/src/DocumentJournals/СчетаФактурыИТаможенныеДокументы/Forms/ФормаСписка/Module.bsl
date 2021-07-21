
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
		Возврат;
	КонецЕсли;
	
	УстановитьЗначенияПоПараметрамФормы(Параметры);
	
	УстановитьПараметрыСписка("Входящие");
	УстановитьПараметрыСписка("Исходящие");
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(
		СписокВходящие,
		"Организация",
		Организация,
		СтруктураБыстрогоОтбора);
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(
		СписокВходящие,
		"Тип",
		ТипыВходящие,
		СтруктураБыстрогоОтбора,
		ТипыВходящие.Количество() > 0,
		ВидСравненияКомпоновкиДанных.ВСписке);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(
		СписокВходящие, 
		"Организация", 
		Организация, 
		СтруктураБыстрогоОтбора, 
		Настройки);
		
	Если Настройки["Тип"] <> Неопределено Тогда
		ИспользованиеЭлементаОтбора = Настройки["Тип"].Количество() > 0;
	КонецЕсли;
		
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(
		СписокВходящие, 
		"Тип", 
		ТипыВходящие, 
		СтруктураБыстрогоОтбора, 
		Настройки,
		ИспользованиеЭлементаОтбора,
		ВидСравненияКомпоновкиДанных.ВСписке);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ФормаОтметкиЭлементов" Тогда
		ВыполнитьПослеЗакрытияСпискаВыбора(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		Организация = ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(СписокВходящие, ,Параметр);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериодВходящие(Команда)
	
	ВыбратьПериод("Входящие");
	
КонецПроцедуры
	
&НаКлиенте
Процедура ВыбратьПериодИсходящие(Команда)
	
	ВыбратьПериод("Исходящие");
	
КонецПроцедуры
	
&НаКлиенте
Процедура ВыбратьПериод(Суффикс)
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Суффикс", Суффикс);
	
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", 
										ЭтаФорма["НачалоПериода" + Суффикс], 
										ЭтаФорма["КонецПериода" + Суффикс]);
											
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект, ДопПараметры);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", 
					ПараметрыВыбора, 
					Элементы["ВыбратьПериод" + Суффикс]
					, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтаФорма["НачалоПериода" + ДопПараметры.Суффикс] = РезультатВыбора.НачалоПериода;
	ЭтаФорма["КонецПериода" + ДопПараметры.Суффикс] = РезультатВыбора.КонецПериода;
	УстановитьПараметрыСписка(ДопПараметры.Суффикс);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВходящиеПриАктивизацииСтроки(Элемент)
	
	
	Возврат; // Для УТ не требуется
	
КонецПроцедуры

&НаКлиенте
Процедура СписокИсходящиеПриАктивизацииСтроки(Элемент)
	
	
	Возврат; // Для УТ не требуется
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(СписокВходящие, "Организация", Организация, ЗначениеЗаполнено(Организация));
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(СписокИсходящие, "Организация", Организация, ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоТипуДокументаВходящиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОтборПоТипуДокументаНачалоВыбора("Входящие", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоТипуДокументаИсходящиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОтборПоТипуДокументаНачалоВыбора("Исходящие", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоТипуДокументаВходящиеОчистка(Элемент, СтандартнаяОбработка)
	
	ОтборПоТипуДокументаОчистка("Входящие");
	
КонецПроцедуры
	
&НаКлиенте
Процедура ОтборПоТипуДокументаИсходящиеОчистка(Элемент, СтандартнаяОбработка)
	
	ОтборПоТипуДокументаОчистка("Исходящие");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоТипуДокументаНачалоВыбора(Суффикс, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокВыбора = ПолучитьЗначенияСписка(Суффикс);
	Для каждого ЭлементСписка Из ЭтаФорма["Типы" + Суффикс] Цикл
		НайденноеЗначение = СписокВыбора.НайтиПоЗначению(ЭлементСписка.Значение);
		НайденноеЗначение.Пометка = (НайденноеЗначение <> Неопределено);
	КонецЦикла;
	СписокВыбора.СортироватьПоПредставлению();
	
	ОткрытьФорму("ОбщаяФорма.ФормаОтметкиЭлементов", Новый Структура("СписокЗначений", СписокВыбора), ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоТипуДокументаОчистка(Суффикс)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЭтаФорма["Список" + Суффикс],
		"Тип",
		ЭтаФорма["Типы" + Суффикс],
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаВходящиеПриИзменении(Элемент)
	
	НачалоПериодаПриИзменении("Входящие");
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаВходящиеПриИзменении(Элемент)
	
	КонецПериодаПриИзменении("Входящие");
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаИсходящиеПриИзменении(Элемент)
	
	НачалоПериодаПриИзменении("Исходящие");
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаИсходящиеПриИзменении(Элемент)
	
	КонецПериодаПриИзменении("Исходящие");
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Суффикс)
	
	НачалоПериода = ЭтаФорма["НачалоПериода" + Суффикс];
	КонецПериода  = ЭтаФорма["КонецПериода" + Суффикс];
	
	Если ЗначениеЗаполнено(НачалоПериода)
		И ЗначениеЗаполнено(КонецПериода)
		И НачалоПериода > КонецПериода Тогда
		ЭтаФорма["НачалоПериода" + Суффикс] = КонецПериода;
	КонецЕсли;
	УстановитьПараметрыСписка(Суффикс);
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Суффикс)
	
	НачалоПериода = ЭтаФорма["НачалоПериода" + Суффикс];
	КонецПериода  = ЭтаФорма["КонецПериода" + Суффикс];
	
	Если ЗначениеЗаполнено(НачалоПериода)
		И ЗначениеЗаполнено(КонецПериода)
		И КонецПериода < НачалоПериода Тогда
		ЭтаФорма["КонецПериода" + Суффикс] = НачалоПериода;
	КонецЕсли;
	УстановитьПараметрыСписка(Суффикс);
	
КонецПроцедуры

&НаКлиенте
Процедура ПомощникПоУчетуНДСНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВходящие Тогда
		НачалоПериода = НачалоПериодаВходящие;
		КонецПериода = КонецПериодаВходящие;
	Иначе
		НачалоПериода = НачалоПериодаИсходящие;
		КонецПериода = КонецПериодаИсходящие;
	КонецЕсли;
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	ПараметрыФормы.Вставить("НачалоПериода", ?(ЗначениеЗаполнено(НачалоПериода), НачалоПериода, ТекущаяДата));
	ПараметрыФормы.Вставить("КонецПериода", ?(ЗначениеЗаполнено(КонецПериода), КонецПериода, ТекущаяДата));
	
	ПараметрыФормы.Вставить("Организация", ЭтаФорма.Организация);
	ПараметрыФормы.Вставить("ТолькоОформлениеДокументов", Истина);
	
	ОткрытьФорму("Обработка.ПомощникПоУчетуНДС.Форма.Форма", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьПослеЗакрытияСпискаВыбора(СписокВыбора)
	
	Если СписокВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Суффикс = "Входящие";
	СписокОтбора = ПолучитьЗначенияСписка(Суффикс);
		
	Для каждого ЭлементСписка Из СписокВыбора Цикл
		
		НайденноеЗначение = СписокОтбора.НайтиПоЗначению(ЭлементСписка.Значение);
		Если НайденноеЗначение = Неопределено Тогда
			Суффикс = "Исходящие";
			СписокОтбора = ПолучитьЗначенияСписка(Суффикс);
			НайденноеЗначение = СписокОтбора.НайтиПоЗначению(ЭлементСписка.Значение);
		КонецЕсли;
		
		Если Не ЭлементСписка.Пометка Тогда
			СписокОтбора.Удалить(НайденноеЗначение);
		КонецЕсли;
		
	КонецЦикла;
	
	ЭтаФорма["Типы" + Суффикс] = СписокОтбора;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЭтаФорма["Список" + Суффикс],
		"Тип",
		СписокОтбора,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		СписокОтбора.Количество() > 0);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьЗначенияСписка(Суффикс)
	
	СписокВыбора = Новый СписокЗначений();
	
	Если Суффикс = "Входящие" Тогда
		СписокВыбора.Добавить(Тип("ДокументСсылка.СчетФактураПолученный"));
		СписокВыбора.Добавить(Тип("ДокументСсылка.СчетФактураПолученныйАванс"));
		СписокВыбора.Добавить(Тип("ДокументСсылка.СчетФактураКомитента"));
		СписокВыбора.Добавить(Тип("ДокументСсылка.ТаможеннаяДекларацияИмпорт"));
	Иначе
		СписокВыбора.Добавить(Тип("ДокументСсылка.СчетФактураВыданный"));
		СписокВыбора.Добавить(Тип("ДокументСсылка.СчетФактураВыданныйАванс"));
		СписокВыбора.Добавить(Тип("ДокументСсылка.СчетФактураКомиссионеру"));
		СписокВыбора.Добавить(Тип("ДокументСсылка.СчетФактураНалоговыйАгент"));
		СписокВыбора.Добавить(Тип("ДокументСсылка.ЗаявлениеОВвозеТоваров"));
		СписокВыбора.Добавить(Тип("ДокументСсылка.СчетФактураНаНеподтвержденнуюРеализацию0"));
	КонецЕсли;
	
	Возврат СписокВыбора;
	
КонецФункции

&НаСервере
Процедура УстановитьЗначенияПоПараметрамФормы(Параметры)
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("Тип", ТипыВходящие);
		СтруктураБыстрогоОтбора.Свойство("ВидДокумента", ВидДокумента);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыСписка(Суффикс)
	
	Список = ЭтаФорма["Список" + Суффикс];
	НачалоПериода = ЭтаФорма["НачалоПериода" + Суффикс];
	КонецПериода = ЭтаФорма["КонецПериода" + Суффикс];
	
	Список.Параметры.УстановитьЗначениеПараметра("НачалоПериода", НачалоПериода);
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериода", 
					?(ЗначениеЗаполнено(КонецПериода), КонецДня(КонецПериода), КонецПериода));
	
	Если Суффикс = "Исходящие" Тогда
		Список.ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СчетаФактурыИТаможенныеДокументы.Ссылка,
		|	ВЫБОР
		|		КОГДА ИсходныйСчетФактура.Ссылка ЕСТЬ NULL 
		|			ТОГДА СчетаФактурыИТаможенныеДокументы.Номер
		|		ИНАЧЕ ИсходныйСчетФактура.Номер
		|	КОНЕЦ КАК Номер,
		|	ВЫБОР
		|		КОГДА ИсходныйСчетФактура.Ссылка ЕСТЬ NULL 
		|			ТОГДА СчетаФактурыИТаможенныеДокументы.Дата
		|		ИНАЧЕ ИсходныйСчетФактура.Дата
		|	КОНЕЦ КАК Дата,
		|	СчетаФактурыИТаможенныеДокументы.НомерИсправления,
		|	ВЫБОР
		|		КОГДА ИсходныйСчетФактура.Ссылка ЕСТЬ NULL 
		|			ТОГДА """"
		|		ИНАЧЕ СчетаФактурыИТаможенныеДокументы.Дата
		|	КОНЕЦ КАК ДатаИсправления,
		|	СчетаФактурыИТаможенныеДокументы.Тип,
		|	СчетаФактурыИТаможенныеДокументы.Организация,
		|	СчетаФактурыИТаможенныеДокументы.Контрагент,
		|	СчетаФактурыИТаможенныеДокументы.ДокументОснование,
		|	СчетаФактурыИТаможенныеДокументы.Комментарий
		|ИЗ
		|	ЖурналДокументов.СчетаФактурыИТаможенныеДокументы КАК СчетаФактурыИТаможенныеДокументы
		|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный КАК ИсходныйСчетФактура
		|			ПО СчетаФактурыИТаможенныеДокументы.Исправление
		|				И ИсходныйСчетФактура.Ссылка = СчетаФактурыИТаможенныеДокументы.СчетФактураОснование	
		|ГДЕ
		|	СчетаФактурыИТаможенныеДокументы.Тип В (
		|		ТИП(Документ.СчетФактураВыданный),
		|		ТИП(Документ.СчетФактураВыданныйАванс),
		|		ТИП(Документ.СчетФактураКомиссионеру),
		|		ТИП(Документ.СчетФактураНалоговыйАгент),
		|		ТИП(Документ.ЗаявлениеОВвозеТоваров),
		|		ТИП(Документ.СчетФактураНаНеподтвержденнуюРеализацию0))
		|	И (СчетаФактурыИТаможенныеДокументы.Дата МЕЖДУ &НачалоПериода И &КонецПериода
		|			ИЛИ &КонецПериода = ДАТАВРЕМЯ(1, 1, 1)
		|				И СчетаФактурыИТаможенныеДокументы.Дата >= &НачалоПериода)";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
