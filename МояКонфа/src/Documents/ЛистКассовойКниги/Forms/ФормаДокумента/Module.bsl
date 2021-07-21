
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ИспользоватьНесколькоКасс = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	ЗаполнитьСписокВыбораКассовыхКниг();
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		РассчитатьОстатокПоРегистрам();
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

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
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РассчитатьОстатокПоРегистрам();
	УправлениеЭлементамиФормы();
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Объект.КассовыеОрдера.Очистить();
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
	ЗаполнитьСписокВыбораКассовыхКниг();
	
КонецПроцедуры

&НаКлиенте
Процедура КассоваяКнигаПриИзменении(Элемент)
	
	Объект.КассовыеОрдера.Очистить();
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДокументы

&НаКлиенте
Процедура ДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "Документ" И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Документ) Тогда
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Документ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПриАктивизацииСтроки(Элемент)
	
	УстановитьПредупреждениеПриРедактировании();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПриИзменении(Элемент)
	
	УстановитьПредупреждениеПриРедактировании();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоТест_ЗаполнитьДокументы(Команда) Экспорт

	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Организация");
	СтруктураРеквизитов.Вставить("Дата");
	
	Оповещение = Новый ОписаниеОповещения("АвтоТест_ЗаполнитьДокументыЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.ПроверитьВозможностьЗаполненияТабличнойЧасти(
		Оповещение, 
		ЭтаФорма, 
		Объект.КассовыеОрдера, 
		СтруктураРеквизитов,
		Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоТест_ЗаполнитьДокументыЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	ЗаполнитьДокументы();
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
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
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Надпись в пустом поле Документ для суммы переоценки
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Документ.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.КассовыеОрдера.Документ");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.DarkGray);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Переоценка валютных денежных средств>'"));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораКассовыхКниг()
	
	Справочники.КассовыеКниги.КассовыеКнигиОрганизации(Объект.Организация, Элементы.КассоваяКнига.СписокВыбора);
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьОстатокПоРегистрам()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Кассы.Ссылка КАК Касса
	|ПОМЕСТИТЬ Кассы
	|ИЗ
	|	Справочник.Кассы КАК Кассы
	|ГДЕ
	|	Кассы.Владелец = &Организация
	|	И Кассы.КассоваяКнига = &КассоваяКнига
	|;
	|////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДенежныеСредстваНаличныеОстатки.СуммаРеглОстаток КАК СуммаРеглОстаток
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваНаличные.Остатки(
	|		&КонецДняГраница,
	|		Организация = &Организация
	|		И Касса В (ВЫБРАТЬ Кассы.Касса ИЗ Кассы)) КАК ДенежныеСредстваНаличныеОстатки
	|;
	|////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(
	|		ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|			ДенежныеСредства.СуммаРегл
	|		КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|			-ДенежныеСредства.СуммаРегл
	|		КОНЕЦ
	|	), 0) КАК СуммаИнвентаризации
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваНаличные КАК ДенежныеСредства
	|ГДЕ
	|	ДенежныеСредства.Период МЕЖДУ &НачалоДня И &КонецДня
	|	И Организация = &Организация
	|	И Касса В (ВЫБРАТЬ Кассы.Касса ИЗ Кассы)
	|	И ДенежныеСредства.ХозяйственнаяОперация В
	|		(ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнвентаризацииДенежныхСредств),
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнвентаризацииДенежныхСредств))
	|");
	
	Запрос.УстановитьПараметр("КонецДняГраница", Новый Граница(КонецДня(Объект.Дата), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("НачалоДня", НачалоДня(Объект.Дата));
	Запрос.УстановитьПараметр("КонецДня", КонецДня(Объект.Дата));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("КассоваяКнига", Объект.КассоваяКнига);
	
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаОстаткаНаНачалоДня = Результат[1].Выбрать();
	ВыборкаОстаткаНаНачалоДня.Следующий();
	ВыборкаСуммыИнвентаризации = Результат[2].Выбрать();
	ВыборкаСуммыИнвентаризации.Следующий();
	
	СуммаКонечныйОстатокПоРегистру = ВыборкаОстаткаНаНачалоДня.СуммаРеглОстаток - ВыборкаСуммыИнвентаризации.СуммаИнвентаризации;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Элементы.КассоваяКнига.Видимость = ИспользоватьНесколькоКасс;
	
	Элементы.СуммаКонечныйОстатокПоРегистру.Видимость =
		(Объект.СуммаКонечныйОстаток <> СуммаКонечныйОстатокПоРегистру)
		И Объект.Проведен;
	
	Элементы.КассоваяКнига.КнопкаОткрытия = ЗначениеЗаполнено(Объект.КассоваяКнига);
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументы()
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		УстановитьПривилегированныйРежим(Истина);
		Документы.ПереоценкаВалютныхСредств.ПереоценитьКассыОрганизации(Объект.Организация, Объект.Дата);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Объект.КассовыеОрдера.Очистить();
	
	ТекстЗапроса = 
	"
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДокументКассоваяКнига.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЛистКассовойКниги КАК ДокументКассоваяКнига
	|ГДЕ
	|	ДокументКассоваяКнига.Ссылка <> &ТекущийДокумент
	|	И ДокументКассоваяКнига.Организация = &Организация
	|	И ДокументКассоваяКнига.КассоваяКнига = &КассоваяКнига
	|	И ДокументКассоваяКнига.Проведен
	|	И НачалоПериода(ДокументКассоваяКнига.Дата, ДЕНЬ) = &ДатаНач
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТекущийДокумент", Объект.Ссылка);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("КассоваяКнига", Объект.КассоваяКнига);
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Объект.Дата));
	
	ЗаполнятьДокументы = Истина;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'На дату %1 уже существует документ: %2'"),
			Объект.Дата, Выборка.Ссылка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			, // КлючДанных
			"Объект.Дата");
		ЗаполнятьДокументы = Ложь;
		
	КонецЦикла;
	
	Если ЗаполнятьДокументы Тогда
		
		ТекстЗапроса = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДенежныеСредства.Регистратор КАК Документ,
		|	ВЫБОР
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер ТОГДА
		|			ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.ПриходныйКассовыйОрдер).Номер
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер ТОГДА
		|			ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.РасходныйКассовыйОрдер).Номер
		|	КОНЕЦ КАК НомерДокумента,
		|	ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|		0
		|	КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|		1
		|	КОНЕЦ КАК ЗначениеУпорядочивания,
		|	СУММА(
		|		ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|			ДенежныеСредства.Сумма
		|		ИНАЧЕ
		|			0
		|		КОНЕЦ
		|	) КАК Приход,
		|	СУММА(
		|		ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|			ДенежныеСредства.Сумма
		|		ИНАЧЕ
		|			0
		|		КОНЕЦ
		|	) КАК Расход,
		|	ДенежныеСредства.Касса.ВалютаДенежныхСредств КАК Валюта,
		|	МАКСИМУМ(СтатьиДДС.КорреспондирующийСчет) КАК КорреспондирующийСчет
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваНаличные КАК ДенежныеСредства
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		Документ.ЛистКассовойКниги.КассовыеОрдера КАК ДокументКассоваяКнига
		|	ПО
		|		ДокументКассоваяКнига.Ссылка <> &Ссылка
		|		И ДокументКассоваяКнига.Ссылка.Проведен
		|		И ДокументКассоваяКнига.Ссылка.Организация = &Организация
		|		И ДокументКассоваяКнига.Ссылка.КассоваяКнига = &КассоваяКнига
		|		И ДокументКассоваяКнига.Документ = ДенежныеСредства.Регистратор
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиДДС
		|	ПО
		|		СтатьиДДС.Ссылка = ДенежныеСредства.СтатьяДвиженияДенежныхСредств
		|
		|ГДЕ
		|	ДенежныеСредства.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ДенежныеСредства.Организация = &Организация
		|	И ДенежныеСредства.Касса.КассоваяКнига = &КассоваяКнига
		|	И ДокументКассоваяКнига.Документ ЕСТЬ NULL
		|	И Не ДенежныеСредства.Регистратор ССЫЛКА Документ.ВводОстатков
		|	И Не ДенежныеСредства.ХозяйственнаяОперация В
		|		(ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПереоценкаДенежныхСредств),
		|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы),
		|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу),
		|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнвентаризацииДенежныхСредств),
		|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнвентаризацииДенежныхСредств))
		|	
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|		0
		|	КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|		1
		|	КОНЕЦ,
		|	ДенежныеСредства.Касса.ВалютаДенежныхСредств,
		|	ДенежныеСредства.Регистратор
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДенежныеСредства.Регистратор КАК Документ,
		|	ВЫБОР
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер ТОГДА
		|			ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.ПриходныйКассовыйОрдер).Номер
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер ТОГДА
		|			ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.РасходныйКассовыйОрдер).Номер
		|	КОНЕЦ КАК НомерДокумента,
		|	ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|		0
		|	КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|		1
		|	КОНЕЦ КАК ЗначениеУпорядочивания,
		|	СУММА(
		|		ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|			ДенежныеСредства.Сумма
		|		ИНАЧЕ
		|			0
		|		КОНЕЦ
		|	) КАК Приход,
		|	СУММА(
		|		ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|			ДенежныеСредства.Сумма
		|		ИНАЧЕ
		|			0
		|		КОНЕЦ
		|	) КАК Расход,
		|	ДенежныеСредства.Касса.ВалютаДенежныхСредств КАК Валюта,
		|	МАКСИМУМ(СтатьиДДС.КорреспондирующийСчет) КАК КорреспондирующийСчет
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваНаличные КАК ДенежныеСредства
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		Документ.ЛистКассовойКниги.КассовыеОрдера КАК ДокументКассоваяКнига
		|	ПО
		|		ДокументКассоваяКнига.Ссылка <> &Ссылка
		|		И ДокументКассоваяКнига.Ссылка.Проведен
		|		И ДокументКассоваяКнига.Ссылка.Организация = &Организация
		|		И ДокументКассоваяКнига.Ссылка.КассоваяКнига = &КассоваяКнига
		|		И ДокументКассоваяКнига.Документ = ДенежныеСредства.Регистратор
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиДДС
		|	ПО
		|		СтатьиДДС.Ссылка = ДенежныеСредства.СтатьяДвиженияДенежныхСредств
		|
		|ГДЕ
		|	ДенежныеСредства.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ДенежныеСредства.Организация = &Организация
		|	И ДенежныеСредства.Касса.КассоваяКнига = &КассоваяКнига
		|	И ДокументКассоваяКнига.Документ ЕСТЬ NULL
		|	И Не ДенежныеСредства.Регистратор ССЫЛКА Документ.ВводОстатков
		|	И ДенежныеСредства.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы)
		|	И (ВЫРАЗИТЬ(ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.ПриходныйКассовыйОрдер).КассаОтправитель КАК Справочник.Кассы).КассоваяКнига <> &КассоваяКнига
		|		ИЛИ ТИПЗНАЧЕНИЯ(ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.ПриходныйКассовыйОрдер).КассаОтправитель) = ТИП(Справочник.КассыККМ))
		|	
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|		0
		|	КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|		1
		|	КОНЕЦ,
		|	ДенежныеСредства.Касса.ВалютаДенежныхСредств,
		|	ДенежныеСредства.Регистратор
		|
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДенежныеСредства.Регистратор КАК Документ,
		|	ВЫБОР
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер ТОГДА
		|			ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.ПриходныйКассовыйОрдер).Номер
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер ТОГДА
		|			ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.РасходныйКассовыйОрдер).Номер
		|	КОНЕЦ КАК НомерДокумента,
		|	ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|		0
		|	КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|		1
		|	КОНЕЦ КАК ЗначениеУпорядочивания,
		|	СУММА(
		|		ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|			ДенежныеСредства.Сумма
		|		ИНАЧЕ
		|			0
		|		КОНЕЦ
		|	) КАК Приход,
		|	СУММА(
		|		ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|			ДенежныеСредства.Сумма
		|		ИНАЧЕ
		|			0
		|		КОНЕЦ
		|	) КАК Расход,
		|	ДенежныеСредства.Касса.ВалютаДенежныхСредств КАК Валюта,
		|	МАКСИМУМ(СтатьиДДС.КорреспондирующийСчет) КАК КорреспондирующийСчет
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваНаличные КАК ДенежныеСредства
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		Документ.ЛистКассовойКниги.КассовыеОрдера КАК ДокументКассоваяКнига
		|	ПО
		|		ДокументКассоваяКнига.Ссылка <> &Ссылка
		|		И ДокументКассоваяКнига.Ссылка.Проведен
		|		И ДокументКассоваяКнига.Ссылка.Организация = &Организация
		|		И ДокументКассоваяКнига.Ссылка.КассоваяКнига = &КассоваяКнига
		|		И ДокументКассоваяКнига.Документ = ДенежныеСредства.Регистратор
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиДДС
		|	ПО
		|		СтатьиДДС.Ссылка = ДенежныеСредства.СтатьяДвиженияДенежныхСредств
		|
		|ГДЕ
		|	ДенежныеСредства.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ДенежныеСредства.Организация = &Организация
		|	И ДенежныеСредства.Касса.КассоваяКнига = &КассоваяКнига
		|	И ДокументКассоваяКнига.Документ ЕСТЬ NULL
		|	И Не ДенежныеСредства.Регистратор ССЫЛКА Документ.ВводОстатков
		|	И (ВЫРАЗИТЬ(ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.РасходныйКассовыйОрдер).КассаПолучатель КАК Справочник.Кассы).КассоваяКнига <> &КассоваяКнига
		|		ИЛИ ТИПЗНАЧЕНИЯ(ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.РасходныйКассовыйОрдер).КассаПолучатель) = ТИП(Справочник.КассыККМ))
		|	
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|		0
		|	КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|		1
		|	КОНЕЦ,
		|	ДенежныеСредства.Касса.ВалютаДенежныхСредств,
		|	ДенежныеСредства.Регистратор
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|	
		|ВЫБРАТЬ
		|	НЕОПРЕДЕЛЕНО КАК Документ,
		|	"""" КАК НомерДокумента,
		|	2 КАК ЗначениеУпорядочивания,
		|	ВЫБОР КОГДА
		|		СУММА(ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|					ДенежныеСредства.СуммаРегл
		|				КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|					-ДенежныеСредства.СуммаРегл
		|				КОНЕЦ) > 0 ТОГДА
		|		СУММА(ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|					ДенежныеСредства.СуммаРегл
		|				КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|					-ДенежныеСредства.СуммаРегл
		|				КОНЕЦ)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Приход,
		|	ВЫБОР КОГДА
		|		СУММА(ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|					ДенежныеСредства.СуммаРегл
		|				КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|					-ДенежныеСредства.СуммаРегл
		|				КОНЕЦ) < 0 ТОГДА
		|		-СУММА(ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|					ДенежныеСредства.СуммаРегл
		|				КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|					-ДенежныеСредства.СуммаРегл
		|				КОНЕЦ)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Расход,
		|	&ВалютаРегламентированногоУчета КАК Валюта,
		|	МАКСИМУМ(СтатьиДДС.КорреспондирующийСчет) КАК КорреспондирующийСчет
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваНаличные КАК ДенежныеСредства
		|	
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиДДС
		|	ПО
		|		СтатьиДДС.Ссылка = ДенежныеСредства.СтатьяДвиженияДенежныхСредств
		|	
		|ГДЕ
		|	ДенежныеСредства.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ДенежныеСредства.СуммаРегл <> 0
		|	И ДенежныеСредства.Организация = &Организация
		|	И ДенежныеСредства.Касса.КассоваяКнига = &КассоваяКнига
		|	И Не ДенежныеСредства.Регистратор ССЫЛКА Документ.ВводОстатков
		|	И ДенежныеСредства.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПереоценкаДенежныхСредств)
		|	
		|СГРУППИРОВАТЬ ПО
		|	ДенежныеСредства.Касса.ВалютаДенежныхСредств
		|	
		|УПОРЯДОЧИТЬ ПО
		|	ЗначениеУпорядочивания,
		|	ВЫБОР
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер ТОГДА
		|			ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.ПриходныйКассовыйОрдер).Номер
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер ТОГДА
		|			ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.РасходныйКассовыйОрдер).Номер
		|	КОНЕЦ Возр
		|";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(Объект.Дата));
		Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(Объект.Дата));
		Запрос.УстановитьПараметр("Организация", Объект.Организация);
		Запрос.УстановитьПараметр("КассоваяКнига", Объект.КассоваяКнига);
		Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
		Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'На дату %1  нет документов для заполнения листа кассовой книги'"),
				Объект.Дата, Выборка.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				, // КлючДанных
				"Дата");
		Иначе
			Объект.КассовыеОрдера.Загрузить(РезультатЗапроса.Выгрузить());
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредупреждениеПриРедактировании()
	
	СтрокаТаблицы = Элементы.КассовыеОрдера.ТекущиеДанные;
	Если СтрокаТаблицы <> Неопределено Тогда
		Если ЗначениеЗаполнено(СтрокаТаблицы.Документ) Тогда
			Если ТипЗнч(СтрокаТаблицы.Документ) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") Тогда
				Элементы.Приход.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
				Элементы.Расход.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
			Иначе
				Элементы.Приход.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
				Элементы.Расход.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
			КонецЕсли;
		Иначе
			Элементы.Приход.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
			Элементы.Расход.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
КонецПроцедуры

#КонецОбласти
