////////////////////////////////////////////////////////////////////////////////
//МОДУЛЬ СОДЕРЖИТ ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ С КОНТЕКТСТНЫМИ ОТЧЕТАМИ, ИСПОЛЬЗУЮЩИЕ СКД
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция обрабатывает расшифровку в отчете, отображаемом на форме. Если расшифровка предполагает открытие значение, то
// дальшейшую обработку в форме делать не нужно, если нужно сформировать отчет-расшифровки, то фукнция вернет описание расшифровки
// которое нужно передать в соотвествующую серверную фукнцию
//
// Параметры:
//		Форма - УправляемаяФорма - форма, в которой расположен отчет
//		ИмяРеквизитаФормы - Строка - реквизит формы связанный с отчетом
//		ИдентификаторРасшифровки - ИдентификаторРасшифровкиКомпоновкиДанных - параметр события ОбработкаРасшифровки
//		СтандартнаяОбработка - Булево - параметр события ОбработкаРасшифровки
//		ПараметрыРасшифровки - Структура - содержит дополнительные параметры расшифровки
//				* МенюОтчетов - Массив - массив, значения которого имеют тип Структура и описывают отчеты, которыми можно расшифровать
//				* МенюДействий - Массив - массив, значения которого имеют тип Структура и описывают действия, которые можно выполнить
// Возвращаемое значение:
//		ОписаниеОбработкиРасшифровкиКомпоновкиДанных, Неопределено - если необходимо сформировать отчет-расшифровку возвращается значение
//			для передачи в соотвествующую серверную фукнцию, иначе возвращается Неопределено
//
Процедура ОбработатьРасшифровку(Форма, ИмяРеквизитаФормы, ИдентификаторРасшифровки, СтандартнаяОбработка, ПараметрыРасшифровки = Неопределено) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыДополнительногоМеню = ПараметрыДополнительногоМенюРасшифровки(
											Форма["АдресДанныхРасшифровки" + ИмяРеквизитаФормы],
											ПараметрыРасшифровки,
											ИдентификаторРасшифровки);
											
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Форма", Форма);
	ПараметрыОбработчика.Вставить("ИмяРеквизитаФормы", ИмяРеквизитаФормы);
	ПараметрыОбработчика.Вставить("ИдентификаторРасшифровки", ИдентификаторРасшифровки);
	
	ПоказатьВыборДействияПриРасшифровке(
			ПараметрыДополнительногоМеню, 
			ИдентификаторРасшифровки, 
			Форма["АдресДанныхРасшифровки" + ИмяРеквизитаФормы], 
			Форма["АдресСхемы" + ИмяРеквизитаФормы],
			Неопределено,
			"ОбработатьРасшифровкуЗавершение",
			ПараметрыОбработчика);
	
КонецПроцедуры

// Процедура отрабатывает расшифровку в отчет путем формирования меню действий и отработки выбранного действия
//
// Параметры:
//		Форма - Форма - форма, в которой расположен отчет
//		ПараметрыРасшифровки - Структура - параметр события ОбработкаРасшифровки
//				МенюОтчетов - Массив - массив, значения которого имеют тип Структура и описывают отчет-приемник
//				МенюДействий - Массив - массив, значения которого имеют тип Структура и описывают тип выполняемого действия
//				Расшифровка - Произвольный - значение расшифровки
//						см. события для "Расширение поля формы для поля табличного документа" в справке.
//		СтандартнаяОбработка - Булево - параметр события ОбработкаРасшифровки
//
Процедура ОбработкаРасшифровкиСДополнительнымМеню(Форма, ПараметрыРасшифровки, СтандартнаяОбработка) Экспорт
	
	ИдентификаторРасшифровки = ПараметрыРасшифровки.Расшифровка;
	
	ПараметрыДополнительногоМеню = ПараметрыДополнительногоМенюРасшифровки(
											Форма.ОтчетДанныеРасшифровки,
											ПараметрыРасшифровки,
											ИдентификаторРасшифровки);
	
	
	Если ПараметрыДополнительногоМеню = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
    СтандартнаяОбработка = Ложь;
	
	ПоказатьВыборДействияПриРасшифровке(
			ПараметрыДополнительногоМеню, 
			ИдентификаторРасшифровки, 
			Форма.ОтчетДанныеРасшифровки, 
			Форма.Отчет,
			Форма.НастройкиОтчета.ПолноеИмя,
			"ОбработкаРасшифровкиСДополнительнымМенюЗавершение",
			Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОбработатьРасшифровкуЗавершение(ВыполненноеДействие, ПараметрВыполненногоДействия, ДополнительныеПараметры) Экспорт 
	
	Если ОбработатьНеСтандартнуюРасшифровку(ВыполненноеДействие, ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли; 
	
	ОписаниеОбработкиРасшифровки = Неопределено;
	Если ПараметрВыполненногоДействия <> Неопределено Тогда
		Если ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
			ПоказатьЗначение(,ПараметрВыполненногоДействия);
		Иначе
			ОписаниеОбработкиРасшифровки = Новый ОписаниеОбработкиРасшифровкиКомпоновкиДанных(
				ДополнительныеПараметры.ДанныеРасшифровки, 
				ДополнительныеПараметры.ПараметрыОбработчика.ИдентификаторРасшифровки, 
				ПараметрВыполненногоДействия);
		КонецЕсли;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("ОписаниеОбработкиРасшифровки", ОписаниеОбработкиРасшифровки);
	Параметры.Вставить("ИмяРеквизитаФормы", ДополнительныеПараметры.ПараметрыОбработчика.ИмяРеквизитаФормы);
	Оповестить("ОбработатьРасшифровку", Параметры); 
	
КонецПроцедуры

Процедура ОбработкаРасшифровкиСДополнительнымМенюЗавершение(ВыполненноеДействие, ПараметрВыполненногоДействия, ДополнительныеПараметры) Экспорт 
	
	Если ОбработатьНеСтандартнуюРасшифровку(ВыполненноеДействие, ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли; 
	
	Если ПараметрВыполненногоДействия <> Неопределено Тогда
		
		Если ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
			
			ПоказатьЗначение(,ПараметрВыполненногоДействия);
			
		ИначеЕсли ВыполненноеДействие <> ДействиеОбработкиРасшифровкиКомпоновкиДанных.Нет Тогда
			
			ОписаниеОбработкиРасшифровки = Новый ОписаниеОбработкиРасшифровкиКомпоновкиДанных(
				ДополнительныеПараметры.ДанныеРасшифровки,
				ДополнительныеПараметры.Расшифровка,
				ПараметрВыполненногоДействия);
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("СформироватьПриОткрытии",     Истина);
			ПараметрыФормы.Вставить("КлючНазначенияИспользования", ДополнительныеПараметры.Расшифровка);
			ПараметрыФормы.Вставить("Расшифровка",                 ОписаниеОбработкиРасшифровки);
			
			ОткрытьФорму(ДополнительныеПараметры.КлючОбъекта + ".Форма", ПараметрыФормы);
			
		КонецЕсли; 
	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура ПоказатьВыборДействияПриРасшифровке(ПараметрыДополнительногоМеню, Расшифровка, ДанныеРасшифровки, АдресСхемы, КлючОбъекта, ИмяОбработчика, ПараметрыОбработчика)
	
	ДополнительноеМеню = Неопределено;
	
    ДополнительныеПараметры = Новый Структура;
    ДополнительныеПараметры.Вставить("Расшифровка", Расшифровка);
    ДополнительныеПараметры.Вставить("ДанныеРасшифровки", ДанныеРасшифровки);
    ДополнительныеПараметры.Вставить("АдресСхемы", АдресСхемы);
    ДополнительныеПараметры.Вставить("КлючОбъекта", КлючОбъекта);
    ДополнительныеПараметры.Вставить("ПараметрыОбработчика", ПараметрыОбработчика);
	
	Если ПараметрыДополнительногоМеню <> Неопределено Тогда
	    ДополнительныеПараметры.Вставить("МенюДействий", ПараметрыДополнительногоМеню.МенюДействий);
	    ДополнительныеПараметры.Вставить("МенюОтчетов", ПараметрыДополнительногоМеню.МенюОтчетов);
	    ДополнительныеПараметры.Вставить("ПараметрыФормыРасшифровки", ПараметрыДополнительногоМеню.ПараметрыФормыРасшифровки);
	    ДополнительныеПараметры.Вставить("ПараметрыДействий", ПараметрыДополнительногоМеню.ПараметрыДействий);
	    ДополнительныеПараметры.Вставить("ПараметрыОтчетов", ПараметрыДополнительногоМеню.ПараметрыОтчетов);
		ДополнительноеМеню = ПараметрыДополнительногоМеню.ДополнительноеМеню;
	КонецЕсли; 
	
    ОписаниеОповещения = Новый ОписаниеОповещения(ИмяОбработчика, ЭтотОбъект, ДополнительныеПараметры);
	
    ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(
									    ДанныеРасшифровки, 
									    Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	
    ОбработкаРасшифровки.ПоказатьВыборДействия(
		    ОписаниеОповещения, 
		    Расшифровка,,
		    ДополнительноеМеню);

КонецПроцедуры

Функция ПараметрыДополнительногоМенюРасшифровки(АдресДанныхРасшифровки, ПараметрыРасшифровки, Расшифровка)

	Если ПараметрыРасшифровки = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// Получим все поля расшифровки и параметры
	ПараметрыФормыРасшифровки = ПараметрыФормыРасшифровки(АдресДанныхРасшифровки, ПараметрыРасшифровки, Расшифровка);
	
	// Формирование меню
	ДополнительноеМеню = Новый СписокЗначений;
	
	ПараметрыОтчетов = Новый Соответствие;
	ПараметрыДействий = Новый Соответствие;
	
	// Меню - Расшифровать отчетом
	МенюОтчетов = Новый СписокЗначений;
	Если ПараметрыРасшифровки.Свойство("МенюОтчетов") И ПараметрыРасшифровки.МенюОтчетов.Количество() <> 0 Тогда
		Для каждого ПараметрыОтчета Из ПараметрыРасшифровки.МенюОтчетов Цикл
			Если ЕстьНеобходимыеПараметрыИЗначения(ПараметрыОтчета, ПараметрыФормыРасшифровки)
				И ЕстьДостаточныеПараметрыИЗначения(ПараметрыОтчета, ПараметрыФормыРасшифровки) Тогда
				МенюОтчетов.Добавить(ПараметрыОтчета.Имя, ПараметрыОтчета.Заголовок);
				ПараметрыОтчетов.Вставить(ПараметрыОтчета.Имя, ПараметрыОтчета);
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли;
	Если МенюОтчетов.Количество() <> 0 Тогда
		ДополнительноеМеню.Добавить(МенюОтчетов, НСтр("ru = 'Расшифровать другим отчетом'"));
	КонецЕсли; 
	
	// Меню - Перейти
	МенюДействий = Новый СписокЗначений;
	Если ПараметрыРасшифровки.Свойство("МенюДействий") И ПараметрыРасшифровки.МенюДействий.Количество() <> 0 Тогда
		Для каждого ПараметрыДействия Из ПараметрыРасшифровки.МенюДействий Цикл
			Если ЕстьНеобходимыеПараметрыИЗначения(ПараметрыДействия, ПараметрыФормыРасшифровки) Тогда
				МенюДействий.Добавить(ПараметрыДействия.Имя, ПараметрыДействия.Заголовок);
				ПараметрыДействий.Вставить(ПараметрыДействия.Имя, ПараметрыДействия);
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли;
	Если МенюДействий.Количество() <> 0 Тогда
		ДополнительноеМеню.Добавить(МенюДействий, НСтр("ru = 'Перейти'"));
	КонецЕсли; 

	Если ДополнительноеМеню.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыДополнительногоМеню = Новый Структура;
	ПараметрыДополнительногоМеню.Вставить("ДополнительноеМеню", ДополнительноеМеню);
	ПараметрыДополнительногоМеню.Вставить("ПараметрыОтчетов", ПараметрыОтчетов);
	ПараметрыДополнительногоМеню.Вставить("ПараметрыДействий", ПараметрыДействий);
	ПараметрыДополнительногоМеню.Вставить("МенюОтчетов", МенюОтчетов);
	ПараметрыДополнительногоМеню.Вставить("МенюДействий", МенюДействий);
	ПараметрыДополнительногоМеню.Вставить("ПараметрыФормыРасшифровки", ПараметрыФормыРасшифровки);
	
	Возврат ПараметрыДополнительногоМеню;
	
КонецФункции

Функция ПараметрыФормыРасшифровки(АдресДанныхРасшифровки, ПараметрыРасшифровки, Расшифровка)
	
	СписокПараметров = Новый Массив;
	ПоляРасшифровки = Новый Массив;
	
	СписокИсточников = Новый Массив;
	СписокИсточников.Добавить("МенюОтчетов");
	СписокИсточников.Добавить("МенюДействий");
	
	Для каждого ИмяИсточника Из СписокИсточников Цикл
		Если ПараметрыРасшифровки.Свойство(ИмяИсточника) И ПараметрыРасшифровки[ИмяИсточника].Количество() <> 0 Тогда
			Для каждого ПараметрыИсточника Из ПараметрыРасшифровки[ИмяИсточника] Цикл
				Если ПараметрыИсточника.Свойство("ПоляРасшифровки") Тогда
					Для каждого ИмяПоля Из ПараметрыИсточника.ПоляРасшифровки Цикл
						Если ПоляРасшифровки.Найти(ИмяПоля) = Неопределено Тогда
							ПоляРасшифровки.Добавить(ИмяПоля);
						КонецЕсли;
					КонецЦикла; 
				КонецЕсли;
				Если ПараметрыИсточника.Свойство("СписокПараметров") Тогда
					Для каждого ИмяПараметра Из ПараметрыИсточника.СписокПараметров Цикл
						Если СписокПараметров.Найти(ИмяПараметра) = Неопределено Тогда
							СписокПараметров.Добавить(ИмяПараметра);
						КонецЕсли;
					КонецЦикла; 
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла; 
	
	Если СписокПараметров.Количество() <> 0 ИЛИ ПоляРасшифровки.Количество() <> 0 Тогда
		ПараметрыФормыРасшифровки = КомпоновкаДанныхВызовСервера.ПараметрыФормыРасшифровки(
												Расшифровка, 
												АдресДанныхРасшифровки, 
												СписокПараметров, 
												ПоляРасшифровки);
	Иначе
		ПараметрыФормыРасшифровки = Неопределено;
	КонецЕсли;

	Возврат ПараметрыФормыРасшифровки;
	
КонецФункции

Функция ОбработатьНеСтандартнуюРасшифровку(ВыполненноеДействие, ДополнительныеПараметры)

	МенюДействий = Неопределено;
	МенюОтчетов = Неопределено;
	Если ДополнительныеПараметры.Свойство("МенюДействий") Тогда
		МенюДействий = ДополнительныеПараметры.МенюДействий;
	КонецЕсли; 
	Если ДополнительныеПараметры.Свойство("МенюОтчетов") Тогда
		МенюОтчетов = ДополнительныеПараметры.МенюОтчетов;
	КонецЕсли; 
	
	Если МенюДействий = Неопределено И МенюОтчетов = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Расшифровка = ДополнительныеПараметры.Расшифровка;
	КлючОбъекта = ДополнительныеПараметры.КлючОбъекта;
	ДанныеРасшифровки = ДополнительныеПараметры.ДанныеРасшифровки;
	АдресСхемы = ДополнительныеПараметры.АдресСхемы;
	ПараметрыФормыРасшифровки = ДополнительныеПараметры.ПараметрыФормыРасшифровки;
	ПараметрыДействий = ДополнительныеПараметры.ПараметрыДействий;
	ПараметрыОтчетов = ДополнительныеПараметры.ПараметрыОтчетов;
	
	Если МенюОтчетов.НайтиПоЗначению(ВыполненноеДействие) <> Неопределено Тогда
		
		ПараметрыОтчета = ПараметрыОтчетов.Получить(ВыполненноеДействие);
		
		ПараметрыФормы = Новый Структура;
		Если ПараметрыОтчета.Свойство("РежимРасшифровки") Тогда
			ПараметрыФормы.Вставить("РежимРасшифровки",         ПараметрыОтчета.РежимРасшифровки);
		КонецЕсли;
		ПараметрыФормы.Вставить("КлючПользовательскихНастроек", ВыполненноеДействие);
		ПараметрыФормы.Вставить("СформироватьПриОткрытии",      Истина);
		ПараметрыФормы.Вставить("КлючНазначенияИспользования",  ВыполненноеДействие + Строка(Новый УникальныйИдентификатор));
		ПараметрыФормы.Вставить("КлючВарианта",                 ВыполненноеДействие);
		ПараметрыФормы.Вставить("Отбор",                        ПараметрыФормыРасшифровки);
		
		// Перенос поддерживаемых источником и приемником отборов
		Если ПараметрыФормыРасшифровки.Свойство("Отбор") Тогда
			Для Каждого Отбор Из ПараметрыФормыРасшифровки.Отбор.Элементы Цикл
				// Расширенные отборы могут быть только в "корне" коллеции, не в группе
				Если Не ТипЗнч(Отбор) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
					Продолжить;
				КонецЕсли;
				
				КлючОтбора = СтрЗаменить(Строка(Отбор.ЛевоеЗначение), ".", "_");
				Если ПараметрыОтчета.ПоляРасшифровки.Найти(КлючОтбора) <> Неопределено
					И Отбор.Использование Тогда
					ПараметрыФормыРасшифровки.Вставить(КлючОтбора, Отбор.ПравоеЗначение);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		ПараметрыФормы.Отбор.Удалить("Отбор");
		
		Если ПараметрыОтчета.Свойство("ЗаменаПараметров") Тогда
			Для Каждого КлючИЗначениеЗаменыПараметров Из ПараметрыОтчета.ЗаменаПараметров Цикл
				КлючУдаляемогоОтбора = "";
				КлючИскомогоОтбораПараметра = КлючИЗначениеЗаменыПараметров.Ключ;
				КлючЦелевогоПараметраОтбора = КлючИЗначениеЗаменыПараметров.Значение;
				
				// Непосредственный поиск параметров формы-приемника по ключу
				Если ПараметрыФормыРасшифровки.Свойство(КлючИскомогоОтбораПараметра) Тогда
					
					Если ТипЗнч(КлючЦелевогоПараметраОтбора) = Тип("Строка") Тогда
						ПараметрыФормы.Отбор.Вставить(КлючЦелевогоПараметраОтбора, ПараметрыФормыРасшифровки[КлючИскомогоОтбораПараметра]);
						КлючУдаляемогоОтбора = КлючИскомогоОтбораПараметра;
						
					ИначеЕсли ТипЗнч(КлючЦелевогоПараметраОтбора) = Тип("Соответствие") Тогда
						ЗаменяющиеПараметры = КлючЦелевогоПараметраОтбора;
						НайденныеЗаменяющиеПараметры = ЗаменяющиеПараметры.Получить(ПараметрыФормыРасшифровки[КлючИскомогоОтбораПараметра]);
						
						Если НайденныеЗаменяющиеПараметры <> Неопределено Тогда
							Для каждого НайденныйЗаменяющийПараметр Из НайденныеЗаменяющиеПараметры Цикл 
								ПараметрыФормы.Отбор.Вставить(НайденныйЗаменяющийПараметр.Ключ, НайденныйЗаменяющийПараметр.Значение);
							КонецЦикла;
						КонецЕсли;
						КлючУдаляемогоОтбора = КлючИскомогоОтбораПараметра;
						
					ИначеЕсли ТипЗнч(КлючЦелевогоПараметраОтбора) = Тип("Неопределено") Тогда
						КлючУдаляемогоОтбора = КлючИскомогоОтбораПараметра;
							
					КонецЕсли;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(КлючУдаляемогоОтбора) Тогда
					ПараметрыФормы.Отбор.Удалить(КлючУдаляемогоОтбора);
				КонецЕсли;
				
				// Поиск требующих замены параметров - полей "через точку"
				Для Каждого ПараметрФормыРасшифровки Из ПараметрыФормыРасшифровки Цикл 
					Если СтрНайти(ПараметрФормыРасшифровки.Ключ, КлючИскомогоОтбораПараметра + "_") > 0 Тогда
						ПараметрыФормы.Отбор.Вставить(СтрЗаменить(ПараметрФормыРасшифровки.Ключ, КлючИскомогоОтбораПараметра + "_", КлючЦелевогоПараметраОтбора + "_"), ПараметрФормыРасшифровки.Значение);
						КлючУдаляемогоОтбора = ПараметрФормыРасшифровки.Ключ;
					КонецЕсли;
				КонецЦикла;
				
				Если ЗначениеЗаполнено(КлючУдаляемогоОтбора) Тогда
					ПараметрыФормы.Отбор.Удалить(КлючУдаляемогоОтбора);
				КонецЕсли;
			КонецЦикла; 
		КонецЕсли; 
		
		Если ПараметрыОтчета.Свойство("ФиксированныеПараметры") Тогда
			Для каждого ФиксированныйПараметр Из ПараметрыОтчета.ФиксированныеПараметры Цикл
				ПараметрыФормы.Отбор.Вставить(ФиксированныйПараметр.Ключ, ФиксированныйПараметр.Значение);
			КонецЦикла;
		КонецЕсли;
				
		ОткрытьФорму(ПараметрыОтчета.ИмяОтчета + ".Форма", ПараметрыФормы);
		
		Возврат Истина;
		
	ИначеЕсли МенюДействий.НайтиПоЗначению(ВыполненноеДействие) <> Неопределено Тогда
		
		ПараметрыДействия = ПараметрыДействий.Получить(ВыполненноеДействие);
		
		Если ПараметрыДействия.Свойство("Действие") Тогда
			ВыполнитьДействие = ПараметрыДействия.Действие;
		Иначе
			ВыполнитьДействие = ВыполненноеДействие;
		КонецЕсли;	
		
		Если ВыполнитьДействие = "ОткрытьФорму" Тогда
			Если ПараметрыДействия.Свойство("ПараметрыФормы") Тогда
				
				ПараметрыФормы = ПараметрыДействия.ПараметрыФормы;
				ЗаполнитьЗначенияСвойств(ПараметрыФормы, ПараметрыФормыРасшифровки);
				Если ПараметрыДействия.Свойство("ЗаменаПараметров") Тогда
					Для каждого КлючИЗначениеЗаменыПараметров Из ПараметрыДействия.ЗаменаПараметров Цикл
						Если ПараметрыФормыРасшифровки.Свойство(КлючИЗначениеЗаменыПараметров.Ключ) Тогда
							ПараметрыФормы.Вставить(КлючИЗначениеЗаменыПараметров.Значение, ПараметрыФормыРасшифровки[КлючИЗначениеЗаменыПараметров.Ключ]);
						КонецЕсли; 
					КонецЦикла; 
				КонецЕсли; 
				
			Иначе
				ПараметрыФормы = Неопределено;
			КонецЕсли;
			
			ОткрытьФорму(ПараметрыДействия.ИмяФормы, ПараметрыФормы);
		Иначе
			ИмяОбщегоМодуля = ПараметрыДействия.ИмяОбщегоМодуля;
			ОбщегоНазначенияКлиент.ОбщийМодуль(ИмяОбщегоМодуля).ВыполнитьДействиеРасшифровки(ПараметрыДействия, ПараметрыФормыРасшифровки);
		КонецЕсли; 
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ЕстьНеобходимыеПараметрыИЗначения(ПараметрыМеню, ПараметрыФормыРасшифровки)

	Если НЕ ПараметрыМеню.Свойство("НеобходимыеПараметры") Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ПараметрыФормыРасшифровки = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли; 
	
	НеобходимыеПараметры = ПараметрыМеню.НеобходимыеПараметры;
	Для каждого КлючИЗначение Из НеобходимыеПараметры Цикл
		Если НЕ ПараметрыФормыРасшифровки.Свойство(КлючИЗначение.Ключ) Тогда
			Возврат Ложь;
		Иначе
			Если КлючИЗначение.Значение <> Неопределено
				И КлючИЗначение.Значение.Найти(ПараметрыФормыРасшифровки[КлючИЗначение.Ключ]) = Неопределено Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла; 
	
	Возврат Истина;

КонецФункции
 
Функция ЕстьДостаточныеПараметрыИЗначения(ПараметрыМеню, ПараметрыФормыРасшифровки)
	Если НЕ ПараметрыМеню.Свойство("ДостаточныеПараметры") Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ПараметрыФормыРасшифровки = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли; 
	
	ДостаточныеПараметры = ПараметрыМеню.ДостаточныеПараметры;
	ЕстьДостаточныеПараметрыИЗначения = Истина;
	Для каждого КлючИЗначение Из ДостаточныеПараметры Цикл
		Если НЕ ПараметрыФормыРасшифровки.Свойство(КлючИЗначение.Ключ) Тогда
			ЕстьДостаточныеПараметрыИЗначения = Ложь;
		ИначеЕсли ПараметрыФормыРасшифровки.Свойство(КлючИЗначение.Ключ) Тогда
			ЕстьДостаточныеПараметрыИЗначения = Истина;
			Прервать;
		Иначе
			Если КлючИЗначение.Значение <> Неопределено
				И КлючИЗначение.Значение.Найти(ПараметрыФормыРасшифровки[КлючИЗначение.Ключ]) = Неопределено Тогда
				ЕстьДостаточныеПараметрыИЗначения = Ложь;
			Иначе
				ЕстьДостаточныеПараметрыИЗначения = Истина;
				Прервать;
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла; 
	
	Возврат ЕстьДостаточныеПараметрыИЗначения;

КонецФункции
 
#КонецОбласти
