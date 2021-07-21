
#Область СлужебныйПрограммныйИнтерфейс

// Проверят доступна ли загрузка внешних компонент с сайта.
//
Функция ДоступнаЗагрузкаССайта() Экспорт 
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ВнешниеКомпоненты")
		И Не ОбщегоНазначения.РазделениеВключено();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий.
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Зависимости) Экспорт
	
	Зависимость = Зависимости.Добавить();
	Зависимость.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеВнешнихКомпонентССайта;
	Зависимость.ДоступноВПодчиненномУзлеРИБ     = Истина;
	Зависимость.ДоступноВАвтономномРабочемМесте = Истина;
	Зависимость.ДоступноВМоделиСервиса          = Ложь;
	
КонецПроцедуры

// См. ГрупповоеИзменениеОбъектовПереопределяемый.ПриОпределенииОбъектовСРедактируемымиРеквизитами.
Процедура ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты) Экспорт
	
	Объекты.Вставить(Метаданные.Справочники.ВнешниеКомпоненты.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.Справочники.ВнешниеКомпоненты);
	
КонецПроцедуры

// См. СтандартныеПодсистемыСервер.ПриОтправкеДанныхГлавному.
Процедура ПриОтправкеДанныхГлавному(ЭлементДанных, ОтправкаЭлемента, Получатель) Экспорт
	
	// Стандартная обработка не переопределяется.
	Если ОтправкаЭлемента = ОтправкаЭлементаДанных.Игнорировать Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.ВнешниеКомпоненты") Тогда
		ОтправкаЭлемента = ОтправкаЭлементаДанных.Игнорировать;
	КонецЕсли;
	
КонецПроцедуры

// См. СтандартныеПодсистемыСервер.ПриОтправкеДанныхПодчиненному.
Процедура ПриОтправкеДанныхПодчиненному(ЭлементДанных, ОтправкаЭлемента, СозданиеНачальногоОбраза, Получатель) Экспорт
	
	// Стандартная обработка не переопределяется.
	Если ОтправкаЭлемента = ОтправкаЭлементаДанных.Игнорировать Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.ВнешниеКомпоненты") Тогда
		ОтправкаЭлемента = ОтправкаЭлементаДанных.Игнорировать;
	КонецЕсли;
	
КонецПроцедуры

// См. СтандартныеПодсистемыСервер.ПриПолученииДанныхОтГлавного.
Процедура ПриПолученииДанныхОтГлавного(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад, Отправитель) Экспорт
	
	// Стандартная обработка не переопределяется.
	Если ПолучениеЭлемента = ПолучениеЭлементаДанных.Игнорировать Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.ВнешниеКомпоненты") Тогда
		ПолучениеЭлемента = ПолучениеЭлементаДанных.Игнорировать;
	КонецЕсли;
	
КонецПроцедуры

// См. СтандартныеПодсистемыСервер.ПриПолученииДанныхОтПодчиненного.
Процедура ПриПолученииДанныхОтПодчиненного(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад, Отправитель) Экспорт
	
	// Стандартная обработка не переопределяется.
	Если ПолучениеЭлемента = ПолучениеЭлементаДанных.Игнорировать Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.ВнешниеКомпоненты") Тогда
		ПолучениеЭлемента = ПолучениеЭлементаДанных.Игнорировать;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает ссылку на справочник внешней компоненты по идентификатору и версии.
//
// Параметры:
//  Идентификатор - Строка               - идентификатор объекта внешнего компонента.
//  Версия        - Строка, Неопределено - версия компоненты.
//
// Возвращаемое значение:
//  СправочникСсылка.ВнешниеКомпоненты - ссылка на контейнер внешней компоненты в информационной базе.
//
Функция СсылкаПоИдентификатору(Идентификатор, Версия = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Если Версия = Неопределено Тогда 
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВнешниеКомпоненты.Идентификатор КАК Идентификатор,
			|	МАКСИМУМ(ВнешниеКомпоненты.ДатаВерсии) КАК ДатаВерсии
			|ПОМЕСТИТЬ ВТ_МаксимальнаяВерсияКомпоненты
			|ИЗ
			|	Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
			|ГДЕ
			|	ВнешниеКомпоненты.Идентификатор = &Идентификатор
			|
			|СГРУППИРОВАТЬ ПО
			|	ВнешниеКомпоненты.Идентификатор
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВнешниеКомпоненты.Ссылка КАК Ссылка,
			|	ВнешниеКомпоненты.Использование КАК Использование
			|ИЗ
			|	ВТ_МаксимальнаяВерсияКомпоненты КАК ВТ_МаксимальнаяВерсияКомпоненты
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
			|		ПО (ВнешниеКомпоненты.Идентификатор = ВТ_МаксимальнаяВерсияКомпоненты.Идентификатор)
			|			И ВТ_МаксимальнаяВерсияКомпоненты.ДатаВерсии = ВнешниеКомпоненты.ДатаВерсии";
	Иначе 
		Запрос.УстановитьПараметр("Версия", Версия);
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВнешниеКомпоненты.Ссылка КАК Ссылка,
			|	ВнешниеКомпоненты.Использование КАК Использование
			|ИЗ
			|	Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
			|ГДЕ
			|	ВнешниеКомпоненты.Идентификатор = &Идентификатор
			|	И ВнешниеКомпоненты.Версия = &Версия";
		
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда 
		Возврат Справочники.ВнешниеКомпоненты.ПустаяСсылка();
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Если Выборка.Использование = Перечисления.ВариантыИспользованияВнешнихКомпонент.Отключена Тогда
		ВызватьИсключение НСтр("ru = 'Внешняя компонента отключена.
		                             |Необходимо обратиться к администратору.'");
	КонецЕсли;
	
	Возврат Результат.Выгрузить()[0].Ссылка;
	
КонецФункции

// Выполняется в длительной операции.
// Выполняет подготовку компоненты к подключению и возвращает информацию для проверки 
// совместимости компоненты на клиенте.
// В случае отсутствия компоненты, выполняет ее получение средствами подсистемы интернет поддержки.
// Компонента помещается во временное хранилище до завершения сеанса,
// Для оптимизации памяти после попытки подключения рекомендуется выполнить очистку хранилища.
//
// Параметры:
//  Параметры - Структура - параметры подготовки.
//      * Идентификатор - Строка               - идентификатор объекта внешнего компонента.
//      * Версия        - Строка, Неопределено - версия компоненты. 
//
//  АдресРезультата - Строка - Адрес в хранилище с результатом.
//      * Структура - информация о компоненте 
//          * Подготовлена   - Булево - признак отсутствия компоненты.
//          * ОписаниеОшибки - Строка - краткое описание ошибки.
//          * Местоположение - Строка - временное хранилище двоичных данных ZIP-архива компоненты.
//
Процедура ПодготовитьКомпонентуКПодключению(Параметры, АдресРезультата) Экспорт
	
	Идентификатор = Параметры.Идентификатор;
	Версия        = Параметры.Версия;
	
	Ссылка = СсылкаПоИдентификатору(Идентификатор, Версия);
	Если Ссылка.Пустая() Тогда 
		
		Если ОбщегоНазначения.РазделениеВключено() Тогда 
		
			Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ВнешниеКомпонентыВМоделиСервиса") Тогда
				
				МодульВнешниеКомпоненты = ОбщегоНазначения.ОбщийМодуль("ВнешниеКомпонентыВМоделиСервисаСлужебный");
				Результат = МодульВнешниеКомпоненты.ПолучениеСлужебнойИнформацииОКомпоненте(Идентификатор, Версия);
				
				ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
				Возврат;
				
			КонецЕсли;
			
		Иначе
			
			Если ДоступнаЗагрузкаССайта() Тогда
			
				Ссылка = НоваяКомпонентаССайта(Идентификатор, Версия);
			
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Ссылка.Пустая() Тогда
	
		ТекстОшибки = НСтр("ru = 'Требуется загрузить внешнюю компоненту в информационную базу.
		                         |Рекомендуем обратиться к администратору.'");
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Windows_x86");
	Результат.Вставить("Windows_x86_64");
	Результат.Вставить("Linux_x86");
	Результат.Вставить("Linux_x86_64");
	Результат.Вставить("Windows_x86_Firefox");
	Результат.Вставить("Linux_x86_Firefox");
	Результат.Вставить("Linux_x86_64_Firefox");
	Результат.Вставить("Windows_x86_MSIE");
	Результат.Вставить("Windows_x86_64_MSIE");
	Результат.Вставить("Windows_x86_Chrome");
	Результат.Вставить("Linux_x86_Chrome");
	Результат.Вставить("Linux_x86_64_Chrome");
	Результат.Вставить("MacOS_x86_64_Safari");
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, Результат);
	
	ЗаполнитьЗначенияСвойств(Результат, Реквизиты);
	
	Местоположение = ПолучитьНавигационнуюСсылку(Ссылка, "ХранилищеКомпоненты");
	Результат.Вставить("Местоположение", Местоположение);
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

// Разбирает файл компоненты для получения служебной информации о компоненте
//
Функция ИнформацияОКомпоненте(АдресХранилищаФайла, ВыполнятьРазборИнфоФайла = Истина) Экспорт

	// Проверка адреса временного хранилища
	Если Не ЭтоАдресВременногоХранилища(АдресХранилищаФайла) Тогда 
		ТекстОшибки = НСтр("ru = 'Не корректный адрес временного хранилища.'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Регистрация внешней компоненты'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	// Значения заполнения по умолчанию.
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("Windows_x86",          Ложь);
	Реквизиты.Вставить("Windows_x86_64",       Ложь);
	Реквизиты.Вставить("Linux_x86",            Ложь);
	Реквизиты.Вставить("Linux_x86_64",         Ложь);
	Реквизиты.Вставить("Windows_x86_Firefox",  Ложь);
	Реквизиты.Вставить("Linux_x86_Firefox",    Ложь);
	Реквизиты.Вставить("Linux_x86_64_Firefox", Ложь);
	Реквизиты.Вставить("Windows_x86_MSIE",     Ложь);
	Реквизиты.Вставить("Windows_x86_64_MSIE",  Ложь);
	Реквизиты.Вставить("Windows_x86_Chrome",   Ложь);
	Реквизиты.Вставить("Linux_x86_Chrome",     Ложь);
	Реквизиты.Вставить("Linux_x86_64_Chrome",  Ложь);
	Реквизиты.Вставить("MacOS_x86_64_Safari",  Ложь);
	Реквизиты.Вставить("Идентификатор",        Неопределено);
	Реквизиты.Вставить("Наименование",         Неопределено);
	Реквизиты.Вставить("Версия",               Неопределено);
	Реквизиты.Вставить("ДатаВерсии",           Неопределено);
	Реквизиты.Вставить("ИмяФайла",             Неопределено);
	
	// Получение и загрузка двоичных данных компоненты.
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресХранилищаФайла);
	
	// Очищаем выделенную память в хранилище
	УдалитьИзВременногоХранилища(АдресХранилищаФайла);
	
	// Контроль соответствия компоненты.
	НайденМанифест = Ложь;
	
	// Разбор данных архива компоненты.
	Попытка
		
		Поток = ДвоичныеДанные.ОткрытьПотокДляЧтения();
		ЧтениеАрхива = Новый ЧтениеZipФайла(Поток);
		
	Исключение
		
		ТекстОшибки = НСтр("ru = 'В файле отсутствует информация о компоненте.'");
		
		Результат = Новый Структура;
		Результат.Вставить("Разобрано",      Ложь);
		Результат.Вставить("ОписаниеОшибки", ТекстОшибки);
		
		Возврат Результат;
		
	КонецПопытки;
	
	ВременныйКаталог = СоздатьВременныйКаталог();
	
	Для каждого ЭлементАрхива Из ЧтениеАрхива.Элементы Цикл
		
		Если ЭлементАрхива.Зашифрован Тогда
			
			// Очищаем временные файлы и освобождаем память.
			УдалитьВременныйКаталог(ВременныйКаталог);
			ЧтениеАрхива.Закрыть();
			Поток.Закрыть();
			
			ТекстОшибки = НСтр("ru = 'ZIP-архив не должен быть зашифрован.'");
			
			Результат = Новый Структура;
			Результат.Вставить("Разобрано",      Ложь);
			Результат.Вставить("ОписаниеОшибки", ТекстОшибки);
			
			Возврат Результат;
			
		КонецЕсли;
		
		// Поиск и разбор манифеста.
		Если НРег(ЭлементАрхива.ПолноеИмя) = "manifest.xml" Тогда
			
			ЧтениеАрхива.Извлечь(ЭлементАрхива, ВременныйКаталог);
			
			ВременныйФайлXML = ВременныйКаталог + ПолучитьРазделительПути() + ЭлементАрхива.ПолноеИмя;
			РазобратьМанифестКомпоненты(ВременныйФайлXML, Реквизиты);
			
			ОписаниеФайла = Новый Файл(ВременныйФайлXML);
			Реквизиты.ДатаВерсии = ОписаниеФайла.ПолучитьВремяИзменения();
			
			НайденМанифест = Истина;
			
		КонецЕсли;
		
		Если НРег(ЭлементАрхива.ПолноеИмя) = "info.xml" И ВыполнятьРазборИнфоФайла Тогда
			
			ЧтениеАрхива.Извлечь(ЭлементАрхива, ВременныйКаталог);
			
			ВременныйФайлXML = ВременныйКаталог + ПолучитьРазделительПути() + ЭлементАрхива.ПолноеИмя;
			РазобратьИнфоКомпоненты(ВременныйФайлXML, Реквизиты);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Очищаем временные файлы и освобождаем память.
	УдалитьВременныйКаталог(ВременныйКаталог);
	ЧтениеАрхива.Закрыть();
	Поток.Закрыть();
	
	// Контроль соответствия компоненты.
	Если Не НайденМанифест Тогда 
		
		ТекстОшибки = НСтр("ru = 'В архиве компоненты отсутствует обязательный файл MANIFEST.XML.'");
		
		Результат = Новый Структура;
		Результат.Вставить("Разобрано",      Ложь);
		Результат.Вставить("ОписаниеОшибки", ТекстОшибки);
		
		Возврат Результат;
		
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Разобрано",      Истина);
	Результат.Вставить("Реквизиты"     , Реквизиты);
	Результат.Вставить("ДвоичныеДанные", ДвоичныеДанные);
	
	Возврат Результат;
	
КонецФункции

Функция СоздатьВременныйКаталог()
	
	ВременныйКаталог = ПолучитьИмяВременногоФайла() 
	                 + ПолучитьРазделительПути() 
	                 + Строка(Новый УникальныйИдентификатор);
	СоздатьКаталог(ВременныйКаталог);
	
	Возврат ВременныйКаталог;
	
КонецФункции

Процедура УдалитьВременныйКаталог(ВременныйКаталог)
	
	Попытка
		УдалитьФайлы(ВременныйКаталог);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Регистрация внешней компоненты'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

Процедура РазобратьМанифестКомпоненты(ВременныйФайлXML, Реквизиты)
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ВременныйФайлXML);
	
	ЧтениеXML.ПерейтиКСодержимому();
	Если ЧтениеXML.Имя = "bundle" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
		Пока ЧтениеXML.Прочитать() Цикл 
			Если ЧтениеXML.Имя = "component" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				
				ОперационнаяСистема  = НРег(ЧтениеXML.ЗначениеАтрибута("os"));
				ТипКомпоненты        = НРег(ЧтениеXML.ЗначениеАтрибута("type"));
				АрхитектураПлатформы = НРег(ЧтениеXML.ЗначениеАтрибута("arch"));
				ПрограммаПросмотра   = НРег(ЧтениеXML.ЗначениеАтрибута("client"));
				
				Если ОперационнаяСистема = "windows" И АрхитектураПлатформы = "i386"
					И (ТипКомпоненты = "native" Или ТипКомпоненты = "com") Тогда 
					
					Реквизиты.Windows_x86 = Истина;
					Продолжить;
				КонецЕсли;
				
				Если ОперационнаяСистема = "windows" И АрхитектураПлатформы = "x86_64"
					И (ТипКомпоненты = "native" Или ТипКомпоненты = "com") Тогда 
					
					Реквизиты.Windows_x86_64 = Истина;
					Продолжить;
				КонецЕсли;
				
				Если ОперационнаяСистема = "linux" И АрхитектураПлатформы = "i386"
					И ТипКомпоненты = "native" Тогда 
					
					Реквизиты.Linux_x86 = Истина;
					Продолжить;
				КонецЕсли;
				
				Если ОперационнаяСистема = "linux" И АрхитектураПлатформы = "x86_64"
					И ТипКомпоненты = "native" Тогда 
					
					Реквизиты.Linux_x86_64 = Истина;
					Продолжить;
				КонецЕсли;
				
				Если ОперационнаяСистема = "windows" И АрхитектураПлатформы = "i386"
					И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "firefox" Тогда
					
					Реквизиты.Windows_x86_Firefox = Истина;
					Продолжить;
				КонецЕсли;
				
				Если ОперационнаяСистема = "linux" И АрхитектураПлатформы = "i386" 
					И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "firefox" Тогда
					
					Реквизиты.Linux_x86_Firefox = Истина;
					Продолжить;
				КонецЕсли;
				
				Если ОперационнаяСистема = "linux" И АрхитектураПлатформы = "x86_64"
					И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "firefox" Тогда
					
					Реквизиты.Linux_x86_64_Firefox = Истина;
					Продолжить;
				КонецЕсли;
				
				Если ОперационнаяСистема = "windows" И АрхитектураПлатформы = "i386"
					И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "msie" Тогда
					
					Реквизиты.Windows_x86_MSIE = Истина;
					Продолжить;
				КонецЕсли;
				
				Если ОперационнаяСистема = "windows" И АрхитектураПлатформы = "x86_64"
					И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "msie" Тогда
					
					Реквизиты.Windows_x86_64_MSIE = Истина;
					Продолжить;
				КонецЕсли;
				
				Если ОперационнаяСистема = "windows" И АрхитектураПлатформы = "i386"
					И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "chrome" Тогда
					
					Реквизиты.Windows_x86_Chrome = Истина;
					Продолжить;
				КонецЕсли;
				
				Если ОперационнаяСистема = "linux" И АрхитектураПлатформы = "i386"
					И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "chrome" Тогда
					
					Реквизиты.Linux_x86_Chrome = Истина;
					Продолжить;
				КонецЕсли;
				
				Если ОперационнаяСистема = "linux" И АрхитектураПлатформы = "x86_64"
					И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "chrome" Тогда
					
					Реквизиты.Linux_x86_64_Chrome = Истина;
					Продолжить;
				КонецЕсли;
				
				Если ОперационнаяСистема = "macos" 
					И (АрхитектураПлатформы = "x86_64" Или АрхитектураПлатформы = "universal")
					И ТипКомпоненты = "plugin" И ПрограммаПросмотра = "safari" Тогда 
					
					Реквизиты.MacOS_x86_64_Safari = Истина;
					Продолжить;
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;  
	КонецЕсли;
	ЧтениеXML.Закрыть();
	
КонецПроцедуры

Процедура РазобратьИнфоКомпоненты(ВременныйФайлXML, Реквизиты)
	
	ИнфоРазобран = Ложь;
	
	// Пытаемся разобрать по формату БПО
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ВременныйФайлXML);
	
	ЧтениеXML.ПерейтиКСодержимому();
	Если ЧтениеXML.Имя = "drivers" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
		Пока ЧтениеXML.Прочитать() Цикл
			Если ЧтениеXML.Имя = "component" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				
				Идентификатор = ЧтениеXML.ЗначениеАтрибута("progid");
				
				Реквизиты.Идентификатор = Сред(Идентификатор, СтрНайти(Идентификатор, ".") + 1);
				Реквизиты.Наименование  = ЧтениеXML.ЗначениеАтрибута("name");
				Реквизиты.Версия        = ЧтениеXML.ЗначениеАтрибута("version");
				
				ИнфоРазобран = Истина;
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	ЧтениеXML.Закрыть();
	
	Если Не ИнфоРазобран Тогда
		
		// Пытаемся разобрать по формату БЭД
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(ВременныйФайлXML);
	
		info = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		Реквизиты.Идентификатор = info.progid;
		Реквизиты.Наименование = info.name;
		Реквизиты.Версия = info.version;
		
		ЧтениеXML.Закрыть();
	
	КонецЕсли;
	
КонецПроцедуры

#Область ЗагрузкаССайта

// Только при наличии подсистемы БИП.ВнешниеКомпоненты
//
Функция НоваяКомпонентаССайта(Идентификатор, Версия = Неопределено)
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Идентификатор");
	Таблица.Колонки.Добавить("Версия");
	Таблица.Колонки.Добавить("ТекущаяВерсия");
	
	СтрокаТаблицы = Таблица.Добавить();
	СтрокаТаблицы.Идентификатор = Идентификатор;
	СтрокаТаблицы.Версия        = Версия;
	СтрокаТаблицы.ТекущаяВерсия = Неопределено;
	
	МодульВнешниеКомпонентыИнтернетПоддержка = ОбщегоНазначения.ОбщийМодуль("ВнешниеКомпонентыИнтернетПоддержка");
	Результат = МодульВнешниеКомпонентыИнтернетПоддержка.ЗагрузитьКомпонентыССайта(Таблица);
	
	Если Результат.Количество() = 0 Тогда
		ТекстОшибки = НСтр("ru = 'На сайте 1С нет требуемой компоненты.'");
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	СтрокаРезультата = Результат[0]; // Фокусировка на первой строке результата.
	
	Информация = ИнформацияОКомпоненте(СтрокаРезультата.АдресХранилищаФайла, Ложь);
	
	Если Не Информация.Разобрано Тогда 
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка, , , Информация.ОписаниеОшибки);
		ВызватьИсключение Информация.ОписаниеОшибки;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Создание экземпляра компоненты.
	Объект = Справочники.ВнешниеКомпоненты.СоздатьЭлемент();
	Объект.Заполнить(Неопределено); // Конструктор по умолчанию.
	
	ЗаполнитьЗначенияСвойств(Объект, Информация.Реквизиты); // По данным манифеста.
	ЗаполнитьЗначенияСвойств(Объект, СтрокаРезультата);     // По данным с сайта.
	
	Объект.ДополнительныеСвойства.Вставить("ДвоичныеДанныеКомпоненты", Информация.ДвоичныеДанные);
	
	
	// Если это компонента последней версии, то устанавливаем ОбновлятьССайта.
	Если Версия = Неопределено Тогда // Если изначальный запрос конкретной версии - пропускаем.
		
		// Запрос требуется для случая, для контроля наличия компоненты старшей версии с отключенным обновлением.
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
		Запрос.Текст = 
		    "ВЫБРАТЬ
		    |	МАКСИМУМ(ВнешниеКомпоненты.ДатаВерсии) КАК ДатаВерсии
		    |ИЗ
		    |	Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
		    |ГДЕ
		    |	ВнешниеКомпоненты.Идентификатор = &Идентификатор";
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ЭтоМаксимальнаяВерсия = (Выборка.ДатаВерсии = Null) Или (Выборка.ДатаВерсии = Объект.ДатаВерсии);

		Объект.ОбновлятьССайта = ЭтоМаксимальнаяВерсия;
		
	КонецЕсли;
	
	Попытка
		Объект.Записать();
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Объект.Ссылка;
	
КонецФункции

// Выполняется в длительной операции.
// Вызывается из формы элемента и списка.
//
Процедура ОбновитьКомпонентыССайта(МассивСсылок, АдресРезультата) Экспорт
	
	Если Не ДоступнаЗагрузкаССайта() Тогда
		ВызватьИсключение НСтр("ru = 'Обновление внешних компонент не доступно.
		                       |Требуется подсистема обновления внешних компонент библиотеки интернет поддержки.'");
	КонецЕсли;
	
	// Фильтруем ссылки, убирая обновление для компонент без признака
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВнешниеКомпоненты.Идентификатор КАК Идентификатор,
		|	НЕОПРЕДЕЛЕНО КАК Версия,
		|	ВнешниеКомпоненты.Версия КАК ТекущаяВерсия,
		|	ВнешниеКомпоненты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
		|ГДЕ
		|	ВнешниеКомпоненты.Ссылка В(&МассивСсылок)
		|	И ВнешниеКомпоненты.ОбновлятьССайта";
			
	ОбновитьКомпонентыССайтаПоЗапросу(Запрос);
	
КонецПроцедуры

// Только при наличии подсистемы БИП.ВнешниеКомпоненты.
//
Процедура ОбновитьКомпонентыССайтаПоЗапросу(Запрос)
	
	Если Не ДоступнаЗагрузкаССайта() Тогда
		ВызватьИсключение НСтр("ru = 'Обновление внешних компонент не доступно.
		                       |Требуется подсистема обновления внешних компонент библиотеки интернет поддержки.'");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда 
		Возврат;
	КонецЕсли;
	
	// Выборка для поиска ссылок при обработке результата запроса с сайта.
	Выборка = РезультатЗапроса.Выбрать();
	
	// Выполнение запроса к сайту.
	Таблица = РезультатЗапроса.Выгрузить();
	
	МодульВнешниеКомпонентыИнтернетПоддержка = ОбщегоНазначения.ОбщийМодуль("ВнешниеКомпонентыИнтернетПоддержка");
	Результат = МодульВнешниеКомпонентыИнтернетПоддержка.ЗагрузитьКомпонентыССайта(Таблица);
	
	// Обход результата запроса с сайта.
	Для каждого СтрокаРезультата Из Результат Цикл
		
		Информация = ИнформацияОКомпоненте(СтрокаРезультата.АдресХранилищаФайла, Ложь);
		
		Если Не Информация.Разобрано Тогда 
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , Информация.ОписаниеОшибки);
			ВызватьИсключение Информация.ОписаниеОшибки;
		КонецЕсли;
				
		// Поиск ссылки.
		Отбор = Новый Структура("Идентификатор", СтрокаРезультата.Идентификатор);
		Если Выборка.НайтиСледующий(Отбор) Тогда 
			
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			
			ЗаполнитьЗначенияСвойств(Объект, Информация.Реквизиты); // По данным манифеста.
			ЗаполнитьЗначенияСвойств(Объект, СтрокаРезультата);     // По данным с сайта.
			
			Объект.ДополнительныеСвойства.Вставить("ДвоичныеДанныеКомпоненты", Информация.ДвоичныеДанные);
			
			Попытка
				Объект.Записать();
			Исключение
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление внешних компонент'",
						ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// Обработчики выполнения регламентный заданий.

// Обновление всех компонент регламентным заданием.
//
Процедура ОбновитьВсеКомпонентыССайта() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОбновлениеВнешнихКомпонентССайта);
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ВызватьИсключение НСтр("ru = 'Недопустимое использование регламентного задания:
		                       |Нельзя использовать регламентное задание в разделенном режиме.'");
	КонецЕсли;
	
	Если Не ДоступнаЗагрузкаССайта() Тогда
		ВызватьИсключение НСтр("ru = 'Недопустимое использование регламентного задания:
		                       |Нельзя использовать регламентное задание в конфигурации 
		                       |без подсистемы Интернет Поддержки.'");
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВнешниеКомпоненты.Идентификатор КАК Идентификатор,
		|	НЕОПРЕДЕЛЕНО КАК Версия,
		|	ВнешниеКомпоненты.Версия КАК ТекущаяВерсия,
		|	ВнешниеКомпоненты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
		|ГДЕ
		|	ВнешниеКомпоненты.ОбновлятьССайта";
	
	ОбновитьКомпонентыССайтаПоЗапросу(Запрос);
	
КонецПроцедуры

#КонецОбласти

