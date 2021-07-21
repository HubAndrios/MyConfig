#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


// Получает реквизиты объекта, которые необходимо блокировать от изменения
//
// Возвращаемое значение:
//	Массив - блокируемые реквизиты объекта
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("Владелец");
	Результат.Добавить("ТипПлана");
	Результат.Добавить("ЗаполнятьПодразделение");
	Результат.Добавить("ЗаполнятьПартнераВТЧ");
	Результат.Добавить("ЗаполнятьСоглашениеВТЧ");
	Результат.Добавить("ЗаполнятьНазначениеВТЧ");
	Результат.Добавить("ЗаполнятьСкладВТЧ; ВарианЗаполненияСкладФорматМагазина");
	Результат.Добавить("ЗаполнятьПартнера; ЗаполнятьПартнера,ЗаполнятьПартнераПродажи,ЗаполнятьПартнераЗакупки");
	Результат.Добавить("ЗаполнятьСклад; ВарианЗаполненияСкладФорматМагазина, ЗаполнятьСклад,ЗаполнятьСкладВТЧ");
	Результат.Добавить("ЗаполнятьСоглашение;ЗаполнятьСоглашение,ЗаполнятьСоглашениеВТЧПродажи,ЗаполнятьСоглашениеВТЧЗакупки");
	Результат.Добавить("ЗаполнятьПланОплат");
	Результат.Добавить("ЗаполнятьПоФормуле; ЗаполнятьПоФормуле");
	Результат.Добавить("Замещающий; Замещающий");
	Результат.Добавить("ЗаполнятьМенеджера");
	Результат.Добавить("ЗаполнятьФорматМагазина; ВарианЗаполненияСкладФорматМагазина");
	
	//ЗаполнятьФорматМагазинаПродажи,ЗаполнятьФорматМагазинаПодажиПоКатегориям,ВарианЗаполненияСкладФорматМагазинаПродажи,ВарианЗаполненияСкладФорматМагазинаПродажиПоКатегориям");
	
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли
