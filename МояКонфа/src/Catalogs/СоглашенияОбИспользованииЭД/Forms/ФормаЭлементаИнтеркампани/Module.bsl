// Электронный документооборот (для Интеркампани) нужен для фиксации юридической значимости
// совершаемых хозяйственных операций (передача/возврат товара между организациями).
// Исходя из этого, любой ЭД, сформированный в рамках Интеркампани, должен иметь ЭП.
// Следовательно, в соглашении об использовании ЭД, достаточно указать вид ЭД,
// что автоматически будет подразумевать необходимость подписывать его и получать
// подтверждение о подписании его другой стороной.

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("РежимОткрытияОкна") Тогда
		РежимОткрытияОкна = Параметры.РежимОткрытияОкна;
	КонецЕсли;
	
	ЗаполнитьВидыЭДДоступнымиЗначениями();
	
	ОбъектЭлемента = РеквизитФормыВЗначение("Объект");
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда // Новый
		Если Параметры.Свойство("Типовое") И Параметры.Типовое Тогда
			Объект.УдалитьЭтоТиповое = Истина;
		КонецЕсли;
		Объект.ЭтоИнтеркампани  = Истина;
		Объект.СтатусСоглашения = Перечисления.СтатусыСоглашенийЭД.НеСогласовано;
		Если НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда // Не копирование
			Объект.Контрагент = ОбменСКонтрагентамиПовтИсп.ПолучитьПустуюСсылку("Организации");
		Иначе
			// При копировании не переносим настройки шифрования и эталонные сертификаты контрагента.
			Объект.СертификатОрганизацииДляРасшифровки = Неопределено;
			Объект.ПроверятьСертификатыПодписей        = Ложь;
			Объект.СертификатыПодписейКонтрагента.Очистить();
		КонецЕсли;
	Иначе
		ДокументОбъект = РеквизитФормыВЗначение("Объект");
		Попытка
			ДвоичныеДанныеСертификата  = ДокументОбъект.СертификатКонтрагентаДляШифрования.Получить();
			Если ДвоичныеДанныеСертификата <> Неопределено Тогда
				СертификатКриптографии = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
				ПредставлениеСертификата = ЭлектроннаяПодписьКлиентСервер.ПредставлениеСубъекта(СертификатКриптографии);
				ФормаСертификатКонтрагентаДляШифрования = ПредставлениеСертификата;
			КонецЕсли;
			ОпределитьДоступностьСертификатовПодписей();
			ПеречитатьДанныеПоСертификатам(ДокументОбъект);
		Исключение
			ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(
				НСтр("ru = 'открытие формы соглашения'"), ТекстОшибки, ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	
	ИспользуютсяЭП = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ЗначениеФункциональнойОпции("ИспользоватьЭлектронныеПодписиЭД");
	Если НЕ ИспользуютсяЭП Тогда
		Элементы.ИсходящиеДокументыИспользоватьЭП.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаШапкаПраво.Видимость                                 = НЕ Объект.УдалитьЭтоТиповое;
	Элементы.СертификатыЭП.Видимость                                   = НЕ Объект.УдалитьЭтоТиповое И ИспользуютсяЭП;
	Если Объект.УдалитьЭтоТиповое Тогда
		Для Каждого Элемент Из Элементы.ГруппаШапкаПраво.ПодчиненныеЭлементы Цикл
			Элемент.РастягиватьПоГоризонтали = Истина;
		КонецЦикла;
	КонецЕсли;
	ТекущийСпособОбменаЭД = Объект.СпособОбменаЭД;
	ОбновитьЗаголовокФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ПеречитатьДанныеПоСертификатам(ДокументОбъект);
	ОбновитьЗаголовокФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ Объект.УдалитьЭтоТиповое Тогда
		Если Объект.СтатусСоглашения = ПредопределенноеЗначение("Перечисление.СтатусыСоглашенийЭД.Действует") Тогда
			ТекстОшибкиАктуальности = "";
			ПроверитьАктуальностьДанныхСоглашения(ТекстОшибкиАктуальности);
			Если НЕ ПустаяСтрока(ТекстОшибкиАктуальности) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибкиАктуальности, , , , Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИзменитьНадписьНаправлениеДокументов();
	
	СправочникОрганизации = ЭлектронноеВзаимодействиеСлужебныйКлиентПовтИсп.ИмяПрикладногоСправочника("Организации");
	ПустаяСсылкаНаОрганизацию = ПредопределенноеЗначение("Справочник." + СправочникОрганизации + ".ПустаяСсылка");
	
	МассивОрганизаций = СписокОрганизаций(ПустаяСсылкаНаОрганизацию);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОпределитьДоступностьСертификатовПодписей();
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаИсходящиеДокументы Тогда
		Если  НЕ Элементы.ИсходящиеДокументы.ТекущаяСтрока=Неопределено Тогда
			
			СтруктураПараметров = СтруктураПараметровВидаЭД();
			СтруктураПараметров.СпособОбмена          = Объект.СпособОбменаЭД;
			СтруктураПараметров.Направление           = Перечисления.НаправленияЭД.Интеркампани;
			СтруктураПараметров.ИспользоватьПодпись   = Объект.ИсходящиеДокументы[Элементы.ИсходящиеДокументы.ТекущаяСтрока].ИспользоватьЭП;
			СтруктураПараметров.ИспользоватьКвитанции = Объект.ИсходящиеДокументы[Элементы.ИсходящиеДокументы.ТекущаяСтрока].ОжидатьКвитанциюОДоставке;
			
			Если НЕ Объект.ИсходящиеДокументы[Элементы.ИсходящиеДокументы.ТекущаяСтрока].Формировать Тогда
				СтруктураПараметров = Неопределено;
			КонецЕсли;
			
			УстановитьЗначенияЭтаповОбменаПоНастройкам(СтруктураПараметров);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СписокСтрокКУдалению = Новый СписокЗначений;
	Для каждого СтрокаСертификата Из ТекущийОбъект.СертификатыПодписейКонтрагента Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаСертификата.Отпечаток) Тогда
			СписокСтрокКУдалению.Добавить(СтрокаСертификата.НомерСтроки);
		КонецЕсли;
	КонецЦикла;
	
	СписокСтрокКУдалению.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
	
	Для Каждого Запись Из СписокСтрокКУдалению Цикл
		ТекущийОбъект.СертификатыПодписейКонтрагента.Удалить(Запись.Значение - 1);
	КонецЦикла
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ОбновитьЗаголовокФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтправительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ДопПараметры = Новый Структура("ИмяРеквизита, ВыбранноеЗначение", "Организация", ВыбранноеЗначение);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьИзменениеОтправителяПолучателя", ЭтотОбъект, ДопПараметры);
	Если ЗначениеЗаполнено(Объект.ИдентификаторОрганизации) Тогда
		Если ВыбранноеЗначение <> Объект.Организация Тогда
			ТекстВопроса = НСтр("ru = 'Была изменена организация. Изменить идентификатор обмена организации?'");
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		КонецЕсли;
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверятьСертификатыПодписейПриИзменении(Элемент)
	
	ОпределитьДоступностьСертификатовПодписей();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтправительПриИзменении(Элемент)
	
	ЗаполнитьНаименование();
	ИзменитьНадписьНаправлениеДокументов();
	ЗаполнитьСписокВыбораОрганизаций(Элементы.Контрагент.СписокВыбора, Объект.Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ДопПараметры = Новый Структура("ИмяРеквизита, ВыбранноеЗначение", "Контрагент", ВыбранноеЗначение);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьИзменениеОтправителяПолучателя", ЭтотОбъект, ДопПараметры);
	Если ЗначениеЗаполнено(Объект.ИдентификаторКонтрагента) Тогда
		Если ВыбранноеЗначение <> Объект.Контрагент Тогда
			ТекстВопроса = НСтр("ru = 'Была изменена организация получатель. Изменить идентификатор получателя?'");
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		КонецЕсли;
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательПриИзменении(Элемент)
	
	ЗаполнитьНаименование();
	ИзменитьНадписьНаправлениеДокументов();
	ЗаполнитьСписокВыбораОрганизаций(Элементы.ОрганизацияОтправитель.СписокВыбора, Объект.Контрагент);

КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторОрганизацииПриИзменении(Элемент)
	
	Объект.ИдентификаторОрганизации = СокрЛП(Объект.ИдентификаторОрганизации);
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторКонтрагентаПриИзменении(Элемент)
	
	Объект.ИдентификаторКонтрагента = СокрЛП(Объект.ИдентификаторКонтрагента);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИсходящиеДокументы

&НаКлиенте
Процедура ИсходящиеДокументыПриИзменении(Элемент)
	
	Элемент.ТекущиеДанные.ИспользоватьЭП = Элемент.ТекущиеДанные.Формировать;
	
	ЗаполнитьТаблицуЭтапов();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсходящиеДокументыПриАктивизацииСтроки(Элемент)
	
	ЗаполнитьТаблицуЭтапов();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсходящиеДокументыИспользоватьОбменПриИзменении(Элемент)
	
	ЗначениеЭлемента = Элемент.Родитель.ТекущиеДанные.Формировать;
	Если НЕ ЗначениеЭлемента Тогда
		
		Элемент.Родитель.ТекущиеДанные.ОжидатьКвитанциюОДоставке = ЗначениеЭлемента;
		Элемент.Родитель.ТекущиеДанные.ИспользоватьЭП           = ЗначениеЭлемента;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСертификатыПодписей

&НаКлиенте
Процедура СертификатыПодписейКонтрагентаПредставлениеСертификатаКонтрагентаПриИзменении(Элемент)
	
	ДопПараметры = Новый Структура("ТекстРедактирования", Элемент.ТекстРедактирования);
	ОбработчикПродолжения = Новый ОписаниеОповещения("ОбработатьИзменениеФайлаСертификата", ЭтотОбъект, ДопПараметры);
	ПроверитьЗаписатьСоглашение(ОбработчикПродолжения);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПодписейКонтрагентаПредставлениеСертификатаКонтрагентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработчикПродолжения = Новый ОписаниеОповещения("ВыбратьФайлСертификата", ЭтотОбъект);
	ПроверитьЗаписатьСоглашение(ОбработчикПродолжения);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПодписейКонтрагентаПредставлениеСертификатаКонтрагентаОчистка(Элемент, СтандартнаяОбработка)
	
	СтруктураПараметров = СтруктураСертификата();
	ДобавитьДанныеПоТабЧасти(
		Объект.СертификатыПодписейКонтрагента.Индекс(Элементы.СертификатыПодписейКонтрагента.ТекущиеДанные),
		Неопределено,
		СтруктураПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПодписейКонтрагентаПослеУдаления(Элемент)
	
	ОбновитьДанныеДокумента();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОбъектЗаполнен()
	
	Возврат РеквизитФормыВЗначение("Объект").ПроверитьЗаполнение();
	
КонецФункции

&НаСервере
Процедура УстановитьИдентификатор(ИсточникИдентификатора, Данные)
	
	Если ИсточникИдентификатора = "Организация" Тогда
		СтрокаЗаполнения = Строка(Данные.ИНН)+"_"+Строка(Данные.КПП);
		Если Прав(СтрокаЗаполнения, 1) = "_" Тогда
			СтрокаЗаполнения = СтрЗаменить(СтрокаЗаполнения, "_", "");
		КонецЕсли;
		Объект.ИдентификаторОрганизации = СокрЛП(СтрокаЗаполнения);
	Иначе
		СтрокаЗаполнения = Строка(Данные.ИНН)+"_"+Строка(Данные.КПП);
		Если Прав(СтрокаЗаполнения, 1) = "_" Тогда
			СтрокаЗаполнения = СтрЗаменить(СтрокаЗаполнения, "_", "");
		КонецЕсли;
		Объект.ИдентификаторКонтрагента = СокрЛП(СтрокаЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидыЭДДоступнымиЗначениями()
	
	АктуальныеВидыЭД = ОбменСКонтрагентамиПовтИсп.ПолучитьАктуальныеВидыЭД();
	
	Для Каждого ЗначениеПеречисления Из АктуальныеВидыЭД Цикл
		Если ЗначениеПеречисления = Перечисления.ВидыЭД.ВозвратТоваровМеждуОрганизациями
			ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ПередачаТоваровМеждуОрганизациями Тогда
			
			МассивСтрок = Объект.ВходящиеДокументы.НайтиСтроки(Новый Структура("ВходящийДокумент", ЗначениеПеречисления));
			Если МассивСтрок.Количество() = 0 Тогда
				НоваяСтрока = Объект.ВходящиеДокументы.Добавить();
				НоваяСтрока.ВходящийДокумент = ЗначениеПеречисления;
			КонецЕсли;
			
			МассивСтрок = Объект.ИсходящиеДокументы.НайтиСтроки(Новый Структура("ИсходящийДокумент", ЗначениеПеречисления));
			Если МассивСтрок.Количество() = 0 Тогда
				НоваяСтрока = Объект.ИсходящиеДокументы.Добавить();
				НоваяСтрока.ИсходящийДокумент = ЗначениеПеречисления;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьДоступностьСертификатовПодписей()
	
	Элементы.СертификатыПодписейКонтрагента.Доступность = Объект.ПроверятьСертификатыПодписей;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияЭтаповОбменаПоНастройкам(СтруктураПараметров)
	
	МассивСтатусов = ОбменСКонтрагентамиСлужебный.ВернутьМассивСтатусовЭД(СтруктураПараметров);
	Если ТаблицаЭтаповИсходящие <> Неопределено Тогда
		ТаблицаЭтаповИсходящие.Очистить();
		
		Для Каждого Элемент Из МассивСтатусов Цикл
			ТаблицаЭтаповИсходящие.Добавить(Элемент);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруПараметров(СтруктураДанных)
	
	СтруктураПараметров = СтруктураПараметровВидаЭД();
	Если СтруктураДанных.Формировать Тогда
		ЗаполнитьЗначенияСвойств(СтруктураПараметров, СтруктураДанных);
		СтруктураПараметров.СпособОбмена = Объект.СпособОбменаЭД;
		СтруктураПараметров.Направление = Перечисления.НаправленияЭД.Исходящий;
		СтруктураПараметров.ВерсияФорматаПакета = Неопределено;
		СтруктураПараметров.ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовВерсииЭД.ПервичныйЭД;
	КонецЕсли;
	УстановитьЗначенияЭтаповОбменаПоНастройкам(СтруктураПараметров);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСертификатыТабличнойЧасти(АдресВХранилище, ИндексСтроки, ПараметрыСертификата)
	
	ДанныеФайла              = ПолучитьИзВременногоХранилища(АдресВХранилище);
	ДобавитьДанныеПоТабЧасти(ИндексСтроки, ДанныеФайла, ПараметрыСертификата);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьДанныеПоТабЧасти(ИндексСтроки, ДвоичныеДанные, СтруктураПараметровРезультата)
	
	Если ИндексСтроки < 0 Тогда
		Возврат ;
	КонецЕсли;
	
	Если ДвоичныеДанные <> Неопределено Тогда
		
		СертификатПодписи = Новый СертификатКриптографии(ДвоичныеДанные);
		ПредставлениеСертификата = ЭлектроннаяПодписьКлиентСервер.ПредставлениеСубъекта(СертификатПодписи);
		Отпечаток = Base64Строка(СертификатПодписи.Отпечаток);
		
		ХранилищеЗначения  = Новый ХранилищеЗначения(ДвоичныеДанные);
		Документ = РеквизитФормыВЗначение("Объект");
		Документ.СертификатыПодписейКонтрагента[ИндексСтроки].Сертификат = ХранилищеЗначения;
		Документ.СертификатыПодписейКонтрагента[ИндексСтроки].Отпечаток  = Отпечаток;
		Документ.Записать();
		
		ЗначениеВРеквизитФормы(Документ, "Объект");
		Прочитать();
		ПеречитатьДанныеПоСертификатам(Документ);
		
		СтруктураПараметровРезультата.Представление = ПредставлениеСертификата;
		СтруктураПараметровРезультата.Отпечаток     = Отпечаток;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПеречитатьДанныеПоСертификатам(ДокументОбъект)
	
	Для Каждого ЭлементСтрока Из ДокументОбъект.СертификатыПодписейКонтрагента Цикл
		ДвоичныеДанныеСертификата = ЭлементСтрока.Сертификат.Получить();
		Если ДвоичныеДанныеСертификата <> Неопределено Тогда
			Попытка
				СертификатПодписи = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
			Исключение
				Операция = НСтр("ru = 'Чтение данных сертификата'");
				ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(
					Операция, ТекстОшибки, ТекстСообщения);
				Продолжить;
			КонецПопытки;
			ПредставлениеСертификата = ЭлектроннаяПодписьКлиентСервер.ПредставлениеСубъекта(СертификатПодписи);
			Объект.СертификатыПодписейКонтрагента[ДокументОбъект.СертификатыПодписейКонтрагента.Индекс(ЭлементСтрока)].ПредставлениеСертификатаКонтрагента = ПредставлениеСертификата;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеДокумента()
	
	Документ = РеквизитФормыВЗначение("Объект");
	ПеречитатьДанныеПоСертификатам(Документ);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьАктуальностьДанныхСоглашения(ТекстОшибкиАктуальности)
	
	ЗапросПоСоглашениям = Новый Запрос;
	ЗапросПоСоглашениям.УстановитьПараметр("СтатусСоглашения",  Перечисления.СтатусыСоглашенийЭД.Действует);
	ЗапросПоСоглашениям.УстановитьПараметр("ТекущееСоглашение", Объект.Ссылка);
	ЗапросПоСоглашениям.УстановитьПараметр("Организация",       Объект.Организация);
	ЗапросПоСоглашениям.УстановитьПараметр("Контрагент",        Объект.Контрагент);
	ЗапросПоСоглашениям.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СоглашенияОбИспользованииЭДВходящиеДокументы.ВходящийДокумент КАК ТипДокумента,
	|	ИСТИНА КАК Входящий,
	|	СоглашенияОбИспользованииЭДВходящиеДокументы.Ссылка КАК Соглашение
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД.ВходящиеДокументы КАК СоглашенияОбИспользованииЭДВходящиеДокументы
	|ГДЕ
	|	СоглашенияОбИспользованииЭДВходящиеДокументы.Ссылка.СтатусСоглашения = &СтатусСоглашения
	|	И СоглашенияОбИспользованииЭДВходящиеДокументы.Ссылка.УдалитьЭтоТиповое = ЛОЖЬ
	|	И СоглашенияОбИспользованииЭДВходящиеДокументы.Формировать = ИСТИНА
	|	И СоглашенияОбИспользованииЭДВходящиеДокументы.Ссылка.ПометкаУдаления = ЛОЖЬ
	|	И СоглашенияОбИспользованииЭДВходящиеДокументы.Ссылка <> &ТекущееСоглашение
	|	И СоглашенияОбИспользованииЭДВходящиеДокументы.Ссылка.Организация = &Организация
	|	И СоглашенияОбИспользованииЭДВходящиеДокументы.Ссылка.Контрагент = &Контрагент
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.ИсходящийДокумент,
	|	ЛОЖЬ,
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД.ИсходящиеДокументы КАК СоглашенияОбИспользованииЭДИсходящиеДокументы
	|ГДЕ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Формировать = ИСТИНА
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.УдалитьЭтоТиповое = ЛОЖЬ
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.СтатусСоглашения = &СтатусСоглашения
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.ПометкаУдаления = ЛОЖЬ
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка <> &ТекущееСоглашение
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.Организация = &Организация
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.Контрагент = &Контрагент";
	
	Результат = ЗапросПоСоглашениям.Выполнить().Выгрузить();
	
	ТекстОшибкиИсходящие = "";
	ТекстОшибкиВходящие = "";
	ПроверитьУникальностьДокументов(Объект.ИсходящиеДокументы, Результат, ТекстОшибкиИсходящие);
	ПроверитьУникальностьДокументов(Объект.ВходящиеДокументы, Результат, ТекстОшибкиВходящие, Истина);
	
	ТекстОшибкиАктуальности = ТекстОшибкиИсходящие + ТекстОшибкиВходящие;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьУникальностьДокументов(ТабличнаяЧастьДокументов, РезультатПроверки, ТекстОшибки, ПроверятьВходящиеДокументы = Ложь)
	
	ОтборСуществующихДокументов = Новый Структура("Входящий", ПроверятьВходящиеДокументы);
	ВидыДокументовДругихСоглашений = РезультатПроверки.НайтиСтроки(ОтборСуществующихДокументов);
	Если ВидыДокументовДругихСоглашений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекущийДокументСоглашения Из ТабличнаяЧастьДокументов Цикл
		Если ТекущийДокументСоглашения.Формировать Тогда
			Для Каждого ДокументВДругихСоглашениях Из ВидыДокументовДругихСоглашений Цикл
				Если ТекущийДокументСоглашения[?(ПроверятьВходящиеДокументы, "ВходящийДокумент", "ИсходящийДокумент")] = ДокументВДругихСоглашениях.ТипДокумента Тогда
					ТекстОшибки =  НСтр("ru = 'По виду электронных документов %1 %2'")
					+ Символы.ПС + НСтр("ru = 'уже существует действующее соглашение между участниками %3 - %4:'")
					+ Символы.ПС + НСтр("ru = '%5.'") + Символы.ПС;
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						ТекстОшибки, ДокументВДругихСоглашениях.ТипДокумента,
						?(ПроверятьВходящиеДокументы, "Входящий", "Исходящий"),
						Объект.Организация,
						Объект.Контрагент,
						ДокументВДругихСоглашениях.Соглашение);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаписатьСоглашение(ОбработчикПродолжения)
	
	Если НЕ Параметры.Ключ.Пустая() Тогда
		ВыполнитьОбработкуОповещения(ОбработчикПродолжения);
	КонецЕсли;
	
	ДопПараметры = Новый Структура("ОбработчикПродолжения", ОбработчикПродолжения);
	Если НЕ Объект.УдалитьЭтоТиповое Тогда
		ТекстВопроса = НСтр("ru = 'Внешние сертификаты можно выбирать только в записанном соглашении.
		|Записать соглашение?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗакончитьПроверкуСоглашения", ЭтотОбъект, ДопПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	Иначе
		ЗакончитьПроверкуСоглашения(КодВозвратаДиалога.Да, ДопПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьНадписьНаправлениеДокументов()
	
	ШаблонСообщения = НСтр("ru='От кого: %1, кому: %2'");
	НадписьНаправлениеДокументов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, 
		Объект.Организация, Объект.Контрагент);
	
КонецПроцедуры

&НаСервере
Функция СписокОрганизаций(ИсключаемыйЭлемент)
	
	НазваниеСправочникаОрганизации = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника("Организации");
	Если Не ЗначениеЗаполнено(НазваниеСправочникаОрганизации) Тогда
		НазваниеСправочникаОрганизации = "Организации";
	КонецЕсли; 
	
	МассивОрганизаций = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка,
	|	Организации.Наименование
	|ИЗ
	|	Справочник."+ НазваниеСправочникаОрганизации +" КАК Организации
	|ГДЕ
	|	Организации.Ссылка <> &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ИсключаемыйЭлемент);
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		МассивОрганизаций = Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	КонецЕсли;
	
	Возврат МассивОрганизаций;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьНаименование()
	
	Организация = Объект.Организация;
	Контрагент  = Объект.Контрагент;
	Если НЕ ЗначениеЗаполнено(Объект.Наименование)
		И ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(Контрагент) Тогда
		Объект.Наименование = "" + Организация + " -> " + Контрагент;
	КонецЕсли;
	
	ОбновитьЗаголовокФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбораОрганизаций(СписокВыбора, ИсключаемыйЭлемент)
	
	МассивОрганизаций = СписокОрганизаций(ИсключаемыйЭлемент);
	Если МассивОрганизаций.Количество() > 0 Тогда
		СписокВыбора.ЗагрузитьЗначения(МассивОрганизаций);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СтруктураПараметровВидаЭД()
	
	СтруктураВозврата = Новый Структура("СпособОбмена, Направление, ВидЭД, ИспользоватьПодпись,
	|ИспользоватьКвитанции, ВерсияФорматаПакета,ТипЭлементаВерсииЭД");
	Возврат СтруктураВозврата;
	
КонецФункции

&НаКлиенте
Функция СтруктураСертификата()
	
	СтруктураВозврата =  Новый Структура("Представление, Отпечаток","","");
	Возврат СтруктураВозврата;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗаголовокФормы(Форма)
	
	ТекстЗаголовкаСоздание = НСтр("ru='Настройка ЭДО между организациями (создание)'");
	ТекстЗаголовка = НСтр("ru='%1 (Настройка ЭДО между организациями)'");
	
	Если ЗначениеЗаполнено(Форма.Объект.Ссылка) Тогда 
		Форма.Заголовок = СтрШаблон(ТекстЗаголовка,
			Форма.Объект.Наименование);
	Иначе
		Форма.Заголовок = ТекстЗаголовкаСоздание;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуЭтапов()
	
	Если Элементы.Страницы.ТекущаяСтраница <> Неопределено Тогда
		ТекущиеДанные = Неопределено;
		Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаИсходящиеДокументы Тогда
			ТекущиеДанные = Элементы.ИсходящиеДокументы.ТекущиеДанные;
			ВидЭД = ТекущиеДанные.ИсходящийДокумент;
		КонецЕсли;
		Если ТекущиеДанные <> Неопределено Тогда
			СтруктураДанных = Новый Структура("ИспользоватьПодпись, ИспользоватьКвитанции, Формировать, ВидЭД");
			СтруктураДанных.ИспользоватьПодпись = ТекущиеДанные.ИспользоватьЭП;
			СтруктураДанных.ИспользоватьКвитанции = ТекущиеДанные.ОжидатьКвитанциюОДоставке;
			СтруктураДанных.Формировать = ТекущиеДанные.Формировать;
			СтруктураДанных.ВидЭД = ВидЭД;
			ЗаполнитьСтруктуруПараметров(СтруктураДанных);
		КонецЕсли;
	КонецЕсли	

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Служебные обработчики асинхронных диалогов

&НаКлиенте
Процедура ЗакончитьПроверкуСоглашения(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да И ОбъектЗаполнен() Тогда
		ОбработчикПродолжения = "";
		Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
			И ДополнительныеПараметры.Свойство("ОбработчикПродолжения", ОбработчикПродолжения)
			И ТипЗнч(ОбработчикПродолжения) = Тип("ОписаниеОповещения") Тогда
			ВыполнитьОбработкуОповещения(ОбработчикПродолжения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеОтправителяПолучателя(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ВыбранноеЗначение = "";
		ИмяРеквизита = "";
		Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
			И ДополнительныеПараметры.Свойство("ИмяРеквизита", ИмяРеквизита)
			И ДополнительныеПараметры.Свойство("ВыбранноеЗначение", ВыбранноеЗначение) Тогда
			УстановитьИдентификатор(ИмяРеквизита, ВыбранноеЗначение);
		КонецЕсли;
		ЗаполнитьНаименование();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлОбработкаВыбора(Результат, Адрес, ИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
		ИндексСтроки = Объект.СертификатыПодписейКонтрагента.Индекс(Элементы.СертификатыПодписейКонтрагента.ТекущиеДанные);
		ПараметрыДобавленногоСертификата = СтруктураСертификата();
		ДобавитьСертификатыТабличнойЧасти(Адрес, ИндексСтроки, ПараметрыДобавленногоСертификата);
		Элементы.СертификатыПодписейКонтрагента.ТекущиеДанные.ПредставлениеСертификатаКонтрагента = ПараметрыДобавленногоСертификата.Представление;
		Элементы.СертификатыПодписейКонтрагента.ТекущиеДанные.Отпечаток                           = ПараметрыДобавленногоСертификата.Отпечаток;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеФайлаСертификата(Знач Неопределен, Знач ДополнительныеПараметры) Экспорт
	
	ТекстРедактирования = "";
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ТекстРедактирования", ТекстРедактирования)
		И ПустаяСтрока(ТекстРедактирования) Тогда
		СтруктураПараметров = СтруктураСертификата();
		ДобавитьДанныеПоТабЧасти(
			Объект.СертификатыПодписейКонтрагента.Индекс(Элементы.СертификатыПодписейКонтрагента.ТекущиеДанные),
			Неопределено,
			СтруктураПараметров);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлСертификата(Знач Неопределен, Знач ДополнительныеПараметры) Экспорт
	
	Обработчик = Новый ОписаниеОповещения("ФайлОбработкаВыбора", ЭтотОбъект);
	НачатьПомещениеФайла(Обработчик, , , Истина, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОрганизацияОтправитель.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИдентификаторОрганизации.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Контрагент.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИдентификаторКонтрагента.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.СтатусСоглашения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыСоглашенийЭД.Действует;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

#КонецОбласти

