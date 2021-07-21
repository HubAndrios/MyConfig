
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.ПоДублям Тогда
	
		Если Параметры.СписокДублейКиЗ.Количество() = 0 Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Заголовок = НСтр("ru = 'Дублирующиеся номера КиЗ'");
		СписокДублейКиЗ      = Параметры.СписокДублейКиЗ;
		ПоЗаявкамНаВыпускКиЗ = Параметры.ПоЗаявкамНаВыпускКиЗ;
		
		ЗаполнитьТаблицуПроблем();
		
	ИначеЕсли Параметры.ПоПроблемамСопоставления Тогда
		
		ПереданнаяТаблица = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицаПроблемыСопоставления);
		Если ПереданнаяТаблица = Неопределено Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Заголовок = НСтр("ru = 'Номера КиЗ, несопоставленные заказанным'");
		ТаблицаПроблемныхКиЗ.Загрузить(ПереданнаяТаблица);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаПроблемныхКиЗ

&НаКлиенте
Процедура ТаблицаПроблемныхКиЗВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаПроблемныхКиЗ.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено
		Или Не ЗначениеЗаполнено(ТекущиеДанные.ЗаявкаНаВыпускКиЗ) Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.ЗаявкаНаВыпускКиЗ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуПроблем()

	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ЗаявкаНаВыпускКиЗГИСМВыпущенныеКиЗ.Ссылка КАК ЗаявкаНаВыпускКиЗ,
	|	ЗаявкаНаВыпускКиЗГИСМВыпущенныеКиЗ.НомерКиЗ КАК НомерКиЗ
	|ИЗ
	|	Документ.ЗаявкаНаВыпускКиЗГИСМ.ВыпущенныеКиЗ КАК ЗаявкаНаВыпускКиЗГИСМВыпущенныеКиЗ
	|ГДЕ
	|	ЗаявкаНаВыпускКиЗГИСМВыпущенныеКиЗ.Ссылка В(&СписокЗаявокНаВыпускКиЗ)
	|	И ЗаявкаНаВыпускКиЗГИСМВыпущенныеКиЗ.НомерКиЗ В(&СписокДублейКиЗ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	Запрос.УстановитьПараметр("СписокДублейКиЗ", СписокДублейКиЗ);
	Если ПоЗаявкамНаВыпускКиЗ.Количество() > 0 Тогда
		
		Запрос.УстановитьПараметр("СписокЗаявокНаВыпускКиЗ",ПоЗаявкамНаВыпускКиЗ);
		
	Иначе
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&СписокЗаявокНаВыпускКиЗ", Обработки.ПодтверждениеПоступившихКиЗГИСМ.ТекстУсловияПоЗаявкамНаВыпускКиЗ());
		
	КонецЕсли;
	
	ТаблицаПроблемныхКиЗ.Загрузить(Запрос.Выполнить().Выгрузить());
 

КонецПроцедуры 

#КонецОбласти
