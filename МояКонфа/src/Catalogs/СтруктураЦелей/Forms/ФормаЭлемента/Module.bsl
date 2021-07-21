
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// Заполнение списка схем компоновки данных
	ПризнакПредопределенногоМакета = Врег("Предопределенный");
	ДлинаПризнакаПредопределенногоМакета = СтрДлина(ПризнакПредопределенногоМакета);
	Для каждого Макет из Метаданные.НайтиПоТипу(ТипЗнч(Объект.Ссылка)).Макеты Цикл
		Если Макет.ТипМакета = Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
			Если ВРег(Прав(Макет.Имя, ДлинаПризнакаПредопределенногоМакета)) = ПризнакПредопределенногоМакета Тогда
				Элементы.СхемаКомпоновкиДанных.СписокВыбора.Добавить(Макет.Имя, Макет.Синоним);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.СхемаКомпоновкиДанных.СписокВыбора.Добавить("", НСтр("ru = 'Произвольный'"));
	
	Если Параметры.ЗначениеКопирования.Пустая() Тогда
		СхемаИНастройки = Справочники.СтруктураЦелей.ОписаниеИСхемаКомпоновкиДанныхЦелиПоИмениМакета(Объект.Ссылка, Объект.СхемаКомпоновкиДанных);
	Иначе
		СхемаИНастройки = Справочники.СтруктураЦелей.ОписаниеИСхемаКомпоновкиДанныхЦелиПоИмениМакета(Параметры.ЗначениеКопирования, Параметры.ЗначениеКопирования.СхемаКомпоновкиДанных);
	КонецЕсли;
	
	Если ПустаяСтрока(СхемаИНастройки.Описание) Тогда
		Объект.СхемаКомпоновкиДанных = "";
	КонецЕсли;
	
	Адреса = АдресаСхемыКомпоновкиДанныхИНастроекВоВременномХранилище();
	
	АдресСхемыКомпоновкиДанных = Адреса.СхемаКомпоновкиДанных;
	АдресНастроекКомпоновкиДанных = Адреса.НастройкиКомпоновкиДанных;
	
	УстановитьДоступностьИВидимостьЭлементовФормы(Объект, Элементы, РазмерностьДоступна());
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Объект.ЦельИзмеримая Тогда
		
		Если Не ЗначениеЗаполнено(ТекущийОбъект.СхемаКомпоновкиДанных) 
			Или ТекущийОбъект.СхемаКомпоновкиДанных = "ШаблоннаяСхемаКомпоновкиДанных" Тогда
			
			Если НЕ ПустаяСтрока(АдресСхемыКомпоновкиДанных) Тогда
				
				РезультатПроверкиСКД = МониторингЦелевыхПоказателей.ПроверитьСхемуКомпоновкиДанных(ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных));
				
				Если РезультатПроверкиСКД.МакетКорректный Тогда
					ТекущийОбъект.ХранилищеСхемыКомпоновкиДанных = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных));
					
				Иначе
					Отказ = Истина;
					
					Для Каждого ОписаниеОшибки Из РезультатПроверкиСКД.ОписаниеОшибок Цикл
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки, Объект.Ссылка, "Объект.СхемаКомпоновкиДанных",,Отказ);
						
					КонецЦикла; 
					
				КонецЕсли;
			Иначе
				Отказ = Истина;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Необходимо настроить шаблон расчета целевого показателя.'"), Объект.Ссылка, "Объект.СхемаКомпоновкиДанных",,Отказ);
			КонецЕсли;
			
		Иначе
			ТекущийОбъект.ХранилищеСхемыКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(АдресНастроекКомпоновкиДанных) Тогда
			ТекущийОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресНастроекКомпоновкиДанных));
		Иначе
			ТекущийОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
		КонецЕсли;
		
	КонецЕсли;

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СхемаКомпоновкиДанныхПриИзменении(Элемент)
	
	СхемаКомпоновкиДанныхПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦельИзмеримаяПриИзменении(Элемент)
	
	УстановитьДоступностьИВидимостьЭлементовФормы(Объект, Элементы, РазмерностьДоступна());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РедактироватьСхемуКомпоновкиДанных(Команда)
	
	// Открыть редактор настроек схемы компоновки данных
	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = НСтр("ru = 'Настройка шаблона расчета для целевого показателя ""%1""'");
	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = СтрЗаменить(ЗаголовокФормыНастройкиСхемыКомпоновкиДанных, "%1", Объект.ЦелевойПоказатель);
	
	АдресаНастроек = Неопределено;
	
	ПараметрыФормы = Новый Структура("
		|НеПомещатьНастройкиВСхемуКомпоновкиДанных,
		|НеРедактироватьСхемуКомпоновкиДанных,
		|НеНастраиватьУсловноеОформление,
		|НеНастраиватьВыбор,
		|НеНастраиватьПорядок,
		|УникальныйИдентификатор,
		|АдресСхемыКомпоновкиДанных,
		|АдресНастроекКомпоновкиДанных,
		|Заголовок,
		|ИсточникШаблонов,
		|ИмяШаблонаСКД,
		|ВозвращатьИмяТекущегоШаблонаСКД"); 
		
	ПараметрыФормы.Вставить("НеПомещатьНастройкиВСхемуКомпоновкиДанных", Истина);
	ПараметрыФормы.Вставить("НеРедактироватьСхемуКомпоновкиДанных", Ложь);
	ПараметрыФормы.Вставить("НеНастраиватьУсловноеОформление", Истина);
	ПараметрыФормы.Вставить("НеНастраиватьВыбор", Истина);
	ПараметрыФормы.Вставить("НеНастраиватьПорядок", Ложь);
	ПараметрыФормы.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыФормы.Вставить("АдресСхемыКомпоновкиДанных", АдресСхемыКомпоновкиДанных);
	ПараметрыФормы.Вставить("АдресНастроекКомпоновкиДанных", АдресНастроекКомпоновкиДанных);
	ПараметрыФормы.Вставить("Заголовок", ЗаголовокФормыНастройкиСхемыКомпоновкиДанных);
	ПараметрыФормы.Вставить("ИсточникШаблонов", Объект.Ссылка);
	ПараметрыФормы.Вставить("ИмяШаблонаСКД", Объект.СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("ВозвращатьИмяТекущегоШаблонаСКД", Истина);
		
	ОткрытьФорму("ОбщаяФорма.УпрощеннаяНастройкаСхемыКомпоновкиДанных", 
		ПараметрыФормы,,,,, 
		Новый ОписаниеОповещения("РедактироватьСхемуКомпоновкиДанныхЗавершение", ЭтотОбъект), 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСхемуКомпоновкиДанныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    АдресаНастроек = Результат;
    
    Если ЗначениеЗаполнено(АдресаНастроек) Тогда
        Если ПустаяСтрока(АдресаНастроек.ИмяТекущегоШаблонаСКД) 
            И Элементы.СхемаКомпоновкиДанных.СписокВыбора.НайтиПоЗначению("") = Неопределено Тогда
            Элементы.СхемаКомпоновкиДанных.СписокВыбора.Добавить("", НСтр("ru = 'Произвольный'"));
            
        КонецЕсли;
        
        Объект.СхемаКомпоновкиДанных = АдресаНастроек.ИмяТекущегоШаблонаСКД;
        
        Если АдресаНастроек.Свойство("АдресХранилищаНастройкиКомпоновщика") Тогда
            АдресНастроекКомпоновкиДанных = АдресаНастроек.АдресХранилищаНастройкиКомпоновщика;
        КонецЕсли;
        
    КонецЕсли;
    
    УстановитьДоступностьИВидимостьЭлементовФормы(Объект, Элементы, РазмерностьДоступна());

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура СхемаКомпоновкиДанныхПриИзмененииНаСервере()
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(Справочники.СтруктураЦелей.ПолучитьМакет(Объект.СхемаКомпоновкиДанных), Новый УникальныйИдентификатор());
	АдресНастроекКомпоновкиДанных = "";
	
	Элементы.СхемаКомпоновкиДанных.СписокВыбора.Удалить(Элементы.СхемаКомпоновкиДанных.СписокВыбора.НайтиПоЗначению(""));
	
	УстановитьДоступностьИВидимостьЭлементовФормы(Объект, Элементы, РазмерностьДоступна());
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
Процедура УстановитьДоступностьИВидимостьЭлементовФормы(Объект, Элементы, РазмерностьДоступна)
	
	ЦельИзмеримая = Объект.ЦельИзмеримая;
	
	Элементы.ЦелевойПоказатель.Доступность = ЦельИзмеримая;
	Элементы.КраткоеНаименованиеЦелевогоПоказателя.Доступность = ЦельИзмеримая;
	Элементы.Описание.Доступность = ЦельИзмеримая;
	Элементы.ФормулаРасчета.Доступность = ЦельИзмеримая;
	Элементы.ГруппаСхемаКомпоновкиДанных.Доступность = ЦельИзмеримая;
	Элементы.ЦелевойТренд.Доступность = ЦельИзмеримая;
	
	Элементы.Размерность.Видимость = (ЦельИзмеримая И РазмерностьДоступна);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере 
Функция АдресаСхемыКомпоновкиДанныхИНастроекВоВременномХранилище()
	
	Возврат Справочники.СтруктураЦелей.АдресаСхемыКомпоновкиДанныхИНастроекВоВременномХранилище(Объект);
	
КонецФункции

&НаСервере  
Функция РазмерностьДоступна()
	
	РазмерностьДоступна = Истина;
	
	Если НЕ ПустаяСтрока(АдресСхемыКомпоновкиДанных) Тогда
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
		
		Если НЕ СхемаКомпоновкиДанных = Неопределено 
			И НЕ СхемаКомпоновкиДанных.Параметры.Найти("ВалютаРасчета") = Неопределено
			И СхемаКомпоновкиДанных.Параметры.Найти("ВалютаРасчета").Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда Тогда
			РазмерностьДоступна = Ложь;
		КонецЕсли;
		
	ИначеЕсли НЕ ПустаяСтрока(АдресНастроекКомпоновкиДанных) Тогда
		НастройкиКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресНастроекКомпоновкиДанных);
		
		Если НЕ НастройкиКомпоновкиДанных = Неопределено 
			И НЕ НастройкиКомпоновкиДанных.Параметры.Найти("ВалютаРасчета") = Неопределено 
			И НастройкиКомпоновкиДанных.Параметры.Найти("ВалютаРасчета").Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда Тогда
			РазмерностьДоступна = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат РазмерностьДоступна;
	
КонецФункции

#КонецОбласти

#КонецОбласти
