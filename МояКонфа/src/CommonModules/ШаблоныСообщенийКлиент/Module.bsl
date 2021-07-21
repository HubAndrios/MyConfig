#Область ПрограммныйИнтерфейс

// Открывает форму для выбора шаблона.
//
// Параметры:
//   Оповещение - ОписаниеОповещения - оповещение, которое будет вызвано после выбора шаблона с готовым сообщением.
//
Процедура ВыбратьШаблон(Оповещение) Экспорт
	
	ДополнительныеПараметры = Новый Структура("Оповещение", Оповещение);
	ПараметрыФормы = Новый Структура("Назначение, РежимВыбора, ВидСообщения", "Общий", Истина, "Письмо");
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоШаблонуПослеВыбораШаблона", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Справочник.ШаблоныСообщений.Форма.СформироватьСообщение", ПараметрыФормы, ЭтотОбъект,,,, Оповещение);
	
КонецПроцедуры

// Показывает форму шаблона сообщения.
//
// Параметры:
//  Значение - СправочникСсылка.ШаблоныСообщений, Структура, ЛюбаяСсылка - Если передана ссылка на шаблон сообщения,
 //                    то будет открыт этот шаблон.
 //                    Если передана структура, то будет открыто окно нового шаблона сообщения заполненного из полей
//                     структуры. Описание полей. см. ШаблоныСообщенийКлиентСервер.ОписаниеПараметровШаблона.
//                     Если ЛюбаяСсылка, то будет открыт шаблон сообщения по владельцу. 
//  ПараметрыОткрытия - Структура - параметры открытия формы:
//    * Владелец - Произвольный - Форма или элемент управления другой формы.
//    * Уникальность - Произвольный - Ключ, значение которого будет использоваться для поиска уже открытых форм.
//    * НавигационнаяСсылка - Строка - Задает навигационную ссылку, возвращаемую формой.
//    * ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана после
//                                                         закрытия формы.
//    * РежимОткрытияОкна - РежимОткрытияОкнаФормы - Указывает режим открытия окна управляемой формы.
//
Процедура ПоказатьФормуШаблона(Значение, ПараметрыОткрытия = Неопределено) Экспорт
	
	ПараметрыОткрытияФормы = ПараметрыФормы(ПараметрыОткрытия);
	
	ПараметрыФормы = Новый Структура;
	Если ТипЗнч(Значение) = Тип("Структура") Тогда
		ПараметрыФормы.Вставить("Основание", Значение);
		ПараметрыФормы.Вставить("ВладелецШаблона", Значение.ВладелецШаблона);
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.ШаблоныСообщений") Тогда
		ПараметрыФормы.Вставить("Ключ", Значение);
	Иначе
		ПараметрыФормы.Вставить("ВладелецШаблона", Значение);
		ПараметрыФормы.Вставить("Ключ", Значение);
	КонецЕсли;

	ОткрытьФорму("Справочник.ШаблоныСообщений.ФормаОбъекта", ПараметрыФормы, ПараметрыОткрытияФормы.Владелец,
		ПараметрыОткрытияФормы.Уникальность,, ПараметрыОткрытияФормы.НавигационнаяСсылка,
		ПараметрыОткрытияФормы.ОписаниеОповещенияОЗакрытии, ПараметрыОткрытияФормы.РежимОткрытияОкна);
КонецПроцедуры

// Возвращает параметры открытия формы шаблона сообщения.
//
// Параметры:
//  ДанныеЗаполнения - Произвольный - Значение, на основании которого выполняется заполнение.
//                                    Значение данного параметра не может быть следующих типов:
//                                    Неопределено, Null, Число, Строка, Дата, Булево, Дата.
// 
// Возвращаемое значение:
//  Структура - Список параметров открытия формы.
//  * Владелец - Произвольный - Форма или элемент управления другой формы.
//  * Уникальность - Произвольный - Ключ, значение которого будет использоваться для поиска уже открытых форм.
//  * НавигационнаяСсылка - Строка - Задает навигационную ссылку, возвращаемую формой.
//  * ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана после
//                                                       закрытия формы.
//  * РежимОткрытияОкна - РежимОткрытияОкнаФормы - Указывает режим открытия окна управляемой формы.
//
Функция ПараметрыФормы(ДанныеЗаполнения) Экспорт
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("Владелец", Неопределено);
	ПараметрыОткрытия.Вставить("Уникальность", Неопределено);
	ПараметрыОткрытия.Вставить("НавигационнаяСсылка", Неопределено);
	ПараметрыОткрытия.Вставить("ОписаниеОповещенияОЗакрытии", Неопределено);
	ПараметрыОткрытия.Вставить("РежимОткрытияОкна", Неопределено);
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, ДанныеЗаполнения);
	КонецЕсли;
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоШаблонуПослеВыбораШаблона(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.Оповещение, Результат);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


