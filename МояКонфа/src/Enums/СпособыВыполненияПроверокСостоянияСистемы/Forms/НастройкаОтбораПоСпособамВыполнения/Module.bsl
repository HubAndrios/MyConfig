
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СписокВыбора = Новый СписокЗначений;
	
	Если Параметры.Свойство("СписокВыбора") Тогда
		СписокВыбора = Параметры.СписокВыбора;
	КонецЕсли;
	
	Для Каждого Значение Из Метаданные.Перечисления.СпособыВыполненияПроверокСостоянияСистемы.ЗначенияПеречисления Цикл
		
		ЗначениеСсылка = Перечисления.СпособыВыполненияПроверокСостоянияСистемы[Значение.Имя];
		ЭлементСписка = Список.Добавить(ЗначениеСсылка);
		
		Если СписокВыбора.НайтиПоЗначению(ЗначениеСсылка)<>Неопределено Тогда
			ЭлементСписка.Пометка = Истина;
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СписокВыбора = Новый СписокЗначений;
	
	Для Каждого ЭлементСписка из Список Цикл
		Если ЭлементСписка.Пометка Тогда
			СписокВыбора.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	ОповеститьОВыборе(СписокВыбора);
	
КонецПроцедуры

#КонецОбласти
