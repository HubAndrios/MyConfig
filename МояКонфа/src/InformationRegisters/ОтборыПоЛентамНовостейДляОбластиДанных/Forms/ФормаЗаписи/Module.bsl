#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Элементы.КатегорияНовостей.СписокВыбора.ЗагрузитьЗначения(ПолучитьРазрешенныеКатегорииНовостейДляЭтойЛентыНовостей(Запись.ЛентаНовостей));

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция возвращает массив доступных категорий для ленты новостей.
//
// Параметры:
//  лкЛентаНовостей - СправочникСсылка.ЛентыНовостей.
//
// Возвращаемое значение:
//  Массив.
//
&НаСервереБезКонтекста
Функция ПолучитьРазрешенныеКатегорииНовостейДляЭтойЛентыНовостей(Знач лкЛентаНовостей)

	Результат = Новый Массив;

	Если НЕ лкЛентаНовостей.Пустая() Тогда
		Результат = лкЛентаНовостей.ДоступныеКатегорииНовостей.Выгрузить(, "КатегорияНовостей").ВыгрузитьКолонку("КатегорияНовостей");
	КонецЕсли;

	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ЛентаНовостейПриИзменении(Элемент)

	Элементы.КатегорияНовостей.СписокВыбора.ЗагрузитьЗначения(ПолучитьРазрешенныеКатегорииНовостейДляЭтойЛентыНовостей(Запись.ЛентаНовостей));

КонецПроцедуры

#КонецОбласти
