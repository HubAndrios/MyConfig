#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Позволяет переопределить настройки плана обмена, заданные по умолчанию.
// Значения настроек по умолчанию см. в ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию
// 
// Параметры:
//	Настройки - Структура - Сеодержит настройки по умолчанию
//
Процедура ОпределитьНастройки(Настройки, ИдентификаторНастройки = "") Экспорт
	
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	Настройки.ПутьКФайлуКомплектаПравилНаПользовательскомСайте = "https://users.v8.1c.ru/distribution/project/Retail22";
	Настройки.ПутьКФайлуКомплектаПравилВКаталогеШаблонов = "\1c\Retail";
	
КонецПроцедуры

// Возвращает признак использования плана обмена для организации обмена в модели сервиса.
//  Если признак установлен, то в сервисе можно включить обмен данными
//  с использованием этого плана обмена.
//  Если признак не установлен, то план обмена будет использоваться только 
//  для обмена в локальном режиме работы конфигурации.
// 
Функция ПланОбменаИспользуетсяВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает признак того, что план обмена поддерживает обмен данными с корреспондентом, работающим в модели сервиса.
// Если признак установлен, то становится возможным создать обмен данными когда эта информационная база
// работает в локальном режиме, а корреспондент в модели сервиса.
//
Функция КорреспондентВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

Функция ОбщиеДанныеУзлов(ВерсияКорреспондента, ИмяФормы) Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПояснениеДляНастройкиПараметровУчета() Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПояснениеДляНастройкиПараметровУчетаБазыКорреспондента(ВерсияКорреспондента) Экспорт
	
	Возврат "";
	
КонецФункции

Процедура ОбработчикПроверкиПараметровУчета(Отказ, Получатель, Сообщение) Экспорт
	
КонецПроцедуры

#Область ПроцедурыИФункцииБсп

// Предназначена для настройки вариантов интерактивной настройки выгрузки по сценарию узла.
// Для настройки необходимо установить значения свойств параметров в необходимые значения.
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого производится настройка
//     Параметры  - Структура        - Параметры для изменения. Содержит поля:
//
//         ВариантБезДополнения - Структура     - настройки типового варианта "Не добавлять".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 1.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантВсеДокументы - Структура      - настройки типового варианта "Добавить все документы за период".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 2.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантПроизвольныйОтбор - Структура - настройки типового варианта "Добавить данные с произвольным отбором".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 3.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантДополнительно - Структура     - настройки дополнительного варианта по сценарию узла.
//                                                Содержит поля:
//             Использование            - Булево            - флаг разрешения использования варианта. По умолчанию Ложь.
//             Порядок                  - Число             - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 4.
//             Заголовок                - Строка            - название варианта для отображения на форме.
//             ИмяФормыОтбора           - Cтрока            - Имя формы, вызываемой для редактирования настроек.
//             ЗаголовокКомандыФормы    - Cтрока            - Заголовок для отрисовки на форме команды открытия формы настроек.
//             ИспользоватьПериодОтбора - Булево            - флаг того, что необходим общий отбор по периоду. По умолчанию Ложь.
//             ПериодОтбора             - СтандартныйПериод - значение периода общего отбора, предлагаемого по умолчанию.
//
//             Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла.
//                                                            Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор которого описывает строка.
//                                                               Например "Документ._ДемоПоступлениеТоваров". Можно  использовать специальные 
//                                                               значения "ВсеДокументы" и "ВсеСправочники" для отбора соответственно всех 
//                                                               документов и всех справочников, регистрирующихся на узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки, предлагаемого по умолчанию.
//                 Отбор               - ОтборКомпоновкиДанных - отбор по умолчанию. Поля отбора формируются в соответствии с общим правилами
//                                                               формирования полей компоновки. Например, для указания отбора по реквизиту
//                                                               документа "Организация", необходимо использовать поле "Ссылка.Организация"
//
Процедура НастроитьИнтерактивнуюВыгрузку(Получатель, Параметры) Экспорт
	
	
КонецПроцедуры

// Возвращает имя файла настроек по умолчанию;
// В этот файл будут выгружены настройки обмена для приемника;
// Это значение должно быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  Строка, 255 - имя файла по умолчанию для выгрузки настроек обмена данными
//
Функция ИмяФайлаНастроекДляПриемника() Экспорт
	
	Возврат "Настройки обмена УТ11.3-РТ2.2";
	
КонецФункции

// Определяет несколько вариантов настройки расписания выполнения обмена данными;
// Рекомендуется указывать не более 3 вариантов;
// Эти варианты должны быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  ВариантыНастройки - СписокЗначений - список расписаний обмена данными
//
Функция ВариантыНастройкиРасписания() Экспорт
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);
	
	// Расписание №1
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	
	Расписание1 = Новый РасписаниеРегламентногоЗадания;
	Расписание1.ДниНедели                = ДниНедели;
	Расписание1.ПериодПовтораВТечениеДня = 900; // 15 минут
	Расписание1.ПериодПовтораДней        = 1; // каждый день
	Расписание1.Месяцы                   = Месяцы;
	
	// Расписание №2
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	ДниНедели.Добавить(7);
	
	Расписание2 = Новый РасписаниеРегламентногоЗадания;
	Расписание2.ВремяНачала              = Дата('00010101080000');
	Расписание2.ВремяКонца               = Дата('00010101200000');
	Расписание2.ПериодПовтораВТечениеДня = 3600; // каждый час
	Расписание2.ПериодПовтораДней        = 1; // каждый день
	Расписание2.ДниНедели                = ДниНедели;
	Расписание2.Месяцы                   = Месяцы;
	
	// Расписание №3
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	
	Расписание3 = Новый РасписаниеРегламентногоЗадания;
	Расписание3.ДниНедели         = ДниНедели;
	Расписание3.ВремяНачала       = Дата('00010101020000');
	Расписание3.ПериодПовтораДней = 1; // каждый день
	Расписание3.Месяцы            = Месяцы;
	
	// возвращаемое значение функции
	ВариантыНастройки = Новый СписокЗначений;
	
	ВариантыНастройки.Добавить(Расписание1, "Один раз в 15 минут, кроме субботы и воскресенья");
	ВариантыНастройки.Добавить(Расписание2, "Каждый час с 8:00 до 20:00, ежедневно");
	ВариантыНастройки.Добавить(Расписание3, "Каждую ночь в 2:00, кроме субботы и воскресенья");
	
	Возврат ВариантыНастройки;
КонецФункции

// Возвращает структуру отборов на узле плана обмена с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена
// 
Функция НастройкаОтборовНаУзле(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки = "") Экспорт
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ДатаНачалаВыгрузкиДокументов", НачалоГода(ТекущаяДата()));
	СтруктураНастроек.Вставить("ВыгружатьСебестоимость", Ложь);
	СтруктураНастроек.Вставить("ВыгружатьИзображенияНоменклатуры", Ложь);
	СтруктураНастроек.Вставить("ИспользоватьОтборПоВидамЦен", Ложь);
	СтруктураНастроек.Вставить("ИспользоватьОтборПоКассам", Ложь);
	СтруктураНастроек.Вставить("ИспользоватьОтборПоОрганизациям", Ложь);
	СтруктураТабличнойЧастиВидыЦен = Новый Структура("ВидЦен", Новый Массив);
	СтруктураНастроек.Вставить("ВидыЦен", СтруктураТабличнойЧастиВидыЦен);
	СтруктураТабличнойЧастиКассы = Новый Структура("Касса", Новый Массив);
	СтруктураНастроек.Вставить("Кассы", СтруктураТабличнойЧастиКассы);
	СтруктураТабличнойЧастиКассыМагазинов = Новый Структура("Касса", Новый Массив);
	СтруктураНастроек.Вставить("КассыМагазинов", СтруктураТабличнойЧастиКассыМагазинов);
	СтруктураТабличнойЧастиОрганизации = Новый Структура("Организация", Новый Массив);
	СтруктураНастроек.Вставить("Организации", СтруктураТабличнойЧастиОрганизации);
	СтруктураТабличнойЧастиМагазины = Новый Структура("Магазин", Новый Массив);
	СтруктураНастроек.Вставить("Магазины", СтруктураТабличнойЧастиМагазины);
	СтруктураТабличнойЧастиСоответствияАналитикиОбмена = Новый Структура("Магазин, Подразделение", Новый Массив, Новый Массив);
	СтруктураНастроек.Вставить("СоответствияАналитикиОбмена", СтруктураТабличнойЧастиСоответствияАналитикиОбмена);
	Возврат СтруктураНастроек;

КонецФункции

// Возвращает структуру значений по умолчению для узла;
// Структура настроек повторяет состав реквизитов шапки плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура значений по умолчанию на узле плана обмена
// 
Функция ЗначенияПоУмолчаниюНаУзле(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки = "") Экспорт
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("РежимВыгрузкиПриНеобходимости", Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости);
	СтруктураНастроек.Вставить("СтатьяДоходов", ПланыВидовХарактеристик.СтатьиДоходов.ПустаяСсылка());
	СтруктураНастроек.Вставить("СтатьяРасходов", ПланыВидовХарактеристик.СтатьиРасходов.ПустаяСсылка());
	СтруктураНастроек.Вставить("Соглашение", Справочники.СоглашенияСКлиентами.ПустаяСсылка());
	СтруктураНастроек.Вставить("ГруппаДоступаНоменклатуры", Справочники.ГруппыДоступаНоменклатуры.ПустаяСсылка());
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает строку описания ограничений миграции данных для пользователя;
// Прикладной разработчик на основе установленных отборов на узле должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена,
//                                       полученная при помощи функции НастройкаОтборовНаУзле().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания ограничений миграции данных для пользователя
//
Функция ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки = "") Экспорт
	
	ОграничениеДатаНачалаВыгрузкиДокументов = "";
	ОпцияВыгрузкиСебестоимости = "";
	ОпцияВыгрузкиИзображений = "";
	ОграничениеОтборПоОрганизациям = "";
	ОграничениеОтборПоКассам = "";
	ОграничениеОтборПоВидамЦен = "";
	ОграничениеОтборПоМагазинам = "";
	
	Если ЗначениеЗаполнено(НастройкаОтборовНаУзле.ДатаНачалаВыгрузкиДокументов) Тогда
		НСтрока = НСтр("ru = 'Начиная с %1'");
		ОграничениеДатаНачалаВыгрузкиДокументов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока, Формат(НастройкаОтборовНаУзле.ДатаНачалаВыгрузкиДокументов, "ДЛФ=DD"));		
	Иначе		
		ОграничениеДатаНачалаВыгрузкиДокументов = НСтр("ru = 'За весь период ведения учета в программе'");
	КонецЕсли;
	
	Если НастройкаОтборовНаУзле.ВыгружатьСебестоимость Тогда
		ОпцияВыгрузкиСебестоимости = НСтр("ru = 'Выгрузка себестоимости: включено'");
	Иначе
		ОпцияВыгрузкиСебестоимости = НСтр("ru = 'Выгрузка себестоимости: выключено'");
	КонецЕсли;	

	Если НастройкаОтборовНаУзле.ВыгружатьИзображенияНоменклатуры Тогда
		ОпцияВыгрузкиИзображений = НСтр("ru = 'Выгрузка изображений номенклатуры: включено'");
	Иначе
		ОпцияВыгрузкиИзображений = НСтр("ru = 'Выгрузка изображений номенклатуры: выключено'");
	КонецЕсли;	
	
	Если НастройкаОтборовНаУзле.ИспользоватьОтборПоОрганизациям Тогда
		СтрокаПредставленияОтбора = СтрСоединить(НастройкаОтборовНаУзле.Организации.Организация, "; ");
		НСтрока = НСтр("ru = 'Только по организациям: %1'");
		ОграничениеОтборПоОрганизациям = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока, СтрокаПредставленияОтбора);	
	Иначе		
		ОграничениеОтборПоОрганизациям = НСтр("ru = 'По всем организациям'");
	КонецЕсли;

	Если НастройкаОтборовНаУзле.ИспользоватьОтборПоКассам Тогда
		СтрокаПредставленияОтбора = СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(НастройкаОтборовНаУзле.Кассы.Касса, "; ");
		НСтрока = НСтр("ru = 'Только по кассам: %1'");
		ОграничениеОтборПоКассам = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока, СтрокаПредставленияОтбора);
	Иначе		
		ОграничениеОтборПоКассам = НСтр("ru = 'По всем кассам'");
	КонецЕсли;

	Если НастройкаОтборовНаУзле.ИспользоватьОтборПоВидамЦен Тогда
		СтрокаПредставленияОтбора = СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(НастройкаОтборовНаУзле.ВидыЦен.ВидЦен, "; ");
		НСтрока = НСтр("ru = 'Только по видам цен: %1'");
		ОграничениеОтборПоВидамЦен = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока, СтрокаПредставленияОтбора);
	Иначе		
		ОграничениеОтборПоВидамЦен = НСтр("ru = 'По всем видам цен'");
	КонецЕсли;

	Если НастройкаОтборовНаУзле.Магазины.Магазин.Количество() > 0 Тогда
		СтрокаПредставленияОтбора = СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(НастройкаОтборовНаУзле.Магазины.Магазин, "; ");
		НСтрока = НСтр("ru = 'Только по магазинам: %1'");
		ОграничениеОтборПоМагазинам = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока, СтрокаПредставленияОтбора);
	Иначе		
		ОграничениеОтборПоМагазинам = НСтр("ru = 'По всем розничным магазинам'"); 
	КонецЕсли;
	
	НСтрока = НСтр("ru = 'Выгружать документы и справочную информацию:
		|%1,
		|%2,
		|%3,
		|%4,
		|%5,
		|%6'");
		
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(ОграничениеДатаНачалаВыгрузкиДокументов);
	МассивПараметров.Добавить(ОграничениеОтборПоМагазинам);
	МассивПараметров.Добавить(ОпцияВыгрузкиСебестоимости);
	МассивПараметров.Добавить(ОпцияВыгрузкиИзображений);
	МассивПараметров.Добавить(ОграничениеОтборПоОрганизациям);
	МассивПараметров.Добавить(ОграничениеОтборПоКассам);
	МассивПараметров.Добавить(ОграничениеОтборПоВидамЦен);
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(НСтрока, МассивПараметров);
    		
КонецФункции

// Возвращает строку описания значений по умолчанию для пользователя;
// Прикладной разработчик на основе установленных значений по умолчанию на узле должен сформировать строку описания 
// удобную для восприятия пользователем.
// 
// Параметры:
//  ЗначенияПоУмолчаниюНаУзле - Структура - структура значений по умолчанию на узле плана обмена,
//                                       полученная при помощи функции ЗначенияПоУмолчаниюНаУзле().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания для пользователя значений по умолчанию
//
Функция ОписаниеЗначенийПоУмолчанию(ЗначенияПоУмолчаниюНаУзле, ВерсияКорреспондента, ИдентификаторНастройки = "") Экспорт
	
	ТекстОписания = "Статья доходов в документах: "
					+ ?(ЗначениеЗаполнено(ЗначенияПоУмолчаниюНаУзле.СтатьяДоходов),
						Строка(ЗначенияПоУмолчаниюНаУзле.СтатьяДоходов), "не указана")
					+ ";" + Символы.ПС;
	
	ТекстОписания = ТекстОписания 
					+ "Статья расходов в документах: "
					+ ?(ЗначениеЗаполнено(ЗначенияПоУмолчаниюНаУзле.СтатьяРасходов),
						Строка(ЗначенияПоУмолчаниюНаУзле.СтатьяРасходов), "не указана")
					+ ";" + Символы.ПС;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
		ТекстОписания = ТекстОписания 
						+ "Соглашение с клиентом в документах: "
						+ ?(ЗначениеЗаполнено(ЗначенияПоУмолчаниюНаУзле.Соглашение),
							Строка(ЗначенияПоУмолчаниюНаУзле.Соглашение), "не указано")
						+ ";" + Символы.ПС;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГруппыДоступаНоменклатуры") Тогда
		ТекстОписания = ТекстОписания 
						+ "Группа доступа номенклатуры в справочниках: "
						+ ?(ЗначениеЗаполнено(ЗначенияПоУмолчаниюНаУзле.ГруппаДоступаНоменклатуры),
							Строка(ЗначенияПоУмолчаниюНаУзле.ГруппаДоступаНоменклатуры), "не указано")
						+ ";" + Символы.ПС;
	КонецЕсли;
	
	Возврат ТекстОписания;

КонецФункции

//Возвращает признак использования мастера настройки обмена для плана обмена
//
//Возвращаемое значение
//Булево - используется - Истина, не используется - Ложь
Функция ИспользоватьПомощникСозданияОбменаДанными() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает пользовательскую форму для создания начального образа базы.
// Эта форма будет открыта после завершения настройки обмена с помощью помощника.
// Для планов обмена не РИБ функция возвращает пустую строку
//
// Возвращаемое значение:
//  Строка, Неогранич - имя формы
//
//
Функция ИмяФормыСозданияНачальногоОбраза() Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает массив используемых транспортов сообщений для этого плана обмена
//
// 1. Например, если план обмена поддерживает только два транспорта сообщений FILE и FTP,
// то тело функции следует определить следующим образом:
//
//	Результат = Новый Массив;
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
//	Возврат Результат;
//
// 2. Например, если план обмена поддерживает все транспорты сообщений, определенных в конфигурации,
// то тело функции следует определить следующим образом:
//
//	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
//
// Возвращаемое значение:
//  Массив - массив содержит значения перечисления ВидыТранспортаСообщенийОбмена
//
Функция ИспользуемыеТранспортыСообщенийОбмена() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.EMAIL);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.COM);
	
	Возврат Результат;
	
КонецФункции

// Возвращает краткую информацию по обмену, выводимую при настройке синхронизации данных.
//
Функция КраткаяИнформацияПоОбмену(ИдентификаторНастройки = "") Экспорт
	
	ПоясняющийТекст = НСтр("ru = 'Позволяет синхронизировать данные между конфигурацией Розница ред. 2 и Управление Торговлей ред. 11. 
	|В синхронизации участвуют следующие типы данных: справочники (например, Организации), документы (например, 
	|Реализация товаров), регистры сведений (например, Фамилия, имя, отчество физического лица), план видов характеристик Дополнительные реквизиты и сведения.
	|
	|Синхронизация является двухсторонней и позволяет иметь актуальные данные в каждой из информационных баз.'");

	Возврат ПоясняющийТекст;
	
КонецФункции

// Возвращаемое значение: Строка - Ссылка на подробную информацию по настраиваемой синхронизации,
// в виде гиперссылки или полного пути к форме
Функция ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки = "") Экспорт
	Возврат "ПланОбмена.ОбменУправлениеТорговлейРозница.Форма.ПодробнаяИнформация";
КонецФункции

// Процедура предназначена для получения дополнительных данных, используемых при настройке обмена в базе-корреспонденте.
//
//  Параметры:
// ДополнительныеДанные – Структура. Дополнительные данные, которые будут использованы
// в базе-корреспонденте при настройке обмена.
// В качестве значений структуры применимы только значения, поддерживающие XDTO-сериализацию.
//
Процедура ПолучитьДополнительныеДанныеДляКорреспондента(ДополнительныеДанные) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Обработчик события при подключении к корреспонденту.
// Событие возникает при успешном подключении к корреспонденту и получении версии конфигурации корреспондента
// при настройке обмена с использованием помощника через прямое подключение
// или при подключении к корреспонденту через Интернет.
// В обработчике можно проанализировать версию корреспондента и,
// если настройка обмена не поддерживается с корреспондентом указанной версии, то вызвать исключение.
//
//  Параметры:
// ВерсияКорреспондента (только чтение) – Строка – версия конфигурации корреспондента, например, "2.1.5.1".
//
Процедура ПриПодключенииККорреспонденту(ВерсияКорреспондента) Экспорт
	
КонецПроцедуры

// Обработчик события при отправке данных узла-отправителя.
// Событие возникает при отправке данных узла-отправителя из текущей базы в корреспондент,
// до помещения данных узла в сообщения обмена.
// В обработчике можно изменить отправляемые данные или вовсе отказаться от отправки данных узла.
//
//  Параметры:
// Отправитель – ПланОбменаОбъект, Структура – узел плана обмена, от имени которого выполняется отправка данных.
// Игнорировать – Булево – признак отказа от выгрузки данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то отправка данных узла выполнена не будет. Значение по умолчанию – Ложь.
//
Процедура ПриОтправкеДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

// Обработчик события при получении данных узла-отправителя.
// Событие возникает при получении данных узла-отправителя,
// когда данные узла прочитаны из сообщения обмена, но не записаны в информационную базу.
// В обработчике можно изменить полученные данные или вовсе отказаться от получения данных узла.
//
//  Параметры:
// Отправитель – ПланОбменаОбъект, Структура – узел плана обмена, от имени которого выполняется получение данных.
// Игнорировать – Булево – признак отказа от получения данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то получение данных узла выполнена не будет. Значение по умолчанию – Ложь.
//
Процедура ПриПолученииДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ФункцииДляРаботыОбменаЧерезВнешнееСоединение

// Возвращает структуру отборов на узле плана обмена базы корреспондента с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена базы корреспондента
// 
Функция НастройкаОтборовНаУзлеБазыКорреспондента(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки = "") Экспорт
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ДатаНачалаВыгрузкиДокументов",      НачалоГода(ТекущаяДата()));
		
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает структуру значений по умолчению для узла базы корреспондента;
// Структура настроек повторяет состав реквизитов шапки плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура значений по умолчанию на узле плана обмена базы корреспондента
//
Функция ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки = "") Экспорт
	
	СтруктураНастроек = Новый Структура;
	
	СтруктураНастроек.Вставить("РежимВыгрузкиПриНеобходимости", Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости);
	СтруктураНастроек.Вставить("АналитикаХозОперации_ОприходованиеТоваров", "");
	СтруктураНастроек.Вставить("АналитикаХозОперации_СписаниеТоваров", "");
	СтруктураНастроек.Вставить("АналитикаХозОперации_ВозвратПоставщику", "");
	
	СтруктураНастроек.Вставить("АналитикаХозОперации_ОприходованиеТоваров_Ключ", "");
	СтруктураНастроек.Вставить("АналитикаХозОперации_СписаниеТоваров_Ключ", "");
	СтруктураНастроек.Вставить("АналитикаХозОперации_ВозвратПоставщику_Ключ", "");
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает строку описания ограничений миграции данных для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных отборов на узле базы корреспондента должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена базы корреспондента,
//                                       полученная при помощи функции НастройкаОтборовНаУзлеБазыКорреспондента().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания ограничений миграции данных для пользователя
//
Функция ОписаниеОграниченийПередачиДанныхБазыКорреспондента(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки = "") Экспорт
	
	ОграничениеДатаНачалаВыгрузкиДокументов = "";
		
	Если ЗначениеЗаполнено(НастройкаОтборовНаУзле.ДатаНачалаВыгрузкиДокументов) Тогда
		
		НСтрока = НСтр("ru = 'Начиная с %1'");
		ОграничениеДатаНачалаВыгрузкиДокументов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока, Формат(НастройкаОтборовНаУзле.ДатаНачалаВыгрузкиДокументов, "ДЛФ=DD"));
		
	Иначе
		
		ОграничениеДатаНачалаВыгрузкиДокументов = "За весь период ведения учета в программе";
		
	КонецЕсли;
		
	НСтрока = НСтр("ru = 'Выгружать документы и справочную информацию:
		|%1'");
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(ОграничениеДатаНачалаВыгрузкиДокументов);
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(НСтрока, МассивПараметров);
	
КонецФункции

// Возвращает строку описания значений по умолчанию для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных значений по умолчанию на узле базы корреспондента должен сформировать строку описания 
// удобную для восприятия пользователем.
// 
// Параметры:
//  ЗначенияПоУмолчаниюНаУзле - Структура - структура значений по умолчанию на узле плана обмена базы корреспондента,
//                                       полученная при помощи функции ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания для пользователя значений по умолчанию
//
Функция ОписаниеЗначенийПоУмолчаниюБазыКорреспондента(ЗначенияПоУмолчаниюНаУзле, ВерсияКорреспондента, ИдентификаторНастройки = "") Экспорт
	
	ТекстОписания = "";
	
	ТекстОписания = ТекстОписания 
					+ "Аналитика хозяйственной операции в документах оприходования товаров: "
					+ ?(ЗначениеЗаполнено(ЗначенияПоУмолчаниюНаУзле.АналитикаХозОперации_ОприходованиеТоваров),
						Строка(ЗначенияПоУмолчаниюНаУзле.АналитикаХозОперации_ОприходованиеТоваров), "не указана")
					+ ";" + Символы.ПС;
									
	ТекстОписания = ТекстОписания 
					+ "Аналитика хозяйственной операции в документах списания товаров: "
					+ ?(ЗначениеЗаполнено(ЗначенияПоУмолчаниюНаУзле.АналитикаХозОперации_СписаниеТоваров),
						Строка(ЗначенияПоУмолчаниюНаУзле.АналитикаХозОперации_СписаниеТоваров), "не указана")
					+ ";" + Символы.ПС;
									
	ТекстОписания = ТекстОписания 
					+ "Аналитика хозяйственной операции в документах возврата товаров поставщику: "
					+ ?(ЗначениеЗаполнено(ЗначенияПоУмолчаниюНаУзле.АналитикаХозОперации_ВозвратПоставщику),
					Строка(ЗначенияПоУмолчаниюНаУзле.АналитикаХозОперации_ВозвратПоставщику), "не указана")
					+ ";" + Символы.ПС;
									
	Возврат ТекстОписания;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли