#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	СогласоватьЗначенияПризнаков();
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",ЭтоНовый());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	РегистрыСведений.НастройкиАдресныхСкладов.УстановитьНастройкиПоУмолчанию(
		Владелец,
		Ссылка,
		ИспользоватьАдресноеХранение,
		ДатаНачалаАдресногоХраненияОстатков,
		ИспользоватьАдресноеХранениеСправочно,
		ИспользованиеРабочихУчастков = Перечисления.ИспользованиеСкладскихРабочихУчастков.Использовать,
		ДополнительныеСвойства.ЭтоНовый);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения)
		ИЛИ НЕ ДанныеЗаполнения.Свойство("Владелец") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	1 КАК Поле1
	|ИЗ
	|	Справочник.СкладскиеПомещения КАК Помещения
	|ГДЕ
	|	НЕ Помещения.ПометкаУдаления
	|	И Помещения.Владелец = &Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкиАдресныхСкладов.ИспользоватьАдресноеХранение,
	|	НастройкиАдресныхСкладов.ИспользоватьАдресноеХранениеСправочно,
	|	НастройкиАдресныхСкладов.ИспользоватьРабочиеУчастки,
	|	Склады.ТекущийОтветственный,
	|	Склады.ТекущаяДолжностьОтветственного
	|ИЗ
	|	Справочник.Склады КАК Склады
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиАдресныхСкладов КАК НастройкиАдресныхСкладов
	|		ПО (НастройкиАдресныхСкладов.Склад = Склады.Ссылка)
	|			И (НастройкиАдресныхСкладов.Помещение = &ПустоеПомещение)
	|ГДЕ
	|	Склады.Ссылка = &Владелец";
	Запрос.УстановитьПараметр("Владелец",ДанныеЗаполнения.Владелец);
	Запрос.УстановитьПараметр("ПустоеПомещение",Справочники.СкладскиеПомещения.ПустаяСсылка());
	Результат = Запрос.ВыполнитьПакет();
	Если Результат[0].Пустой() Тогда
		Выборка = Результат[1].Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		Если Выборка.ИспользоватьАдресноеХранение Тогда
			НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.ЯчейкиОстатки;
		ИначеЕсли Выборка.ИспользоватьАдресноеХранениеСправочно Тогда
			НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.ЯчейкиСправочно;
		Иначе
			НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.НеИспользовать;
		КонецЕсли;
		Если Выборка.ИспользоватьРабочиеУчастки Тогда
			ИспользованиеРабочихУчастков = Перечисления.ИспользованиеСкладскихРабочихУчастков.Использовать;
		Иначе
			ИспользованиеРабочихУчастков = Перечисления.ИспользованиеСкладскихРабочихУчастков.НеИспользовать;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Процедура СогласоватьЗначенияПризнаков() Экспорт
	Если Не ЗначениеЗаполнено(НастройкаАдресногоХранения)
		Или НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.ОпределяетсяНастройкамиПомещения Тогда
		НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.НеИспользовать;
	КонецЕсли;
	
	Если НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.ЯчейкиОстатки Тогда
		ИспользоватьАдресноеХранение          = Истина;
	ИначеЕсли НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.ЯчейкиСправочно Тогда
		ИспользоватьАдресноеХранение          = Ложь;
		ИспользоватьАдресноеХранениеСправочно = Истина;
	Иначе
		ИспользоватьАдресноеХранение          = Ложь;
		ИспользоватьАдресноеХранениеСправочно = Ложь;
	КонецЕсли;
	
	Если Не ИспользоватьАдресноеХранение
		И Не ИспользоватьАдресноеХранениеСправочно Тогда
		НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.НеИспользовать;
	КонецЕсли;
	
	Если Не ИспользоватьАдресноеХранение Тогда
		ДатаНачалаАдресногоХраненияОстатков = Дата(1, 1, 1);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли