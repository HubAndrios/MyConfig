#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает таблицу классификатора из макета с предопределенными элементами.
// Макеты хранятся в макетах данного справочника (см. общую форму "ДобавлениеЭлементовВКлассификатор").
//	Параметры:
//		Переменные - Строка - в данном методе не используется, однако является обязательной в случе обращения к другим классификаторам.
//	Возвращаемое значение:
//		Таблица значений - таблица классификатора с колонками:
//			* Код - Строка - строковое представление кода элемента классификатора.
//			* Наименование - Строка - наименование элемента классификатора.
//
Функция ТаблицаКлассификатора(Знач Переменные) Экспорт
	
	ТаблицаПоказателей = Новый ТаблицаЗначений;
	
	Макет = Справочники.КлассификаторТНВЭД.ПолучитьМакет("КлассификаторТоварнойНоменклатурыВнешнеэкономическойДеятельности");
	
	// В полученном макете содержатся значения всех списков используемых в отчете, ищем переданный.
	Список = Макет.Области.Найти("Строки");
	
	Если Список.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
		// Заполнение дерева данными списка.	
		ВерхОбласти = Список.Верх;
		НизОбласти = Список.Низ;
		
		НомерКолонки = 1;
		Область = Макет.Область(ВерхОбласти - 1, НомерКолонки);
		ИмяКолонки = Область.Текст;
		ДлинаКодаКлассификатора = 7;
		
		Пока ЗначениеЗаполнено(ИмяКолонки) Цикл
			
			Если ИмяКолонки = "Код" Тогда
				ТаблицаПоказателей.Колонки.Добавить("Код", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(12)));
			ИначеЕсли ИмяКолонки = "Наименование" Тогда
				ТаблицаПоказателей.Колонки.Добавить("Наименование",Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(255)));
			КонецЕсли;	
			
			НомерКолонки = НомерКолонки + 1;
			Область = Макет.Область(ВерхОбласти - 1, НомерКолонки);
			ИмяКолонки = Область.Текст;
			
		КонецЦикла;
		
		Для НомСтр = ВерхОбласти По НизОбласти Цикл
			
			// Отображаем только элементы.
			
			Код = СокрП(Макет.Область(НомСтр, 1).Текст);
			Если СтрДлина(Код) = 2 Тогда
				Продолжить;
			КонецЕсли;
			СтрокаСписка = ТаблицаПоказателей.Добавить();
			
			Для Каждого Колонка Из ТаблицаПоказателей.Колонки Цикл
				
				ЗначениеКолонки = СокрП(Макет.Область(НомСтр, ТаблицаПоказателей.Колонки.Индекс(Колонка) + 1).Текст);
				СтрокаСписка[Колонка.Имя] = ЗначениеКолонки;
				
			КонецЦикла;
			
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаПоказателей.Сортировать(ТаблицаПоказателей.Колонки[0].Имя + " Возр");
	
	Возврат ТаблицаПоказателей;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#КонецОбласти

#КонецЕсли