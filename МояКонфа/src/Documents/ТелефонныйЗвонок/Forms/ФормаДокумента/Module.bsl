
#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстВыбора;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Взаимодействия.УстановитьПредметПоДаннымЗаполнения(Параметры, Предмет);
	КонецЕсли;
	Взаимодействия.ЗаполнитьСписокВыбораДляРассмотретьПосле(Элементы.РассмотретьПосле.СписокВыбора);
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Входящий = НЕ (Параметры.Свойство("Основание")
		И НЕ (Параметры.Основание = Ложь ИЛИ Параметры.Основание = Неопределено));
	КонецЕсли;
	
	// Определим типы контактов, которые можно создать.
	СписокИнтерактивноСоздаваемыхКонтактов = Взаимодействия.СоздатьСписокЗначенийИнтерактивноСоздаваемыхКонтактов();
	Элементы.СоздатьКонтакт.Видимость      = СписокИнтерактивноСоздаваемыхКонтактов.Количество() > 0;

	// Подготовить оповещения взаимодействий.
	Взаимодействия.ПодготовитьОповещения(ЭтотОбъект,Параметры);
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "СтраницаДополнительныеРеквизиты");
		ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Если Параметры.Свойство("ДанныеУчастника") И Объект.АбонентКонтакт <> Параметры.ДанныеУчастника.Контакт Тогда
		ЗаполнитьНаОснованииУчастника(Параметры.ДанныеУчастника);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	
	ПриСозданииИПриЧтенииНаСервере();
	
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтотОбъект, "ТелефонныйЗвонок");

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	ПриСозданииИПриЧтенииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	ПроверитьДоступностьСозданияКонтакта();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, РежимЗаписи, РежимПроведения)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Взаимодействия.ПередЗаписьюВзаимодействияИзФормы(ЭтотОбъект, ТекущийОбъект, ИзменилисьКонтакты);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Взаимодействия.ПриЗаписиВзаимодействияИзФормы(ТекущийОбъект, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	ВзаимодействияКлиент.ВзаимодействиеПредметПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи, "ТелефонныйЗвонок");
	ПроверитьДоступностьСозданияКонтакта();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		Если МодульУправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
			ОбновитьЭлементыДополнительныхРеквизитов();
			МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	ВзаимодействияКлиент.ОтработатьОповещение(ЭтотОбъект,ИмяСобытия, Параметр, Источник);
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект, ЭтотОбъект, "ТелефонныйЗвонок");
	ПроверитьДоступностьСозданияКонтакта();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ВзаимодействияКлиент.ФормаОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора, КонтекстВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницыОписаниеДополнительноПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства")
		И ТекущаяСтраница.Имя = "СтраницаДополнительныеРеквизиты"
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ТолькоEmail",                       Ложь);
	ПараметрыОткрытия.Вставить("ТолькоТелефон",                     Истина);
	ПараметрыОткрытия.Вставить("ЗаменятьПустыеАдресИПредставление", Истина);
	ПараметрыОткрытия.Вставить("ДляФормыУточненияКонтактов",        Ложь);
	ПараметрыОткрытия.Вставить("ИдентификаторФормы",                УникальныйИдентификатор);
	
	ВзаимодействияКлиент.ВыбратьКонтакт(Предмет, Объект.АбонентКакСвязаться,
	         Объект.АбонентПредставление, Объект.АбонентКонтакт, ПараметрыОткрытия);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеКонтактаПриИзменении(Элемент)
	
	ПроверитьДоступностьСозданияКонтакта();
	ИзменилисьКонтакты = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактПриИзменении(Элемент)
	
	ВзаимодействияВызовСервера.ПредставлениеИВсяКонтактнаяИнформациюКонтакта(Объект.АбонентКонтакт,
	                                                                         Объект.АбонентПредставление,
	                                                                         Объект.АбонентКакСвязаться);
	ПроверитьДоступностьСозданияКонтакта();
	ВзаимодействияКлиентСервер.ПроверитьЗаполнениеКонтактов(Объект,ЭтотОбъект,"ТелефонныйЗвонок");
	ИзменилисьКонтакты = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РассмотретьПослеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВзаимодействияКлиент.ОбработатьВыборВПолеРассмотретьПосле(РассмотретьПосле, 
		ВыбранноеЗначение, СтандартнаяОбработка, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура РассмотреноПриИзменении(Элемент)
	
	Элементы.РассмотретьПосле.Доступность = НЕ Рассмотрено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВзаимодействияКлиент.ПредметНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьКонтактВыполнить()

	ВзаимодействияКлиент.СоздатьКонтакт(
		Объект.АбонентПредставление, Объект.АбонентКакСвязаться, Объект.Ссылка, СписокИнтерактивноСоздаваемыхКонтактов);

КонецПроцедуры

&НаКлиенте
Процедура СвязанныеВзаимодействияВыполнить()

	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Предмет", Объект.Предмет);

	ОткрытьФорму("ЖурналДокументов.Взаимодействия.ФормаСписка", ПараметрыОтбора, ЭтотОбъект, , Окно);

КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьНаОснованииУчастника(ДанныеУчастника)
	
	Объект.АбонентКонтакт = ДанныеУчастника.Контакт;
	Если ПустаяСтрока(ДанныеУчастника.КакСвязаться) Тогда
		
		Объект.АбонентКакСвязаться = "";
		Взаимодействия.ДозаполнитьПоляКонтактов(Объект.АбонентКонтакт,
			Объект.АбонентПредставление,
			Объект.АбонентКакСвязаться,
			Перечисления.ТипыКонтактнойИнформации.Телефон);
		
	Иначе
		
		Объект.АбонентКакСвязаться = ДанныеУчастника.КакСвязаться;
		
	КонецЕсли;
	
	Объект.АбонентПредставление = ДанныеУчастника.Представление;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииИПриЧтенииНаСервере()
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Взаимодействия.УстановитьРеквизитыФормыВзаимодействияПоДаннымРегистра(ЭтотОбъект);
	Иначе
		ИзменилисьКонтакты = Истина;
	КонецЕсли;
	Элементы.РассмотретьПосле.Доступность = НЕ Рассмотрено;
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ПроверитьДоступностьСозданияКонтакта()
	
	Элементы.СоздатьКонтакт.Доступность = (НЕ Объект.Ссылка.Пустая()) 
	                                      И (Не ЗначениеЗаполнено(Объект.АбонентКонтакт)) 
	                                      И (Не ПустаяСтрока(Объект.АбонентПредставление));
	
КонецПроцедуры

#КонецОбласти
