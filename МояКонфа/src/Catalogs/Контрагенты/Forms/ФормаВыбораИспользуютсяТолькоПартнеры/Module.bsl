
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ПартнерыИКонтрагенты.ПартнерыФормаВыбораСпискаПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если Параметры.Свойство("Отбор")
		И Параметры.Отбор.Свойство("Партнер")
		И ЗначениеЗаполнено(Параметры.Отбор.Партнер) Тогда
		
		Партнер = Параметры.Отбор.Партнер;
		ПоПартнеру = Истина;
		Параметры.Отбор.Удалить("Партнер");
		
		ПартнерыИКонтрагенты.ЗаполнитьСписокПартнераСоВсехИерархией(Партнер, СписокПартнеров);
		
		НайденныйПартнер = СписокПартнеров.НайтиПоЗначению(Партнер);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПараметризацияПоПартнеру", СписокПартнеров, ВидСравненияКомпоновкиДанных.ВСписке);
		
	Иначе
		
		Партнер = Справочники.Партнеры.ПустаяСсылка();
		
	КонецЕсли;
	
	Если Параметры.Свойство("Основание") Тогда
		Основание = Параметры.Основание;
	КонецЕсли;
	
	ИспользоватьПроверкуКонтрагентов                  = ПроверкаКонтрагентов.ПроверкаКонтрагентовВключена();
	Элементы.ЕстьОшибкиПроверкаКонтрагентов.Видимость = ИспользоватьПроверкуКонтрагентов;
	Элементы.ГруппаЛегенда.Видимость                  = ИспользоватьПроверкуКонтрагентов;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ПартнерыИКонтрагенты.ПередЗагрузкойДанныхИзНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПартнерыИКонтрагентыКлиент.ПанельНавигацииУправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ТребуетсяОбновлениеПанелиИнформации = Ложь;
	
	ПартнерыИКонтрагентыКлиент.ПартнерыФормаСпискаВыбораОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник, ТребуетсяОбновлениеПанелиИнформации);
	
	Если ТребуетсяОбновлениеПанелиИнформации Тогда
		ИгнорироватьСохранениеТекущейПозиции = Истина;
		ОбработатьАктивизациюСтрокиСписка();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТолькоМоиПриИзменении(Элемент)
	
	ИзменитьОтборСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	ВыполнитьПоиск(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеВыбораНажатие(Элемент, СтандартнаяОбработка)
	
	ПартнерыИКонтрагентыКлиент.ПартнерыФормаСпискаВыбораОснованиеВыбораНажатие(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СегментПриИзменении(Элемент)
	
	ПартнерыИКонтрагентыКлиент.ПартнерыФормаСпискаВыбораСегментПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	СпискиВыбораКлиентСервер.АвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипФильтраОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьФильтрПриИзменении(Элемент)
	
	ПартнерыИКонтрагентыКлиент.ПанельНавигацииУправлениеДоступностью(ЭтаФорма);
	ОбработатьАктивизациюСтрокиДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ДинамическийСписокФильтрыПриАктивизацииСтроки(Элемент)
	
	Если Элемент.Имя = "БизнесРегионы" И Элементы.СтраницыТипФильтра.ТекущаяСтраница <> Элементы.СтраницаБизнесРегионы Тогда
		Возврат;
	ИначеЕсли Элемент.Имя = "ГруппыДоступаПартнеров" И Элементы.СтраницыТипФильтра.ТекущаяСтраница <> Элементы.СтраницаГруппыДоступа Тогда
		Возврат;
	ИначеЕсли Элемент.Имя = "Менеджеры" И Элементы.СтраницыТипФильтра.ТекущаяСтраница <> Элементы.СтраницаМенеджеры Тогда
		Возврат;
	ИначеЕсли Элемент.Имя = "Свойства" И Элементы.СтраницыТипФильтра.ТекущаяСтраница <> Элементы.СтраницаСвойства Тогда
		Возврат;
	ИначеЕсли Элемент.Имя = "Категории" И Элементы.СтраницыТипФильтра.ТекущаяСтраница <> Элементы.СтраницаКатегории Тогда
		Возврат;
	КонецЕсли;
	
	Если НеОтрабатыватьАктивизациюПанелиНавигации Тогда
		НеОтрабатыватьАктивизациюПанелиНавигации = Ложь;
	Иначе
		Если Элемент.Имя = "БизнесРегионы" И ТекущееЗначениеФильтра = Элементы.БизнесРегионы.ТекущаяСтрока Тогда
			Возврат;
		ИначеЕсли Элемент.Имя = "ГруппыДоступаПартнеров" И ТекущееЗначениеФильтра = Элементы.ГруппыДоступаПартнеров.ТекущаяСтрока Тогда
			Возврат;
		ИначеЕсли Элемент.Имя = "Менеджеры" И ТекущееЗначениеФильтра = Элементы.Менеджеры.ТекущаяСтрока Тогда
			Возврат;
		ИначеЕсли Элемент.Имя = "Свойства" И ТекущееЗначениеФильтра = Свойства.НайтиПоИдентификатору(Элементы.Свойства.ТекущаяСтрока) Тогда
			Возврат;
		ИначеЕсли Элемент.Имя = "Категории" И ТекущееЗначениеФильтра = Категории.НайтиПоИдентификатору(Элементы.Категории.ТекущаяСтрока) Тогда
			Возврат;
		КонецЕсли;
		
		ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиДинамическогоСписка",0.2,Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактныеЛицаПартнераНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПартнерыИКонтрагентыКлиент.КонтактныеЛицаПартнераНажатие(ЭтаФорма);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПоВсемПриИзменении(Элемент)
	
	ИзменитьОтборСписок(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ГоловнойКонтрагент Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные.ОбособленноеПодразделение И Не ЗначениеЗаполнено(ТекущиеДанные.ГоловнойКонтрагент) Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ПараметрыЗаполнения = Новый Структура;
			ПараметрыЗаполнения.Вставить("Контрагент", ТекущиеДанные.Ссылка);
			ПараметрыЗаполнения.Вставить("ИНН",        ТекущиеДанные.ИНН);
			ПараметрыЗаполнения.Вставить("Партнер",    ТекущиеДанные.Партнер);
			ПараметрыЗаполнения.Вставить("ИспользоватьПартнеровКакКонтрагентов", Истина);
			
			Оповещение = Новый ОписаниеОповещения("ЗаполнитьГоловногоКонтрагентаЗавершение", ЭтотОбъект);
			ПартнерыИКонтрагентыКлиент.ЗаполнитьГоловногоКонтрагента(ЭтотОбъект, ПараметрыЗаполнения, Истина, Оповещение);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиСписка",0.2,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ПартнерыИКонтрагентыКлиент.ПартнерыФормаСпискаВыбораСписокПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа, Основание);
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиПП(Команда)
	
	ВыполнитьПоиск(Неопределено);
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПолнотекстовыйПоиск

&НаКлиенте
Процедура ПроверитьИндексПолнотекстовогоПоиска(Знач Оповещение)
	
	Если Не ИндексПолнотекстовогоПоискаАктуален И ИнформационнаяБазаФайловая Тогда
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ПроверитьИндексПолнотекстовогоПоискаЗавершение", ЭтотОбъект, 
			Новый Структура("Оповещение", Оповещение)), НСтр("ru='Индекс полнотекстового поиска неактуален. Обновить индекс?'"), 
			РежимДиалогаВопрос.ДаНет);
		
        Возврат;
		
	КонецЕсли;
	
	ПроверитьИндексПолнотекстовогоПоискаФрагмент(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИндексПолнотекстовогоПоискаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Оповещение = ДополнительныеПараметры.Оповещение;
    
    
    Результат = РезультатВопроса; 
    
    Если Результат = КодВозвратаДиалога.Да Тогда
        ПодключитьОбработчикОжидания("ОбновитьИндексПолнотекстовогоПоиска",0.2,Истина);
        ВыполнитьОбработкуОповещения(Оповещение);
        Возврат;
    КонецЕсли;
    
    
    ПроверитьИндексПолнотекстовогоПоискаФрагмент(Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИндексПолнотекстовогоПоискаФрагмент(Знач Оповещение)
    
    ВыполнитьПолнотекстовыйПоиск();
    
    
    ВыполнитьОбработкуОповещения(Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИндексПолнотекстовогоПоиска()
	
	Состояние(НСтр("ru = 'Идет обновление индекса полнотекстового поиска ...'"));
	ОбновитьИндексПолнотекстовогоПоискаСервер();
	ИндексПолнотекстовогоПоискаАктуален = Истина;
	Состояние(НСтр("ru = 'Обновление индекса полнотекстового поиска завершено...'"));
	
	ВыполнитьПолнотекстовыйПоиск();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИндексПолнотекстовогоПоискаСервер()
	
	ПартнерыИКонтрагенты.ОбновитьИндексПолнотекстовогоПоиска();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПолнотекстовыйПоиск()
	
	ТекстОшибки = НайтиПартнеровПолнотекстовыйПоиск();
	Если ТекстОшибки = Неопределено Тогда
		РасширенныйПоиск = Истина;
		ПартнерыИКонтрагентыКлиент.ЗаполнитьСтрокуОснования(ЭтаФорма);
	Иначе
		Если НЕ ТекстОшибки = НСтр("ru = 'Ничего не найдено'") Тогда
			ПоказатьОповещениеПользователя(ТекстОшибки);
		Иначе
			ПартнерыИКонтрагентыКлиент.ВостановитьОтображениеСпискаПослеПолнотекстовогоПоиска(ЭтаФорма);
			РасширенныйПоиск = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Функция НайтиПартнеровПолнотекстовыйПоиск()
	
	Возврат ПартнерыИКонтрагенты.НайтиПартнеровПолнотекстовыйПоиск(ЭтаФорма)
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПоиск(Знач Оповещение)
	
	Если СтрокаПоиска <> "" Тогда
		
		ПроверитьИндексПолнотекстовогоПоиска(Новый ОписаниеОповещения("ВыполнитьПоискЗавершение", ЭтотОбъект, Новый Структура("Оповещение", Оповещение)));
        Возврат;
		
	Иначе
		
		ПартнерыИКонтрагентыКлиент.ВостановитьОтображениеСпискаПослеПолнотекстовогоПоиска(ЭтаФорма);
		РасширенныйПоиск = Ложь;
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		                                                                   "ОтборПоПолнотекстовомуПоискуУстановлен",
		                                                                   Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
		                                                                   "ОтборПоПолнотекстовомуПоиску",
		                                                                   Неопределено);
		ОснованиеВыбора = "";
		
	КонецЕсли;
	
	ВыполнитьПоискФрагмент(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоискЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Оповещение = ДополнительныеПараметры.Оповещение;
    
    
    ЭтаФорма.ТекущийЭлемент = ?(НЕ РасширенныйПоиск, Элементы.СтрокаПоиска, Элементы.Список);
    
    
    ВыполнитьПоискФрагмент(Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоискФрагмент(Знач Оповещение)
    
    ВыполнитьОбработкуОповещения(Оповещение);

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	ПартнерыИКонтрагенты.ПартнерыФормаВыбораСпискаУсловноеОформление(ЭтаФорма);
	ПартнерыИКонтрагенты.УстановитьОформлениеГоловногоКонтрагентаВСписке(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиСписка()
	
	Если Не ПартнерыИКонтрагентыКлиент.ПозиционированиеКорректно("Список" ,ЭтаФорма) Тогда
		
		Если ТекущийАктивныйПартнер <> ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка") Тогда
			ЗаполнитьПанельИнформацииПоДаннымПартнера(Неопределено);
		КонецЕсли;
		ОснованиеВыбора = "";
		
	Иначе
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			ЗаполнитьПанельИнформацииПоДаннымПартнера(Неопределено);
			Возврат;
		КонецЕсли;
		
		Если ТекущийАктивныйПартнер <> ТекущиеДанные.Партнер ИЛИ ИгнорироватьСохранениеТекущейПозиции Тогда
			ЗаполнитьПанельИнформацииПоДаннымПартнера(ТекущиеДанные.Партнер);
		КонецЕсли;
		
		Если РасширенныйПоиск Тогда
			ПартнерыИКонтрагентыКлиент.ЗаполнитьСтрокуОснования(ЭтаФорма);
		Иначе
			ОснованиеВыбора = "";
		КонецЕсли;
		
	КонецЕсли;
	
	ИгнорироватьСохранениеТекущейПозиции = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПанельИнформацииПоДаннымПартнера(Партнер)

	ПартнерыИКонтрагенты.ЗаполнитьПанельИнформацииПоДаннымПартнера(ЭтаФорма, Партнер);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиДинамическогоСписка()

	ИзменитьОтборСписок();

КонецПроцедуры

&НаСервере
Процедура ИзменитьОтборСписок(ПереформированиеПанелиНавигации = Ложь, ТребуетсяЗаполнениеСтраницыСвойств = Ложь)

	ПартнерыИКонтрагенты.ИзменитьОтборСписок(ЭтаФорма, ПереформированиеПанелиНавигации, ТребуетсяЗаполнениеСтраницыСвойств);

КонецПроцедуры

&НаКлиенте
Процедура ТипФильтраПриИзменении(Элемент)
	
	ТребуетсяЗаполнениеСтраницыСвойств = ЛОЖЬ;
	ПартнерыИКонтрагентыКлиент.ФильтрыПанельНавигацииТипФильтраПриИзменении(ЭтаФорма, Элемент, ТребуетсяЗаполнениеСтраницыСвойств);
	ИзменитьОтборСписок(Истина, ТребуетсяЗаполнениеСтраницыСвойств);
	Если ТребуетсяЗаполнениеСтраницыСвойств Тогда
		Для каждого СтрокаДерева Из Свойства.ПолучитьЭлементы() Цикл
			Элементы.Свойства.Развернуть(СтрокаДерева.ПолучитьИдентификатор());
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ПартнерыИКонтрагентыКлиент.ФильтрыПанельНавигацииПроверкаПеретаскивания(ЭтаФорма, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле) 
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	КоличествоЗаписанных = 0;
	ПартнерыИКонтрагентыКлиент.ФильтрыПанельНавигацииПеретаскивание(КоличествоЗаписанных, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле);
	
	Если КоличествоЗаписанных > 0 Тогда
		ИзменитьОтборСписок();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьГоловногоКонтрагентаЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
