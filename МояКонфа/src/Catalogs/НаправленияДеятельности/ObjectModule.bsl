
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Статус.Пустая() Тогда
		Статус = Перечисления.СтатусыНаправленияДеятельности.Используется;
	КонецЕсли;
	
	Если УчетЗатрат И Не ЗначениеЗаполнено(ВариантОбособления) Тогда
		
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбособленноеОбеспечениеЗаказов") Тогда
			ВариантОбособления = Перечисления.ВариантыОбособленияПоНаправлениюДеятельности.ПоЗаказамНаправления;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЭтоНовый() И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ВариантОбособления") <> ВариантОбособления Тогда
		
		Если ВариантОбособления <> Перечисления.ВариантыОбособленияПоНаправлениюДеятельности.ПоНаправлениюВЦелом Тогда
			
			Запрос = Новый Запрос();
			Запрос.Текст =
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	1
				|ИЗ
				|	Справочник.Назначения КАК Таблица
				|		
				|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОбеспечениеЗаказов КАК ДанныеУчета
				|		ПО ДанныеУчета.Назначение = Таблица.Ссылка
				|	
				|ГДЕ
				|	Таблица.НаправлениеДеятельности = &Ссылка
				|	И Таблица.НаправлениеДеятельности.ВариантОбособления = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленияПоНаправлениюДеятельности.ПоНаправлениюВЦелом)
				|	И НЕ ДанныеУчета.Назначение ЕСТЬ NULL";
				Запрос.УстановитьПараметр("Ссылка", Ссылка);
			
			Если Не Запрос.Выполнить().Пустой() Тогда
				
				ТекстОшибки = НСтр("ru = 'По направлению деятельности %1 имеются товародвижения с вариантом обособления ""По направлению деятельности в целом"". Изменение варианта обособления невозможно.'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Ссылка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка);
				Отказ = Истина;
				Возврат;
				
			КонецЕсли;
			
		ИначеЕсли ВариантОбособления <> Перечисления.ВариантыОбособленияПоНаправлениюДеятельности.ПоЗаказамНаправления Тогда
			
			Запрос = Новый Запрос();
			Запрос.Текст =
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	1
				|ИЗ
				|	Справочник.Назначения КАК Таблица
				|	
				|ГДЕ
				|	Таблица.НаправлениеДеятельности = &Ссылка
				|	И Таблица.НаправлениеДеятельности.ВариантОбособления = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленияПоНаправлениюДеятельности.ПоЗаказамНаправления)";
				Запрос.УстановитьПараметр("Ссылка", Ссылка);
			
			Если Не Запрос.Выполнить().Пустой() Тогда
				
				ТекстОшибки = НСтр("ru = 'По направлению деятельности %1 с вариантом обособления ""По заказам направления деятельности"" имеются назначения. Изменение варианта обособления невозможно.'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Ссылка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка);
				Отказ = Истина;
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ТребуетсяНазначение = УчетЗатрат И ВариантОбособления = Перечисления.ВариантыОбособленияПоНаправлениюДеятельности.ПоНаправлениюВЦелом;
	
	Если ТребуетсяНазначение Тогда
		
		Если Не ЗначениеЗаполнено(Назначение) Тогда
			
			Если Не ЭтоНовый() Тогда
				
				Запрос = Новый Запрос();
				Запрос.Текст =
					"ВЫБРАТЬ ПЕРВЫЕ 1
					|	Таблица.Ссылка КАК Назначение
					|ИЗ
					|	Справочник.Назначения КАК Таблица
					|ГДЕ
					|	Таблица.НаправлениеДеятельности = &Ссылка
					|	И Таблица.Партнер = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
					|	И Таблица.Заказ = НЕОПРЕДЕЛЕНО";
				
				Запрос.УстановитьПараметр("Ссылка", Ссылка);
				Выборка = Запрос.Выполнить().Выбрать();
				
				Если Выборка.Следующий() Тогда
					Назначение = Выборка.Назначение;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Назначение) Тогда
			Назначение = Справочники.Назначения.ПолучитьСсылку();
		КонецЕсли;
		
	Иначе
		Назначение = Справочники.Назначения.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.Назначения.СоздатьОбновитьНазначение(
		Неопределено, Назначение, Неопределено, Неопределено, Неопределено, ПометкаУдаления, Ссылка);
	ОбновитьПовторноИспользуемыеЗначения();
	
	// Запись подчиненной константы.
	ОбеспечениеСервер.ИспользоватьУправлениеПеремещениемОбособленныхТоваровВычислитьИЗаписать();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не УчетЗатрат
		Или Не ПолучитьФункциональнуюОпцию("ИспользоватьОбособленноеОбеспечениеЗаказов")
		Или ЗначениеЗаполнено(ВариантОбособления) Тогда
	Иначе
		ТекстСообщения = НСтр("ru = 'Поле ""Обособление материалов и работ"" не заполнено'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "ВариантОбособленияПоНаправлениюВЦелом", "", Отказ);
	КонецЕсли;
	МассивНепроверяемыхРеквизитов.Добавить("ВариантОбособления");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если НЕ ЭтоГруппа Тогда
		Назначение = Справочники.Назначения.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли