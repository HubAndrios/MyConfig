#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция определяет, является ли статус заявки неактуальным.
//
// Параметры:
// 	Статус - статус, который необходимо проверить
//
// Возвращаемое значение:
//	Булево - статус заявки является неактуальным
//
Функция ЭтоСтатусНеАктуальнойЗаявки(Статус) Экспорт

	Если Статус = Перечисления.СтатусыЗаявокНаВыпускКиЗГИСМ.Отсутствует
		Или Статус = Перечисления.СтатусыЗаявокНаВыпускКиЗГИСМ.ОтклоненаГИСМ
		Или Статус = Перечисления.СтатусыЗаявокНаВыпускКиЗГИСМ.ОтклоненаФНС
		Или Статус = Перечисления.СтатусыЗаявокНаВыпускКиЗГИСМ.ОтклоненаЭмитентом
		Или Статус = Перечисления.СтатусыЗаявокНаВыпускКиЗГИСМ.ПустаяСсылка() Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;

КонецФункции

// Функция определяет необходимость расчета статуса поступления по заявке.
//
// Параметры:
// 	Статус - статус заявки
// 	СтатусОбработкиЭмитентом - статус обработки эмитентом
//
// Возвращаемое значение:
//	Булево - статус заявки требует расчета поступления по заявке
//
Функция СтатусТребуетРасчетаПоступления(Статус, СтатусОбработкиЭмитентом) Экспорт

	Если Статус = Перечисления.СтатусыЗаявокНаВыпускКиЗГИСМ.ОбрабатываетсяПоступление
		Или Статус = Перечисления.СтатусыЗаявокНаВыпускКиЗГИСМ.ОбрабатываетсяЭмитентом
		И (СтатусОбработкиЭмитентом = Перечисления.СтатусыОбработкиЭмитентомКиЗГИСМ.ЖдетСамовывоза
		   Или СтатусОбработкиЭмитентом = Перечисления.СтатусыОбработкиЭмитентомКиЗГИСМ.ОтгруженоЗаказчику
		   Или СтатусОбработкиЭмитентом = Перечисления.СтатусыОбработкиЭмитентомКиЗГИСМ.ПереданоГрузоперевозчику) Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;

КонецФункции

// Функция возвращает структуру значений по умолчанию для заявки для движений.
//
// Возвращаемое значение:
//	Структура - значения по умолчанию
//
Функция ЗначенияПоУмолчанию() Экспорт
	
	СтруктрураЗначенияПоУмолчанию = Новый Структура;
	
	СтруктрураЗначенияПоУмолчанию.Вставить("Документ", Неопределено);
	СтруктрураЗначенияПоУмолчанию.Вставить("ТекущаяЗаявкаНаВыпускКиЗ",     Документы.ЗаявкаНаВыпускКиЗГИСМ.ПустаяСсылка());
	
	СтруктрураЗначенияПоУмолчанию.Вставить("СтатусЗаявкиНаВыпускКиЗ",      Перечисления.СтатусыЗаявокНаВыпускКиЗГИСМ.Отсутствует);
	СтруктрураЗначенияПоУмолчанию.Вставить("СтатусОбработкиЭмитентом",     Перечисления.СтатусыОбработкиЭмитентомКиЗГИСМ.ПустаяСсылка());
	СтруктрураЗначенияПоУмолчанию.Вставить("ДальнейшееДействие",           Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПустаяСсылка());
	
	СтруктрураЗначенияПоУмолчанию.Вставить("ПоступлениеТоваров",           Неопределено);
	СтруктрураЗначенияПоУмолчанию.Вставить("КоличествоПоступленийТоваров", 0);
	СтруктрураЗначенияПоУмолчанию.Вставить("СтатусПоступления",            Перечисления.СтатусыПоступленийГИСМ.ПустаяСсылка());
	
	СтруктрураЗначенияПоУмолчанию.Вставить("КПередачеПодтверждения",       Ложь);
	СтруктрураЗначенияПоУмолчанию.Вставить("ПроцентПодтвержденныхКиЗ",     0);
	
	Возврат СтруктрураЗначенияПоУмолчанию;
	
КонецФункции

// Осуществляет запись в регистр по переданным данным.
//
// Параметры:
// 	ДанныеЗаписи - данные для записи в регистр
//
Процедура ВыполнитьЗаписьВРегистрПоДаннымСтруктура(ДанныеЗаписи) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.СтатусыЗаявокНаВыпускКиЗГИСМ.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ДанныеЗаписи);
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Удаляет запись из регистра по переданному документу.
//
// Параметры:
// 	Документ - документ, данные по которому необходимо удалить
//
Процедура УдалитьЗаписьИзРегистра(Документ) Экспорт

	НаборЗаписей = РегистрыСведений.СтатусыЗаявокНаВыпускКиЗГИСМ.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	НаборЗаписей.Записать();

КонецПроцедуры

// Возвращает статус обработки заявки эмитентом.
//
// Параметры:
// 	ЗаявкаНаВыпускКиЗ - заявка
// 	СтатусОбработкиЭмитентом - статус обработки эмитентом
//
// Возвращаемое значение:
//	Перечисление.СтатусыОбработкиЭмитентомКиЗГИСМ - рассчитанный статус заявки
//
Функция ОбновитьСтатусОбработкиЭмитентом(ЗаявкаНаВыпускКиЗ, СтатусОбработкиЭмитентом) Экспорт
	
	НовыйСтатус                   = Неопределено;
	НовоеДальнейшееДействие       = Неопределено;
	НовыйСтатусОбработкиЭмитентом = Неопределено;
	
	НаборЗаписей = НаборЗаписей(ЗаявкаНаВыпускКиЗ);
	
	Если СтатусОбработкиЭмитентом = Перечисления.СтатусыОбработкиЭмитентомКиЗГИСМ.Отклонена Тогда
		Статус = Перечисления.СтатусыЗаявокНаВыпускКиЗГИСМ.ОтклоненаЭмитентом;
	ИНаче
		Статус = Перечисления.СтатусыЗаявокНаВыпускКиЗГИСМ.ОбрабатываетсяЭмитентом;
	КонецЕсли;
	
	Если СтатусОбработкиЭмитентом = Перечисления.СтатусыОбработкиЭмитентомКиЗГИСМ.Отклонена Тогда
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется;
	ИначеЕсли СтатусОбработкиЭмитентом = Перечисления.СтатусыОбработкиЭмитентомКиЗГИСМ.Приостановлена Тогда
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ИсправьтеНекорректныеРеквизиты;
	ИначеЕсли СтатусОбработкиЭмитентом = Перечисления.СтатусыОбработкиЭмитентомКиЗГИСМ.ФормированиеСчета Тогда
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПолучитеСчетНаОплату;
	ИначеЕсли СтатусОбработкиЭмитентом = Перечисления.СтатусыОбработкиЭмитентомКиЗГИСМ.ОжидаетсяОплата Тогда
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОплатитеСчет;
	ИначеЕсли СтатусОбработкиЭмитентом = Перечисления.СтатусыОбработкиЭмитентомКиЗГИСМ.ПереданоВПроизводство Тогда
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеУведомлениеОВыпускеКиЗ;
		
	ИначеЕсли СтатусОбработкиЭмитентом = Перечисления.СтатусыОбработкиЭмитентомКиЗГИСМ.ПереданоГрузоперевозчику Тогда
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПоступлениеТоваров;
	ИначеЕсли СтатусОбработкиЭмитентом = Перечисления.СтатусыОбработкиЭмитентомКиЗГИСМ.ЖдетСамовывоза Тогда
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПоступлениеТоваров;
	ИначеЕсли СтатусОбработкиЭмитентом = Перечисления.СтатусыОбработкиЭмитентомКиЗГИСМ.ОтгруженоЗаказчику Тогда
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПоступлениеТоваров;
		
	ИначеЕсли СтатусОбработкиЭмитентом = Перечисления.СтатусыОбработкиЭмитентомКиЗГИСМ.Возвращено Тогда
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется;
	ИначеЕсли СтатусОбработкиЭмитентом = Перечисления.СтатусыОбработкиЭмитентомКиЗГИСМ.Уничтожено Тогда
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется;
	КонецЕсли;
	
	Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
		
		Если ЗаписьНабора.СтатусОбработкиЭмитентом <> СтатусОбработкиЭмитентом Тогда
			ЗаписьНабора.СтатусОбработкиЭмитентом = СтатусОбработкиЭмитентом;
			НовыйСтатусОбработкиЭмитентом = СтатусОбработкиЭмитентом;
		КонецЕсли;
		Если ЗаписьНабора.СтатусЗаявкиНаВыпускКиЗ <> Статус Тогда
			ЗаписьНабора.СтатусЗаявкиНаВыпускКиЗ = Статус;
			НовыйСтатус = Статус;
		КонецЕсли;
		Если ЗаписьНабора.ДальнейшееДействие <> ДальнейшееДействие Тогда
			ЗаписьНабора.ДальнейшееДействие = ДальнейшееДействие;
			НовоеДальнейшееДействие = ДальнейшееДействие;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(НовыйСтатус)
		Или ЗначениеЗаполнено(НовоеДальнейшееДействие)
		Или ЗначениеЗаполнено(НовыйСтатусОбработкиЭмитентом) Тогда
		НаборЗаписей.Записать();
	КонецЕсли;
	
	Возврат НовыйСтатусОбработкиЭмитентом;
	
КонецФункции

// Возвращает статус заявки.
//
// Параметры:
// 	ЗаявкаНаВыпускКиЗ - заявка
// 	Статус - статус заявки
// 	ДальнейшееДействие - дальнейшее действие по заявке
//
// Возвращаемое значение:
//	ПеречислениеСсылка.СтатусыЗаявокНаВыпускКиЗГИСМ - новый статус заявки
//
Функция ОбновитьСтатус(ЗаявкаНаВыпускКиЗ, Статус, ДальнейшееДействие) Экспорт
	
	НовыйСтатус            = Неопределено;
	НовоеДальнейшееДействие = Неопределено;
	
	НаборЗаписей = НаборЗаписей(ЗаявкаНаВыпускКиЗ);
	
	Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
		Если ЗаписьНабора.СтатусЗаявкиНаВыпускКиЗ <> Статус Тогда
			ЗаписьНабора.СтатусЗаявкиНаВыпускКиЗ = Статус;
			НовыйСтатус = Статус;
		КонецЕсли;
		Если ЗаписьНабора.ДальнейшееДействие <> ДальнейшееДействие Тогда
			ЗаписьНабора.ДальнейшееДействие = ДальнейшееДействие;
			НовоеДальнейшееДействие = ДальнейшееДействие;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(НовыйСтатус)
		Или ЗначениеЗаполнено(НовоеДальнейшееДействие) Тогда
		НаборЗаписей.Записать();
	КонецЕсли;
	
	Возврат НовыйСтатус;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НаборЗаписей(ЗаявкаНаВыпускКиЗ)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Состояния.Документ КАК Документ
	|ИЗ
	|	РегистрСведений.СтатусыЗаявокНаВыпускКиЗГИСМ КАК Состояния
	|ГДЕ
	|	Состояния.Документ = &ЗаявкаНаВыпускКиЗ
	|ИЛИ Состояния.ТекущаяЗаявкаНаВыпускКиЗ = &ЗаявкаНаВыпускКиЗ");
	
	Запрос.УстановитьПараметр("ЗаявкаНаВыпускКиЗ", ЗаявкаНаВыпускКиЗ);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	НаборЗаписей = Неопределено;
	Если Выборка.Следующий() Тогда
		
		НаборЗаписей = РегистрыСведений.СтатусыЗаявокНаВыпускКиЗГИСМ.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Документ.Установить(Выборка.Документ, Истина);
		НаборЗаписей.Прочитать();
		
	Иначе
		
		Основание = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗаявкаНаВыпускКиЗ, "Основание");
		Если ЗначениеЗаполнено(Основание) Тогда
			Документ = Основание;
		Иначе
			Документ = ЗаявкаНаВыпускКиЗ;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.СтатусыЗаявокНаВыпускКиЗГИСМ.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Документ.Установить(Документ, Истина);
		
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗначенияПоУмолчанию());
		НоваяЗапись.Документ                    = Документ;
		НоваяЗапись.ТекущаяЗаявкаНаВыпускКиЗ = ЗаявкаНаВыпускКиЗ;
		
	КонецЕсли;
	
	Возврат НаборЗаписей;
	
КонецФункции

#КонецОбласти

#КонецЕсли