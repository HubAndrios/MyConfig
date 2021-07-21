
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	
	//установить заголовок по отбору
	Если Параметры.Свойство("РозничныеМагазины") Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru='Розничные магазины'");
	КонецЕсли;
		
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРозничныеПродажи") Тогда
		Элементы.ФормаСоздать.Видимость = Ложь;
		Элементы.ГруппаСоздатьСклад.Видимость = Истина;
	Иначе
		Элементы.ФормаСоздать.Видимость = Истина;
		Элементы.ГруппаСоздатьСклад.Видимость = Ложь;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Справочники.Склады) Тогда
		Элементы.ГруппаСоздатьСклад.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.Список.ИзменятьСоставСтрок = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура СоздатьОптовыйСклад(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ТипСклада", ПредопределенноеЗначение("Перечисление.ТипыСкладов.ОптовыйСклад"));
	ЗначенияЗаполнения.Вставить("Группа", ТекущийЭлемент.ТекущийРодитель);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Справочник.Склады.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры
		
&НаКлиенте
Процедура СоздатьРозничныйМагазин(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ТипСклада", ПредопределенноеЗначение("Перечисление.ТипыСкладов.РозничныйМагазин"));
	ЗначенияЗаполнения.Вставить("Группа", ТекущийЭлемент.ТекущийРодитель);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Справочник.Склады.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры


#КонецОбласти

