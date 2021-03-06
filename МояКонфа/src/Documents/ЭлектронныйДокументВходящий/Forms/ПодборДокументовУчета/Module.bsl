#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	СсылкаНаЭД = "";
	Если Параметры.Свойство("ЭлектронныйДокумент",СсылкаНаЭД) Тогда
		
		ЗначениеВРеквизитФормы(СсылкаНаЭД.ПолучитьОбъект(),"ЭлектронныйДокумент");
				
		СписокТиповДокументов = ОбменСКонтрагентамиСлужебный.СписокОперацийВидаЭД(ЭлектронныйДокумент.ВидЭД);
		
		Если СписокТиповДокументов.Количество() = 0 Тогда
			Элементы.ГруппаПодобрать.Видимость = Ложь;
			Элементы.ГруппаСоздать.Видимость = Ложь;
			Элементы.ФормаПодобратьДокумент.Видимость = Ложь;
			
		ИначеЕсли СписокТиповДокументов.Количество() = 1 Тогда
			
			Элементы.ГруппаПодобрать.Видимость = Ложь;
			Элементы.ГруппаСоздать.Видимость = Ложь;
			
			НоваяКоманда = ЭтотОбъект.Команды.Добавить("Создать_" + СписокТиповДокументов[0].Значение);
			НоваяКоманда.Действие = "СоздатьДокументУчета";
			Элементы.ФормаСоздатьДокумент.ИмяКоманды = "Создать_" + СписокТиповДокументов[0].Значение;

			НоваяКоманда = ЭтотОбъект.Команды.Добавить("Прикрепить_" + СписокТиповДокументов[0].Значение);
			НоваяКоманда.Действие = "ПодобратьДокумент";
			Элементы.ФормаПодобратьДокумент.ИмяКоманды = "Прикрепить_" + СписокТиповДокументов[0].Значение;
			
		Иначе
			
			Элементы.ФормаПодобратьДокумент.Видимость = Ложь;
			Элементы.ФормаСоздатьДокумент.Видимость = Ложь;
			
			Для Каждого ЭлементСписка Из СписокТиповДокументов Цикл
				
				НоваяКоманда = ЭтотОбъект.Команды.Добавить("Создать_" + ЭлементСписка.Значение);
				НоваяКоманда.Действие = "СоздатьДокументУчета";
				
				НоваяКнопка = Элементы.Добавить("Создать_" + ЭлементСписка.Значение,Тип("КнопкаФормы"),Элементы.ГруппаСоздать);
				НоваяКнопка.Заголовок = ЭлементСписка.Представление;
				НоваяКнопка.ИмяКоманды = "Создать_" + ЭлементСписка.Значение;
				
				НоваяКоманда = ЭтотОбъект.Команды.Добавить("Прикрепить_" + ЭлементСписка.Значение);
				НоваяКоманда.Действие = "ПодобратьДокумент";
				
				НоваяКнопка = Элементы.Добавить("Прикрепить_" + ЭлементСписка.Значение,Тип("КнопкаФормы"),Элементы.ГруппаПодобрать);
				НоваяКнопка.Заголовок = ЭлементСписка.Представление;  
				НоваяКнопка.ИмяКоманды = "Прикрепить_" + ЭлементСписка.Значение;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ЭлектронныйДокумент.ВидЭД = Перечисления.ВидыЭД.КаталогТоваров Тогда
			Элементы.ФормаПерезаполнитьТекущий.Заголовок = НСтр("ru = 'Сопоставить номенклатуру'");
		КонецЕсли;

		Если ЭлектронныйДокумент.ВидЭД = Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
			Элементы.ГруппаСоздать.Видимость = Ложь;
			Элементы.ФормаПерезаполнитьТекущий.Видимость = Ложь;
		КонецЕсли;
		
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерезаполнитьТекущий(Команда)
	
	Модифицированность = Ложь;
	ТекСтрока = Элементы.ЭлектронныйДокументДокументыОснования.ТекущиеДанные;
	
	Если ТекСтрока <> Неопределено Тогда
		ТекстВопроса = НСтр("ru = 'Документ учета будет заполнены данными электронного документа. Продолжить?'");
		СтруктураПараметров = Новый Структура("ДокументОснование,СпособОбработки",ТекСтрока.ДокументОснование,ТекСтрока.СпособОбработки);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПерезаполнитьТекущийПродолжить", ЭтотОбъект, СтруктураПараметров);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьДокумент(Команда)
	
	Модифицированность = Ложь;
	СпособОбработки = СтрЗаменить(Команда.Имя,"Прикрепить_","");
	ИмяТипа = ПолучитьИмяДокументаНаСервере(СпособОбработки); 
	Если ЗначениеЗаполнено(ИмяТипа) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПодобратьДокументЗавершить", ЭтотОбъект,СпособОбработки);
		Подсказка = НСтр("ru = 'Укажите документ отражения в учете'");
		ПоказатьВводЗначения(ОписаниеОповещения, , Подсказка, Новый ОписаниеТипов(ИмяТипа));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументУчета(Команда)
	
	СоздатьДокументУчетаНаСервере(СтрЗаменить(Команда.Имя,"Создать_",""));
	ОповеститьВладельца();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСвязьСДокументом(Команда)
		
	ТекСтрока = Элементы.ЭлектронныйДокументДокументыОснования.ТекущиеДанные;
	
	Если ТекСтрока <> Неопределено Тогда
		ТекстВопроса = НСтр("ru = 'Связь между документами разорвется. Повторно связать документы возможно только в ручном режиме. Продолжить?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьСвязьСДокументомЗавершить", ЭтотОбъект, ТекСтрока.ДокументОснование);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодобратьДокументЗавершить(Знач Результат, Знач СпособОбработки) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		ПерепривязатьЭлектронныйДокумент(Результат,СпособОбработки);
		ОповеститьВладельца();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьВладельца()
	
	Оповестить("ЭлектронныйДокументВходящий_ПодборДокументаУчета",ЭлектронныйДокумент.Ссылка, ЭтотОбъект.ВладелецФормы);
	
КонецПроцедуры

&НаСервере
Процедура СоздатьДокументУчетаНаСервере(СпособОбработки)
	
	СтруктураПараметров = Новый Структура;
	ЭД = ОбменСКонтрагентамиСлужебный.ПрисоединенныйФайл(ЭлектронныйДокумент.Ссылка);
	Если ОбменСКонтрагентамиСлужебный.ЭтоОтветныйТитул(ЭД.ТипЭлементаВерсииЭД) Тогда
		ЭД = ЭД.ЭлектронныйДокументВладелец;
	КонецЕсли;
	СтруктураПараметров.Вставить("ФайлДанныхСсылка", ОбменСКонтрагентамиСлужебныйВызовСервера.ПолучитьДанныеЭД(ЭД));
	
	Если ЭлектронныйДокумент.ВидЭД = Перечисления.ВидыЭД.КаталогТоваров Тогда
		
		ВладелецФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭД, "ВладелецФайла");
		НастройкаЭДО = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВладелецФайла, "НастройкаЭДО");
		
		ДокументыУчета = Новый Массив;
		ДокументыУчета.Добавить(НастройкаЭДО);
		
	Иначе
		
		ДокументыУчета = ОбменСКонтрагентамиВнутренний.СохранитьДанныеОбъекта(СтруктураПараметров, СпособОбработки);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДокументыУчета) Тогда
		ДокументОбъект = РеквизитФормыВЗначение("ЭлектронныйДокумент",Тип("ДокументОбъект.ЭлектронныйДокументВходящий"));
		Для каждого Основание Из ДокументыУчета Цикл
			
			Если Не ДокументОбъект.ДокументыОснования.Найти(Основание, "ДокументОснование") = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ДокументОбъект.ДокументыОснования.Добавить();
			НоваяСтрока.ДокументОснование = Основание;
			НоваяСтрока.СпособОбработки = СпособОбработки;
		
			ОбменСКонтрагентамиСлужебный.УстановитьСсылкуДляВладельцаВРегистреСостояний(Основание, ЭлектронныйДокумент.Ссылка);
		КонецЦикла;
		ДокументОбъект.Записать();
		
		ЗначениеВРеквизитФормы(ДокументОбъект,"ЭлектронныйДокумент");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСвязьСДокументомЗавершить(Результат, СсылкаНаОбъект) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		УдалитьСвязьСДокументомНаСервере(СсылкаНаОбъект,ЭлектронныйДокумент.Ссылка);
		ОповеститьВладельца();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСвязьСДокументомНаСервере(СсылкаНаОбъект,ЭД)
	
	ОбработатьДокументыОснования(СсылкаНаОбъект,,Истина);
	Если ЭлектронныйДокумент.ВидЭД <> Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
		ОбменСКонтрагентамиСлужебный.УдалитьСсылкуДляВладельцаВРегистреСостояний(СсылкаНаОбъект,ЭД);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьИмяДокументаНаСервере(СпособОбработки)
	
	ИмяТипа = ОбменСКонтрагентамиСлужебный.ИмяДокументаПоСпособуОбработки(СпособОбработки);
	
	Тип = Неопределено;
	Если Метаданные.Справочники.Найти(ИмяТипа) <> Неопределено Тогда
	
		Тип = "СправочникСсылка." + ИмяТипа;
	ИначеЕсли Метаданные.Документы.Найти(ИмяТипа) <> Неопределено Тогда
	
		Тип = "ДокументСсылка." + ИмяТипа;
	КонецЕсли;
	
	Возврат Тип;
		
КонецФункции

&НаСервере
Процедура ПерепривязатьЭлектронныйДокумент(ВыбранноеЗначение,СпособОбработки)
	
	ОбработатьДокументыОснования(ВыбранноеЗначение,СпособОбработки);
	Если ЭлектронныйДокумент.ВидЭД <> Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
		ОбменСКонтрагентамиСлужебный.УстановитьСсылкуДляВладельцаВРегистреСостояний(ВыбранноеЗначение,ЭлектронныйДокумент.Ссылка);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ОбработатьДокументыОснования(СсылкаНаДокумент,СпособОбработки = "",Удаление = Ложь)
	
	ДокументОбъект = РеквизитФормыВЗначение("ЭлектронныйДокумент",Тип("ДокументОбъект.ЭлектронныйДокументВходящий"));
	
	СтрокаОснования = ДокументОбъект.ДокументыОснования.Найти(СсылкаНаДокумент,"ДокументОснование");
	
	Если Удаление И СтрокаОснования <> Неопределено  Тогда
		ДокументОбъект.ДокументыОснования.Удалить(СтрокаОснования);
	КонецЕсли;
	
	Если НЕ Удаление И СтрокаОснования = Неопределено Тогда
		НоваяСтрока = ДокументОбъект.ДокументыОснования.Добавить();
		НоваяСтрока.ДокументОснование = СсылкаНаДокумент;
		НоваяСтрока.СпособОбработки = СпособОбработки;
	КонецЕсли;	
	
	ДокументОбъект.Записать();
	
	ЗначениеВРеквизитФормы(ДокументОбъект,"ЭлектронныйДокумент");
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлектронныйДокументДокументыОснованияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекСтрока = Элементы.ЭлектронныйДокументДокументыОснования.ТекущиеДанные;
	
	Если ТекСтрока <> Неопределено Тогда
		ПоказатьЗначение(,ТекСтрока.ДокументОснование);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьТекущийПродолжить(Результат, СтруктураПараметров) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ОбменСКонтрагентамиКлиент.ПерезаполнитьДокумент(СтруктураПараметров.ДокументОснование, , , ЭлектронныйДокумент.Ссылка, СтруктураПараметров.СпособОбработки);

		ОповеститьВладельца();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


