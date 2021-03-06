
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МассивИсключаемыхЗначений = Новый Массив;
	
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		МассивИсключаемыхЗначений.Добавить(ПредопределенноеЗначение("Перечисление.ТипыРасходов.ФормированиеСтоимостиВНА"));
		МассивИсключаемыхЗначений.Добавить(ПредопределенноеЗначение("Перечисление.ТипыРасходов.Производственные"));
	КонецЕсли;
	
	ОбщегоНазначенияУТВызовСервера.ДоступныеДляВыбораЗначенияПеречисления(
		"ТипыРасходов",
		ДанныеВыбора,
		Параметры,
		МассивИсключаемыхЗначений);
	
КонецПроцедуры

#КонецОбласти

