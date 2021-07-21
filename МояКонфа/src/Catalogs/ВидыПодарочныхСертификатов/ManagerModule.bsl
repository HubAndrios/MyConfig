#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает реквизиты объекта, которые необходимо блокировать от изменения
//
// Возвращаемое значение:
//  Массив - блокируемые реквизиты объекта
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	
	Результат.Добавить("Номинал");
	Результат.Добавить("Валюта");
	Результат.Добавить("ТипКарты");
	Результат.Добавить("ПериодДействия");
	Результат.Добавить("КоличествоПериодовДействия");
	Результат.Добавить("СегментНоменклатуры;ИспользоватьСегментНоменклатуры");
	Результат.Добавить("ЧастичнаяОплата;ЧастичнаяОплатаПереключатель");
	Результат.Добавить("ШаблоныКодовПодарочныхСертификатов");
	Результат.Добавить("СчетУчета");
	Результат.Добавить("СтатьяДоходов");
	Результат.Добавить("АналитикаДоходов");
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецЕсли
