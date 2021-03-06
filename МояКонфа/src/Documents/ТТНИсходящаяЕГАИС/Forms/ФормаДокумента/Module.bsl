
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииПриЧтенииНаСервере();
	КонецЕсли;
	
	ВалютаДокумента = ИнтеграцияЕГАИСПереопределяемый.ПредставлениеВалютыРегламентированногоУчета();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Прочитать();
		ОбновитьСтатусЕГАИС();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусЕГАИСВФормахДокументов)) Тогда
		
		Прочитать();
		ОбновитьСтатусЕГАИС();
		
		СформироватьТекстДокументаЕГАИС();
		
	КонецЕсли;
	
	// Обновление гиперссылки на создание документа Возврат из регистра №2
	Если ИмяСобытия = "Запись_ВозвратИзРегистра2ЕГАИС"
		И Параметр.Основание = Объект.Ссылка Тогда
		
		СформироватьТекстДокументаЕГАИС();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И Параметр.Основание = Объект.Ссылка Тогда
		
		СформироватьТекстДокументаЕГАИС();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииПриЧтенииНаСервере();
	
	СобытияФормЕГАИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	ОбновитьСтатусЕГАИС();
	
	СформироватьТекстДокументаЕГАИС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("Основание", Объект.ДокументОснование);
	Оповестить("Запись_ТТНИсходящаяЕГАИС", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ТТНИсходящаяЕГАИС.Форма.ФормаДокумента.Записать");
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСправки2(Команда)
	
	ВыполнитьКомандуПодобратьСправки2();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ТТНИсходящаяЕГАИС.Форма.ФормаДокумента.Провести");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ТТНИсходящаяЕГАИС.Форма.ФормаДокумента.ПровестиИЗакрыть");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ГрузоотправительПриИзменении(Элемент)
	
	ГрузоотправительПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСправка2ПокупателяПриИзменении(Элемент)
	
	СформироватьТекстДокументаЕГАИС();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбработкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОчиститьСообщения();
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Товарно-транспортная накладная ЕГАИС (исходящая) была изменена. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Товарно-транспортная накладная ЕГАИС (исходящая) не проведена. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстДокументаЕГАИСОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСКлиент.ТекстДокументаЕГАИСОбработкаНавигационнойСсылки(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТовары

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	РассчитатьСуммуВСтроке();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	РассчитатьСуммуВСтроке();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущаяСтрока.Количество <> 0 Тогда
		ТекущаяСтрока.Цена = ТекущаяСтрока.Сумма / ТекущаяСтрока.Количество;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Количество факт
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыКоличествоФакт.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.КоличествоФакт");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<данные не переданы>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГИСМ);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииПриЧтенииНаСервере()
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	ОбновитьСтатусЕГАИС();
	
	СформироватьТекстДокументаЕГАИС();
	
	ДоступностьЭлементовФормы();
	
КонецПроцедуры

#Область Статус

&НаСервере
Процедура ОбновитьСтатусЕГАИС()

	ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется;
	ЦветТекста         = Неопределено;
	
	Если Объект.СтатусОбработки = Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.Новый
		Или Объект.СтатусОбработки = Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиВЕГАИС Тогда 
		
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные;
		
	ИначеЕсли Объект.СтатусОбработки = Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПринятАктРасхождений
		Или Объект.СтатусОбработки = Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиПодтвержденияАктаРасхождений
		Или Объект.СтатусОбработки = Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиОтказаОтАктаРасхождений Тогда
		
		ДальнейшееДействие = Новый Массив;
		ДальнейшееДействие.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПодтвердитеАктОРасхождениях);
		ДальнейшееДействие.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОткажитесьОтАктаОРасхождениях);
		
	ИначеЕсли Объект.СтатусОбработки = Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПринятЗапросНаОтменуПроведения Тогда
		
		ДальнейшееДействие = Новый Массив;
		ДальнейшееДействие.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПодтвердитеЗапросНаОтменуПроведения);
		ДальнейшееДействие.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОткажитесьОтЗапросаНаОтменуПроведения);
		
	КонецЕсли;
	
	Если Объект.СтатусОбработки = Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиВЕГАИС 
		Или Объект.СтатусОбработки = Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиПодтвержденияАктаРасхождений
		Или Объект.СтатусОбработки = Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиОтказаОтАктаРасхождений Тогда 
		
		ЦветТекста = ЦветаСтиля.ЕГАИССтатусОбработкиОшибкаПередачи;
		
	КонецЕсли;
	
	ТекстПредставление = Новый ФорматированнаяСтрока(Строка(Объект.СтатусОбработки),,ЦветТекста);
	
	СтатусЕГАИСПредставление = ИнтеграцияЕГАИС.ПредставлениеСтатусаЕГАИС(ТекстПредставление, ДальнейшееДействие);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		
		ПередатьДанные(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ТТН"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПодтвердитьАктОРасхождениях" Тогда
		
		ПередатьДанные(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ПодтверждениеАктаРасхожденийТТН"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтказатьсяОтАктаОРасхождениях" Тогда
		
		ПередатьДанные(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ОтказОтАктаРасхожденийТТН"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПодтвердитьЗапросНаОтменуПроведения" Тогда
		
		ПередатьДанные(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ПодтверждениеЗапросаНаОтменуПроведенияТТН"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтказатьсяОтЗапросаНаОтменуПроведения" Тогда
		
		ПередатьДанные(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ОтказОтЗапросаНаОтменуПроведенияТТН"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	КонецЕсли;
	
	Если Не Модифицированность И Объект.Проведен Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанные(ВидДокумента)
	
	ПараметрыЗапроса = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(ВидДокумента);
	ПараметрыЗапроса.ДокументСсылка = Объект.Ссылка;
	
	ИнтеграцияЕГАИСКлиент.НачатьФормированиеИсходящегоЗапроса(
		Новый ОписаниеОповещения("ПослеПередачиДанныхЕГАИС", ИнтеграцияЕГАИСКлиент),
		ВидДокумента,
		ПараметрыЗапроса);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура ДоступностьЭлементовФормы()
	
	РедактируемыеСтатусы = Новый Массив;
	РедактируемыеСтатусы.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.Новый);
	РедактируемыеСтатусы.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиВЕГАИС);
	
	РедактированиеФормыНеДоступно                   = РедактируемыеСтатусы.Найти(Объект.СтатусОбработки) = Неопределено;
	Элементы.ГруппаЛевоПравоОсновное.ТолькоПросмотр = РедактированиеФормыНеДоступно;
	Элементы.ГруппаТовары.ТолькоПросмотр            = РедактированиеФормыНеДоступно;
	Элементы.ГруппаДоставка.ТолькоПросмотр          = РедактированиеФормыНеДоступно;
	Элементы.ТоварыПодобратьСправки2.Доступность    = НЕ РедактированиеФормыНеДоступно;
	
КонецПроцедуры

#КонецОбласти

#Область ПодборСправок2

// Подобрать справки 2 в табличной части Товары.
// 
// Возвращаемое значение:
//  Булево - Истина, если требуется задать пользователю вопрос о вводе на основании документа на возврат из регистра №2.
//
&НаСервере
Функция ПодобратьСправки2НаСервере()
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("СправкиЗаполнены", Ложь);
	ВозвращаемоеЗначение.Вставить("ЗадатьВопросОВводеНаОсновании", Ложь);
	
	СправкиЗаполнены = Документы.ТТНИсходящаяЕГАИС.ПодобратьСправки2(Объект);
	
	СформироватьТекстДокументаЕГАИС();
	
	Если СправкиЗаполнены Тогда
		
		ВозвращаемоеЗначение.СправкиЗаполнены              = СправкиЗаполнены;
		ВозвращаемоеЗначение.ЗадатьВопросОВводеНаОсновании = Ложь;
		
		Возврат ВозвращаемоеЗначение;
		
	Иначе
		
		СтруктураПересчетаСуммы = ИнтеграцияЕГАИСКлиентСервер.СтруктураПересчетаСуммы("КоличествоУпаковок");
		
		ПараметрыОтбора = Новый Структура("Справка2", Справочники.Справки2ЕГАИС.ПустаяСсылка());
		ТоварыБезСерий = Объект.Товары.Выгрузить(ПараметрыОтбора);
		УдалосьЗаполнитьСправки = ИнтеграцияЕГАИС.ПодобратьСправки2ДляВозвратаИзРегистра2(
			ТоварыБезСерий,
			Объект.Грузоотправитель,
			Неопределено,
			СтруктураПересчетаСуммы);
		
		ЗадатьВопросОВводеНаОсновании = УдалосьЗаполнитьСправки
		                              И ИнтеграцияЕГАИСПереопределяемый.ИспользоватьРегистр2(Объект.Грузоотправитель);
		
		ВозвращаемоеЗначение.СправкиЗаполнены              = СправкиЗаполнены;
		ВозвращаемоеЗначение.ЗадатьВопросОВводеНаОсновании = ЗадатьВопросОВводеНаОсновании;
		
		Возврат ВозвращаемоеЗначение;
		
	КонецЕсли;
	
КонецФункции

// Обработчик оповещения при закрытии формы ПредложениеНаВозвратИзРегистра2.
//
// Параметры:
//  Результат - Структура - Параметры, переданные из формы ПредложениеНаВозвратИзРегистра2.
//  ДополнительныеПараметры - Неопределено - Дополнительные параметры.
//
&НаКлиенте
Процедура ПриЗакрытииФормыПредложениеНаВозвратИзРегистра2(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
		
		ВыполнитьКомандуПодобратьСправки2();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКомандуПодобратьСправки2()
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(Объект.Грузоотправитель) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не заполнено поле ""Грузоотправитель""'"),
			Объект.Ссылка, "Объект.Грузоотправитель");
		Возврат;
	КонецЕсли;
	
	РезультатЗаполнения = ПодобратьСправки2НаСервере();
	
	ИнтеграцияЕГАИСКлиент.СообщитьОЗавершенииЗаполненияСправок(РезультатЗаполнения.СправкиЗаполнены);
	
	Если РезультатЗаполнения.ЗадатьВопросОВводеНаОсновании Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗакрытииФормыПредложениеНаВозвратИзРегистра2", ЭтотОбъект);
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ДокументОснование", Объект.Ссылка);
		
		ОткрытьФорму(
			"Документ.ТТНИсходящаяЕГАИС.Форма.ПредложениеНаВозвратИзРегистра2",
			ПараметрыОткрытия,
			ЭтотОбъект,,,,
			ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура СформироватьТекстДокументаЕГАИС()
	
	ТекстДокументаЕГАИС = "";
	
	ИспользоватьРегистр2 = ИнтеграцияЕГАИСПереопределяемый.ИспользоватьРегистр2(Объект.Грузоотправитель);
	
	ПараметрыОтбора = Новый Структура("Справка2", Справочники.Справки2ЕГАИС.ПустаяСсылка());
	НайденныеСтроки = Объект.Товары.НайтиСтроки(ПараметрыОтбора);
	
	Если Не (ИспользоватьРегистр2 И НайденныеСтроки.Количество() > 0) Тогда
		Возврат;
	КонецЕсли;
	
	ДокументыПоОснованию = ИнтеграцияЕГАИСВызовСервера.ДокументыПоОснованию(Объект.Ссылка);
	Данные = ИнтеграцияЕГАИС.ДанныеДокументаЕГАИС(Метаданные.Документы.ВозвратИзРегистра2ЕГАИС, ДокументыПоОснованию);
	
	ФорматированныеСтроки = Новый Массив;
	ФорматированныеСтроки.Добавить(Данные.Представление);
	
	ТекстДокументаЕГАИС = Новый ФорматированнаяСтрока(ФорматированныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуВСтроке()
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока.Сумма = ТекущаяСтрока.Цена * ТекущаяСтрока.Количество;
	
КонецПроцедуры

&НаСервере
Процедура ГрузоотправительПриИзмененииНаСервере()
	
	СформироватьТекстДокументаЕГАИС();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

