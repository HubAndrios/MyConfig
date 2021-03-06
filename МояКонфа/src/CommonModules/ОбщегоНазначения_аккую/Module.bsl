Функция СравнитьСпоследнимДокументом(Документ)
	ТзТЧТекущего = Документ.Товары.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостояниеОборудованияСрезПоследних.Регистратор КАК Документ
	|ИЗ
	|	РегистрСведений.пр_СостояниеОборудования.СрезПоследних(&ВыбраннаяДата, Номенклатура В (&ТзНоменклатура)) КАК СостояниеОборудованияСрезПоследних
	|ГДЕ
	|	СостояниеОборудованияСрезПоследних.Регистратор ССЫЛКА Документ."+Документ.Метаданные().Имя;
	Запрос.УстановитьПараметр("Документ",Документ);
	Запрос.УстановитьПараметр("ТзНоменклатура",ТзТЧТекущего.ВыгрузитьКолонку("Номенклатура"));
	МоментВремени =  Новый Граница(Документ.Дата-60, ВидГраницы.Исключая);	 
	Запрос.УстановитьПараметр("ВыбраннаяДата",МоментВремени ); 
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ДокПоследний = Неопределено;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ДокПоследний =  ВыборкаДетальныеЗаписи.Документ;
	КонецЦикла;
	
	Если ДокПоследний<>Неопределено Тогда
		
		ТзТЧПоследнего = ДокПоследний.Товары.Выгрузить();	
		Если ТзТЧТекущего.Количество()<>ТзТЧПоследнего.Количество() Тогда
			Возврат Ложь;
		КонецЕсли;
		Для Каждого СтрокаТЧт из ТзТЧТекущего Цикл
			Отбор = Новый Структура();
			Для Каждого Колонка из ТзТЧТекущего.Колонки Цикл
				Отбор.Вставить(Колонка.Имя,СтрокаТЧт[Колонка.Имя]);
			КонецЦикла;
			
			СтрокаТЧп = ТзТЧПоследнего.НайтиСтроки(Отбор);
			Если СтрокаТЧп.Количество() = 0 Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	
	Возврат Истина;
КонецФункции


Процедура ОтразитьСостояниеОборудованияПоДокументу(Документ) Экспорт 
	ТзТЧ = Документ.Товары.Выгрузить();

	//НесоответствиеДокумента=не СравнитьСпоследнимДокументом(Документ));
	
	
	НовыйНаборЗаписей = РегистрыСведений.пр_СостояниеОборудования.СоздатьНаборЗаписей();
	НовыйНаборЗаписей.Отбор.Регистратор.Установить(Документ.Ссылка);
	ЕстьДатаПоставки = Ложь;
	Если Документ.Метаданные().ТабличныеЧасти.Товары.Реквизиты.Найти("ДатаПоставки") <> Неопределено Тогда
		ЕстьДатаПоставки = Истина;
	КонецЕсли;
	ЕстьДатаПоставкиА = Ложь;
	Если Документ.Метаданные().ТабличныеЧасти.Товары.Реквизиты.Найти("ДатаПоставки") <> Неопределено Тогда
		ЕстьДатаПоставкиА = Истина;
	КонецЕсли;
	
	
	Для Каждого строка из Документ.Товары Цикл
		НетНоменклатуры = Ложь;
		НесоответствиеНоменклатуры=Ложь;
		ВыходЗаГраничныеУсловия=Ложь;
		НесоответствиеДокумента=Ложь;


		Если строка.Номенклатура.Пустая() Тогда
			НетНоменклатуры=Истина;
		КонецЕсли;

		Для Каждого Колонка из ТзТЧ.Колонки Цикл
			Если Найти(Колонка.Имя,"фл")>0 Тогда
				Если строка[Колонка.Имя] Тогда
					НесоответствиеНоменклатуры=Истина;
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		
		НоваяЗаписьНабора = НовыйНаборЗаписей.Добавить();
		НоваяЗаписьНабора.Период = Документ.Дата;
		НоваяЗаписьНабора.Номенклатура = строка.Номенклатура;
		НоваяЗаписьНабора.КодОборудования = строка.КодОборудования;
		НоваяЗаписьНабора.Состояние = Документ.Состояние;
		НоваяЗаписьНабора.НетНоменклатуры = НетНоменклатуры;
		НоваяЗаписьНабора.НесоответствиеНоменклатуры = НесоответствиеНоменклатуры;
		НоваяЗаписьНабора.НесоответствиеДокумента = НесоответствиеДокумента;
		НоваяЗаписьНабора.ВыходЗаГраничныеУсловия = ВыходЗаГраничныеУсловия;
		Если ЕстьДатаПоставки Тогда
			НоваяЗаписьНабора.ДатаПоставки = строка.ДатаПоставки;
		КонецЕсли;
		//Если ЕстьДатаПоставкиА Тогда
		//	НоваяЗаписьНабора.ДатаПоставкиФакт = строка.ДатаПоставкиФакт;
		//КонецЕсли;
		НовыйНаборЗаписей.Записать();
	КонецЦикла;
КонецПроцедуры

Функция СоздатьОписаниеТипов(НазваниеТипа,Длина,Точность="")
	мас = Новый Массив;
	мас.Добавить(Тип(НазваниеТипа));
	Если Точность = "" Тогда
		КвалифСтроки = Новый КвалификаторыСтроки(Длина,
		ДопустимаяДлина.переменная)
	Иначе
		КвалифЧисла = Новый КвалификаторыЧисла(ДопустимыйЗнак.Любой,
		Длина,Точность);
	КонецЕсли;
	Возврат Новый ОписаниеТипов(мас, квалифСтроки, КвалифЧисла);
КонецФункции

Функция ПолучитьСостояниеПоДокументам(Объект) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СостояниеОборудования.Регистратор КАК Регистратор,
		|	СостояниеОборудования.Состояние КАК Состояние
		|ИЗ
		|	РегистрСведений.пр_СостояниеОборудования КАК СостояниеОборудования
		|ГДЕ
		|	СостояниеОборудования.Номенклатура = &Номенклатура";
	
	Запрос.УстановитьПараметр("Номенклатура", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	       
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	тз = Новый ТаблицаЗначений;
	//ТипКолНаим = СоздатьОписаниеТипов("Перечисления");
	тз.Колонки.Добавить("Регистратор",  Новый ОписаниеТипов("ПеречислениеСсылка.пр_ВидыДокументовПроцесса"));
	тз.Колонки.Добавить("Состояние",Новый ОписаниеТипов("ПеречислениеСсылка.СтатусыЛота, ПеречислениеСсылка.СтатусыДоговора, ПеречислениеСсылка.СтатусыЗаявкиТАЕК, Строка, ПеречислениеСсылка.СтатусыАктаВК, ПеречислениеСсылка.СтатусыЛогистики"));
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Строки = тз.Добавить();
		Строки.Регистратор = Перечисления.пр_ВидыДокументовПроцесса[ВыборкаДетальныеЗаписи.Регистратор.Метаданные().Имя];
		Строки.Состояние =  ВыборкаДетальныеЗаписи.Состояние;
	КонецЦикла;
	
	Если тз.Количество()>0 Тогда
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТЗ1.Регистратор КАК ВидДокумента,
		|	ТЗ1.Состояние КАК Состояние
		|ПОМЕСТИТЬ ТЗСОСТОЯНИЙ
		|ИЗ
		|	&ТЗ КАК ТЗ1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПоследовательностьПроцессныхСтатусов.Последовательность КАК Последовательность,
		|	ПоследовательностьПроцессныхСтатусов.ВидДокумента КАК Регистратор,
		|	ТЗСОСТОЯНИЙ.Состояние КАК Состояние
		|ИЗ
		|	РегистрСведений.пр_ПоследовательностьПроцессныхСтатусов КАК ПоследовательностьПроцессныхСтатусов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТЗСОСТОЯНИЙ КАК ТЗСОСТОЯНИЙ
		|		ПО ПоследовательностьПроцессныхСтатусов.ВидДокумента = ТЗСОСТОЯНИЙ.ВидДокумента
		|
		|УПОРЯДОЧИТЬ ПО
		|	Последовательность";
	
		Запрос.УстановитьПараметр("ТЗ", тз);
		тз = Запрос.Выполнить().Выгрузить();
		
	КонецЕсли;
	

	
	Возврат тз;
КонецФункции


Функция ПолучитьСостояниеОборудования(Объект) Экспорт
	тзСостояний = ПолучитьСостояниеПоДокументам(Объект);
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТЗ1.Регистратор КАК ВидДокумента,
		|	ТЗ1.Состояние КАК Состояние
		|ПОМЕСТИТЬ ТЗСОСТОЯНИЙ
		|ИЗ
		|	&ТЗ КАК ТЗ1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПоследовательностьПроцессныхСтатусов.Последовательность КАК Последовательность,
		|	ПоследовательностьПроцессныхСтатусов.ВидДокумента КАК ВидДокумента,
		|	ПоследовательностьПроцессныхСтатусов.СтатусОК КАК СтатусОК,
		|	ТЗСОСТОЯНИЙ.Состояние КАК Состояние
		//,
		//|	ВЫБОР
		//|		КОГДА ЗНАЧЕНИЕ(ПоследовательностьПроцессныхСтатусов.СтатусОК) В (ЗНАЧЕНИЕ(ТЗСОСТОЯНИЙ.Состояние))
		//|			ТОГДА 3
		//|		ИНАЧЕ 1
		//|	КОНЕЦ КАК ЗначениеСостояния
		|ИЗ
		|	РегистрСведений.пр_ПоследовательностьПроцессныхСтатусов КАК ПоследовательностьПроцессныхСтатусов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТЗСОСТОЯНИЙ КАК ТЗСОСТОЯНИЙ
		|		ПО ПоследовательностьПроцессныхСтатусов.ВидДокумента = ТЗСОСТОЯНИЙ.ВидДокумента";
	
		Запрос.УстановитьПараметр("ТЗ", тзСостояний);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Минимум=99;	
		Максимум=1;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Если ВыборкаДетальныеЗаписи.СтатусОК = ВыборкаДетальныеЗаписи.Состояние Тогда
				ЗначениеСостояния=3;
			Иначе 
				ЗначениеСостояния=1;
			КонецЕсли;
			
				
			
			Минимум = Мин(Минимум,ЗначениеСостояния);
			Максимум = Макс(Максимум,ЗначениеСостояния);
		КонецЦикла;
		
		СтатусОборудования="";
		Если Максимум>Минимум и Максимум = 3 Тогда
			СтатусОборудования = "В процессе";
		ИначеЕсли Максимум = Минимум и Максимум = 3 Тогда
			СтатусОборудования = "Готово";
		ИначеЕсли  Максимум < 3 Тогда
			СтатусОборудования = "Не готово";
		КонецЕсли;
		
	
	Возврат СтатусОборудования;
КонецФункции

Функция ПолучитьСуществующийДокументПоНомеру(Номенклатура,КодОборудования,ВидДокумента)Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СостояниеОборудования.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.пр_СостояниеОборудования КАК СостояниеОборудования
		|ГДЕ
		|	СостояниеОборудования.Номенклатура = &Номенклатура
		|	И СостояниеОборудования.КодОборудования = &КодОборудования
		|	И СостояниеОборудования.Регистратор ССЫЛКА Документ."+ВидДокумента;
	
		
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("КодОборудования", КодОборудования);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Регистратор;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

Процедура РаскраситьНеВалидныеСтрокиКрасным(Форма) Экспорт  
    
	//МассивИменКолонокДляПодсветки = Новый Массив;
	//Для каждого Стр из Элементы.Товары.ПодчиненныеЭлементы Цикл
	//    МассивИменКолонокДляПодсветки.Добавить(Стр.Имя);
	//КонецЦикла;
	ЕстьРабота=Ложь;
	Для каждого Стр из Форма.Элементы.Товары.ПодчиненныеЭлементы Цикл
		Если Стр.Имя ="флРабота" Тогда
			ЕстьРабота=Истина;
		КонецЕсли;
		
	КонецЦикла;	
	
	СписокПолейСФлагоми = Новый Соответствие;
	СписокПолейСФлагоми.Вставить("флТехХарактеристика","ТоварыТехХарактеристика");
	СписокПолейСФлагоми.Вставить("флКодОборудования","ТоварыКодОборудования");
	СписокПолейСФлагоми.Вставить("флНаименование","ТоварыНаименование");
	Если ЕстьРабота Тогда
	СписокПолейСФлагоми.Вставить("флРабота","ТоварыИДРаботы");
	КонецЕсли;


	Для каждого Ст из СписокПолейСФлагоми Цикл
		МассивИменКолонокДляПодсветки = Новый Массив;

		МассивИменКолонокДляПодсветки.Добавить(Форма.Элементы.Товары.ПодчиненныеЭлементы[Ст.Значение].Имя);
		
	    ЭлементОформления = Форма.УсловноеОформление.Элементы.Добавить();
	    ЭлементОформления.Использование = Истина;
	    ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона",  ЦветаСтиля.ОшибкаПолнотекстовыйПоискФон);
	    
	    ЭлементУсловия                = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	    ЭлементУсловия.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.Товары."+Ст.Ключ);
	    ЭлементУсловия.ПравоеЗначение = Ложь;
		ЭлементУсловия.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;   
	    ЭлементУсловия.Использование  = Истина;
		
		Для каждого ТекЭлемент из МассивИменКолонокДляПодсветки Цикл
			ОформляемоеПоле      = ЭлементОформления.Поля.Элементы.Добавить();
			ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ТекЭлемент);
		КонецЦикла;
		 
	КонецЦикла;
   
КонецПроцедуры

Процедура ОтразитьОборудованиеВГрафикеРабот(Документ) Экспорт 
	
	
	НовыйНаборЗаписей = РегистрыСведений.пр_СвязьОборудованияИГрафикаРабот.СоздатьНаборЗаписей();
	НовыйНаборЗаписей.Отбор.Регистратор.Установить(Документ.Ссылка);
	Для Каждого ТЧ из Документ.Метаданные().ТабличныеЧасти Цикл 
		
		Для Каждого строка из Документ[ТЧ.Имя] Цикл
			//Если ТЧ.Реквизиты.Найти("ИДРаботы") <> Неопределено Тогда 
				Если ЗначениеЗаполнено(строка.ИДРаботы) Тогда
					Работа = НайтиРаботуВГрафике(строка.ИДРаботы,строка.НомерБлока);
				Иначе
					Работа = строка.Работа;
				КонецЕсли;
			//КонецЕсли;
			
			
			НоваяЗаписьНабора = НовыйНаборЗаписей.Добавить();
			НоваяЗаписьНабора.Период = Документ.Дата;
			НоваяЗаписьНабора.Номенклатура = строка.Номенклатура;
			НоваяЗаписьНабора.КодОборудования = строка.КодОборудования;
			НоваяЗаписьНабора.Работа = Работа;
			НоваяЗаписьНабора.НомерБлока = строка.НомерБлока;
			НоваяЗаписьНабора.ИДРаботы = строка.ИДРаботы;
			
			НовыйНаборЗаписей.Записать();
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Функция НайтиРаботуВГрафике(ИДРаботы,НомерБлока) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	пр_РаботыПроектаСооружений.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.пр_РаботыПроектаСооружений КАК пр_РаботыПроектаСооружений
		|ГДЕ
		|	пр_РаботыПроектаСооружений.ЭтоГруппа = ЛОЖЬ
		|	И пр_РаботыПроектаСооружений.НомерБлока = &НомерБлока
		|	И пр_РаботыПроектаСооружений.Код = &Код
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	пр_РаботыПроектаСооружений.Ссылка
		|ИЗ
		|	Справочник.пр_РаботыПроектаСооружений КАК пр_РаботыПроектаСооружений
		|ГДЕ
		|	пр_РаботыПроектаСооружений.ЭтоГруппа = ЛОЖЬ
		|	И пр_РаботыПроектаСооружений.НомерБлока = &НомерБлока
		|	И пр_РаботыПроектаСооружений.КодОборудования = &Код";
	
	Запрос.УстановитьПараметр("Код", СокрЛП(ИДРаботы));
	Запрос.УстановитьПараметр("НомерБлока", НомерБлока);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Ссылка) Тогда
			Возврат  ВыборкаДетальныеЗаписи.Ссылка;
		КонецЕсли;
	КонецЦикла;

	Возврат Неопределено;
	
КонецФункции
