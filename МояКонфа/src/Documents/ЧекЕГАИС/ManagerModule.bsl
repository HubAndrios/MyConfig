
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПараметрыПередачиДанныхЕГАИС(ДокументСсылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЧекЕГАИС.Дата,
	|	ЧекЕГАИС.НомерСмены,
	|	ЧекЕГАИС.НомерЧекаККМ,
	|	ЧекЕГАИС.СерийныйНомерККМ,
	|	ЧекЕГАИС.ОрганизацияЕГАИС,
	|	ЧекЕГАИС.Ответственный.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЧекЕГАИС.ОрганизацияЕГАИС.Код КАК ИдентификаторФСРАР
	|ИЗ
	|	Документ.ЧекЕГАИС КАК ЧекЕГАИС
	|ГДЕ
	|	ЧекЕГАИС.Ссылка = &ДокументСсылка");
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();
	
	Данные = ДанныеДляЕГАИСПоСсылке(ДокументСсылка);
	
	ТаблицаТоваров = Новый Массив();
	Для Каждого СтрокаТЧ Из Данные Цикл
		
		ПараметрыАлкогольнойПродукции = Новый Массив;
		ПараметрыАлкогольнойПродукции.Добавить(СтрокаТЧ.МаркируемаяАлкогольнаяПродукция); // Признак наличия штрихкода PDF417
		ПараметрыАлкогольнойПродукции.Добавить(СтрокаТЧ.КодАкцизнойМарки);                // Штрихкод марки в формате PDF417
		ПараметрыАлкогольнойПродукции.Добавить(СтрокаТЧ.Объем);                           // Объем номенклатуры в литрах
		ПараметрыАлкогольнойПродукции.Добавить(СтрокаТЧ.Крепость);                        // Процент содержания алкоголя
		ПараметрыАлкогольнойПродукции.Добавить(СтрокаТЧ.КодВидаАлкогольнойПродукции);     // Код вида алкогольной продукции
		
		СтрокаТаблицыТоваров = Новый СписокЗначений();
		СтрокаТаблицыТоваров.Добавить(Строка(СтрокаТЧ.Номенклатура)); //  1 - Наименование
		СтрокаТаблицыТоваров.Добавить(СтрокаТЧ.Штрихкод);             //  2 - Штрихкод
		СтрокаТаблицыТоваров.Добавить("");                            //  3 - Артикул
		СтрокаТаблицыТоваров.Добавить(1);                             //  4 - Номер отдела
		СтрокаТаблицыТоваров.Добавить(СтрокаТЧ.Цена);                 //  5 - Цена за позицию без скидки
		СтрокаТаблицыТоваров.Добавить(СтрокаТЧ.Количество);           //  6 - Количество
		СтрокаТаблицыТоваров.Добавить("");                            //  7 - Наименование скидки/наценки
		СтрокаТаблицыТоваров.Добавить(0);                             //  8 - Сумма скидки/наценки
		СтрокаТаблицыТоваров.Добавить(0);                             //  9 - Процент скидки/наценки
		СтрокаТаблицыТоваров.Добавить(СтрокаТЧ.Сумма);                // 10 - Сумма позиции со скидкой
		СтрокаТаблицыТоваров.Добавить(0);                             // 11 - Номер налога (1)
		СтрокаТаблицыТоваров.Добавить(0);                             // 12 - Сумма налога (1)
		СтрокаТаблицыТоваров.Добавить(0);                             // 13 - Процент налога (1)
		СтрокаТаблицыТоваров.Добавить(0);                             // 14 - Номер налога (2)
		СтрокаТаблицыТоваров.Добавить(0);                             // 15 - Сумма налога (2)
		СтрокаТаблицыТоваров.Добавить(0);                             // 16 - Процент налога (2)
		СтрокаТаблицыТоваров.Добавить("");                            // 17 - Наименование секции форматирования товарной строки
		СтрокаТаблицыТоваров.Добавить(ПараметрыАлкогольнойПродукции); // 18 - Параметры алкогольной продукции
		
		ТаблицаТоваров.Добавить(СтрокаТаблицыТоваров);
		
	КонецЦикла;
	
	Отбор = Новый Структура("Поле, Значение", "ИдентификаторФСРАР", Шапка.ИдентификаторФСРАР);
	
	ТранспортныеМодули = ИнтеграцияЕГАИСВызовСервера.ДоступныеТранспортныеМодули(Отбор);
	
	Если ТранспортныеМодули.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не найдено настройки подключения к ЕГАИС'");
	КонецЕсли;
	
	ТранспортныйМодуль = ТранспортныеМодули[0];
	
	// Подготовка таблицы оплат
	ТаблицаОплат = Новый Массив();
	
	СведенияОбОрганизации = ГосударственныеИнформационныеСистемыПереопределяемый.СведенияОбОрганизацииДляПечатиЧека(ТранспортныйМодуль.Контрагент);
	
	АдресТорговогоОбъекта = ИнтеграцияЕГАИСПереопределяемый.АдресТорговогоОбъекта(ТранспортныйМодуль.ТорговыйОбъект);
	
	// Подготовка таблицы общих параметров
	ОбщиеПараметры = Новый Массив();
	ОбщиеПараметры.Добавить(0);                                            //  1 - Тип чека
	ОбщиеПараметры.Добавить(Истина);                                       //  2 - Признак фискального чека
	ОбщиеПараметры.Добавить(Неопределено);                                 //  3 - Печать на подкладном документе
	ОбщиеПараметры.Добавить(0);                                            //  4 - Сумма по чеку без скидок/наценок
	ОбщиеПараметры.Добавить(0);                                            //  5 - Сумма по чеку с учетом всех скидок/наценок
	ОбщиеПараметры.Добавить("");                                           //  6 - Номер дисконтной карты
	ОбщиеПараметры.Добавить("");                                           //  7 - Текст шапки (Для чека ЕНВД)
	ОбщиеПараметры.Добавить("");                                           //  8 - Текст подвала (Для чека ЕНВД)
	ОбщиеПараметры.Добавить(Шапка.НомерСмены);                             //  9 - Номер смены (для копии чека)
	ОбщиеПараметры.Добавить(Шапка.НомерЧекаККМ);                           // 10 - Номер чека (для копии чека)
	ОбщиеПараметры.Добавить(1);                                            // 11 - Номер документа (для копии чека)
	ОбщиеПараметры.Добавить(Шапка.Дата);                                   // 12 - Дата и время документа (для копии чека)
	ОбщиеПараметры.Добавить(Строка(Шапка.ФизическоеЛицо));                 // 13 - Имя кассира (для копии чека)
	ОбщиеПараметры.Добавить(СведенияОбОрганизации.Наименование);           // 14 - Название организации (Для чека ЕНВД)
	ОбщиеПараметры.Добавить(СведенияОбОрганизации.ИНН);                    // 15 - ИНН организации (Для чека ЕНВД)
	ОбщиеПараметры.Добавить("");                                           // 16 - Наименование секции форматирования шапки
	ОбщиеПараметры.Добавить("");                                           // 17 - Наименование секции форматирования подвала
	
	// Необходимые поля для работы ЕГАИС
	ОбщиеПараметры.Добавить(СведенияОбОрганизации.КПП);                    // 18 - КПП организации (Для ЕГАИС/Для чека ЕНВД)
	ОбщиеПараметры.Добавить(Строка(ТранспортныйМодуль.ТорговыйОбъект));    // 19 – Название магазина (Для ЕГАИС/ Для чека ЕНВД)
	ОбщиеПараметры.Добавить(АдресТорговогоОбъекта);                        // 20 – Адрес магазина (Для ЕГАИС/ Для чека ЕНВД)
	ОбщиеПараметры.Добавить(Шапка.СерийныйНомерККМ);                       // 21 – Заводской номер ККМ (Для ЕГАИС/ Для чека ЕНВД)
	
	ВходныеПараметры  = Новый Массив;
	ВходныеПараметры.Добавить(ТаблицаТоваров);
	ВходныеПараметры.Добавить(ТаблицаОплат);
	ВходныеПараметры.Добавить(ОбщиеПараметры);
	
	Возврат Новый Структура("ВходныеПараметры, ТранспортныйМодуль",
		ВходныеПараметры,
		ТранспортныйМодуль);
	
КонецФункции

Функция ДанныеДляЕГАИС(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Товары.ИдентификаторСтроки,
	|	Товары.НомерСтроки,
	|	Товары.АлкогольнаяПродукция,
	|	Товары.Количество,
	|	Товары.Цена,
	|	Товары.Сумма,
	|	Товары.Штрихкод
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.ИдентификаторСтроки,
	|	Товары.НомерСтроки,
	|	Истина КАК АлкогольнаяПродукция,
	|	Товары.АлкогольнаяПродукция КАК НоменклатураЕГАИС,
	|	Товары.Количество,
	|	Товары.Цена,
	|	Товары.Сумма,
	|	Товары.Штрихкод,
	|	Товары.АлкогольнаяПродукция.ВидПродукции             КАК ВидПродукции,
	|	Товары.АлкогольнаяПродукция.ВидПродукции.Код         КАК КодВидаАлкогольнойПродукции,
	|	Товары.АлкогольнаяПродукция.ВидПродукции.Маркируемый КАК МаркируемаяАлкогольнаяПродукция,
	|	Товары.АлкогольнаяПродукция.Объем                    КАК Объем,
	|	Товары.АлкогольнаяПродукция.Крепость                 КАК Крепость,
	|	ВЫБОР КОГДА Товары.АлкогольнаяПродукция.Импортер <> ЗНАЧЕНИЕ(Справочник.КлассификаторОрганизацийЕГАИС.ПустаяСсылка) ТОГДА
	|		Товары.АлкогольнаяПродукция.Импортер.ИНН
	|	ИНАЧЕ
	|		Товары.АлкогольнаяПродукция.Производитель.ИНН
	|	КОНЕЦ КАК ИНН,
	|	ВЫБОР КОГДА Товары.АлкогольнаяПродукция.Импортер <> ЗНАЧЕНИЕ(Справочник.КлассификаторОрганизацийЕГАИС.ПустаяСсылка) ТОГДА
	|		Товары.АлкогольнаяПродукция.Импортер.КПП
	|	ИНАЧЕ
	|		Товары.АлкогольнаяПродукция.Производитель.КПП
	|	КОНЕЦ КАК КПП,
	|	ВЫБОР КОГДА Товары.АлкогольнаяПродукция.Импортер <> ЗНАЧЕНИЕ(Справочник.КлассификаторОрганизацийЕГАИС.ПустаяСсылка) ТОГДА
	|		Товары.АлкогольнаяПродукция.Импортер
	|	ИНАЧЕ
	|		Товары.АлкогольнаяПродукция.Производитель
	|	КОНЕЦ КАК ПроизводительИмпортерАлкогольнойПродукции
	|ИЗ
	|	ТаблицаТовары КАК Товары
	|";
	
	Запрос.УстановитьПараметр("Товары", Объект.Товары.Выгрузить());
	
	МассивСтрок = Новый Массив;
	
	ТЧ = Объект.АкцизныеМарки.Выгрузить();
	ТЧ.Индексы.Добавить("ИдентификаторСтроки");
	
	ТаблицаТоваровЧека = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТЧ Из ТаблицаТоваровЧека Цикл
		
		НоваяСтрока = ИнтеграцияЕГАИСКлиентСервер.СтруктураСтрокиЧекаЕГАИС();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		
		КодыАкцизныхМарок = Новый Массив;
		НайденныеСтроки = ТЧ.НайтиСтроки(Новый Структура("ИдентификаторСтроки", СтрокаТЧ.ИдентификаторСтроки));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			КодыАкцизныхМарок.Добавить(НайденнаяСтрока.КодАкцизнойМарки);
		КонецЦикла;
		
		Если КодыАкцизныхМарок.Количество() = 1 Тогда
			НоваяСтрока.КодАкцизнойМарки = КодыАкцизныхМарок[0];
		ИначеЕсли КодыАкцизныхМарок.Количество() > 1 Тогда
			НоваяСтрока.КодАкцизнойМарки = КодыАкцизныхМарок;
		Иначе
			НоваяСтрока.КодАкцизнойМарки = "";
		КонецЕсли;
		
		МассивСтрок.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	Возврат МассивСтрок;
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляЕГАИСПоСсылке(ДокументСсылка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Товары.ИдентификаторСтроки,
	|	Товары.НомерСтроки,
	|	Товары.АлкогольнаяПродукция,
	|	Товары.Количество,
	|	Товары.Цена,
	|	Товары.Сумма,
	|	Товары.Штрихкод
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	Документ.ЧекЕГАИС.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ДокументСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АкцизныеМарки.НомерСтроки,
	|	АкцизныеМарки.ИдентификаторСтроки,
	|	АкцизныеМарки.КодАкцизнойМарки
	|ИЗ
	|	Документ.ЧекЕГАИС.АкцизныеМарки КАК АкцизныеМарки
	|ГДЕ
	|	АкцизныеМарки.Ссылка = &ДокументСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.ИдентификаторСтроки,
	|	Товары.НомерСтроки,
	|	Истина КАК АлкогольнаяПродукция,
	|	Товары.АлкогольнаяПродукция КАК НоменклатураЕГАИС,
	|	Товары.Количество,
	|	Товары.Цена,
	|	Товары.Сумма,
	|	Товары.Штрихкод,
	|	Товары.АлкогольнаяПродукция.ВидПродукции             КАК ВидПродукции,
	|	Товары.АлкогольнаяПродукция.ВидПродукции.Код         КАК КодВидаАлкогольнойПродукции,
	|	Товары.АлкогольнаяПродукция.ВидПродукции.Маркируемый КАК МаркируемаяАлкогольнаяПродукция,
	|	Товары.АлкогольнаяПродукция.Объем                    КАК Объем,
	|	Товары.АлкогольнаяПродукция.Крепость                 КАК Крепость,
	|	ВЫБОР КОГДА Товары.АлкогольнаяПродукция.Импортер <> ЗНАЧЕНИЕ(Справочник.КлассификаторОрганизацийЕГАИС.ПустаяСсылка) ТОГДА
	|		Товары.АлкогольнаяПродукция.Импортер.ИНН
	|	ИНАЧЕ
	|		Товары.АлкогольнаяПродукция.Производитель.ИНН
	|	КОНЕЦ КАК ИНН,
	|	ВЫБОР КОГДА Товары.АлкогольнаяПродукция.Импортер <> ЗНАЧЕНИЕ(Справочник.КлассификаторОрганизацийЕГАИС.ПустаяСсылка) ТОГДА
	|		Товары.АлкогольнаяПродукция.Импортер.КПП
	|	ИНАЧЕ
	|		Товары.АлкогольнаяПродукция.Производитель.КПП
	|	КОНЕЦ КАК КПП,
	|	ВЫБОР КОГДА Товары.АлкогольнаяПродукция.Импортер <> ЗНАЧЕНИЕ(Справочник.КлассификаторОрганизацийЕГАИС.ПустаяСсылка) ТОГДА
	|		Товары.АлкогольнаяПродукция.Импортер
	|	ИНАЧЕ
	|		Товары.АлкогольнаяПродукция.Производитель
	|	КОНЕЦ КАК ПроизводительИмпортерАлкогольнойПродукции
	|ИЗ
	|	ТаблицаТовары КАК Товары
	|";
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	МассивСтрок = Новый Массив;
	
	АкцизныеМарки = РезультатЗапроса[1].Выгрузить();
	АкцизныеМарки.Индексы.Добавить("ИдентификаторСтроки");
	
	ТаблицаТоваровЧека = РезультатЗапроса[2].Выгрузить();
	Для Каждого СтрокаТЧ Из ТаблицаТоваровЧека Цикл
		
		НоваяСтрока = ИнтеграцияЕГАИСКлиентСервер.СтруктураСтрокиЧекаЕГАИС();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		
		КодыАкцизныхМарок = Новый Массив;
		НайденныеСтроки = АкцизныеМарки.НайтиСтроки(Новый Структура("ИдентификаторСтроки", СтрокаТЧ.ИдентификаторСтроки));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			КодыАкцизныхМарок.Добавить(НайденнаяСтрока.КодАкцизнойМарки);
		КонецЦикла;
		
		Если КодыАкцизныхМарок.Количество() = 1 Тогда
			НоваяСтрока.КодАкцизнойМарки = КодыАкцизныхМарок[0];
		ИначеЕсли КодыАкцизныхМарок.Количество() > 1 Тогда
			НоваяСтрока.КодАкцизнойМарки = КодыАкцизныхМарок;
		Иначе
			НоваяСтрока.КодАкцизнойМарки = "";
		КонецЕсли;
		
		МассивСтрок.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	Возврат МассивСтрок;
	
КонецФункции

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
