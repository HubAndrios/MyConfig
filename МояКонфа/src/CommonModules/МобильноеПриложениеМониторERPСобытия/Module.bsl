////////////////////////////////////////////////////////////////////////////////
// МОДУЛЬ СОДЕРЖИТ ПРОЦЕДУРЫ РЕГИСТРАЦИИ ОБЪЕКТОВ ОБМЕНА С МОБИЛЬНЫМ ПРИЛОЖЕНИЕМ "1С:МОНИТОР ERP"
// - регистрация объектов в узлах обмена
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик подписки на событие "МониторERPПриЗаписиСправочника".
//
// Параметры:
//  Источник - СправочникОбъект.КонтактныеЛицаПартнеров, СправочникОбъект.Партнеры, СправочникОбъект.ВариантыАнализаЦелевыхПоказателей, СправочникОбъект.ВариантыОтчетов - источник события;
//  Отказ - Булево - отказ от выполнения.
//
Процедура ЗарегистрироватьИзмененияПриЗаписиСправочникаДляОбменаСМониторERP(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗарегистрироватьИзменения(Источник);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Регистрирует изменения по узлам планов обмена с мобильным приложением "Монитор ERP".
//
// Параметры:
//  Объект - Объект метаданных - источник события.
//
Процедура ЗарегистрироватьИзменения(Объект)
	
	Если БезопасныйРежим() И ТипЗнч(Объект) = Тип("СправочникОбъект.ВариантыОтчетов") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	МобильноеПриложениеМониторERP.Ссылка
	|ИЗ
	|	ПланОбмена.МобильноеПриложениеМониторERP КАК МобильноеПриложениеМониторERP
	|ГДЕ
	|	НЕ МобильноеПриложениеМониторERP.ПометкаУдаления
	|	И НЕ МобильноеПриложениеМониторERP.Ссылка = &ЭтотУзел");
	
	Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена.МобильноеПриложениеМониторERP.ЭтотУзел());
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	МассивУзлов = Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Если ТипЗнч(Объект) = Тип("СправочникОбъект.КонтактныеЛицаПартнеров") Тогда
		ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Объект.Владелец);
	Иначе
		ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Объект.Ссылка);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
