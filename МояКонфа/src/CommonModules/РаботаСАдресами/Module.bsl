#Область ПрограммныйИнтерфейс

// Возвращает наименование субъекта РФ для адреса или пустую строку, если субъект не определен.
// Если переданная строка не содержит информации об адресе, то будет вызвано исключение.
//
// Параметры:
//    XMLСтрока - Строка - Строка XML соответствующая XDTO пакету Адрес.
//
// Возвращаемое значение:
//    Строка - Наименование региона.
//
Функция РегионАдресаКонтактнойИнформации(Знач XMLСтрока) Экспорт
	
	Если ПустаяСтрока(XMLСтрока) Тогда
		Возврат "";
	КонецЕсли;
	
	ПространствоИмен = УправлениеКонтактнойИнформациейКлиентСервер.ПространствоИмен();
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(XMLСтрока);
	XDTOАдрес = ФабрикаXDTO.ПрочитатьXML(Чтение, ФабрикаXDTO.Тип(ПространствоИмен, "КонтактнаяИнформация"));
	Адрес = XDTOАдрес.Состав;
	Если Адрес = Неопределено Или Адрес.Тип() <> ФабрикаXDTO.Тип(ПространствоИмен, "Адрес") Тогда
		ВызватьИсключение НСтр("ru = 'Невозможно определить субъекта РФ, ожидается адрес.'");
	КонецЕсли;
	
	АдресРФ = Обработки.РасширенныйВводКонтактнойИнформации.НациональныйАдрес(Адрес);
	Возврат ?(АдресРФ = Неопределено, "", СокрЛП(АдресРФ.СубъектРФ));
	
КонецФункции

// Возвращает наименование города для адреса РФ или пустую строку для иностранного адреса.
// Если переданная строка не содержит информации об адресе, то будет вызвано исключение.
//
// Параметры:
//    XMLСтрока - Строка - Строка XML соответствующая XDTO пакету Адрес.
//
// Возвращаемое значение:
//    Строка - Наименование города.
//
Функция ГородАдресаКонтактнойИнформации(Знач XMLСтрока) Экспорт
	
	Если ПустаяСтрока(XMLСтрока) Тогда
		Возврат "";
	КонецЕсли;
	
	ПространствоИмен = УправлениеКонтактнойИнформациейКлиентСервер.ПространствоИмен();
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(XMLСтрока);
	XDTOАдрес = ФабрикаXDTO.ПрочитатьXML(Чтение, ФабрикаXDTO.Тип(ПространствоИмен, "КонтактнаяИнформация"));
	Адрес = XDTOАдрес.Состав;
	Если Адрес = Неопределено Или Адрес.Тип() <> ФабрикаXDTO.Тип(ПространствоИмен, "Адрес") Тогда
		ВызватьИсключение НСтр("ru = 'Невозможно определить город, ожидается адрес.'");
	КонецЕсли;
	
	АдресРФ = Обработки.РасширенныйВводКонтактнойИнформации.НациональныйАдрес(Адрес);
	Возврат ?(АдресРФ = Неопределено, "", СокрЛП(АдресРФ.Город));
	
КонецФункции

// Возвращает сведения об адресах в виде структуру частей адреса и кодов КЛАДР.
//
// Параметры:
//   Адреса                  - Массив - XDTO объекты или строки XML соответствующие XDTO пакету Адрес.
//   ДополнительныеПараметры - Структура - Параметры контактной информации:
//       * БезПредставлений - Булево - Если Истина, то поле представления адреса будет отсутствовать.
//       * КодыКЛАДР - Булево - Если Истина, то возвращает структуру с кодами КЛАДР по всем частям адреса.
//       * ПолныеНаименованияСокращений - Булево - Если Истина, то возвращает полное наименование адресных объектов.
//       * НаименованиеВключаетСокращение - Булево - Если Истина, то поля содержат сокращениям в наименованиях адресных объектов.
// Возвращаемое значение:
//   Массив - Содержит массив структур, содержимое структуры см. описание функции СведенияОбАдресе.
//
Функция СведенияОбАдресах(Адреса, ДополнительныеПараметры = Неопределено) Экспорт
	Возврат Обработки.РасширенныйВводКонтактнойИнформации.СведенияОбАдресахВВидеСтруктуры(Адреса, ДополнительныеПараметры);
КонецФункции

// Возвращает сведения об адресах в виде структуру частей адреса и кодов КЛАДР.
//
// Параметры:
//   Адрес                  - Строка, ОбъектXDTO - XDTO объект или строка XML соответствующие XDTO пакету Адрес.
//   ДополнительныеПараметры - Структура - параметры контактной информации. 
//       * БезПредставлений - Булево - Если Истина, то поле представления адреса будет отсутствовать.
//       * КодыКЛАДР - Булево - Если Истина, то возвращает структуру с кодами КЛАДР по всем частям адреса.
//       * ПолныеНаименованияСокращений - Булево - Если Истина, то возвращает полное наименование адресных объектов.
//       * НаименованиеВключаетСокращение - Булево - Если Истина, то поля содержат сокращениям в наименованиях адресных объектов.
// Возвращаемое значение:
//   Структура - набор пар ключ-значение. Состав свойств для адреса:
//        * Страна           - Строка - текстовое представление страны.
//        * КодСтраны        - Строка - код страны по ОКСМ.
//        * Индекс           - Строка - почтовый индекс.
//        * КодРегиона       - Строка - код региона РФ.
//        * Регион           - Строка - текстовое представление региона РФ.
//        * РегионСокращение - Строка - сокращение региона.
//        * Округ            - Строка - текстовое представление округа.
//        * ОкругСокращение  - Строка - сокращение округа.
//        * Район            - Строка - текстовое представление района.
//        * РайонСокращение  - Строка - сокращение района.
//        * Город            - Строка - текстовое представление города.
//        * ГородСокращение  - Строка - сокращение города.
//        * ВнутригородскойРайон - Строка - текстовое представление внутригородского района.
//        * ВнутригородскойРайонСокращение  - Строка - сокращение внутригородского района.
//        * НаселенныйПункт  - Строка - текстовое представление населенного пункта.
//        * НаселенныйПунктСокращение - Строка - сокращение населенного пункта.
//        * Улица            - Строка - текстовое представление улицы.
//        * УлицаСокращение  - Строка - сокращение улицы.
//        * ДополнительнаяТерритория - Строка - текстовое представление дополнительной территории.
//        * ДополнительнаяТерриторияСокращение - Строка - сокращение дополнительной территории.
//        * ЭлементДополнительнойТерритории - Строка - текстовое представление элемента дополнительной территории.
//        * ЭлементДополнительнойТерриторииСокращение - Строка - сокращение элемента дополнительной территории.
//        * Здание - Структура - структура с информацией о здании адреса.
//            ** ТипЗдания - Строка  - тип объекта адресации адреса РФ согласно приказу ФНС ММВ-7-1/525 от 31.08.2011.
//            ** Номер - Строка  - текстовое представление номера дома (только для адресов РФ).
//        * Корпуса - Массив - содержит структуры(поля структуры: ТипКорпуса, Номер) с перечнем корпусов адреса.
//        * Помещения - Массив - содержит структуры(поля структуры: ТипПомещения, Номер) с перечнем помещений адреса.
//        * КодыКЛАДР           - Структура - Коды КЛАДР, если установлен параметр КодыКЛАДР.
//           ** Регион          - Строка    - Код КЛАДР региона.
//           ** Район           - Строка    - Код КЛАДР район.
//           ** Город           - Строка    - Код КЛАДР города.
//           ** НаселенныйПункт - Строка    - Код КЛАДР населенного пункта.
//           ** Улица           - Строка    - Код КЛАДР улица.
//        * ДополнительныеКоды  - Структура - Коды ОКТМО, ОКТМО, ОКАТО, КодИФНСФЛ, КодИФНСЮЛ, КодУчасткаИФНСФЛ, КодУчасткаИФНСЮЛ.
Функция СведенияОбАдресе(Адрес, ДополнительныеПараметры = Неопределено) Экспорт
	Возврат Обработки.РасширенныйВводКонтактнойИнформации.СведенияОбАдресеВВидеСтруктуры(Адрес, ДополнительныеПараметры);
КонецФункции

// Преобразует адреса нового формата XML ФИАС в адрес формата КЛАДР.
//
// Параметры:
//   Данные                  - Строка - строка XML соответствующая XDTO пакету Адрес.
//
// Возвращаемое значение:
//   Структура - набор пар ключ-значение. Состав свойств для адреса:
//        ** Страна           - Строка - Представление страны.
//        ** КодСтраны        - Строка - Код страны по ОКСМ.
//        ** Индекс           - Строка - Почтовый индекс (только для адресов РФ).
//        ** Регион           - Строка - Представление региона РФ (только для адресов РФ).
//        ** КодРегиона       - Строка - Код региона РФ (только для адресов РФ).
//        ** РегионСокращение - Строка - Сокращение региона.
//        ** Район            - Строка - Представление района (только для адресов РФ).
//        ** РайонСокращение  - Строка - Сокращение района.
//        ** Город            - Строка - Представление города (только для адресов РФ).
//        ** ГородСокращение  - Строка - Сокращение города (только для адресов РФ).
//        ** НаселенныйПункт  - Строка - Представление населенного пункта (только для адресов РФ).
//        ** НаселенныйПунктСокращение - Строка - Сокращение населенного пункта.
//        ** Улица            - Строка - Представление улицы (только для адресов РФ).
//        ** УлицаСокращение  - Строка - Сокращение улицы.
//        ** ТипДома          - Строка - Тип дома см. РаботаСАдресамиКлиентСервер.ТипыОбъектовАдресацииАдресаРФ.
//        ** Дом              - Строка - Представление дома (только для адресов РФ).
//        ** ТипКорпуса       - Строка - Тип корпуса см. РаботаСАдресамиКлиентСервер.ТипыОбъектовАдресацииАдресаРФ.
//        ** Корпус           - Строка - Представление корпуса (только для адресов РФ).
//        ** ТипКвартиры      - Строка - Тип квартиры см. РаботаСАдресамиКлиентСервер.ТипыОбъектовАдресацииАдресаРФ.
//        ** Квартира         - Строка - Представление квартиры (только для адресов РФ).
//        ** АдресРФ          - Булево - Если Истина, то адрес российский.
//        ** Представление    - Строка - Представление адреса.
//
Функция АдресВФорматеКЛАДР(Знач Данные) Экспорт
	
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(Данные) Тогда
		// Новый формат КИ
		Результат = УправлениеКонтактнойИнформациейКлиентСервер.СтруктураЗначенийПолей(
				ПредыдущийФорматКонтактнойИнформацииXML(Данные));
			Представление = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Данные);
			
	ИначеЕсли ПустаяСтрока(Данные) Тогда
		// Генерируем пустую структуру по виду
		Результат = РаботаСАдресамиКлиентСервер.СтруктураКонтактнойИнформацииПоТипу(
			Перечисления.ТипыКонтактнойИнформации.Адрес);
		Представление = "";
	КонецЕсли;
	
	Если Результат.Свойство("Страна") И СтрСравнить(Результат.Страна, ОсновнаяСтрана().Наименование) = 0 Тогда
		Результат.Вставить("АдресРФ", Истина);
	Иначе
		Результат.Вставить("АдресРФ", Ложь);
	КонецЕсли;
	Результат.Вставить("Представление", Представление);
	
	Возврат Результат;
КонецФункции

// Проверяет адрес на соответствие требованиям к адресной информации.
//
// Параметры:
//   АдресВXML          - Строка - Строка XML соответствующая XDTO пакету Адрес.
//   ПараметрыПроверки  - Структура, СправочникСсылка.ВидыКонтактнойИнформации - Флаги проверки адреса:
//          ТолькоНациональныйАдрес - Булево - Адрес должен быть только Российским. По умолчанию ИСТИНА.
//          ФорматАдреса - Строка - По какому классификатору проверять "КЛАДР" или "ФИАС". По умолчанию "КЛАДР".
// Возвращаемое значение:
//   Структура - содержит структуру с полями:
//        * Результат - Строка - Результат проверки: "Корректный", "НеПроверен", "СодержитОшибки".
//        * СписокОшибок - СписокЗначений - Информация о ошибках.
Функция ПроверитьАдрес(Знач АдресВXML, ПараметрыПроверки = Неопределено) Экспорт
	Возврат УправлениеКонтактнойИнформациейСлужебный.ПроверитьАдресВXML(АдресВXML, ПараметрыПроверки);
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обратная совместимость.

// Преобразует данные формата XML в предыдущий формат контактной информации.
//
// Параметры:
//    Данные                 - Строка - Строка XML соответствующая XDTO пакету Адрес.
//    СокращенныйСоставПолей - Булево - Если Ложь, то из состава полей будут исключены
//                                      поля, отсутствующие в версиях БСП младше 2.1.3.
//
// Возвращаемое значение:
//    Строка - набор пар ключ-значение, разделенных переносом строки.
//
Функция ПредыдущийФорматКонтактнойИнформацииXML(Знач Данные, Знач СокращенныйСоставПолей = Ложь) Экспорт
	
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(Данные) Тогда
		СтарыйФормат = Обработки.РасширенныйВводКонтактнойИнформации.КонтактнаяИнформацияВСтаруюСтруктуру(Данные, СокращенныйСоставПолей);
		Возврат РаботаСАдресамиКлиентСервер.ПреобразоватьСписокПолейВСтроку(СтарыйФормат.ЗначенияПолей, Ложь);
	КонецЕсли;
	
	Возврат Данные;
КонецФункции

// Преобразует данные нового формата XML контактной информации в структуру старого формата.
//
// Параметры:
//   Данные                  - Строка - Строка XML соответствующая XDTO пакету Адрес.
//   ВидКонтактнойИнформации - СправочникСсылка.ВидыКонтактнойИнформации, Структура - Параметры контактной информации.
//     * Тип - ПеречислениеСсылка.ТипыКонтактнойИнформации - Тип контактной информации.
//
// Возвращаемое значение:
//   Структура - набор пар ключ-значение. Состав свойств для адреса:
//        ** Страна           - Строка - Представление страны.
//        ** КодСтраны        - Строка - Код страны по ОКСМ.
//        ** Индекс           - Строка - Почтовый индекс (только для адресов РФ).
//        ** Регион           - Строка - Представление региона РФ (только для адресов РФ).
//        ** КодРегиона       - Строка - Код региона РФ (только для адресов РФ).
//        ** РегионСокращение - Строка - Сокращение региона (если СтарыйСоставПолей = Ложь).
//        ** Район            - Строка - Представление района (только для адресов РФ).
//        ** РайонСокращение  - Строка - Сокращение района (если СтарыйСоставПолей = Ложь).
//        ** Город            - Строка - Представление города (только для адресов РФ).
//        ** ГородСокращение  - Строка - Сокращение города (только для адресов РФ).
//        ** НаселенныйПункт  - Строка - Представление населенного пункта (только для адресов РФ).
//        ** НаселенныйПунктСокращение - Строка - сокращение населенного пункта (если СтарыйСоставПолей = Ложь).
//        ** Улица            - Строка - Представление улицы (только для адресов РФ).
//        ** УлицаСокращение  - Строка - Сокращение улицы (если СтарыйСоставПолей = Ложь).
//        ** ТипДома          - Строка - Тип дома см. РаботаСАдресамиКлиентСервер.ТипыОбъектовАдресацииАдресаРФ.
//        ** Дом              - Строка - Представление дома (только для адресов РФ).
//        ** ТипКорпуса       - Строка - Тип корпуса см. РаботаСАдресамиКлиентСервер.ТипыОбъектовАдресацииАдресаРФ.
//        ** Корпус           - Строка - Представление корпуса (только для адресов РФ).
//        ** ТипКвартиры      - Строка - Тип квартиры см. РаботаСАдресамиКлиентСервер.ТипыОбъектовАдресацииАдресаРФ.
//        ** Квартира         - Строка - Представление квартиры (только для адресов РФ).
//       Состав свойств для телефона:
//        ** КодСтраны        - Строка - Код страны. Например, +7.
//        ** КодГорода        - Строка - Код города. Например, 495.
//        ** НомерТелефона    - Строка - Номер телефона.
//        ** Добавочный       - Строка - Добавочный номер телефона.
//
Функция ПредыдущаяСтруктураКонтактнойИнформацииXML(Знач Данные, Знач ВидКонтактнойИнформации = Неопределено) Экспорт
	
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(Данные) Тогда
		// Новый формат КИ
		Возврат УправлениеКонтактнойИнформациейКлиентСервер.СтруктураЗначенийПолей(
			ПредыдущийФорматКонтактнойИнформацииXML(Данные));
		
	ИначеЕсли ПустаяСтрока(Данные) И ВидКонтактнойИнформации <> Неопределено Тогда
		// Генерируем по виду
		Возврат УправлениеКонтактнойИнформациейКлиентСервер.СтруктураКонтактнойИнформацииПоТипу(
			ВидКонтактнойИнформации.Тип);
		
	КонецЕсли;
	
	Если ВидКонтактнойИнформации <> Неопределено
		И ((ТипЗнч(ВидКонтактнойИнформации) = Тип("Структура") И ВидКонтактнойИнформации.Свойство("Тип"))
		ИЛИ ТипЗнч(ВидКонтактнойИнформации) = Тип("СправочникСсылка.ВидыКонтактнойИнформации")) Тогда
			ТипКонтактнойИнформации = ВидКонтактнойИнформации.Тип;
	Иначе
		ТипКонтактнойИнформации = Неопределено;
	КонецЕсли;
	
	// Возвращаем полную структуру для данного вида с заполненными полями.
	Результат = РаботаСАдресамиКлиентСервер.СтруктураКонтактнойИнформацииПоТипу(ТипКонтактнойИнформации);
	СтруктураЗначенийПолей = УправлениеКонтактнойИнформациейКлиентСервер.СтруктураЗначенийПолей(Данные, ВидКонтактнойИнформации);
	Если ТипКонтактнойИнформации <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Результат, СтруктураЗначенийПолей);
		Возврат Результат;
	КонецЕсли;
	
	Возврат СтруктураЗначенийПолей;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Определяет страну по умолчанию.
// 
// Возвращаемое значение:
//  СправочникСсылка.СтраныМира - Ссылка на элемент справочника страны мира страны по умолчанию.
//
Функция ОсновнаяСтрана() Экспорт
	Возврат Справочники.СтраныМира.Россия;
КонецФункции

// Возвращает пространство имен для оперирования с XDTO контактной информации.
//
// Возвращаемое значение:
//      Строка - пространство имен.
//
Функция ПространствоИмен() Экспорт
	Возврат "http://www.v8.1c.ru/ssl/contactinfo_ru";
КонецФункции

// Преобразует XML. Обратная совместимость.
//
Функция ПередЧтениемXDTOКонтактнаяИнформация(ТекстXML) Экспорт
	
	Если СтрНайти(ТекстXML, "Адрес") = 0 Тогда
		Возврат ТекстXML;
	КонецЕсли;
	
	Если СтрНайти(ТекстXML, "http://www.v8.1c.ru/ssl/contactinfo_ru") > 0 Тогда
		Возврат ТекстXML;
	КонецЕсли;
	
	ТекстXML = СтрЗаменить(ТекстXML, "xsi:type=""АдресРФ""", "xmlns:rf=""http://www.v8.1c.ru/ssl/contactinfo_ru"" xsi:type=""rf:АдресРФ""");
	
	ТекстXML = СтрЗаменить(ТекстXML, "<СубъектРФ", "<rf:СубъектРФ");
	ТекстXML = СтрЗаменить(ТекстXML, "/СубъектРФ>", "/rf:СубъектРФ>");
	ТекстXML = СтрЗаменить(ТекстXML, "<СубъектРФ/>", "<rf:СубъектРФ/>");
	
	ТекстXML = СтрЗаменить(ТекстXML, "<Округ", "<rf:Округ");
	ТекстXML = СтрЗаменить(ТекстXML, "/Округ>", "/rf:Округ>");
	ТекстXML = СтрЗаменить(ТекстXML, "<Округ/>", "<rf:Округ/>");
	
	ТекстXML = СтрЗаменить(ТекстXML, "<СвРайМО", "<rf:СвРайМО");
	ТекстXML = СтрЗаменить(ТекстXML, "/СвРайМО>", "/rf:СвРайМО>");
	ТекстXML = СтрЗаменить(ТекстXML, "<СвРайМО/>", "<rf:СвРайМО/>");
	
	ТекстXML = СтрЗаменить(ТекстXML, "<Район", "<rf:Район");
	ТекстXML = СтрЗаменить(ТекстXML, "/Район>", "/rf:Район>");
	ТекстXML = СтрЗаменить(ТекстXML, "</Район>", "</rf:Район>");
	
	ТекстXML = СтрЗаменить(ТекстXML, "<Город", "<rf:Город");
	ТекстXML = СтрЗаменить(ТекстXML, "/Город>", "/rf:Город>");
	ТекстXML = СтрЗаменить(ТекстXML, "<Город/>", "<rf:Город/>");
	
	ТекстXML = СтрЗаменить(ТекстXML, "ВнутригРайон", "rf:ВнутригРайон");
	
	ТекстXML = СтрЗаменить(ТекстXML, "НаселПункт", "rf:НаселПункт");
	
	ТекстXML = СтрЗаменить(ТекстXML, "<Улица", "<rf:Улица");
	ТекстXML = СтрЗаменить(ТекстXML, "/Улица>", "/rf:Улица>");
	ТекстXML = СтрЗаменить(ТекстXML, "<Улица/>", "<rf:Улица/>");
	
	ТекстXML = СтрЗаменить(ТекстXML, "ОКТМО", "rf:ОКТМО");
	ТекстXML = СтрЗаменить(ТекстXML, "ОКАТО", "rf:ОКАТО");
	
	ТекстXML = СтрЗаменить(ТекстXML, "ДопАдрЭл", "rf:ДопАдрЭл");
	
	ТекстXML = СтрЗаменить(ТекстXML, "<Номер", "<rf:Номер");
	ТекстXML = СтрЗаменить(ТекстXML, "/Номер>", "/rf:Номер>");
	ТекстXML = СтрЗаменить(ТекстXML, "<Номер/>", "<rf:Номер/>");
	
	ТекстXML = СтрЗаменить(ТекстXML, "<Местоположение", "<rf:Местоположение");
	ТекстXML = СтрЗаменить(ТекстXML, "/Местоположение>", "/rf:Местоположение>");
	ТекстXML = СтрЗаменить(ТекстXML, "<Местоположение/>", "<rf:Местоположение/>");
	
	Возврат ТекстXML;
	
КонецФункции

Функция ПередЗаписьюXDTOКонтактнаяИнформация(ТекстXML) Экспорт
	
	Позиция = СтрНайти(ТекстXML, "АдресРФ""");
	Если Позиция > 0 Тогда
		ПозицияНачало = СтрНайти(ТекстXML, """", НаправлениеПоиска.СКонца, Позиция);
		Префикс = Сред(ТекстXML, ПозицияНачало + 1, Позиция - ПозицияНачало - 2);
		
		ТекстXML = СтрЗаменить(ТекстXML, Префикс +":", "");
		ТекстXML = СтрЗаменить(ТекстXML, " xmlns:"+ Префикс + "=""http://www.v8.1c.ru/ssl/contactinfo_ru""", "");
	КонецЕсли;
	
	Возврат ТекстXML;
КонецФункции

Функция ДополнительныеПравилаПреобразования() Экспорт
	
	КодыДополнительныхАдресныхЭлементов = Новый ТекстовыйДокумент;
	Для Каждого ДополнительныйАдресныйЭлемент Из РаботаСАдресамиКлиентСервер.ТипыОбъектовАдресацииАдресаРФ() Цикл
		КодыДополнительныхАдресныхЭлементов.ДобавитьСтроку("<data:item data:title=""" + ДополнительныйАдресныйЭлемент.Наименование + """>" + ДополнительныйАдресныйЭлемент.Код + "</data:item>");
		КодыДополнительныхАдресныхЭлементов.ДобавитьСтроку("<data:item data:title=""" + НРег(ДополнительныйАдресныйЭлемент.Наименование) + """>" + ДополнительныйАдресныйЭлемент.Код + "</data:item>");
	КонецЦикла;
	
	КодыРегионов = Новый ТекстовыйДокумент;
	ВсеРегионы = ВсеРегионы();
	Если ВсеРегионы <> Неопределено Тогда
		Для Каждого Строка Из ВсеРегионы Цикл
			КодыРегионов.ДобавитьСтроку("<data:item data:code=""" + Формат(Строка.КодСубъектаРФ, "ЧН=; ЧГ=") + """>" 
			+ Строка.Представление + "</data:item>");
		КонецЦикла;
	КонецЕсли;
	
	РасширенныйТекстПреобразования = "
	|  <xsl:template match=""/"" mode=""domestic"">
	|    <xsl:element name=""Состав"">
	|      <xsl:attribute name=""xsi:type"">АдресРФ</xsl:attribute>
	|    
	|      <xsl:element name=""СубъектРФ"">
	|        <xsl:variable name=""value"" select=""tns:Structure/tns:Property[@name='Регион']/tns:Value/text()"" />
	|
	|        <xsl:choose>
	|          <xsl:when test=""0=count($value)"">
	|            <xsl:variable name=""regioncode"" select=""tns:Structure/tns:Property[@name='КодРегиона']/tns:Value/text()""/>
	|            <xsl:variable name=""regiontitle"" select=""$enum-regioncode-nodes/data:item[@data:code=number($regioncode)]"" />
	|              <xsl:if test=""0!=count($regiontitle)"">
	|                <xsl:value-of select=""$regiontitle""/>
	|              </xsl:if>
	|          </xsl:when>
	|          <xsl:otherwise>
	|            <xsl:value-of select=""$value"" />
	|          </xsl:otherwise> 
	|        </xsl:choose>
	|
	|      </xsl:element>
	|   
	|      <xsl:element name=""Округ"">
	|        <xsl:value-of select=""tns:Structure/tns:Property[@name='Округ']/tns:Value/text()""/>
	|      </xsl:element>
	|
	|      <xsl:element name=""СвРайМО"">
	|        <xsl:element name=""Район"">
	|          <xsl:value-of select=""tns:Structure/tns:Property[@name='Район']/tns:Value/text()""/>
	|        </xsl:element>
	|      </xsl:element>
	|  
	|      <xsl:element name=""Город"">
	|        <xsl:value-of select=""tns:Structure/tns:Property[@name='Город']/tns:Value/text()""/>
	|      </xsl:element>
	|    
	|      <xsl:element name=""ВнутригРайон"">
	|        <xsl:value-of select=""tns:Structure/tns:Property[@name='ВнутригРайон']/tns:Value/text()""/>
	|      </xsl:element>
	|
	|      <xsl:element name=""НаселПункт"">
	|        <xsl:value-of select=""tns:Structure/tns:Property[@name='НаселенныйПункт']/tns:Value/text()""/>
	|      </xsl:element>
	|
	|      <xsl:element name=""Улица"">
	|        <xsl:value-of select=""tns:Structure/tns:Property[@name='Улица']/tns:Value/text()""/>
	|      </xsl:element>
	|
	|      <xsl:variable name=""index"" select=""tns:Structure/tns:Property[@name='Индекс']/tns:Value/text()"" />
	|      <xsl:if test=""0!=count($index)"">
	|        <xsl:element name=""ДопАдрЭл"">
	|          <xsl:attribute name=""ТипАдрЭл"">" + РаботаСАдресамиКлиентСервер.КодСериализацииПочтовогоИндекса() + "</xsl:attribute>
	|          <xsl:attribute name=""Значение""><xsl:value-of select=""$index""/></xsl:attribute>
	|        </xsl:element>
	|      </xsl:if>
	|
	|      <xsl:call-template name=""add-elem-number"">
	|        <xsl:with-param name=""source"" select=""tns:Structure/tns:Property[@name='ТипДома']/tns:Value/text()"" />
	|        <xsl:with-param name=""defsrc"" select=""'Дом'"" />
	|        <xsl:with-param name=""value""  select=""tns:Structure/tns:Property[@name='Дом']/tns:Value/text()"" />
	|      </xsl:call-template>
	|
	|      <xsl:call-template name=""add-elem-number"">
	|        <xsl:with-param name=""source"" select=""tns:Structure/tns:Property[@name='ТипКорпуса']/tns:Value/text()"" />
	|        <xsl:with-param name=""defsrc"" select=""'Корпус'"" />
	|        <xsl:with-param name=""value""  select=""tns:Structure/tns:Property[@name='Корпус']/tns:Value/text()"" />
	|      </xsl:call-template>
	|
	|      <xsl:call-template name=""add-elem-number"">
	|        <xsl:with-param name=""source"" select=""tns:Structure/tns:Property[@name='ТипКвартиры']/tns:Value/text()"" />
	|        <xsl:with-param name=""defsrc"" select=""'Квартира'"" />
	|        <xsl:with-param name=""value""  select=""tns:Structure/tns:Property[@name='Квартира']/tns:Value/text()"" />
	|      </xsl:call-template>
	|    
	|    </xsl:element>
	|  </xsl:template>
	|
	|  <xsl:param name=""enum-codevalue"">
	|" + КодыДополнительныхАдресныхЭлементов.ПолучитьТекст() + "
	|  </xsl:param>
	|  <xsl:variable name=""enum-codevalue-nodes"" select=""exsl:node-set($enum-codevalue)"" />
	|
	|  <xsl:param name=""enum-regioncode"">
	|" + КодыРегионов.ПолучитьТекст() + "
	|  </xsl:param>
	|  <xsl:variable name=""enum-regioncode-nodes"" select=""exsl:node-set($enum-regioncode)"" />
	|  
	|  <xsl:template name=""add-elem-number"">
	|    <xsl:param name=""source"" />
	|    <xsl:param name=""defsrc"" />
	|    <xsl:param name=""value"" />
	|
	|    <xsl:if test=""0!=count($value)"">
	|
	|      <xsl:choose>
	|        <xsl:when test=""0!=count($source)"">
	|          <xsl:variable name=""type-code"" select=""$enum-codevalue-nodes/data:item[@data:title=$source]"" />
	|          <xsl:element name=""ДопАдрЭл"">
	|            <xsl:element name=""Номер"">
	|              <xsl:attribute name=""Тип""><xsl:value-of select=""$type-code"" /></xsl:attribute>
	|              <xsl:attribute name=""Значение""><xsl:value-of select=""$value""/></xsl:attribute>
	|            </xsl:element>
	|          </xsl:element>
	|
	|        </xsl:when>
	|        <xsl:otherwise>
	|          <xsl:variable name=""type-code"" select=""$enum-codevalue-nodes/data:item[@data:title=$defsrc]"" />
	|          <xsl:element name=""ДопАдрЭл"">
	|            <xsl:element name=""Номер"">
	|              <xsl:attribute name=""Тип""><xsl:value-of select=""$type-code"" /></xsl:attribute>
	|              <xsl:attribute name=""Значение""><xsl:value-of select=""$value""/></xsl:attribute>
	|            </xsl:element>
	|          </xsl:element>
	|
	|        </xsl:otherwise>
	|      </xsl:choose>
	|
	|    </xsl:if>
	|  
	|  </xsl:template>
	|  
	|</xsl:stylesheet>";
	
	Возврат РасширенныйТекстПреобразования;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает список всех регионов адресного классификатора.
//
// Возвращаемое значение:
//   ТаблицаЗначений - содержит колонки:
//      * КодСубъектаРФ - Число                   - Код региона.
//      * Идентификатор - УникальныйИдентификатор - Идентификатор региона.
//      * Представление - Строка                  - Наименование и сокращение региона.
//      * Загружено     - Булево                  - Истина, если классификатор по данному региону сейчас загружен.
//      * ДатаВерсии    - Дата                    - UTC версия загруженных данных.
//   Неопределено    - если нет подсистемы адресного классификатора.
// 
Функция ВсеРегионы()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
		МодульАдресныйКлассификаторСлужебный = ОбщегоНазначения.ОбщийМодуль("АдресныйКлассификаторСлужебный");
		Возврат МодульАдресныйКлассификаторСлужебный.СведенияОЗагрузкеСубъектовРФ();
	КонецЕсли;
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

