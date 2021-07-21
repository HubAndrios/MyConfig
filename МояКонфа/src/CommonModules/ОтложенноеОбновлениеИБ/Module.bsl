////////////////////////////////////////////////////////////////////////////////
// Отложенное обновление информационной базы.
// В модуле содержатся обработчики обновления для отложенного проведения
// документов по регистрам
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает параметры обработчиков отложенного обновления
//
// Параметры:
//  ИдентификаторПараметров	 - Строка - уникальный идентификатор параметров
//  ЗначениеПоУмолчанию		 - Произвольный - значение, которое будет присвоено параметрам, если они отсутствуют
//
// Возвращаемое значение:
//  Соответствие - Содержит параметры обработчиков отложенного обновления
//    
Функция ПараметрыОбработчиковОбновления(ИдентификаторПараметров, ЗначениеПоУмолчанию = Неопределено) Экспорт

	ПараметрыОбработчиков = Константы.ПараметрыОбработчиковОбновления.Получить().Получить();
	Если ТипЗнч(ПараметрыОбработчиков) <> Тип("Соответствие") Тогда
		ПараметрыОбработчиков = Новый Соответствие;
	КонецЕсли;
	Если ПараметрыОбработчиков.Получить(ИдентификаторПараметров) = Неопределено Тогда
		ПараметрыОбработчиков.Вставить(ИдентификаторПараметров, ЗначениеПоУмолчанию);
	КонецЕсли;

	Возврат ПараметрыОбработчиков;
	
КонецФункции

// Записывает в константу ПараметрыОбработчиковОбновления информацию об отложенном обновлении
//
// Параметры:
//  ПараметрыОбработчиковОбновления	 - Структура - Содержит сохраняемые параметры в константе "ПараметрыОбработчиковОбновления"
//  необходимые для последующей обработки отложенным обработчиком обновления
//  МоментВремени					 - МоментВремени - Момент времени документа, на котором закончилась выполнение отложенного обработчика обновления
//  ИмяКлюча						 - Строка		 - Имя ключа сохраняемого значения в структуре "ПараметрыОбработчиковОбновления"
//
Процедура ЗаписатьИнформациюОбОтложенномОбновлении(ПараметрыОбработчиковОбновления, МоментВремени, ИмяКлюча) Экспорт

	Если ЗначениеЗаполнено(МоментВремени) Тогда
		ПараметрыОбработчиковОбновления.Вставить(ИмяКлюча, МоментВремени);
	Иначе
		ПараметрыОбработчиковОбновления.Удалить(ИмяКлюча);
	КонецЕсли;

	МенеджерКонстанты = Константы.ПараметрыОбработчиковОбновления.СоздатьМенеджерЗначения();
	МенеджерКонстанты.Значение = Новый ХранилищеЗначения(ПараметрыОбработчиковОбновления);
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(МенеджерКонстанты);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ФормированиеДанныхДляОбновления

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти