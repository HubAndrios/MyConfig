
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
		
	Если ДоговорЗакрыт(Запись.ВариантГрафика) Тогда
		Отказ = Истина;
		Текст = НСтр("ru = 'Изменения графика по закрытому договору запрещены!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДоговорЗакрыт(ВариантГрафика)
	
	Возврат ВариантГрафика.Владелец = Перечисления.СтатусыДоговоровКонтрагентов.Закрыт;
	
КонецФункции

#КонецОбласти
