#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.Параметры;
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	НастройкиОтчета = ЭтаФорма.НастройкиОтчета;
	
	Схема = ПолучитьИзВременногоХранилища(ЭтаФорма.НастройкиОтчета.АдресСхемы);
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//   Например, если схема отчета зависит от ключа варианта или параметров отчета.
//   Чтобы изменения схемы вступили в силу следует вызывать метод ОтчетыСервер.ПодключитьСхему().
//
// Параметры:
//   Контекст - Произвольный - 
//       Параметры контекста, в котором используется отчет.
//       Используется для передачи в параметрах метода ОтчетыСервер.ПодключитьСхему().
//   КлючСхемы - Строка -
//       Идентификатор текущей схемы компоновщика настроек.
//       По умолчанию не заполнен (это означает что компоновщик инициализирован на основании основной схемы).
//       Используется для оптимизации, чтобы переинициализировать компоновщик как можно реже).
//       Может не использоваться если переинициализация выполняется безусловно.
//   КлючВарианта - Строка, Неопределено -
//       Имя предопределенного или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов для варианта расшифровки или без контекста.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных, Неопределено -
//       Настройки варианта отчета, которые будут загружены в компоновщик настроек после его инициализации.
//       Неопределено когда настройки варианта не надо загружать (уже загружены ранее).
//   НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных, Неопределено -
//       Пользовательские настройки, которые будут загружены в компоновщик настроек после его инициализации.
//       Неопределено когда пользовательские настройки не надо загружать (уже загружены ранее).
//
// Примеры:
// 1. Компоновщик отчета инициализируется на основании схемы из общих макетов:
//	Если КлючСхемы <> "1" Тогда
//		КлючСхемы = "1";
//		СхемаКД = ПолучитьОбщийМакет("МояОбщаяСхемаКомпоновки");
//		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//	КонецЕсли;
//
// 2. Схема зависит от значения параметра, выведенного в пользовательские настройки отчета:
//	Если ТипЗнч(НовыеПользовательскиеНастройкиКД) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
//		ПолноеИмяОбъектаМетаданных = "";
//		Для Каждого ЭлементКД Из НовыеПользовательскиеНастройкиКД.Элементы Цикл
//			Если ТипЗнч(ЭлементКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
//				ИмяПараметра = Строка(ЭлементКД.Параметр);
//				Если ИмяПараметра = "ОбъектМетаданных" Тогда
//					ПолноеИмяОбъектаМетаданных = ЭлементКД.Значение;
//				КонецЕсли;
//			КонецЕсли;
//		КонецЦикла;
//		Если КлючСхемы <> ПолноеИмяОбъектаМетаданных Тогда
//			КлючСхемы = ПолноеИмяОбъектаМетаданных;
//			СхемаКД = Новый СхемаКомпоновкиДанных;
//			// Наполнение схемы...
//			ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//		КонецЕсли;
//	КонецЕсли;
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	// Локализация списка значений
	ДоступныеЗначения = ДоступныеЗначенияПоляВидОперации();
	
	ВидОперации = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Поля.Найти("ВидОперации");
	ВидОперации.УстановитьДоступныеЗначения(ДоступныеЗначения);
	
	ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос = ТекстЗапроса();
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	ПараметрПериода = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Период");
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПериодГраница", Новый Граница(КонецДня(ПараметрПериода.Значение), ВидГраницы.Включая));
	
	ВидыОперацийИСинонимы = ВидыОперацийИСинонимы();
	
	// Строковые литералы
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтрокаРекомендацияОформитеПоступлениеТоваров", НСтр("ru='Оформите поступление товаров'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтрокаРекомендацияОформитеПриобретениеТоваровИУслуг", НСтр("ru='Оформите приобретение товаров и услуг'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтрокаРекомендацияОформитеТаможеннуюДекларациюНаИмпорт", НСтр("ru='Оформите таможенную декларацию на импорт'"));
	
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ТоварыВПути", ВидыОперацийИСинонимы["ТоварыВПути"]);
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НеотфактурованнаяПоставка", ВидыОперацийИСинонимы["НеотфактурованнаяПоставка"]);
	
КонецПроцедуры

Функция ДоступныеВидыОперацийИЗапросы()
	
	Доступные = Новый ТаблицаЗначений;
	Доступные.Колонки.Добавить("ВидОперации", ОбщегоНазначения.ОписаниеТипаСтрока(200));
	Доступные.Колонки.Добавить("ВидОперацииСиноним", ОбщегоНазначения.ОписаниеТипаСтрока(200));
	Доступные.Колонки.Добавить("ИмяТекстаЗапроса", ОбщегоНазначения.ОписаниеТипаСтрока(200));
	
	ВидыОперацийИСинонимы = ВидыОперацийИСинонимы();
	
	// Отключаются комбинацией функциональных опций
	Если ПолучитьФункциональнуюОпцию("ИспользоватьТоварыВПутиОтПоставщиков") Тогда
		ДобавитьВидОперацииИЗапрос(Доступные, ВидыОперацийИСинонимы, "ТоварыВПути", "ТекстЗапросаТоварыВПути");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНеотфактурованныеПоставки") Тогда
		ДобавитьВидОперацииИЗапрос(Доступные, ВидыОперацийИСинонимы, "НеотфактурованнаяПоставка", "ТекстЗапросаНеотфактурованнаяПоставка");
	КонецЕсли;
	
	Возврат Доступные;
	
КонецФункции

Процедура ПодключитьЗапрос(ДинамическийТекстЗапроса, ПодключаемыйЗапрос, КоличествоПодключенныхЗапросов)
	Если КоличествоПодключенныхЗапросов = 0 Тогда
		ДинамическийТекстЗапроса = ДинамическийТекстЗапроса + ПодключаемыйЗапрос;
	Иначе
		ДинамическийТекстЗапроса = ДинамическийТекстЗапроса + Символы.ПС + Символы.ПС 
			+ "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС + Символы.ПС;
			
		СтрокаПолейКомпоновки = "{ВЫБРАТЬ
			|	Номенклатура.*,
			|	Характеристика.*,
			|	Серия.*,
			|	Назначение.*}";

		ПодключаемыйЗапросПодготовка = СтрЗаменить(ПодключаемыйЗапрос, "РАЗРЕШЕННЫЕ", "");
		ПодключаемыйЗапросПодготовка = СтрЗаменить(ПодключаемыйЗапросПодготовка, СтрокаПолейКомпоновки, "");
		
		ДинамическийТекстЗапроса = ДинамическийТекстЗапроса + ПодключаемыйЗапросПодготовка;
	КонецЕсли;
		
	КоличествоПодключенныхЗапросов = КоличествоПодключенныхЗапросов + 1;
КонецПроцедуры

Функция ТекстЗапросаТоварыВПути()
	// Строковые литералы локализуются в настройках СКД отчета
	// Наборы данных - Поля - Доступные значения
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&ТоварыВПути КАК ВидОперации,
	|	ВЫБОР
	|		КОГДА ТоварыУПартнеровОстатки.ПереданоОстаток > 0
	|			ТОГДА &СтрокаРекомендацияОформитеПоступлениеТоваров
	|		КОГДА ТоварыУПартнеровОстатки.ПереданоОстаток < 0
	|			ТОГДА &СтрокаРекомендацияОформитеПриобретениеТоваровИУслуг
	|	КОНЕЦ КАК Рекомендация,
	|	ТоварыУПартнеровОстатки.Номенклатура КАК Номенклатура,
	|	ТоварыУПартнеровОстатки.Характеристика КАК Характеристика,
	|	ТоварыУПартнеровОстатки.Серия КАК Серия,
	|	ТоварыУПартнеровОстатки.Назначение КАК Назначение,
	|	ТоварыУПартнеровОстатки.ВидЗапасов КАК ВидЗапасов,
	|	ТоварыУПартнеровОстатки.Партнер КАК Партнер,
	|	ТоварыУПартнеровОстатки.Контрагент КАК Контрагент,
	|	ТоварыУПартнеровОстатки.НомерГТД КАК НомерГТД,
	|	ТоварыУПартнеровОстатки.Договор КАК Договор,
	|	ТоварыУПартнеровОстатки.ПереданоОстаток КАК Количество
	|{ВЫБРАТЬ
	|	Номенклатура.*,
	|	Характеристика.*,
	|	Серия.*,
	|	Назначение.*}
	|ИЗ
	|	РегистрНакопления.ТоварыУПартнеров.Остатки(
	|		&ПериодГраница) КАК ТоварыУПартнеровОстатки
	|ГДЕ
	|	ТоварыУПартнеровОстатки.Договор.ВариантОформленияЗакупок = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияЗакупок.ТоварыВПути)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&ТоварыВПути КАК ВидОперации,
	|	ВЫБОР
	|		КОГДА ТоварыКОформлениюТаможенныхДекларацийОстатки.КоличествоОстаток > 0
	|			ТОГДА &СтрокаРекомендацияОформитеТаможеннуюДекларациюНаИмпорт
	|		КОГДА ТоварыКОформлениюТаможенныхДекларацийОстатки.КоличествоОстаток < 0
	|			ТОГДА &СтрокаРекомендацияОформитеПриобретениеТоваровИУслуг
	|	КОНЕЦ,
	|	ТоварыКОформлениюТаможенныхДекларацийОстатки.АналитикаУчетаНоменклатуры.Номенклатура,
	|	ТоварыКОформлениюТаможенныхДекларацийОстатки.АналитикаУчетаНоменклатуры.Характеристика,
	|	ТоварыКОформлениюТаможенныхДекларацийОстатки.АналитикаУчетаНоменклатуры.Серия,
	|	ТоварыКОформлениюТаможенныхДекларацийОстатки.АналитикаУчетаНоменклатуры.Назначение,
	|	ТоварыКОформлениюТаможенныхДекларацийОстатки.ВидЗапасов,
	|	ТоварыКОформлениюТаможенныхДекларацийОстатки.Поставщик,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ТоварыКОформлениюТаможенныхДекларацийОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюТаможенныхДеклараций.Остатки(
	|		&ПериодГраница) КАК ТоварыКОформлениюТаможенныхДекларацийОстатки
	|ГДЕ
	|	ТоварыКОформлениюТаможенныхДекларацийОстатки.ДокументПоступления.ХозяйственнаяОперация В
	|		(
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщикаТоварыВПути),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаПоИмпортуТоварыВПути),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСТоварыВПути)
	|		)";
	
	Возврат ТекстЗапроса;
КонецФункции

Функция ТекстЗапросаНеотфактурованнаяПоставка()
	// Строковые литералы локализуются в настройках СКД отчета
	// Наборы данных - Поля - Доступные значения
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&НеотфактурованнаяПоставка КАК ВидОперации,
	|	ВЫБОР
	|		КОГДА ТоварыУПартнеровОстатки.ПереданоОстаток < 0
	|			ТОГДА &СтрокаРекомендацияОформитеПоступлениеТоваров
	|		КОГДА ТоварыУПартнеровОстатки.ПереданоОстаток > 0
	|			ТОГДА &СтрокаРекомендацияОформитеПриобретениеТоваровИУслуг
	|	КОНЕЦ КАК Рекомендация,
	|	ТоварыУПартнеровОстатки.Номенклатура КАК Номенклатура,
	|	ТоварыУПартнеровОстатки.Характеристика КАК Характеристика,
	|	ТоварыУПартнеровОстатки.Серия КАК Серия,
	|	ТоварыУПартнеровОстатки.Назначение КАК Назначение,
	|	ТоварыУПартнеровОстатки.ВидЗапасов КАК ВидЗапасов,
	|	ТоварыУПартнеровОстатки.Партнер КАК Партнер,
	|	ТоварыУПартнеровОстатки.Контрагент КАК Контрагент,
	|	ТоварыУПартнеровОстатки.НомерГТД КАК НомерГТД,
	|	ТоварыУПартнеровОстатки.Договор КАК Договор,
	|	ТоварыУПартнеровОстатки.ПереданоОстаток КАК Количество
	|{ВЫБРАТЬ
	|	Номенклатура.*,
	|	Характеристика.*,
	|	Серия.*,
	|	Назначение.*}
	|ИЗ
	|	РегистрНакопления.ТоварыУПартнеров.Остатки(
	|		&ПериодГраница) КАК ТоварыУПартнеровОстатки
	|
	|ГДЕ
	|	ТоварыУПартнеровОстатки.Договор.ВариантОформленияЗакупок = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияЗакупок.НеотфактурованныеПоставки)";
	
	Возврат ТекстЗапроса;
КонецФункции

Функция ДоступныеЗначенияПоляВидОперации()
	
	ДоступныеВидыОперацийИЗапросы = ДоступныеВидыОперацийИЗапросы();
	ДоступныеЗначения = Новый СписокЗначений;
	
	ДоступныеЗначения.ЗагрузитьЗначения(ДоступныеВидыОперацийИЗапросы.ВыгрузитьКолонку("ВидОперацииСиноним"));
	Для Каждого ДоступноеЗначение Из ДоступныеЗначения Цикл 
		ДоступноеЗначение.Представление = ДоступноеЗначение.Значение;
	КонецЦикла;
	
	Возврат ДоступныеЗначения;
КонецФункции

Процедура ДобавитьВидОперацииИЗапрос(Таблица, ВидыОперацийИСинонимы, ВидОперации, ИмяТекстаЗапроса)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.ВидОперации = ВидОперации;
	НоваяСтрока.ВидОперацииСиноним = ВидыОперацийИСинонимы[ВидОперации];
	НоваяСтрока.ИмяТекстаЗапроса = ИмяТекстаЗапроса;
	
КонецПроцедуры

Функция ВидыОперацийИСинонимы()
	
	ВидыОперацийИСинонимы = Новый Соответствие;
	
	ВидыОперацийИСинонимы.Вставить("ТоварыВПути", НСтр("ru='Товары в пути'"));
	ВидыОперацийИСинонимы.Вставить("НеотфактурованнаяПоставка", НСтр("ru='Неотфактурованная поставка'"));
	
	Возврат ВидыОперацийИСинонимы;
	
КонецФункции

Функция ТекстЗапроса()
	КоличествоПодключенныхЗапросов = 0;
	ТекстЗапроса = "";
	
	Доступные = ДоступныеВидыОперацийИЗапросы();
	ТекстыЗапроса = Новый Структура; 
	Для Каждого Доступный Из Доступные Цикл 
		ТекстыЗапроса.Вставить(Доступный.ИмяТекстаЗапроса, Истина);
	КонецЦикла;
	
	Если ТекстыЗапроса.Свойство("ТекстЗапросаТоварыВПути") Тогда
		ПодключитьЗапрос(ТекстЗапроса, ТекстЗапросаТоварыВПути(), КоличествоПодключенныхЗапросов);
	КонецЕсли;
	
	Если ТекстыЗапроса.Свойство("ТекстЗапросаНеотфактурованнаяПоставка") Тогда
		ПодключитьЗапрос(ТекстЗапроса, ТекстЗапросаНеотфактурованнаяПоставка(), КоличествоПодключенныхЗапросов);
	КонецЕсли;
	
	Возврат ТекстЗапроса;
КонецФункции

#КонецОбласти

#КонецЕсли