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
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ПараметрВалютаУправленческогоУчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВалютаУправленческогоУчета");
	Если ПараметрВалютаУправленческогоУчета <> Неопределено 
		И НЕ (ЗначениеЗаполнено(ПараметрВалютаУправленческогоУчета.Значение)
			ИЛИ ТипЗнч(ПараметрВалютаУправленческогоУчета.Значение) = Тип("Строка")) Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВалютаУправленческогоУчета", ВалютаУправленческогоУчета);
	КонецЕсли;
	
	ПользовательскиеНастройкиМодифицированы = Ложь;
	ПараметрВалютаОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВалютаОтчета");
	Если ПараметрВалютаОтчета <> Неопределено 
		И (НЕ ЗначениеЗаполнено(ПараметрВалютаОтчета.Значение) ИЛИ ТипЗнч(ПараметрВалютаОтчета.Значение) = Тип("Строка")) Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВалютаОтчета", ВалютаУправленческогоУчета);
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗаменитьОтборПустойАналитики(КомпоновщикНастроек.Настройки.Отбор, КомпоновщикНастроек.ПользовательскиеНастройки) Тогда
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ПолеАналитики = ПолеАналитики();
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.ОборотныеСредства.Запрос;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "АктивыПассивы.Аналитика КАК Аналитика", ПолеАналитики + " КАК Аналитика");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "(АктивыПассивы.Аналитика).* КАК Аналитика", "("+ПолеАналитики + ").* КАК Аналитика");
	СхемаКомпоновкиДанных.НаборыДанных.ОборотныеСредства.Запрос = ТекстЗапроса;
	
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
	
	ОтчетПустой = ВзаиморасчетыСервер.ОтчетПустой(ПроцессорКомпоновки);
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", ОтчетПустой);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = Параметры.ПараметрКоманды;
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("Статья", Параметры.ПараметрКоманды);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолеАналитики()
	
	ШаблонВыбора =
	"ВЫБОР АктивыПассивы.Аналитика
	|		КОГДА NULL ТОГДА НЕОПРЕДЕЛЕНО
	|%1
	|		ИНАЧЕ АктивыПассивы.Аналитика
	|	КОНЕЦ";
	ШаблонУсловия =
	"		КОГДА ЗНАЧЕНИЕ(%1.ПустаяСсылка) ТОГДА НЕОПРЕДЕЛЕНО";
	УсловияВыбора = Новый Массив;
	ТипыАналитики = Метаданные.ПланыВидовХарактеристик.СтатьиАктивовПассивов.Тип.Типы();
	Для Каждого ТипАналитики Из ТипыАналитики Цикл
		
		ПолноеИмяТипа = Метаданные.НайтиПоТипу(ТипАналитики).ПолноеИмя();
		УсловияВыбора.Добавить(СтрШаблон(ШаблонУсловия, ПолноеИмяТипа));
		
	КонецЦикла;
	Возврат СтрШаблон(ШаблонВыбора, СтрСоединить(УсловияВыбора, Символы.ПС));
	
КонецФункции

Функция ЗаменитьОтборПустойАналитики(ОтборКД, ПользовательскиеНастройки = Неопределено)
	
	ПользовательскиеНастройкиМодифицированы = Ложь;
	ВидСравненияРавно = ВидСравненияКомпоновкиДанных.Равно;
	Для Каждого ЭлементОтбора Из ОтборКД.Элементы Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			ПользовательскиеНастройкиМодифицированы = ЗаменитьОтборПустойАналитики(ЭлементОтбора);
		ИначеЕсли ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Аналитика") Тогда
			Если ЭлементОтбора.ВидСравнения = ВидСравненияРавно И ЭлементОтбора.ПравоеЗначение = Неопределено  Тогда
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
				ПользовательскиеНастройкиМодифицированы = Истина;
				Если ПользовательскиеНастройки <> Неопределено И НЕ ПустаяСтрока(ЭлементОтбора.ИдентификаторПользовательскойНастройки) Тогда
					Ид = ПользовательскиеНастройки.ПолучитьИдентификаторПоОбъекту(ЭлементОтбора);
					ПользовательскийОтбор = ПользовательскиеНастройки.ПолучитьОбъектПоИдентификатору(Ид);
					ЗаполнитьЗначенияСвойств(ПользовательскийОтбор, ЭлементОтбора);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат ПользовательскиеНастройкиМодифицированы;
	
КонецФункции

#КонецОбласти

#КонецЕсли