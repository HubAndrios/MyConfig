#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостямиТекущемуПользователю() <> Истина Тогда
		Отказ = Истина;
		СтандартнаяОбработка= Ложь;
		Возврат;
	КонецЕсли;

	// В конфигурации есть общие реквизиты с разделением и включена ФО РаботаВМоделиСервиса.
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		// Если включено разделение данных, и мы зашли в неразделенном сеансе,
		//  то нельзя устанавливать пользовательские свойства новости.
		// Зашли в конфигурацию под пользователем без разделения (и не вошли в область данных).
		Если ИнтернетПоддержкаПользователей.СеансЗапущенБезРазделителей() Тогда
			Элементы.ГруппаКоманднаяПанель.Видимость = Ложь;
			ПолучитьТекущегоПользователя = Ложь;
		Иначе
			ПолучитьТекущегоПользователя = Истина;
		КонецЕсли;
	Иначе
		ПолучитьТекущегоПользователя = Истина;
	КонецЕсли;

	Если ПолучитьТекущегоПользователя = Истина Тогда
		ЭтаФорма.ПараметрыСеанса_ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Иначе
		ЭтаФорма.ПараметрыСеанса_ТекущийПользователь = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;

	Если ВРег(Параметры.РежимОткрытияОкна) = ВРег("БлокироватьОкноВладельца") Тогда
		ЭтаФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе // Все остальные значения
		// По-умолчанию - независимое открытие.
		ЭтаФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
	КонецЕсли;

	ЭтаФорма.ЗаголовокФормы = Параметры.Заголовок;
	Если ПустаяСтрока(ЭтаФорма.ЗаголовокФормы) = Истина Тогда
		ЭтаФорма.ЗаголовокФормы = "Новости";
	КонецЕсли;

	Если (Параметры.ПоказыватьПанельНавигации = Истина)
			И (ОбработкаНовостейПовтИсп.ЕстьРолиЧтенияНовостей()) Тогда
		Элементы.ГруппаНавигация.Видимость = Истина;
	Иначе
		Элементы.ГруппаНавигация.Видимость = Ложь;
	КонецЕсли;

	ЭтаФорма.СписокНовостей.Очистить();
	Для Каждого ТекущаяНовость Из Параметры.СписокНовостей Цикл
		ЭтаФорма.СписокНовостей.Добавить(ТекущаяНовость.Значение, ТекущаяНовость.Значение.УИННовости);
	КонецЦикла;

	ЭтаФорма.Заголовок = ЭтаФорма.ЗаголовокФормы + " (" + ЭтаФорма.СписокНовостей.Количество() + ")";

	ЭтаФорма.ТекстНовостей = ОбработкаНовостейПовтИсп.ПолучитьХТМЛТекстНовостей(
		ЭтаФорма.СписокНовостей.ВыгрузитьЗначения(),
		Новый Структура("ОтображатьЗаголовок", Истина));

	ЭтаФорма.ОповещениеВключено = Истина; // Для списка новостей (в отличие от одной новости) пользователю необходимо вручную отключить оповещение.

	ОбработкаНовостейПереопределяемый.ДополнительноОбработатьФормуОченьВажныхНовостейПриСозданииНаСервере(
		ЭтаФорма,
		Отказ,
		СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если ЗавершениеРаботы = Истина Тогда
		// Запрещены серверные вызовы и открытие форм.
		// В таком исключительном случае, когда выходят из программы,
		//  можно проигнорировать установку признака прочтенности у новостей.
	Иначе

		// Прочтена - При закрытии помечать все новости как прочитанные.
		// ОповещениеВключено - в зависимости от установленной галочки.

		Для Каждого ТекущаяНовость Из ЭтаФорма.СписокНовостей Цикл
			Оповестить(
				"Новости. Новость прочтена",
				Истина,
				ТекущаяНовость.Значение);
			Оповестить(
				"Новости. Изменено состояние оповещения о новости",
				ЭтаФорма.ОповещениеВключено,
				ТекущаяНовость.Значение);
		КонецЦикла;

		Если НЕ ЭтаФорма.ПараметрыСеанса_ТекущийПользователь.Пустая() Тогда
			СписокОчисткиКонтекстныхНовостей = ЗаписатьИзменениеСостоянияНовостиСервер(
				ЭтаФорма.СписокНовостей,
				ЭтаФорма.ОповещениеВключено,
				ЭтаФорма.ПараметрыСеанса_ТекущийПользователь);

			// Для новостей с отключенным признаком Оповещение очистить кэш контекстных новостей.
			Если ЭтаФорма.ОповещениеВключено = Ложь Тогда
				Для Каждого ПараметрыКонтекстнойНовости Из СписокОчисткиКонтекстныхНовостей Цикл
					ОбработкаНовостейКлиент.УдалитьКонтекстныеНовостиИзКэшаПриложения(
						ПараметрыКонтекстнойНовости.Значение,
						ПараметрыКонтекстнойНовости.Представление);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстНовостейПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)

	ОбработкаНовостейКлиент.ОбработкаНажатияВТекстеНовости(
		ЭтаФорма.СписокНовостей,
		ДанныеСобытия,
		СтандартнаяОбработка,
		ЭтаФорма,
		Элемент);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаБольшеНеПоказывать(Команда)

	ЭтаФорма.ОповещениеВключено = Ложь;
	ЭтаФорма.Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказатьПозже(Команда)

	ЭтаФорма.ОповещениеВключено = Истина;
	ЭтаФорма.Закрыть();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
// Функция записывает регистр сведений "СостоянияНовостей".
// Также подготавливается список данных для очистки кэша контекстных новостей.
//
// Параметры:
//  лкСписокНовостей      - СписокЗначений - список новостей;
//  лкОповещениеВключено  - Булево;
//  лкТекущийПользователь - СправочникСсылка.Пользователи.
//
// Возвращаемое значение:
//   СписокЗначений - список данных, для которых надо очистить кэш контекстных новостей:
//     * Значение - ИдентификаторМетаданных;
//     * Представление - ИдентификаторФормы.
//
Функция ЗаписатьИзменениеСостоянияНовостиСервер(лкСписокНовостей, лкОповещениеВключено, лкТекущийПользователь)

	СписокДанныхДляОчисткиКэшаКонтекстныхНовостей = Новый СписокЗначений;

	Для Каждого ТекущаяНовость Из лкСписокНовостей Цикл
		Запись = РегистрыСведений.СостоянияНовостей.СоздатьМенеджерЗаписи();
		Запись.Пользователь = лкТекущийПользователь;
		Запись.Новость      = ТекущаяНовость.Значение;
		Запись.Прочитать(); // Запись будет ниже. // На тот случай, если были установлены другие свойства
		// Вдруг новость не выбрана (т.е. ее нет в базе) - перезаполнить менеджер записи и записать.
		Запись.Пользователь         = лкТекущийПользователь;
		Запись.Новость              = ТекущаяНовость.Значение;
		Запись.Прочтена             = Истина; // Всегда устанавливать прочтенность
		// Запись.Пометка Не трогать.
		Запись.ОповещениеВключено   = лкОповещениеВключено;
		// Запись.ДатаНачалаОповещения Не трогать.
		Запись.Записать(Истина);
	КонецЦикла;

	Если лкОповещениеВключено = Ложь Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Спр.Метаданные КАК ИдентификаторМетаданных,
			|	Спр.Форма      КАК ИдентификаторФормы
			|ИЗ
			|	Справочник.Новости.ПривязкаКМетаданным КАК Спр
			|ГДЕ
			|	Спр.Ссылка В (&МассивНовостейДляОчисткиКэшаКонтекстныхНовостей)
			|";
		Запрос.УстановитьПараметр("МассивНовостейДляОчисткиКэшаКонтекстныхНовостей", лкСписокНовостей.ВыгрузитьЗначения());

		Результат = Запрос.Выполнить(); // ЗаписатьИзменениеСостоянияНовостиСервер()
		Если НЕ Результат.Пустой() Тогда
			Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.Прямой);
			Пока Выборка.Следующий() Цикл
				СписокДанныхДляОчисткиКэшаКонтекстныхНовостей.Добавить(
					Выборка.ИдентификаторМетаданных,
					Выборка.ИдентификаторФормы);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	Возврат СписокДанныхДляОчисткиКэшаКонтекстныхНовостей;

КонецФункции

// Процедура для работы с закэшированной формой новостей - форма уже в памяти, надо установить ей список новостей и открыть.
//
// Параметры:
//  лкЗаголовокФормы - Строка - заголовок формы.
//  лкСписокНовостей - СписокЗначений - список новостей, где:
//    * Значение      - СправочникСсылка.Новости;
//    * Представление - Строка (36) - уникальный идентификатор новости;
//    * Пометка       - Булево - Признак прочтенности, Истина - новость прочтена.
//
&НаКлиенте
Процедура УстановитьСписокНовостей(лкЗаголовокФормы, лкСписокНовостей) Экспорт

	ЭтаФорма.ЗаголовокФормы = лкЗаголовокФормы;
	Если ПустаяСтрока(ЭтаФорма.ЗаголовокФормы) = Истина Тогда
		ЭтаФорма.ЗаголовокФормы = "Новости";
	КонецЕсли;

	ЭтаФорма.СписокНовостей.Очистить();
	Для Каждого ТекущаяНовость Из лкСписокНовостей Цикл
		ЭтаФорма.СписокНовостей.Добавить(ТекущаяНовость.Значение, ТекущаяНовость.Представление);
	КонецЦикла;

	ЭтаФорма.Заголовок = ЭтаФорма.ЗаголовокФормы + " (" + ЭтаФорма.СписокНовостей.Количество() + ")";

	ЭтаФорма.ТекстНовостей = ОбработкаНовостейКлиентПовтИсп.ПолучитьХТМЛТекстНовостей(
		ЭтаФорма.СписокНовостей.ВыгрузитьЗначения(),
		Новый Структура("ОтображатьЗаголовок", Истина));

	ЭтаФорма.ОповещениеВключено = Истина; // Для списка новостей (в отличие от одной новости) пользователю необходимо вручную отключить оповещение.

КонецПроцедуры

#КонецОбласти
