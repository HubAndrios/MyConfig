
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	
	ДанныеВыбора.Добавить(Перечисления.СтатусыПеремещенийТоваров.Отгружено);
	ДанныеВыбора.Добавить(Перечисления.СтатусыПеремещенийТоваров.Принято);
	
КонецПроцедуры
