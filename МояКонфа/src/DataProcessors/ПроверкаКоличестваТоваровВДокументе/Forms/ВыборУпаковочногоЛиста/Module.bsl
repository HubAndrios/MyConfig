
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УпаковочныйЛист = Параметры.УпаковочныйЛист;
	Склад           = Параметры.Склад;
	
	Если ЗначениеЗаполнено(УпаковочныйЛист) Тогда
		Код = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УпаковочныйЛист, "Код");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			Код = МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр).ШтрихКод;
			НайтиУпаковочныйЛист();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	ОчиститьСообщения();
	НайтиУпаковочныйЛист();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНовый(Команда)
	ОчиститьСообщения();
	СоздатьНовыйУпаковочныйЛистСервер();
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	ОчиститьСообщения();
	Если Не ЗначениеЗаполнено(УпаковочныйЛист) Тогда
		Если Не ЗначениеЗаполнено(Код) Тогда
			УпаковочныйЛист = ПредопределенноеЗначение("Документ.УпаковочныйЛист.ПустаяСсылка");
			
			ТекстВопроса = НСтр("ru = 'Упаковочный лист не выбран. Очистить упаковочный лист в выделенных строках?'");
			ОписаниеОповещения = Новый ОписаниеОповещения("ВопросПриПустомУпаковочномЛистеЗавершение",ЭтаФорма);
			
			ПоказатьВопрос(ОписаниеОповещения,ТекстВопроса,РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет);
			Возврат;
			
		Иначе
			СтрокаСообщения = НСтр("ru = 'Упаковочный лист с кодом %1% не найден.'");
			СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%1%", СокрЛП(Код));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,,"Код");
			УпаковочныйЛист = ПредопределенноеЗначение("Документ.УпаковочныйЛист.ПустаяСсылка");
			Возврат;	
		КонецЕсли;
	КонецЕсли;
	
	ЗакрытьСРезультатом();
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЭтикетки(Команда)
	
	Если Не ЗначениеЗаполнено(УпаковочныйЛист) Тогда
		ТекстСообщения = НСтр("ru = 'Для печати этикетки введите код существующего упаковочного листа или создайте новый.'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ОбъектыПечати = Новый Массив();
    ОбъектыПечати.Добавить(УпаковочныйЛист);
    УправлениеПечатьюУТКлиент.ПечатьЭтикетокУпаковочныхЛистов(Новый Структура("ОбъектыПечати",ОбъектыПечати));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьНовыйУпаковочныйЛистСервер()
	ДокСтруктура = Новый Структура("Вид, СкладУпаковки", Перечисления.ВидыУпаковочныхЛистов.Исходящий, Склад);
	УпаковочныйЛист = Документы.УпаковочныйЛист.СоздатьПровестиНовый(ДокСтруктура);
	Код = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УпаковочныйЛист, "Код");
КонецПроцедуры

&НаСервере
Процедура НайтиУпаковочныйЛист()
	
	Массив = Документы.УпаковочныйЛист.МассивСсылокПоМассивуКодов(Код);
	
	Если Массив.Количество() = 1 Тогда
		УпаковочныйЛист = Массив[0];
	Иначе
		СтрокаСообщения = НСтр("ru = 'Упаковочный лист с кодом %1% не найден'");
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%1%", СокрЛП(Код));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,,"Код");
		УпаковочныйЛист = Документы.УпаковочныйЛист.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСРезультатом()
	Результат = Новый Структура;
	Результат.Вставить("УпаковочныйЛист", УпаковочныйЛист);
	Результат.Вставить("Код", Код);
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура ВопросПриПустомУпаковочномЛистеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗакрытьСРезультатом();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


