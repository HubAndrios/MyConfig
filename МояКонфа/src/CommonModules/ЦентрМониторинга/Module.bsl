#Область ПрограммныйИнтерфейс

#Область ПрограммныйИнтерфейсОбщий

// Включает подсистему ЦентрМониторинга.
//
Процедура ВключитьПодсистему() Экспорт
    
    ПараметрыЦентраМониторинга = ЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторинга();
    
    ПараметрыЦентраМониторинга.ВключитьЦентрМониторинга = Истина;
	ПараметрыЦентраМониторинга.ЦентрОбработкиИнформацииОПрограмме = Ложь;
    
    ЦентрМониторингаСлужебный.УстановитьПараметрыЦентраМониторингаВнешнийВызов(ПараметрыЦентраМониторинга);
    
КонецПроцедуры

// Отключает подсистему ЦентрМониторинга.
//
Процедура ОтключитьПодсистему() Экспорт
    
    ПараметрыЦентраМониторинга = ЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторинга();
    
    ПараметрыЦентраМониторинга.ВключитьЦентрМониторинга = Ложь;
	ПараметрыЦентраМониторинга.ЦентрОбработкиИнформацииОПрограмме = Ложь;
    
    ЦентрМониторингаСлужебный.УстановитьПараметрыЦентраМониторингаВнешнийВызов(ПараметрыЦентраМониторинга);
    
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейсБизнесСтатистики

// Записывает операцию бизнес статистики.
//
// Параметры:
//  ИмяОперации	- Строка	- имя операции статистики, в случае отсутствия создается новое.
//  Значение	- Число		- количественное значение операции статистики.
//  Комментарий	- Строка	- произвольный комментарий.
//	Разделитель	- Строка	- разделитель значений в ИмяОперации, если разделитель не точка.
//
Процедура ЗаписатьОперациюБизнесСтатистики(ИмяОперации, Значение, Комментарий = Неопределено, Разделитель = ".") Экспорт
	Если ЦентрМониторингаВызовСервераПовтИсп.ЗаписыватьОперацииБизнесСтатистики() Тогда
		РегистрыСведений.БуферОперацийСтатистики.ЗаписатьОперациюБизнесСтатистики(ИмяОперации, Значение, Комментарий, Разделитель);
	КонецЕсли;
КонецПроцедуры

// Записывает уникальную операцию бизнес статистики в разрезе часа.
// При записи проверяет уникальность.
//
// Параметры:
//  ИмяОперации      - Строка - имя операции статистики, в случае отсутствия создается новое.
//  КлючУникальности - Строка - ключ для контроля уникальности записи, максимальная длина 100.
//  Значение         - Число  - количественное значение операции статистики.
//  Замещать         - Булево - определяет режим замещения существующей записи.
//                              Истина - перед записью существующая запись будет удалена.
//                              Ложь - если запись уже существует, новые данные игнорируются.
//                              Значение по умолчанию: Ложь.
//
Процедура ЗаписатьОперациюБизнесСтатистикиЧас(ИмяОперации, КлючУникальности, Значение, Замещать = Ложь) Экспорт
    
    ПараметрыЗаписи = Новый Структура("ИмяОперации, КлючУникальности, Значение, Замещать, ТипЗаписи, ПериодЗаписи");
    ПараметрыЗаписи.ИмяОперации = ИмяОперации;
    ПараметрыЗаписи.КлючУникальности = КлючУникальности;
    ПараметрыЗаписи.Значение = Значение;
    ПараметрыЗаписи.Замещать = Замещать;
    ПараметрыЗаписи.ТипЗаписи = 1;
    ПараметрыЗаписи.ПериодЗаписи = НачалоЧаса(ТекущаяУниверсальнаяДата());
    
    ЦентрМониторингаСлужебный.ЗаписатьОперациюБизнесСтатистикиСлужебная(ПараметрыЗаписи);
    
КонецПроцедуры

// Записывает уникальную операцию бизнес статистики в разрезе суток.
// При записи проверяет уникальность.
//
// Параметры:
//  ИмяОперации      - Строка - имя операции статистики, в случае отсутствия создается новое.
//  КлючУникальности - Строка - ключ для контроля уникальности записи, максимальная длина 100.
//  Значение         - Число  - количественное значение операции статистики.
//  Замещать         - Булево - определяет режим замещения существующей записи.
//                              Истина - перед записью существующая запись будет удалена.
//                              Ложь - если запись уже существует, новые данные игнорируются.
//                              Значение по умолчанию: Ложь.
//
Процедура ЗаписатьОперациюБизнесСтатистикиСутки(ИмяОперации, КлючУникальности, Значение, Замещать = Ложь) Экспорт
    
    ПараметрыЗаписи = Новый Структура("ИмяОперации, КлючУникальности, Значение, Замещать, ТипЗаписи, ПериодЗаписи");
    ПараметрыЗаписи.ИмяОперации = ИмяОперации;
    ПараметрыЗаписи.КлючУникальности = КлючУникальности;
    ПараметрыЗаписи.Значение = Значение;
    ПараметрыЗаписи.Замещать = Замещать;
    ПараметрыЗаписи.ТипЗаписи = 2;
    ПараметрыЗаписи.ПериодЗаписи = НачалоДня(ТекущаяУниверсальнаяДата());
   
    ЦентрМониторингаСлужебный.ЗаписатьОперациюБизнесСтатистикиСлужебная(ПараметрыЗаписи);
    
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейсСтатистикиКонфигурации

// Записывает статистику по объектам конфигурации.
//
// Параметры:
//  СоответствиеИменМетаданных - Структура - структура со свойствами:
//   * Ключ		- Строка - 	имя объекта метаданных.
//   * Значение	- Строка - 	текст запроса выборки данных, обязательно должно
//							присутствовать поле Количество. Если Количество равно нулю,
//                          то запись не происходит.
//
Процедура ЗаписатьСтатистикуКонфигурации(СоответствиеИменМетаданных) Экспорт
	Параметры = Новый Соответствие;
	Для Каждого ТекМетаданные Из СоответствиеИменМетаданных Цикл
		Параметры.Вставить(ТекМетаданные.Ключ, Новый Структура("Запрос, ОперацииСтатистики, ВидСтатистики", ТекМетаданные.Значение,,0));
	КонецЦикла;
	
    Если ОбщегоНазначения.РазделениеВключено() И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
        МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
        ОбластьДанныхСтрока = Формат(МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса(), "ЧГ=0");
    Иначе
        ОбластьДанныхСтрока = "0";
    КонецЕсли;
	ОбластьДанныхСсылка = РегистрыСведений.ОбластиСтатистики.ПолучитьСсылку(ОбластьДанныхСтрока);
	
	РегистрыСведений.СтатистикаКонфигурации.Записать(Параметры, ОбластьДанныхСсылка);
КонецПроцедуры

// Записывает статистику по объекту конфигурации.
//
// Параметры:
//  ИмяОбъекта -	Строка	- имя операции статистики, в случае отсутствия создается новое.
//  Значение - 		Число	- количественное значение операции статистики. Если значение
//                            равно нулю, то запись не происходит.
//
Процедура ЗаписатьСтатистикуОбъектаКонфигурации(ИмяОбъекта, Значение) Экспорт
    
    Если Значение <> 0 Тогда 
        ОперацияСтатистики = ЦентрМониторингаПовтИсп.ПолучитьСсылкуОперацииСтатистики(ИмяОбъекта);
        
        Если ОбщегоНазначения.РазделениеВключено() И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
            МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
            ОбластьДанныхСтрока = Формат(МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса(), "ЧГ=0");
        Иначе
            ОбластьДанныхСтрока = "0";
        КонецЕсли;
        ОбластьДанныхСсылка = РегистрыСведений.ОбластиСтатистики.ПолучитьСсылку(ОбластьДанныхСтрока);
        
        НаборЗаписей = РегистрыСведений.СтатистикаКонфигурации.СоздатьНаборЗаписей();
        НаборЗаписей.Отбор.ОперацияСтатистики.Установить(ОперацияСтатистики);
        
        НовЗапись = НаборЗаписей.Добавить();
        НовЗапись.ИдентификаторОбластиСтатистики = ОбластьДанныхСсылка;
        НовЗапись.ОперацияСтатистики = ОперацияСтатистики;
        НовЗапись.Значение = Значение;	
        НаборЗаписей.Записать(Истина);
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти

#КонецОбласти