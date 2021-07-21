
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСВызовСервера.ПриПолученииФормыДокумента(
		"ОстаткиЕГАИС",
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных;

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаОстаткиАлкогольнойПродукцииЕГАИС(Запрос, ТекстыЗапроса, Регистры);
	
	ИнтеграцияЕГАИС.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеШапки.Дата             КАК Период,
	|	ДанныеШапки.Ссылка           КАК Ссылка,
	|	ДанныеШапки.ОрганизацияЕГАИС КАК ОрганизацияЕГАИС,
	|	ДанныеШапки.СтатусОбработки  КАК СтатусОбработки,
	|	ДанныеШапки.ВидДокумента     КАК ВидДокумента
	|
	|ИЗ
	|	Документ.ОстаткиЕГАИС КАК ДанныеШапки
	|ГДЕ
	|	ДанныеШапки.Ссылка = &Ссылка";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",           Реквизиты.Период);
	Запрос.УстановитьПараметр("ПустаяДата",       '00010101');
	Запрос.УстановитьПараметр("Ссылка",           Реквизиты.Ссылка);
	Запрос.УстановитьПараметр("СтатусОбработки",  Реквизиты.СтатусОбработки);
	Запрос.УстановитьПараметр("ОрганизацияЕГАИС", Реквизиты.ОрганизацияЕГАИС);
	Запрос.УстановитьПараметр("ВидДокумента",     Реквизиты.ВидДокумента);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаОстаткиАлкогольнойПродукцииЕГАИС(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОстаткиАлкогольнойПродукцииЕГАИС";
	
	Если НЕ ИнтеграцияЕГАИС.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ИнтеграцияЕГАИС.ЕстьТаблицаЗапроса("ВТТовары", ТекстыЗапроса) Тогда
		ТекстЗапросаВТТовары(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Количество > 0
	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	КОНЕЦ КАК ВидДвижения,
	|	&Период КАК Период,
	|	&ОрганизацияЕГАИС КАК ОрганизацияЕГАИС,
	|	ТаблицаТовары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТаблицаТовары.Справка2 КАК Справка2,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Количество > 0
	|			ТОГДА ТаблицаТовары.Количество
	|		ИНАЧЕ -ТаблицаТовары.Количество
	|	КОНЕЦ КАК СвободныйОстаток,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Количество > 0
	|			ТОГДА ТаблицаТовары.Количество
	|		ИНАЧЕ -ТаблицаТовары.Количество
	|	КОНЕЦ КАК Количество,
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	ВТТовары КАК ТаблицаТовары
	|ГДЕ
	|	&ВидДокумента = ЗНАЧЕНИЕ(Перечисление.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре1)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВТТовары(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВТТовары";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаТовары.Ссылка               КАК Ссылка,
	|	ТаблицаТовары.НомерСтроки          КАК НомерСтроки,
	|	ТаблицаТовары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТаблицаТовары.Количество           КАК Количество,
	|	ТаблицаТовары.Справка2             КАК Справка2
	|ПОМЕСТИТЬ ВТТовары
	|ИЗ
	|	Документ.ОстаткиЕГАИС.КорректировкаОстатков КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений();
	ТекстыЗапросаВременныхТаблиц = Новый Соответствие();
	ПолноеИмяДокумента = "Документ.ОстаткиЕГАИС";
	
	Если ИмяРегистра = "ОстаткиАлкогольнойПродукцииЕГАИС" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаОстаткиАлкогольнойПродукцииЕГАИС(Запрос, ТекстыЗапроса, ИмяРегистра);
		ТекстыЗапросаВременныхТаблиц.Вставить("ВТТовары", ТекстЗапросаВТТовары(Запрос, ТекстыЗапроса));
		СинонимТаблицыДокумента = "ТаблицаТовары";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ПереопределениеРасчетаПараметров = Новый Структура;
	
	Результат = ОбновлениеИнформационнойБазыЕГАИС.РезультатАдаптацииЗапроса();
	Результат.ТекстЗапроса = ОбновлениеИнформационнойБазыЕГАИС.АдаптироватьЗапросМеханизмаПроведения(
		ТекстЗапроса,
		ПолноеИмяДокумента,
		СинонимТаблицыДокумента,
		ПереопределениеРасчетаПараметров,
		ТекстыЗапросаВременныхТаблиц);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли