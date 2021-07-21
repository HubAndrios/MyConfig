
#Область ПрограммныйИнтерфейс


////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС ПОЛЯ ВЫБОРА ОРГАНИЗАЦИИ С ОБОСОБЛЕННЫМИ ПОДРАЗДЕЛЕНИЯМИ
//

// Устанавливает значение поля организации.
//
// Параметры:
//	ПолеОрганизация - РеквизитФормы - Реквизит формы, в котором нужно установить значение.
//	Организация - СправочникСсылка.Организации - Организация, для которой нужно установить реквизит.
//	ВключатьОбособленныеПодразделения - Булево - Признак, что нужно включать обособленные подразделения.
//
Процедура УстановитьЗначениеПолеОрганизация(ПолеОрганизация, Организация, ВключатьОбособленныеПодразделения) Экспорт
	
	Ключ = СтрЗаменить(Строка(ВключатьОбособленныеПодразделения) + Организация.УникальныйИдентификатор(), "-", "");
	ПолеОрганизация = Ключ;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СТРОКОВЫЕ ФУНКЦИИ

// Функция возвращает строку, которая содержит только цифры из исходной строки.
//
// Параметры:
//	ИсходнаяСтрока - Строка - Исходная строка.
//
// Возвращаемое значение:
//	Строка - Строка, содержащая только цифры.
//
Функция ОставитьВСтрокеТолькоЦифры(ИсходнаяСтрока) Экспорт
	
	СтрокаРезультат = "";
	
	Для а = 1 По СтрДлина(ИсходнаяСтрока) Цикл
		ТекущийСимвол = Сред(ИсходнаяСтрока, а, 1);
		КодСимвола = КодСимвола(ТекущийСимвол);
		Если КодСимвола >= 48 И КодСимвола <= 57 Тогда
			СтрокаРезультат = СтрокаРезультат + ТекущийСимвол;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрокаРезультат;
	
КонецФункции

#КонецОбласти

#Область УстаревшийПрограммныйИнтерфейс

// Устарела. Следует использовать ОбщегоНазначения.ОписаниеТипаСтрока
// Служебная функция, предназначенная для получения описания типов строки, заданной длины.
//
// Параметры:
//  ДлинаСтроки - число, длина строки.
//
// Возвращаемое значение:
//  ОписаниеТипов - для строки указанной длины.
//
Функция ПолучитьОписаниеТиповСтроки(ДлинаСтроки) Экспорт

	Массив = Новый Массив;
	Массив.Добавить(Тип("Строка"));

	КвалификаторСтроки = Новый КвалификаторыСтроки(ДлинаСтроки, ДопустимаяДлина.Переменная);

	Возврат Новый ОписаниеТипов(Массив, , КвалификаторСтроки);

КонецФункции // ПолучитьОписаниеТиповСтроки()

// Устарела. Следует использовать ОбщегоНазначения.ОписаниеТипаЧисло.
// Служебная функция, предназначенная для получения описания типов числа, заданной разрядности.
//
// Параметры:
//  Разрядность 			- число, разряд числа.
//  РазрядностьДробнойЧасти - число, разряд дробной части.
//  ЗнакЧисла				- ДопустимыйЗнак, знак числа.
//
// Возвращаемое значение:
//  ОписаниеТипов - для числа указанной разрядности.
//
Функция ПолучитьОписаниеТиповЧисла(Разрядность, РазрядностьДробнойЧасти = 0, ЗнакЧисла = Неопределено) Экспорт

	Если ЗнакЧисла = Неопределено Тогда
		КвалификаторЧисла = Новый КвалификаторыЧисла(Разрядность, РазрядностьДробнойЧасти);
	Иначе
		КвалификаторЧисла = Новый КвалификаторыЧисла(Разрядность, РазрядностьДробнойЧасти, ЗнакЧисла);
	КонецЕсли;

	Возврат Новый ОписаниеТипов("Число", КвалификаторЧисла);

КонецФункции // ПолучитьОписаниеТиповЧисла()

// Устарела. Следует использовать ОбщегоНазначения.ОписаниеТипаДата.
// Служебная функция, предназначенная для получения описания типов даты.
//
// Параметры:
//  ЧастиДаты - системное перечисление ЧастиДаты.
//
// Возвращаемое значение:
//	ОписаниеТипов - Описание типов даты.
//
Функция ПолучитьОписаниеТиповДаты(ЧастиДаты) Экспорт

	Массив = Новый Массив;
	Массив.Добавить(Тип("Дата"));

	КвалификаторДаты = Новый КвалификаторыДаты(ЧастиДаты);

	Возврат Новый ОписаниеТипов(Массив, , , КвалификаторДаты);

КонецФункции // ПолучитьОписаниеТиповДаты()

// Устарела. Следует использовать ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения
// Формирует текст сообщения, подставляя значения
// параметров в шаблоны сообщений.
//
// Параметры
//  ВидПоля       - Строка - может принимать значения:
//                  Поле, Колонка, Список.
//  ВидСообщения  - Строка - может принимать значения:
//                  Заполнение, Корректность.
//  Параметр1     - Строка - имя поля.
//  Параметр2     - Строка - номер строки.
//  Параметр3     - Строка - имя списка.
//  Параметр4     - Строка - текст сообщения о некорректности заполнения.
//
// Возвращаемое значение:
//   Строка - Текст сообщения.
//
Функция ПолучитьТекстСообщения(ВидПоля = "Поле", ВидСообщения = "Заполнение",
	Параметр1 = "", Параметр2 = "",	Параметр3 = "", Параметр4 = "") Экспорт

	ТекстСообщения = "";

	Если ВРег(ВидПоля) = "ПОЛЕ" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru = 'Поле ""%1"" не заполнено'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru = 'Поле ""%1"" заполнено некорректно.
                           |
                           |%4'");
		КонецЕсли;
	ИначеЕсли ВРег(ВидПоля) = "КОЛОНКА" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""%3""'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru = 'Некорректно заполнена колонка ""%1"" в строке %2 списка ""%3"".
                           |
                           |%4'");
		КонецЕсли;
	ИначеЕсли ВРег(ВидПоля) = "СПИСОК" Тогда
		Если ВРег(ВидСообщения) = "ЗАПОЛНЕНИЕ" Тогда
			Шаблон = НСтр("ru = 'Не введено ни одной строки в список ""%3""'");
		ИначеЕсли ВРег(ВидСообщения) = "КОРРЕКТНОСТЬ" Тогда
			Шаблон = НСтр("ru = 'Некорректно заполнен список ""%3"".
                           |
                           |%4'");
		КонецЕсли;
	КонецЕсли;

	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Параметр1, Параметр2, Параметр3, Параметр4);

КонецФункции // ПолучитьТекстСообщения()


#КонецОбласти
