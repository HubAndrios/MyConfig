#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ВалютаДенежныхСредств = Константы.ВалютаРегламентированногоУчета.Получить();
	Склад = ЗначениеНастроекПовтИсп.ПолучитьРозничныйСкладПоУмолчанию(Склад);
	Владелец = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Владелец);
	
	Если Не ОбщегоНазначенияУТ.ИспользоватьПодключаемоеОборудование() Тогда
		ИспользоватьБезПодключенияОборудования = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Склад) И ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") = Ложь Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
		|	Склады.Ссылка
		|ИЗ
		|	Справочник.Склады КАК Склады");
		
		Если Запрос.Выполнить().Выбрать().Количество() = 2 Тогда
			ВызватьИсключение НСтр("ru = 'Не удалось заполнить поле ""Склад"". В информационной базе введено несколько складов,
			                             |Включите функциональную опцию ""Использовать несколько складов""!'");
		Иначе
			ЛюбойСклад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию();
			Если ЗначениеЗаполнено(ЛюбойСклад) Тогда
				ВызватьИсключение НСтр("ru = 'Не удалось заполнить поле ""Склад"". На склад предприятия возможно оформление только операций оптовой продажи.
				                             |Для оформления розничных операций установите тип склада: Оптово-розничный.'");
			Иначе
				ВызватьИсключение НСтр("ru = 'Не удалось заполнить поле ""Склад"". Возможно, в информационной базе не введено ни одного склада'");
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ТипКассы = Перечисления.ТипыКассККМ.АвтономнаяККМ Тогда
		
		ИспользоватьБезПодключенияОборудования = Ложь;
		ПодключаемоеОборудование               = Неопределено;
		АвтоматическаяИнкассация               = Ложь;
		
	ИначеЕсли ТипКассы = Перечисления.ТипыКассККМ.ККМOffline Тогда
		
		ИспользоватьБезПодключенияОборудования = Ложь;
		АвтоматическаяИнкассация               = Ложь;
		Склад                                  = Неопределено;
		
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКассККМ") Тогда
		УстановитьПривилегированныйРежим(Истина);
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	КассыККМ.Ссылка
		|ИЗ
		|	Справочник.КассыККМ КАК КассыККМ
		|ГДЕ
		|	КассыККМ.Ссылка <> &Ссылка");
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Если Не Запрос.Выполнить().Пустой() Тогда
			Константы.ИспользоватьНесколькоКассККМ.Установить(Истина);
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ТипКассы = Перечисления.ТипыКассККМ.ККМOffline Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли