#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ОблачныйАрхивПовтИсп.РазрешенаРаботаСОблачнымАрхивом() Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	ЭтотОбъект.ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылки;

	ТипСтруктура = Тип("Структура");

	// Сбор информации запускается сразу, а не фоновым заданием.
	ЗагрузитьСтатистику(300);

	ИнформацияОКлиенте = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("ИнформацияОКлиенте", ИмяКомпьютера());
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ИнформацияОКлиенте, "ИдентификаторКомпьютера, КаталогУстановкиАгентаКопирования, ЛогинАдминистратораОС");
	Если ПустаяСтрока(ЭтотОбъект.ЛогинАдминистратораОС) Тогда
		ЭтотОбъект.ПарольАдминистратораОС = "";
		Элементы.ПарольАдминистратораОС.ПодсказкаВвода = "";
	Иначе
		ЭтотОбъект.ПарольАдминистратораОС = " ";
		Элементы.ПарольАдминистратораОС.ПодсказкаВвода = НСтр("ru='Введите пароль'");
	КонецЕсли;
	ЭтотОбъект.ПараметрыАдминистратораОСБылиИзменены = Ложь;

	// Проверка актуальности установленного Агента резервного копирования.
	ПроверкаНеобходимостиОбновленияАгента = ОблачныйАрхив.ПроверкаАктуальностиУстановленногоАгентаРезервногоКопирования(ИнформацияОКлиенте);
	//   Структура - структура с ключами:
	//    * ТребуетсяУстановка - Булево;
	//    * ТребуетсяОбновление - Число - Признак необходимости обновления:
	//        ** 0 - не требуется;
	//        ** 1 - есть файл обновления;
	//        ** 2 - рекомендуется обновление (текущая установленная версия скоро станет неактуальной);
	//        ** 3 - необходимо обновление (текущая установленная версия неактуальна).
	//    * ВерсияНовейшегоАгентаКопирования - Строка - версия самого актуального агента резервного копирования;
	//    * СрокГодностиАгентаКопирования    - Дата;
	//    * РазмерДистрибутиваБайт           - Число;
	//    * СсылкаНаСкачивание               - Строка;
	//    * КонтрольнаяСумма                 - Строка;
	//    * ТекстЧтоНовогоВВерсии            - Строка;
	//    * ТекстПорядокОбновления           - Строка.
	//

	// Если на текущем компьютере установлен АБАгент, но он не активирован ни на этот, ни на какой другой логин,
	//  то активировать автоматически. ////! Реализовать.

	// Настройки ПараметрыОкруженияСервер.
	ПараметрыОкруженияСервер = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("ПараметрыОкруженияСервер");
	ЭтотОбъект.ИмяИБ = ПараметрыОкруженияСервер.ИмяИБ;
	ЭтотОбъект.ИмяИБ_Полный =
		ЭтотОбъект.ИмяИБ
			+ ОблачныйАрхивКлиентСервер.ПолучитьОписаниеСуффиксовИдентификаторовИБ().АвтоматическаяКопия.Описание;
	ЭтотОбъект.ИдентификаторИБ = ПараметрыОкруженияСервер.ИдентификаторИБ;
	ЭтотОбъект.ИдентификаторИБ_Полный =
		ЭтотОбъект.ИдентификаторИБ
			+ ОблачныйАрхивКлиентСервер.ПолучитьОписаниеСуффиксовИдентификаторовИБ().АвтоматическаяКопия.Суффикс;
	Элементы.ИмяИБ.Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Идентификатор ИБ: %1'"),
		ЭтотОбъект.ИдентификаторИБ);

	// Настройки НастройкиАгентаКопированияОбщие.
	НастройкиАгентаКопированияОбщие = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("НастройкиАгентаКопированияОбщие");
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиАгентаКопированияОбщие, "КоличествоХранимыхКопий_Ежедневные, КоличествоХранимыхКопий_Еженедельные, КоличествоХранимыхКопий_Ежемесячные");

	// Настройки НастройкиАгентаКопированияКлиент.
	НастройкиАгентаКопированияКлиент = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("НастройкиАгентаКопированияКлиент", ИмяКомпьютера());
	ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования = НастройкиАгентаКопированияКлиент.РасписаниеАвтоматическогоРезервногоКопирования;

	// Настройка внешнего вида формы.
	МассивПодстрок = Новый Массив;
	МассивПодстрок.Добавить(
		Новый ФорматированнаяСтрока(
			НСтр("ru='Журнал работы'"),,ЦветаСтиля.ЦветГиперссылки,,"backup1C:BackupAgentEventLog"));
	МассивПодстрок.Добавить(" ");
	МассивПодстрок.Добавить(НСтр("ru='Агента резервного копирования.'"));
	МассивПодстрок.Добавить(Символы.ПС);
	МассивПодстрок.Добавить(Символы.ПС);
	Если ПроверкаНеобходимостиОбновленияАгента.ТребуетсяУстановка = Истина Тогда
		МассивПодстрок.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru='На этом компьютере не установлен Агент резервного копирования.'"),
				Новый Шрифт(Элементы.ДекорацияЖурналРаботыРезервногоКопированияИВерсияАгента.Шрифт,,,Истина),
				ЦветаСтиля.ЦветОсобогоТекста));
		МассивПодстрок.Добавить(Символы.ПС);
	Иначе
		МассивПодстрок.Добавить(НСтр("ru='Установленная версия Агента резервного копирования:'"));
		МассивПодстрок.Добавить(" ");
		МассивПодстрок.Добавить(
			Новый ФорматированнаяСтрока(
				ИнтернетПоддержкаПользователейКлиентСервер.ПользовательскоеПредставлениеНомераВерсии(
					ИнформацияОКлиенте.ВерсияУстановленногоАгентаКопирования,
					Ложь),
				Новый Шрифт(Элементы.ДекорацияЖурналРаботыРезервногоКопированияИВерсияАгента.Шрифт,,,Истина)));
		МассивПодстрок.Добавить(Символы.ПС);
	КонецЕсли;
	МассивПодстрок.Добавить(НСтр("ru='Установленная версия подсистемы Облачный архив:'"));
	МассивПодстрок.Добавить(" ");
	МассивПодстрок.Добавить(
		Новый ФорматированнаяСтрока(
			ИнтернетПоддержкаПользователейКлиентСервер.ПользовательскоеПредставлениеНомераВерсии(
				ПараметрыОкруженияСервер.ВерсияПодсистемы,
				Ложь),
			Новый Шрифт(Элементы.ДекорацияЖурналРаботыРезервногоКопированияИВерсияАгента.Шрифт,,,Истина)));
	МассивПодстрок.Добавить(Символы.ПС);
	МассивПодстрок.Добавить(Символы.ПС);
	// Есть обновление Агента резервного копирования?
	Если ПроверкаНеобходимостиОбновленияАгента.ТребуетсяУстановка = Истина Тогда
		// Управлять настройками агента невозможно, если он не установлен.
		Элементы.ГруппаОбщаяИнформация.Доступность = Ложь;
		Элементы.ГруппаНастройкаРасписания.Доступность = Ложь;
		Элементы.ГруппаПараметрыХраненияРезервныхКопий.Доступность = Ложь;
		Элементы.ГруппаЗапускСервисаВWindows.Доступность = Ложь;
		Элементы.ФормаКомандаГотово.Видимость = Ложь;
	ИначеЕсли ПроверкаНеобходимостиОбновленияАгента.ТребуетсяОбновление = 1 Тогда // Доступно обновление.
		МассивПодстрок.Добавить(НСтр("ru='Доступна новая версия Агента резервного копирования:'"));
		МассивПодстрок.Добавить(" ");
		МассивПодстрок.Добавить(
			Новый ФорматированнаяСтрока(
				ИнтернетПоддержкаПользователейКлиентСервер.ПользовательскоеПредставлениеНомераВерсии(
					ПроверкаНеобходимостиОбновленияАгента.ВерсияНовейшегоАгентаКопирования,
					Ложь),
				Новый Шрифт(Элементы.ДекорацияЖурналРаботыРезервногоКопированияИВерсияАгента.Шрифт,,,Истина)));
		МассивПодстрок.Добавить(". ");
		МассивПодстрок.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru='Обновить'"),,ЦветаСтиля.ЦветГиперссылки,,"backup1C:UpdateAgentOnThisPC"));
		МассивПодстрок.Добавить(".");
		МассивПодстрок.Добавить(Символы.ПС);
		МассивПодстрок.Добавить(Символы.ПС);
	ИначеЕсли ПроверкаНеобходимостиОбновленияАгента.ТребуетсяОбновление = 2 Тогда // Рекомендуется обновление.
		МассивПодстрок.Добавить(НСтр("ru='Рекомендуется обновить Агента резервного копирования на версию:'"));
		МассивПодстрок.Добавить(" ");
		МассивПодстрок.Добавить(Новый ФорматированнаяСтрока(
			ИнтернетПоддержкаПользователейКлиентСервер.ПользовательскоеПредставлениеНомераВерсии(
				ПроверкаНеобходимостиОбновленияАгента.ВерсияНовейшегоАгентаКопирования,
				Ложь),
			Новый Шрифт(Элементы.ДекорацияЖурналРаботыРезервногоКопированияИВерсияАгента.Шрифт,,,Истина)));
		МассивПодстрок.Добавить(". ");
		МассивПодстрок.Добавить(Новый ФорматированнаяСтрока(
			НСтр("ru='Обновить'"),,ЦветаСтиля.ЦветГиперссылки,,"backup1C:UpdateAgentOnThisPC"));
		МассивПодстрок.Добавить(".");
		МассивПодстрок.Добавить(Символы.ПС);
		МассивПодстрок.Добавить(Символы.ПС);
	ИначеЕсли ПроверкаНеобходимостиОбновленияАгента.ТребуетсяОбновление = 3 Тогда // Необходимо обновление.
		МассивПодстрок.Добавить(НСтр("ru='Необходимо обновить Агента резервного копирования на версию:'"));
		МассивПодстрок.Добавить(" ");
		МассивПодстрок.Добавить(Новый ФорматированнаяСтрока(
			ИнтернетПоддержкаПользователейКлиентСервер.ПользовательскоеПредставлениеНомераВерсии(
				ПроверкаНеобходимостиОбновленияАгента.ВерсияНовейшегоАгентаКопирования,
				Ложь),
			Новый Шрифт(Элементы.ДекорацияЖурналРаботыРезервногоКопированияИВерсияАгента.Шрифт,,,Истина)));
		МассивПодстрок.Добавить(". ");
		МассивПодстрок.Добавить(Новый ФорматированнаяСтрока(
			НСтр("ru='Обновить'"),,ЦветаСтиля.ЦветГиперссылки,,"backup1C:UpdateAgentOnThisPC"));
		МассивПодстрок.Добавить(".");
		МассивПодстрок.Добавить(Символы.ПС);
		МассивПодстрок.Добавить(Символы.ПС);
	КонецЕсли;

	Элементы.ДекорацияЖурналРаботыРезервногоКопированияИВерсияАгента.Заголовок = Новый ФорматированнаяСтрока(МассивПодстрок);

	ЭтотОбъект.РасписаниеВключено = Ложь;
	Если ТипЗнч(ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования) = ТипСтруктура Тогда
		Если ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования.Свойство("РасписаниеВключено") Тогда
			ЭтотОбъект.РасписаниеВключено = (ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования.РасписаниеВключено = Истина);
		КонецЕсли;
	КонецЕсли;

	ЭтотОбъект.КаталогИБ = ОбщегоНазначенияКлиентСервер.КаталогФайловойИнформационнойБазы();
	ЭтотОбъект.КаталогИБ = ОблачныйАрхивКлиентСервер.ПривестиИмяКаталогаКПолномуВиду(ЭтотОбъект.КаталогИБ);

	Элементы.ГруппаОшибка.Видимость = Ложь;

	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	#Если НЕ ВебКлиент Тогда

		// Попробовать автоматически получить идентификатор компьютера, если он не заполнен.
		Если ПустаяСтрока(ЭтотОбъект.ИдентификаторКомпьютера) Тогда
			ИмяВременногоФайлаВывода = ПолучитьИмяВременногоФайла("txt");
			СтрокаКоманды = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"%1\Sysnative\reg.exe query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography /v MachineGuid > %2",
				"%WinDir%",
				ИмяВременногоФайлаВывода);
			КомандаСистемы(СтрокаКоманды, КаталогВременныхФайлов());
			ФайлВывода = Новый Файл(ИмяВременногоФайлаВывода);
			Если ФайлВывода.Существует() Тогда
				ЧтениеТекста = Новый ЧтениеТекста(ИмяВременногоФайлаВывода, КодировкаТекста.ANSI, Символы.ПС, Символы.ПС, Ложь);
					ТекущаяСтрокаТекста = ЧтениеТекста.ПрочитатьСтроку(Символы.ПС);
					ТекущаяСтрокаТекста = СтрЗаменить(ТекущаяСтрокаТекста, Символ(10), "");
					ТекущаяСтрокаТекста = СтрЗаменить(ТекущаяСтрокаТекста, Символ(13), "");
					Пока ТекущаяСтрокаТекста <> Неопределено Цикл
						Если СтрНайти(ТекущаяСтрокаТекста, "MachineGuid") > 0 Тогда
							МассивПодстрок = СтрРазделить(ТекущаяСтрокаТекста, " ", Ложь);
							Если МассивПодстрок.Количество() >= 3 Тогда
								ЭтотОбъект.ИдентификаторКомпьютера = МассивПодстрок[2];
							КонецЕсли;
						КонецЕсли;
						ТекущаяСтрокаТекста = ЧтениеТекста.ПрочитатьСтроку(Символы.ПС);
					КонецЦикла;
				ЧтениеТекста.Закрыть();
			КонецЕсли;
			Попытка
				УдалитьФайлы(ИмяВременногоФайлаВывода);
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
			КонецПопытки;
		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	ТипУправляемаяФорма = Тип("УправляемаяФорма");
	ТипСтруктура = Тип("Структура");

	Если ТипЗнч(ИсточникВыбора) = ТипУправляемаяФорма Тогда
		Если ИсточникВыбора.КлючНазначенияИспользования = "НастройкаРасписания" Тогда
			Если ТипЗнч(ВыбранноеЗначение) = ТипСтруктура Тогда
				ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования = ВыбранноеЗначение;
				УправлениеФормой(ЭтотОбъект); // Перерисовать надписи.
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	ПрочиеПараметры = Новый Структура("РасписаниеАвтоматическогоРезервногоКопирования",
		ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования);
	ОблачныйАрхивКлиент.ОбработкаНавигационнойСсылки(
		ЭтотОбъект,
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка,
		ПрочиеПараметры);

КонецПроцедуры

&НаКлиенте
Процедура РасписаниеВключеноПриИзменении(Элемент)

	ТипСтруктура = Тип("Структура");

	Если ТипЗнч(ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования) = ТипСтруктура Тогда
		ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования.Вставить("РасписаниеВключено", ЭтотОбъект.РасписаниеВключено);
	КонецЕсли;

	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ИмяИБПриИзменении(Элемент)

	ЭтотОбъект.ИмяИБ = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(СокрЛП(ЭтотОбъект.ИмяИБ), "");
	ЭтотОбъект.ИмяИБ_Полный =
		ЭтотОбъект.ИмяИБ
			+ ОблачныйАрхивКлиентСервер.ПолучитьОписаниеСуффиксовИдентификаторовИБ().АвтоматическаяКопия.Описание;

КонецПроцедуры

&НаКлиенте
Процедура ЛогинАдминистратораОСПриИзменении(Элемент)

	ЭтотОбъект.ПараметрыАдминистратораОСБылиИзменены = Истина;
	Если ПустаяСтрока(ЭтотОбъект.ЛогинАдминистратораОС) Тогда
		Элементы.ПарольАдминистратораОС.ПодсказкаВвода = "";
		ЭтотОбъект.ПарольАдминистратораОС = "";
	Иначе
		Элементы.ПарольАдминистратораОС.ПодсказкаВвода = НСтр("ru='Введите пароль'");
		Если ЭтотОбъект.ПарольАдминистратораОС = " " Тогда
			ЭтотОбъект.ПарольАдминистратораОС = "";
		КонецЕсли;
	КонецЕсли;

	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПарольАдминистратораОСПриИзменении(Элемент)

	ЭтотОбъект.ПараметрыАдминистратораОСБылиИзменены = Истина;

	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПарольАдминистратораОСОткрытие(Элемент, СтандартнаяОбработка)

	Элемент.РежимПароля = НЕ Элемент.РежимПароля;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписатьИЗакрытьНажатие(Команда)

	БылиОшибки = Ложь;

	// Сохранить все настройки.
	ЗаписатьВсеНастройкиНаСервере();

	// Если изменился логин / пароль администратора ОС, инициализировать Агента резервного копирования.
	#Если НЕ ВебКлиент Тогда

		Если ЭтотОбъект.ПараметрыАдминистратораОСБылиИзменены Тогда
			Если (НЕ ПустаяСтрока(ЭтотОбъект.ЛогинАдминистратораОС)) Тогда
				Если (НЕ ПустаяСтрока(ЭтотОбъект.ПарольАдминистратораОС)) Тогда

					// Если в логине присутствуют запрещенные для командной строки символы, то надо обрамить параметр в кавычки.
					Если ОблачныйАрхивКлиентСервер.ЕстьЗапрещенныеСимволыДляКоманднойСтроки(ЭтотОбъект.ЛогинАдминистратораОС) = Истина Тогда
						ПараметрЛогин = " -login=" + """" + ЭтотОбъект.ЛогинАдминистратораОС + """";
					Иначе
						ПараметрЛогин = " -login=" + ЭтотОбъект.ЛогинАдминистратораОС;
					КонецЕсли;

					// Если в пароле присутствуют запрещенные для командной строки символы, то надо обрамить параметр в кавычки.
					Если ОблачныйАрхивКлиентСервер.ЕстьЗапрещенныеСимволыДляКоманднойСтроки(ЭтотОбъект.ПарольАдминистратораОС) = Истина Тогда
						ПараметрПароль = " -password=" + """" + ЭтотОбъект.ПарольАдминистратораОС + """";
					Иначе
						ПараметрПароль = " -password=" + ЭтотОбъект.ПарольАдминистратораОС;
					КонецЕсли;

					КодВозврата = 0;
					СтрокаКоманды = 
						"BackupAgent.exe"
						+ " set_local_user"
						+ ПараметрЛогин
						+ ПараметрПароль;
					ЗапуститьПриложение(СтрокаКоманды, ЭтотОбъект.КаталогУстановкиАгентаКопирования, Истина, КодВозврата);
					Если КодВозврата <> 0 Тогда
						ТекстСообщения = НСтр("ru='Неверно указан логин или пароль'");
						Сообщение = Новый СообщениеПользователю();
						Сообщение.Текст = ТекстСообщения;
						Сообщение.Поле  = "ЛогинАдминистратораОС";
						Сообщение.УстановитьДанные(ЭтотОбъект);
						Сообщение.Сообщить();
						БылиОшибки = Истина;
					КонецЕсли;

					// После установки нового логина / пароля необходимо заново инициализировать расписание,
					//  т.к. расписания сохранены со старым логином / паролем.
					Если ЭтотОбъект.РасписаниеВключено = Истина Тогда
						// Необходимо инициализировать расписание и для всех остальных баз данных.
						// Для этого надо будет зайти в каждую базу и в настройках выбрать тот же логин и пароль.
						// Автоматизировать этот процесс невозможно.
						// ////! Реализовать вывод инструкции.
					КонецЕсли;

				Иначе

					ТекстСообщения = НСтр("ru='Не заполнен пароль'");
					Сообщение = Новый СообщениеПользователю();
					Сообщение.Текст = ТекстСообщения;
					Сообщение.Поле  = "ПарольАдминистратораОС";
					Сообщение.УстановитьДанные(ЭтотОбъект);
					Сообщение.Сообщить();
					БылиОшибки = Истина;

				КонецЕсли;

			КонецЕсли;
		КонецЕсли;

	#КонецЕсли

	ИнициализироватьРасписание();

	Если БылиОшибки = Ложь Тогда
		ЭтотОбъект.Закрыть(Истина);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьРасписание()

	Перем ЗаписьХМЛ, ИмяВременногоФайлаНастроекИБ, НомерНедели, СписокДнейМесяца, СписокДнейНедели, СтрокаКоманды;
	Перем ТекущееРасписание, ТекущийДеньМесяца, ТекущийДеньМесяцаПредставление, ТекущийДеньНедели, ТекущийДеньНеделиПредставление;

	Т1 = ТекущаяУниверсальнаяДатаВМиллисекундах();
	КонтекстВыполнения = ИнтернетПоддержкаПользователейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций();

	#Если НЕ ВебКлиент Тогда

	// 1. Если отключили расписание, то отключить его с помощью BackupAgent.exe
	//    (на клиенте, т.к. на сервере не работает "КомандаСистемы").
	Если ЭтотОбъект.РасписаниеВключено = Ложь Тогда

		ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
			КонтекстВыполнения,
			"ОблачныйАрхив.НастройкаОблачногоАрхива.ИнициализироватьРасписание/Отключение расписания", // Идентификатор.
			НСтр("ru='Инициализация нового расписания для утилиты резервного копирования / Отключение расписания'"));

			СтрокаКоманды =
				"BackupAgent.exe"
				+ " stop_backup -db_id="
				+ ЭтотОбъект.ИдентификаторИБ_Полный;
			КомандаСистемы(СтрокаКоманды, ЭтотОбъект.КаталогУстановкиАгентаКопирования);

		ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
			КонтекстВыполнения,
			0,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Расписание отключено.
					|Строка команды: %1
					|Каталог установки агента копирования: %2'"),
				СтрокаКоманды,
				ЭтотОбъект.КаталогУстановкиАгентаКопирования),
			Неопределено);

	Иначе

		ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
			КонтекстВыполнения,
			"ОблачныйАрхив.НастройкаОблачногоАрхива.ИнициализироватьРасписание/Изменение расписания/Создание файла настроек", // Идентификатор.
			НСтр("ru='Инициализация нового расписания для утилиты резервного копирования / Изменение / Создание файла настроек'"));

			// Сохранить расписание в файле настроек.
			ИмяВременногоФайлаНастроекИБ = ПолучитьИмяВременногоФайла("xml");
			ЗаписьХМЛ = Новый ЗаписьXML;
			ЗаписьХМЛ.ОткрытьФайл(
				ИмяВременногоФайлаНастроекИБ,
				Новый ПараметрыЗаписиXML(
					"UTF-8",
					"1.0",
					Истина,
					Истина,
					Символы.Таб));

				ЗаписьХМЛ.ЗаписатьОбъявлениеXML();

				ЗаписьХМЛ.ЗаписатьНачалоЭлемента("DatabaseBackupConfiguration");
					ЗаписьХМЛ.ЗаписатьНачалоЭлемента("Database");

						ЗаписьХМЛ.ЗаписатьНачалоЭлемента("DB_ID");
							ЗаписьХМЛ.ЗаписатьТекст(ЭтотОбъект.ИдентификаторИБ_Полный);
						ЗаписьХМЛ.ЗаписатьКонецЭлемента();

						ЗаписьХМЛ.ЗаписатьНачалоЭлемента("DBName");
							ЗаписьХМЛ.ЗаписатьТекст(ЭтотОбъект.ИмяИБ_Полный);
						ЗаписьХМЛ.ЗаписатьКонецЭлемента();

						ЗаписьХМЛ.ЗаписатьНачалоЭлемента("DBFolder");
							// Преобразовать подключенные диски в сетевые пути, т.к. при работе сервиса (которая запущена от имени администратора),
							//  у администратора могут быть НЕ подключены такие же сетевые диски.
							ЗаписьХМЛ.ЗаписатьТекст(ЭтотОбъект.КаталогИБ);
						ЗаписьХМЛ.ЗаписатьКонецЭлемента();

					ЗаписьХМЛ.ЗаписатьКонецЭлемента(); // Database.

					ЗаписьХМЛ.ЗаписатьНачалоЭлемента("Schedule");

						// Все время надо указывать в GMT.
						// Настройки расписания в регистре сведений хранятся в текущем часовом поясе.
						Если ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования.Вариант = "Ежедневно_ОдинРазВДень" Тогда
							ТекущееРасписание = ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования.Ежедневно_ОдинРазВДень;
							ЗаписьХМЛ.ЗаписатьНачалоЭлемента("BackupDaily");
							ЗаписьХМЛ.ЗаписатьАтрибут("time", Формат(УниверсальноеВремя(ТекущееРасписание.Время), "ДФ=HH:mm:ss"));
							ЗаписьХМЛ.ЗаписатьКонецЭлемента();
						ИначеЕсли ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования.Вариант = "Ежедневно_НесколькоРазВДень" Тогда
							ТекущееРасписание = ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования.Ежедневно_НесколькоРазВДень;
							ЗаписьХМЛ.ЗаписатьНачалоЭлемента("BackupDaily");
							ЗаписьХМЛ.ЗаписатьАтрибут("time", Формат(УниверсальноеВремя(ТекущееРасписание.ВремяНачала), "ДФ=HH:mm:ss"));
							ЗаписьХМЛ.ЗаписатьАтрибут("endTime", Формат(УниверсальноеВремя(ТекущееРасписание.ВремяОкончания), "ДФ=HH:mm:ss"));
							ЗаписьХМЛ.ЗаписатьАтрибут("repeatHours", Формат(ТекущееРасписание.КоличествоЧасовПовтора, "ЧЦ=2; ЧН=0; ЧГ=0"));
							ЗаписьХМЛ.ЗаписатьКонецЭлемента();
						ИначеЕсли ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования.Вариант = "Еженедельно" Тогда
							ТекущееРасписание = ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования.Еженедельно;
							СписокДнейНедели = "";
							Для Каждого ТекущийДеньНедели Из ТекущееРасписание.ДниНедели Цикл
								ТекущийДеньНеделиПредставление = "";
								Если ТекущийДеньНедели = 1 Тогда
									ТекущийДеньНеделиПредставление = "#Monday#";
								ИначеЕсли ТекущийДеньНедели = 2 Тогда
									ТекущийДеньНеделиПредставление = "#Tuesday#";
								ИначеЕсли ТекущийДеньНедели = 3 Тогда
									ТекущийДеньНеделиПредставление = "#Wednesday#";
								ИначеЕсли ТекущийДеньНедели = 4 Тогда
									ТекущийДеньНеделиПредставление = "#Thursday#";
								ИначеЕсли ТекущийДеньНедели = 5 Тогда
									ТекущийДеньНеделиПредставление = "#Friday#";
								ИначеЕсли ТекущийДеньНедели = 6 Тогда
									ТекущийДеньНеделиПредставление = "#Saturday#";
								ИначеЕсли ТекущийДеньНедели = 7 Тогда
									ТекущийДеньНеделиПредставление = "#Sunday#";
								КонецЕсли;
								Если НЕ ПустаяСтрока(ТекущийДеньНеделиПредставление) Тогда
									СписокДнейНедели = СписокДнейНедели + ТекущийДеньНеделиПредставление;
								КонецЕсли;
							КонецЦикла;
							СписокДнейНедели = СтрЗаменить(СписокДнейНедели, "##", ",");
							СписокДнейНедели = СтрЗаменить(СписокДнейНедели, "#", "");
							ЗаписьХМЛ.ЗаписатьНачалоЭлемента("BackupWeekly");
							ЗаписьХМЛ.ЗаписатьАтрибут("time", Формат(УниверсальноеВремя(ТекущееРасписание.Время), "ДФ=HH:mm:ss"));
							ЗаписьХМЛ.ЗаписатьАтрибут("weekDay", СписокДнейНедели);
							ЗаписьХМЛ.ЗаписатьКонецЭлемента();
						ИначеЕсли ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования.Вариант = "Ежемесячно_ПоДням" Тогда
							ТекущееРасписание = ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования.Ежемесячно_ПоДням;
							СписокДнейМесяца = "";
							Для Каждого ТекущийДеньМесяца Из ТекущееРасписание.ДниМесяца Цикл
								Если ТекущийДеньМесяца = 32 Тогда
									ТекущийДеньМесяцаПредставление = "#last#";
								Иначе
									ТекущийДеньМесяцаПредставление = "#" + ТекущийДеньМесяца + "#";
								КонецЕсли;
								СписокДнейМесяца = СписокДнейМесяца + ТекущийДеньМесяцаПредставление;
							КонецЦикла;
							СписокДнейМесяца = СтрЗаменить(СписокДнейМесяца, "##", ",");
							СписокДнейМесяца = СтрЗаменить(СписокДнейМесяца, "#", "");
							ЗаписьХМЛ.ЗаписатьНачалоЭлемента("BackupMonthly");
							ЗаписьХМЛ.ЗаписатьАтрибут("time", Формат(УниверсальноеВремя(ТекущееРасписание.Время), "ДФ=HH:mm:ss"));
							ЗаписьХМЛ.ЗаписатьАтрибут("monthDay", СписокДнейМесяца);
							ЗаписьХМЛ.ЗаписатьКонецЭлемента();
						ИначеЕсли ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования.Вариант = "Ежемесячно_ПоДнямНедели" Тогда
							ТекущееРасписание = ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования.Ежемесячно_ПоДнямНедели;
							СписокДнейНедели = "";
							Для Каждого ТекущийДеньНедели Из ТекущееРасписание.ДниНедели Цикл
								ТекущийДеньНеделиПредставление = "";
								Если ТекущийДеньНедели = 1 Тогда
									ТекущийДеньНеделиПредставление = "#Monday#";
								ИначеЕсли ТекущийДеньНедели = 2 Тогда
									ТекущийДеньНеделиПредставление = "#Tuesday#";
								ИначеЕсли ТекущийДеньНедели = 3 Тогда
									ТекущийДеньНеделиПредставление = "#Wednesday#";
								ИначеЕсли ТекущийДеньНедели = 4 Тогда
									ТекущийДеньНеделиПредставление = "#Thursday#";
								ИначеЕсли ТекущийДеньНедели = 5 Тогда
									ТекущийДеньНеделиПредставление = "#Friday#";
								ИначеЕсли ТекущийДеньНедели = 6 Тогда
									ТекущийДеньНеделиПредставление = "#Saturday#";
								ИначеЕсли ТекущийДеньНедели = 7 Тогда
									ТекущийДеньНеделиПредставление = "#Sunday#";
								КонецЕсли;
								Если НЕ ПустаяСтрока(ТекущийДеньНеделиПредставление) Тогда
									СписокДнейНедели = СписокДнейНедели + ТекущийДеньНеделиПредставление;
								КонецЕсли;
							КонецЦикла;
							СписокДнейНедели = СтрЗаменить(СписокДнейНедели, "##", ",");
							СписокДнейНедели = СтрЗаменить(СписокДнейНедели, "#", "");
							НомерНедели = "first";
							Если ТекущееРасписание.НомерНедели = 1 Тогда
								НомерНедели = "first";
							ИначеЕсли ТекущееРасписание.НомерНедели = 2 Тогда
								НомерНедели = "second";
							ИначеЕсли ТекущееРасписание.НомерНедели = 3 Тогда
								НомерНедели = "third";
							ИначеЕсли ТекущееРасписание.НомерНедели = 4 Тогда
								НомерНедели = "fourth";
							ИначеЕсли ТекущееРасписание.НомерНедели = 5 Тогда
								НомерНедели = "last";
							КонецЕсли;
							ЗаписьХМЛ.ЗаписатьНачалоЭлемента("BackupMonthly");
							ЗаписьХМЛ.ЗаписатьАтрибут("time", Формат(УниверсальноеВремя(ТекущееРасписание.Время), "ДФ=HH:mm:ss"));
							ЗаписьХМЛ.ЗаписатьАтрибут("every", НомерНедели);
							ЗаписьХМЛ.ЗаписатьАтрибут("weekDay", СписокДнейНедели);
							ЗаписьХМЛ.ЗаписатьКонецЭлемента();
						КонецЕсли;

					ЗаписьХМЛ.ЗаписатьКонецЭлемента(); // Schedule.

					ЗаписьХМЛ.ЗаписатьНачалоЭлемента("RetentionRule");

						ЗаписьХМЛ.ЗаписатьНачалоЭлемента("Daily");
							ЗаписьХМЛ.ЗаписатьТекст(Формат(ЭтотОбъект.КоличествоХранимыхКопий_Ежедневные, "ЧЦ=20; ЧГ=0"));
						ЗаписьХМЛ.ЗаписатьКонецЭлемента();

						ЗаписьХМЛ.ЗаписатьНачалоЭлемента("Weekly");
							ЗаписьХМЛ.ЗаписатьТекст(Формат(ЭтотОбъект.КоличествоХранимыхКопий_Еженедельные, "ЧЦ=20; ЧГ=0"));
						ЗаписьХМЛ.ЗаписатьКонецЭлемента();

						ЗаписьХМЛ.ЗаписатьНачалоЭлемента("Monthly");
							ЗаписьХМЛ.ЗаписатьТекст(Формат(ЭтотОбъект.КоличествоХранимыхКопий_Ежемесячные, "ЧЦ=20; ЧГ=0"));
						ЗаписьХМЛ.ЗаписатьКонецЭлемента();

					ЗаписьХМЛ.ЗаписатьКонецЭлемента(); // RetentionRule.

				ЗаписьХМЛ.ЗаписатьКонецЭлемента(); // DatabaseBackupConfiguration.

			ЗаписьХМЛ.Закрыть();

		ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
			КонтекстВыполнения,
			0,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Файл расписания сформирован.
					|Имя файла: %1'"),
				ИмяВременногоФайлаНастроекИБ),
			Неопределено);

		ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
			КонтекстВыполнения,
			"ОблачныйАрхив.НастройкаОблачногоАрхива.ИнициализироватьРасписание/Изменение расписания/Запуск утилиты", // Идентификатор.
			НСтр("ru='Инициализация нового расписания для утилиты резервного копирования / Изменение / Запуск утилиты'"));

			КонтекстВыполненияВложенный = ИнтернетПоддержкаПользователейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций();
			СтрокаКоманды =
				""""
				+ ЭтотОбъект.КаталогУстановкиАгентаКопирования
				+ ПолучитьРазделительПутиКлиента()
				+ "BackupAgent.exe"
				+ """"
				+ " update_task_config -path="
					+ """"
					+ ИмяВременногоФайлаНастроекИБ
					+ """";
			РезультатВыполнения = ОблачныйАрхивКлиентСервер.ВыполнитьСтрокуКоманды(
				СтрокаКоманды,
				ЭтотОбъект.КаталогУстановкиАгентаКопирования,
				КонтекстВыполненияВложенный);

		ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
			КонтекстВыполнения,
			0,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Запуск утилиты.
					|Строка команды: %1
					|Каталог установки агента копирования: %2
					|Код возврата: %3'"),
				СтрокаКоманды,
				ЭтотОбъект.КаталогУстановкиАгентаКопирования,
				РезультатВыполнения.КодВозврата),
			КонтекстВыполненияВложенный);

		ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
			КонтекстВыполнения,
			"ОблачныйАрхив.НастройкаОблачногоАрхива.ИнициализироватьРасписание/Изменение расписания/Удаление временных файлов", // Идентификатор.
			НСтр("ru='Инициализация нового расписания для утилиты резервного копирования / Изменение / Удаление временных файлов'"));

			Попытка
				УдалитьФайлы(ИмяВременногоФайлаНастроекИБ);
				ПодробноеСообщение = НСтр("ru='Удаление прошло успешно'");
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ПодробноеСообщение = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
			КонецПопытки;

		ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
			КонтекстВыполнения,
			0,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Удаление временных файлов.
					|Имя файла: %1
					|Подробности:
					|%2'"),
				ИмяВременногоФайлаНастроекИБ,
				ПодробноеСообщение),
			Неопределено);

	КонецЕсли;

	// 2. Пересчитать расписания.
	// Расписания уже сохранены в регистре "НастройкиОблачногоАрхиваНаЛокальномКомпьютере".
	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.НастройкаОблачногоАрхива.ИнициализироватьРасписание/Пересчет расписания", // Идентификатор.
		НСтр("ru='Инициализация нового расписания для утилиты резервного копирования / Пересчет расписания'"));

		ТекущаяДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
		ОблачныйАрхивКлиент.ЗаполнитьРасписаниеСозданияРезервныхКопий(ТекущаяДатаСеанса);

	ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		0,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Пересчет расписания.
				|Дата сеанса: %1'"),
			ТекущаяДатаСеанса),
		Неопределено);

	#Иначе

	ИнтернетПоддержкаПользователейКлиентСервер.ЗарегистрироватьРезультатВыполненияОперации(
		КонтекстВыполнения,
		"ОблачныйАрхив.НастройкаОблачногоАрхива.ИнициализироватьРасписание/Запуск в веб-клиенте", // Идентификатор.
		НСтр("ru='Инициализация нового расписания для утилиты резервного копирования / Запуск в веб-клиенте'"),
		0,
		НСтр("ru='Запуск в веб-клиенте запрещен'"),
		Неопределено);

	#КонецЕсли

	Т2 = ТекущаяУниверсальнаяДатаВМиллисекундах();
	ИнтернетПоддержкаПользователейВызовСервера.ЗаписатьСообщениеВЖурналРегистрации(
		НСтр("ru='БИП:ОблачныйАрхив.Работа с внешними утилитами'"), // ИмяСобытия
		НСтр("ru='Облачный архив. Работа с внешними утилитами. Запуск Агента резервного копирования'"), // ИдентификаторШага
		"Информация", // УровеньЖурналаРегистрации.*
		, // ОбъектМетаданных
		(Т2 - Т1), // Данные
		ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеЗаписиРезультатовВыполненияОпераций(
			КонтекстВыполнения,
			Истина,
			"ПодробноПоШагам",
			0), // Комментарий
		ОблачныйАрхивВызовСервера.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Загружает из веб-сервисов статистику и список резервных копий и собирает информацию о клиентском компьютере.
//
// Параметры:
//  СрокЖизниСтатистики - Число - количество секунд, сколько собранная статистика считается актуальной,
//                        если 0 - обновить принудительно.
//
&НаСервере
Процедура ЗагрузитьСтатистику(СрокЖизниСтатистики = 300)

	МассивШагов = Новый Массив;

		ШагСбораДанных = ОблачныйАрхивКлиентСервер.ПолучитьОписаниеШагаСбораДанных();
			ШагСбораДанных.КодШага               = "СвойстваХранилищаОблачногоАрхива"; // Идентификатор
			ШагСбораДанных.ОписаниеШага          = НСтр("ru='Сбор информации об использовании облачного хранилища'");
			ШагСбораДанных.СрокУстареванияСекунд = СрокЖизниСтатистики; // Обновлять только если данные были собраны > 5 минут назад.
		МассивШагов.Добавить(ШагСбораДанных);

		ШагСбораДанных = ОблачныйАрхивКлиентСервер.ПолучитьОписаниеШагаСбораДанных();
			ШагСбораДанных.КодШага               = "АктивацииАгентовКопирования"; // Идентификатор
			ШагСбораДанных.ОписаниеШага          = НСтр("ru='Проверка активации Агента резервного копирования на этом компьютере'");
			ШагСбораДанных.СрокУстареванияСекунд = СрокЖизниСтатистики; // Обновлять только если данные были собраны > 5 минут назад.
		МассивШагов.Добавить(ШагСбораДанных);

		ШагСбораДанных = ОблачныйАрхивКлиентСервер.ПолучитьОписаниеШагаСбораДанных();
			ШагСбораДанных.КодШага               = "ИнформацияОКлиенте"; // Идентификатор
			ШагСбораДанных.ОписаниеШага          = НСтр("ru='Сбор информации о клиентском компьютере'");
			ШагСбораДанных.СрокУстареванияСекунд = СрокЖизниСтатистики; // Обновлять только если данные были собраны > 5 минут назад.
		МассивШагов.Добавить(ШагСбораДанных);

	ОблачныйАрхив.СобратьДанныеПоОблачномуАрхиву(Новый Структура("МассивШагов", МассивШагов), "");

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;

	Если Форма.РасписаниеВключено = Истина Тогда
		МассивПодстрок = Новый Массив;
		МассивПодстрок.Добавить(НСтр("ru='Выполнять автоматическое резервное копирование'"));
		МассивПодстрок.Добавить(" ");
		МассивПодстрок.Добавить(
			Новый ФорматированнаяСтрока(
				ОблачныйАрхивКлиентСервер.ПолучитьТекстовоеОписаниеРасписания(Форма.РасписаниеАвтоматическогоРезервногоКопирования, "Кратко"), // Содержимое
				, // Шрифт
				Форма.ЦветГиперссылки, // ЦветТекста
				, // ЦветФона
				"backup1C:EditBackupScheduler")); // Ссылка
		МассивПодстрок.Добавить(".");
		Элементы.ДекорацияРасписание.Заголовок = Новый ФорматированнаяСтрока(МассивПодстрок);
		Элементы.ДекорацияРасписание.Доступность = Истина;
	Иначе
		МассивПодстрок = Новый Массив;
		МассивПодстрок.Добавить(НСтр("ru='Выполнять автоматическое резервное копирование'"));
		МассивПодстрок.Добавить(" ");
		МассивПодстрок.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru='по расписанию'"), // Содержимое
				, // Шрифт
				Форма.ЦветГиперссылки, // ЦветТекста
				, // ЦветФона
				"backup1C:EditBackupScheduler")); // Ссылка
		МассивПодстрок.Добавить(".");
		Элементы.ДекорацияРасписание.Заголовок = Новый ФорматированнаяСтрока(МассивПодстрок);
		Элементы.ДекорацияРасписание.Доступность = Ложь;
	КонецЕсли;

	Если ОблачныйАрхивКлиентСервер.ЕстьЗапрещенныеСимволыДляКоманднойСтроки(Форма.ЛогинАдминистратораОС) Тогда
		Элементы.ДекорацияЛогинАдминистратораОС.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Обнаружен один из запрещенных символов: %1.
				|Это может привести к ошибке запуска Агента резервного копирования.'"),
			ОблачныйАрхивКлиентСервер.ЗапрещенныеСимволыДляКоманднойСтроки());
	Иначе
		Элементы.ДекорацияЛогинАдминистратораОС.Заголовок = "";
	КонецЕсли;

	Если ОблачныйАрхивКлиентСервер.ЕстьЗапрещенныеСимволыДляКоманднойСтроки(Форма.ПарольАдминистратораОС) Тогда
		Элементы.ДекорацияПарольАдминистратораОС.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Обнаружен один из запрещенных символов: %1.
				|Это может привести к ошибке запуска Агента резервного копирования.'"),
			ОблачныйАрхивКлиентСервер.ЗапрещенныеСимволыДляКоманднойСтроки());
	Иначе
		Элементы.ДекорацияПарольАдминистратораОС.Заголовок = "";
	КонецЕсли;

КонецПроцедуры

// Сохраняет все настройки на сервере и в файлах настроек.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура ЗаписатьВсеНастройкиНаСервере()

	// 1. Настройки "ИнформацияОКлиенте" (ИдентификаторКомпьютера).
	Если НЕ ПустаяСтрока(ЭтотОбъект.ИдентификаторКомпьютера) Тогда
		ИнформацияОКлиенте = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("ИнформацияОКлиенте", ИмяКомпьютера());
			ИнформацияОКлиенте.Вставить("ИдентификаторКомпьютера", ЭтотОбъект.ИдентификаторКомпьютера);
			ИнформацияОКлиенте.Вставить("ЛогинАдминистратораОС", ЭтотОбъект.ЛогинАдминистратораОС);
		ОблачныйАрхив.ЗаписатьНастройкиОблачногоАрхива(ИнформацияОКлиенте, "ИнформацияОКлиенте", ИмяКомпьютера());
	КонецЕсли;

	// 2. Настройки ПараметрыОкруженияСервер (ИмяИБ).
	ПараметрыОкруженияСервер = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("ПараметрыОкруженияСервер");
		ПараметрыОкруженияСервер.Вставить("ИмяИБ", ЭтотОбъект.ИмяИБ);
	ОблачныйАрхив.ЗаписатьНастройкиОблачногоАрхива(ПараметрыОкруженияСервер, "ПараметрыОкруженияСервер");

	// 3. Настройки НастройкиАгентаКопированияОбщие (КоличествоХранимыхКопий_Ежедневные, КоличествоХранимыхКопий_Еженедельные, КоличествоХранимыхКопий_Ежемесячные).
	// 4. Настройки НастройкиАгентаКопированияКлиент (Расписание).
	// Если изменили хотя бы один из параметров, то записать настройки в файл настроек.
	// Оба вида настроек (НастройкиАгентаКопированияОбщие и НастройкиАгентаКопированияКлиент) хранятся в одном файле настроек.
	НастройкиАгентаКопированияОбщие = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("НастройкиАгентаКопированияОбщие");
	Если (НастройкиАгентаКопированияОбщие.КоличествоХранимыхКопий_Ежедневные <> ЭтотОбъект.КоличествоХранимыхКопий_Ежедневные)
			ИЛИ (НастройкиАгентаКопированияОбщие.КоличествоХранимыхКопий_Еженедельные <> ЭтотОбъект.КоличествоХранимыхКопий_Еженедельные)
			ИЛИ (НастройкиАгентаКопированияОбщие.КоличествоХранимыхКопий_Ежемесячные <> ЭтотОбъект.КоличествоХранимыхКопий_Ежемесячные) Тогда
		НастройкиАгентаКопированияОбщие.Вставить("КоличествоХранимыхКопий_Ежедневные",   ЭтотОбъект.КоличествоХранимыхКопий_Ежедневные);
		НастройкиАгентаКопированияОбщие.Вставить("КоличествоХранимыхКопий_Еженедельные", ЭтотОбъект.КоличествоХранимыхКопий_Еженедельные);
		НастройкиАгентаКопированияОбщие.Вставить("КоличествоХранимыхКопий_Ежемесячные",  ЭтотОбъект.КоличествоХранимыхКопий_Ежемесячные);
		ОблачныйАрхив.ЗаписатьНастройкиОблачногоАрхива(НастройкиАгентаКопированияОбщие, "НастройкиАгентаКопированияОбщие");
	КонецЕсли;

	// 5. Сохранить расписание.
	НастройкиАгентаКопированияКлиент = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("НастройкиАгентаКопированияКлиент", ИмяКомпьютера());
		НастройкиАгентаКопированияКлиент.Вставить("РасписаниеАвтоматическогоРезервногоКопирования", ЭтотОбъект.РасписаниеАвтоматическогоРезервногоКопирования);
	ОблачныйАрхив.ЗаписатьНастройкиОблачногоАрхива(НастройкиАгентаКопированияКлиент, "НастройкиАгентаКопированияКлиент", ИмяКомпьютера());

	// Настройки расписания и общие настройки для Агента резервного копирования запишутся в файлы в процедуре ИнициализироватьРасписание.

КонецПроцедуры

#КонецОбласти
