
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	КонвертSOAP = ИнтеграцияГИСМВызовСервера.КонвертSOAPИзПротокола(Объект.Ссылка);
	ТекстовыйДокументКонвертSOAP.УстановитьТекст(КонвертSOAP);
	
	ТекстСообщенияXML = ИнтеграцияГИСМВызовСервера.ТекстВходящегоСообщенияXML(КонвертSOAP);
	ТекстСообщенияXML = ИнтеграцияГИСМВызовСервера.ФорматироватьXMLСПараметрами(ТекстСообщенияXML, ИнтеграцияГИСМ.ПараметрыФорматированияXML(Истина, "  "));

	ТекстовыйДокументТекстСообщенияXML.УстановитьТекст(ТекстСообщенияXML);
	
	СертификатКриптографии = ИнтеграцияГИСМКлиентСервер.СертификатКриптографииИзКонвертаSOAP(КонвертSOAP);
	
	АдресСертификата = ПоместитьВоВременноеХранилище(СертификатКриптографии.Выгрузить(), УникальныйИдентификатор);
	
	Подпись = ИнтеграцияГИСМКлиентСервер.ПредставлениеПодписи(СертификатКриптографии, Объект, Истина, ЦветаСтиля);
	
	РежимОтладки = ОбщегоНазначенияКлиентСервер.РежимОтладки();
	
	СтруктураЦветаСтиля = Новый Структура;
	СтруктураЦветаСтиля.Вставить("ЦветТекстаТребуетВниманияГИСМ", ЦветаСтиля.ЦветТекстаТребуетВниманияГИСМ);
	СтруктураЦветаСтиля.Вставить("ЦветГиперссылкиГИСМ", ЦветаСтиля.ЦветГиперссылкиГИСМ);
	
	Элементы.ГруппаШапка.ТолькоПросмотр = Не РежимОтладки;
	Элементы.ГруппаСообщение.ТолькоПросмотр = Не РежимОтладки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапки

&НаКлиенте
Процедура ПодписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьСертификат" Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("АдресСертификата", АдресСертификата);
		
		ОткрытьФорму("ОбщаяФорма.Сертификат", ПараметрыОткрытия, ЭтотОбъект);
		
	КонецЕсли;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПроверитьПодпись" Тогда
		
		ИсходныеДанные = Новый Структура;
		ИсходныеДанные.Вставить("КонвертSOAP",      ТекстовыйДокументКонвертSOAP.ПолучитьТекст());
		ИсходныеДанные.Вставить("ПараметрыXMLDSig", ИнтеграцияГИСМКлиентСервер.ПараметрыXMLDSig());
		
		ЭлектроннаяПодписьКлиент.ПроверитьПодпись(
			Новый ОписаниеОповещения("ПослеПроверкиПодписи", ЭтотОбъект),
			ИсходныеДанные,
			Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСертификат(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("АдресСертификата", АдресСертификата);
	
	ОткрытьФорму("ОбщаяФорма.Сертификат", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ОбновитьРеквизитПодписьВернаНаСервере(Ссылка, ПодписьВерна)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СправочникОбъект = Ссылка.ПолучитьОбъект();
	СправочникОбъект.ПодписьВерна        = ПодписьВерна;
	СправочникОбъект.ДатаПроверкиПодписи = ТекущаяДатаСеанса();
	
	СправочникОбъект.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПроверкиПодписи(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
		
		ОбновитьРеквизитПодписьВернаНаСервере(Объект.Ссылка, Истина);
		ЭтотОбъект.Прочитать();
		
	ИначеЕсли Результат = Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не удалось получить менеджер криптографии'"));
		
	ИначеЕсли ТипЗнч(Результат) = Тип("Строка") Тогда
		
		ОбновитьРеквизитПодписьВернаНаСервере(Объект.Ссылка, Ложь);
		ЭтотОбъект.Прочитать();
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат);
		
	КонецЕсли;
	
	СертификатКриптографии = ИнтеграцияГИСМКлиентСервер.СертификатКриптографииИзКонвертаSOAP(ТекстовыйДокументКонвертSOAP.ПолучитьТекст());
	
	Подпись = ИнтеграцияГИСМКлиентСервер.ПредставлениеПодписи(СертификатКриптографии, Объект, Истина, СтруктураЦветаСтиля);
	
КонецПроцедуры

#КонецОбласти