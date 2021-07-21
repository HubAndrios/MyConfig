
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ИдентификаторКатегории", ИдентификаторКатегории);
	Параметры.Свойство("ИдентификаторРеквизитаКатегории", ИдентификаторРеквизита);
	Параметры.Свойство("ВидНоменклатуры", ВидНоменклатуры);
	Параметры.Свойство("РеквизитОбъекта", РеквизитОбъекта);
	Параметры.Свойство("ТипЗначения", ТипЗначения);
	
	ЗагрузитьЗначенияРеквизитаРубрикатора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьЗакрыть(Команда)
	
	СохранитьИзменения();
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	СохранитьИзменения();
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	Для Каждого ЭлементСписка Из Список Цикл
		ЭлементСписка.ПредставлениеЗначенияРеквизитаКатегории = Неопределено;
		ЭлементСписка.ЗначениеНеактуально = Ложь;
		ЭлементСписка.Автоподстановка = Ложь;
	КонецЦикла;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗначенияРеквизита(Команда)
	
	МассивЗначений = Новый Массив;
	Для Каждого СтрокаСписка Из Список Цикл
		Если ЗначениеЗаполнено(СтрокаСписка.ПредставлениеЗначенияРеквизитаКатегории)
			И Не СтрокаСписка.ЗначениеНеактуально Тогда
			Продолжить;
		КонецЕсли;
		МассивЗначений.Добавить(СтрокаСписка.Значение);
	КонецЦикла;
	
	Если МассивЗначений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	// Получение сопоставления значений свойств.
	Значения = ПолучитьЗначенияРеквизитаСервиса(МассивЗначений, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Индекс = -1;
	Для Каждого ЭлементМассива Из МассивЗначений Цикл
		Индекс = Индекс + 1;
		Если Значения[Индекс] = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		СтрокиПоиска = Список.НайтиСтроки(Новый Структура("Значение", ЭлементМассива));
		СтрокиПоиска[0].ИдентификаторЗначенияРеквизитаКатегории = Формат(Значения[Индекс].id, "ЧГ=");
		СтрокиПоиска[0].ПредставлениеЗначенияРеквизитаКатегории = Значения[Индекс].value;
		СтрокиПоиска[0].Автоподстановка = Истина;
		СтрокиПоиска[0].ЗначениеНеактуально = Ложь;
		Модифицированность = Истина;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗагрузитьЗначенияРеквизитаРубрикатора()
	
	Результат = Неопределено;
	Отказ = Ложь;
	
	ОбновитьСписокЗначенийРеквизита();

	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("ИдентификаторКатегории", ИдентификаторКатегории);
	ПараметрыКоманды.Вставить("ИдентификаторХарактеристики", ИдентификаторРеквизита);
	
	ТорговыеПредложения.ВыполнитьКомандуРубрикатора("ПолучитьЗначенияХарактеристики", ПараметрыКоманды, Результат, Отказ);
	Если Отказ ИЛИ Результат.КодСостояния <> 200 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ЗначенияРубрикатора Из Результат.Данные Цикл
		СписокЗначенийСервиса.Добавить(ЗначенияРубрикатора.value, Формат(ЗначенияРубрикатора.id, "ЧГ="));
		Элементы.ПредставлениеЗначенияРеквизитаКатегории.СписокВыбора.Добавить(ЗначенияРубрикатора.value);
	КонецЦикла;
	Элементы.ПредставлениеЗначенияРеквизитаКатегории.СписокВыбора.СортироватьПоЗначению();
	
	Для Каждого СтрокаСписка Из Список Цикл
		Если ЗначениеЗаполнено(СтрокаСписка.ПредставлениеЗначенияРеквизитаКатегории) Тогда
			// Проверка актуальности данных.
			ЗначениеРубрикатора = СписокЗначенийСервиса.НайтиПоЗначению(СтрокаСписка.ПредставлениеЗначенияРеквизитаКатегории);
			Если ЗначениеРубрикатора = Неопределено Тогда
				СтрокаСписка.ЗначениеНеактуально = Истина;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗначенийРеквизита()
	
	ТаблицаЗначений = ТорговыеПредложенияПереопределяемый.СопоставленныеЗначенияРеквизитаВидаНоменклатуры(ВидНоменклатуры,
		РеквизитОбъекта, ТипЗначения);
		
	Список.Загрузить(ТаблицаЗначений);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьИзменения()
	
	НаборЗаписей = РегистрыСведений.СоответствиеЗначенийРеквизитов1СБизнесСеть.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ВидНоменклатуры.Значение = ВидНоменклатуры;
	НаборЗаписей.Отбор.ВидНоменклатуры.Использование = Истина;
	НаборЗаписей.Отбор.РеквизитОбъекта.Значение = РеквизитОбъекта;
	НаборЗаписей.Отбор.РеквизитОбъекта.Использование = Истина;
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	
	Для Каждого СтрокаСписка Из Список Цикл
		Если ЗначениеЗаполнено(СтрокаСписка.ПредставлениеЗначенияРеквизитаКатегории) Тогда
			Запись = НаборЗаписей.Добавить();
			Запись.ВидНоменклатуры = ВидНоменклатуры;
			Запись.РеквизитОбъекта = РеквизитОбъекта;
			Запись.Значение = СтрокаСписка.Значение;
			Запись.Автоподстановка = СтрокаСписка.Автоподстановка;
			
			ЗначениеСервиса = СписокЗначенийСервиса.НайтиПоЗначению(СтрокаСписка.ПредставлениеЗначенияРеквизитаКатегории);
			Если ЗначениеСервиса = Неопределено Тогда
				Запись.ИдентификаторЗначенияРеквизитаКатегории = СтрокаСписка.ИдентификаторЗначенияРеквизитаКатегории;
				Запись.ПредставлениеЗначенияРеквизитаКатегории = СтрокаСписка.ПредставлениеЗначенияРеквизитаКатегории;
			Иначе
				Запись.ИдентификаторЗначенияРеквизитаКатегории = ЗначениеСервиса.Представление;
				Запись.ПредставлениеЗначенияРеквизитаКатегории = ЗначениеСервиса.Значение;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЗначенияРеквизитаСервиса(МассивЗначений, Отказ)
	
	// Формирование пакета для запроса.
	AttributeValueSearch = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://1cbn.ru/offers/XMLSchema", "AttributeValueSearch"));
	
	Для Каждого ЗначениеДляСопоставления Из МассивЗначений Цикл 
		AttributeValue = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://1cbn.ru/offers/XMLSchema", "AttributeValue"));
		AttributeValue.categoryId = ИдентификаторКатегории;
		AttributeValue.attributeId = ИдентификаторРеквизита;
		AttributeValue.value = Строка(ЗначениеДляСопоставления);
		AttributeValueSearch.AttributeValues.Добавить(AttributeValue);
	КонецЦикла;
	
	Результат = Неопределено;
	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("ЗначенияДляСопоставления", ТорговыеПредложения.ОбъектXDTOВСтрокуJSON(AttributeValueSearch, -1));
	ТорговыеПредложения.ВыполнитьКомандуРубрикатора("СопоставитьЗначенияРеквизитов", ПараметрыКоманды, Результат, Отказ);
	
	Возврат Результат.Данные;
	
КонецФункции

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	СохранитьИзменения();
	Модифицированность = Ложь; // не выводить подтверждение о закрытии формы еще раз.
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеЗначенияРеквизитаКатегорииПриИзменении(Элемент)
	
	Если Элементы.Список.ТекущиеДанные.ЗначениеНеактуально Тогда
		Элементы.Список.ТекущиеДанные.ЗначениеНеактуально = Ложь;
	КонецЕсли;
	Элементы.Список.ТекущиеДанные.Автоподстановка = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Установка условного оформления для неактуального значения рубрикатора.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПредставлениеЗначенияРеквизитаКатегории.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЗначениеНеактуально");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	// Надпись <Выберите значение>.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Выберите значение>'"));
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПредставлениеЗначенияРеквизитаКатегории.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ПредставлениеЗначенияРеквизитаКатегории");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "Значение" Тогда
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			СтандартнаяОбработка = Ложь;
			ПоказатьЗначение(, ТекущиеДанные.Значение)
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
