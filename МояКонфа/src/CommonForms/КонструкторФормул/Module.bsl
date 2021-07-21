
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Формула         = Параметры.Формула;
	ИсходнаяФормула = Параметры.Формула;
	
	Параметры.Свойство("СтроковаяФормула", СтроковаяФормула);
	Параметры.Свойство("ИспользуетсяДеревоОперандов", ИспользуетсяДеревоОперандов);
	Параметры.Свойство("ТипРезультата", ТипРезультата);
	Параметры.Свойство("ФункцииИзОбщегоМодуля", ФункцииИзОбщегоМодуля);
	Параметры.Свойство("ФормулаДляВычисленияВЗапросе", ФормулаДляВычисленияВЗапросе);

	Если СтроковаяФормула Тогда
		Параметры.Свойство("НаборСвойств", НаборСвойств);
		Элементы.ГруппаОперандыСтраницы.ТекущаяСтраница = Элементы.СтраницаСтроковыхОперандов;
		ЗагрузитьНастройкиОтбораПоУмолчанию();
	ИначеЕсли ИспользуетсяДеревоОперандов Тогда
		Элементы.ГруппаОперандыСтраницы.ТекущаяСтраница = Элементы.СтраницаДеревоОперандов;
		ЗагрузитьДеревоОперандов(Параметры);
	Иначе
		Элементы.ГруппаОперандыСтраницы.ТекущаяСтраница = Элементы.СтраницаЧисловыхОперандов;
		Операнды.Загрузить(ПолучитьИзВременногоХранилища(Параметры.Операнды));
		Для Каждого ТекСтрока Из Операнды Цикл
			Если ТекСтрока.ПометкаУдаления Тогда
				ТекСтрока.ИндексКартинки = 3;
			Иначе
				ТекСтрока.ИндексКартинки = 2;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	АдресХранилищаДереваОператоров = Неопределено;
	Если Параметры.Свойство("Операторы", АдресХранилищаДереваОператоров) и ЭтоАдресВременногоХранилища(АдресХранилищаДереваОператоров) Тогда
		ДеревоОператоров = ПолучитьИзВременногоХранилища(АдресХранилищаДереваОператоров);
	Иначе
		ДеревоОператоров = РаботаСФормулами.ПолучитьСтандартноеДеревоОператоров();
	КонецЕсли;
	ЗначениеВРеквизитФормы(ДеревоОператоров, "Операторы");
	
	Если Параметры.Свойство("ОперандыЗаголовок") Тогда
		Элементы.ГруппаОперанды.Заголовок = Параметры.ОперандыЗаголовок;
		Элементы.ГруппаОперанды.Подсказка = Параметры.ОперандыЗаголовок;
	КонецЕсли;
	
	Если Параметры.Свойство("НеИспользоватьПредставление") Тогда
		Элементы.Представление.Видимость = Ложь;
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Операнды",
			"ИзменятьСоставСтрок",
			Ложь);
	
	Если Параметры.Свойство("Расширенный") и Параметры.Расширенный Тогда
		
		Расширенный           = Параметры.Расширенный;
		ВключитьЗначение      = Параметры.ВключитьЗначение;
		ТипПлана              = Параметры.ТипПлана;
		
		ФункцииИзОбщегоМодуля = Планирование.ФункцииИзОбщегоМодуля();
		
		Представление = ?(Найти(Параметры.Представление, "["),"", Параметры.Представление);
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ОК",
			"Заголовок",
			НСтр("ru = 'Задать произвольную формулу'"));
			
		УстановитьПояснениеКОперандам(ЭтотОбъект, Параметры.Отбор);
		
		Если ВключитьЗначение Тогда
			
			ПараметрыРасшифровки = Параметры.ПараметрыРасшифровки;
			
			УстановитьЗаголовокФормы(ЭтотОбъект, Параметры);
			
			УстановитьЗаголовокЗначенияОперандов();
			
			УстановитьПредставлениеВычисленияПоФормуле(Формула, Операнды, Вычисление);
			
		КонецЕсли;
		
		ВосстановитьНастройки();
		
	КонецЕсли;
	
	УстановитьВидимость();

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ПринудительноЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность
		И ЗначениеЗаполнено(ИсходнаяФормула) И ИсходнаяФормула <> Формула Тогда
		
		Отказ = Истина;
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект),
			НСтр("ru='Данные были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Если РаботаСФормуламиКлиентСервер.ПроверитьФормулу(
				Формула,
				ПолучитьМассивОперандов(),
				"Формула",,
				СтроковаяФормула,,
				ПараметрыПроверкиФормулы(ЭтаФорма)) Тогда
			
			ПринудительноЗакрытьФорму = Истина;
			Если Расширенный Тогда
				СохранитьНастройки();
				Закрыть(Новый Структура("Формула, Представление, Вычисление",Формула, Представление, Вычисление));
			Иначе
				Закрыть(Формула);
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		ПринудительноЗакрытьФорму = Истина;
		Закрыть(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиВыборДоступныеПоляВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекстСтроки = Строка(КомпоновщикНастроек.Настройки.ДоступныеПоляПорядка.ПолучитьОбъектПоИдентификатору(ВыбраннаяСтрока).Поле);
	Операнд = ОбработатьТекстОперанда(ТекстСтроки);
	Если Не ЗначениеЗаполнено(Операнд) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Имя реквизита не должно содержать ""."". Переименуйте реквизит.'"));
		Возврат;
	КонецЕсли;
	ВставитьТекстВФормулу(Операнд);
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ТекстЭлемента = Строка(КомпоновщикНастроек.Настройки.ДоступныеПоляПорядка.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроек.ТекущаяСтрока).Поле);
	Операнд = ОбработатьТекстОперанда(ТекстЭлемента);
	Если Не ЗначениеЗаполнено(Операнд) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Имя реквизита не должно содержать ""."". Переименуйте реквизит.'"));
		Выполнение = Ложь;
		Возврат;
	КонецЕсли;
	ПараметрыПеретаскивания.Значение = Операнд;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОперанды

&НаКлиенте
Процедура ОперандыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ОперандыЗначение" Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.ПометкаУдаления Тогда
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ОперандыВыборЗавершение", ЭтотОбъект), 
			НСтр("ru = 'Выбранный элемент помечен на удаление. 
				|Продолжить?'"), 
			РежимДиалогаВопрос.ДаНет);
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ВставитьОперандВФормулу();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперандыВыборЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ВставитьОперандВФормулу();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОперандыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	ПараметрыПеретаскивания.Значение = РаботаСФормуламиКлиентСервер.ПолучитьТекстОперандаДляВставки(Элемент.ТекущиеДанные.Идентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОперандыОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные.ПометкаУдаления Тогда
		
		Ответ = Неопределено;

		
		ПоказатьВопрос(Новый ОписаниеОповещения("ОперандыОкончаниеПеретаскиванияЗавершение", ЭтотОбъект), НСтр("ru = 'Выбранный элемент помечен на удаление'") + Символы.ПС + НСтр("ru = 'Продолжить?'"), РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОперандыОкончаниеПеретаскиванияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        
        НачалоСтроки  = 0;
        НачалоКолонки = 0;
        КонецСтроки   = 0;
        КонецКолонки  = 0;
        
        Элементы.Формула.ПолучитьГраницыВыделения(НачалоСтроки, НачалоКолонки, КонецСтроки, КонецКолонки);
        Элементы.Формула.ВыделенныйТекст = "";
        Элементы.Формула.УстановитьГраницыВыделения(НачалоСтроки, НачалоКолонки, НачалоСтроки, НачалоКолонки);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОперандыЗначениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Операнд = Элементы.Операнды.ТекущиеДанные.Идентификатор;
	
	ВыполнитьРасшифровку(Операнд, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОперандовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоОперандов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаРодитель = ТекущиеДанные.ПолучитьРодителя();
	Если СтрокаРодитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаРодитель.Идентификатор) Тогда
		
		ВставитьТекстВФормулу(РаботаСФормуламиКлиентСервер.ПолучитьТекстОперандаДляВставки(
		                                                   СтрокаРодитель.Идентификатор + "." + ТекущиеДанные.Идентификатор));
	Иначе
		
		ВставитьТекстВФормулу(РаботаСФормуламиКлиентСервер.ПолучитьТекстОперандаДляВставки(ТекущиеДанные.Идентификатор));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОперандов

&НаКлиенте
Процедура ДеревоОперандовНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Если ПараметрыПеретаскивания.Значение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаДерева = ДеревоОперандов.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение);
	СтрокаРодитель = СтрокаДерева.ПолучитьРодителя();
	Если СтрокаРодитель = Неопределено Тогда
		Выполнение = Ложь;
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаРодитель.Идентификатор) Тогда
		
		ПараметрыПеретаскивания.Значение = 
		   РаботаСФормуламиКлиентСервер.ПолучитьТекстОперандаДляВставки(СтрокаРодитель.Идентификатор +"." + СтрокаДерева.Идентификатор);
		
	Иначе
		
		ПараметрыПеретаскивания.Значение = 
		   РаботаСФормуламиКлиентСервер.ПолучитьТекстОперандаДляВставки(СтрокаДерева.Идентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОператоры

&НаКлиенте
Процедура ОператорыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВставитьОператорВФормулу();
	
КонецПроцедуры

&НаКлиенте
Процедура ОператорыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Оператор) Тогда
		ПараметрыПеретаскивания.Значение = Элемент.ТекущиеДанные.Оператор;
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОператорыОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные.Оператор = "Формат(,)" Тогда
		ФорматСтроки = Новый КонструкторФорматнойСтроки;
		ФорматСтроки.Показать(Новый ОписаниеОповещения("ОператорыОкончаниеПеретаскиванияЗавершение", ЭтотОбъект, Новый Структура("ФорматСтроки", ФорматСтроки)));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОператорыОкончаниеПеретаскиванияЗавершение(Текст, ДополнительныеПараметры) Экспорт
    
    ФорматСтроки = ДополнительныеПараметры.ФорматСтроки;
    
    
    Если ЗначениеЗаполнено(ФорматСтроки.Текст) Тогда
        ТекстДляВставки = "Формат( , """ + ФорматСтроки.Текст + """)";
        Элементы.Формула.ВыделенныйТекст = ТекстДляВставки;
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	
	Если РаботаСФормуламиКлиентСервер.ПроверитьФормулу(Формула, ПолучитьМассивОперандов(),
		                                               "Формула", , СтроковаяФормула,,ПараметрыПроверкиФормулы(ЭтаФорма)) Тогда
		
		ПринудительноЗакрытьФорму = Истина;
		Если Расширенный Тогда
			СохранитьНастройки();
			Закрыть(Новый Структура("Формула, Представление, Вычисление",Формула, Представление, Вычисление));
		Иначе
			Закрыть(Формула);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	
	ОчиститьСообщения();
	РаботаСФормуламиКлиент.ПроверитьФормулуИнтерактивно(Формула, ПолучитьМассивОперандов(), "Формула", СтроковаяФормула, ПараметрыПроверкиФормулы(ЭтаФорма));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура ВставитьТекстВФормулу(ТекстДляВставки, Сдвиг = 0)
	
	СтрокаНач = 0;
	СтрокаКон = 0;
	КолонкаНач = 0;
	КолонкаКон = 0;
	
	Элементы.Формула.ПолучитьГраницыВыделения(СтрокаНач, КолонкаНач, СтрокаКон, КолонкаКон);
	
	Если (КолонкаКон = КолонкаНач) И (КолонкаКон + СтрДлина(ТекстДляВставки)) > Элементы.Формула.Ширина / 8 Тогда
		Элементы.Формула.ВыделенныйТекст = "";
	КонецЕсли;
		
	Элементы.Формула.ВыделенныйТекст = ТекстДляВставки;
	
	Если Не Сдвиг = 0 Тогда
		Элементы.Формула.ПолучитьГраницыВыделения(СтрокаНач, КолонкаНач, СтрокаКон, КолонкаКон);
		Элементы.Формула.УстановитьГраницыВыделения(СтрокаНач, КолонкаНач - Сдвиг, СтрокаКон, КолонкаКон - Сдвиг);
	КонецЕсли;
		
	ТекущийЭлемент = Элементы.Формула;
	
	Если Расширенный Тогда
		Представление = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОперандВФормулу()
	
	ВставитьТекстВФормулу(РаботаСФормуламиКлиентСервер.ПолучитьТекстОперандаДляВставки(Элементы.Операнды.ТекущиеДанные.Идентификатор));
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьМассивОперандов()
	
	МассивОперандов = Новый Массив();
	
	Если СтроковаяФормула Тогда
		
		МассивОперандов = РаботаСФормуламиКлиентСервер.ПолучитьМассивОперандовТекстовойФормулы(Формула);
		
	ИначеЕсли ИспользуетсяДеревоОперандов Тогда
		
		МассивОперандов = РаботаСФормуламиКлиентСервер.МассивОперандовДляДерева(ДеревоОперандов);
		
	Иначе
		
		Для Каждого ТекСтрока Из Операнды Цикл
			
			МассивОперандов.Добавить(ТекСтрока.Идентификатор);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат МассивОперандов;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьНастройкиОтбораПоУмолчанию()
	
	Если НаборСвойств.НаборСвойствНоменклатуры Тогда
		СхемаКомпоновкиДанных = Справочники.ВидыНоменклатуры.ПолучитьМакет("ШаблонНоменклатуры");
	Иначе
		Если НЕ НаборСвойств.Свойство("НаборСвойствХарактеристик") ИЛИ НаборСвойств.НаборСвойствХарактеристик Тогда
			СхемаКомпоновкиДанных = Справочники.ВидыНоменклатуры.ПолучитьМакет("ШаблонХарактеристики");
		Иначе
			СхемаКомпоновкиДанных = Справочники.ВидыНоменклатуры.ПолучитьМакет("ШаблонСерии");
		КонецЕсли;
	КонецЕсли;
	
	СхемаКомпоновкиДанных.Параметры.НаборСвойств.Значение = НаборСвойств.Набор;
	КомпоновщикНастроек.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, ЭтаФорма.УникальныйИдентификатор)));
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОператорВФормулу()
	
	Если Элементы.Операторы.ТекущиеДанные.Наименование = "Формат" Тогда
		ФорматСтроки = Новый КонструкторФорматнойСтроки;
		ФорматСтроки.Показать(Новый ОписаниеОповещения("ВставитьОператорВФормулуЗавершение", ЭтотОбъект, Новый Структура("ФорматСтроки", ФорматСтроки)));
        Возврат;
	Иначе	
		ВставитьТекстВФормулу(Элементы.Операторы.ТекущиеДанные.Оператор, Элементы.Операторы.ТекущиеДанные.Сдвиг);
	КонецЕсли;
	
	ВставитьОператорВФормулуФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОператорВФормулуЗавершение(Текст, ДополнительныеПараметры) Экспорт
    
    ФорматСтроки = ДополнительныеПараметры.ФорматСтроки;
    
    
    Если ЗначениеЗаполнено(ФорматСтроки.Текст) Тогда
        ТекстДляВставики = "Формат( , """ + ФорматСтроки.Текст + """)";
        ВставитьТекстВФормулу(ТекстДляВставики, Элементы.Операторы.ТекущиеДанные.Сдвиг);
    Иначе	
        ВставитьТекстВФормулу(Элементы.Операторы.ТекущиеДанные.Оператор, Элементы.Операторы.ТекущиеДанные.Сдвиг);
    КонецЕсли;
    
    ВставитьОператорВФормулуФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ВставитьОператорВФормулуФрагмент()
    
    Перем ТекущиеДанные, Функции;
    
    Если Расширенный Тогда
        Функции = "+,-,*,/,<,>,<=,>=,=,<>,И,ИЛИ,НЕ,ИСТИНА,ЛОЖЬ,Максимум,Минимум,Округление,Целая часть,Условие";
        ТекущиеДанные = Элементы.Операторы.ТекущиеДанные;
        Если ЗначениеЗаполнено(ТекущиеДанные.Оператор) и Не СтрНайти(Функции, ТекущиеДанные.Наименование) и Не СтрНайти(ТекущиеДанные.Наименование, "[") Тогда
            Представление = ТекущиеДанные.Наименование;
        Иначе
            Представление = "";
        КонецЕсли;
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция  ОбработатьТекстОперанда(ТекстОперанда)
	
	ТекстСтроки = ТекстОперанда;
	
	// Проверка на наличии "." в имене операнда дополнительного реквизита
	// Имя операнда доп реквизита заключено в []
	НачалоОперанда = Найти(ТекстСтроки, "[");
	КонецОперанда = Найти(ТекстСтроки, "]");
	Если НачалоОперанда <> 0
		И КонецОперанда <> 0
		И НачалоОперанда < КонецОперанда Тогда
		
		ИмяОперанда = Сред(ТекстСтроки, НачалоОперанда + 1, КонецОперанда - НачалоОперанда - 1);
		Если Найти(ИмяОперанда, ".") <> 0 Тогда
			Возврат Неопределено
		КонецЕсли;
	КонецЕсли;
		
	ТекстСтроки = СтрЗаменить(ТекстСтроки, "[", "");
	ТекстСтроки = СтрЗаменить(ТекстСтроки, "]", "");
	Операнд = "[" + СтрЗаменить(ТекстСтроки, 
		?(НаборСвойств.НаборСвойствНоменклатуры, "Номенклатура.", 
			?(НЕ НаборСвойств.Свойство("НаборСвойствХарактеристик") ИЛИ НаборСвойств.НаборСвойствХарактеристик, "ХарактеристикаНоменклатуры.", "СерияНоменклатуры.")), "") + "]";
	
	Возврат Операнд
	
КонецФункции

&НаКлиенте
Процедура ФормулаПриИзменении(Элемент)
	
	Если Расширенный Тогда
		Представление = "";
	КонецЕсли;
	
	Если ВключитьЗначение Тогда
		УстановитьПредставлениеВычисленияПоФормуле(Формула, Операнды, Вычисление);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()

	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОперандыИдентификатор",
		"Видимость",
		Не Расширенный);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОперандыПредставление",
		"Видимость",
		Расширенный);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОперандыЗначение",
		"Видимость",
		ВключитьЗначение);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Вычисление",
		"Видимость",
		ВключитьЗначение);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДекорацияАвтоСумма",
		"Видимость",
		ВключитьЗначение);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Операнды",
		"Шапка",
		ВключитьЗначение);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Операторы",
		"Шапка",
		ВключитьЗначение);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеВычисленияПоФормуле(Знач РасчетнаяФормула, Операнды, Представление)
	
	Если Не ЗначениеЗаполнено(РасчетнаяФормула) Тогда
		Представление = "";
		Возврат;
	КонецЕсли;
	
	РасчетнаяФормула = УдалениеНезначимыхСимволов(РасчетнаяФормула);
	ВыводитьПромежуточныеВычисления = Ложь;
	
	МассивОперандов = РаботаСФормуламиКлиентСервер.ПолучитьМассивОперандовТекстовойФормулы(РасчетнаяФормула);
	
	Для каждого Операнд Из МассивОперандов Цикл
		НайденныйСтроки = Операнды.НайтиСтроки(Новый Структура("Идентификатор", Операнд));
		Если НайденныйСтроки.Количество() = 1 Тогда
			Если НЕ ВыводитьПромежуточныеВычисления Тогда
				ВыводитьПромежуточныеВычисления = НЕ ПустаяСтрока(УдалениеНезначимыхСимволов(СтрЗаменить(РасчетнаяФормула, "["+Операнд+"]", "")));
			КонецЕсли;
			РасчетнаяФормула = СтрЗаменить(РасчетнаяФормула, "["+Операнд+"]", Формат(НайденныйСтроки[0].Значение, "ЧРД=.; ЧН=0; ЧГ=0"));
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		#Если Клиент Тогда
			РезультатВычисления = Формат(Вычислить(РасчетнаяФормула),"ЧЦ=15; ЧДЦ=3; ЧН=0");
		#Иначе
			РезультатВычисления = Формат(ОбщегоНазначения.ВычислитьВБезопасномРежиме(РасчетнаяФормула),"ЧЦ=15; ЧДЦ=3; ЧН=0");
		#КонецЕсли
	Исключение
		Возврат;
	КонецПопытки;
	
	Представление = ?(ВыводитьПромежуточныеВычисления, РасчетнаяФормула, "") + ?(ЗначениеЗаполнено(РасчетнаяФормула), " = ", "") + РезультатВычисления;
	
	Представление = УдалениеНезначимыхСимволов(Представление);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	МассивФормул = Неопределено;
	
	КоличествоСохраняемыхФормул = 10;
	
	УстановитьЗначениеНастройки("МассивФормул", МассивФормул);
	
	НовыйМассивФормул = Новый ТаблицаЗначений();
	НовыйМассивФормул.Колонки.Добавить("Представление");
	НовыйМассивФормул.Колонки.Добавить("Формула");
	
	Формула = УдалениеНезначимыхСимволов(Формула);
	Представление = УдалениеНезначимыхСимволов(Представление);
	
	Если Не ЗначениеЗаполнено(Формула) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(МассивФормул) = Тип("ТаблицаЗначений") и МассивФормул.Количество() > 0 Тогда
		
		НайденнаяСтрока = МассивФормул.Найти(Формула, "Формула");
		
		НовоеЗначение = НовыйМассивФормул.Добавить();
		НовоеЗначение.Представление = Представление;
		
		Если НайденнаяСтрока = Неопределено Тогда
			НовоеЗначение.Формула = Формула;
		Иначе
			НовоеЗначение.Формула = НайденнаяСтрока.Формула;
			МассивФормул.Удалить(НайденнаяСтрока);
		КонецЕсли;
		
		Для каждого Элемент Из МассивФормул Цикл
			НовоеЗначение = НовыйМассивФормул.Добавить();
			ЗаполнитьЗначенияСвойств(НовоеЗначение,Элемент);
			
			КоличествоСохраняемыхФормул = КоличествоСохраняемыхФормул - 1;
			
			Если КоличествоСохраняемыхФормул <=0 Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла; 
		
	Иначе
		
		НовоеЗначение = НовыйМассивФормул.Добавить();
		НовоеЗначение.Представление = Представление;
		НовоеЗначение.Формула		= Формула;
		
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиРаботыПользователя" + ТипПлана, "МассивФормул", НовыйМассивФормул);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки()
	
	МассивФормул = Неопределено;
	
	УстановитьЗначениеНастройки("МассивФормул", МассивФормул);
	
	ДеревоОператоров = РеквизитФормыВЗначение("Операторы");
	
	Если ТипЗнч(МассивФормул) = Тип("ТаблицаЗначений") и МассивФормул.Количество() > 0 Тогда
		ГруппаОператоров = РаботаСФормулами.ДобавитьГруппуОператоров(ДеревоОператоров, НСтр("ru='Последние используемые формулы'"));
	Иначе
		Возврат;
	КонецЕсли;
	
	Для каждого Элемент Из МассивФормул Цикл
		РаботаСФормулами.ДобавитьОператор(ДеревоОператоров, ГруппаОператоров,?(ЗначениеЗаполнено(Элемент.Представление),Элемент.Представление,Элемент.Формула),Элемент.Формула);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоОператоров, "Операторы");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеНастройки(ИмяНастройки, Настройка)
	
	ЗначениеНастройкиИзХранилища = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиРаботыПользователя" + ТипПлана, ИмяНастройки);
	Если ЗначениеНастройкиИзХранилища <> Неопределено Тогда
		Настройка = ЗначениеНастройкиИзХранилища;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция УдалениеНезначимыхСимволов(Знач ВходящаяСтрока)
	
	ВходящаяСтрока = СокрЛП(ВходящаяСтрока);
	ДлинаСтроки = СтрДлина(ВходящаяСтрока);
	КонечнаяСтрока = Строка("");
	
	Пока ДлинаСтроки > 0 Цикл 
		
		ПервыйСимвол = Лев(ВходящаяСтрока, 1);
		
		Если Не ПустаяСтрока(ПервыйСимвол) Тогда
			КонечнаяСтрока = КонечнаяСтрока + ПервыйСимвол;
			ДлинаСтроки = ДлинаСтроки - 1;
			Отступ = 2;
		Иначе
			КонечнаяСтрока = КонечнаяСтрока + " ";
			ВходящаяСтрока = СокрЛ(ВходящаяСтрока);
			ДлинаСтроки = СтрДлина(ВходящаяСтрока);
			Отступ = 1;
		КонецЕсли;
		
		Если ДлинаСтроки > 1 тогда
			ВходящаяСтрока = Сред(ВходящаяСтрока, Отступ, ДлинаСтроки);
		Иначе
			КонечнаяСтрока = КонечнаяСтрока + Сред(ВходящаяСтрока, Отступ, 1);
			ДлинаСтроки = 0; 
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КонечнаяСтрока;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокФормы(Форма, Параметры)

	Форма.АвтоЗаголовок= Ложь;
	Форма.Заголовок = НСтр("ru='Редактирование формулы для ""'") + Параметры.ЗаголовокЗначения + """";

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПояснениеКОперандам(Форма, Отбор)
	
	ЭлементПояснение = Форма.Элементы.ДекорацияПояснение;
	ТекстПояснения = "";
	Шрифт = Новый Шрифт(,,,Истина);
	
	ЕстьСклад			= Отбор.Свойство("ОтборСклад") и ЗначениеЗаполнено(Отбор.ОтборСклад);
	ЕстьПодразделение	= Отбор.Свойство("ОтборПодразделение") и ЗначениеЗаполнено(Отбор.ОтборПодразделение);
	ЕстьПартнер			= Отбор.Свойство("ОтборПартнер") и ЗначениеЗаполнено(Отбор.ОтборПартнер);
	ЕстьСоглашение 		= Отбор.Свойство("ОтборСоглашение") и ЗначениеЗаполнено(Отбор.ОтборСоглашение);
	ЕстьФорматМагазина	= Отбор.Свойство("ОтборФорматМагазина") и ЗначениеЗаполнено(Отбор.ОтборФорматМагазина);
	ЕстьНазначение		= Отбор.Свойство("ОтборНазначение") и ЗначениеЗаполнено(Отбор.ОтборНазначение);
	
	Если ЕстьСклад Тогда
		ТекстПояснения = Новый ФорматированнаяСтрока(ТекстПояснения,
														Новый ФорматированнаяСтрока(НСтр("ru='складу'") + " ",
														"""",
														Новый ФорматированнаяСтрока(Строка(Отбор.ОтборСклад), Шрифт),
														""""));
	КонецЕсли;
	
	Если ЕстьФорматМагазина Тогда
		ТекстПояснения = Новый ФорматированнаяСтрока(ТекстПояснения,
														Новый ФорматированнаяСтрока(НСтр("ru='формату магазина'") + " ",
														"""",
														Новый ФорматированнаяСтрока(Строка(Отбор.ОтборФорматМагазина), Шрифт),
														""""));
	КонецЕсли;
	
	Если ЕстьПодразделение Тогда
		ТекстПояснения = Новый ФорматированнаяСтрока(ТекстПояснения,
														?(ЕстьСклад ИЛИ ЕстьФорматМагазина,", ",""),
														Новый ФорматированнаяСтрока(НСтр("ru='подразделению'") + " ",
														"""",Новый ФорматированнаяСтрока(Строка(Отбор.ОтборПодразделение), Шрифт),""""));
	КонецЕсли;
	
	Если ЕстьПартнер Тогда
		ТекстПояснения = Новый ФорматированнаяСтрока(ТекстПояснения,
														?(ЕстьСклад ИЛИ ЕстьФорматМагазина или ЕстьПодразделение,", ",""),
														Новый ФорматированнаяСтрока(НСтр("ru='партнеру'") + " ",
														"""", Новый ФорматированнаяСтрока(Строка(Отбор.ОтборПартнер), Шрифт),""""));
	КонецЕсли;
	
	Если ЕстьСоглашение Тогда
		ТекстПояснения = Новый ФорматированнаяСтрока(ТекстПояснения,
														?(ЕстьСклад ИЛИ ЕстьФорматМагазина или ЕстьПодразделение или ЕстьПартнер,", ",""),
														Новый ФорматированнаяСтрока(НСтр("ru='соглашению'") + " ",
														"""", Новый ФорматированнаяСтрока(Строка(Отбор.ОтборСоглашение), Шрифт),""""));
	КонецЕсли;
	
	Если ЕстьНазначение Тогда
		ТекстПояснения = Новый ФорматированнаяСтрока(ТекстПояснения,
														?(ЕстьСклад ИЛИ ЕстьФорматМагазина или ЕстьПодразделение или ЕстьПартнер или ЕстьСоглашение,", ",""),
														Новый ФорматированнаяСтрока(НСтр("ru='назначению'") + " ",
														"""", Новый ФорматированнаяСтрока(Строка(Отбор.ОтборНазначение), Шрифт),""""));
	КонецЕсли;
	
	ЭлементПояснение.Видимость = ЗначениеЗаполнено(ТекстПояснения);
	
	ТекстПояснения = Новый ФорматированнаяСтрока(НСтр("ru='* Поля с отбором по'") + " ", ТекстПояснения, ".");
	
	ЭлементПояснение.Заголовок = ТекстПояснения;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьРасшифровку(Операнд,СтандартнаяОбработка)
	
	ОперандыСРасшифровкой = ПолучитьОперандыСРасшифровкой();
	
	Если НЕ ОперандыСРасшифровкой.Свойство(Операнд) Тогда
		Возврат;
	КонецЕсли;
	
	МассивИменНаборов = Новый Массив();
	МассивИменНаборов.Добавить(Операнд);
	
	МассивДанныхРасшифровки = ПолучитьРасшифровку(МассивИменНаборов);
	
	Если МассивДанныхРасшифровки = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	СписокДокументов = Новый СписокЗначений();
	
	Для каждого ЭлементРасшифровки Из МассивДанныхРасшифровки Цикл
	
		ДокументПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru = '%1 (№ %2 от %3)'"),
										Формат(ЭлементРасшифровки[Операнд], "ЧДЦ=3"), ЭлементРасшифровки.НомерДокумента, 
										Формат(ЭлементРасшифровки.ДатаДокумента, "ДЛФ=D"));
				
		СписокДокументов.Добавить(ЭлементРасшифровки.Документ, ДокументПредставление);
	
	КонецЦикла; 

	ИмяФормыРасшифровки = ОперандыСРасшифровкой[Операнд] + ".ФормаОбъекта";
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ИмяФормыРасшифровки",ИмяФормыРасшифровки);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборДокумента", ЭтотОбъект,ДополнительныеПараметры);
	СписокДокументов.ПоказатьВыборЭлемента(ОписаниеОповещения, НСтр("ru='Выберите документ'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборДокумента(РезультатВыбора, ДополнительныеПараметры) Экспорт 

	Если Не РезультатВыбора = Неопределено Тогда 
		
		Документ = РезультатВыбора.Значение;
		ПоказатьЗначение(, Документ);
		
	КонецЕсли;

КонецПроцедуры 

&НаСервере
Функция ПолучитьОперандыСРасшифровкой()

	ОперандыСРасшифровкой = Новый Структура();
	
	Для каждого Поле Из ПараметрыРасшифровки.Поля Цикл
		Значение = Поле.Значение;
		Если Значение.Свойство("Расшифровка") и ЗначениеЗаполнено(Значение.Расшифровка) Тогда
			ОперандыСРасшифровкой.Вставить(Поле.Значение.Имя,Поле.Значение.Расшифровка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОперандыСРасшифровкой;

КонецФункции

&НаСервере
Функция ПолучитьРасшифровку(МассивИменНаборов)

	Возврат Планирование.ПолучитьРасшифровку(МассивИменНаборов, ПараметрыРасшифровки);

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПересчитатьНачалоПериода(НачалоПериода, Периодичность, Знач Смещение)
	
	Результат = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(НачалоПериода, Периодичность, Смещение);
	
	Результат = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуНачалаПериода(Результат + 1, Периодичность);
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПересчитатьОкончаниеПериода(НачалоПериода, Периодичность, Знач Смещение)
	
	Результат = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(НачалоПериода, Периодичность, Смещение);
	
	Результат = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(Результат + 1, Периодичность);
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьПредставлениеПериода(Периодичность, НачалоПериода,ОкончаниеПериода) 

	Представление = "";
	
	ПланированиеКлиентСервер.УстановитьНачалоОкончаниеПериодаПлана(Периодичность, НачалоПериода, ОкончаниеПериода);
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		Если НачалоМесяца(НачалоПериода) = НачалоМесяца(ОкончаниеПериода) Тогда
			Представление = Формат(НачалоПериода, "ДФ='ММММ гггг'");
		Иначе
			Представление = Формат(НачалоПериода, "ДФ='ММММ гггг'") + " - " + Формат(ОкончаниеПериода, "ДФ='ММММ гггг'");
		КонецЕсли;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		
		Если НачалоДня(НачалоПериода) = НачалоДня(ОкончаниеПериода) Тогда
			Представление = Формат(НачалоПериода, "ДЛФ=DD");
		Иначе
			Представление = Формат(НачалоПериода, "ДЛФ=DD") + " - " + Формат(ОкончаниеПериода, "ДЛФ=DD");
		КонецЕсли;
		
	Иначе
		
		Представление = Формат(НачалоПериода, "ДЛФ=DD") + " - " + Формат(ОкончаниеПериода, "ДЛФ=DD");
		
	КонецЕсли;
	
	Возврат Представление;

КонецФункции

&НаСервере
Процедура УстановитьЗаголовокЗначенияОперандов()

	Если Не ПараметрыРасшифровки.Свойство("НачалоПериодаСмещения") или ПараметрыРасшифровки.Свойство("КонецПериодСмещения") Тогда
		Возврат;
	КонецЕсли;
	
	НачалоПериода 		= ПересчитатьНачалоПериода(ПараметрыРасшифровки.НачалоПериодаСмещения, ПараметрыРасшифровки.Периодичность, ПараметрыРасшифровки.СмещениеПериода);
	ОкончаниеПериода 	= ПересчитатьОкончаниеПериода(ПараметрыРасшифровки.КонецПериодаСмещения, ПараметрыРасшифровки.Периодичность, ПараметрыРасшифровки.СмещениеПериода);
	
	ПериодВыборки 		= СформироватьПредставлениеПериода(ПараметрыРасшифровки.Периодичность, НачалоПериода, ОкончаниеПериода);
	
	Элементы.ОперандыЗначение.Заголовок = "Значение (" + ПериодВыборки + ")";

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДеревоОперандов(Параметры)

	Если Параметры.Свойство("ТипСобытийОповещений") Тогда
		ЗагрузитьДеревоОперандовПоТипуСобытияОповещения(Параметры.ТипСобытийОповещений);
	Иначе
		ЗагрузитьДеревоОперандовИзХранилища(Параметры.Операнды);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДеревоОперандовИзХранилища(АдресХранилища)
	
	Дерево = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если ТипЗнч(Дерево) <> Тип("ДеревоЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Строка Из Дерево.Строки Цикл
		
		ДобавитьВДеревоСтроки(Строка.Строки, СтрокаДереваВерхнийУровень(Строка.Идентификатор, Строка.Представление));
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВДеревоСтроки(Данные, СтрокаРодитель)
	
	ДочернииЭлементы = СтрокаРодитель.ПолучитьЭлементы();
	
	Для Каждого Строка ИЗ Данные Цикл
		
		НовыйЭлемент = ДочернииЭлементы.Добавить();
		НовыйЭлемент.Идентификатор = Строка.Идентификатор;
		НовыйЭлемент.Представление = Строка.Представление;
		НовыйЭлемент.КодКартинки   = 3;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДеревоОперандовПоТипуСобытияОповещения(ТипСобытийОповещений)
	
	Если ТипЗнч(ТипСобытийОповещений) <> Тип("ПеречислениеСсылка.ТипыСобытийОповещений")
		ИЛИ НЕ ЗначениеЗаполнено(ТипСобытийОповещений) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	МакетСКД = Перечисления.ТипыСобытийОповещений.ПолучитьМакет(
	       ТипСобытийОповещений.Метаданные().ЗначенияПеречисления.Получить(Перечисления.ТипыСобытийОповещений.Индекс(ТипСобытийОповещений)).Имя);
	КомпоновщикНастроек = РассылкиИОповещенияКлиентам.ИнициализироватьСКД(МакетСКД, УникальныйИдентификатор);
	
	ДобавитьВДеревоДоступныеПоляПоКомпоновщикуНастроек(КомпоновщикНастроек, СтрокаДереваВерхнийУровень("ПредыдущееСообщение", НСтр("ru = 'Предыдущее сообщение'")));
	ДобавитьВДеревоДоступныеПоляПоКомпоновщикуНастроек(КомпоновщикНастроек, СтрокаДереваВерхнийУровень("ТекущееСообщение", НСтр("ru = 'Текущее сообщение'")));
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВДеревоДоступныеПоляПоКомпоновщикуНастроек(КомпоновщикНастроек, СтрокаРодитель)

	 Для Каждого ДоступноеПоле ИЗ КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		
		Если ДоступноеПоле.Папка Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаИмяПараметра = СтрокаРодитель.ПолучитьЭлементы().Вставить(СтрокаРодитель.ПолучитьЭлементы().Количество());
		
		СтрокаИмяПараметра.Идентификатор = ДоступноеПоле.Поле;
		СтрокаИмяПараметра.Представление = ДоступноеПоле.Заголовок;
		СтрокаИмяПараметра.КодКартинки   = 3;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция СтрокаДереваВерхнийУровень(Идентификатор, Представление)

	СтрокаВерхнийУровень = ДеревоОперандов.ПолучитьЭлементы().Добавить();
	СтрокаВерхнийУровень.Идентификатор = Идентификатор;
	СтрокаВерхнийУровень.Представление = Представление;
	СтрокаВерхнийУровень.КодКартинки   = 2;
	
	Возврат СтрокаВерхнийУровень;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыПроверкиФормулы(Форма)
	
	ДополнительныеПараметры = Новый Структура;
	
	Если ЗначениеЗаполнено(Форма.ТипРезультата) Тогда
		
		ДополнительныеПараметры.Вставить("ТипРезультата", Форма.ТипРезультата);
		
	КонецЕсли;
	
	Если Форма.ФормулаДляВычисленияВЗапросе Тогда
		
		ДополнительныеПараметры.Вставить("ФормулаДляВычисленияВЗапросе", Форма.ФормулаДляВычисленияВЗапросе);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.ФункцииИзОбщегоМодуля) Тогда
	
		ДополнительныеПараметры.Вставить("ФункцииИзОбщегоМодуля", Форма.ФункцииИзОбщегоМодуля);
	
	КонецЕсли; 
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

#КонецОбласти

#КонецОбласти
