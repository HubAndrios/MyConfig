
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Контрагент = Параметры.Контрагент;
	ЭлектроннаяПочта = Параметры.ЭлектроннаяПочта;
	
	Если Не ЗначениеЗаполнено(ЭлектроннаяПочта) Тогда
		ЭлектроннаяПочта = ОбменСКонтрагентамиПереопределяемый.АдресЭлектроннойПочтыКонтрагента(Контрагент);
	КонецЕсли;
	
	ЗарегистрированныеОрганизации = БизнесСетьВызовСервера.МассивЗарегистрированныхОрганизаций();
	
	Элементы.Организация.СписокВыбора.ЗагрузитьЗначения(ЗарегистрированныеОрганизации);
	
	Если ЗарегистрированныеОрганизации.Количество() = 1 Тогда
		Организация = ЗарегистрированныеОрганизации[0];
	КонецЕсли;
	
	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийЭД");
	
	Если НЕ ИспользоватьНесколькоОрганизаций Тогда
		Элементы.Отправитель.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьПриглашение(Команда)
	
	ОчиститьСообщения();
	
	Если СпособОтправки = 0 Тогда
		ОтправитьПриглашенияЧерезБизнесСеть();
	Иначе
		ОтправитьПриглашениеИзПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПриглашенияЧерезБизнесСеть()
	
	Отказ = Ложь;
	Результат = Неопределено;

	БизнесСетьВызовСервера.ОтправитьПриглашениеКонтрагенту(Организация, Контрагент, ЭлектроннаяПочта, Результат, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.КодСостояния = 200 Тогда
		ТекстОповещения= НСтр("ru = 'Отправка приглашения'");
		ТекстПояснения = НСтр("ru = 'Приглашение отправлено контрагенту %1'");
		ТекстПояснения = СтрШаблон(ТекстПояснения, Контрагент);
		ПоказатьОповещениеПользователя(ТекстОповещения, , ТекстПояснения, БиблиотекаКартинок.БизнесСеть);
		Закрыть();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Ошибка отправления приглашения.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстСообщенияНажатие(Элемент)
	
	Информация = ТекстСообщения();
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Информация", Информация);
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Пример текста приглашения к обмену электронными документами'"));
	ПараметрыФормы.Вставить("Пояснение", НСтр("ru = 'Скопируйте текст сообщения в буфер обмена и отправьте получателю любым удобным способом.'"));
	ОткрытьФорму("Обработка.БизнесСеть.Форма.СообщениеПользователю", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОтправкиПриИзменении(Элемент)
	
	Элементы.УчетнаяЗапись.Доступность = (СпособОтправки = 1);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОтправитьПриглашениеИзПрограммы()
	
	ПараметрыФормы = Новый Структура;
	ТемаПисьма = НСтр("ru = 'Приглашение для регистрации в сервисе 1С:Бизнес-сеть'");
	
	ПараметрыФормы.Вставить("Тема", ТемаПисьма);
	ПараметрыФормы.Вставить("УчетнаяЗапись", УчетнаяЗапись);
	ПараметрыФормы.Вставить("Кому", ЭлектроннаяПочта); // АдресПолучателя
	ПараметрыФормы.Вставить("Тело", ТекстСообщения());
	Форма = ОткрытьФорму("ОбщаяФорма.ОтправкаСообщения", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Функция ТекстСообщения()
	
	Информация = 
		"Для %1
		|от %2
		|
		|Уважаемый контрагент! Приглашаем вас подключиться к сервису 1С:Бизнес-сеть.
		|Сервис 1С:Бизнес-сеть позволяет быстро обмениваться электронными документами 
		|с контрагентами без электронной подписи, а так же предоставляет 
		|дополнительные возможности.
		|
		|Подробная информация о сервисе, возможностях использования в конфигурациях 1С
		|размещена на сайте https://1cbn.ru.";
	
	Информация = СтрШаблон(Информация, Контрагент, Организация);
	
	Возврат Информация;
	
КонецФункции

#КонецОбласти
