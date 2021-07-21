
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Варианты ответов анкет используются только внешними пользователями.'"),,,,Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
