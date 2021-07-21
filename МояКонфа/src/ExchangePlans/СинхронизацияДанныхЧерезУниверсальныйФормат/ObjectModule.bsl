
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	// ОбменДанными.Загрузка
	// Перед записью объекта, необходимо актуализировать служебные реквизиты и зачистить неиспользуемые,
	// но возможно выбранные значения отборов, в процессе настройки узла.
	ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.АктуализацияРеквизитовУзлаПланаОбмена(ЭтотОбъект);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиСобытияУТУП.ОбновитьКэшМеханизмовРегистрации();
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	// ОбменДанными.Загрузка
	// Обмен может быть удален программно. 
	// В этом случае, необходимо актализировать константу ИспользуетсяОбменСБухгалтериейПредприятия.
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей")
		И (ВариантНастройки = "ОбменБП30"
		Или ВариантНастройки = "ОбменБПКОРП30"
		Или ВариантНастройки = "ОбменУТБП"
		Или ВариантНастройки = "ОбменУниверсальный") Тогда
		ОбменДаннымиУТ.АктуализироватьПризнакИспользованияОбменаСБухгалтерией(ЭтотОбъект, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти

#КонецЕсли