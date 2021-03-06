#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		 И ДанныеЗаполнения.Свойство("ПериодРегистрации") Тогда
		Дата = ДанныеЗаполнения.ПериодРегистрации;
	КонецЕсли;
	
	ЗаполнитьРеквизитыПоУмолчанию();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ВыручкаНДС0 = 0;
	ДокументыЭкспорт.Очистить();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьДублиДокументов(Отказ);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	НеобходимоРаспределениеНДСПоТоварам = Документы.РаспределениеНДС.НеобходимоРаспределениеНДСПоТоварам(Организация, Дата); 
	Если НЕ НеобходимоРаспределениеНДСПоТоварам И СписатьНДСПоРасходамАктивамНаСтатьиОтражения Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходовНеНДС");
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходовЕНВД");
	Иначе
		Если ВыручкаЕНВД = 0 Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходовЕНВД");
		КонецЕсли;
		Если ВыручкаНеНДС = 0 Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходовНеНДС");
		КонецЕсли;
	КонецЕсли;
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,
		"СтатьяРасходовНеНДС, АналитикаРасходовНеНДС, СтатьяРасходовЕНВД, АналитикаРасходовЕНВД",
		МассивНепроверяемыхРеквизитов,
		Отказ);
	 
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если ВыручкаНДС = 0 И ВыручкаНеНДС = 0 И ВыручкаЕНВД = 0 И ВыручкаНДС0 = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не определена база распределения НДС. Распределение не может быть выполнено.'"), ЭтотОбъект, , , Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.РаспределениеНДС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	Если НЕ Отказ Тогда
		МассивДокументов = Новый Массив;
		МассивДокументов.Добавить(Ссылка);
		РегистрыСведений.ЗаданияКФормированиюЗаписейКнигиПокупокПродаж.СформироватьЗаданияПоДокументам(МассивДокументов);
	КонецЕсли;
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#Область ЗаполнениеДокумента

Процедура ЗаполнитьРеквизитыПоУмолчанию()

	Ответственный	= Пользователи.ТекущийПользователь();
	Организация		= ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	ПравилаСписания = Документы.РаспределениеНДС.ЗаполнитьПравилаСписанияНДС(Организация);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект,ПравилаСписания);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьДублиДокументов (Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РаспределениеНДС.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.РаспределениеНДС КАК РаспределениеНДС
		|ГДЕ
		|	РаспределениеНДС.Проведен
		|	И РаспределениеНДС.Организация = &Организация
		|	И РаспределениеНДС.Дата МЕЖДУ &ПериодНачало И &ПериодОкончание
		|	И НЕ РаспределениеНДС.Ссылка = &ТекущийДокумент");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ПериодНачало", НачалоКвартала(Дата));
	Запрос.УстановитьПараметр("ПериодОкончание", КонецКвартала(Дата));
	Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		
		ПредставлениеПериода = ПредставлениеПериода(НачалоКвартала(Дата), КонецКвартала(Дата), "ДЛФ=D");
		
		
		ШаблонТекста = НСтр("ru = 'В налоговом периоде ""%1"" уже есть проведенный документ ""Распределение НДС"" для организации %2'");
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, ПредставлениеПериода, Организация);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "Дата", , Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
