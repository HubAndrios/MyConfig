
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	//Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура("Ключ", ПолучитьОрганизациюПоУмолчанию());
	ОткрытьФорму("Справочник.Организации.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьОрганизациюПоУмолчанию()
	
	Возврат ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию();
	
КонецФункции

#КонецОбласти

