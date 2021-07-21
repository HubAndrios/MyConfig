&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = ОбщегоНазначенияУТПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	РежимРаботы = Новый Структура;
	
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьПодразделения");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьНесколькоОрганизаций");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьБюджетирование");
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	ИспользоватьЖурналПлатежей = НаборКонстант.ИспользоватьЖурналПлатежей;
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
	 ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
	 		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
	 			Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтаФорма.Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьДоговорыКредитовИДепозитовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНесколькоКассПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗаявкиНаРасходованиеДенежныхСредствПриИзменении(Элемент)
	
	Если НаборКонстант.ИспользоватьЗаказыПоставщикам И НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств Тогда
		
		УстановитьИспользованиеЗаказовПоставщикамИЗаявокНаРасходованиеДС(Истина);
		
	Иначе
		
		УстановитьИспользованиеЗаказовПоставщикамИЗаявокНаРасходованиеДС(Ложь);
		
	КонецЕсли;

	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНесколькоРасчетныхСчетовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЛимитыРасходаДенежныхСредствПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЛимитыРасходаДенежныхСредствПоОрганизациямПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениямПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьПревышениеЛимитовРасходаДенежныхСредствПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЖурналПлатежейПриИзменении(Элемент)
	
	НаборКонстант.ИспользоватьЖурналПлатежей = ИспользоватьЖурналПлатежей;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОплатуПлатежнымиКартамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДоверенностиНаПолучениеТМЦПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСтатусыАвансовыхОтчетовПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьВыдачуПодОтчетВРазрезеЦелейПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоддержкаПлатежейВСоответствииС275ФЗПриИзменении(Элемент)
	
	Возврат;
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиПодтверждающихДокументовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Возврат;
КонецПроцедуры

&НаКлиенте
Процедура МаксимальныйРазмерФайлаПодтверждающегоДокументаПриИзменении(Элемент)
	
	Возврат;
КонецПроцедуры

&НаКлиенте
Процедура МаксимальныйРазмерФайлаАрхиваПодтверждающихДокументовПриИзменении(Элемент)
	
	Возврат;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьТипыПлатежей275ФЗ(Команда)
	
	
	Возврат; // В УТ обработчик пустой
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыПодтверждающихДокументов(Команда)
	
	
	Возврат; // В УТ обработчик пустой
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
		Если РеквизитПутьКДанным = "ИспользоватьЖурналПлатежей" Тогда
			КонстантаИмя = "ИспользоватьЖурналПлатежей";
			НаборКонстант.ИспользоватьЖурналПлатежей = Булево(ИспользоватьЖурналПлатежей);
		КонецЕсли;
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если ОбщегоНазначенияУТПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств" Тогда
		ИспользоватьЖурналПлатежей = НаборКонстант.ИспользоватьЖурналПлатежей;
	КонецЕсли;
	
	Возврат КонстантаИмя
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")

	Если РеквизитПутьКДанным = "" Тогда
		
		Элементы.ИспользоватьНесколькоКасс.Доступность = НЕ НаборКонстант.ИспользоватьНесколькоОрганизаций;
		Элементы.ИспользоватьНесколькоРасчетныхСчетов.Доступность = НЕ НаборКонстант.ИспользоватьНесколькоОрганизаций;
	
		
		Элементы.ИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениям.Доступность = НаборКонстант.ИспользоватьПодразделения;
		
		Элементы.ГруппаПоддержка275ФЗ.Видимость = Не Константы.УправлениеТорговлей.Получить();
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНесколькоКасс" ИЛИ РеквизитПутьКДанным = "" Тогда
		Если НаборКонстант.ИспользоватьНесколькоКасс Тогда
			Элементы.ГруппаСтраницыИспользоватьНесколькоКасс.ТекущаяСтраница = Элементы.ГруппаНесколькоКасс;
		Иначе
			Элементы.ГруппаСтраницыИспользоватьНесколькоКасс.ТекущаяСтраница = Элементы.ГруппаОднаКасса;
		КонецЕсли;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНесколькоРасчетныхСчетов" ИЛИ РеквизитПутьКДанным = "" Тогда
		Если НаборКонстант.ИспользоватьНесколькоРасчетныхСчетов Тогда
			Элементы.ГруппаСтраницыИспользоватьНесколькоРасчетныхСчетов.ТекущаяСтраница = Элементы.ГруппаНесколькоСчетов;
		Иначе
			Элементы.ГруппаСтраницыИспользоватьНесколькоРасчетныхСчетов.ТекущаяСтраница = Элементы.ГруппаОдинСчет;
		КонецЕсли;
	КонецЕсли;

	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств"
	 ИЛИ РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЛимитыРасходаДенежныхСредств"
	 ИЛИ РеквизитПутьКДанным = "" Тогда
		 
		ИспользоватьЛимиты = НаборКонстант.ИспользоватьЛимитыРасходаДенежныхСредств;
		
		Элементы.ИспользоватьЛимитыРасходаДенежныхСредств.Доступность = НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств;
		
		Элементы.ИспользоватьЛимитыРасходаДенежныхСредствПоОрганизациям.Доступность = ИспользоватьЛимиты И НаборКонстант.ИспользоватьНесколькоОрганизаций;
		Элементы.ИспользоватьЛимитыРасходаДенежныхСредствПоПодразделениям.Доступность = ИспользоватьЛимиты И НаборКонстант.ИспользоватьПодразделения;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьБюджетирование") = Ложь Тогда
			Элементы.КонтролироватьПревышениеЛимитовРасходаДенежныхСредств.Доступность = ИспользоватьЛимиты;
		Иначе
			Элементы.КонтролироватьПревышениеЛимитовРасходаДенежныхСредств.Доступность = НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств;
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств"
		ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Элементы.ИспользоватьЖурналПлатежей.Доступность = Не НаборКонстант.ИспользоватьЗаявкиНаРасходованиеДенежныхСредств;
		
	КонецЕсли;
	
	
	УправлениеТорговлей = ПолучитьФункциональнуюОпцию("УправлениеТорговлей");
	Элементы.Декорация4.Видимость = Не УправлениеТорговлей;
	Элементы.Декорация5.Видимость = Не УправлениеТорговлей;
	Элементы.ПоддержкаПлатежейВСоответствииС275ФЗ.Видимость = Не УправлениеТорговлей;
	
	ОбменДаннымиУТУП.УстановитьДоступностьНастроекУзлаИнформационнойБазы(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИспользованиеЗаказовПоставщикамИЗаявокНаРасходованиеДС(Использование)
	
	Константы.ИспользоватьЗаказыПоставщикамИЗаявкиНаРасходованиеДС.Установить(Использование);
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти
