#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура создает запись в регистре по переданным данным.
//
//	Параметры:
//		Организация - СправочникСсылка - ссылка на элемент справочника "Организации".
//		Период - Дата - Период записи регистра.
//		УчетнаяПолитика - СправочникСсылка - ссылка на элемент справочника "Учетные политики организаций".
//
Процедура СоздатьЗаписьРегистра(Знач Организация, Период, Знач УчетнаяПолитика) Экспорт
	
	Если Организация = Неопределено ИЛИ Организация = Справочники.Организации.ПустаяСсылка() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Данные.ПрименяетсяЕНВД,
		|	Данные.ПрименяетсяПБУ18
		|ИЗ
		|	Справочник.УчетныеПолитикиОрганизаций КАК Данные
		|ГДЕ
		|	Данные.Ссылка = &УчетнаяПолитика");
		
	Запрос.УстановитьПараметр("УчетнаяПолитика", УчетнаяПолитика);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();

	НоваяЗапись = РегистрыСведений.УчетнаяПолитикаОрганизаций.СоздатьМенеджерЗаписи();
	НоваяЗапись.Период = НачалоГода(ТекущаяДатаСеанса());
	НоваяЗапись.Организация = Организация;
	НоваяЗапись.Период = Период;
	НоваяЗапись.УчетнаяПолитика = УчетнаяПолитика;
	НоваяЗапись.ПлательщикЕНВД = Выборка.ПрименяетсяЕНВД;
	НоваяЗапись.ПрименяетсяПБУ18 = Выборка.ПрименяетсяПБУ18;
	Попытка
		НоваяЗапись.Записать();
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Запись в регистр сведений Учетная политика организаций'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;

КонецПроцедуры

// Функция возвращает структуру параметров действующей для организации учетной политики.
//
//	Параметры:
//		Организация - СправочникСсылка - ссылка на элемент справочника "Организации".
//		Период - Дата - Дата, на которую необходимо получить действующую учетную политику.
//
Функция ПараметрыУчетнойПолитики(Организация, Период) Экспорт
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	УчетныеПолитики.Наименование,
		|	УчетныеПолитики.МетодОценкиСтоимостиТоваров,
		|	УчетныеПолитики.СистемаНалогообложения,
		|	УчетныеПолитики.ПрименяетсяЕНВД,
		|	УчетныеПолитики.ПрименяетсяУчетНДСПоФактическомуИспользованию,
		|	УчетныеПолитики.ПрименяетсяПБУ18,
		|	УчетныеПолитики.Учитывать5ПроцентныйПорог,
		|	УчетныеПолитики.ФормироватьРезервыПоСомнительнымДолгамБУ,
		|	УчетныеПолитики.ФормироватьРезервыПоСомнительнымДолгамНУ,
		|	УчетныеПолитики.УчетГотовойПродукцииПоПлановойСтоимости,
		|	УчетныеПолитики.ИспользоватьСчет40,
		|	УчетныеПолитики.ПроводкиПоРаботникам,
		|	УчетныеПолитики.БазаРаспределенияКосвенныхРасходовПоВидамДеятельности,
		|	УчетныеПолитики.ФормироватьРезервОтпусковБУ,
		|	УчетныеПолитики.ФормироватьРезервОтпусковНУ,
		|	УчетныеПолитики.СхемаУчетаСтоимостиОСвНУ,
		|	УчетныеПолитики.ПрименяетсяОсвобождениеОтУплатыНДС
		|ИЗ
		|	РегистрСведений.УчетнаяПолитикаОрганизаций.СрезПоследних(&Период,
		|							Организация = &Организация) КАК ДанныеРегистра
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УчетныеПолитикиОрганизаций КАК УчетныеПолитики
		|		ПО ДанныеРегистра.УчетнаяПолитика = УчетныеПолитики.Ссылка");

	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("Организация", Организация);

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	СтруктураПараметров = Новый Структура;
	Для Каждого Колонка Из Результат.Колонки Цикл
		СтруктураПараметров.Вставить(Колонка.Имя, Выборка[Колонка.Имя]);
	КонецЦикла;
	
	Возврат СтруктураПараметров;
	
КонецФункции

#КонецОбласти

#КонецЕсли