
#Если ВебКлиент Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Начинает установку компоненты HTTP-запросов.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, которая будет вызвана после установки компоненты.
//
Процедура НачатьУстановкуКомпонентыHTTPЗапросов(ОповещениеПриЗавершении = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	НачатьУстановкуВнешнейКомпоненты(
		Новый ОписаниеОповещения("УстановкаКомпонентыHTTPЗапросов_Завершение", ЭтотОбъект, ДополнительныеПараметры),
		"ОбщийМакет.КомпонентаHTTPЗапросов");
	
КонецПроцедуры

// Начинает формирование HTTP-запроса в УТМ на веб-клиенте.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, которая будет вызвана после формирования запроса,
//  ТранспортныйМодуль - Структура - модуль, в который требуется отправить запрос,
//  ДанныеЗапроса - Структура - структура данных запроса,
//  ОтображатьСообщения - Булево - если Истина, то пользователю будут отображены сообщения с ошибками,
//  УстанавливатьКомпоненту - Булево - признак установки компоненты HTTP-запросов.
//
Процедура НачатьФормированиеHTTPЗапроса(ОповещениеПриЗавершении, ТранспортныйМодуль, ДанныеЗапроса, ОтображатьСообщения,
	УстанавливатьКомпоненту = Истина) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	Контекст.Вставить("ТранспортныйМодуль"     , ТранспортныйМодуль);
	Контекст.Вставить("ОтображатьСообщения"    , ОтображатьСообщения);
	Контекст.Вставить("ДанныеЗапроса"          , ДанныеЗапроса);
	Контекст.Вставить("УстанавливатьКомпоненту", УстанавливатьКомпоненту);
	
	НачатьПодключениеВнешнейКомпоненты(
		Новый ОписаниеОповещения("ФормированиеHTTPЗапроса_ПослеПодключенияКомпоненты", ЭтотОбъект, Контекст),
		"ОбщийМакет.КомпонентаHTTPЗапросов",
		"HTTPЗапросыNative",
		ТипВнешнейКомпоненты.Native);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Завершает установку компоненты HTTP-запросов.
//
Процедура УстановкаКомпонентыHTTPЗапросов_Завершение(ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после подключения компоненты перед формированием HTTP-запроса.
//
Процедура ФормированиеHTTPЗапроса_ПослеПодключенияКомпоненты(Подключено, Контекст) Экспорт
	
	Если Подключено Тогда
		
		Попытка
			ОбъектКомпоненты = Новый("AddIn.HTTPЗапросыNative.HTTPRequester");
		Исключение
			ТекстОшибки = НСтр("ru = 'Ошибка инициализации компоненты HTTP-запросов.'") + Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ИнтеграцияЕГАИСКлиент.ЗавершитьОперациюСОшибкой(Контекст.ОповещениеПриЗавершении, Контекст.ОтображатьСообщения, ТекстОшибки);
			Возврат;
		КонецПопытки;
		
		НастройкаПроксиСервера = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().НастройкиПроксиСервера;
		
		Контекст.Вставить("ОбъектКомпоненты", ОбъектКомпоненты);
		
		Если НЕ НастройкаПроксиСервера = Неопределено И НЕ ПустаяСтрока(НастройкаПроксиСервера.Сервер) Тогда
			ОбъектКомпоненты.НачатьВызовУстановитьПараметрыПрокси(
				Новый ОписаниеОповещения("ФормированиеHTTPЗапроса_ПослеУстановкиПараметровПрокси", ЭтотОбъект, Контекст),
				"HTTP",
				НастройкаПроксиСервера.Сервер,
				НастройкаПроксиСервера.Порт,
				НастройкаПроксиСервера.Пользователь,
				НастройкаПроксиСервера.Пароль);
		Иначе
			ФормированиеHTTPЗапроса_ПослеУстановкиПараметровПрокси(Истина, Неопределено, Контекст);
		КонецЕсли;
		
	ИначеЕсли Контекст.УстанавливатьКомпоненту Тогда
		
		ТекстВопроса = НСтр("ru = 'Для поддержки интеграции с ЕГАИС необходима установка компоненты HTTP-запросов.
		|Перейти к установке данной компоненты?'");
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ФормированиеHTTPЗапроса_ПередУстановкойКомпоненты", ЭтотОбъект, Контекст),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
	Иначе
		ИнтеграцияЕГАИСКлиент.ЗавершитьОперациюСОшибкой(Контекст.ОповещениеПриЗавершении, Контекст.ОтображатьСообщения, НСтр("ru = 'Операция невозможна. Требуется установка компоненты для HTTP-запросов.'"));
	КонецЕсли;
	
КонецПроцедуры

// Начинает установку компоненты HTTP-запросов в случае положительного ответа.
//
Процедура ФормированиеHTTPЗапроса_ПередУстановкойКомпоненты(РезультатВопроса, Контекст) Экспорт
	
	Если НЕ РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ИнтеграцияЕГАИСКлиент.ЗавершитьОперациюСОшибкой(Контекст.ОповещениеПриЗавершении, Контекст.ОтображатьСообщения, НСтр("ru = 'Не установлена компонента HTTP-запросов.'"));
	Иначе
		НачатьУстановкуКомпонентыHTTPЗапросов(Новый ОписаниеОповещения("ФормированиеHTTPЗапроса_ПослеУстановкиКомпоненты", ЭтотОбъект, Контекст));
	КонецЕсли;
	
КонецПроцедуры

// Подключает компоненту HTTP-запросов после установки.
//
Процедура ФормированиеHTTPЗапроса_ПослеУстановкиКомпоненты(Результат, Контекст) Экспорт
	
	Контекст.Вставить("УстанавливатьКомпоненту", Ложь);
	
	НачатьПодключениеВнешнейКомпоненты(
		Новый ОписаниеОповещения("ФормированиеHTTPЗапроса_ПослеПодключенияКомпоненты", ЭтотОбъект, Контекст),
		"ОбщийМакет.КомпонентаHTTPЗапросов",
		"HTTPЗапросыNative",
		ТипВнешнейКомпоненты.Native);
	
КонецПроцедуры

// Начинает добавление заголовков HTTP-запроса.
//
Процедура ФормированиеHTTPЗапроса_ПослеУстановкиПараметровПрокси(РезультатВыполнения, Параметры, Контекст) Экспорт
	
	Если НЕ РезультатВыполнения Тогда
		ИнтеграцияЕГАИСКлиент.ЗавершитьОперациюСОшибкой(Контекст.ОповещениеПриЗавершении, Контекст.ОтображатьСообщения, НСтр("ru = 'Ошибка установки настроек прокси-сервера.'"));
		Возврат;
	КонецЕсли;
	
	ОбъектКомпоненты = Контекст.ОбъектКомпоненты;
	
	Если Контекст.ДанныеЗапроса.Заголовки.Количество() > 0 Тогда
		Контекст.Вставить("ТекущийИндекс", 0);
		
		ТекущийЗаголовок = Неопределено;
		Индекс = 0;
		Для Каждого Заголовок Из Контекст.ДанныеЗапроса.Заголовки Цикл
			Если Индекс = Контекст.ТекущийИндекс Тогда
				ТекущийЗаголовок = Заголовок;
				Прервать;
			КонецЕсли;
			
			Индекс = Индекс + 1;
		КонецЦикла;
		
		ОбъектКомпоненты.НачатьВызовAddHeader(
			Новый ОписаниеОповещения("ФормированиеHTTPЗапроса_ПослеДобавленияЗаголовка", ЭтотОбъект, Контекст),
			"" + ТекущийЗаголовок.Ключ + ": " + ТекущийЗаголовок.Значение);
	Иначе
		ФормированиеHTTPЗапроса_ПослеДобавленияЗаголовков(Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Добавляет очередной заголовок HTTP-запроса.
//
Процедура ФормированиеHTTPЗапроса_ПослеДобавленияЗаголовка(РезультатВыполнения, Параметры, Контекст) Экспорт
	
	Если НЕ РезультатВыполнения Тогда
		ИнтеграцияЕГАИСКлиент.ЗавершитьОперациюСОшибкой(Контекст.ОповещениеПриЗавершении, Контекст.ОтображатьСообщения, НСтр("ru = 'Ошибка добавления заголовка запроса.'"));
		Возврат;
	КонецЕсли;
	
	ОбъектКомпоненты = Контекст.ОбъектКомпоненты;
	
	Если Контекст.ТекущийИндекс = Контекст.ДанныеЗапроса.Заголовки.Количество() - 1 Тогда
		ФормированиеHTTPЗапроса_ПослеДобавленияЗаголовков(Контекст);
	Иначе
		Контекст.ТекущийИндекс = Контекст.ТекущийИндекс + 1;
		
		ТекущийЗаголовок = Неопределено;
		Индекс = 0;
		Для Каждого Заголовок Из Контекст.ДанныеЗапроса.Заголовки Цикл
			Если Индекс = Контекст.ТекущийИндекс Тогда
				ТекущийЗаголовок = Заголовок;
				Прервать;
			КонецЕсли;
			
			Индекс = Индекс + 1;
		КонецЦикла;
		
		ОбъектКомпоненты.НачатьВызовAddHeader(
			Новый ОписаниеОповещения("ФормированиеHTTPЗапроса_ПослеДобавленияЗаголовка", ЭтотОбъект, Контекст),
			"" + ТекущийЗаголовок.Ключ + ": " + ТекущийЗаголовок.Значение);
	КонецЕсли;
	
КонецПроцедуры

// Начинает отправку HTTP-запроса через внешнюю компоненту.
//
Процедура ФормированиеHTTPЗапроса_ПослеДобавленияЗаголовков(Контекст)
	
	ОбъектКомпоненты = Контекст.ОбъектКомпоненты;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ФормированиеHTTPЗапроса_Завершение", ЭтотОбъект, Контекст);
	
	АдресЗапроса = "http://" + Контекст.ТранспортныйМодуль.АдресУТМ + ":" + Формат(Контекст.ТранспортныйМодуль.ПортУТМ, "ЧГ=0");
	АдресЗапроса = АдресЗапроса + ?(Лев(Контекст.ДанныеЗапроса.АдресЗапроса, 1) = "/", "", "/");
	АдресЗапроса = АдресЗапроса + Контекст.ДанныеЗапроса.АдресЗапроса;
	
	Контекст.Вставить("АдресЗапроса", АдресЗапроса);
	
	Если Контекст.ДанныеЗапроса.ТипЗапроса = "GET" Тогда
		ОбъектКомпоненты.НачатьВызовGET(ОповещениеПриЗавершении, АдресЗапроса, "", "");
	ИначеЕсли Контекст.ДанныеЗапроса.ТипЗапроса = "POST" Тогда
		ОбъектКомпоненты.НачатьВызовPOST(ОповещениеПриЗавершении, АдресЗапроса, Контекст.ДанныеЗапроса.ТелоЗапроса, "", "");
	ИначеЕсли Контекст.ДанныеЗапроса.ТипЗапроса = "DELETE" Тогда
		ОбъектКомпоненты.НачатьВызовDELETE(ОповещениеПриЗавершении, АдресЗапроса, "", "");
	Иначе
		ИнтеграцияЕГАИСКлиент.ЗавершитьОперациюСОшибкой(Контекст.ОповещениеПриЗавершении, Контекст.ОтображатьСообщения, НСтр("ru = 'Неверный тип HTTP-запроса.'"));
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает результат выполнения HTTP-запроса.
//
Процедура ФормированиеHTTPЗапроса_Завершение(КодСостояния, Параметры, Контекст) Экспорт
	
	ОтветМодуляЕГАИС = "";
	ТекстОшибки = "";
	
	Если Контекст.ДанныеЗапроса.ТипЗапроса = "GET" Тогда
		ОтветМодуляЕГАИС = Параметры[1];
		ТекстОшибки = Параметры[2];
	ИначеЕсли Контекст.ДанныеЗапроса.ТипЗапроса = "POST" Тогда
		ОтветМодуляЕГАИС = Параметры[2];
		ТекстОшибки = Параметры[3];
	ИначеЕсли Контекст.ДанныеЗапроса.ТипЗапроса = "DELETE" Тогда
		ТекстОшибки = Параметры[1];
	КонецЕсли;
	
	Результат = ИнтеграцияЕГАИСКлиентСервер.РезультатВыполненияHTTPЗапроса();
	Результат.Результат = ТекстОшибки = "Ошибок нет";
	Результат.ОписаниеОшибки = ?(ТекстОшибки = "Ошибок нет", "", ТекстОшибки);
	
	Если Результат.Результат Тогда
		Результат = ИнтеграцияЕГАИСВызовСервера.ПрочитатьОтветМодуляЕГАИС(КодСостояния, ОтветМодуляЕГАИС, Контекст.ДанныеЗапроса.ТипЗапроса = "POST");
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Результат.ОписаниеОшибки) Тогда
		ТекстОшибки = НСтр("ru = 'Ошибка при выполнении %1-запроса по адресу %2'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1", Контекст.ДанныеЗапроса.ТипЗапроса);
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%2", Контекст.АдресЗапроса);
		
		Результат.ОписаниеОшибки = ТекстОшибки + Символы.ПС + Результат.ОписаниеОшибки;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли