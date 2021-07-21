
#Область ПрограммныйИнтерфейс

// Выполняет запрос по данным истории продаж.
//
// Параметры:
//  НастройкиКомпоновки - НастройкиКомпонокиДанных - настройки компоновки данных для формирования запроса по
//  данным истории продаж.
//  НачалоПериода - Дата - начало периода, за который анализируется истории продаж.
//  КонецПериода - Дата - конец периода, за который анализируется истории продаж.
//  Период - Строка - период, за который рассчитывается среднее значение объема продаж.
//
// Возвращаемое значение:
//  РезультатЗапроса - результат запроса.
//
Функция ВыполнитьЗапросПоИсторииПродаж(НастройкиКомпоновки, НачалоПериода, КонецПериода, Период, ДетализацияПоНоменклатуре) Экспорт

	Если ДетализацияПоНоменклатуре Тогда
		СхемаКомпоновки = Документы.ЗаданиеТорговомуПредставителю.ПолучитьМакет("СхемаКомпоновкиДляАвтоматическогоЗаполненияПоИсторииПродаж");
	Иначе
		СхемаКомпоновки = Документы.ЗаданиеТорговомуПредставителю.ПолучитьМакет("СхемаКомпоновкиДляАвтоматическогоЗаполненияПоИсторииПродажПоСумме");
	КонецЕсли;
		
	МобильныеПриложения.УстановитьЗначениеПараметраНастроек(НастройкиКомпоновки, "НачалоПериода", НачалоПериода);
	МобильныеПриложения.УстановитьЗначениеПараметраНастроек(НастройкиКомпоновки, "КонецПериода", КонецПериода);
	МобильныеПриложения.УстановитьЗначениеПараметраНастроек(НастройкиКомпоновки, "Период", Период);

	МакетКомпоновки = КомпоновкаДанныхСервер.ПолучитьМакетКомпоновки(СхемаКомпоновки, НастройкиКомпоновки);
	
	Запрос = КомпоновкаДанныхСервер.ПолучитьЗапросИзМакетаКомпоновки(МакетКомпоновки, "Запрос");
	
	Возврат Запрос.Выполнить();

КонецФункции

// Формирует данные о состоянии расчетов с партнером.
//
// Параметры:
//  Партнер - СправочникСсылка.Партнеры - партнер, данные о состоянии расчетов с которым требуется получить.
//  ПлановаяДата - Дата - плановая дата посещения.
//
// Возвращаемое значение:
//  Структура - структура, содержащая данные о состоянии расчетов с партнером, с полями:
//  	* ТаблицаДолгов - Таблица значений, содержащая информацию о задолженности.
//      * ТаблицаДвижений - Таблица значений, содержащая информацию о движениях расчетов.
//
Функция ПолучитьДанныеОДебиторскойЗадолженностиПартнера(Партнер, ПлановаяДата) Экспорт

	Запрос = Новый Запрос();
	Запрос.Текст = ПолучитьТекстЗапросаПоДебиторскойЗадолженности();
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Запрос.УстановитьПараметр("ПлановаяДата", ПлановаяДата);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	РезультатЗапросаПоДолгам = МассивРезультатов[1];
	РезультатЗапросаПоДвижениям = МассивРезультатов[2];
	
	ТаблицаДолгов = РезультатЗапросаПоДолгам.Выгрузить();
	ТаблицаДвижений = РезультатЗапросаПоДвижениям.Выгрузить();
	
	СтруктураДанных = Новый Структура();
	СтруктураДанных.Вставить("ТаблицаДолгов", ТаблицаДолгов);
	СтруктураДанных.Вставить("ТаблицаДвижений", ТаблицаДвижений);
	
	Возврат СтруктураДанных;

КонецФункции

// Возвращает структуру, содержащую значения реквизитов, относящихся к дате и времени визита.
//
// Параметры:
//  РасчетнаяДата - Дата - дата, на которую выполняется планирование визита.
//  ГрафикПосещения - Таблицы значений - график, определенный в условиях обслуживания, с колонками:
//  	* ДеньНедели - ПеречислениеСсылка.ДниНедели - день недели.
//		* ВремяНачала - Дата - время начала посещения.
//  	* ВремяОкончания - Дата - время окончания посещения.
//
// Возвращаемое значение:
//  Структура - структура, содержащая значения реквизитов, относящихся к дате и времени визита, с полями:
//  	* ДатаВизитаПлан - Дата - плановая дата визита.
//  	* ВремяНачала - Дата - время начала посещения.
//  	* ВремяОкончания - Дата - время окончания посещения.
//
Функция ПолучитьСтруктуруРеквизитовВизита(РасчетнаяДата, ГрафикПосещения) Экспорт

	СтруктураРеквизитов = Новый Структура();
	СтруктураРеквизитов.Вставить("ДатаВизитаПлан", '00010101000000');
	СтруктураРеквизитов.Вставить("ВремяНачала", '00010101000000');
	СтруктураРеквизитов.Вставить("ВремяОкончания", '00010101000000');

	Если ГрафикПосещения.Количество() = 0 Тогда
		Возврат СтруктураРеквизитов;
	КонецЕсли;

	ГрафикПосещения.Колонки.Добавить("Срок");

	НомерТекущегоДня = ДеньНедели(РасчетнаяДата);

	Для Каждого СтрокаГрафика Из ГрафикПосещения Цикл

		Если СтрокаГрафика.ДеньНедели = Перечисления.ДниНедели.Понедельник Тогда
			 СтрокаГрафика.Срок = РассчитатьСрокОтДня(НомерТекущегоДня, 1);
		ИначеЕсли СтрокаГрафика.ДеньНедели = Перечисления.ДниНедели.Вторник Тогда
			СтрокаГрафика.Срок = РассчитатьСрокОтДня(НомерТекущегоДня, 2);
		ИначеЕсли СтрокаГрафика.ДеньНедели = Перечисления.ДниНедели.Среда Тогда
			СтрокаГрафика.Срок = РассчитатьСрокОтДня(НомерТекущегоДня, 3);
		ИначеЕсли СтрокаГрафика.ДеньНедели = Перечисления.ДниНедели.Четверг Тогда
			СтрокаГрафика.Срок = РассчитатьСрокОтДня(НомерТекущегоДня, 4);
		ИначеЕсли СтрокаГрафика.ДеньНедели = Перечисления.ДниНедели.Пятница Тогда
			СтрокаГрафика.Срок = РассчитатьСрокОтДня(НомерТекущегоДня, 5);
		ИначеЕсли СтрокаГрафика.ДеньНедели = Перечисления.ДниНедели.Суббота Тогда
			СтрокаГрафика.Срок = РассчитатьСрокОтДня(НомерТекущегоДня, 6);
		ИначеЕсли СтрокаГрафика.ДеньНедели = Перечисления.ДниНедели.Воскресенье Тогда
			СтрокаГрафика.Срок = РассчитатьСрокОтДня(НомерТекущегоДня, 7);
		КонецЕсли;

	КонецЦикла;
	
	ГрафикПосещения.Сортировать("Срок Возр");
	СтрокаГрафика = ГрафикПосещения[0];

	СтруктураРеквизитов.Вставить("ДатаВизитаПлан",РасчетнаяДата + СтрокаГрафика.Срок*86400);
	СтруктураРеквизитов.Вставить("ВремяНачала", СтрокаГрафика.ВремяНачала);
	СтруктураРеквизитов.Вставить("ВремяОкончания", СтрокаГрафика.ВремяОкончания);

	Возврат СтруктураРеквизитов;

КонецФункции

// Выполняет формирования заданий для указанного торгового представителя на указанный период.
//
// Параметры:
//  ТорговыйПредставитель - СправочникСсылка.ПОльзователи - торговый представитель, для которого отбираются условия обслуживания.
//  НачальнаяДатаПланирования - Дата - дата, начиная с которой требуется анализировать необходимость визита по условиям обслуживания.
//  КонечнаяДатаПланирования - Дата - дата, по которую требуется анализировать необходимость визита по условиям обслуживания.
//
Процедура СформироватьЗадания(ТорговыйПредставитель, НачальнаяДатаПланирования, КонечнаяДатаПланирования) Экспорт
	
	ТаблицаУсловийОбслуживания = ПолучитьУсловияОбслуживанияДляФормированияЗаданий(ТорговыйПредставитель, НачальнаяДатаПланирования, КонечнаяДатаПланирования);
	
	Для Каждого СтрокаТаблицы Из ТаблицаУсловийОбслуживания Цикл
		
		Задание = Документы.ЗаданиеТорговомуПредставителю.СоздатьДокумент();
		Задание.Дата = ТекущаяДатаСеанса();
		
		ДанныеЗаполнения = Новый Структура();
		ДанныеЗаполнения.Вставить("Партнер", СтрокаТаблицы.Партнер);
		ДанныеЗаполнения.Вставить("УсловияОбслуживания", СтрокаТаблицы.УсловияОбслуживания);
		ДанныеЗаполнения.Вставить("ДатаВизитаПлан", СтрокаТаблицы.ДатаПосещенияПоГрафику);
		ДанныеЗаполнения.Вставить("Куратор", ТорговыйПредставитель);
		ДанныеЗаполнения.Вставить("ТорговыйПредставитель", ТорговыйПредставитель);
		
		Задание.Заполнить(ДанныеЗаполнения);
		Задание.Статус = Перечисления.СтатусыЗаданийТорговымПредставителям.КОтработке;
		
		Попытка
			Задание.Записать();
		Исключение
			КодОсновногоЯзыка = ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка();
		
			ТекстСообщения = ИнформацияОбОшибке().Описание;
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка при записи задания торговому представителю'", КодОсновногоЯзыка),
								УровеньЖурналаРегистрации.Ошибка,
								,
								,
								ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#Область ПроцедурыИнициализацииУсловийОбслуживания

// Возвращает структуру условий обслуживания.
//
// Параметры:
//  УсловияОбслуживания - СправочникСсылка.УсловияОбслуживанияПартнеровТорговымиПредставителями - ссылка на условия обслуживания.
//
// Возвращаемое значение:
//  Структура - структура, включающая условия обслуживания, с полями:
//		* УсловияОбслуживания - СправочникСсылка.УсловияОбслуживанияПартнеровТорговымиПредставителями - условия обслуживания.
//      * Соглашение - СправочникСсылка.СоглашенияСКлиентами - соглашение с клиентом.
//      * Куратор - СправочникСсылка.Пользователи - куратор.
//      * ТорговыйПредставитель - СправочникСсылка.Пользователи - торговый представитель.
//
Функция ПолучитьУсловияОбслуживания(Знач УсловияОбслуживания) Экспорт
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Ссылка", УсловияОбслуживания);
	
	Возврат ПолучитьДанныеУсловийОбслуживания(ПараметрыОтбора);
	
КонецФункции

// Возвращает структуру условий обслуживания по партнеру.
//
// Параметры:
//  Партнер - СправочникСсылка.Партнеры - ссылка на партнера, для которого необходимо получить условия обслуживания.
//
// Возвращаемое значение:
//  Структура - структура, включающая условия обслуживания, с полями:
//  	* УсловияОбслуживания - СправочникСсылка.УсловияОбслуживанияПартнеровТорговымиПредставителями - условия обслуживания.
//      * Соглашение - СправочникСсылка.СоглашенияСКлиентами - соглашение с клиентом.
//      * Куратор - СправочникСсылка.Пользователи - куратор.
//      * ТорговыйПредставитель - СправочникСсылка.Пользователи - торговый представитель.
//
Функция ПолучитьУсловияОбслуживанияПоУмолчанию(Знач Партнер) Экспорт
	
	Если Не ЗначениеЗаполнено(Партнер) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Владелец",        Партнер);
	ПараметрыОтбора.Вставить("ПометкаУдаления", Ложь);
	
	Возврат ПолучитьДанныеУсловийОбслуживания(ПараметрыОтбора);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует и текст запроса для получения данных о состоянии расчетов с партнером.
//
// Возвращаемое значение:
//  Сформированный текст запроса.
//
Функция ПолучитьТекстЗапросаПоДебиторскойЗадолженности()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСКлиентамиОстаткиДолги.ЗаказКлиента,
	|	РасчетыСКлиентамиОстаткиДолги.Валюта,
	|	СУММА(ВЫБОР
	|			КОГДА РасчетыСКлиентамиОстаткиДолги.СуммаОстаток < 0
	|				ТОГДА -РасчетыСКлиентамиОстаткиДолги.СуммаОстаток
	|			ИНАЧЕ NULL
	|		КОНЕЦ) КАК НашДолг,
	|	СУММА(ВЫБОР
	|			КОГДА РасчетыСКлиентамиОстаткиДолги.СуммаОстаток > 0
	|				ТОГДА РасчетыСКлиентамиОстаткиДолги.СуммаОстаток
	|			ИНАЧЕ NULL
	|		КОНЕЦ) КАК ДолгКлиента,
	|	ПРЕДСТАВЛЕНИЕ(РасчетыСКлиентамиОстаткиДолги.ЗаказКлиента) КАК ПредставлениеЗаказа,
	|	СУММА(ВЫБОР
	|			КОГДА РасчетыСКлиентамиОстаткиПросроченныеДолги.КОплатеОстаток>0
	|				ТОГДА РасчетыСКлиентамиОстаткиПросроченныеДолги.КОплатеОстаток
	|			ИНАЧЕ NULL
	|		КОНЕЦ) КАК КОплатеПросрочено,
	|	СУММА(- РасчетыСКлиентамиОстаткиПросроченныеДолги.КОтгрузкеОстаток) КАК КОтгрузкеПросрочено
	|ПОМЕСТИТЬ ДолгиПоЗаказам
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами.Остатки(
	|			,
	|			ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
	|				И ЗаказКлиента.Партнер = &Партнер) КАК РасчетыСКлиентамиОстаткиДолги
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКлиентами.Остатки(
	|				&ПлановаяДата,
	|				ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
	|					И ЗаказКлиента.Партнер = &Партнер) КАК РасчетыСКлиентамиОстаткиПросроченныеДолги
	|		ПО РасчетыСКлиентамиОстаткиДолги.ЗаказКлиента = РасчетыСКлиентамиОстаткиПросроченныеДолги.ЗаказКлиента
	|ГДЕ
	|	РасчетыСКлиентамиОстаткиДолги.СуммаОстаток <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСКлиентамиОстаткиДолги.Валюта,
	|	РасчетыСКлиентамиОстаткиДолги.ЗаказКлиента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДолгиПоЗаказам.ЗаказКлиента,
	|	ДолгиПоЗаказам.Валюта,
	|	ДолгиПоЗаказам.ПредставлениеЗаказа,
	|	ДолгиПоЗаказам.НашДолг,
	|	ДолгиПоЗаказам.ДолгКлиента,
	|	ДолгиПоЗаказам.КОплатеПросрочено,
	|	ДолгиПоЗаказам.КОтгрузкеПросрочено
	|ИЗ
	|	ДолгиПоЗаказам КАК ДолгиПоЗаказам
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СУММА(РасчетыСКлиентамиОстаткиИОбороты.СуммаПриход) КАК УвеличениеДолга,
	|	СУММА(РасчетыСКлиентамиОстаткиИОбороты.СуммаРасход) КАК УменьшениеДолга,
	|	РасчетыСКлиентамиОстаткиИОбороты.Регистратор КАК РасчетныйДокумент,
	|	РасчетыСКлиентамиОстаткиИОбороты.ПериодСекунда КАК Дата,
	|	РасчетыСКлиентамиОстаткиИОбороты.ЗаказКлиента,
	|	ПРЕДСТАВЛЕНИЕ(РасчетыСКлиентамиОстаткиИОбороты.Регистратор) КАК ПредставлениеРасчетногоДокумента
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами.ОстаткиИОбороты(
	|			,
	|			,
	|			Авто,
	|			,
	|			ЗаказКлиента В
	|				(ВЫБРАТЬ
	|					ДолгиПоЗаказам.ЗаказКлиента
	|				ИЗ
	|					ДолгиПоЗаказам)) КАК РасчетыСКлиентамиОстаткиИОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСКлиентамиОстаткиИОбороты.Регистратор,
	|	РасчетыСКлиентамиОстаткиИОбороты.ПериодСекунда,
	|	РасчетыСКлиентамиОстаткиИОбороты.ЗаказКлиента
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата"
	;
	
	Возврат ТекстЗапроса
	
КонецФункции

// Рассчитывает срок от одного дня недели до другого.
//
// Параметры:
//  НомерИсходногоДня - номер дня недели, от которого отсчитывается срок.
//  НомерРасчетногоДня - номер дня недели, до которого требуется рассчитать срок.
//
// Возвращаемое значение:
//  Срок - количество дней от одного дня до другого.
//
Функция РассчитатьСрокОтДня(НомерИсходногоДня, НомерРасчетногоДня)

	Если НомерРасчетногоДня > НомерИсходногоДня Тогда
		Срок = НомерРасчетногоДня - НомерИсходногоДня;
	Иначе
		Срок = НомерРасчетногоДня - НомерИсходногоДня + 7;
	КонецЕсли;

	Возврат Срок;

КонецФункции

// Формирует таблицу значений, содержащую перечень условий обслуживания партнеров.
//
// Параметры:
//  ТорговыйПредставитель - торговый представитель, для которого отбираются условия обслуживания.
//  НачальнаяДатаПланирования - дата, начиная с которой требуется анализировать необходимость визита по условиям обслуживания.
//  КонечнаяДатаПланирования - дата, по которую требуется анализировать необходимость визита по условиям обслуживания.
//
// Возвращаемое значение:
//  Таблица значений, содержащая перечень условий обслуживания партнеров, включая даты посещения по графику.
//
Функция ПолучитьУсловияОбслуживанияДляФормированияЗаданий(ТорговыйПредставитель, НачальнаяДатаПланирования, КонечнаяДатаПланирования)
	
	Запрос = Новый Запрос();
	Запрос.Текст = ПолучитьТекстЗапросаПоУсловиямОбслуживанияПартнеров();
	
	Запрос.УстановитьПараметр("ТорговыйПредставитель", ТорговыйПредставитель);
	Запрос.УстановитьПараметр("НачальнаяДатаПланирования", МАКС(НачальнаяДатаПланирования, НачалоДня(ТекущаяДатаСеанса())));
	Запрос.УстановитьПараметр("КонечнаяДатаПланирования", КонечнаяДатаПланирования);
	Запрос.УстановитьПараметр("ПустаяДата", '00010101000000');
	
	Запрос.УстановитьПараметр("Понедельник", Перечисления.ДниНедели.Понедельник);
	Запрос.УстановитьПараметр("Вторник", Перечисления.ДниНедели.Вторник);
	Запрос.УстановитьПараметр("Среда", Перечисления.ДниНедели.Среда);
	Запрос.УстановитьПараметр("Четверг", Перечисления.ДниНедели.Четверг);
	Запрос.УстановитьПараметр("Пятница", Перечисления.ДниНедели.Пятница);
	Запрос.УстановитьПараметр("Суббота", Перечисления.ДниНедели.Суббота);
	Запрос.УстановитьПараметр("Воскресенье", Перечисления.ДниНедели.Воскресенье);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Формирует текст запроса по условиям обслуживания партнеров.
//
// Возвращаемое значение:
//  Текст запрос.
//
Функция ПолучитьТекстЗапросаПоУсловиямОбслуживанияПартнеров()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗапросПоУсловиямОбслуживания.Партнер,
	|	ЗапросПоУсловиямОбслуживания.УсловияОбслуживания,
	|	ЗапросПоУсловиямОбслуживания.Соглашение,
	|	МИНИМУМ(ЗапросПоУсловиямОбслуживания.ДатаПосещенияПоГрафику) КАК ДатаПосещенияПоГрафику
	|ИЗ
	|	(ВЫБРАТЬ
	|		УсловияОбслуживанияПартнеровТорговымиПредставителямиГрафикПосещения.Ссылка КАК УсловияОбслуживания,
	|		УсловияОбслуживанияПартнеровТорговымиПредставителямиГрафикПосещения.Ссылка.Владелец КАК Партнер,
	|		УсловияОбслуживанияПартнеровТорговымиПредставителямиГрафикПосещения.Ссылка.Соглашение КАК Соглашение,
	|		ВЫБОР
	|			КОГДА УсловияОбслуживанияПартнеровТорговымиПредставителямиГрафикПосещения.ДеньНедели = &Понедельник
	|				ТОГДА ВЫБОР
	|						КОГДА ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования) > 1
	|							ТОГДА ДОБАВИТЬКДАТЕ(&НачальнаяДатаПланирования, ДЕНЬ, 1 - ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования) + 7)
	|						ИНАЧЕ ДОБАВИТЬКДАТЕ(&НачальнаяДатаПланирования, ДЕНЬ, 1 - ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования))
	|					КОНЕЦ
	|			КОГДА УсловияОбслуживанияПартнеровТорговымиПредставителямиГрафикПосещения.ДеньНедели = &Вторник
	|				ТОГДА ВЫБОР
	|						КОГДА ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования) > 2
	|							ТОГДА ДОБАВИТЬКДАТЕ(&НачальнаяДатаПланирования, ДЕНЬ, 2 - ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования) + 7)
	|						ИНАЧЕ ДОБАВИТЬКДАТЕ(&НачальнаяДатаПланирования, ДЕНЬ, 2 - ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования))
	|					КОНЕЦ
	|			КОГДА УсловияОбслуживанияПартнеровТорговымиПредставителямиГрафикПосещения.ДеньНедели = &Среда
	|				ТОГДА ВЫБОР
	|						КОГДА ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования) > 3
	|							ТОГДА ДОБАВИТЬКДАТЕ(&НачальнаяДатаПланирования, ДЕНЬ, 3 - ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования) + 7)
	|						ИНАЧЕ ДОБАВИТЬКДАТЕ(&НачальнаяДатаПланирования, ДЕНЬ, 3 - ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования))
	|					КОНЕЦ
	|			КОГДА УсловияОбслуживанияПартнеровТорговымиПредставителямиГрафикПосещения.ДеньНедели = &Четверг
	|				ТОГДА ВЫБОР
	|						КОГДА ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования) > 4
	|							ТОГДА ДОБАВИТЬКДАТЕ(&НачальнаяДатаПланирования, ДЕНЬ, 4 - ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования) + 7)
	|						ИНАЧЕ ДОБАВИТЬКДАТЕ(&НачальнаяДатаПланирования, ДЕНЬ, 4 - ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования))
	|					КОНЕЦ
	|			КОГДА УсловияОбслуживанияПартнеровТорговымиПредставителямиГрафикПосещения.ДеньНедели = &Пятница
	|				ТОГДА ВЫБОР
	|						КОГДА ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования) > 5
	|							ТОГДА ДОБАВИТЬКДАТЕ(&НачальнаяДатаПланирования, ДЕНЬ, 5 - ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования) + 7)
	|						ИНАЧЕ ДОБАВИТЬКДАТЕ(&НачальнаяДатаПланирования, ДЕНЬ, 5 - ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования))
	|					КОНЕЦ
	|			КОГДА УсловияОбслуживанияПартнеровТорговымиПредставителямиГрафикПосещения.ДеньНедели = &Суббота
	|				ТОГДА ВЫБОР
	|						КОГДА ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования) > 6
	|							ТОГДА ДОБАВИТЬКДАТЕ(&НачальнаяДатаПланирования, ДЕНЬ, 6 - ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования) + 7)
	|						ИНАЧЕ ДОБАВИТЬКДАТЕ(&НачальнаяДатаПланирования, ДЕНЬ, 6 - ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования))
	|					КОНЕЦ
	|			КОГДА УсловияОбслуживанияПартнеровТорговымиПредставителямиГрафикПосещения.ДеньНедели = &Воскресенье
	|				ТОГДА ВЫБОР
	|						КОГДА ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования) > 7
	|							ТОГДА ДОБАВИТЬКДАТЕ(&НачальнаяДатаПланирования, ДЕНЬ, 7 - ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования) + 7)
	|						ИНАЧЕ ДОБАВИТЬКДАТЕ(&НачальнаяДатаПланирования, ДЕНЬ, 7 - ДЕНЬНЕДЕЛИ(&НачальнаяДатаПланирования))
	|					КОНЕЦ
	|			ИНАЧЕ &ПустаяДата
	|		КОНЕЦ КАК ДатаПосещенияПоГрафику
	|	ИЗ
	|		Справочник.УсловияОбслуживанияПартнеровТорговымиПредставителями.ГрафикПосещения КАК УсловияОбслуживанияПартнеровТорговымиПредставителямиГрафикПосещения
	|	ГДЕ
	|		(НЕ УсловияОбслуживанияПартнеровТорговымиПредставителямиГрафикПосещения.Ссылка.ПометкаУдаления)
	|		И УсловияОбслуживанияПартнеровТорговымиПредставителямиГрафикПосещения.Ссылка.Владелец.ОбслуживаетсяТорговымиПредставителями
	|		И УсловияОбслуживанияПартнеровТорговымиПредставителямиГрафикПосещения.Ссылка.ТорговыйПредставитель = &ТорговыйПредставитель
	|		И УсловияОбслуживанияПартнеровТорговымиПредставителямиГрафикПосещения.Ссылка.Соглашение <> ЗНАЧЕНИЕ(Справочник.СоглашенияСКлиентами.ПустаяСсылка)) КАК ЗапросПоУсловиямОбслуживания
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаданиеТорговомуПредставителю КАК ЗаданиеТорговомуПредставителю
	|		ПО ЗапросПоУсловиямОбслуживания.УсловияОбслуживания = ЗаданиеТорговомуПредставителю.УсловияОбслуживания
	|			И ЗапросПоУсловиямОбслуживания.ДатаПосещенияПоГрафику = ЗаданиеТорговомуПредставителю.ДатаВизитаПлан
	|ГДЕ
	|	ЗаданиеТорговомуПредставителю.Ссылка ЕСТЬ NULL 
	|	И (ЗапросПоУсловиямОбслуживания.ДатаПосещенияПоГрафику <= &КонечнаяДатаПланирования
	|			ИЛИ &КонечнаяДатаПланирования = &ПустаяДата)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗапросПоУсловиямОбслуживания.УсловияОбслуживания,
	|	ЗапросПоУсловиямОбслуживания.Партнер,
	|	ЗапросПоУсловиямОбслуживания.Соглашение"
	;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#Область ПроцедурыИнициализацииУсловийОбслуживания

// Формирует структура, содержащую данные об условиях обслуживания.
//
// Параметры:
// ПараметрыОтбора - Структура - содержит параметры отбора условий обслуживания.
//
// Возвращаемое значение:
//  Структура, содержащая данные об условиях обслуживания.
//
Функция ПолучитьДанныеУсловийОбслуживания(ПараметрыОтбора)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УсловияОбслуживанияПартнеровТорговымиПредставителями.Ссылка                КАК УсловияОбслуживания,
	|	УсловияОбслуживанияПартнеровТорговымиПредставителями.Соглашение            КАК Соглашение,
	|	УсловияОбслуживанияПартнеровТорговымиПредставителями.Куратор               КАК Куратор,
	|	УсловияОбслуживанияПартнеровТорговымиПредставителями.ТорговыйПредставитель КАК ТорговыйПредставитель,
	|	УсловияОбслуживанияПартнеровТорговымиПредставителями.ГрафикПосещения.(
	|		Ссылка,
	|		НомерСтроки,
	|		ДеньНедели,
	|		ВремяНачала,
	|		ВремяОкончания
	|	) КАК ГрафикПосещения
	|ИЗ
	|	Справочник.УсловияОбслуживанияПартнеровТорговымиПредставителями КАК УсловияОбслуживанияПартнеровТорговымиПредставителями"
	;
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	
	Запрос = Новый Запрос;
	
	Отбор = СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Отбор;
	Для Каждого ТекЭлемент Из ПараметрыОтбора Цикл
		ИмяОтбора = ТекЭлемент.Ключ;
		Отбор.Добавить(ИмяОтбора + "=&"+ИмяОтбора);
		Запрос.УстановитьПараметр(ИмяОтбора, ТекЭлемент.Значение);
	КонецЦикла;
	
	Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	СтруктураДанных = ПолучитьСтруктуруУсловийОбслуживания();
	ЗаполнитьЗначенияСвойств(СтруктураДанных, Выборка);
	СтруктураДанных.ГрафикПосещения = Выборка.ГрафикПосещения.Выгрузить();
	
	СтруктураВизита =
		ТорговыеПредставителиСервер.ПолучитьСтруктуруРеквизитовВизита(ТекущаяДатаСеанса(), СтруктураДанных.ГрафикПосещения);
		
	ЗаполнитьЗначенияСвойств(СтруктураДанных, СтруктураВизита);
	
	Возврат СтруктураДанных;
	
КонецФункции

Функция ПолучитьСтруктуруУсловийОбслуживания()
	
	Возврат Новый Структура("
		|УсловияОбслуживания,
		|Соглашение,
		|Куратор,
		|ТорговыйПредставитель,
		|ГрафикПосещения,
		|ДатаВизитаПлан,
		|ВремяНачала,
		|ВремяОкончания
		|");
		
КонецФункции

#КонецОбласти

#КонецОбласти
