////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с 1С:Документооборотом"
// Модуль ИнтеграцияС1СДокументооборотОбмен, сервер, внешнее соединение
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Последовательно отправляет сообщения очереди, потом принимает сообщения из ДО.
//
Процедура ВыполнитьОбменДанными() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьИнтеграциюС1СДокументооборот") Тогда
		Возврат;
	КонецЕсли;
	
	// Прочтем настройки авторизации и установим их в параметры сеанса. Константы могут быть недоступны.
	УстановитьПривилегированныйРежим(Истина);
	ИмяПользователя = Константы.ИнтеграцияС1СДокументооборотИмяПользователяДляОбмена.Получить();
	Пароль = Константы.ИнтеграцияС1СДокументооборотПарольДляОбмена.Получить();
	Если Не ЗначениеЗаполнено(ИмяПользователя) Тогда // прочтем настройки из пользовательского хранилища.
		
		ПарольСохранен = Ложь;
		ИнтеграцияС1СДокументооборотВызовСервера.ПрочитатьНастройкиАвторизацииИзХранилищаОбщихНастроек(
			ИмяПользователя, Пароль, ПарольСохранен);
		
		Если Не ЗначениеЗаполнено(ИмяПользователя) Тогда
			
			ЗаписьЖурналаРегистрации(
				ИнтеграцияС1СДокументооборот.ИмяСобытияЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,,,
				НСтр("ru = 'Для пользователя регламентного задания обмена не указано имя пользователя 1С:Документооборота'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
			
			Возврат;
			
		КонецЕсли;
		
		Если ПарольСохранен <> Истина Тогда
			
			ЗаписьЖурналаРегистрации(
				ИнтеграцияС1СДокументооборот.ИмяСобытияЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,,,
				НСтр("ru = 'Для пользователя регламентного задания обмена не сохранен пароль 1С:Документооборота'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
				
			Возврат;
			
		КонецЕсли;
		
		// Перенесем настройки в константы.
		ИнтеграцияС1СДокументооборотВызовСервера.СохранитьНастройкиАвторизацииДляОбмена(ИмяПользователя, Пароль);
		ИнтеграцияС1СДокументооборотВызовСервера.УдалитьНастройкиАвторизацииИзХранилищаОбщихНастроек();
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ИнтеграцияС1СДокументооборотВызовСервера.УстановитьНастройкиАвторизацииВПараметрыСеанса(ИмяПользователя,
		Пароль,
		Ложь);
		
	// Поддержка синхронизации?
	Если Не ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3.CORP") Тогда
		// Сервис доступен, но версия младше требуемой?
		Если ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("") Тогда
			УзелДокументооборота = ИнтеграцияС1СДокументооборотПовтИсп.УзелДокументооборота();
			ПланыОбмена.УдалитьРегистрациюИзменений(УзелДокументооборота);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ПодготовитьДанныеДляОтправки();
	ОтправитьДанные();
	ПолучитьДанные();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//Возвращает измененние объекты, которые интегрированы с 1С:Документооборотом. 
// Параметры:
//	УзелОбмена - ПланОбменаСсылка.ИнтеграцияС1СДокументооборотом - узел, для по которому нужно получить изменения
//
Функция ПолучитьМассивЗарегистрированныхДанных(УзелОбмена)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивДанных = Новый Массив;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Правила.Ссылка КАК Правило
		|ПОМЕСТИТЬ
		|	ПравилаСУсловиями
		|ИЗ
		|	Справочник.ПравилаИнтеграцииС1СДокументооборотом КАК Правила
		|ГДЕ
		|	ВЫРАЗИТЬ(Правила.УсловиеПрименимостиПриВыгрузке КАК СТРОКА(1)) <> """"
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ПравилаЗагрузки.Ссылка КАК Правило
		|ИЗ
		|	Справочник.ПравилаИнтеграцииС1СДокументооборотом.ПравилаЗаполненияРеквизитовПриЗагрузке КАК ПравилаЗагрузки
		|ГДЕ
		|	ПравилаЗагрузки.Ключевой
		|;
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Правила.Ссылка КАК ПравилоЗаполнения,
		|	Правила.ТипОбъектаПотребителя КАК ТипОбъектаПотребителя,
		|	Правила.ТипОбъектаДокументооборота КАК ТипОбъектаДокументооборота,
		|	ВЫБОР КОГДА Правила.Ссылка В (ВЫБРАТЬ Правило ИЗ ПравилаСУсловиями) ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ КАК ЕстьУсловия
		|ПОМЕСТИТЬ ПравилаЗаполнения
		|ИЗ
		|	Справочник.ПравилаИнтеграцииС1СДокументооборотом КАК Правила
		|ГДЕ
		|	НЕ Правила.Ссылка.ПометкаУдаления
		|	И Правила.ВыгружатьИзменения";
		
	Запрос.Выполнить();
	
	//Проверим, нужно ли получить связанные объекты.
	ИнтеграцияС1СДокументооборот.ПроверитьОбновитьДанныеСвязанныхОбъектов();
	
	Для Каждого ЭлементСоставаПланаОбмена Из УзелОбмена.Метаданные().Состав Цикл
		ЗапросИзменения = Новый Запрос;
		ЗапросИзменения.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		
		ИмяМетаданныхЭлемента = ЭлементСоставаПланаОбмена.Метаданные.Имя;
		ПолноеИмяМетаданныхЭлемента = ЭлементСоставаПланаОбмена.Метаданные.ПолноеИмя();
		ТекстЗапроса = 
			"ВЫБРАТЬ
			|	ТаблицаИзменения.Ссылка КАК Объект,
			|	ПравилаЗаполнения.ПравилоЗаполнения КАК ПравилоЗаполнения,
			|	ПравилаЗаполнения.ЕстьУсловия КАК ЕстьУсловия,
			|	ЕСТЬNULL(ОбъектыИнтегрированныеС1СДокументооборотом.ТипОбъектаДокументооборота, ПравилаЗаполнения.ТипОбъектаДокументооборота) КАК ТипОбъектаДокументооборота,
			|	ЕСТЬNULL(ОбъектыИнтегрированныеС1СДокументооборотом.ИдентификаторОбъектаДокументооборота, """") КАК ИдентификаторОбъектаДокументооборота
			|ИЗ
			|	%1.Изменения КАК ТаблицаИзменения
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПравилаЗаполнения КАК ПравилаЗаполнения
			|		ПО (ПравилаЗаполнения.ТипОбъектаПотребителя = ""%1"")
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыИнтегрированныеС1СДокументооборотом КАК ОбъектыИнтегрированныеС1СДокументооборотом
			|		ПО ТаблицаИзменения.Ссылка = ОбъектыИнтегрированныеС1СДокументооборотом.Объект
			|ГДЕ
			|	ТаблицаИзменения.Узел = &Узел
			|	И ЕСТЬNULL(ОбъектыИнтегрированныеС1СДокументооборотом.ТипОбъектаДокументооборота, ПравилаЗаполнения.ТипОбъектаДокументооборота) = ПравилаЗаполнения.ТипОбъектаДокументооборота
			|ИТОГИ ПО
			|	Объект";
				
		ЗапросИзменения.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстЗапроса,
			ПолноеИмяМетаданныхЭлемента);
		ЗапросИзменения.УстановитьПараметр("Узел", УзелОбмена);
		ВыборкаОбъекты = ЗапросИзменения.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаОбъекты.Следующий() Цикл
			
			ИнтегрированныйОбъект = Новый Структура("Объект", ВыборкаОбъекты.Объект);
			
			ВыборкаПравила = ВыборкаОбъекты.Выбрать();
			ВыборкаПравила.Следующий();
			
			ИнтегрированныйОбъект.Вставить("ТипОбъектаДокументооборота", 
				ВыборкаПравила.ТипОбъектаДокументооборота);
			ИнтегрированныйОбъект.Вставить("ИдентификаторОбъектаДокументооборота", 
				ВыборкаПравила.ИдентификаторОбъектаДокументооборота);
			
			Если ВыборкаПравила.Количество() = 1 Тогда
				
				Если ВыборкаПравила.ЕстьУсловия Тогда
					Правила = ИнтеграцияС1СДокументооборотВызовСервера.ПодходящиеПравила(ВыборкаОбъекты.Объект);
					Если Правила.Количество() = 0 Тогда
						Продолжить;
					КонецЕсли;
					ИнтегрированныйОбъект.Вставить("ПравилоЗаполнения", Правила[0].Ссылка);
				Иначе
					ИнтегрированныйОбъект.Вставить("ПравилоЗаполнения", ВыборкаПравила.ПравилоЗаполнения);
				КонецЕсли;
				
			Иначе // требуется уточнение
				
				Правила = ИнтеграцияС1СДокументооборотВызовСервера.ПодходящиеПравила(ВыборкаОбъекты.Объект);
				Если Правила.Количество() = 0 Тогда
					Продолжить;
				КонецЕсли;
				ИнтегрированныйОбъект.Вставить("ПравилоЗаполнения", Правила[0].Ссылка);
				
			КонецЕсли;
			
			МассивДанных.Добавить(ИнтегрированныйОбъект); 
			
		КонецЦикла;
		
	КонецЦикла;
	
	МенеджерВременныхТаблиц.Закрыть();
	
	Возврат МассивДанных;
	
КонецФункции

//Готовит сообщения обмена в Документооборот и записывает их в очередь на отправку.
//
Процедура ПодготовитьДанныеДляОтправки()
	
	УзелДокументооборота = ИнтеграцияС1СДокументооборотПовтИсп.УзелДокументооборота();
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	// Выборка всех изменений для данной интегрированной системы
	ИнтегрированныеОбъекты = ПолучитьМассивЗарегистрированныхДанных(УзелДокументооборота);
	
	Если ИнтегрированныеОбъекты.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ИмяВременногоФайла, "UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьXML.ЗаписатьНачалоЭлемента("Message");
	
	Для Каждого ИнтегрированныйОбъект Из ИнтегрированныеОбъекты Цикл
		
		ОбъектXDTO = ИнтеграцияС1СДокументооборот.ПолучитьXDTOИзмененийИзОбъекта(Прокси, ИнтегрированныйОбъект);
		
		Если ОбъектXDTO = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			Прокси.ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектXDTO);
		Исключение
			Инфо = ОписаниеОшибки();
			ЗаписьЖурналаРегистрации(
				ИнтеграцияС1СДокументооборот.ИмяСобытияЖурналаРегистрации(НСтр("ru = 'Выгрузка XDTO в XML'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())),
				УровеньЖурналаРегистрации.Ошибка,
				,
				ОбъектXDTO.Тип().Имя,
				ОбъектXDTO.Тип().Имя + Символы.ПС + Инфо);
		КонецПопытки;
		
	КонецЦикла;
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	ЗаписьXML.Закрыть();
	ДвоичныеДанныеСообщения = Новый ДвоичныеДанные(ИмяВременногоФайла);
	ДанныеСообщения = Новый ХранилищеЗначения(ДвоичныеДанныеСообщения, Новый СжатиеДанных(9));
	
	РегистрыСведений.ОчередьСообщенийВ1СДокументооборот.ДобавитьСообщение(ДанныеСообщения);
	#Если Сервер Тогда
	УдалитьФайлы(ИмяВременногоФайла);
	#КонецЕсли
	
	ПланыОбмена.УдалитьРегистрациюИзменений(УзелДокументооборота);
	
КонецПроцедуры

//Прочитывает данные из очереди на отправку и отправляет их в Документооборот.
//
Процедура ОтправитьДанные()
	
	Попытка
		
		ИдентификаторСообщения = Неопределено;
		МоментВремени = Неопределено;
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ОчередьСообщенийВ1СДокументооборот.МоментВремени КАК МоментВремени,
			|	ОчередьСообщенийВ1СДокументооборот.Данные КАК Данные,
			|	ОчередьСообщенийВ1СДокументооборот.Идентификатор КАК Идентификатор
			|ИЗ
			|	РегистрСведений.ОчередьСообщенийВ1СДокументооборот КАК ОчередьСообщенийВ1СДокументооборот
			|
			|УПОРЯДОЧИТЬ ПО
			|	МоментВремени");
		
		Результат = Запрос.Выполнить();
		
		Если Результат.Пустой() Тогда
			Возврат;
		КонецЕсли; 
		
		Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
		
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMPutChangesRequest");
		ОбщийРазмерСообщений = 0;
		ПредельныйРазмерСообщений = 
			ИнтеграцияС1СДокументооборотВызовСервера.МаксимальныйРазмерПередаваемогоФайла();
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			ИдентификаторСообщения = Выборка.Идентификатор;
			МоментВремени = Выборка.МоментВремени;
			
			ДвоичныеДанные = Выборка.Данные.Получить();
			
			ОбщийРазмерСообщений = ОбщийРазмерСообщений + ДвоичныеДанные.Размер();
			
			Если ОбщийРазмерСообщений > ПредельныйРазмерСообщений
				И Запрос.objects.Количество() > 0 Тогда
				
				Результат = Прокси.execute(Запрос);
				ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
				
				Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMPutChangesRequest");
				ОбщийРазмерСообщений = 0;
				
			КонецЕсли;
			
			ИмяФайлаСообщенияОбмена = ПолучитьИмяВременногоФайла("xml");
			ДвоичныеДанные.Записать(ИмяФайлаСообщенияОбмена);
			
			ЧтениеXML = Новый ЧтениеXML;
			ЧтениеXML.ОткрытьФайл(ИмяФайлаСообщенияОбмена);
			ЧтениеXML.Прочитать();
			ЧтениеXML.Прочитать();
			
			Пока ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Цикл
				// Выполняется последовательное чтение одного объекта за другим
				ТипXDTO = Прокси.ФабрикаXDTO.Тип("http://www.1c.ru/dm", ЧтениеXML.Имя);
				ОбъектXDTO = Прокси.ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ТипXDTO);
				Запрос.objects.Добавить(ОбъектXDTO);
			КонецЦикла;
			
			ЧтениеXML = Неопределено;
			#Если Сервер Тогда
			УдалитьФайлы(ИмяФайлаСообщенияОбмена);
			#КонецЕсли
			
		КонецЦикла; 
		
		Если Запрос.objects.Количество() > 0 Тогда
			Результат = Прокси.execute(Запрос);
			ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
		КонецЕсли;
		
		Выборка.Сбросить();
		
		Пока Выборка.Следующий() Цикл
			
			МенеджерЗаписи = РегистрыСведений.ОчередьСообщенийВ1СДокументооборот.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
			МенеджерЗаписи.Удалить();
			
		КонецЦикла;
		
	Исключение
		
		Инфо = ОписаниеОшибки();
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Интеграция с 1С:Документооборотом.Отправка данных'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.РегистрыСведений.ОчередьСообщенийВ1СДокументооборот,
			Строка(ИдентификаторСообщения),
			Запрос.Тип().Имя + Символы.ПС + Инфо);
			
		Если ИдентификаторСообщения <> Неопределено Тогда
			МенеджерЗаписи = РегистрыСведений.ОчередьСообщенийВ1СДокументооборот.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.МоментВремени = МоментВремени;
			МенеджерЗаписи.Идентификатор = ИдентификаторСообщения;
			МенеджерЗаписи.Прочитать();
			МенеджерЗаписи.КоличествоПопытокОтправки = МенеджерЗаписи.КоличествоПопытокОтправки + 1;
			МенеджерЗаписи.ТекстСообщенияОбОшибке = Инфо;
			МенеджерЗаписи.Записать();
		КонецЕсли;
		
	КонецПопытки; 
	
КонецПроцедуры

// Получает данные из Документооборота.
//
Процедура ПолучитьДанные()
	
	Попытка
		
		Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
		
		ПоддерживаетсяОбновлениеФайлов = 
			ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("2.1.9.1.CORP");
		ОбъектыКОбновлениюПечатныхФорм = Новый ТаблицаЗначений;
		ОбъектыКОбновлениюПечатныхФорм.Колонки.Добавить("Объект");
		ОбъектыКОбновлениюПечатныхФорм.Колонки.Добавить("ОбъектXDTO");
		ОбъектыКОбновлениюПечатныхФорм.Колонки.Добавить("Правило");
		
		УзелДокументооборота = ИнтеграцияС1СДокументооборотПовтИсп.УзелДокументооборота();
		СоставПланаОбмена = Метаданные.ПланыОбмена.ИнтеграцияС1СДокументооборотом.Состав;
		
		ПрочитаныВсеСообщения = Ложь;
		
		Пока Не ПрочитаныВсеСообщения Цикл
			
			Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetChangesRequest");
			Запрос.lastMessageId = Константы.НомерПоследнегоПринятогоСообщенияДокументооборота.Получить();
			
			Ответ = Прокси.execute(Запрос);
			ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Ответ);
			
			Для каждого ОбъектXDTO Из Ответ.objects Цикл
				
				Если ОбъектXDTO.objectId.type = "DMInternalDocumentTemplate"
					Или ОбъектXDTO.objectId.type = "DMIncomingDocumentTemplate"
					Или ОбъектXDTO.objectId.type = "DMOutgoingDocumentTemplate" Тогда
					
					Справочники.ПравилаИнтеграцииС1СДокументооборотом.ОбновитьПравилаПоШаблону(ОбъектXDTO);
					
					Продолжить;
					
				КонецЕсли;
				
				Ссылки = ИнтеграцияС1СДокументооборот.СсылкиПоВнешнимОбъектам(ОбъектXDTO);
				
				Для Каждого ОбъектСсылка Из Ссылки Цикл
					
					Правило = Справочники.ПравилаИнтеграцииС1СДокументооборотом.ПравилаИнтеграцииОбъекта(
						ОбъектСсылка, ОбъектXDTO.objectId.type);
					Если Правило = Неопределено Тогда
						Продолжить;
					КонецЕсли;
					
					Если ОбъектXDTO.Свойства().Получить("files") <> Неопределено
						И ОбъектXDTO.Установлено("files") Тогда
						
						Если ОбъектXDTO.files.Количество() <> 0 Тогда
							ИнтеграцияС1СДокументооборотПереопределяемый.
								ПриПоявленииПрисоединенныхФайловДокументооборота(ОбъектСсылка);
						Иначе
							ИнтеграцияС1СДокументооборотПереопределяемый.
								ПриУдаленииПрисоединенныхФайловДокументооборота(ОбъектСсылка);
						КонецЕсли;
						
					КонецЕсли;
					
					Объект = ОбъектСсылка.ПолучитьОбъект();
					
					ИсходнаяПометкаУдаления = Объект.ПометкаУдаления;
					
					ЕстьИзменения = Справочники.ПравилаИнтеграцииС1СДокументооборотом.
						ЗаполнитьОбъектПоОбъектуXDTO(Прокси, Объект, ОбъектXDTO, Правило, Истина);
						
					Если ЕстьИзменения Тогда
							
						Если Объект.ПометкаУдаления
							И Не ИсходнаяПометкаУдаления Тогда
							
							МетаданныеОбъекта = Объект.Метаданные();
							Если Метаданные.Документы.Содержит(МетаданныеОбъекта)
								И МетаданныеОбъекта.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить
								И Объект.Проведен Тогда
								Объект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
							Иначе
								Объект.ОбменДанными.Загрузка = Истина;
								Объект.Записать();
							КонецЕсли;
							
						Иначе
							
							ЗаполненКорректно = Объект.ПроверитьЗаполнение();
							
							Если ЗаполненКорректно Тогда
								Объект.ОбменДанными.Загрузка = Истина;
								Объект.Записать();
							Иначе
								СообщенияПользователю = ПолучитьСообщенияПользователю(Истина);
								ТекстСообщения = "";
								Для Каждого СообщениеПользователю Из СообщенияПользователю Цикл 
									ТекстСообщения = ТекстСообщения + СообщениеПользователю.Текст + Символы.ПС;
								КонецЦикла;
								ЗаписьЖурналаРегистрации(
									ИнтеграцияС1СДокументооборот.ИмяСобытияЖурналаРегистрации(
										НСтр("ru = 'Получение данных'",
											ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())),
									УровеньЖурналаРегистрации.Ошибка,
									Объект.Метаданные(),
									Объект,
									ТекстСообщения);
							КонецЕсли;
							
						КонецЕсли;
						
						Если ПоддерживаетсяОбновлениеФайлов
							И ИнтеграцияС1СДокументооборотКлиентСервер.ЭтоДокумент(ОбъектXDTO.objectId.type) Тогда
							КОбновлению = ОбъектыКОбновлениюПечатныхФорм.Добавить();
							КОбновлению.Объект = Объект;
							КОбновлению.ОбъектXDTO = ОбъектXDTO;
							КОбновлению.Правило = Правило;
						КонецЕсли;
					
						Если СоставПланаОбмена.Содержит(Объект.Метаданные()) Тогда
							ПланыОбмена.УдалитьРегистрациюИзменений(УзелДокументооборота, Объект.Ссылка);
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЦикла;
			
			// С версии 1.4.8 выполняется обновление состояний согласования на стороне ИС.
			Если Ответ.Свойства().Получить("records") <> Неопределено Тогда
				
				Для каждого ОбъектXDTO Из Ответ.records Цикл
					
					ЗапросСвязанныйОбъект = Новый Запрос(
						"ВЫБРАТЬ ПЕРВЫЕ 1
						|	Объект
						|ИЗ
						|	РегистрСведений.ОбъектыИнтегрированныеС1СДокументооборотом
						|ГДЕ
						|	ТипОбъектаДокументооборота = &ТипОбъектаДокументооборота
						|	И ИдентификаторОбъектаДокументооборота = &ИдентификаторОбъектаДокументооборота
						|");
					Если ИнтеграцияС1СДокументооборот.ПроверитьТип(Прокси, ОбъектXDTO, 
						"DMApprovalStateRecord") Тогда
						ЗапросСвязанныйОбъект.УстановитьПараметр("ТипОбъектаДокументооборота",
							ОбъектXDTO.type);
						ЗапросСвязанныйОбъект.УстановитьПараметр("ИдентификаторОбъектаДокументооборота",
							ОбъектXDTO.id);
						Выборка = ЗапросСвязанныйОбъект.Выполнить().Выбрать();
						Если Выборка.Следующий() Тогда
							Если ОбъектXDTO.status = Неопределено Тогда // запись удалена (например, прерывание)
								ИнтеграцияС1СДокументооборотВызовСервера.ПриИзмененииСостоянияСогласования(
									ОбъектXDTO.id,
									ОбъектXDTO.type,
									Неопределено,
									Ложь,
									Выборка.Объект);
							Иначе
								ИдентификаторСостояния = ОбъектXDTO.status.objectId.id;
								Состояние = Перечисления.СостоянияСогласованияВДокументообороте[ИдентификаторСостояния];
								ИнтеграцияС1СДокументооборотВызовСервера.ПриИзмененииСостоянияСогласования(
									ОбъектXDTO.id,
									ОбъектXDTO.type,
									Состояние,
									Ложь,
									Выборка.Объект,
									ОбъектXDTO.name,
									ОбъектXDTO.date);
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
			НомерИсходный = Константы.НомерПоследнегоПринятогоСообщенияДокументооборота.Получить();
			НомерПринятый = Строка(Ответ.messageId);
			Если НомерИсходный <> НомерПринятый Тогда
				Константы.НомерПоследнегоПринятогоСообщенияДокументооборота.Установить(НомерПринятый);
			КонецЕсли;
			
			ПрочитаныВсеСообщения = (Ответ.messageId = Неопределено);
			
			ОбновитьПечатныеФормы(ОбъектыКОбновлениюПечатныхФорм);
			
		КонецЦикла; 
		
	Исключение
		Инфо = ОписаниеОшибки();
		ЗаписьЖурналаРегистрации(
			ИнтеграцияС1СДокументооборот.ИмяСобытияЖурналаРегистрации(
				НСтр("ru = 'Получение данных'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Ошибка,
			,
			Запрос.Тип().Имя,
			Запрос.Тип().Имя + Символы.ПС + Инфо);
		
	КонецПопытки; 
		
КонецПроцедуры

// Обновляет печатные формы объекта ДО после изменения объекта ИС.
//
Процедура ОбновитьПечатныеФормы(ОбъектыКОбновлениюПечатныхФорм) Экспорт
	
	Если ОбъектыКОбновлениюПечатныхФорм.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMUpdateFilesRequest");
	ОбщийРазмерСообщений = 0;
	ПредельныйРазмерСообщений = 
		ИнтеграцияС1СДокументооборотВызовСервера.МаксимальныйРазмерПередаваемогоФайла();
		
	Для Каждого КОбновлению Из ОбъектыКОбновлениюПечатныхФорм Цикл
			
		СтруктураРеквизитов = ИнтеграцияС1СДокументооборот.
			СтруктураРеквизитовЗаполняемогоОбъектаДО(КОбновлению.ОбъектXDTO.objectId.type);
		Справочники.ПравилаИнтеграцииС1СДокументооборотом.ЗаполнитьПечатныеФормы(
			КОбновлению.Объект.Ссылка,
			СтруктураРеквизитов.Файлы,
			КОбновлению.Правило,
			Истина);
		Если СтруктураРеквизитов.Файлы.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ОбъектXDTO = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси,
			КОбновлению.ОбъектXDTO.objectId.type);
			
		ОбъектXDTO.name = Строка(КОбновлению.Объект);
		ОбъектXDTO.objectId = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, 
			КОбновлению.ОбъектXDTO.objectId.id,
			КОбновлению.ОбъектXDTO.objectId.type);
			
		Запрос.objects.Добавить(ОбъектXDTO);
		
		Для Каждого СтрокаФайла из СтруктураРеквизитов.Файлы Цикл
			ФайлXDTO = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMFile");
			ФайлXDTO.objectId = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, "", "DMFile");
			ФайлXDTO.name = "";
			ФайлXDTO.binaryData = СтрокаФайла.ДвоичныеДанные;
			ФайлXDTO.extension = СтрокаФайла.Расширение;
			ФайлXDTO.modificationDate = СтрокаФайла.ДатаСоздания;
			ФайлXDTO.modificationDateUniversal = СтрокаФайла.ДатаМодификацииУниверсальная;
			ФайлXDTO.name = СтрокаФайла.Наименование;
			ФайлXDTO.size = СтрокаФайла.Размер;
			ОбъектXDTO.files.Добавить(ФайлXDTO);
			ОбщийРазмерСообщений = ОбщийРазмерСообщений + СтрокаФайла.Размер;
		КонецЦикла;
		
		Если ОбщийРазмерСообщений > ПредельныйРазмерСообщений
			И Запрос.objects.Количество() > 0 Тогда
			Результат = Прокси.execute(Запрос);
			ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
			Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMUpdateFilesRequest");
			ОбщийРазмерСообщений = 0;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Запрос.objects.Количество() > 0 Тогда
		Результат = Прокси.execute(Запрос);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

