////////////////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции для обработки действий пользователя
// в процессе работы с ценами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПроцедурыИФункцииПроверкиВозможностиВыполненияДействий

// Проверяет заполненность реквизитов, необходимых для пересчета из валюты в валюту.
//
// Параметры:
//  Документ - ДокументОбъект - Документ, для которого выполняются проверки.
//  СтараяВалюта - СправочникСсылка.Валюты - Предыдущая валюта документа.
//  ИмяТЧ - Строка - Имя табличной части.
//
// Возвращаемое значение:
//  Булево  - Истина, если необходим пересчет в валюту.
//
Функция НеобходимПересчетВВалюту(Документ, СтараяВалюта, ИмяТЧ="Товары") Экспорт

	Если Не ЗначениеЗаполнено(Документ.Валюта) Тогда
		Документ.Валюта = СтараяВалюта;
		Возврат Ложь;
	ИначеЕсли Не ЗначениеЗаполнено(СтараяВалюта) Тогда
		Возврат Ложь;
	ИначеЕсли СтараяВалюта = Документ.Валюта Тогда
		Возврат Ложь;
	ИначеЕсли Документ[ИмяТч].Итог("Цена") = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

// Проверяет заполненность реквизитов, необходимых пересчета сумм взаиморасчетов
//
// Параметры:
// 		Документ - ДокументОбъект, для которого выполняются проверки
// 		СтараяВалюта - Предыдущая валюта взаиморасчетов
// 		ИмяТЧ - Имя табличной части
//
// Возвращаемое значение:
// 		Булево - Ложь, если необходимые пересчитать суммы взаиморасчетов
//
Функция НеобходимПересчетСуммыВзаиморасчетов(Документ, СтараяВалюта, ИмяТЧ="Товары") Экспорт

	Если Не ЗначениеЗаполнено(Документ.ВалютаВзаиморасчетов) Тогда
		Документ.ВалютаВзаиморасчетов = СтараяВалюта;
		Возврат Ложь;
	ИначеЕсли Не ЗначениеЗаполнено(СтараяВалюта) Тогда
		Возврат Истина;
	ИначеЕсли СтараяВалюта = Документ.ВалютаВзаиморасчетов Тогда
		Возврат Ложь;
	ИначеЕсли Документ[ИмяТч].Итог("СуммаВзаиморасчетов") = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

// Проверяет заполненность реквизитов, необходимых для пересчета цен при изменении даты документа
//
// Параметры:
// Документ - ДокументОбъект, для которого выполняются проверки
// ОповещениеОРезультате - ОписаниеОповещения - оповещение о результате вопроса, 
// 		Ложь, если необходимые данные не заполнены или на вопрос пользователь ответил отрицательно
// ИмяТЧ - Имя табличной части
//
//
Процедура ЗадатьВопросПересчетаЦеныПриИзмененииДаты(Документ, ОповещениеОРезультате, ИмяТЧ="Товары") Экспорт

	Если Не ЗначениеЗаполнено(Документ.Соглашение) Или
		Не ЗначениеЗаполнено(Документ.Валюта) Или
		Документ[ИмяТЧ].Количество() = 0 Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОРезультате, Ложь);
		Возврат;
	КонецЕсли;
	
	ВариантыОтветов = Новый СписокЗначений;
	ВариантыОтветов.Добавить(Истина, НСтр("ru='Перезаполнить'"));
	ВариантыОтветов.Добавить(Ложь, НСтр("ru='Не перезаполнять'"));
	
	ПоказатьВопрос(ОповещениеОРезультате, НСтр("ru='Перезаполнить цены по соглашению?'"), ВариантыОтветов);

КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОповещенияПользователяОВыполненныхДействиях

//Показывает оповещение пользователя об окончании пересчета сумм из валюты в валюту
//
// Параметры:
// ВалютаИсточник - СправочникСсылка.Валюты - валюта, из которой осуществлялся пересчет
// ВалютаПриемник - СправочникСсылка.Валюты - валюта, в которую осуществляется пересчет
//
Процедура ОповеститьОбОкончанииПересчетаСуммВВалюту(ВалютаИсточник, ВалютаПриемник) Экспорт

	СтрокаСообщения = НСтр("ru='Суммы в документе пересчитаны из валюты %ВалютаИсточник% в валюту %ВалютаПриемник%'");
	СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%ВалютаИсточник%", ВалютаИсточник);
	СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%ВалютаПриемник%", ВалютаПриемник);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Суммы пересчитаны'"),
		,
		СтрокаСообщения,
		БиблиотекаКартинок.Информация32);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
