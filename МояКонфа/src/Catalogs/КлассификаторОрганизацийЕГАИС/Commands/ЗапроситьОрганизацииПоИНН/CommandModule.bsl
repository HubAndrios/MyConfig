
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидДокументаЕГАИС", ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОрганизаций"));
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормированиеИсходящегоЗапросаЕГАИС",
		ПараметрыФормы,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ФормированиеЗапросаКлассификатора_Завершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ФормированиеЗапросаКлассификатора_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") ИЛИ НЕ Результат.Результат Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИСКлиент.СообщитьОЗавершенииФормированияИсходящегоЗапроса();
	
КонецПроцедуры

#КонецОбласти