#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура загружает стандартные значения из макета с именем "СтандартныеЗначения".
// Имеет смысл заполнять значения из макета:
//  - при обновлении конфигурации (когда подключение к интернету может занять много времени);
//  - при первоначальном заполнении пустой базы, когда не заполнены параметры, логины и пароли для доступа к веб-сервисам обновлений.
//
// Параметры:
//  КонтекстВыполнения - Структура, Неопределено - структура контекста выполнения.
//
Процедура ЗагрузитьСтандартныеЗначения(КонтекстВыполнения = Неопределено) Экспорт

	ОбъектМетаданных = ПланыВидовХарактеристик.КатегорииНовостей; // Переопределение
	ИмяОбъектаМетаданных = "ПланыВидовХарактеристик.КатегорииНовостей"; // Переопределение
	ИмяСвойства = "ChartOfCharacteristicTypesObject_КатегорииНовостей"; // Переопределение
	ИдентификаторШага = НСтр("ru='Новости. Сервис и регламент. Загрузка стандартных значений. %ИмяСвойства%. Конец'");
	ИдентификаторШага = СтрЗаменить(ИдентификаторШага, "%ИмяСвойства%", ИмяСвойства);

	НаименованиеПроцедурыФункции = ИмяОбъектаМетаданных + ".ЗагрузитьСтандартныеЗначения"; // Идентификатор.
	ЗаписыватьВЖурналРегистрации = Ложь;
	Если КонтекстВыполнения = Неопределено Тогда
		КонтекстВыполнения = ИнтернетПоддержкаПользователейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций(); // Этот контекст.
		ЗаписыватьВЖурналРегистрации = Истина;
	КонецЕсли;
	КодРезультата = 0;
	ОписаниеРезультата = "";
	КонтекстВыполненияВложенный = ИнтернетПоддержкаПользователейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций(); // Контекст "по шагам".
	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		НаименованиеПроцедурыФункции, // Идентификатор.
		НСтр("ru='Загрузка стандартных значений'"));

		ТипСоответствие = Тип("Соответствие");
		ТипСтрока = Тип("Строка");

		СодержимоеМакета = ОбъектМетаданных.ПолучитьМакет("СтандартныеЗначения").ПолучитьТекст();
		ПоставляемыеДанныеОбъекта = Новый Соответствие;
		ПоставляемыеДанныеОбъекта.Вставить(
			"" + ИмяОбъектаМетаданных + ":СтандартныеЗначения", // Идентификатор.
			СодержимоеМакета);
		ОбработкаНовостейВызовСервера.ПолучитьДополнительныеСтандартныеЗначенияКлассификаторов(ИмяОбъектаМетаданных, ПоставляемыеДанныеОбъекта);
		Если ТипЗнч(ПоставляемыеДанныеОбъекта) = ТипСоответствие Тогда
			Для Каждого СтрокаСтандартныхЗначений Из ПоставляемыеДанныеОбъекта Цикл
				Если (ТипЗнч(СтрокаСтандартныхЗначений.Значение) = ТипСтрока)
						И (НЕ ПустаяСтрока(СтрокаСтандартныхЗначений.Значение)) Тогда
					ЕстьОшибки = Ложь;
					Попытка
						ОписаниеРезультата = ОписаниеРезультата
							+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='Попытка загрузки стандартных значений из строки (первые 2000 символов):
									|%1'")
									+ Символы.ПС,
								Лев(СтрокаСтандартныхЗначений.Значение, 2000));
						ЧтениеХМЛ = Новый ЧтениеXML;
						ЧтениеХМЛ.УстановитьСтроку(СтрокаСтандартныхЗначений.Значение);
						ЧтениеХМЛ.Прочитать();
					Исключение
						ИнформацияОбОшибке = ИнформацияОбОшибке();
						ОписаниеРезультата = ОписаниеРезультата
							+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='Ошибка загрузки стандартных значений из строки по причине:
									|%1'"),
								ПодробноеПредставлениеОшибки(ИнформацияОбОшибке))
							+ Символы.ПС;
						ЕстьОшибки = Истина;
					КонецПопытки;
					Если ЕстьОшибки <> Истина Тогда
						ХМЛТип = ПолучитьXMLТип(ЧтениеХМЛ);
						Если (НРег(ХМЛТип.ИмяТипа) = НРег("DefaultData")) Тогда // И (ВРег(ХМЛТип.URIПространстваИмен)=ВРег("http://v8.1c.ru/8.1/data/enterprise/current-config"))
							ОбъектХДТО = ФабрикаXDTO.ПрочитатьXML(ЧтениеХМЛ);
							СвойствоОбъект = ОбъектХДТО.Свойства().Получить(ИмяСвойства);
							Если ТипЗнч(СвойствоОбъект) = Тип("СвойствоXDTO") Тогда
								Если (СвойствоОбъект.ВерхняяГраница = -1) ИЛИ (СвойствоОбъект.ВерхняяГраница > 1) Тогда
									СписокХДТО = ОбъектХДТО.ПолучитьСписок(СвойствоОбъект);
									Для каждого лкТекущийОбъект Из СписокХДТО Цикл
										ЗагрузитьСтандартноеЗначение(лкТекущийОбъект, ОбъектМетаданных, ИмяСвойства, ОписаниеРезультата);
									КонецЦикла;
								ИначеЕсли (СвойствоОбъект.НижняяГраница = 1) И (СвойствоОбъект.ВерхняяГраница = 1) Тогда
									ЗагрузитьСтандартноеЗначение(ОбъектХДТО.Получить(СвойствоОбъект), ОбъектМетаданных, ИмяСвойства, ОписаниеРезультата);
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;

	ШагВыполнения = ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата, // Много действий, всегда установлено в 0, надо читать данные по каждому шагу.
		ОписаниеРезультата,
		КонтекстВыполненияВложенный);

	Если ЗаписыватьВЖурналРегистрации = Истина Тогда

		ИнтернетПоддержкаПользователейВызовСервера.ЗаписатьСообщениеВЖурналРегистрации(
			НСтр("ru='БИП:Новости.Сервис и регламент'"), // ИмяСобытия
			ИдентификаторШага, // ИдентификаторШага
			?(КодРезультата > 0,
				УровеньЖурналаРегистрации.Ошибка,
				УровеньЖурналаРегистрации.Информация), // УровеньЖурналаРегистрации.*
			, // ОбъектМетаданных
			(ШагВыполнения.ВремяОкончания - ШагВыполнения.ВремяНачала), // Данные
			ОбработкаНовостейВызовСервера.КомментарийДляЖурналаРегистрации(
				НаименованиеПроцедурыФункции,
				ШагВыполнения,
				КонтекстВыполнения,
				"Простой"), // Комментарий
			ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации

	КонецЕсли;

КонецПроцедуры

// Процедура загружает стандартное значение из макета с именем "СтандартныеЗначения".
//
// Параметры:
//  ОбъектХДТО       - Объект ХДТО - загружаемый объект;
//  ОбъектМетаданных - Объект метаданных;
//  ИмяСвойства      - Строка - имя свойства;
//  ЛогЗагрузки      - Строка - сюда будет писаться состояние загрузки данных.
//
Процедура ЗагрузитьСтандартноеЗначение(ОбъектХДТО, ОбъектМетаданных, ИмяСвойства, ЛогЗагрузки)

	СтрокаЛогаЗагрузки = "";

	Попытка
		// Если объект был загружен ранее (есть другой объект с таким же кодом), то подставить
		//  в создаваемый объект ссылку на созданный ранее элемент.
		НайденныйЭлемент = ОбъектМетаданных.НайтиПоКоду(ОбъектХДТО.Code);
		Если НайденныйЭлемент.Пустая() Тогда
			// Нет ранее созданных элементов с таким же кодом - оставить как есть.
			СтрокаЛогаЗагрузки = "Создание: " + СокрЛП(ОбъектХДТО.Code);
		Иначе
			// Подменить на ранее созданный элемент с таким же кодом.
			ОбъектХДТО.Ref = НайденныйЭлемент.Ссылка;
			СтрокаЛогаЗагрузки = "Изменение: " + СокрЛП(НайденныйЭлемент.Код) + ", " + СокрЛП(НайденныйЭлемент.Наименование) + "";
		КонецЕсли;
		ТекущийОбъект = СериализаторXDTO.ПрочитатьXDTO(ОбъектХДТО);
		ТекущийОбъект.Записать();
		// После записи классификатора можно провести дополнительные обработки.
		ОбработкаНовостейВызовСервера.ДополнительноОбработатьКлассификаторПослеПолученияПослеЗаписи(ТекущийОбъект.Ссылка);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ИдентификаторШага = НСтр("ru='Новости. Сервис и регламент. Загрузка стандартных значений. %ИмяСвойства%. Ошибка'");
		ИдентификаторШага = СтрЗаменить(ИдентификаторШага, "%ИмяСвойства%", ИмяСвойства);
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не удалось записать объект метаданных по причине:
				|%1'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ИнтернетПоддержкаПользователейВызовСервера.ЗаписатьСообщениеВЖурналРегистрации(
			НСтр("ru='БИП:Новости.Сервис и регламент'"), // ИмяСобытия
			ИдентификаторШага, // ИдентификаторШага
			УровеньЖурналаРегистрации.Ошибка, // УровеньЖурналаРегистрации.*
			ОбъектМетаданных, // ОбъектМетаданных
			, // Данные
			ТекстСообщения, // Комментарий
			ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации
		СтрокаЛогаЗагрузки = СтрокаЛогаЗагрузки + ". "
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Произошла ошибка записи: %1'"),
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;

	ЛогЗагрузки = ЛогЗагрузки + СтрокаЛогаЗагрузки + Символы.ПС;

КонецПроцедуры

// Возвращает реквизиты справочника, которые образуют естественный ключ для элементов справочника.
// Используется для сопоставления элементов механизмом "Выгрузка/загрузка областей данных".
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Массив(Строка) - массив имен реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт

	Результат = Новый Массив;

	Результат.Добавить("Код");

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)

	СтандартнаяОбработка = Истина;

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

	ТипСтруктура     = Тип("Структура");
	ТипЛентаНовостей = Тип("СправочникСсылка.ЛентыНовостей");

	Если ТипЗнч(Параметры) = ТипСтруктура Тогда
		Если Параметры.Свойство("ЛентаНовостей") Тогда
			лкЛентаНовостей = Неопределено;
			Параметры.Свойство("ЛентаНовостей", лкЛентаНовостей);
			Если ТипЗнч(лкЛентаНовостей) = ТипЛентаНовостей
					И (НЕ лкЛентаНовостей.Пустая()) Тогда
				МассивДоступныхКатегорий = лкЛентаНовостей.ДоступныеКатегорииНовостей.ВыгрузитьКолонку("КатегорияНовостей");
				Если МассивДоступныхКатегорий.Количество() > 0 Тогда
					ДанныеВыбора = Новый СписокЗначений;
					ДанныеВыбора.ЗагрузитьЗначения(МассивДоступныхКатегорий);
					СтандартнаяОбработка = Ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

#КонецЕсли

КонецПроцедуры

#КонецОбласти
