
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
		ИнициализироватьКомпоновщикСервер(Неопределено);
	КонецЕсли;
	
	МодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, СтандартнаяОбработка, Отказ);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	Если Объект.ПредназначенаДляЭлектронныхПисем Тогда
		ЗаполнитьВложения();
	КонецЕсли;
	
	СохраненныйКомпоновщикНастроек = ТекущийОбъект.ОтборАдресатов.Получить();
	ИнициализироватьКомпоновщикСервер(СохраненныйКомпоновщикНастроек);
	ТекстЗаголовкаФильтрАдресатов(ЭтотОбъект);
	
	Если Объект.ДополнительныеПолучатели.Количество() > 0 
		И Объект.Статус <> Перечисления.СтатусыРассылокКлиентам.Обрабатывается
		И Объект.Статус <> Перечисления.СтатусыРассылокКлиентам.Выполнена Тогда
		
		ЗаполнитьТаблицыКИДополнительныхПолучателей();
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбработатьВложенияПриЗаписи(ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не Отказ Тогда
		
		РассылкиИОповещенияКлиентамКлиент.ПоместитьВложенияВоВременноеХранилище(Вложения);
		
	КонецЕсли;
	
	Объект.ЕстьВложения = (Вложения.Количество() <> 0) И Объект.ПредназначенаДляЭлектронныхПисем;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если Объект.ПредназначенаДляЭлектронныхПисем Тогда
		ЗаполнитьВложения();
	КонецЕсли;
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий)
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Объект.ПредназначенаДляЭлектронныхПисем И Объект.ТипТекстаПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
	
		РассылкиИОповещенияКлиентам.ФорматированныйДокументВHTMLПередЗаписью(
		          ТекстПисьмаФорматированныйДокумент,
		          ТекущийОбъект.ТекстПисьмаHTML,
		          ТекущийОбъект.ТипТекстаПисьма,
		          ТаблицаСоответствийИменВложенийИдентификаторам);
		
		Если ПустаяСтрока(ТекущийОбъект.ТекстПисьмаHTML) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			           НСтр("ru = 'Не заполнен текст письма'"),
			           ,
			           "ТекстПисьмаФорматированныйДокумент",
			           ,
			           Отказ);
			
		КонецЕсли;
		
	Иначе
		
		ТекущийОбъект.ТекстПисьмаHTML = "";
		
	КонецЕсли;

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийОбъект.ПредставлениеОтбора  = Строка(КомпоновщикНастроек.Настройки.Отбор);
	ТекущийОбъект.ОтборАдресатов       = Новый ХранилищеЗначения(КомпоновщикНастроек.ПолучитьНастройки());
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТранспортРассылкиПриИзменении(Элемент)
	
	ПредназначениеРассылкиПоФлагуТранспорт(ЭтаФорма);
	УправлениеДоступностью(ЭтаФорма);
	
	Если Объект.ДополнительныеПолучатели.Количество() > 0 Тогда
		ЗаполнитьТаблицыКИДополнительныхПолучателей();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппаРассылокИОповещенийПриИзменении(Элемент)
	
	ГруппаРассылокИОповещенийПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипТекстаПисьмаПриИзменении(Элемент)
	
	Если ТипТекстаПисьма = 0 Тогда
		
		ВзаимодействияКлиент.ВопросПриИзмененииФорматаСообщенияНаОбычныйТекст(ЭтаФорма);
		
	Иначе
		
		ТекстПисьмаФорматированныйДокумент.Добавить(Объект.ТекстПисьма);
		Объект.ТекстПисьма     = "";
		Объект.ТипТекстаПисьма = ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML");
		
		УправлениеДоступностью(ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьВТранслитеПриИзменении(Элемент)
	
	ОсталосьСимволов = ВзаимодействияКлиентСервер.СформироватьИнформационнуюНадписьКоличествоСимволовСообщений(
	                        Объект.ОтправлятьВТранслите,
	                        Объект.ТекстSMS);
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеНажатие(Элемент, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.Основание) Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, Объект.Основание);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборПриИзменении(Элемент)
	
	ТекстЗаголовкаФильтрАдресатов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборПередНачаломИзменения(Элемент, Отказ)
	
	Если НаОснованииОпроса Тогда
		Если Элемент.ТекущиеДанные <> Неопределено 
			И Элемент.ТекущиеДанные.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НазначениеОпроса") Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВложения

&НаКлиенте
Процедура ВложенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	РассылкиИОповещенияКлиентамКлиент.ДобавитьВложениеВыполнить(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьВложениеВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОткрытьВложениеВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	РассылкиИОповещенияКлиентамКлиент.ОбработатьПеретаскиваниеВложения(Вложения, ПараметрыПеретаскивания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПередУдалением(Элемент, Отказ)
	
	УдалитьВложениеВыполнить();
	Отказ = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ВложенияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТекстSMSПриИзменении(Элемент)
	
	ОсталосьСимволов      = ВзаимодействияКлиентСервер.СформироватьИнформационнуюНадписьКоличествоСимволовСообщений(
	                          Объект.ОтправлятьВТранслите,
	                          Объект.ТекстSMS);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВложения

&НаКлиенте
Процедура ДополнительныеПолучателиКонтактОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДополнительныеПолучатели.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Тип") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = ТекущиеДанные.Контакт Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Контакт = ВыбранноеЗначение;
	
	ЗаполнитьТаблицуАдресов(Элементы.ДополнительныеПолучатели.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПолучателиПриАктивизацииЯчейки(Элемент)
	
	ТекущиеДанные = Элементы.ДополнительныеПолучатели.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент.Имя = "ДополнительныеПолучателиКонтактнаяИнформация" Тогда
		СписокВыбора = Элементы.ДополнительныеПолучателиКонтактнаяИнформация.СписокВыбора;
		СписокВыбора.Очистить();
		Для Каждого СтрокаТаблицыАдресов Из ТекущиеДанные.ТаблицаАдресов Цикл
			СписокВыбора.Добавить(СтрокаТаблицыАдресов.Представление, СтрокаКИСВидом(СтрокаТаблицыАдресов.Представление, СтрокаТаблицыАдресов.ВидКонтактнойИнформации));
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтрокаКИСВидом(Представление, ВидКИ)

	Возврат Представление + " (" + Строка(ВидКИ) + ")";

КонецФункции

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ДобавитьВложениеВыполнить()
	
	РассылкиИОповещенияКлиентамКлиент.ДобавитьВложениеВыполнить(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВложениеВыполнить()
	
	РассылкиИОповещенияКлиентамКлиент.ОткрытьВложениеВыполнить(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВложениеВыполнить()

	РассылкиИОповещенияКлиентамКлиент.ПереместитьВложениеВУдаленные(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПараметрПредставлениеАдресата(Команда)
	
	ДобавитьПараметр("ПредставлениеАдресата");
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПараметрТекущаяДата(Команда)
	
	ДобавитьПараметр("ТекущаяДата");
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПараметрДатаНачалаОпроса(Команда)
	
	ДобавитьПараметр("ДатаНачалаОпроса");
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПараметрДатаОкончанияОпроса(Команда)
	
	ДобавитьПараметр("ДатаОкончанияОпроса");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ЗаписатьИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПараметрНаименованиеОпроса(Команда)
	
	ДобавитьПараметр("НаименованиеОпроса");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	НаОснованииОпроса = ЗначениеЗаполнено(Объект.Основание) И ТипЗнч(Объект.Основание) = Тип("ДокументСсылка.НазначениеОпросов");
	
	ГруппаРассылокИОповещенийПриИзмененииНаСервере(Истина);
	
	ОсталосьСимволов = ВзаимодействияКлиентСервер.СформироватьИнформационнуюНадписьКоличествоСимволовСообщений(
	                   Объект.ОтправлятьВТранслите,
	                   Объект.ТекстSMS);
	УстановитьСпособРедактированияПисьма();
	
	Если Объект.Статус = Перечисления.СтатусыРассылокКлиентам.Обрабатывается 
		ИЛИ Объект.Статус = Перечисления.СтатусыРассылокКлиентам.Выполнена Тогда
		
		Элементы.Статус.СписокВыбора.Очистить();
		Элементы.Статус.СписокВыбора.Добавить(Объект.Статус);
		
	КонецЕсли;
	
	УправлениеДоступностью(ЭтаФорма);
	
	Элементы.ДобавитьПараметрДатаНачалаОпросаПисьмо.Видимость    = НаОснованииОпроса;
	Элементы.ДобавитьПараметрДатаОкончанияОпросаПисьмо.Видимость = НаОснованииОпроса;
	Элементы.ДобавитьПараметрНаименованиеОпросаПисьмо.Видимость  = НаОснованииОпроса;
	Элементы.ДатаНачалаОпроса.Видимость                          = НаОснованииОпроса;
	Элементы.ДатаОкончанияОпроса.Видимость                       = НаОснованииОпроса;
	Элементы.НаименованиеОпроса.Видимость                        = НаОснованииОпроса;
	
	Элементы.СтраницаКомментарий.Картинка  = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)
	
	Форма.Элементы.ТранспортРассылки.Доступность = Форма.ДоступнаОтправкаПоSMS И Форма.ДоступнаОтправкаПоПочте;
	
	Если Форма.Объект.ПредназначенаДляЭлектронныхПисем Тогда
		
		Форма.Элементы.СтраницыТексты.ТекущаяСтраница = Форма.Элементы.СтраницаЭлектронноеПисьмо;
		
		Если Форма.ТипТекстаПисьма = 0 Тогда
			Форма.Элементы.СтраницыТекстПисьма.ТекущаяСтраница = Форма.Элементы.СтраницаТекстПисьмаОбычный;
		Иначе
			Форма.Элементы.СтраницыТекстПисьма.ТекущаяСтраница = Форма.Элементы.СтраницаТекстПисьмаHTML;
		КонецЕсли;
		
	Иначе
		
		Форма.Элементы.СтраницыТексты.ТекущаяСтраница = Форма.Элементы.СтраницаСообщениеSMS;
		
	КонецЕсли;
	
	ГруппаНеУказана = Форма.Объект.ГруппаРассылокИОповещений.Пустая();
	РедактированиеЗапрещено = Форма.Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыРассылокКлиентам.Обрабатывается")
		ИЛИ Форма.Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыРассылокКлиентам.Выполнена"); 
	
	Форма.Элементы.СтраницаСообщение.ТолькоПросмотр = ГруппаНеУказана Или РедактированиеЗапрещено;
	Форма.Элементы.СтраницаАдресаты.ТолькоПросмотр  = ГруппаНеУказана Или РедактированиеЗапрещено;
	Форма.Элементы.ГруппаШапка.ТолькоПросмотр       = РедактированиеЗапрещено;
	Форма.Элементы.ВложенияКонтекстноеМенюДобавитьВложение.Доступность = Не РедактированиеЗапрещено;
	Форма.Элементы.ВложенияКонтекстноеМенюУдалитьВложение.Доступность  = Не РедактированиеЗапрещено;
	Форма.Элементы.ГруппаДобавитьПараметрПисьмо.Доступность            = НЕ РедактированиеЗапрещено;
	Форма.Элементы.ГруппаДобавитьПараметрSMS.Доступность               = НЕ РедактированиеЗапрещено;
	
КонецПроцедуры

&НаСервере
Процедура ГруппаРассылокИОповещенийПриИзмененииНаСервере(ЧтениеСуществующего = Ложь)
	
	Если ЗначениеЗаполнено(Объект.ГруппаРассылокИОповещений) Тогда
		РеквизитыГруппы = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ГруппаРассылокИОповещений, "ПредназначенаДляЭлектронныхПисем, ПредназначенаДляSMS");
		ДоступнаОтправкаПоПочте = РеквизитыГруппы.ПредназначенаДляЭлектронныхПисем;
		ДоступнаОтправкаПоSMS   = РеквизитыГруппы.ПредназначенаДляSMS;
	Иначе
		ДоступнаОтправкаПоПочте = Ложь;
		ДоступнаОтправкаПоSMS   = Ложь;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() ИЛИ НЕ ЧтениеСуществующего  Тогда
		
		СтароеЗначениеТранспорт = ТранспортРассылки;
		Если ДоступнаОтправкаПоSMS И Не ДоступнаОтправкаПоПочте Тогда
			ТранспортРассылки = 1;
		ИначеЕсли ДоступнаОтправкаПоПочте И НЕ ДоступнаОтправкаПоSMS Тогда
			ТранспортРассылки = 0;
		КонецЕсли;
		ПредназначениеРассылкиПоФлагуТранспорт(ЭтаФорма);
		Если СтароеЗначениеТранспорт <> ТранспортРассылки И Объект.ДополнительныеПолучатели.Количество() > 0 Тогда
			ЗаполнитьТаблицыКИДополнительныхПолучателей();
		КонецЕсли;
		
	Иначе
		ТранспортРассылки = ?(Объект.ПредназначенаДляЭлектронныхПисем, 0, 1);
	КонецЕсли;
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПредназначениеРассылкиПоФлагуТранспорт(Форма)

	Форма.Объект.ПредназначенаДляЭлектронныхПисем = (Форма.ТранспортРассылки = 0);
	Форма.Объект.ПредназначенаДляSMS              = (Форма.ТранспортРассылки = 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПриИзмененииФорматаПриЗакрытии(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		
		УстановитьHTML(ТекстПисьмаФорматированныйДокумент, Объект.ТекстПисьмаHTML, Новый Структура);
		ТипТекстаПисьма = 1;
		
	Иначе
		
		Объект.ТипТекстаПисьма    = ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст");
		Объект.ТекстПисьма = ТекстПисьмаФорматированныйДокумент.ПолучитьТекст();
		ТекстПисьмаФорматированныйДокумент.Удалить();

	КонецЕсли;
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьHTML(РеквизитФорматированныйДокумент, ТекстHTML, Вложения)
	
	РеквизитФорматированныйДокумент.УстановитьHTML(ТекстHTML, Вложения);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСпособРедактированияПисьма()
	
	Если Объект.ТипТекстаПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
		
		ТипТекстаПисьма = 1;
		СтруктураВложений = Новый Структура;
		Если Не Объект.Ссылка.Пустая() Тогда
			Если Не ПустаяСтрока(Объект.ТекстПисьмаHTML) Тогда
				
				Объект.ТекстПисьмаHTML = Взаимодействия.ОбработатьТекстHTMLДляФорматированногоДокумента(Объект.Ссылка , Объект.ТекстПисьмаHTML,СтруктураВложений)
				
			КонецЕсли;
		ИначеЕсли ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			Если Не ПустаяСтрока(Объект.ТекстПисьмаHTML) Тогда
				
				Объект.ТекстПисьмаHTML = Взаимодействия.ОбработатьТекстHTMLДляФорматированногоДокумента(Параметры.ЗначениеКопирования , Объект.ТекстПисьмаHTML,СтруктураВложений)
				
			КонецЕсли;
		КонецЕсли;
		
		ТекстПисьмаФорматированныйДокумент.УстановитьHTML(Объект.ТекстПисьмаHTML, СтруктураВложений);
		
	Иначе
		
		Объект.ТипТекстаПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст;
		ТипТекстаПисьма = 0;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВложения(Параметры = Неопределено)
	
	Вложения.Очистить();
	ТаблицаВложений = СамообслуживаниеСервер.ВложенияОбъектаМетаданных(Объект.Ссылка, Истина, Ложь);
	Для Каждого СтрокаТаблицыВложений Из ТаблицаВложений Цикл
		НоваяСтрока = Вложения.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицыВложений);
		НоваяСтрока.Расположение = 0;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьВложенияПриЗаписи(ТекущийОбъект)
	
	Если Объект.ПредназначенаДляЭлектронныхПисем Тогда
		
		РассылкиИОповещенияКлиентам.ДобавитьВСписокУдаляемыхВложенияСНепустымИД(ТекущийОбъект.Ссылка, УдаленныеВложения);
		
		РассылкиИОповещенияКлиентам.УдалитьВложения(УдаленныеВложения);
		
		РассылкиИОповещенияКлиентам.СохранитьКартинкиФорматированнногоДокументаКакПрисоединенныеФайлы(
				ТекущийОбъект.Ссылка,
				ТекущийОбъект.ТипТекстаПисьма,
				ТаблицаСоответствийИменВложенийИдентификаторам,
				УникальныйИдентификатор);
				
		РассылкиИОповещенияКлиентам.СохранитьВложения(ТекущийОбъект.Ссылка, Вложения, УникальныйИдентификатор);
		
	ИначеЕсли Вложения.Количество() > 0 ИЛИ УдаленныеВложения.Количество() > 0 Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	РассылкаКлиентамПрисоединенныеФайлы.Ссылка
		|ИЗ
		|	Справочник.РассылкаКлиентамПрисоединенныеФайлы КАК РассылкаКлиентамПрисоединенныеФайлы
		|ГДЕ
		|	РассылкаКлиентамПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла";
		
		Запрос.УстановитьПараметр("ВладелецФайла", Объект.Ссылка);
		
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда
			
			Выборка = Результат.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				ПрисоединенныйФайлОбъект = Выборка.Ссылка.ПолучитьОбъект();
				ПрисоединенныйФайлОбъект.Удалить();
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьКомпоновщикСервер(НастройкаКомпоновки)
		
	ИмяМакета = ?(НаОснованииОпроса, "ОтборПартнеровНазначениеОпросов", "ОтборПартнеров");
	
	СхемаКомпоновки = Обработки.ПодборПартнеровПоОтбору.ПолучитьМакет(ИмяМакета);
	ПартнерыИКонтрагенты.ЗаголовокПоляСКДВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	                      СхемаКомпоновки.НаборыДанных.ОсновнойНаборДанных, "Партнер", НСтр("ru = 'Контрагент'"));
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновки,УникальныйИдентификатор);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	
	Если НастройкаКомпоновки = Неопределено Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновки.НастройкиПоУмолчанию);
		КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
		Если НаОснованииОпроса Тогда
			МассивЭлементовОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(КомпоновщикНастроек.Настройки.Отбор,"НазначениеОпроса");
			Для Каждого ЭлементОтбораНазначениеОпросов Из МассивЭлементовОтбора Цикл
				ЭлементОтбораНазначениеОпросов.Использование = Истина;
				ЭлементОтбораНазначениеОпросов.ПравоеЗначение = Объект.Основание;
			КонецЦикла; 
		КонецЕсли;
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкаКомпоновки);
		КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	КонецЕсли;
	
	ТекстЗаголовкаФильтрАдресатов(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуАдресов(ТекущаяСтрока)

	ТекущиеДанные  = Объект.ДополнительныеПолучатели.НайтиПоИдентификатору(ТекущаяСтрока);
	Контакт        = ТекущиеДанные.Контакт;
	ТаблицаАдресов = ТекущиеДанные.ТаблицаАдресов;
	
	ТребуемыйТипКонтакнойИнформации = ?(Объект.ПредназначенаДляЭлектронныхПисем,
	                                    Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
	                                    Перечисления.ТипыКонтактнойИнформации.Телефон);
	
	ИмяСправочника = Контакт.Метаданные().Имя;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	Таблица.Вид КАК ВидКонтактнойИнформации,
	|	Таблица.Тип КАК ТипКонтактнойИнформации,
	|	Таблица.Представление КАК Представление
	|ИЗ
	|	Справочник." + ИмяСправочника + ".КонтактнаяИнформация КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка = &Контакт
	|	И Таблица.Тип = &ТипКИ
	|	И Таблица.Представление <> """"";
	
	Запрос.УстановитьПараметр("Контакт", Контакт);
	Запрос.УстановитьПараметр("ТипКИ", ТребуемыйТипКонтактнойИнформации());
	
	ТаблицаАдресов.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Если ТаблицаАдресов.Количество() > 0 Тогда
		ТекущиеДанные.КонтактнаяИнформация = ТаблицаАдресов[0].Представление;
	ИначеЕсли ТаблицаАдресов.Количество() = 0 Тогда
		ТекущиеДанные.КонтактнаяИнформация = "";
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицыКИДополнительныхПолучателей()

	ТаблицаАдресов = Новый ТаблицаЗначений;
	ТаблицаАдресов.Колонки.Добавить("Представление",  Новый ОписаниеТипов("Строка"));
	ТаблицаАдресов.Колонки.Добавить("ВидКонтактнойИнформации",  Новый ОписаниеТипов("СправочникСсылка.ВидыКонтактнойИнформации"));
	
	ТекстЗапроса ="
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Контакты.Контакт,
	|	Контакты.КонтактнаяИнформация
	|ПОМЕСТИТЬ ВсеКонтакты
	|ИЗ
	|	&Контакты КАК Контакты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Контакты.Контакт
	|ПОМЕСТИТЬ Контакты
	|ИЗ
	|	ВсеКонтакты КАК Контакты
	|ГДЕ
	|	Контакты.Контакт <> НЕОПРЕДЕЛЕНО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПартнерыКонтактнаяИнформация.Представление КАК Представление,
	|	ПартнерыКонтактнаяИнформация.Вид КАК ВидКонтактнойИнформации,
	|	ПартнерыКонтактнаяИнформация.Ссылка КАК Контакт
	|ИЗ
	|	Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформация
	|ГДЕ
	|	ПартнерыКонтактнаяИнформация.Ссылка В
	|			(ВЫБРАТЬ
	|				Контакты.Контакт
	|			ИЗ
	|				Контакты КАК Контакты)
	|	И ПартнерыКонтактнаяИнформация.Представление <> """"
	|	И ПартнерыКонтактнаяИнформация.Тип = &ТипКИ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КонтактныеЛицаПартнеровКонтактнаяИнформация.Представление,
	|	КонтактныеЛицаПартнеровКонтактнаяИнформация.Вид,
	|	КонтактныеЛицаПартнеровКонтактнаяИнформация.Ссылка
	|ИЗ
	|	Справочник.КонтактныеЛицаПартнеров.КонтактнаяИнформация КАК КонтактныеЛицаПартнеровКонтактнаяИнформация
	|ГДЕ
	|	КонтактныеЛицаПартнеровКонтактнаяИнформация.Ссылка В
	|			(ВЫБРАТЬ
	|				Контакты.Контакт
	|			ИЗ
	|				Контакты КАК Контакты)
	|	И КонтактныеЛицаПартнеровКонтактнаяИнформация.Представление <> """"
	|	И КонтактныеЛицаПартнеровКонтактнаяИнформация.Тип = &ТипКИ
	|ИТОГИ ПО
	|	Контакт";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Контакты",Объект.ДополнительныеПолучатели.Выгрузить());
	Запрос.УстановитьПараметр("ТипКи", ТребуемыйТипКонтактнойИнформации());
	
	ВыборкаКонтакт = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаКонтакт.Следующий() Цикл
		
		ТаблицаАдресов.Очистить();
		
		ВыборкаДетали = ВыборкаКонтакт.Выбрать();
		Пока ВыборкаДетали.Следующий() Цикл
			
			НоваяСтрока = ТаблицаАдресов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетали);
			
		КонецЦикла;
		
		Если ТаблицаАдресов.Количество() > 0 Тогда
			
			НайденныеСтроки = Объект.ДополнительныеПолучатели.НайтиСтроки(Новый Структура("Контакт", ВыборкаКонтакт.Контакт));
			Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			
				НайденнаяСтрока.ТаблицаАдресов.Загрузить(ТаблицаАдресов);
			
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ТребуемыйТипКонтактнойИнформации()

	Возврат ?(Объект.ПредназначенаДляЭлектронныхПисем,
	          Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
	          Перечисления.ТипыКонтактнойИнформации.Телефон);

КонецФункции

&НаКлиенте
Процедура ДобавитьПараметр(ИмяПараметра)

	ВставляемыйТекст = "[" + ИмяПараметра + "]";
	
	Если Объект.ПредназначенаДляSMS Тогда
		
		ВставитьВРедактируемыйТекст(Элементы.ТекстSMS, ВставляемыйТекст);
		
	Иначе
		
		Если Объект.ТипТекстаПисьма = ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст") Тогда
			
			ВставитьВРедактируемыйТекст( Элементы.ТекстПисьма, ВставляемыйТекст);
			
		Иначе
			
			НачалоВыделения = Неопределено;
			КонецВыделения  = Неопределено;
			Элементы.ТекстПисьмаФорматированныйДокумент.ПолучитьГраницыВыделения(НачалоВыделения, КонецВыделения);
			ТекстПисьмаФорматированныйДокумент.Вставить(НачалоВыделения, ВставляемыйТекст, ТипЭлементаФорматированногоДокумента.Текст);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВставитьВРедактируемыйТекст( Элемент, ТекстВставки)

	НачалоСтроки = 0;
	НачалоКолонки = 0;
	КонецСтроки = 0;
	КонецКолонки = 0;
	
 	Элемент.ПолучитьГраницыВыделения(НачалоСтроки, НачалоКолонки, КонецСтроки, КонецКолонки);
	
	Если (КонецКолонки = НачалоКолонки) И (КонецКолонки + СтрДлина(ТекстВставки)) > Элемент.Ширина / 8 Тогда
		Элемент.ВыделенныйТекст = "";
	КонецЕсли;
	
	Элемент.ВыделенныйТекст = ТекстВставки;
	
	ТекущийЭлемент = Элемент;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ТекстЗаголовкаФильтрАдресатов(Форма)

	Если ПустаяСтрока(Строка(Форма.КомпоновщикНастроек.Настройки.Отбор)) Тогда
		Форма.ЗаголовокФильтрАдресатов = НСтр("ru = 'не установлен'");
	Иначе
		Форма.ЗаголовокФильтрАдресатов = НСтр("ru = 'установлен'");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
