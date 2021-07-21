&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "ТоварыХарактеристика");
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "ТоварыУпаковка");
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;

	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
	
	ОповещениеПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(
		ОповещениеПриПодключении,
		ЭтотОбъект,
		ПоддерживаемыеТипыПодключаемогоОборудования);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОповещениеПриОтключении = Новый ОписаниеОповещения("ОтключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(ОповещениеПриОтключении, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораПодборНоменклатуры(
		Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаПодбораНоменклатуры", ЭтотОбъект),
		ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если НЕ РедактированиеФормыНедоступно Тогда
		СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещенияПодборНоменклатуры(
			Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаПодбораНоменклатуры", ЭтотОбъект),
			ИмяСобытия, Параметр, Источник);
		
		СобытияФормЕГАИСКлиент.ОбработкаОповещенияПолученыШтрихкоды(
			Новый ОписаниеОповещения("Подключаемый_ПолученыШтрихкоды", ЭтотОбъект),
			ЭтотОбъект, ИмяСобытия, Параметр, Источник);
		
		СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещенияОбработаныНеизвестныеШтрихкоды(
			Новый ОписаниеОповещения("Подключаемый_ОбработаныНеизвестныеШтрихкоды", ЭтотОбъект),
			ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Прочитать();
		ОбновитьСтатусЕГАИС();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусЕГАИСВФормахДокументов)) Тогда
		
		Прочитать();
		ОбновитьСтатусЕГАИС();
		
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФормЕГАИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	АкцизныеМаркиЕГАИС.ЗаполнитьСлужебныеРеквизиты(ЭтотОбъект);
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
	ОбновитьСтатусЕГАИС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("Основание", Объект.ДокументОснование);
	Оповестить("Запись_АктПостановкиНаБалансЕГАИС", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если НЕ РедактированиеФормыНедоступно Тогда
		СобытияФормЕГАИСКлиент.ВнешнееСобытиеПолученыШтрихкоды(
			Новый ОписаниеОповещения("Подключаемый_ПолученыШтрихкоды", ЭтотОбъект),
			ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СтатусОбработкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОчиститьСообщения();
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Акт постановки на баланс ЕГАИС был изменен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Акт постановки на баланс ЕГАИС не проведен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСопоставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьОбработкуСопоставленияКлассификаторов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПричинаПостановкиНаБалансПриИзменении(Элемент)
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
	ОбновитьСтатусЕГАИС();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТовары

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	ИдентификаторыСтрок = Новый Массив;
	ВыделенныеСтроки = Элементы.Товары.ВыделенныеСтроки;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		СтрокаТЧ = Объект.Товары.НайтиПоИдентификатору(ВыделеннаяСтрока);
		ИдентификаторыСтрок.Добавить(СтрокаТЧ.ИдентификаторСтроки);
	КонецЦикла;
	
	Если Не Отказ И ИдентификаторыСтрок.Количество() > 0 Тогда
		УдалитьАкцизныеМарки(ИдентификаторыСтрок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПриИзмененииНоменклатуры(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииХарактеристики(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииУпаковки(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииКоличестваУпаковок(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьПодбор(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, 
		"Документ.АктПостановкиНаБалансЕГАИС.ФормаДокумента.Команда.ОткрытьПодбор");
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуПодбораНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьДанныеВТСД(Команда)
	
	ОчиститьСообщения();
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыгрузитьДанныеВТСД(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ОчиститьСообщения();
	
	МенеджерОборудованияКлиент.НачатьЗагрузкуДанныеИзТСД(
		Новый ОписаниеОповещения("ЗагрузитьИзТСДЗавершение", ЭтотОбъект),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьПоОснованию(Команда)
	
	ОчиститьСообщения();
	
	Если Объект.Товары.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru = 'Табличная часть будет перезаполнена. Продолжить?'");
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ВопросОПерезаполнениииПоОснованиюПриЗавершении", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ПерезаполнитьПоОснованиюСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АкцизныеМарки(Команда)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторСтроки) Тогда
		ТекущиеДанные.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
	ДополнительныеПараметрыИзменениеАкцизныхМарок = Новый Структура;
	ДополнительныеПараметрыИзменениеАкцизныхМарок.Вставить("ИдентификаторСтроки", ТекущиеДанные.ПолучитьИдентификатор());
	ДополнительныеПараметрыИзменениеАкцизныхМарок.Вставить("Редактирование", Истина);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИдентификаторСтроки", ТекущиеДанные.ПолучитьИдентификатор());
	ДополнительныеПараметры.Вставить("Редактирование", Истина);
	ДополнительныеПараметры.Вставить("АдресВоВременномХранилище", АдресТаблицыАкцизныхМаркиВоВременномХранилище(ТекущиеДанные.ИдентификаторСтроки));
	ДополнительныеПараметры.Вставить("Форма", ЭтотОбъект);
	ДополнительныеПараметры.Вставить(
		"ОповещениеПриЗавершении",
		Новый ОписаниеОповещения("ИзменениеАкцизныхМарокЗавершение", ЭтотОбъект, ДополнительныеПараметрыИзменениеАкцизныхМарок));
	
	АкцизныеМаркиЕГАИСКлиент.ОткрытьФормуСчитыванияАкцизнойМарки(
		Неопределено,
		ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.АктПостановкиНаБалансЕГАИС.Форма.ФормаДокумента.Записать");
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОстаткам(Команда)
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(Объект.ОрганизацияЕГАИС) Тогда
		ТекстСообщения =НСтр("ru = 'Не указана организация ЕГАИС'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,
		                                                  ,
		                                                  "ОрганизацияЕГАИС",
		                                                  "Объект");
		Возврат;
	КонецЕсли;
	
	Если Объект.Товары.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru = 'Табличная часть будет перезаполнена. Продолжить?'");
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ВопросОПерезаполнениииПоОстаткамПриЗавершении", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ВыполнитьКомандуЗаполнитьПоОстаткам();
		
	КонецЕсли
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.АктПостановкиНаБалансЕГАИС.Форма.ФормаДокумента.Провести");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.АктПостановкиНаБалансЕГАИС.Форма.ФормаДокумента.ПровестиИЗакрыть");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтотОбъект);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ИнтеграцияЕГАИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	ОбновитьСтатусЕГАИС();
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	АкцизныеМаркиЕГАИС.ЗаполнитьСлужебныеРеквизиты(ЭтотОбъект);
	
КонецПроцедуры

#Область АкцизныеМарки

&НаСервере
Функция АдресТаблицыАкцизныхМаркиВоВременномХранилище(ИдентификаторСтроки)
	
	Возврат АкцизныеМаркиЕГАИС.АдресТаблицыАкцизныхМаркиВоВременномХранилище(
		ЭтотОбъект,
		ИдентификаторСтроки);
	
КонецФункции

&НаСервере
Функция ЗагрузитьАкцизныеМаркиИзВременногоХранилища(ИдентификаторСтроки, АдресВоВременномХранилище)
	
	Возврат АкцизныеМаркиЕГАИС.ЗагрузитьАкцизныеМаркиИзВременногоХранилища(
		ЭтотОбъект,
		ИдентификаторСтроки,
		АдресВоВременномХранилище);
	
КонецФункции

&НаСервере
Функция ДанныеПоАкцизнымМаркам(ИдентификаторСтроки, КодАкцизнойМарки)
	
	Возврат АкцизныеМаркиЕГАИС.ДанныеПоАкцизнымМаркам(
		ЭтотОбъект,
		ИдентификаторСтроки,
		КодАкцизнойМарки);
	
КонецФункции

&НаСервере
Процедура УдалитьАкцизныеМарки(Данные)
	
	АкцизныеМаркиЕГАИС.УдалитьАкцизныеМарки(
		ЭтотОбъект,
		Данные);
	
КонецПроцедуры

&НаКлиенте
Процедура ВводАкцизнойМаркиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуТабличнойЧасти = Ложь;
	Если ДополнительныеПараметры.Редактирование Тогда
		
		ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
		ДанныеПоАкцизнымМаркам = ЗагрузитьАкцизныеМаркиИзВременногоХранилища(
			ТекущиеДанные.ИдентификаторСтроки,
			Результат);
		
	Иначе
		
		КодАкцизнойМарки           = Результат.КодАкцизнойМарки;
		СопоставленнаяНоменклатура = Результат.СопоставленнаяНоменклатура;
		ЗапрашиватьНоменклатуру    = ДополнительныеПараметры.ЗапрашиватьНоменклатуру;
		
		Если ДополнительныеПараметры.ИдентификаторСтроки = Неопределено Тогда
			ТекущиеДанные = Неопределено;
		Иначе
			НайденнаяСтрока = Объект.Товары.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
			Если  СопоставленнаяНоменклатура <> Неопределено
				И НайденнаяСтрока <> Неопределено
				И (НайденнаяСтрока.Номенклатура <> СопоставленнаяНоменклатура.Номенклатура
				   Или НайденнаяСтрока.Характеристика <> СопоставленнаяНоменклатура.Характеристика) Тогда
				ТекущиеДанные = Неопределено;
			Иначе
				ТекущиеДанные = НайденнаяСтрока;
			КонецЕсли;
		КонецЕсли;
		
		Если (СопоставленнаяНоменклатура <> Неопределено
			И ЗначениеЗаполнено(СопоставленнаяНоменклатура.Номенклатура))
			ИЛИ Не ЗапрашиватьНоменклатуру Тогда
			
			Если ТекущиеДанные <> Неопределено
				И Не ЗапрашиватьНоменклатуру Тогда
				
				// Добавление акцизной марки к текущий строке
				
			ИначеЕсли ТекущиеДанные <> Неопределено
				И СопоставленнаяНоменклатура.Номенклатура = ТекущиеДанные.Номенклатура
				И СопоставленнаяНоменклатура.Характеристика = ТекущиеДанные.Характеристика Тогда
				
				// Искомая алкогольная продукция найдена
				
			Иначе
				
				Если Объект.Товары.Количество() = 0 Тогда
					ТекущиеДанные = Объект.Товары.Добавить();
					ЗаполнитьЗначенияСвойств(ТекущиеДанные, СопоставленнаяНоменклатура);
					Если ЗначениеЗаполнено(СопоставленнаяНоменклатура.Номенклатура) Тогда
						ВыполнитьОбработкуТабличнойЧасти = Истина;
					Иначе
						ТекущиеДанные.АлкогольнаяПродукция = Истина;
						ТекущиеДанные.МаркируемаяАлкогольнаяПродукция = Истина;
					КонецЕсли;
				Иначе
					Если ТекущиеДанные = Неопределено Тогда
						ТекущиеДанные = Объект.Товары.Добавить();
						ЗаполнитьЗначенияСвойств(ТекущиеДанные, СопоставленнаяНоменклатура);
						Если ЗначениеЗаполнено(СопоставленнаяНоменклатура.Номенклатура) Тогда
							ВыполнитьОбработкуТабличнойЧасти = Истина;
						Иначе
							ТекущиеДанные.АлкогольнаяПродукция = Истина;
							ТекущиеДанные.МаркируемаяАлкогольнаяПродукция = Истина;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			
			ПараметрыОткрытияФормы = Новый Структура;
			ПараметрыОткрытияФормы.Вставить("КодАкцизнойМарки", КодАкцизнойМарки);
			Если СопоставленнаяНоменклатура <> Неопределено И ЗначениеЗаполнено(СопоставленнаяНоменклатура.НоменклатураЕГАИС) Тогда
				ПараметрыОткрытияФормы.Вставить("НоменклатураЕГАИС", СопоставленнаяНоменклатура.НоменклатураЕГАИС);
			КонецЕсли;
			
			ОткрытьФорму(
				"Обработка.РаботаСАкцизнымиМаркамиЕГАИС.Форма.ФормаВводаАкцизнойМаркиПоискНоменклатуры",
				ПараметрыОткрытияФормы,
				 ЭтотОбъект,,,,
				Новый ОписаниеОповещения("ВводАкцизнойМаркиЗавершение", ЭтотОбъект, ДополнительныеПараметры));
			Возврат;
			
		КонецЕсли;
		
		ДанныеПоАкцизнымМаркам = ДанныеПоАкцизнымМаркам(
			ТекущиеДанные.ИдентификаторСтроки,
			КодАкцизнойМарки);
		
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДополнительныеПараметры.Вставить("ВыполнитьОбработкуТабличнойЧасти", ВыполнитьОбработкуТабличнойЧасти);
	
	АкцизныеМаркиЕГАИСКлиент.ВводАкцизнойМаркиЗавершение(
		ДанныеПоАкцизнымМаркам,
		ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеАкцизныхМарокЗавершение(ТекущаяСтрока, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	
	Если ДополнительныеПараметры.ВыполнитьОбработкуТабличнойЧасти Тогда
		ПараметрыЗаполнения.ПерезаполнитьНоменклатуруЕГАИС = Истина;
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииКоличества(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область Штрихкоды

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	СобытияФормЕГАИСКлиент.ВыполнитьКомандуПоискПоШтрихкоду(
		Новый ОписаниеОповещения("Подключаемый_ПолученыШтрихкоды", ЭтотОбъект),
		ЭтотОбъект, ДанныеШтрихкода);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзТСДЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриПолученииДанныхИзТСД(
		Новый ОписаниеОповещения("Подключаемый_ПолученыДанныеИзТСД", ЭтотОбъект),
		ЭтотОбъект, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученыШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры) Экспорт
	
	МаркируемаяАлкогольнаяПродукцияВТЧ = (Объект.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр1"));
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки       = Истина;
	ПараметрыЗаполнения.МаркируемаяАлкогольнаяПродукцияВТЧ = МаркируемаяАлкогольнаяПродукцияВТЧ;
	ДанныеДляОбработки = ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПодготовитьДанныеДляОбработкиШтрихкодов(
		ЭтотОбъект, ДанныеШтрихкодов, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
	ОбработатьШтрихкоды(ДанныеДляОбработки, КэшированныеЗначения);
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПослеОбработкиШтрихкодов(
		ЭтотОбъект,
		ДанныеДляОбработки,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработаныНеизвестныеШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры) Экспорт
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ОчиститьКэшированныеШтрихкоды(ДанныеШтрихкодов, КэшированныеЗначения);
	
	Подключаемый_ПолученыШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученыДанныеИзТСД(ТаблицаТоваров, ДополнительныеПараметры) Экспорт
	
	МаркируемаяАлкогольнаяПродукцияВТЧ = (Объект.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр1"));
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки       = Истина;
	ПараметрыЗаполнения.МаркируемаяАлкогольнаяПродукцияВТЧ = МаркируемаяАлкогольнаяПродукцияВТЧ;
	ДанныеДляОбработки = ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПодготовитьДанныеДляОбработкиТаблицыТоваровПолученнойИзТСД(
		ЭтотОбъект, ТаблицаТоваров, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
	ОбработатьДанныеИзТСД(ДанныеДляОбработки, КэшированныеЗначения);
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПослеОбработкиТаблицыТоваровПолученнойИзТСД(
		ЭтотОбъект,
		ДанныеДляОбработки,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкоды(ДанныеДляОбработки, КэшированныеЗначения)
	
	ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.ОбработатьШтрихкоды(
		ЭтотОбъект, ДанныеДляОбработки, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьДанныеИзТСД(ТаблицаТоваров, КэшированныеЗначения)
	
	ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.ОбработатьДанныеИзТСД(
		ЭтотОбъект, ТаблицаТоваров, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область Подбор

&НаСервере
Процедура ОбработкаРезультатаПодбораНоменклатуры(ВыбранноеЗначение, ПараметрыЗаполнения)
	
	СобытияФормЕГАИСПереопределяемый.ОбработкаРезультатаПодбораНоменклатуры(
		ЭтотОбъект, ВыбранноеЗначение,
		ПараметрыЗаполнения);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	АкцизныеМаркиЕГАИС.ЗаполнитьСлужебныеРеквизиты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаПодбораНоменклатуры(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	ОбработкаРезультатаПодбораНоменклатуры(Результат, ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область Статус

&НаСервере
Процедура ОбновитьСтатусЕГАИС()

	ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется;
	ЦветТекста         = Неопределено;
	
	Если Объект.СтатусОбработки = Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.Новый
		Или Объект.СтатусОбработки = Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ОшибкаПередачиВЕГАИС Тогда 
		
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные;
		
	ИначеЕсли Объект.СтатусОбработки = Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ПереданВЕГАИС
		И Объект.ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр1 Тогда
		
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОтменуПроведения;
		
	КонецЕсли;
	
	Если Объект.СтатусОбработки = Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ОшибкаПередачиВЕГАИС Тогда 
		
		ЦветТекста = ЦветаСтиля.ЕГАИССтатусОбработкиОшибкаПередачи;
		
	КонецЕсли;
	
	ТекстПредставление = Новый ФорматированнаяСтрока(Строка(Объект.СтатусОбработки),,ЦветТекста);
	
	СтатусЕГАИСПредставление = ИнтеграцияЕГАИС.ПредставлениеСтатусаЕГАИС(ТекстПредставление, ДальнейшееДействие);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		
		ПередатьДанные();
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ЗапроситьОтменуПроведения" Тогда
		
		ЗапроситьОтменуПроведения();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	КонецЕсли;
	
	Если Не Модифицированность И Объект.Проведен Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанные()
	
	ПараметрыЗапроса = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(Объект.ВидДокумента);
	ПараметрыЗапроса.ДокументСсылка = Объект.Ссылка;
	
	ИнтеграцияЕГАИСКлиент.НачатьФормированиеИсходящегоЗапроса(
		Новый ОписаниеОповещения("ПослеПередачиДанныхЕГАИС", ЭтотОбъект),
		Объект.ВидДокумента,
		ПараметрыЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьОтменуПроведения()
	
	ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияАктаПостановкиНаБаланс");
	
	ПараметрыЗапроса = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(ВидДокумента);
	ПараметрыЗапроса.ДокументСсылка = Объект.Ссылка;
	
	ИнтеграцияЕГАИСКлиент.НачатьФормированиеИсходящегоЗапроса(
		Новый ОписаниеОповещения("ПослеПередачиДанныхЕГАИС", ЭтотОбъект),
		ВидДокумента,
		ПараметрыЗапроса);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЭлементыФормы(Форма)
	
	АктПостановкиНаБалансВРегистр1 = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр1");
	Пересортица                    = ПредопределенноеЗначение("Перечисление.ПричиныПостановкиНаБалансЕГАИС.Пересортица");
	
	Форма.РедактированиеФормыНеДоступно =
		(Форма.Объект.СтатусОбработки = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ПередаетсяВЕГАИС")
		ИЛИ Форма.Объект.СтатусОбработки = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ПереданВЕГАИС"));
		
	Форма.Элементы.ГруппаНередактируемыеПослеОтправкиРеквизитыОсновное.ТолькоПросмотр = Форма.РедактированиеФормыНедоступно;
	Форма.Элементы.ГруппаНередактируемыеПослеОтправкиКомандыТовары.Доступность        = НЕ Форма.РедактированиеФормыНедоступно;
	Форма.Элементы.СтраницаТовары.ТолькоПросмотр                                      = Форма.РедактированиеФормыНедоступно;
	
	Форма.Элементы.ДекорацияСопоставление.Видимость         = Форма.ОтображатьСтрокуСопоставления;
	Форма.Элементы.ТоварыЗаполнитьПоОстаткам.Видимость      = Не ЗначениеЗаполнено(Форма.Объект.ДокументОснование);
	Форма.Элементы.ТоварыПерезаполнитьПоОснованию.Видимость = ЗначениеЗаполнено(Форма.Объект.ДокументОснование);
	
	Форма.Элементы.АктСписанияЕГАИС.Видимость = (Форма.Объект.ПричинаПостановкиНаБаланс = Пересортица);
	
	Форма.Элементы.ТоварыАкцизныеМарки.Видимость       = (Форма.Объект.ВидДокумента = АктПостановкиНаБалансВРегистр1);
	Форма.Элементы.ТоварыИндексАкцизнойМарки.Видимость = (Форма.Объект.ВидДокумента = АктПостановкиНаБалансВРегистр1);
	
	Форма.Элементы.ТоварыКоличествоПоСправке1.Видимость = (Форма.Объект.ВидДокумента = АктПостановкиНаБалансВРегистр1);
	Форма.Элементы.ТоварыНомерТТН.Видимость             = (Форма.Объект.ВидДокумента = АктПостановкиНаБалансВРегистр1);
	Форма.Элементы.ТоварыДатаТТН.Видимость              = (Форма.Объект.ВидДокумента = АктПостановкиНаБалансВРегистр1);
	Форма.Элементы.ТоварыДатаРозлива.Видимость          = (Форма.Объект.ВидДокумента = АктПостановкиНаБалансВРегистр1);
	
	Форма.Элементы.ТоварыНомерПодтвержденияЕГАИС.Видимость = (Форма.Объект.ВидДокумента = АктПостановкиНаБалансВРегистр1);
	Форма.Элементы.ТоварыДатаПодтвержденияЕГАИС.Видимость  = (Форма.Объект.ВидДокумента = АктПостановкиНаБалансВРегистр1);
	Форма.Элементы.ТоварыСправка2.Видимость                = (Форма.Объект.ВидДокумента = АктПостановкиНаБалансВРегистр1);
	
	Форма.ИспользоватьАкцизныеМарки = Форма.Объект.ВидДокумента = АктПостановкиНаБалансВРегистр1;
	
КонецПроцедуры

#КонецОбласти

#Область Оборудование

&НаКлиенте
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При отключении оборудования произошла ошибка: ""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ОткрытьОбработкуСопоставленияКлассификаторов()
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Документ",               Объект.Ссылка);
	ПараметрыОткрытияФормы.Вставить("НеСопоставленныеТовары", АдресТаблицыНесопоставленныхТоваров);
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуСопоставленияНоменклатурыСАлкогольнойПродукцией(
		ЭтотОбъект,
		Новый ОписаниеОповещения("ПриЗавершенииСопоставленияКлассификаторов", ЭтотОбъект),
		ПараметрыОткрытияФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииСопоставленияКлассификаторов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не Результат = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьКомандуЗаполнитьПоОстаткам();
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОПерезаполнениииПоОстаткамПриЗавершении(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ВыполнитьКомандуЗаполнитьПоОстаткам();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОПерезаполнениииПоОснованиюПриЗавершении(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ПерезаполнитьПоОснованиюСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьПоОснованиюСервер()
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТекущийОбъект.Заполнить(Объект.ДокументОснование);
	
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	
	НастроитьЭлементыФормы(ЭтотОбъект);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	АкцизныеМаркиЕГАИС.ЗаполнитьСлужебныеРеквизиты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКомандуЗаполнитьПоОстаткам()
	
	РезультатЗаполнения = РезультатЗаполненияПоОстаткамСервер();
	
	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		ПриИзмененииНоменклатуры(СтрокаТЧ);
	КонецЦикла;
	
	АдресТаблицыНесопоставленныхТоваров = РезультатЗаполнения.АдресТаблицыНесопоставленныхТоваров;
	ОтображатьСтрокуСопоставления = РезультатЗаполнения.ЕстьНесопоставленнаяАлкогольнаяПродукция;
	НастроитьЭлементыФормы(ЭтотОбъект);
	
	Если ОтображатьСтрокуСопоставления Тогда
		
		ОткрытьОбработкуСопоставленияКлассификаторов();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция РезультатЗаполненияПоОстаткамСервер()

	Возврат СобытияФормЕГАИСПереопределяемый.ЗаполнитьАктПостановкиНаБалансОтсутствующимиВЕГАИСОстатками(Объект, ЭтотОбъект);

КонецФункции

&НаКлиенте
Процедура ПриИзмененииНоменклатуры(ТекущаяСтрока)
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки = Истина;
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииНоменклатуры(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПередачиДанныхЕГАИС(Результат, ДополнительныеПараметры) Экспорт
	
	Прочитать();
	
	ИнтеграцияЕГАИСКлиент.ПослеПередачиДанныхЕГАИС(Результат, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
