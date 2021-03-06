#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОплатаПодтверждена               = Параметры.ОплатаПодтверждена;
	НомерОтметкиОРегистрации         = Параметры.НомерОтметкиОРегистрации;
	ДатаПодтвержденияОплаты          = Параметры.ДатаПодтвержденияОплаты;
	НомерДокументаПеречисленияНалога = Параметры.НомерДокументаПеречисленияНалога;
	ДатаДокументаПеречисленияНалога  = Параметры.ДатаДокументаПеречисленияНалога;
	
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подтвердить(Команда)
	
	ОчиститьСообщения();
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ОплатаПодтверждена",               ОплатаПодтверждена);
	Результат.Вставить("НомерОтметкиОРегистрации",         НомерОтметкиОРегистрации);
	Результат.Вставить("ДатаПодтвержденияОплаты",          ДатаПодтвержденияОплаты);
	Результат.Вставить("НомерДокументаПеречисленияНалога", НомерДокументаПеречисленияНалога);
	Результат.Вставить("ДатаДокументаПеречисленияНалога",  ДатаДокументаПеречисленияНалога);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатаПодтвержденаПриИзменении(Элемент)
	
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Элементы.ДатаПодтвержденияОплаты.Доступность = ОплатаПодтверждена;
	Элементы.НомерРегистрации.Доступность = ОплатаПодтверждена;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ОплатаПодтверждена Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("НомерОтметкиОРегистрации"));
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ДатаПодтвержденияОплаты"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти