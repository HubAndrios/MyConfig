
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ЦеныПоставщиков.ТекстЗапроса = СтрЗаменить(ЦеныПоставщиков.ТекстЗапроса, 
												"&ТекстЗапросаКоэффициентУпаковки",
												Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки("Цены.Упаковка",
																													"Цены.Номенклатура"));
	
	//Заполнение параметров динамических списков.
	ПараметрыСписка = Новый Структура("Номенклатура, Характеристика, Склад");
	ЗаполнитьЗначенияСвойств(ПараметрыСписка, Параметры);

	УстановитьПараметрыСписка(Поставщики,      ПараметрыСписка);
	УстановитьПараметрыСписка(Склады,          ПараметрыСписка);
	УстановитьПараметрыСписка(ЦеныПоставщиков, ПараметрыСписка);

	ТекущаяДата = ТекущаяДатаСеанса();
	КоэффициентПересчетаЦены = 1 / РаботаСКурсамиВалютУТ.ПолучитьКурсВалютыУправленческогоУчета(ТекущаяДата);

	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Номенклатура, "СтавкаНДС, ЕдиницаИзмерения");
	КоэффициентНДС = 1 + ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(Реквизиты.СтавкаНДС);
	ЕдиницаИзмерения = Реквизиты.ЕдиницаИзмерения;
	ВалютаУпрУчета = Константы.ВалютаУправленческогоУчета.Получить();
	
	ЦеныПоставщиков.Параметры.УстановитьЗначениеПараметра("ДатаЦены",                 ТекущаяДата);
	ЦеныПоставщиков.Параметры.УстановитьЗначениеПараметра("КоэффициентПересчетаЦены", КоэффициентПересчетаЦены);
	ЦеныПоставщиков.Параметры.УстановитьЗначениеПараметра("КоэффициентНДС",           КоэффициентНДС);

	//Настройка внешнего вида формы.
	Элементы.ЦенаУпрУчет.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Цена (%1)'"), Строка(ВалютаУпрУчета));
	Элементы.Доступно.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Доступно (%1)'"), Строка(Реквизиты.ЕдиницаИзмерения));

	Позиция = Строка(Параметры.Номенклатура) +
		?(ЗначениеЗаполнено(Параметры.Характеристика), ", " + Строка(Параметры.Характеристика), "");

	Если Параметры.ТипОбеспечения = Перечисления.ТипыОбеспечения.Покупка 
		ИЛИ Параметры.ТипОбеспечения = Перечисления.ТипыОбеспечения.ПроизводствоНаСтороне Тогда

		Элементы.ГруппаПеремещение.Видимость = Ложь;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выбор поставщика для позиции: %1'"), Позиция);

	Иначе

		Элементы.Страницы.Видимость = Ложь;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выбор склада для позиции: %1'"), Позиция);

	КонецЕсли;

	УстановитьКнопкуПоУмолчанию();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)

	УстановитьКнопкуПоУмолчанию();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЦеныПоставщиков

&НаКлиенте
Процедура ЦеныПоставщиковВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ВыбратьНаКлиенте();

КонецПроцедуры

&НаКлиенте
Процедура ПоставщикНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ПоставщикОчистка(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПоставщики

&НаКлиенте
Процедура ПоставщикиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ВыбратьНаКлиенте();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСклады

&НаКлиенте
Процедура СкладыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ВыбратьНаКлиенте();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)

	ВыбратьНаКлиенте();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьНаКлиенте()

	ПараметрыПоставкиОптимальные = Новый Структура("ИсточникОбеспечения");
	ПараметрыПоставкиОптимальные.Вставить("Соглашение", ПредопределенноеЗначение("Справочник.СоглашенияСПоставщиками.ПустаяСсылка"));
	ПараметрыПоставкиОптимальные.Вставить("ЦенаВВалютеУправленческогоУчета", 0);
	ПараметрыПоставкиОптимальные.Вставить("ЦенаВВалютеСоглашения",           0);
	ПараметрыПоставкиОптимальные.Вставить("ВалютаСоглашения", ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	ПараметрыПоставкиОптимальные.Вставить("ВидЦены", ПредопределенноеЗначение("Справочник.ВидыЦенПоставщиков.ПустаяСсылка"));

	Если Параметры.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Покупка") 
		ИЛИ Параметры.ТипОбеспечения = ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.ПроизводствоНаСтороне") Тогда

		Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПоставщики Тогда

			Если Элементы.Поставщики.ТекущиеДанные = Неопределено Тогда
				Возврат;
			КонецЕсли;

			Партнер = Элементы.Поставщики.ТекущиеДанные.Поставщик;
			УсловияЗакупок = УсловияЗакупокПартнера(Партнер);

			ПараметрыПоставкиОптимальные.Вставить("ИсточникОбеспечения", Партнер);
			ПараметрыПоставкиОптимальные.Вставить("Соглашение",       УсловияЗакупок.Соглашение);
			ПараметрыПоставкиОптимальные.Вставить("ВалютаСоглашения", УсловияЗакупок.Валюта);

		Иначе

			Если Элементы.ЦеныПоставщиков.ТекущиеДанные = Неопределено Тогда
				Возврат;
			КонецЕсли;

			ТекущаяСтрока = Элементы.ЦеныПоставщиков.ТекущиеДанные;
			УсловияЗакупок = УсловияЗакупокПартнера(ТекущаяСтрока.Партнер, ТекущаяСтрока.ЦенаУпрУчет);

			ПараметрыПоставкиОптимальные.Вставить("ИсточникОбеспечения",   ТекущаяСтрока.Партнер);
			ПараметрыПоставкиОптимальные.Вставить("Соглашение",            УсловияЗакупок.Соглашение);
			ПараметрыПоставкиОптимальные.Вставить("ВалютаСоглашения",      УсловияЗакупок.Валюта);
			ПараметрыПоставкиОптимальные.Вставить("ЦенаВВалютеСоглашения", УсловияЗакупок.Цена);

			ПараметрыПоставкиОптимальные.Вставить("ЦенаВВалютеУправленческогоУчета", ТекущаяСтрока.ЦенаУпрУчет);
			ПараметрыПоставкиОптимальные.Вставить("ВидЦены",                         ТекущаяСтрока.ВидЦены);

		КонецЕсли;

	Иначе

		Если Элементы.Склады.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;

		ПараметрыПоставкиОптимальные.Вставить("ИсточникОбеспечения", Элементы.Склады.ТекущиеДанные.Склад);

	КонецЕсли;

	Результат = Новый Структура("ПараметрыПоставкиОптимальные", ПараметрыПоставкиОптимальные);
	ОповеститьОвыборе(Результат);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыСписка(Список, Параметры)

	Для каждого Свойство Из Параметры Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, Свойство.Ключ, Свойство.Значение, Истина);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура УстановитьКнопкуПоУмолчанию()

	Кнопка = ?(Элементы.ГруппаПеремещение.Видимость, Элементы.ВыбратьСклад,
		?(Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПодборПоЦене, Элементы.ВыбратьПоставщикаССоглашением,
		?(Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПоставщики, Элементы.ВыбратьПоставщика, Неопределено)));
	Кнопка.КнопкаПоУмолчанию = Истина;

КонецПроцедуры

&НаСервереБезКонтекста
Функция УсловияЗакупокПартнера(Партнер, Цена = 0)

	Возврат ОбеспечениеСервер.УсловияЗакупокПартнера(Партнер, Цена);

КонецФункции

#КонецОбласти
