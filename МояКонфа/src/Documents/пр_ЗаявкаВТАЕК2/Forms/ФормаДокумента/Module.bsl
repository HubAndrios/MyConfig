Процедура РаскраситьСтрокиКрасным(Поле) 
    
    МассивИменКолонокДляПодсветки = Новый Массив;
	//Для каждого Стр из Элементы.Товары.ПодчиненныеЭлементы Цикл
	//    МассивИменКолонокДляПодсветки.Добавить(Стр.Имя);
	//КонецЦикла;
	Если Поле="Куратор" Тогда
		МассивИменКолонокДляПодсветки.Добавить(Элементы.Куратор.Имя);
	
	КонецЕсли;

    
    ЭлементОформления = УсловноеОформление.Элементы.Добавить();
    ЭлементОформления.Использование = Истина;
    ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона",  WebЦвета.Красный);
    
    ЭлементУсловия                = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    ЭлементУсловия.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект."+Поле);
    ЭлементУсловия.ПравоеЗначение = "";
	ЭлементУсловия.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;   
    ЭлементУсловия.Использование  = Истина;
    
    Для каждого ТекЭлемент из МассивИменКолонокДляПодсветки Цикл
        ОформляемоеПоле      = ЭлементОформления.Поля.Элементы.Добавить();
        ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ТекЭлемент);
    КонецЦикла;
        
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//РаскраситьСтрокиКрасным("Куратор")
КонецПроцедуры


