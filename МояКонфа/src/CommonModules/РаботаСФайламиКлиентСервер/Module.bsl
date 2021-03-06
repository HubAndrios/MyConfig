////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс
////////////////////////////////////////////////////////////////////////////////
// Обработчики подписок на события.

// См. РаботаСФайлами.ОпределитьФормуПрисоединенногоФайла.
// Обработчик подписки на событие ОбработкаПолученияФормы для переопределения формы файла.
//
// Параметры:
//  Источник                 - СправочникМенеджер - менеджер справочника с именем "*ПрисоединенныеФайлы".
//  ВидФормы                 - Строка - имя стандартной формы.
//  Параметры                - Структура - параметры формы.
//  ВыбраннаяФорма           - Строка - имя или объект метаданных открываемой формы.
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы.
//  СтандартнаяОбработка     - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ОпределитьФормуПрисоединенногоФайла(Источник,
                                                      ВидФормы,
                                                      Параметры,
                                                      ВыбраннаяФорма,
                                                      ДополнительнаяИнформация,
                                                      СтандартнаяОбработка) Экспорт
	
	РаботаСФайламиСлужебныйВызовСервера.ОпределитьФормуПрисоединенногоФайла(
		Источник,
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Инициализирует структуру со сведениями о файле.
//
// Параметры:
//   Режим        - Строка - "Файл" или "ФайлСВерсией".
//   ИсходныйФайл - Файл   - файл, на основании которого заполняются свойства структуры.
//
// Возвращаемое значение:
//   Структура - со свойствами:
//    * ИмяБезРасширения             - Строка - имя файла без расширения.
//    * РасширениеБезТочки           - Строка - расширение файла.
//    * ВремяИзменения               - Дата   - дата и время изменения файла.
//    * ВремяИзмененияУниверсальное  - Дата   - UTC дата и время изменения файла.
//    * Размер                       - Число  - размер файла в байтах.
//    * АдресВременногоХранилищаФайла  - Строка, ХранилищеЗначения - адрес во временном хранилище с двоичными данными
//                                       файла или непосредственно двоичные данные файла.
//    * АдресВременногоХранилищаТекста - Строка, ХранилищеЗначения - адрес во временном хранилище с извлеченным текстов
//                                       для ППД или непосредственно сами данные с текстом.
//    * ЭтоВебКлиент                 - Булево - Истина, если вызов идет из веб клиента.
//    * Автор                        - СправочникСсылка.Пользователи - автор файла. Если Неопределено, то текущий
//                                                                     пользователь.
//    * Комментарий                  - Строка - комментарий к файлу.
//    * ЗаписатьВИсторию             - Булево - записать в историю работы пользователя.
//    * ХранитьВерсии                - Булево - разрешить хранение версий у файла в ИБ;
//                                              при создании новой версии - создавать новую версию, или изменять
//                                              существующую (Ложь).
//    * Зашифрован                   - Булево - файл зашифрован.
//
Функция СведенияОФайле(Знач Режим, Знач ИсходныйФайл = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяБезРасширения");
	Результат.Вставить("Комментарий", "");
	Результат.Вставить("АдресВременногоХранилищаТекста");
	Результат.Вставить("ХранитьВерсии", Истина);
	Результат.Вставить("Автор");
	Результат.Вставить("ИмяСправочникаХранилищаФайлов", "Файлы");
	Если Режим = "ФайлСВерсией" Тогда
		Результат.Вставить("РасширениеБезТочки");
		Результат.Вставить("ВремяИзменения", Дата('00010101'));
		Результат.Вставить("ВремяИзмененияУниверсальное", Дата('00010101'));
		Результат.Вставить("Размер", 0);
		Результат.Вставить("Зашифрован");
		Результат.Вставить("АдресВременногоХранилищаФайла");
		Результат.Вставить("ЗаписатьВИсторию", Ложь);
		Результат.Вставить("Кодировка");
		Результат.Вставить("СсылкаНаВерсиюИсточник");
		Результат.Вставить("НоваяВерсияДатаСоздания"); 
		Результат.Вставить("НоваяВерсияАвтор"); 
		Результат.Вставить("НоваяВерсияКомментарий"); 
		Результат.Вставить("НоваяВерсияНомерВерсии"); 
		Результат.Вставить("НовыйСтатусИзвлеченияТекста"); 
	КонецЕсли;
	
	Если ИсходныйФайл <> Неопределено Тогда
		Результат.ИмяБезРасширения = ИсходныйФайл.ИмяБезРасширения;
		Результат.РасширениеБезТочки = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(ИсходныйФайл.Расширение);
		Результат.ВремяИзменения = ИсходныйФайл.ПолучитьВремяИзменения();
		Результат.ВремяИзмененияУниверсальное = ИсходныйФайл.ПолучитьУниверсальноеВремяИзменения();
		Результат.Размер = ИсходныйФайл.Размер();
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определить, можно ли занять файл и, если нет, то сформировать текст ошибки.
//
// Параметры:
//  ДанныеФайла  - Структура - структура с данными файла.
//  СтрокаОшибки - Строка - (возвращаемое значение) - если файл занять нельзя,
//                 тогда содержит описание ошибки.
//
// Возвращаемое значение:
//  Булево - если Истина, тогда текущий пользователь может занять файл или
//           файл уже занят текущим пользователем.
//
Функция МожноЛиЗанятьФайл(ДанныеФайла, СтрокаОшибки = "") Экспорт
	
	Если ДанныеФайла.ПометкаУдаления = Истина Тогда
		СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Нельзя занять файл ""%1"",
			           |т.к. он помечен на удаление.'"),
			Строка(ДанныеФайла.Ссылка));
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Не ЗначениеЗаполнено(ДанныеФайла.Редактирует) Или ДанныеФайла.ФайлРедактируетТекущийПользователь;  
	Если Не Результат Тогда
		СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Файл ""%1""
			           |уже занят для редактирования пользователем
			           |""%2"" с %3.'"),
			Строка(ДанныеФайла.Ссылка),
			Строка(ДанныеФайла.Редактирует),
			Формат(ДанныеФайла.ДатаЗаема, "ДЛФ=ДВ"));
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

// Возвращает строковую константу для формирования сообщений журнала регистрации.
//
// Возвращаемое значение:
//   Строка
//
Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Файлы'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти