#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтранаПроисхождения = Неопределено;
	Параметры.Отбор.Свойство("СтранаПроисхождения", СтранаПроисхождения);

	Если Параметры.СтрокаПоиска = Неопределено Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеСправочника.Ссылка КАК Ссылка,
		|	ДанныеСправочника.Представление КАК Представление,
		|	ДанныеСправочника.ПометкаУдаления КАК ПометкаУдаления,
		|	ДанныеСправочника.СтранаПроисхождения.Представление КАК СтранаПредставление
		|ИЗ
		|	Справочник.НомераГТД КАК ДанныеСправочника
		|ГДЕ
		|	Не ДанныеСправочника.Предопределенный
		|");
	Иначе
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 100
		                      |	ПриобретениеТоваровУслугТовары.Номенклатура,
		                      |	ПриобретениеТоваровУслугТовары.Характеристика,
		                      |	ПриобретениеТоваровУслугТовары.НомерГТД,
		                      |	ПриобретениеТоваровУслугТовары.Ссылка,
		                      |	ПриобретениеТоваровУслугТовары.Ссылка.Дата КАК Дата
		                      |ПОМЕСТИТЬ СочетанияНоменклатураГТД
		                      |ИЗ
		                      |	Документ.ПриобретениеТоваровУслуг.Товары КАК ПриобретениеТоваровУслугТовары
		                      |ГДЕ
		                      |	ПриобретениеТоваровУслугТовары.Номенклатура = &Номенклатура
		                      |	И ПриобретениеТоваровУслугТовары.Характеристика = &Характеристика
		                      |	И ПриобретениеТоваровУслугТовары.Ссылка.Проведен
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ ПЕРВЫЕ 100
		                      |	ОприходованиеИзлишковТоваровТовары.Номенклатура,
		                      |	ОприходованиеИзлишковТоваровТовары.Характеристика,
		                      |	ОприходованиеИзлишковТоваровТовары.НомерГТД,
		                      |	ОприходованиеИзлишковТоваровТовары.Ссылка,
		                      |	ОприходованиеИзлишковТоваровТовары.Ссылка.Дата
		                      |ИЗ
		                      |	Документ.ОприходованиеИзлишковТоваров.Товары КАК ОприходованиеИзлишковТоваровТовары
		                      |ГДЕ
		                      |	ОприходованиеИзлишковТоваровТовары.Номенклатура = &Номенклатура
		                      |	И ОприходованиеИзлишковТоваровТовары.Характеристика = &Характеристика
		                      |	И ОприходованиеИзлишковТоваровТовары.Ссылка.Проведен
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ ПЕРВЫЕ 100
		                      |	КорректировкаПриобретенияТовары.Номенклатура,
		                      |	КорректировкаПриобретенияТовары.Характеристика,
		                      |	КорректировкаПриобретенияТовары.НомерГТД,
		                      |	КорректировкаПриобретенияТовары.Ссылка,
		                      |	КорректировкаПриобретенияТовары.Ссылка.Дата
		                      |ИЗ
		                      |	Документ.КорректировкаПриобретения.Товары КАК КорректировкаПриобретенияТовары
		                      |ГДЕ
		                      |	КорректировкаПриобретенияТовары.Номенклатура = &Номенклатура
		                      |	И КорректировкаПриобретенияТовары.Характеристика = &Характеристика
		                      |	И КорректировкаПриобретенияТовары.Ссылка.Проведен
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ ПЕРВЫЕ 100
		                      |	ПересортицаТоваровТовары.Номенклатура,
		                      |	ПересортицаТоваровТовары.Характеристика,
		                      |	ПересортицаТоваровТовары.НомерГТД,
		                      |	ПересортицаТоваровТовары.Ссылка,
		                      |	ПересортицаТоваровТовары.Ссылка.Дата
		                      |ИЗ
		                      |	Документ.ПересортицаТоваров.Товары КАК ПересортицаТоваровТовары
		                      |ГДЕ
		                      |	ПересортицаТоваровТовары.Номенклатура = &Номенклатура
		                      |	И ПересортицаТоваровТовары.Характеристика = &Характеристика
		                      |	И ПересортицаТоваровТовары.Ссылка.Проведен
		                      |
		                      |ОБЪЕДИНИТЬ ВСЕ
		                      |
		                      |ВЫБРАТЬ ПЕРВЫЕ 100
		                      |	ТаможеннаяДекларацияИмпортТовары.Номенклатура,
		                      |	ТаможеннаяДекларацияИмпортТовары.Характеристика,
		                      |	ТаможеннаяДекларацияИмпортТовары.НомерГТД,
		                      |	ТаможеннаяДекларацияИмпортТовары.Ссылка,
		                      |	ТаможеннаяДекларацияИмпортТовары.Ссылка.Дата
		                      |ИЗ
		                      |	Документ.ТаможеннаяДекларацияИмпорт.Товары КАК ТаможеннаяДекларацияИмпортТовары
		                      |ГДЕ
		                      |	ТаможеннаяДекларацияИмпортТовары.Номенклатура = &Номенклатура
		                      |	И ТаможеннаяДекларацияИмпортТовары.Характеристика = &Характеристика
		                      |	И ТаможеннаяДекларацияИмпортТовары.Ссылка.Проведен
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	Дата УБЫВ
		                      |;
		                      |
		                      |////////////////////////////////////////////////////////////////////////////////
		                      |ВЫБРАТЬ РАЗРЕШЕННЫЕ
		                      |	ДанныеСправочника.Ссылка КАК Ссылка,
		                      |	ДанныеСправочника.Представление КАК Представление,
		                      |	ДанныеСправочника.ПометкаУдаления КАК ПометкаУдаления,
		                      |	ДанныеСправочника.СтранаПроисхождения.Представление КАК СтранаПредставление,
		                      |	МАКСИМУМ(СочетанияНоменклатураГТД.Дата) КАК Порядок
		                      |ИЗ
		                      |	Справочник.НомераГТД КАК ДанныеСправочника
		                      |		ЛЕВОЕ СОЕДИНЕНИЕ СочетанияНоменклатураГТД КАК СочетанияНоменклатураГТД
		                      |		ПО (СочетанияНоменклатураГТД.НомерГТД = ДанныеСправочника.Ссылка)
		                      |ГДЕ
		                      |	ДанныеСправочника.Код ПОДОБНО &СтрокаПоиска
		                      |	И (НЕ &ОтборПоСтране
		                      |			ИЛИ ДанныеСправочника.СтранаПроисхождения = &Страна)
		                      |
		                      |СГРУППИРОВАТЬ ПО
		                      |	ДанныеСправочника.Ссылка,
		                      |	ДанныеСправочника.Представление,
		                      |	ДанныеСправочника.ПометкаУдаления,
		                      |	ДанныеСправочника.СтранаПроисхождения.Представление
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	Порядок УБЫВ");
		Запрос.УстановитьПараметр("Номенклатура", ?(Параметры.Свойство("Номенклатура"),Параметры.Номенклатура,Неопределено));
		Запрос.УстановитьПараметр("Характеристика", ?(Параметры.Свойство("Характеристика"),Параметры.Характеристика,Неопределено));
		Запрос.УстановитьПараметр("СтрокаПоиска", Параметры.СтрокаПоиска + "%");
		Запрос.УстановитьПараметр("ОтборПоСтране", ЗначениеЗаполнено(СтранаПроисхождения));
		Запрос.УстановитьПараметр("Страна", СтранаПроисхождения);
	КонецЕсли;
	
	ДанныеВыбора = Новый СписокЗначений;
	ВыборкаГТД = Запрос.Выполнить().Выбрать();
	Пока ВыборкаГТД.Следующий() Цикл
		ЭлементВыбора = Новый Структура("Значение, ПометкаУдаления", ВыборкаГТД.Ссылка, ВыборкаГТД.ПометкаУдаления);
		Представление = СокрЛП(ВыборкаГТД.Представление)
			+ ?(ЗначениеЗаполнено(ВыборкаГТД.СтранаПредставление), " (" + ВыборкаГТД.СтранаПредставление + ")", "");
		ДанныеВыбора.Добавить(ЭлементВыбора, Представление);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

