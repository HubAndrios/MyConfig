
&НаКлиенте 
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТипНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Номенклатура, "ТипНоменклатуры");
	Если ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Услуга") Тогда
		ТекстСообщения = НСтр("ru='Качество услуг изменять нельзя.'");
		ВызватьИсключение ТекстСообщения;
	ИначеЕсли ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа") Тогда
		ТекстСообщения = НСтр("ru='Качество работ изменять нельзя.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбобщенныйУчетНекачественныхТоваров") Тогда
		Элементы.ГруппаФормаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Элементы.ГруппаФормаСтраницы.ТекущаяСтраница    = Элементы.СтраницаПоНоменклатуре;
	КонецЕсли;
	
	ТоварИсходногоКачества = РегистрыСведений.ТоварыДругогоКачества.ПолучитьТоварИсходногоКачества(Параметры.Номенклатура);
	Если ЗначениеЗаполнено(ТоварИсходногоКачества) Тогда
		Номенклатура = ТоварИсходногоКачества;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПоНоменклатуре, "Номенклатура", ТоварИсходногоКачества, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	Иначе
		ШаблонТекстаСообщения = НСтр("ru = 'Для товара %Товар% не найден товар исходного качества. Выбор товаров другого качества невозможен.'");
		ТекстСообщения = СтрЗаменить(ШаблонТекстаСообщения, "%Товар%", Параметры.Номенклатура.Наименование);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	Элементы.ГруппаСоздатьНекачественныйТовар.Видимость  = ПравоДоступа("Добавление", Метаданные.Справочники.Номенклатура);
	Элементы.ГруппаСоздатьНекачественныйТовар1.Видимость = ПравоДоступа("Добавление", Метаданные.Справочники.Номенклатура);
	Элементы.СтраницаОбщегоСписка.Видимость              = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ТоварыДругогоКачества);
	Если Элементы.СтраницаОбщегоСписка.Видимость Тогда
		ПоляНоменклатуры = Новый Структура;
		ПоляНоменклатуры.Вставить("ВидНоменклатуры");
		ПоляНоменклатуры.Вставить("ИспользоватьСерии",           "ВидНоменклатуры.ИспользоватьСерии");
		ПоляНоменклатуры.Вставить("НастройкаИспользованияСерий", "ВидНоменклатуры.НастройкаИспользованияСерий");
		РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Номенклатура, ПоляНоменклатуры);
		Если РеквизитыНоменклатуры.ИспользоватьСерии
			И Не РеквизитыНоменклатуры.НастройкаИспользованияСерий = Перечисления.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОбщийСписок,
				"ВидНоменклатуры",
				РеквизитыНоменклатуры.ВидНоменклатуры,
				ВидСравненияКомпоновкиДанных.Равно,,
				Истина);
			Элементы.СтраницаОбщегоСписка.Заголовок = НСтр("ru='Товары другого качества с видом номенклатуры товара исходного качества'");
		КонецЕсли;
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_Номенклатура" Тогда
		Если ЗначениеЗаполнено(Источник) Тогда
			УстановитьГрадациюКачества(Источник);
			Элементы.ОбщийСписок.ТекущаяСтрока = Источник;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработатьВыборНекачественнойНоменклатурыКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбщийСписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработатьВыборНекачественнойНоменклатурыКлиент();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)

	ОбработатьВыборНекачественнойНоменклатурыКлиент();

КонецПроцедуры

&НаКлиенте
Процедура СоздатьОграниченноГоднуюНоменклатуру(Команда)
	Качество = ПредопределенноеЗначение("Перечисление.ГрадацииКачества.ОграниченноГоден"); 
	СоздатьНоменклатуруСДругимКачеством(Качество);
 КонецПроцедуры

&НаКлиенте
Процедура СоздатьНеГоднуюНоменклатуру(Команда)
	Качество = ПредопределенноеЗначение("Перечисление.ГрадацииКачества.НеГоден"); 
	СоздатьНоменклатуруСДругимКачеством(Качество);
 КонецПроцедуры 
 
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Функция ПроверитьУстановитьГрадацию(ТоварИсходногоКачества, НекачественныйТовар)
	Отказ = Ложь;
	ЕстьГрадация = РегистрыСведений.ТоварыДругогоКачества.ПроверитьНаличиеГрадации(ТоварИсходногоКачества, НекачественныйТовар);
	Если Не ЕстьГрадация Тогда
		Попытка
			РегистрыСведений.ТоварыДругогоКачества.ЗаписатьСвязьСТоваромДругогоКачества(ТоварИсходногоКачества, НекачественныйТовар);
		Исключение
			Отказ = Истина;
		КонецПопытки;
	КонецЕсли;	
	
	Возврат Отказ;
КонецФункции

&НаСервере
Процедура УстановитьГрадациюКачества(НекачественныйТовар) 
	                                       
	РегистрыСведений.ТоварыДругогоКачества.ЗаписатьСвязьСТоваромДругогоКачества(Номенклатура, НекачественныйТовар);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборНекачественнойНоменклатурыКлиент()
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	ПроверятьГрадацию = Ложь;
	
	Если Элементы.ГруппаФормаСтраницы.ТекущаяСтраница = Элементы.СтраницаПоНоменклатуре Тогда
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат
		КонецЕсли;
		НекачественныйТовар = ТекущиеДанные.НоменклатураБрак;
	Иначе
		ТекущиеДанные = Элементы.ОбщийСписок.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат
		КонецЕсли;
		НекачественныйТовар = ТекущиеДанные.Ссылка;
		ПроверятьГрадацию = Истина;
		ЕстьСоответствие = Ложь;
	КонецЕсли;
	
	Если ПроверятьГрадацию Тогда
		Отказ = ПроверитьУстановитьГрадацию(Номенклатура, НекачественныйТовар);	
	КонецЕсли;
	 
	Если Не Отказ И ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(НекачественныйТовар, "ПометкаУдаления") Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбработатьВыборНекачественнойНоменклатурыКлиентЗавершение", ЭтотОбъект, Новый Структура("НекачественныйТовар, Отказ", НекачественныйТовар, Отказ)), НСтр("ru = 'Выбранные данные помечены на удаление.
			|Выполнить выбор этих данных?'") , РежимДиалогаВопрос.ДаНет);
        Возврат;
	КонецЕсли;

	ОбработатьВыборНекачественнойНоменклатурыКлиентФрагмент(НекачественныйТовар, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборНекачественнойНоменклатурыКлиентЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    НекачественныйТовар = ДополнительныеПараметры.НекачественныйТовар;
    Отказ = ДополнительныеПараметры.Отказ;
    
    
    Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОбработатьВыборНекачественнойНоменклатурыКлиентФрагмент(НекачественныйТовар, Отказ);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборНекачественнойНоменклатурыКлиентФрагмент(Знач НекачественныйТовар, Знач Отказ)
    
    Если Не Отказ Тогда
        Закрыть(НекачественныйТовар);
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СоздатьНоменклатуруСДругимКачеством(Качество)
	ПараметрыФормы = Новый Структура("ЗначениеКопирования, СозданиеНекачественногоТовара", Номенклатура, Качество);
	ОткрытьФорму(
		"Справочник.Номенклатура.ФормаОбъекта", 
		ПараметрыФормы,
		,
		,
		,
		,
		Новый ОписаниеОповещения("СоздатьНоменклатуруСДругимКачествомЗавершение", ЭтотОбъект), 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНоменклатуруСДругимКачествомЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ГруппаФормаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если Элементы.ГруппаФормаСтраницы.ТекущаяСтраница = Элементы.СтраницаПоНоменклатуре Тогда
		Элементы.СтраницыКомандныхПанелей.ТекущаяСтраница = Элементы.СтраницаКоманднаяПанельСпискаСвязанныхТоваров;
	Иначе 
		Элементы.СтраницыКомандныхПанелей.ТекущаяСтраница = Элементы.СтраницаКоманднаяПанельОбщегоСписка;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти
