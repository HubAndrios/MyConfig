
#Область ОписаниеПеременных

&НаКлиенте
Перем ВнешнийПодключаемыйМодуль;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Хранилище Из Параметры.Хранилища Цикл
		Элементы.ИдентификаторХранилища.СписокВыбора.Добавить(Хранилище);
	КонецЦикла;
	
	Если Параметры.Хранилища.Количество() = 1 Тогда
		Элементы.ИдентификаторХранилища.ТолькоПросмотр = Истина;
		ИдентификаторХранилища = Хранилище;
		ТекущийЭлемент = Элементы.ПИН;
	КонецЕсли;

	ИмяВнешнегоМодуля = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.НастройкаОбмена, "ИмяВнешнегоМодуля");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ВнешнийПодключаемыйМодуль = ОбменСБанкамиСлужебныйКлиент.ВнешнийПодключаемыйМодульЧерезДополнительнуюОбработку(
		ИмяВнешнегоМодуля);
	Если ВнешнийПодключаемыйМодуль = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ХранилищеПриИзменении(Элемент)

	УстановитьДоступностьЭлементов();
	ПИН = "";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если Не ЗначениеЗаполнено(ИдентификаторХранилища) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбрано аппаратное устройство.'"), , "ИдентификаторХранилища");
		Возврат;
	КонецЕсли;
	
	Если Элементы.ПИН.Доступность Тогда
		ПинКодУстановлен = ОбменСБанкамиСлужебныйКлиент.УстановитьPINКодХранилищаЧерезДополнительнуюОбработку(
			ВнешнийПодключаемыйМодуль, ИдентификаторХранилища, ПИН)
	Иначе
		ПинКодУстановлен = Истина;
	КонецЕсли;
	
	Если ПинКодУстановлен Тогда
		Закрыть(ИдентификаторХранилища);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()

	Если ЗначениеЗаполнено(ИдентификаторХранилища) Тогда
		Элементы.ПИН.Доступность = ОбменСБанкамиСлужебныйКлиент.ТребуетсяУстановкаPINКодаХранилищаЧерезДополнительнуюОбработку(ВнешнийПодключаемыйМодуль, ИдентификаторХранилища)
			И НЕ ОбменСБанкамиСлужебныйКлиент.УстановленPINКодХранилищаЧерезДополнительнуюОбработку(ВнешнийПодключаемыйМодуль, ИдентификаторХранилища);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

