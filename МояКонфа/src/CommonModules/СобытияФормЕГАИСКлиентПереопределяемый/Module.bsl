
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийФормы

// Возникает на клиенте перед выполнением записи объекта из формы.
//
// Параметры:
//  Форма - УправляемаяФорма - форма записываемого объекта,
//  Отказ - Булево - признак отказа от записи,
//  ПараметрыЗаписи - Структура - структура, содержащая параметры записи.
//
Процедура ПередЗаписью(Форма, Отказ, ПараметрыЗаписи) Экспорт
	
	//++ НЕ ЕГАИС
	Если ИнтеграцияЕГАИСКлиентСервер.ЕстьРеквизитОбъекта(Форма, "Объект") Тогда
		
		Если ИнтеграцияЕГАИСКлиентСервер.ЕстьРеквизитОбъекта(ПараметрыЗаписи, "РежимЗаписи") Тогда
			
			СобытияФормКлиент.ПередЗаписью(Форма, Отказ, ПараметрыЗаписи);
			
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Вызывается во всех созданных формах при вызове метода Оповестить.
//
// Параметры:
//  Форма - УправляемаяФорма - оповещаемая форма,
//  ИмяСобытия - Строка - имя события,
//  Параметр - Произвольный - параметр сообщения. Могут быть переданы любые необходимые данные,
//  Источник - Произвольный - источник события.
//
Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	//++ НЕ ЕГАИС
	СобытияФормКлиент.ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник);
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

// Обработчик переопределяемой команды формы.
//
// Параметры:
//  Форма - УправляемаяФорма - форма объекта справочника или документа,
//  Команда - КомандаФормы - команда формы.
//
Процедура ВыполнитьПереопределяемуюКоманду(Форма, Команда) Экспорт
	
	//++ НЕ ЕГАИС
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(Форма, Команда);
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Открывает форму сопоставления номенклатуры с классификатором ЕГАИС.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой вызывается команда открытия обработки сопоставления,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы сопоставления,
//  ПараметрыОткрытияФормы - Структура - параметры, передаваемые в форму сопоставления.
//
Процедура ОткрытьФормуСопоставленияНоменклатурыСАлкогольнойПродукцией(Форма, ОповещениеПриЗавершении = Неопределено, ПараметрыОткрытияФормы = Неопределено) Экспорт
	
	//++ НЕ ЕГАИС
	Если ПараметрыОткрытияФормы = Неопределено Тогда
		ПараметрыОткрытияФормы = Новый Структура;
	КонецЕсли;
	
	ОткрытьФорму(
		"Обработка.СопоставлениеКлассификаторовЕГАИС.Форма.СопоставлениеНоменклатурыСАлкогольнойПродукциейЕГАИС",
		ПараметрыОткрытияФормы,
		Форма,
		Форма.УникальныйИдентификатор,,,
		ОповещениеПриЗавершении);
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Открывает форму сопоставления классификатора ЕГАИС с номенклатурой.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой вызывается команда открытия обработки сопоставления,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы сопоставления,
//  ПараметрыОткрытияФормы - Структура - параметры, передаваемые в форму сопоставления.
//
Процедура ОткрытьФормуСопоставленияАлкогольнойПродукцииСНоменклатурой(Форма, ОповещениеПриЗавершении = Неопределено, ПараметрыОткрытияФормы = Неопределено) Экспорт
	
	//++ НЕ ЕГАИС
	Если ПараметрыОткрытияФормы = Неопределено Тогда
		ПараметрыОткрытияФормы = Новый Структура;
	КонецЕсли;
	
	ОткрытьФорму(
		"Обработка.СопоставлениеКлассификаторовЕГАИС.Форма.СопоставлениеАлкогольнойПродукцииЕГАИСНоменклатурой",
		ПараметрыОткрытияФормы,
		Форма,
		Форма.УникальныйИдентификатор,,,
		ОповещениеПриЗавершении);
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Открывает форму подбора номенклатуры.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой вызывается команда открытия обработки сопоставления,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы подбора.
//
Процедура ОткрытьФормуПодбораНоменклатуры(Форма, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	//++ НЕ ЕГАИС
	ПараметрЗаголовок = НСтр("ru = 'Подбор товаров в %Документ%'");
	Если ЗначениеЗаполнено(Форма.Объект.Ссылка) Тогда
		ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", Форма.Объект.Ссылка);
	Иначе
		Если ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.АктПостановкиНаБалансЕГАИС") Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='Акт постановки на баланс ЕГАИС'"));
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.АктСписанияЕГАИС") Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='Акт списания ЕГАИС'"));
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.ВозвратИзРегистра2ЕГАИС") Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='Возврат из регистра №2 ЕГАИС'"));
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.ПередачаВРегистр2ЕГАИС") Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='Передача в регистр №2 ЕГАИС'"));
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.ЧекЕГАИС") Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='Чек ЕГАИС'"));
		ИначеЕсли ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.ЧекЕГАИСВозврат") Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='Чек ЕГАИС на возврат'"));
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОсобенностьУчета",                        ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция"));
	ПараметрыФормы.Вставить("РежимПодбораБезКоличественныхПараметров", Истина);
	ПараметрыФормы.Вставить("РежимПодбораБезСуммовыхПараметров",       Истина);
	ПараметрыФормы.Вставить("СкрыватьКолонкуВидЦены",                  Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуЦеныНоменклатуры",         Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуОстаткиНаСкладах",         Истина);
	ПараметрыФормы.Вставить("СкрыватьКнопкуЗапрашиватьКоличество",     Истина);
	ПараметрыФормы.Вставить("Заголовок",                               ПараметрЗаголовок);
	ПараметрыФормы.Вставить("Дата",                                    Форма.Объект.Дата);
	ПараметрыФормы.Вставить("Документ",                                Форма.Объект.Ссылка);
	ПараметрыФормы.Вставить("СкрыватьКолонкуВидЦены",                  Истина);
	
	ОткрытьФорму(
		"Обработка.ПодборТоваровВДокументПродажи.Форма",
		ПараметрыФормы,
		Форма,
		Форма.УникальныйИдентификатор,,,
		ОповещениеПриЗавершении);
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Открывает форму выбора документа перемещения товаров.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой вызывается команда выбора документа,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы выбора,
//  Отбор - Структура - значения реквизитов, по которым нужно отобрать выбираемое перемещение товаров.
//
Процедура ОткрытьФормуВыбораДокументаПеремещениеТоваров(Форма, ОповещениеПриЗавершении, Отбор = Неопределено) Экспорт
	
	//++ НЕ ЕГАИС
	Если Отбор = Неопределено Тогда
		Отбор = Новый Структура;
	КонецЕсли;
	
	ОткрытьФорму(
		"Документ.ПеремещениеТоваров.ФормаВыбора",
		Новый Структура("Отбор", Отбор),
		Форма,,,,
		ОповещениеПриЗавершении);
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Открывает форму выбора документа Приобретения товаров и услуг.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой вызывается команда выбора документа,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы выбора,
//  Отбор - Структура - значения реквизитов, по которым нужно отобрать выбираемое приобретение товаров.
//
Процедура ОткрытьФормуВыбораДокументаПриобретениеТоваровУслуг(Форма, ОповещениеПриЗавершении, Отбор = Неопределено) Экспорт
	
	//++ НЕ ЕГАИС
	Если Отбор = Неопределено Тогда
		Отбор = Новый Структура;
	КонецЕсли;
	
	ОткрытьФорму(
		"Документ.ПриобретениеТоваровУслуг.ФормаВыбора",
		Новый Структура("Отбор", Отбор),
		Форма,,,,
		ОповещениеПриЗавершении);
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Открывает форму создания нового документа приобретения товаров и услуг на основании ТТН ЕГАИС.
//
// Параметры:
//  ТТНВходящаяЕГАИС - ДокументСсылка.ТТНВходящаяЕГАИС - ссылка на ТТН.
//
Процедура ОткрытьФормуСозданияДокументаПриобретенияТоваровНаОснованииТТНЕГАИС(ТТНВходящаяЕГАИС) Экспорт
	
	//++ НЕ ЕГАИС
	ОткрытьФорму("Документ.ПриобретениеТоваровУслуг.Форма.ФормаДокумента", Новый Структура("Основание", ТТНВходящаяЕГАИС));
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

// Выполняет действия при изменении номенклатуры в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения.
//
Процедура ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	//++ НЕ ЕГАИС
	ПараметрыЗаполненияНоменклатурыЕГАИС = Новый Структура;
	ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ЗаполнитьФлагАлкогольнаяПродукция", Ложь);
	ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ИмяКолонки", "АлкогольнаяПродукция");
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	СтруктураДействий.Вставить("ЗаполнитьПризнакЕдиницаИзмерения", Новый Структура("Номенклатура", "ЕдиницаИзмерения"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакМаркируемаяАлкогольнаяПродукция", Новый Структура("Номенклатура", "МаркируемаяАлкогольнаяПродукция"));
	СтруктураДействий.Вставить("ЗаполнитьНоменклатуруЕГАИС", ПараметрыЗаполненияНоменклатурыЕГАИС);
	
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
		СтруктураДействий.Вставить("ЗаполнитьИндексАкцизнойМарки");
	КонецЕсли;
	
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		Форма.ИмяФормы, "Товары"));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении характеристики в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения.
//
Процедура ПриИзмененииХарактеристики(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	//++ НЕ ЕГАИС
	ПараметрыЗаполненияНоменклатурыЕГАИС = Новый Структура;
	ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ЗаполнитьФлагАлкогольнаяПродукция", Ложь);
	ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ЗаполнитьФлагМаркируемаяАлкогольнаяПродукция", Ложь);
	ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ИмяКолонки", "АлкогольнаяПродукция");
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьНоменклатуруЕГАИС", ПараметрыЗаполненияНоменклатурыЕГАИС);
	
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	СтруктураДействий.Вставить("ХарактеристикаПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		Форма.ИмяФормы, "Товары"));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении упаковки в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения.
//
Процедура ПриИзмененииУпаковки(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	//++ НЕ ЕГАИС
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
		СтруктураДействий.Вставить("ЗаполнитьИндексАкцизнойМарки");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении количества упаковок в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения.
//
Процедура ПриИзмененииКоличестваУпаковок(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	//++ НЕ ЕГАИС
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
		СтруктураДействий.Вставить("ЗаполнитьИндексАкцизнойМарки");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении количества в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения.
//
Процедура ПриИзмененииКоличества(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	//++ НЕ ЕГАИС
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковок");
	
	Если ПараметрыЗаполнения.ПерезаполнитьНоменклатуруЕГАИС Тогда
		
		ПараметрыЗаполненияНоменклатурыЕГАИС = Новый Структура;
		ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ЗаполнитьФлагАлкогольнаяПродукция", Ложь);
		ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ИмяКолонки", "АлкогольнаяПродукция");
		
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
		СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
		
		СтруктураДействий.Вставить("ЗаполнитьПризнакМаркируемаяАлкогольнаяПродукция", Новый Структура("Номенклатура", "МаркируемаяАлкогольнаяПродукция"));
		СтруктураДействий.Вставить("ЗаполнитьНоменклатуруЕГАИС", ПараметрыЗаполненияНоменклатурыЕГАИС);
		
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
		СтруктураДействий.Вставить("ЗаполнитьИндексАкцизнойМарки");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении цены в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения.
//
Процедура ПриИзмененииЦены(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	//++ НЕ ЕГАИС
	СтруктураДействий = Новый Структура;
	
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

// Вызывает процедуру обработки подбора, если произошел выбор из формы подбора.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура завершения подбора номенклатуры,
//  ВыбранноеЗначение - Произвольный - результат выбора в подчиненной форме,
//  ИсточникВыбора - УправляемаяФорма - форма, где осуществлен выбор.
//
Процедура ОбработкаВыбораПодборНоменклатуры(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	//++ НЕ ЕГАИС
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваровВДокументПродажи.Форма.Форма" Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВыбранноеЗначение);
	КонецЕсли;
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Вызывает процедуру обработки подбора, если произошло оповещение из формы подбора.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура завершения подбора номенклатуры,
//  ИмяСобытия - Строка - имя события, о котором происходит оповещение,
//  Параметр - Произвольный - переданный в сообщение параметр,
//  Источник - УправляемаяФорма - форма, в которой произошло оповещение.
//
Процедура ОбработкаОповещенияПодборНоменклатуры(ОповещениеПриЗавершении, ИмяСобытия, Параметр, Источник) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Открывает форму создания нового контрагента.
//
// Параметры:
//  ДанныеКонтрагента - Структура - данные для заполнения нового контрагента. Структура со свойствами:
//   * Наименование - Строка - наименование контрагента,
//   * СокращенноеНаименование - Строка - сокращенное наименование контрагента,
//   * ИНН - Строка - ИНН контрагента,
//   * КПП - Строка - КПП контрагента.
//  Форма  - УправляемаяФорма - форма-владелец.
//
Процедура ОткрытьФормуСозданияНовогоКонтрагента(ДанныеКонтрагента, Форма) Экспорт
	
	//++ НЕ ЕГАИС
	Если ДанныеКонтрагента <> Неопределено Тогда
		ОснованиеСозданияКонтрагента = Новый Структура();
		ОснованиеСозданияКонтрагента.Вставить("Наименование",            ДанныеКонтрагента.Наименование);
		ОснованиеСозданияКонтрагента.Вставить("СокращенноеНаименование", ДанныеКонтрагента.Наименование);
		ОснованиеСозданияКонтрагента.Вставить("ИНН", ДанныеКонтрагента.ИНН);
		ОснованиеСозданияКонтрагента.Вставить("КПП", ДанныеКонтрагента.КПП);
	Иначе
		ОснованиеСозданияКонтрагента = Неопределено;
	КонецЕсли;
	
	ПараметрыСозданияКонтрагента = Новый Структура();
	ПараметрыСозданияКонтрагента.Вставить("РежимВыбора", Истина);
	ПараметрыСозданияКонтрагента.Вставить("Основание", ОснованиеСозданияКонтрагента);
	
	ОткрытьФорму(ПартнерыИКонтрагентыВызовСервера.ИмяФормыСозданияКонтрагента(), ПараметрыСозданияКонтрагента, Форма);
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Обработчик выбора контрагента в форме классификатора организаций.
//
// Параметры:
//  ВыбранноеЗначение - ОпределяемыйТип.ОрганизацияКонтрагентЕГАИС, ОпределяемыйТип.ТорговыйОбъектЕГАИС - выбранный контрагент или партнер,
//  ИсточникВыбора - УправляемаяФорма - форма, в которой произведен выбор,
//  Объект - СправочникОбъект.КлассификаторОрганизацийЕГАИС - элемент классификатора, в котором выбран контрагент или партнер.
//
Процедура ОбработатьВыборКонтрагентаДляСопоставления(ВыбранноеЗначение, ИсточникВыбора, Объект) Экспорт
	
	//++ НЕ ЕГАИС
	Если ИсточникВыбора.ИмяФормы = "Справочник.Контрагенты.Форма.ФормаЭлемента" Тогда
		Объект.Контрагент = ВыбранноеЗначение;
	КонецЕсли;
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.Партнеры.Форма.ПомощникНового" Тогда
		Объект.Контрагент = ИнтеграцияЕГАИСВызовСервераУТ.ПолучитьКонтрагентаПартнераПоУмолчанию(ВыбранноеЗначение);
	КонецЕсли;
	//-- НЕ ЕГАИС
	
КонецПроцедуры

// Обработчик выбора номенклатуры в форме элемента классификатора алкогольной продукции.
//
// Параметры:
//  ВыбранноеЗначение - ОпределяемыйТип.Номенклатура - выбранный элемент номенклатуры,
//  ИсточникВыбора - УправляемаяФорма - форма, в которой произведен выбор,
//  Объект - СправочникОбъект.КлассификаторАлкогольнойПродукцииЕГАИС - элемент классификатора, в котором выбрана номенклатура.
//
Процедура ОбработатьВыборНоменклатурыДляСопоставления(ВыбранноеЗначение, ИсточникВыбора, Объект) Экспорт
	
	//++ НЕ ЕГАИС
	Если ИсточникВыбора.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаВыбора"
		Или ИсточникВыбора.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаЭлемента" Тогда
		Объект.Номенклатура = ВыбранноеЗначение;
	КонецЕсли;
	//-- НЕ ЕГАИС
	
КонецПроцедуры

// Вызывается при нажатии на гиперссылку форматированной строки, расположенной в элементе формы.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло нажатие на гиперссылку,
//  ДокументОснование - ДокументСсылка - ссылка на документ, в котором произошло нажатие на гиперссылку,
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - значение гиперссылки форматированной строки,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, которая будет вызвана после обработки нажатия на гиперссылку.
//
Процедура ПриОбработкеНавигационнойСсылки(Форма, ДокументОснование, НавигационнаяСсылкаФорматированнойСтроки, ОповещениеПриЗавершении) Экспорт
	
	//++ НЕ ЕГАИС
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ТТНИсходящаяЕГАИС")
		Или ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ТТНВходящаяЕГАИС") Тогда
		
		РезультатПроверки = ИнтеграцияЕГАИСВызовСервераУТ.ПроверитьСопоставлениеКлассификаторовДляТоварноТранспортнойНакладнойЕГАИС(ДокументОснование, Форма.УникальныйИдентификатор);
		Если РезультатПроверки.ЕстьНеСопоставленныеТовары Тогда
			
			ПараметрыОткрытияФормы = Новый Структура;
			ПараметрыОткрытияФормы.Вставить("Документ",               ДокументОснование);
			ПараметрыОткрытияФормы.Вставить("НеСопоставленныеТовары", РезультатПроверки.НеСопоставленныеТовары);
			
			ОткрытьФорму(
				"Обработка.СопоставлениеКлассификаторовЕГАИС.Форма.СопоставлениеАлкогольнойПродукцииЕГАИСНоменклатурой",
				ПараметрыОткрытияФормы,
				Форма,,,,
				ОповещениеПриЗавершении);
			
		Иначе
			
			ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, Истина);
			
		КонецЕсли;
		
	Иначе
		
		РезультатПроверки = ИнтеграцияЕГАИСВызовСервераУТ.ПроверитьСопоставлениеКлассификаторов(ДокументОснование, Форма.УникальныйИдентификатор);
		Если РезультатПроверки.ЕстьНеСопоставленныеТовары Тогда
			
			ПараметрыОткрытияФормы = Новый Структура;
			ПараметрыОткрытияФормы.Вставить("Документ",               ДокументОснование);
			ПараметрыОткрытияФормы.Вставить("НеСопоставленныеТовары", РезультатПроверки.НеСопоставленныеТовары);
			
			ОткрытьФорму(
				"Обработка.СопоставлениеКлассификаторовЕГАИС.Форма.СопоставлениеНоменклатурыСАлкогольнойПродукциейЕГАИС",
				ПараметрыОткрытияФормы,
				Форма,,,,
				ОповещениеПриЗавершении);
			
		Иначе
			
			ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ ЕГАИС
	
КонецПроцедуры

#Область ПодключаемоеОборудование

// Вызывается при считывании сканером штрихкода.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - процедура, которую нужно вызвать после обработки получения штрихкодов,
//  Форма - УправляемаяФорма - форма, в которой отсканировали штрихкоды,
//  ИмяСобытия - Строка - имя события, инициировавшее оповещение. Если получены штрихкоды, то имя события будет "ScanData",
//  Параметр - Произвольный - отсканированные штрихкоды,
//  Источник - Произвольный - источник события.
//
Процедура ОбработкаОповещенияПолученыШтрихкоды(ОписаниеОповещения, Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	//++ НЕ ЕГАИС
	Если Источник = "ПодключаемоеОборудование" И Форма.ВводДоступен() Тогда
		
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			
			ДанныеШтрихкодов = МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр);
			ВыполнитьОбработкуОповещения(ОписаниеОповещения, ДанныеШтрихкодов);
			
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Вызывается перед обработкой штрихкодов, не привязанных ни к одной номенклатуре.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - процедура, которую нужно вызвать после выполнения обработки,
//  Форма - УправляемаяФорма - форма, в которой отсканировали штрихкоды,
//  ИмяСобытия - Строка - имя события, инициировавшее оповещение,
//  Параметр - Структура - данные для обработки,
//  Источник - Произвольный - источник события.
//
Процедура ОбработкаОповещенияОбработаныНеизвестныеШтрихкоды(ОписаниеОповещения, Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	//++ НЕ ЕГАИС
	Если Источник = "ПодключаемоеОборудование"
		И ИмяСобытия = "НеизвестныеШтрихкоды"
		И Параметр.ФормаВладелец = Форма.УникальныйИдентификатор Тогда
		
		ДанныеШтрихкодов = Новый Массив;
		Для Каждого ПолученныйШтрихкод Из Параметр.ПолученыНовыеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		Для Каждого ПолученныйШтрихкод Из Параметр.ЗарегистрированныеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, ДанныеШтрихкодов);
		
	КонецЕсли;
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

// Вызывается при считывании сканером штрихкода.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - процедура, которую нужно вызвать после обработки получения штрихкодов,
//  Форма - УправляемаяФорма - форма, в которой отсканировали штрихкоды,
//  Источник - Строка - источник внешнего события,
//  Событие - Строка - наименование события. Если получены штрихкоды, то событие будет "ScanData",
//  Данные - Произвольный - отсканированные штрихкоды.
//
Процедура ВнешнееСобытиеПолученыШтрихкоды(ОписаниеОповещения, Форма, Источник, Событие, Данные) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В процедуре нужно реализовать алгоритм передачи данных в ТСД.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, инициировавшая выгрузку.
//
Процедура ВыгрузитьДанныеВТСД(Форма) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В процедуре нужно реализовать алгоритм заполнения формы данными из ТСД.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - процедура, которую нужно вызвать после заполнения данных формы,
//  Форма - УправляемаяФорма - форма, данные в которой требуется заполнить,
//  РезультатВыполнения - Структура - результат загрузки данных из ТСД (см. МенеджерОборудованияКлиент.ПараметрыВыполненияОперацииНаОборудовании()).
//
Процедура ПриПолученииДанныхИзТСД(ОписаниеОповещения, Форма, РезультатВыполнения) Экспорт
	
	//++ НЕ ЕГАИС
	Если РезультатВыполнения.Результат Тогда
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения.ТаблицаТоваров);
		
	Иначе
		
		МенеджерОборудованияКлиентПереопределяемый.СообщитьОбОшибке(РезультатВыполнения);
		
	КонецЕсли;
	//-- НЕ ЕГАИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти