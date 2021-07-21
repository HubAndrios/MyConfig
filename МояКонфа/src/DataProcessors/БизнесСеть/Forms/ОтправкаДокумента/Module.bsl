
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.МассивСсылокНаОбъект) <> Тип("Массив") ИЛИ Параметры.МассивСсылокНаОбъект.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Ссылка = Параметры.МассивСсылокНаОбъект[0];
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	МассивСсылокНаОбъект = Параметры.МассивСсылокНаОбъект;
	ЭлектронноеВзаимодействиеПереопределяемый.ПроверитьГотовностьИсточников(МассивСсылокНаОбъект);
	Если МассивСсылокНаОбъект.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	РеквизитыДокумента = ОбменСКонтрагентамиСлужебный.ЗаполнитьПараметрыЭДПоИсточнику(Ссылка);
	Организация = РеквизитыДокумента.Организация;
	Контрагент = РеквизитыДокумента.Контрагент;
	ЭлектронныйАдресУведомления = ОбменСКонтрагентамиПереопределяемый.АдресЭлектроннойПочтыКонтрагента(РеквизитыДокумента.Контрагент);
	
	ЭДНадпись = Ссылка.Метаданные().Синоним + " " + Ссылка.Номер + " " + Формат(Ссылка.Дата, "ДЛФ=D");
	
	ТекстОрганизации = НСтр("ru = 'Для отправки документа зарегистрируйте организацию %1 в сервисе 1С:Бизнес-сеть.'");
	ТекстОрганизации = СтрШаблон(ТекстОрганизации, Организация);
	Элементы.ТекстРегистрацииОрганизации.Заголовок = ТекстОрганизации;
	
	ТекстКонтрагента = НСтр("ru = 'Контрагент ""%1"" не зарегистрирован в сервисе 1С:Бизнес-сеть.'");
	ТекстКонтрагента = СтрШаблон(ТекстКонтрагента, Контрагент);
	Элементы.ТекстРегистрацииКонтрагента.Заголовок = ТекстКонтрагента;
	
	// Формирование электронных документов.
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("МассивСсылокНаОбъект", МассивСсылокНаОбъект);
	ПараметрыЗадания.Вставить("ОтправкаЧерезБС", Истина);
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	Обработки.ОбменСКонтрагентами.ПодготовитьДанныеДляЗаполненияДокументов(ПараметрыЗадания, АдресХранилища);
	
	Если АдресХранилища = "" Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗагрузитьПодготовленныеДанныеЭД();
	
	Если ОбменСКонтрагентами.ОрганизацияПодключена(Организация) Тогда
		Элементы.ДекорацияПодключенияЭДО.Видимость = Ложь;
	КонецЕсли;
	
	// Проверка организации.
	ОрганизацияЗарегистрирована = БизнесСеть.ОрганизацияЗарегистрирована(Организация);
	
	Если ОрганизацияЗарегистрирована = Истина Тогда
		Результат = Неопределено;
		БизнесСетьВызовСервера.ПолучитьРеквизитыУчастника(Организация, Результат, Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		ДанныеСервиса = Результат.Данные;
		ОрганизацияЗарегистрирована = Ложь;
		Если Не Отказ И Результат.КодСостояния = 200 И ТипЗнч(ДанныеСервиса) = Тип("Структура") Тогда
			ОрганизацияЗарегистрирована = Истина;
		КонецЕсли;
		ЕстьПодключениеКСервису = ОрганизацияЗарегистрирована;
	КонецЕсли;
	
	Если Не ЕстьПодключениеКСервису Тогда
		ЕстьПодключениеКСервису = БизнесСеть.ОрганизацияЗарегистрирована(Неопределено);
		Если НЕ ЕстьПодключениеКСервису Тогда
			Элементы.Зарегистрировать.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ЕстьПодключениеКСервису Тогда
		ПараметрыКоманды = Новый Структура("Ссылка, ИНН, КПП", Контрагент);
		БизнесСеть.ВыполнитьКомандуСервиса("ПолучитьРеквизитыУчастника", ПараметрыКоманды, Результат, Отказ);
		
		КонтрагентЗарегистрирован = Ложь;
		Если Не Отказ И Результат <> Неопределено И Результат.КодСостояния = 200 Тогда
			ДанныеСервиса = Неопределено;
			Если Результат.Свойство("Данные", ДанныеСервиса) И ТипЗнч(ДанныеСервиса) = Тип("Структура") Тогда
				КонтрагентЗарегистрирован = Истина;	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ОрганизацияЗарегистрирована И КонтрагентЗарегистрирован Тогда
		КлючСохраненияПоложенияОкна = "БизнесСеть_ОтправкаДокумента_Стандартный";
	ИначеЕсли ОрганизацияЗарегистрирована И Не КонтрагентЗарегистрирован Тогда
		КлючСохраненияПоложенияОкна = "БизнесСеть_ОтправкаДокумента_РегистрацияКонтрагента";
	ИначеЕсли Не ОрганизацияЗарегистрирована И КонтрагентЗарегистрирован Тогда
		КлючСохраненияПоложенияОкна = "БизнесСеть_ОтправкаДокумента_РегистрацияОрганизации";
	Иначе
		КлючСохраненияПоложенияОкна = "БизнесСеть_ОтправкаДокумента_РегистрацияОрганизацииКонтрагента";
	КонецЕсли;
	
	Если ОрганизацияЗарегистрирована Тогда
		
		// Загрузка истории отправки документа.
		ПараметрыКоманды = Новый Структура;
		ПараметрыКоманды.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
		
		МассивСсылокНаОбъект = Новый Массив;
		Для каждого СтрокаТаблицы Из ТаблицаДанных Цикл
			МассивСсылокНаОбъект.Добавить(СтрокаТаблицы.ВладелецЭД);
		КонецЦикла; 
		
		ПараметрыКоманды.Вставить("МассивСсылокНаОбъект", МассивСсылокНаОбъект);
		ПараметрыКоманды.Вставить("РежимВходящихДокументов", Ложь);
		ПараметрыКоманды.Вставить("withData", "false");
		
		БизнесСеть.ВыполнитьКомандуСервиса("ПолучитьДокументы", ПараметрыКоманды, Результат, Отказ);
		
		Если Отказ Тогда
			ТекстСообщения = НСтр("ru = 'Ошибка запроса истории документов в сервисе 1С:Бизнес-сеть.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			Возврат;
		КонецЕсли;
		
		ДанныеСервиса = Результат.Данные;
		
		Если Не Отказ И Результат.КодСостояния = 200 И ТипЗнч(ДанныеСервиса) = Тип("Массив") Тогда
			Для каждого Элемент Из ДанныеСервиса Цикл
				МассивСсылокНаОбъект.Найти(Элемент.documentGuid);
			КонецЦикла;
		КонецЕсли;
		
		Если ТипЗнч(ДанныеСервиса) = Тип("Массив") Тогда
			СписокИстории.Очистить();
			Для каждого ЭлементМассива Из ДанныеСервиса Цикл
				
				НоваяСтрока = СписокИстории.Добавить();
				НоваяСтрока.Дата = БизнесСетьКлиентСервер.ДатаИзUnixTime(ЭлементМассива.sentDate);
				Если ВРег(ЭлементМассива.deliveryStatus) = "SENT" Тогда
					НоваяСтрока.Статус = НСтр("ru = 'Отправлен'");
				ИначеЕсли ВРег(ЭлементМассива.deliveryStatus) = "DELIVERED" Тогда
					НоваяСтрока.Статус = НСтр("ru = 'Доставлен'");
				ИначеЕсли ВРег(ЭлементМассива.deliveryStatus) = "REJECTED" Тогда
					НоваяСтрока.Статус = НСтр("ru = 'Отклонен'");
				КонецЕсли; 
				
				НоваяСтрока.Наименование  = ЭлементМассива.documentTitle;
				НоваяСтрока.Идентификатор = ЭлементМассива.id;
				Если ЗначениеЗаполнено(ЭлементМассива.receivedDate) Тогда
					НоваяСтрока.ДатаДоставки = БизнесСетьКлиентСервер.ДатаИзUnixTime(ЭлементМассива.receivedDate);
				КонецЕсли; 
				
				// Получение владельца из ТаблицаДанных.
				СтрокаДанных = ТаблицаДанных.НайтиСтроки(Новый Структура("УникальныйИдентификатор", ЭлементМассива.documentGuid));
				НоваяСтрока.ВладелецЭД = СтрокаДанных[0].ВладелецЭД;
				
				НоваяСтрока.Информация = ЭлементМассива.info;
				НоваяСтрока.Получатель = ЭлементМассива.destinationOrganization.title;
				НоваяСтрока.КонтрагентИНН = ЭлементМассива.destinationOrganization.inn;
				НоваяСтрока.КонтрагентКПП = ЭлементМассива.destinationOrganization.kpp;
				
				// Удаление двоичных данных из структуры данных.
				НоваяСтрока.Источник = ЭлементМассива;
				Если НоваяСтрока.Источник.Свойство("documentData") Тогда
					НоваяСтрока.Источник.Удалить("documentData");
				КонецЕсли;
				Если НоваяСтрока.Источник.Свойство("documentPresentationData") Тогда
					НоваяСтрока.Источник.Удалить("documentPresentationData");	
				КонецЕсли;
				
				НоваяСтрока.КонтактноеЛицо = ЭлементМассива.person.name;
				НоваяСтрока.ЭлектроннаяПочта = ЭлементМассива.person.email;
				НоваяСтрока.Телефон = ЭлементМассива.person.phone;
				
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	СтруктураКонтактныхДанных = БизнесСеть.ОписаниеКонтактнойИнформацииПользователя();
	БизнесСетьПереопределяемый.ПолучитьКонтактнуюИнформациюПользователя(Пользователи.ТекущийПользователь(), СтруктураКонтактныхДанных);
	КонтактноеЛицо = СтруктураКонтактныхДанных.ФИО;
	Телефон = СтруктураКонтактныхДанных.Телефон;
	ЭлектроннаяПочта = СтруктураКонтактныхДанных.ЭлектроннаяПочта;
	
	ИзменитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не НаправитьУведомление Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ЭлектронныйАдресУведомления"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗарегистрироватьОрганизациюПриИзменении(Элемент)
	
	Если ЕстьПодключениеКСервису Тогда
		Элементы.Отправить.Доступность = ЗарегистрироватьОрганизацию;	
	Иначе
		Элементы.Зарегистрировать.Доступность = ЗарегистрироватьОрганизацию;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура("Контрагент", Контрагент);
	БизнесСетьКлиент.ОткрытьПрофильУчастника(ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СписокИстории.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтруктур = Новый Массив;
	ЗаполнитьСписокДокументовИстории(МассивСтруктур);
	
	Если МассивСтруктур.Количество() = 1 Тогда
		ОткрытьФорму("Обработка.БизнесСеть.Форма.ПросмотрДокумента",
			Новый Структура("СтруктураЭД", МассивСтруктур[0]), ЭтотОбъект);
	Иначе
		ФормаПросмотраЭД = ОткрытьФорму("Обработка.БизнесСеть.Форма.ИсторияОтправки",
			Новый Структура("СтруктураЭД", МассивСтруктур), , ЭтотОбъект);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ДокументНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТаблицаДанных.Количество() > 1 Тогда
		
		МассивСтруктур = Новый Массив;
		Для Каждого СтрокаДанных Из ТаблицаДанных Цикл
			ПараметрыЭД = Новый Структура;
			ПараметрыЭД.Вставить("АдресХранилища", СтрокаДанных.АдресХранилища);
			ПараметрыЭД.Вставить("ФайлАрхива", Истина);
			ПараметрыЭД.Вставить("НаименованиеФайла", СтрокаДанных.НаименованиеФайла);
			ПараметрыЭД.Вставить("НаправлениеЭД", СтрокаДанных.НаправлениеЭД);
			ПараметрыЭД.Вставить("Контрагент", СтрокаДанных.Контрагент);
			ПараметрыЭД.Вставить("ВладелецЭД", СтрокаДанных.ВладелецЭД);
			ПараметрыЭД.Вставить("Источник", СтрокаДанных.Источник);
			МассивСтруктур.Добавить(ПараметрыЭД);
		КонецЦикла;
		ОткрытьФорму("Обработка.БизнесСеть.Форма.ИсторияОтправки",
			Новый Структура("СтруктураЭД", МассивСтруктур), ЭтотОбъект);
			
	ИначеЕсли ТаблицаДанных.Количество() = 1 Тогда
		ПараметрыЭД = Новый Структура;
		ПараметрыЭД.Вставить("АдресХранилища");
		ПараметрыЭД.Вставить("ФайлАрхива", Истина);
		ПараметрыЭД.Вставить("НаименованиеФайла");
		ПараметрыЭД.Вставить("НаправлениеЭД");
		ПараметрыЭД.Вставить("Контрагент");
		ПараметрыЭД.Вставить("ВладелецЭД");
		ПараметрыЭД.Вставить("Источник");
		ПараметрыЭД.Вставить("СопроводительнаяИнформация", СопроводительнаяИнформация);
		ЗаполнитьЗначенияСвойств(ПараметрыЭД, ТаблицаДанных[0]);
		ПараметрыФормы = Новый Структура("СтруктураЭД", ПараметрыЭД);
		ОткрытьФорму("Обработка.БизнесСеть.Форма.ПросмотрДокумента", ПараметрыФормы, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаправитьУведомлениеПриИзменении(Элемент)
	
	Элементы.ЭлектронныйАдресУведомления.Доступность = НаправитьУведомление;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлектроннаяПочтаПриИзменении(Элемент)
	
	УстановитьДоступностьФлагаУведомлятьПоПочте();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьДокумент(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ЭлектроннаяПочта)
		И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ЭлектроннаяПочта, Истина) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Адрес электронной почты введен неверно'"),,
			"ЭлектроннаяПочта",,);
		Возврат;
	КонецЕсли;
	
	Если НаправитьУведомление И Не ПустаяСтрока(ЭлектронныйАдресУведомления)
		И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ЭлектронныйАдресУведомления, Истина) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Адрес электронной почты контрагента введен неверно'"),,
			"ЭлектронныйАдресУведомления",,);
		Возврат;
	КонецЕсли;
	
	ОтправитьДокументыВСервис();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарегистрироватьОрганизацию(Команда)
	
	Отказ = Ложь;
	ЗарегистрироватьОрганизациюНаСервере(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеЭД()
	
	ТаблицаЭД = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если НЕ ЗначениеЗаполнено(ТаблицаЭД) Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаТаблицы Из ТаблицаЭД Цикл
		СтрокаТаблицы.АдресХранилища = ПоместитьВоВременноеХранилище(СтрокаТаблицы.ДвоичныеДанныеПакета, УникальныйИдентификатор);
		СтрокаТаблицы.АдресХранилищаПредставления = ПоместитьВоВременноеХранилище(СтрокаТаблицы.ДвоичныеДанныеПредставления,
			УникальныйИдентификатор);
	КонецЦикла;
	
	ТипыДокументов = БизнесСеть.ВидыДокументовСервиса();
	
	ТаблицаДанных.Загрузить(ТаблицаЭД);
	Для каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрокаТаблицы.ВладелецЭД, "Номер, Дата");
		ШаблонНаименования = НСтр("ru = '%1 %2 от %3'");
		
		Тип = ТипыДокументов.НайтиПоЗначению(СтрокаТаблицы.ВидЭД);
		Если Тип = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Отправка данного вида документа не поддерживается.'");
		КонецЕсли;
		
		НомерДокумента = ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьПечатныйНомерДокумента(СтрокаТаблицы.ВладелецЭД);
		СтрокаТаблицы.НаименованиеФайла = СтрШаблон(ШаблонНаименования,
			Тип.Представление, СокрП(НомерДокумента), Формат(СтруктураРеквизитов.Дата, "ДЛФ=Д"));
	КонецЦикла;
	
	ТекстГиперссылки = НСтр("ru = 'документы не найдены'");
	Если ТаблицаДанных.Количество() > 1 Тогда
		ТекстГиперссылки = НСтр("ru = 'открыть список (%1)'");
		ТекстГиперссылки = СтрЗаменить(ТекстГиперссылки, "%1", ТаблицаДанных.Количество());
	ИначеЕсли ТаблицаДанных.Количество() = 1 Тогда
		ТекстГиперссылки = ТаблицаДанных[0].НаименованиеФайла;
	КонецЕсли;
	ЭДНадпись = ТекстГиперссылки;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьДоступностьЭлементов()
	
	Элементы.РегистрацияОрганизации.Видимость = Не ОрганизацияЗарегистрирована;
	Элементы.РегистрацияКонтрагента.Видимость = Не КонтрагентЗарегистрирован И ЕстьПодключениеКСервису;
	Элементы.Контрагент.Видимость = КонтрагентЗарегистрирован;
	
	Элементы.Зарегистрировать.Видимость = Не ЕстьПодключениеКСервису;
	Элементы.Зарегистрировать.Доступность = ЗарегистрироватьОрганизацию;
	
	Если Не ОрганизацияЗарегистрирована И Не КонтрагентЗарегистрирован Тогда
		Элементы.ТекстРегистрацииКонтрагента.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.ЧертаСверху, 1);
	КонецЕсли;
	
	ТребуетсяОтправкаУведомления = НЕ КонтрагентЗарегистрирован И ЗначениеЗаполнено(ЭлектронныйАдресУведомления);
	НаправитьУведомление = ТребуетсяОтправкаУведомления;
	Элементы.ЭлектронныйАдресУведомления.Доступность = ТребуетсяОтправкаУведомления;
	
	Если СписокИстории.Количество() = 0 Тогда
		Элементы.История.Гиперссылка = Ложь;	
		Состояние = НСтр("ru = 'не отправлен'");
	ИначеЕсли СписокИстории.Количество() = 1 Тогда 
		Элементы.История.Гиперссылка = Истина;
		ОтправленныеДанные = СписокИстории[0];
		Если ВРег(ОтправленныеДанные.Статус) = "ДОСТАВЛЕН" Тогда
			Состояние = НСтр("ru = 'доставлен'") + " " + Формат(ОтправленныеДанные.ДатаДоставки, "ДЛФ=D");
		Иначе
			Состояние = НСтр("ru = 'отправлен'") + " " + Формат(ОтправленныеДанные.Дата, "ДЛФ=D");
		КонецЕсли;
	Иначе
		Элементы.История.Гиперссылка = Истина;	
		ШаблонСостояния = НСтр("ru = 'отправлено (%1)'");
		Состояние = СтрШаблон(ШаблонСостояния, СписокИстории.Количество());
	КонецЕсли;
	
	Элементы.Отправить.Доступность = ОрганизацияЗарегистрирована;
	
	Элементы.УведомлятьПоПочте.Доступность = Не ПустаяСтрока(ЭлектроннаяПочта);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьДокументыВСервис()
	
	Отказ = Ложь;
	ОтправитьДокументыНаСервере(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОповещения	= НСтр("ru = 'Отправка выполнена.'");
	ТекстПояснения	= НСтр("ru = 'Отправлен документ через сервис 1С:Бизнес-сеть.'");
	ПоказатьОповещениеПользователя(ТекстОповещения, ПолучитьНавигационнуюСсылку(Ссылка),
		ТекстПояснения, БиблиотекаКартинок.БизнесСеть);
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьДокументыНаСервере(Отказ)
	
	Если ЗарегистрироватьОрганизацию Тогда
		// Регистрация организации в сервисе.
		МассивОрганизаций = Новый Массив;
		МассивОрганизаций.Добавить(Организация);
		БизнесСеть.ЗарегистрироватьОрганизации(МассивОрганизаций, Отказ, Неопределено, Неопределено);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МассивИдентификаторов = Новый Массив;
	
	Результат = Неопределено;
	Для каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		ПараметрыКоманды = Новый Структура();
		ПараметрыКоманды.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
		ПараметрыКоманды.Вставить("Отправитель",             Организация);
		ПараметрыКоманды.Вставить("Получатель",              Контрагент);
		ПараметрыКоманды.Вставить("Заголовок",               СтрокаТаблицы.НаименованиеФайла);
		ПараметрыКоманды.Вставить("Ссылка",                  СтрокаТаблицы.ВладелецЭД);
		ПараметрыКоманды.Вставить("ВидЭД",                   СтрокаТаблицы.ВидЭД);
		ПараметрыКоманды.Вставить("Сумма",                   СтрокаТаблицы.Сумма);
		ПараметрыКоманды.Вставить("АдресХранилища",          СтрокаТаблицы.АдресХранилища);
		ПараметрыКоманды.Вставить("ТипПредставления",        СтрокаТаблицы.ТипПредставления);
		ПараметрыКоманды.Вставить("СопроводительнаяИнформация", СопроводительнаяИнформация);
		ПараметрыКоманды.Вставить("АдресХранилищаПредставления", СтрокаТаблицы.АдресХранилищаПредставления);
		ПараметрыКоманды.Вставить("КонтактноеЛицо",          КонтактноеЛицо);
		ПараметрыКоманды.Вставить("Телефон",                 Телефон);
		ПараметрыКоманды.Вставить("ЭлектроннаяПочта",        ЭлектроннаяПочта);
		ПараметрыКоманды.Вставить("УведомлятьПоПочте",       УведомлятьПоПочте);
		
		БизнесСетьВызовСервера.ОтправитьДокумент(ПараметрыКоманды, Результат, Отказ);
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		МассивИдентификаторов.Добавить(Результат.Данные);
		
	КонецЦикла;
	
	Если Не Отказ Тогда
		// Направление уведомления об отправке электронного документа через сервис.
		Если НаправитьУведомление Тогда
			БизнесСетьВызовСервера.ОтправитьУведомлениеОбОтправке(Контрагент, МассивИдентификаторов,
				ЭлектронныйАдресУведомления, Результат, Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДокументовИстории(МассивСтруктур)
	
	МассивИдентификаторовДокументов = Новый Массив;
	Для Каждого СтрокаДанных Из СписокИстории Цикл
		МассивИдентификаторовДокументов.Добавить(СтрокаДанных.Идентификатор);
	КонецЦикла;
	МассивДанныхДокументов = БизнесСетьВызовСервера.ПолучитьДанныеДокументаСервиса(МассивИдентификаторовДокументов, Ложь, УникальныйИдентификатор);
	
	МассивСтруктур = Новый Массив;
	Для Каждого СтрокаДанных Из СписокИстории Цикл
		ПараметрыЭД = Новый Структура;
		ПараметрыЭД.Вставить("Контрагент");
		ПараметрыЭД.Вставить("ВладелецЭД");
		ПараметрыЭД.Вставить("Дата");
		ПараметрыЭД.Вставить("Статус");
		ПараметрыЭД.Вставить("Идентификатор");
		ПараметрыЭД.Вставить("Получатель");
		ПараметрыЭД.Вставить("Информация");
		ПараметрыЭД.Вставить("КонтрагентИНН");
		ПараметрыЭД.Вставить("КонтрагентКПП");
		ПараметрыЭД.Вставить("Источник");
		ПараметрыЭД.Вставить("ДатаДоставки");
		ПараметрыЭД.Вставить("КонтактноеЛицо");
		ПараметрыЭД.Вставить("Телефон");
		ПараметрыЭД.Вставить("ЭлектроннаяПочта");
		ЗаполнитьЗначенияСвойств(ПараметрыЭД, СтрокаДанных);
		
		// Заполнение дополнительных параметров.
		АдресХранилища = МассивДанныхДокументов[СписокИстории.Индекс(СтрокаДанных)];
		ПараметрыЭД.Вставить("АдресХранилища", АдресХранилища);
		ПараметрыЭД.Вставить("ФайлАрхива", Истина);
		ПараметрыЭД.Вставить("НаименованиеФайла", СтрокаДанных.Наименование);
		ПараметрыЭД.Вставить("Контрагент", Контрагент);
		ПараметрыЭД.Вставить("НаправлениеЭД", ПредопределенноеЗначение("Перечисление.НаправленияЭД.Исходящий"));
		
		МассивСтруктур.Добавить(ПараметрыЭД);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПодключенияЭДООбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СпособыОЭД = Новый Массив;
	СпособыОЭД.Добавить(ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезСервис1СЭДО"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СпособыОбменаЭД", СпособыОЭД);
	ПараметрыФормы.Вставить("Организация", Организация);
	ОткрытьФорму("Справочник.ПрофилиНастроекЭДО.Форма.ПомощникПодключенияЭДО", ПараметрыФормы);

КонецПроцедуры

&НаСервере
Процедура ЗарегистрироватьОрганизациюНаСервере(Отказ)
	
	Результат = Неопределено;
	
	// Регистрация организации.
	МассивОрганизаций = Новый Массив;
	МассивОрганизаций.Добавить(Организация);
	БизнесСеть.ЗарегистрироватьОрганизации(МассивОрганизаций, Отказ, Неопределено, Неопределено);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизацияЗарегистрирована = Истина;
	ЕстьПодключениеКСервису = Истина;
	Элементы.Зарегистрировать.Видимость = Ложь;
	
	// Проверка регистрации контрагента.
	ПараметрыКоманды = Новый Структура("Ссылка, ИНН, КПП", Контрагент);
	БизнесСеть.ВыполнитьКомандуСервиса("ПолучитьРеквизитыУчастника", ПараметрыКоманды, Результат, Отказ);
	Если Не Отказ И Результат <> Неопределено И Результат.КодСостояния = 200 Тогда
		ДанныеСервиса = Неопределено;
		Если Результат.Свойство("Данные", ДанныеСервиса) И ТипЗнч(ДанныеСервиса) = Тип("Структура") Тогда
			КонтрагентЗарегистрирован = Истина;	
		КонецЕсли;
	КонецЕсли;
	
	// Обновление видимости элементов.
	ИзменитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьФлагаУведомлятьПоПочте()
	
	Элементы.УведомлятьПоПочте.Доступность = Не ПустаяСтрока(ЭлектроннаяПочта);
	Если Не Элементы.УведомлятьПоПочте.Доступность Тогда
		УведомлятьПоПочте = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
