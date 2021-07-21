
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	ОтображатьНастройкиСчетовУчета = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	Элементы.ГруппаОтражениеВРеглУчете.Видимость = ОтображатьНастройкиСчетовУчета;
	
	Элементы.ГруппаОтражениеВМеждународномУчете.Видимость = Ложь;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Возврат; // в УТ11 обработчик пустой
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСчетаРеглУчетаПоОрганизациям(Команда)
	
	
	Возврат; // Чтобы в УТ был не пустой обработчик
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	МассивПрименимость = Новый Массив;
	
	ИспользоватьКомиссиюПриЗакупках = ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриЗакупках");
	ИспользоватьКомиссиюПриПродажах = ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриПродажах");
	ИспользоватьПередачиТоваровМеждуОрганизациями = ПолучитьФункциональнуюОпцию("ИспользоватьПередачиТоваровМеждуОрганизациями");
	ИспользоватьДоговорыКредитовИДепозитов = ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыКредитовИДепозитов");
	
	СписокВыбора = Элементы.Применимость.СписокВыбора;
	СписокВыбора.Очистить();
	
	СписокВыбора.Добавить(1, НСтр("ru = 'клиентами'"));
	СписокВыбора.Добавить(2, НСтр("ru = 'поставщиками'"));
	Если ИспользоватьКомиссиюПриПродажах 
		 ИЛИ ИспользоватьПередачиТоваровМеждуОрганизациями
		 ИЛИ Объект.РасчетыСКомиссионерами Тогда
		СписокВыбора.Добавить(3, НСтр("ru = 'комиссионерами (агентами)'"));
	КонецЕсли;
	Если ИспользоватьКомиссиюПриЗакупках 
		ИЛИ ИспользоватьПередачиТоваровМеждуОрганизациями
		ИЛИ Объект.РасчетыСКомитентами Тогда
		СписокВыбора.Добавить(4, НСтр("ru = 'комитентами (принципалами)'"));
	КонецЕсли;
	Если ИспользоватьДоговорыКредитовИДепозитов 
		ИЛИ Объект.РасчетыСКредиторами Тогда
		СписокВыбора.Добавить(5, НСтр("ru = 'кредиторами (займы, кредиты)'"));
	КонецЕсли;
	Если ИспользоватьДоговорыКредитовИДепозитов
		ИЛИ Объект.РасчетыСДебиторами Тогда
		СписокВыбора.Добавить(6, НСтр("ru = 'дебиторами (депозиты, займы)'"));
	КонецЕсли;
	
	Если Объект.РасчетыСКлиентами Тогда
		МассивПрименимость.Добавить(1);
	КонецЕсли;
	Если Объект.РасчетыСПоставщиками Тогда
		МассивПрименимость.Добавить(2);
	КонецЕсли;
	Если Объект.РасчетыСКомиссионерами Тогда
		МассивПрименимость.Добавить(3);
	КонецЕсли;
	Если Объект.РасчетыСКомитентами Тогда
		МассивПрименимость.Добавить(4);
	КонецЕсли;
	Если Объект.РасчетыСКредиторами Тогда
		МассивПрименимость.Добавить(5);
	КонецЕсли;
	Если Объект.РасчетыСДебиторами Тогда
		МассивПрименимость.Добавить(6);
	КонецЕсли;

	Если МассивПрименимость.Количество() = 1 Тогда
		Применимость = МассивПрименимость[0];
	Иначе
		Применимость = 0;
		МассивПодстрок = Новый Массив;
		Для каждого Элемент Из МассивПрименимость Цикл
			ЭлементСписка = СписокВыбора.НайтиПоЗначению(Элемент); 
			Если ЭлементСписка <> Неопределено Тогда
				МассивПодстрок.Добавить(ЭлементСписка.Представление);
			КонецЕсли;
		КонецЦикла;
		СписокВыбораУниверсальная = Элементы.ПрименимостьУниверсальная.СписокВыбора;
		СписокВыбораУниверсальная.Очистить();
		СписокВыбораУниверсальная.Добавить(0, СтрСоединить(МассивПодстрок, ", "));
	КонецЕсли;
	Элементы.ПрименимостьУниверсальная.Видимость = (Применимость = 0);
	
	
КонецПроцедуры



&НаКлиенте
Процедура ПрименимостьПриИзменении(Элемент)
	
	Объект.РасчетыСКлиентами = Ложь;
	Объект.РасчетыСПоставщиками = Ложь;
	Объект.РасчетыСКомиссионерами = Ложь;
	Объект.РасчетыСКомитентами = Ложь;
	Объект.РасчетыСКредиторами = Ложь;
	Объект.РасчетыСДебиторами = Ложь;
	
	Если Применимость = 1 Тогда
		Объект.РасчетыСКлиентами = Истина;
	ИначеЕсли Применимость = 2 Тогда
		Объект.РасчетыСПоставщиками = Истина;
	ИначеЕсли Применимость = 3 Тогда
		Объект.РасчетыСКомиссионерами = Истина;
	ИначеЕсли Применимость = 4 Тогда
		Объект.РасчетыСКомитентами = Истина;
	ИначеЕсли Применимость = 5 Тогда
		Объект.РасчетыСКредиторами = Истина;
	ИначеЕсли Применимость = 6 Тогда
		Объект.РасчетыСДебиторами = Истина;
	КонецЕсли;
	
	НастройкаЭлементовСчетовУчета();
	
КонецПроцедуры

&НаСервере
Процедура НастройкаЭлементовСчетовУчета()
	
	Если Применимость = 0 Тогда
		Элементы.ГруппаСчетаУчетаСтраницы.ТекущаяСтраница = Элементы.СтраницаУниверсальная;
	ИначеЕсли Объект.РасчетыСКлиентами Тогда
		Элементы.ГруппаСчетаУчетаСтраницы.ТекущаяСтраница = Элементы.СтраницаРасчетыСКлиентами;
	ИначеЕсли Объект.РасчетыСПоставщиками Тогда
		Элементы.ГруппаСчетаУчетаСтраницы.ТекущаяСтраница = Элементы.СтраницаРасчетыСПоставщиками;
	ИначеЕсли Объект.РасчетыСКомитентами Тогда
		Элементы.ГруппаСчетаУчетаСтраницы.ТекущаяСтраница = Элементы.СтраницаРасчетыСКомитентами;
	ИначеЕсли Объект.РасчетыСКомиссионерами Тогда
		Элементы.ГруппаСчетаУчетаСтраницы.ТекущаяСтраница = Элементы.СтраницаРасчетыСКомиссионерами;
	ИначеЕсли Объект.РасчетыСКредиторами Тогда
		Элементы.ГруппаСчетаУчетаСтраницы.ТекущаяСтраница = Элементы.СтраницаРасчетыСКредиторами;
	ИначеЕсли Объект.РасчетыСДебиторами Тогда
		Элементы.ГруппаСчетаУчетаСтраницы.ТекущаяСтраница = Элементы.СтраницаРасчетыСДебиторами;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
