#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Процедура регистрации данных для обработчика обновления ОбработатьДанныеДляПереходаНаВерсию
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.ПланыПродаж";
	ИмяРегистра       = "ПланыПродаж";
	
	ПолноеИмяДокумента = "Документ.ПланПродаж";
	
	ТекстЗапроса = Документы.ПланПродаж.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
		ТекстЗапроса, ПолноеИмяРегистра, ПолноеИмяДокумента);
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(
		Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ПланПродаж");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(Регистраторы,
		"РегистрНакопления.ПланыПродаж", Параметры.Очередь);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли