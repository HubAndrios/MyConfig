
#Область ПрограммныйИнтерфейс

// Запускает автоматическое начисление и списание баллов и контролирует результат.
// 
// Параметры:
//  ПравилоНачисления - СправочникСсылка.ПравилаНачисленияИСписанияБонусныхБаллов - правило начисления баллов.
//
Процедура ВыполнитьАвтоматическоеНачислениеИСписаниеРегламентноеЗадание(ПравилоНачисления) Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	Если ПустаяСтрока(ИмяПользователя()) Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПравилоНачисления) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЖурнала = Новый Структура("ГруппаСобытий, Метаданные, Данные");
	ПараметрыЖурнала.ГруппаСобытий = НСтр("ru = 'Автоматическое начисление и списание бонусных баллов. Запуск по расписанию'");
	ПараметрыЖурнала.Метаданные    = ПравилоНачисления.Метаданные();
	ПараметрыЖурнала.Данные        = ПравилоНачисления;
	
	СегментыСервер.ЗаписьЖурнала(ПараметрыЖурнала, УровеньЖурналаРегистрации.Примечание, "", НСтр("ru = 'Запуск'"));
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		ПравилоНачисления,
		"ПометкаУдаления, Наименование");
	
	// Проверки
	Если Реквизиты.ПометкаУдаления Тогда
		СегментыСервер.ЗаписьЖурнала(ПараметрыЖурнала, УровеньЖурналаРегистрации.Ошибка, "",
			НСтр("ru = 'Завершение'"), НСтр("ru = 'Элемент автоматического начисления и списания бонусных баллов помечен на удаление'"));
		Возврат;
	КонецЕсли;
	
	БонусныеБаллыСервер.ВыполнитьАвтоматическоеНачислениеИСписание(ПравилоНачисления);
	СегментыСервер.ЗаписьЖурнала(ПараметрыЖурнала, УровеньЖурналаРегистрации.Примечание, "",НСтр("ru = 'Завершение'"));
	
КонецПроцедуры

// Выполняет автоматическое начисление и списание бонусных
// баллов по правилу начисления бонусных баллов.
// 
// Параметры:
//  ПравилоНачисления - СправочникСсылка.ПравилаНачисленияИСписанияБонусныхБаллов - правило начисления.
//
Процедура ВыполнитьАвтоматическоеНачислениеИСписание(ПравилоНачисления) Экспорт
	
	ДатаНачисления = ТекущаяДатаСеанса();
	
	ТаблицаНачислениеИСписание = ТаблицаНачислениеИСписание(ПравилоНачисления, ДатаНачисления);

	Если ТаблицаНачислениеИСписание.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПравилаНачисленияИСписанияБонусныхБаллов.ПериодДействия КАК ПериодДействия,
	|	ПравилаНачисленияИСписанияБонусныхБаллов.КоличествоПериодовДействия КАК КоличествоПериодовДействия,
	|	ПравилаНачисленияИСписанияБонусныхБаллов.КоличествоПериодовОтсрочкиНачалаДействия КАК КоличествоПериодовОтсрочкиНачалаДействия,
	|	ПравилаНачисленияИСписанияБонусныхБаллов.ПериодОтсрочкиНачалаДействия КАК ПериодОтсрочкиНачалаДействия,
	|	ПравилаНачисленияИСписанияБонусныхБаллов.ВидПравила КАК ВидПравила,
	|	ПравилаНачисленияИСписанияБонусныхБаллов.Владелец КАК БонуснаяПрограммаЛояльности
	|ИЗ
	|	Справочник.ПравилаНачисленияИСписанияБонусныхБаллов КАК ПравилаНачисленияИСписанияБонусныхБаллов
	|ГДЕ
	|	ПравилаНачисленияИСписанияБонусныхБаллов.Ссылка = &ПравилоНачисления");
	
	Запрос.УстановитьПараметр("ПравилоНачисления", ПравилоНачисления);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		НачислениеИСписаниеБонусныхБаллов = Документы.НачислениеИСписаниеБонусныхБаллов.СоздатьДокумент();
		НачислениеИСписаниеБонусныхБаллов.ПравилоНачисления = ПравилоНачисления;
		НачислениеИСписаниеБонусныхБаллов.Дата              = ДатаНачисления;
		НачислениеИСписаниеБонусныхБаллов.БонуснаяПрограммаЛояльности              = Выборка.БонуснаяПрограммаЛояльности;
		НачислениеИСписаниеБонусныхБаллов.ВидПравила                               = Выборка.ВидПравила;
		НачислениеИСписаниеБонусныхБаллов.КоличествоПериодовДействия               = Выборка.КоличествоПериодовДействия;
		НачислениеИСписаниеБонусныхБаллов.КоличествоПериодовОтсрочкиНачалаДействия = Выборка.КоличествоПериодовОтсрочкиНачалаДействия;
		НачислениеИСписаниеБонусныхБаллов.ПериодОтсрочкиНачалаДействия             = Выборка.ПериодОтсрочкиНачалаДействия;
		НачислениеИСписаниеБонусныхБаллов.ПериодДействия                           = Выборка.ПериодДействия;
		
		Для Каждого СтрокаТЧ Из ТаблицаНачислениеИСписание Цикл
		
			Если НачислениеИСписаниеБонусныхБаллов.ВидПравила = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Начисление Тогда
				НоваяСтрока = НачислениеИСписаниеБонусныхБаллов.Начисление.Добавить();
			Иначе
				НоваяСтрока = НачислениеИСписаниеБонусныхБаллов.Списание.Добавить();
			КонецЕсли;
			
			НоваяСтрока.Партнер = СтрокаТЧ.Партнер;
			НоваяСтрока.Баллы   = СтрокаТЧ.СуммаНачисления;
			
		КонецЦикла;
		
		НачислениеИСписаниеБонусныхБаллов.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
		
	КонецЕсли;
	
КонецПроцедуры

// Получает данные об остатках бонусных баллов партнера по бонусной программе лояльности.
//
// Параметры:
//  БонуснаяПрограммаЛояльности - СправочникСсылка.БонусныеПрограммыЛояльности - Бонусная программа лояльности.
//  Партнер - СправочникСсылка.Партнеры - Партнер.
//
// Возвращаемое значение:
//  ТаблицаЗначений с колонками:
//   * Период - Дата - Период.
//   * Сумма - Число - Сумма.
//   * Изменение - Число - Сумма изменения.
//   * ТекущийОстаток - Число - Текущий остаток.
//
Функция ОстаткиИДвиженияБонусныхБаллов(БонуснаяПрограммаЛояльности, Партнер) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОстаткиБонусныхБаллов = Новый ТаблицаЗначений;
	ОстаткиБонусныхБаллов.Колонки.Добавить("Период");
	ОстаткиБонусныхБаллов.Колонки.Добавить("Сумма");
	ОстаткиБонусныхБаллов.Колонки.Добавить("Изменение");
	ОстаткиБонусныхБаллов.Колонки.Добавить("ТекущийОстаток");
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	""Сейчас"" КАК Период,
	|	ВЫБОР
	|		КОГДА БонусныеБаллыОстаткиИОбороты.НачисленоОстаток - ВЫБОР КОГДА БонусныеБаллыОстаткиИОбороты.КСписаниюОстаток > 0 ТОГДА БонусныеБаллыОстаткиИОбороты.КСписаниюОстаток ИНАЧЕ 0 КОНЕЦ >= 0
	|			ТОГДА БонусныеБаллыОстаткиИОбороты.НачисленоОстаток - ВЫБОР КОГДА БонусныеБаллыОстаткиИОбороты.КСписаниюОстаток > 0 ТОГДА БонусныеБаллыОстаткиИОбороты.КСписаниюОстаток ИНАЧЕ 0 КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Сумма
	|ПОМЕСТИТЬ НачальныйОстаток
	|ИЗ
	|	РегистрНакопления.БонусныеБаллы.Остатки(
	|			&ДатаНачала,
	|			БонуснаяПрограммаЛояльности = &БонуснаяПрограммаЛояльности
	|				И Партнер = &Партнер) КАК БонусныеБаллыОстаткиИОбороты
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Сейчас"",
	|	0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НачальныйОстаток.Период КАК Период,
	|	СУММА(НачальныйОстаток.Сумма) КАК Сумма
	|ИЗ
	|	НачальныйОстаток КАК НачальныйОстаток
	|
	|СГРУППИРОВАТЬ ПО
	|	НачальныйОстаток.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	БонусныеБаллыОстаткиИОбороты.ПериодДень КАК Период,
	|	ВЫБОР
	|		КОГДА БонусныеБаллыОстаткиИОбороты.НачисленоКонечныйОстаток - ВЫБОР КОГДА БонусныеБаллыОстаткиИОбороты.КСписаниюКонечныйОстаток > 0 ТОГДА БонусныеБаллыОстаткиИОбороты.КСписаниюКонечныйОстаток ИНАЧЕ 0 КОНЕЦ >= 0
	|			ТОГДА БонусныеБаллыОстаткиИОбороты.НачисленоКонечныйОстаток - ВЫБОР КОГДА БонусныеБаллыОстаткиИОбороты.КСписаниюКонечныйОстаток > 0 ТОГДА БонусныеБаллыОстаткиИОбороты.КСписаниюКонечныйОстаток ИНАЧЕ 0 КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Сумма
	|ИЗ
	|	РегистрНакопления.БонусныеБаллы.ОстаткиИОбороты(
	|			&ДатаНачала,
	|			,
	|			Авто,
	|			Движения,
	|			БонуснаяПрограммаЛояльности = &БонуснаяПрограммаЛояльности
	|				И Партнер = &Партнер) КАК БонусныеБаллыОстаткиИОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период");

	Запрос.УстановитьПараметр("ДатаНачала",                  ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("БонуснаяПрограммаЛояльности", БонуснаяПрограммаЛояльности);
	Запрос.УстановитьПараметр("Партнер",                     Партнер);

	Результат = Запрос.ВыполнитьПакет();
	
	НачальныйОстатокВБаллах = 0;
	
	// Текущий остаток
	Выборка = Результат[1].Выбрать();
	ТекущийОстаток = 0;
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ОстаткиБонусныхБаллов.Добавить();
		НоваяСтрока.Период = Выборка.Период;
		НоваяСтрока.Сумма = Выборка.Сумма;
		НачальныйОстатокВБаллах = НоваяСтрока.Сумма;
		ТекущийОстаток = НоваяСтрока.Сумма;
		НоваяСтрока.ТекущийОстаток = Истина;
		
	КонецЦикла;
	
	// Списания баллов
	Выборка = Результат[2].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Изменение = Выборка.Сумма - ТекущийОстаток;
		
		Если Изменение = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ОстаткиБонусныхБаллов.Добавить();
		Если Изменение > 0 Тогда
			НоваяСтрока.Период = НСтр("ru = 'Начисление через'")
			                   + " " + СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(Цел((Выборка.Период - ТекущаяДатаСеанса())/(24*60*60)), НСтр("ru = 'день, дня, дней'"))
			                   + " " + "("+Формат(Выборка.Период,"ДЛФ=D")+"):"
			                   + " " + СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(Изменение, НСтр("ru = 'балл, балла, баллов'"))
		Иначе
			НоваяСтрока.Период = НСтр("ru = 'Списание через'")
			                   + " " + СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(Цел((Выборка.Период - ТекущаяДатаСеанса())/(24*60*60)), НСтр("ru = 'день, дня, дней'"))
			                   + " " + "("+Формат(Выборка.Период,"ДЛФ=D")+"):"
			                   + " " + СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(-Изменение, НСтр("ru = 'балл, балла, баллов'"))
		КонецЕсли;
		
		НоваяСтрока.Сумма = Выборка.Сумма;
		НоваяСтрока.Изменение = Изменение;
		ТекущийОстаток = Выборка.Сумма; 
		
	КонецЦикла;
	
	Возврат ОстаткиБонусныхБаллов;
	
КонецФункции

// Получает данные бонусной программы по карте лояльности.
//
// Параметры:
//  КартаЛояльности - СправочникСсылка.КартыЛояльности - карта лояльности.
//
// Возвращаемое значение:
//  СправочникСсылка.БонусныеПрограммыЛояльности - Бонусная программа лояльности.
//
Функция БонуснаяПрограммаКартыЛояльности(КартаЛояльности) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КартыЛояльности.Владелец.БонуснаяПрограммаЛояльности                                   КАК БонуснаяПрограммаЛояльности,
	|	КартыЛояльности.Владелец.БонуснаяПрограммаЛояльности.ВалютаКонвертацииБонусов          КАК Валюта,
	|	КартыЛояльности.Владелец.БонуснаяПрограммаЛояльности.КурсКонвертацииБонусовВВалюту     КАК КурсКонвертацииБонусовВВалюту,
	|	КартыЛояльности.Партнер                                                                КАК Партнер,
	|	КартыЛояльности.Владелец.БонуснаяПрограммаЛояльности.НеНачислятьБаллыПриОплатеБонусами КАК НеНачислятьБаллыПриОплатеБонусами
	|ИЗ
	|	Справочник.КартыЛояльности КАК КартыЛояльности
	|ГДЕ
	|	КартыЛояльности.Ссылка = &КартаЛояльности");
	Запрос.УстановитьПараметр("КартаЛояльности", КартаЛояльности);
	
	ВыборкаБонуснаяПрограммаЛояльности = Запрос.Выполнить().Выбрать();
	ВыборкаБонуснаяПрограммаЛояльности.Следующий();
	
	Возврат ВыборкаБонуснаяПрограммаЛояльности;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьБонусныеБаллыВозвратТоваровОтКлиента(ТекущийОбъект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущийОбъект.НачислениеБонусныхБаллов.Очистить();
	ТекущийОбъект.ОплатаБонуснымиБаллами.Очистить();
	
	Если ТипЗнч(ТекущийОбъект.ДокументРеализации) <> Тип("ДокументСсылка.ОтчетОРозничныхПродажах") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Сумма
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.БонуснаяПрограммаЛояльности,
	|	Таблица.ДатаНачисления КАК ДатаНачисления,
	|	Таблица.ДатаСписания КАК ДатаСписания,
	|	СУММА(Таблица.СуммаБонусныхБаллов) КАК СуммаБонусныхБаллов
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаБонусныеБаллы.БонуснаяПрограммаЛояльности КАК БонуснаяПрограммаЛояльности,
	|		ТаблицаБонусныеБаллы.ДатаНачисления КАК ДатаНачисления,
	|		ТаблицаБонусныеБаллы.ДатаСписания КАК ДатаСписания,
	|		ТаблицаБонусныеБаллы.СуммаБонусныхБаллов КАК СуммаБонусныхБаллов
	|	ИЗ
	|		Документ.ОтчетОРозничныхПродажах.НачислениеБонусныхБаллов КАК ТаблицаБонусныеБаллы
	|	ГДЕ
	|		ТаблицаБонусныеБаллы.Ссылка = &ДокументОснование
	|		И ТаблицаБонусныеБаллы.Партнер = &Партнер
	|		И ТаблицаБонусныеБаллы.Ссылка.Проведен
	|		И ТаблицаБонусныеБаллы.СуммаБонусныхБаллов > 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаБонусныеБаллы.БонуснаяПрограммаЛояльности,
	|		ТаблицаБонусныеБаллы.ДатаНачисления,
	|		ТаблицаБонусныеБаллы.ДатаСписания,
	|		-ТаблицаБонусныеБаллы.СуммаБонусныхБаллов
	|	ИЗ
	|		Документ.ВозвратТоваровОтКлиента.НачислениеБонусныхБаллов КАК ТаблицаБонусныеБаллы
	|	ГДЕ
	|		ТаблицаБонусныеБаллы.Ссылка.ДокументРеализации = &ДокументОснование
	|		И ТаблицаБонусныеБаллы.Ссылка.Партнер = &Партнер
	|		И ТаблицаБонусныеБаллы.Ссылка.Проведен
	|		И ТаблицаБонусныеБаллы.СуммаБонусныхБаллов > 0
	|		И ТаблицаБонусныеБаллы.Ссылка.Ссылка <> &Ссылка) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.БонуснаяПрограммаЛояльности,
	|	Таблица.ДатаНачисления,
	|	Таблица.ДатаСписания
	|
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.СуммаБонусныхБаллов) <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.БонуснаяПрограммаЛояльности,
	|	Таблица.ДатаОплаты КАК ДатаОплаты,
	|	СУММА(Таблица.СуммаБонусныхБаллов) КАК СуммаБонусныхБаллов
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаБонусныеБаллы.БонуснаяПрограммаЛояльности КАК БонуснаяПрограммаЛояльности,
	|		ТаблицаБонусныеБаллы.ДатаОплаты КАК ДатаОплаты,
	|		ТаблицаБонусныеБаллы.СуммаБонусныхБаллов КАК СуммаБонусныхБаллов
	|	ИЗ
	|		Документ.ОтчетОРозничныхПродажах.ОплатаБонуснымиБаллами КАК ТаблицаБонусныеБаллы
	|	ГДЕ
	|		ТаблицаБонусныеБаллы.Ссылка = &ДокументОснование
	|		И ТаблицаБонусныеБаллы.Партнер = &Партнер
	|		И ТаблицаБонусныеБаллы.Ссылка.Проведен
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаБонусныеБаллы.БонуснаяПрограммаЛояльности,
	|		ТаблицаБонусныеБаллы.ДатаОплаты,
	|		-ТаблицаБонусныеБаллы.СуммаБонусныхБаллов
	|	ИЗ
	|		Документ.ВозвратТоваровОтКлиента.ОплатаБонуснымиБаллами КАК ТаблицаБонусныеБаллы
	|	ГДЕ
	|		ТаблицаБонусныеБаллы.Ссылка.ДокументРеализации = &ДокументОснование
	|		И ТаблицаБонусныеБаллы.Ссылка.Партнер = &Партнер
	|		И ТаблицаБонусныеБаллы.Ссылка.Проведен
	|		И ТаблицаБонусныеБаллы.Ссылка.Ссылка <> &Ссылка) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.БонуснаяПрограммаЛояльности,
	|	Таблица.ДатаОплаты
	|
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.СуммаБонусныхБаллов) <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(Товары.Сумма), 0) КАК Сумма,
	|	ЕСТЬNULL(СУММА(Товары.СуммаВДокументе), 0) КАК СуммаВДокументе
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаТовары.Номенклатура КАК Номенклатура,
	|		ТаблицаТовары.Характеристика КАК Характеристика,
	|		ТаблицаТовары.Сумма КАК Сумма,
	|		0 КАК СуммаВДокументе
	|	ИЗ
	|		Документ.ОтчетОРозничныхПродажах.Товары КАК ТаблицаТовары
	|	ГДЕ
	|		ТаблицаТовары.Ссылка = &ДокументОснование
	|		И ТаблицаТовары.Ссылка.Проведен
	|		И ТаблицаТовары.Партнер = &Партнер
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Товары.Номенклатура,
	|		Товары.Характеристика,
	|		0,
	|		Товары.Сумма
	|	ИЗ
	|		Товары КАК Товары) КАК Товары
	|";

	Запрос.УстановитьПараметр("Ссылка", ТекущийОбъект.Ссылка);
	Запрос.УстановитьПараметр("ДокументОснование", ТекущийОбъект.ДокументРеализации);
	Запрос.УстановитьПараметр("ВалютаДокумента", ТекущийОбъект.Валюта);
	Запрос.УстановитьПараметр("Дата", ТекущийОбъект.Дата);
	Запрос.УстановитьПараметр("Партнер", ТекущийОбъект.Партнер);
	Запрос.УстановитьПараметр("Товары", ТекущийОбъект.Товары.Выгрузить());

	Результаты = Запрос.ВыполнитьПакет();
	
	ОстаткиНачисленныхБонусныхБаллов = Результаты[1].Выгрузить();
	ОстаткиСписываемыхБонусныхБаллов = Результаты[2].Выгрузить();
	
	СуммаНачисленныхБалловКВозврату = 0;
	СуммаСписанныхБонусныхБалловКВозврату = 0;
	
	ВыборкаТовары = Результаты[3].Выбрать();
	Если ВыборкаТовары.Следующий() Тогда
		
		Если ВыборкаТовары.Сумма <> 0 Тогда
			СуммаНачисленныхБалловКВозврату = ОстаткиНачисленныхБонусныхБаллов.Итог("СуммаБонусныхБаллов")
			                                * ВыборкаТовары.СуммаВДокументе / ВыборкаТовары.Сумма;
			
			СуммаСписанныхБонусныхБалловКВозврату = ОстаткиСписываемыхБонусныхБаллов.Итог("СуммаБонусныхБаллов")
			                                      * ВыборкаТовары.СуммаВДокументе / ВыборкаТовары.Сумма;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из ОстаткиНачисленныхБонусныхБаллов Цикл
		
		Если СуммаНачисленныхБалловКВозврату = 0 Тогда
			Прервать;
		КонецЕсли;
		
		Если СуммаНачисленныхБалловКВозврату >= СтрокаТЧ.СуммаБонусныхБаллов Тогда
			
			СуммаНачисленныхБалловКВозврату = СуммаНачисленныхБалловКВозврату - СтрокаТЧ.СуммаБонусныхБаллов;
			КСписанию = СтрокаТЧ.СуммаБонусныхБаллов;
			
		Иначе
			
			КСписанию = СуммаНачисленныхБалловКВозврату;
			СуммаНачисленныхБалловКВозврату = 0;
			
		КонецЕсли;
		
		НоваяСтрока = ТекущийОбъект.НачислениеБонусныхБаллов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ, "БонуснаяПрограммаЛояльности, ДатаНачисления, ДатаСписания");
		НоваяСтрока.СуммаБонусныхБаллов = КСписанию;
		
		СтрокаТЧ.СуммаБонусныхБаллов = СтрокаТЧ.СуммаБонусныхБаллов - КСписанию;
		
	КонецЦикла;
	
	Для Каждого СтрокаТЧ Из ОстаткиСписываемыхБонусныхБаллов Цикл
		
		Если СуммаСписанныхБонусныхБалловКВозврату = 0 Тогда
			Прервать;
		КонецЕсли;
		
		Если СуммаСписанныхБонусныхБалловКВозврату >= СтрокаТЧ.СуммаБонусныхБаллов Тогда
			
			СуммаСписанныхБонусныхБалловКВозврату = СуммаСписанныхБонусныхБалловКВозврату - СтрокаТЧ.СуммаБонусныхБаллов;
			КСписанию = СтрокаТЧ.СуммаБонусныхБаллов;
			
		Иначе
			
			КСписанию = СуммаСписанныхБонусныхБалловКВозврату;
			СуммаСписанныхБонусныхБалловКВозврату = 0;
			
		КонецЕсли;
		
		НоваяСтрока = ТекущийОбъект.ОплатаБонуснымиБаллами.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ, "БонуснаяПрограммаЛояльности, ДатаОплаты");
		НоваяСтрока.СуммаБонусныхБаллов = -КСписанию;
		
		СтрокаТЧ.СуммаБонусныхБаллов = СтрокаТЧ.СуммаБонусныхБаллов - КСписанию;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьБонусныеБаллыЧекККМВозврат(ТекущийОбъект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Валюта КАК Валюта,
	|	КурсыВалютСрезПоследних.Курс КАК Курс,
	|	КурсыВалютСрезПоследних.Кратность КАК Кратность
	|ПОМЕСТИТЬ КурсыВалют
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Дата, ) КАК КурсыВалютСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Количество
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.БонуснаяПрограммаЛояльности,
	|	Таблица.ДатаНачисления КАК ДатаНачисления,
	|	Таблица.ДатаСписания,
	|	СУММА(Таблица.СуммаБонусныхБаллов) КАК СуммаБонусныхБаллов
	|ПОМЕСТИТЬ БонусныеБаллы
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЧекККМБонусныеБаллы.БонуснаяПрограммаЛояльности КАК БонуснаяПрограммаЛояльности,
	|		ЧекККМБонусныеБаллы.ДатаНачисления КАК ДатаНачисления,
	|		ЧекККМБонусныеБаллы.ДатаСписания КАК ДатаСписания,
	|		ЧекККМБонусныеБаллы.СуммаБонусныхБаллов КАК СуммаБонусныхБаллов
	|	ИЗ
	|		Документ.ЧекККМ.БонусныеБаллы КАК ЧекККМБонусныеБаллы
	|	ГДЕ
	|		ЧекККМБонусныеБаллы.Ссылка = &ЧекККМ
	|		И ЧекККМБонусныеБаллы.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЧекККМВозвратБонусныеБаллы.БонуснаяПрограммаЛояльности,
	|		ЧекККМВозвратБонусныеБаллы.ДатаНачисления,
	|		ЧекККМВозвратБонусныеБаллы.ДатаСписания,
	|		-ЧекККМВозвратБонусныеБаллы.СуммаБонусныхБаллов
	|	ИЗ
	|		Документ.ЧекККМВозврат.БонусныеБаллы КАК ЧекККМВозвратБонусныеБаллы
	|	ГДЕ
	|		ЧекККМВозвратБонусныеБаллы.Ссылка.ЧекККМ = &ЧекККМ
	|		И ЧекККМВозвратБонусныеБаллы.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|		И ЧекККМВозвратБонусныеБаллы.Ссылка.Ссылка <> &Ссылка) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.БонуснаяПрограммаЛояльности,
	|	Таблица.ДатаНачисления,
	|	Таблица.ДатаСписания
	|
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.СуммаБонусныхБаллов) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	БонусныеБаллы.БонуснаяПрограммаЛояльности КАК БонуснаяПрограммаЛояльности,
	|	БонусныеБаллы.ДатаНачисления КАК ДатаНачисления,
	|	БонусныеБаллы.ДатаСписания КАК ДатаСписания,
	|	БонусныеБаллы.СуммаБонусныхБаллов КАК СуммаБонусныхБаллов,
	|	БонусныеБаллы.СуммаБонусныхБаллов * ЕСТЬNULL(КурсыВалютКонвертацииБонусов.Курс, 1) * ЕСТЬNULL(КурсыВалютДокумента.Кратность, 1) / (ЕСТЬNULL(КурсыВалютДокумента.Курс, 1) * ЕСТЬNULL(КурсыВалютКонвертацииБонусов.Кратность, 1)) * БонусныеБаллы.БонуснаяПрограммаЛояльности.КурсКонвертацииБонусовВВалюту КАК СуммаВВалютеДокумента
	|ИЗ
	|	БонусныеБаллы КАК БонусныеБаллы
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсыВалютКонвертацииБонусов
	|		ПО (КурсыВалютКонвертацииБонусов.Валюта = БонусныеБаллы.БонуснаяПрограммаЛояльности.ВалютаКонвертацииБонусов)
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсыВалютДокумента
	|		ПО (КурсыВалютДокумента.Валюта = &ВалютаДокумента)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаНачисления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	СУММА(Товары.СуммаБонусныхБалловКСписанию) КАК СуммаБонусныхБалловКСписанию,
	|	СУММА(Товары.СуммаНачисленныхБонусныхБалловВВалюте) КАК СуммаНачисленныхБонусныхБалловВВалюте,
	|	СУММА(Товары.Количество) КАК Количество,
	|	СУММА(Товары.КоличествоВДокументе) КАК КоличествоВДокументе
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЧекККМТовары.Номенклатура КАК Номенклатура,
	|		ЧекККМТовары.Характеристика КАК Характеристика,
	|		ЧекККМТовары.СуммаБонусныхБалловКСписанию КАК СуммаБонусныхБалловКСписанию,
	|		ЧекККМТовары.СуммаНачисленныхБонусныхБалловВВалюте КАК СуммаНачисленныхБонусныхБалловВВалюте,
	|		ЧекККМТовары.Количество КАК Количество,
	|		0 КАК КоличествоВДокументе
	|	ИЗ
	|		Документ.ЧекККМ.Товары КАК ЧекККМТовары
	|	ГДЕ
	|		ЧекККМТовары.Ссылка = &ЧекККМ
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Товары.Номенклатура,
	|		Товары.Характеристика,
	|		0,
	|		0,
	|		0,
	|		Товары.Количество
	|	ИЗ
	|		Товары КАК Товары) КАК Товары
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЧекККМ.КартаЛояльности КАК КартаЛояльности,
	|	ЧекККМ.КартаЛояльности.Владелец.БонуснаяПрограммаЛояльности КАК БонуснаяПрограммаЛояльности,
	|	ЧекККМ.Дата КАК Дата
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Ссылка = &ЧекККМ;
	|";

	Запрос.УстановитьПараметр("Ссылка", ТекущийОбъект.Ссылка);
	Запрос.УстановитьПараметр("ЧекККМ", ТекущийОбъект.ЧекККМ);
	Запрос.УстановитьПараметр("Дата",   ТекущийОбъект.Дата);
	Запрос.УстановитьПараметр("ВалютаДокумента", ТекущийОбъект.Валюта);
	Запрос.УстановитьПараметр("Товары", ТекущийОбъект.Товары.Выгрузить());

	Результаты = Запрос.ВыполнитьПакет();
	
	ОстаткиБонусныхБаллов = Результаты[3].Выгрузить();
	
	СуммаНачисленныхБалловКВозврату = 0;
	СуммаСписанныхБонусныхБалловКВозврату = 0;
	
	ВыборкаТовары = Результаты[4].Выбрать();
	Пока ВыборкаТовары.Следующий() Цикл
		
		Если ВыборкаТовары.Количество <> 0 Тогда
		
			СуммаНачисленныхБалловКВозврату = СуммаНачисленныхБалловКВозврату
			                                + ВыборкаТовары.СуммаНачисленныхБонусныхБалловВВалюте
			                                * ВыборкаТовары.КоличествоВДокументе / ВыборкаТовары.Количество;
			
			СуммаСписанныхБонусныхБалловКВозврату = СуммаСписанныхБонусныхБалловКВозврату
			                                      + ВыборкаТовары.СуммаБонусныхБалловКСписанию
			                                      * ВыборкаТовары.КоличествоВДокументе / ВыборкаТовары.Количество;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ТекущийОбъект.БонусныеБаллы.Очистить();
	
	Для Каждого СтрокаТЧ Из ОстаткиБонусныхБаллов Цикл
		
		Если СуммаНачисленныхБалловКВозврату = 0 Тогда
			Прервать;
		КонецЕсли;
		
		Если СуммаНачисленныхБалловКВозврату >= СтрокаТЧ.СуммаВВалютеДокумента Тогда
			
			СуммаНачисленныхБалловКВозврату = СуммаНачисленныхБалловКВозврату - СтрокаТЧ.СуммаВВалютеДокумента;
			
			КСписанию = СтрокаТЧ.СуммаВВалютеДокумента;
			
			НоваяСтрока = ТекущийОбъект.БонусныеБаллы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ, "БонуснаяПрограммаЛояльности, ДатаНачисления, ДатаСписания");
			НоваяСтрока.СуммаБонусныхБаллов = СтрокаТЧ.СуммаБонусныхБаллов *  КСписанию / СтрокаТЧ.СуммаВВалютеДокумента;
			
			СтрокаТЧ.СуммаВВалютеДокумента = СтрокаТЧ.СуммаВВалютеДокумента - КСписанию;
			СтрокаТЧ.СуммаБонусныхБаллов = СтрокаТЧ.СуммаБонусныхБаллов - НоваяСтрока.СуммаБонусныхБаллов;
			
		Иначе
			
			КСписанию = СуммаНачисленныхБалловКВозврату;
			
			СуммаНачисленныхБалловКВозврату = 0;
			
			НоваяСтрока = ТекущийОбъект.БонусныеБаллы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ, "БонуснаяПрограммаЛояльности, ДатаНачисления, ДатаСписания");
			НоваяСтрока.СуммаБонусныхБаллов = СтрокаТЧ.СуммаБонусныхБаллов *  КСписанию / СтрокаТЧ.СуммаВВалютеДокумента;
			
			СтрокаТЧ.СуммаВВалютеДокумента = СтрокаТЧ.СуммаВВалютеДокумента - КСписанию;
			СтрокаТЧ.СуммаБонусныхБаллов = СтрокаТЧ.СуммаБонусныхБаллов - НоваяСтрока.СуммаБонусныхБаллов;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Выборка = Результаты[5].Выбрать();
	Если Выборка.Следующий() Тогда
		ТекущийОбъект.КартаЛояльности              = Выборка.КартаЛояльности;
		ТекущийОбъект.СуммаБонусныхБалловКВозврату = СуммаСписанныхБонусныхБалловКВозврату;
	КонецЕсли;
	
КонецПроцедуры

Функция ТаблицаБонусныеБаллы(СкидкиНаценки, Дата) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Таблица.КлючСвязи     КАК КлючСвязи,
	|	Таблица.СкидкаНаценка КАК СкидкаНаценка,
	|	Таблица.Сумма         КАК Сумма
	|ПОМЕСТИТЬ СкидкиНаценки
	|ИЗ
	|	&СкидкиНаценки КАК Таблица
	|ГДЕ
	|	Таблица.СпособПримененияСкидки = ЗНАЧЕНИЕ(Перечисление.СпособыПримененияСкидокНаценок.НачислитьБонусныеБаллы)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабличнаяЧасть.БонуснаяПрограммаЛояльности КАК БонуснаяПрограммаЛояльности,
	|	ТабличнаяЧасть.БонуснаяПрограммаЛояльности.ВалютаКонвертацииБонусов КАК ВалютаКонвертацииБонусов,
	|	ТабличнаяЧасть.БонуснаяПрограммаЛояльности.КурсКонвертацииБонусовВВалюту КАК КурсКонвертацииБонусовВВалюту,
	|	ТабличнаяЧасть.КлючСвязи КАК КлючСвязи,
	|
	|	ВЫБОР
	|		КОГДА ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовДействия > 0 ТОГДА
	|			ВЫБОР
	|				КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
	|					ТОГДА ДОБАВИТЬКДАТЕ(ТабличнаяЧасть.Период, ДЕНЬ, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовОтсрочкиНачалаДействия)
	|				КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|					ТОГДА ДОБАВИТЬКДАТЕ(ТабличнаяЧасть.Период, НЕДЕЛЯ, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовОтсрочкиНачалаДействия)
	|				КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|					ТОГДА ДОБАВИТЬКДАТЕ(ТабличнаяЧасть.Период, МЕСЯЦ, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовОтсрочкиНачалаДействия)
	|				КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|					ТОГДА ДОБАВИТЬКДАТЕ(ТабличнаяЧасть.Период, КВАРТАЛ, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовОтсрочкиНачалаДействия)
	|				КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|					ТОГДА ДОБАВИТЬКДАТЕ(ТабличнаяЧасть.Период, ГОД, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовОтсрочкиНачалаДействия)
	|				КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|					ТОГДА ДОБАВИТЬКДАТЕ(ТабличнаяЧасть.Период, ДЕКАДА, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовОтсрочкиНачалаДействия)
	|				КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|					ТОГДА ДОБАВИТЬКДАТЕ(ТабличнаяЧасть.Период, ПОЛУГОДИЕ, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовОтсрочкиНачалаДействия)
	|				ИНАЧЕ ТабличнаяЧасть.Период
	|			КОНЕЦ
	|	ИНАЧЕ
	|		ДатаВремя(1,1,1)
	|	КОНЕЦ КАК ДатаСписания,
	|
	|	ВЫБОР
	|		КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ДЕНЬ, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовОтсрочкиНачалаДействия)
	|		КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, НЕДЕЛЯ, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовОтсрочкиНачалаДействия)
	|		КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, МЕСЯЦ, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовОтсрочкиНачалаДействия)
	|		КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, КВАРТАЛ, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовОтсрочкиНачалаДействия)
	|		КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ГОД, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовОтсрочкиНачалаДействия)
	|		КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ДЕКАДА, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовОтсрочкиНачалаДействия)
	|		КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодОтсрочкиНачалаДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ПОЛУГОДИЕ, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовОтсрочкиНачалаДействия)
	|		ИНАЧЕ &Период
	|	КОНЕЦ КАК ДатаНачисления,
	|
	|	ТабличнаяЧасть.Сумма КАК СуммаБонусныхБаллов
	|
	|ИЗ
	|	(
	|	ВЫБРАТЬ
	|		ВЫБОР
	|			КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&Период, ДЕНЬ, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовДействия)
	|				КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&Период, НЕДЕЛЯ, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовДействия)
	|			КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&Период, МЕСЯЦ, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовДействия)
	|			КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&Период, КВАРТАЛ, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовДействия)
	|			КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&Период, ГОД, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовДействия)
	|			КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&Период, ДЕКАДА, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовДействия)
	|			КОГДА ТабличнаяЧасть.СкидкаНаценка.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&Период, ПОЛУГОДИЕ, ТабличнаяЧасть.СкидкаНаценка.КоличествоПериодовДействия)
	|			ИНАЧЕ &Период
	|		КОНЕЦ                                                    КАК Период,
	|		ТабличнаяЧасть.СкидкаНаценка.БонуснаяПрограммаЛояльности КАК БонуснаяПрограммаЛояльности,
	|		ТабличнаяЧасть.Сумма                                     КАК Сумма,
	|		ТабличнаяЧасть.СкидкаНаценка                             КАК СкидкаНаценка,
	|		ТабличнаяЧасть.КлючСвязи                                 КАК КлючСвязи
	|	ИЗ
	|		СкидкиНаценки КАК ТабличнаяЧасть
	|	) КАК ТабличнаяЧасть
	|";
	
	Запрос.УстановитьПараметр("СкидкиНаценки", СкидкиНаценки);
	Запрос.УстановитьПараметр("Период",        Дата);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

Функция ТаблицаНачислениеИСписание(ПравилоНачисления, Дата) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПравилоНачисления.СхемаКомпоновкиДанных КАК СхемаКомпоновкиДанных,
	|	ПравилоНачисления.ХранилищеСхемыКомпоновкиДанных КАК ХранилищеСхемыКомпоновкиДанных,
	|	ПравилоНачисления.ХранилищеНастроекКомпоновкиДанных КАК ХранилищеНастроекКомпоновкиДанных,
	|	ПравилоНачисления.Владелец КАК БонуснаяПрограммаЛояльности
	|ИЗ
	|	Справочник.ПравилаНачисленияИСписанияБонусныхБаллов КАК ПравилоНачисления
	|ГДЕ
	|	ПравилоНачисления.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", ПравилоНачисления);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Если ЗначениеЗаполнено(Выборка.СхемаКомпоновкиДанных) Тогда
		СхемаКомпоновкиДанных = Справочники.ПравилаНачисленияИСписанияБонусныхБаллов.ПолучитьМакет(Выборка.СхемаКомпоновкиДанных);
	Иначе
		СхемаКомпоновкиДанных = Выборка.ХранилищеСхемыКомпоновкиДанных.Получить();
	КонецЕсли;

	НастройкиКомпоновкиДанных = Выборка.ХранилищеНастроекКомпоновкиДанных.Получить();


	// Подготовка компоновщика макета компоновки данных, загрузка настроек
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));

	Если НастройкиКомпоновкиДанных <> Неопределено Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновкиДанных);
		КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;

	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);

	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ТекущаяДата");
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Параметр.Значение = Дата;
	КонецЕсли;

	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("АвтоматическоеНачисление");
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Параметр.Значение = ПравилоНачисления;
	КонецЕсли;

	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("БонуснаяПрограммаЛояльности");
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Параметр.Значение = Выборка.БонуснаяПрограммаЛояльности;
	КонецЕсли;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		СхемаКомпоновкиДанных,
		КомпоновщикНастроек.ПолучитьНастройки(), , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"), Ложь);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,,,Истина);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;

	ДанныеОтчета = Новый ТаблицаЗначений();
	ПроцессорВывода.УстановитьОбъект(ДанныеОтчета);
	ДанныеОтчета = ПроцессорВывода.Вывести(ПроцессорКомпоновки);

	Возврат ДанныеОтчета;
	
КонецФункции

#КонецОбласти
