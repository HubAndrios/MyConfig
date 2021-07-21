&НаКлиенте
Перем ПараметрыОбработчикаОжидания;
&НаКлиенте
Перем ФормаДлительнойОперации;
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеНастроекМонитораПоказателей" Тогда
		
		ОбновлениеСтруктурыНастроекСервер();
		
		ИнициализироватьОбработчикАвтообновления(СтруктураНастроек.ПериодАвтообновления * 60);
		
		ОбновитьСоставМонитораКлиент();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИнициализироватьОбработчикАвтообновления();
	ОбновитьСоставМонитораКлиент();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СтруктураНастроек = МониторингЦелевыхПоказателей.ПолучитьНастройкиМонитораЦелевыхПоказателей();
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	ЗаполнитьСписокВыбораОтбораПоСтатусу();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборЗонаВниманияПриИзменении(Элемент)
	
	ОбновитьСоставМонитораКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	ОбновитьСоставМонитораКлиент();
КонецПроцедуры

&НаКлиенте
Процедура ПодсказкаОМобильномПриложенииНажатие(Элемент)
	ПараметрыФормы = Новый Структура("ИмяМакетаОписания, НазваниеПриложения", 
		"ОписаниеМобильногоПриложенияМониторERP", НСтр("ru= '1С:Монитор ERP'"));
	ОткрытьФорму("ОбщаяФорма.ОписаниеМобильногоПриложения", ПараметрыФормы, ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПоказателей

&НаКлиенте
Процедура ДеревоПоказателейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если НЕ Элемент.ТекущиеДанные.ЭтоГруппа Тогда
		Отбор = Новый Структура("ОтборВариантовАнализа", Элемент.ТекущиеДанные.ВариантАнализа);
		ПараметрыФормы = Новый Структура("Отбор, ПользовательскиеНастройки, СформироватьПриОткрытии", 
			Отбор,
			Отчет.КомпоновщикНастроек.ПользовательскиеНастройки,
			Истина);
		
		ОткрытьФорму("Отчет.МониторЦелевыхПоказателей.Форма.ПечатнаяФормаВариантаАнализа", 
			ПараметрыФормы, 
			ЭтаФорма, 
			Новый УникальныйИдентификатор());
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Настроить(Команда)
	ПараметрыФормы = Новый Структура("ПользовательскиеНастройки", 
		Отчет.КомпоновщикНастроек.ПользовательскиеНастройки);
		
	ОбработкаЗавершения = Новый ОписаниеОповещения("НастроитьЗавершение", ЭтаФорма);
	ОткрытьФорму("Отчет.МониторЦелевыхПоказателей.ФормаНастроек", 
		ПараметрыФормы, 
		ЭтаФорма, 
		ЭтаФорма,,,
		ОбработкаЗавершения);
КонецПроцедуры

&НаКлиенте 
Процедура НастроитьЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если Не РезультатЗакрытия = КодВозвратаДиалога.Отмена 
		И Не РезультатЗакрытия = Неопределено Тогда
		Отчет.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(РезультатЗакрытия);
		
		ОбновлениеСтруктурыНастроекСервер();
		
		ИнициализироватьОбработчикАвтообновления(СтруктураНастроек.ПериодАвтообновления * 60);
		
		ОбновитьСоставМонитораКлиент();
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура Обновить(Команда)
	
	ИнициализироватьОбработчикАвтообновления();
	
	ОбновитьСоставМонитораКлиент(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	#Область ОформлениеГруппПоказателей
		Элемент = УсловноеОформление.Элементы.Добавить();

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПоказателей.Имя);

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПоказателей.ЭтоГруппа");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Истина, Ложь, Ложь, Ложь, ));
		
		//

		Элемент = УсловноеОформление.Элементы.Добавить();

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПоказателей.Имя);

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПоказателей.Статус");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = "НеприемлемоеСостояние";

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПоказателей.ЭтоГруппа");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Кирпичный);
		
		//

		Элемент = УсловноеОформление.Элементы.Добавить();

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПоказателей.Имя);

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПоказателей.Статус");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = "ПриемлемоеСостояние";

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПоказателей.ЭтоГруппа");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноОранжевый);

		//

		Элемент = УсловноеОформление.Элементы.Добавить();

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПоказателей.Имя);

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПоказателей.Статус");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = "ЦельДостигнута";

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПоказателей.ЭтоГруппа");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ЦветМорскойВолны);
		
		//

		Элемент = УсловноеОформление.Элементы.Добавить();

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПоказателей.Имя);

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПоказателей.Статус");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = "РассчитаноСОшибками";

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПоказателей.ЭтоГруппа");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Кирпичный);
	#КонецОбласти 

	#Область ОформлениеЗначенияПоказателяПриОшибках
		Элемент = УсловноеОформление.Элементы.Добавить();

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПоказателейТекущееЗначение.Имя);

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПоказателей.Статус");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = "РассчитаноСОшибками";

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПоказателей.ЭтоГруппа");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОтличающейсяСтрокиДокумента);
		Элемент.Оформление.УстановитьЗначениеПараметра("ГоризонтальноеПоложение", ГоризонтальноеПоложение.Лево);
	#КонецОбласти 

	#Область УсловноеОформлениеОтображенияДеталей
		Элемент = УсловноеОформление.Элементы.Добавить();

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПоказателейАбсИзменение.Имя);

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПоказателейОтнИзменение.Имя);

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПоказателей.ЗонаВнимания");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Перечисления.ЗоныВниманияВариантовАнализа.РассчитанныеСОшибками;

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПоказателей.ЭтоГруппа");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

		//

		Элемент = УсловноеОформление.Элементы.Добавить();

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПоказателейОтнИзменение.Имя);

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПоказателейАбсИзменение.Имя);

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантОтображенияДеталей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = НСтр("ru = 'ПоказыватьТекущееЗначениеИДетали'");

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЕстьПодробности");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Истина);

		//

		Элемент = УсловноеОформление.Элементы.Добавить();

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПоказателейОтнИзменение.Имя);

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПоказателейАбсИзменение.Имя);

		ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

		ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЕстьПодробности");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантОтображенияДеталей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
		ОтборЭлемента.ПравоеЗначение = НСтр("ru = 'ПоказыватьТекущееЗначениеИДетали'");

		Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	#КонецОбласти 
КонецПроцедуры

#Область ЗаполнениеДереваЦелевыхПоказателей

&НаСервере
Функция ДобавитьГруппирующуюСтроку(ДеревоПоказателейЗначение, СтруктураЗначенийСтроки, ЭтоГруппа, РодительскаяСтрока = Неопределено)
	
	Если РодительскаяСтрока = Неопределено Тогда
		ГруппирующаяСтрока = ДеревоПоказателейЗначение.Строки.Добавить();
	Иначе 
		ГруппирующаяСтрока = РодительскаяСтрока.Строки.Добавить();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ГруппирующаяСтрока, СтруктураЗначенийСтроки);
	ГруппирующаяСтрока.ЭтоГруппа = ЭтоГруппа;
	ГруппирующаяСтрока.КартинкаСостояния = 4;
	ГруппирующаяСтрока.КартинкаТренда = 8;
	
	Возврат ГруппирующаяСтрока;
	
КонецФункции

&НаСервере
Процедура ДобавитьЭлементыМонитора(ДеревоПоказателейЗначение, СоставМонитора)
	
	ЗоныВнимания = Перечисления.ЗоныВниманияВариантовАнализа;
	
	СоздатьБазовуюСтруктуруДереваПоказателей(ДеревоПоказателейЗначение, СоставМонитора);
	
	НаборИсточниковДанных = СоставМонитора.НаборИсточниковДанных;
	
	Если СтруктураНастроек.ВариантГруппировкиПоказателей = "ПоСостоянию" Тогда
		Отбор = Новый Структура("Статус", "НеприемлемоеСостояние");
		Показатели = НаборИсточниковДанных.НайтиСтроки(Отбор);
		
		Если Показатели.Количество() > 0 Тогда
			ДобавитьЭлементыМонитораСУчетомСостояния(ДеревоПоказателейЗначение, Показатели, Отбор.Статус);
		КонецЕсли;
		
		Отбор = Новый Структура("Статус", "ПриемлемоеСостояние");
		Показатели = НаборИсточниковДанных.НайтиСтроки(Отбор);
		
		Если Показатели.Количество() > 0 Тогда
			ДобавитьЭлементыМонитораСУчетомСостояния(ДеревоПоказателейЗначение, Показатели, Отбор.Статус);
		КонецЕсли;
		
		Отбор = Новый Структура("Статус", "ЦельДостигнута");
		Показатели = НаборИсточниковДанных.НайтиСтроки(Отбор);
		
		Если Показатели.Количество() > 0 Тогда
			ДобавитьЭлементыМонитораСУчетомСостояния(ДеревоПоказателейЗначение, Показатели, Отбор.Статус);
		КонецЕсли;
		
		Отбор = Новый Структура("Статус", "СостояниеНеОпределено");
		Показатели = НаборИсточниковДанных.НайтиСтроки(Отбор);
		
		Если Показатели.Количество() > 0 Тогда
			ДобавитьЭлементыМонитораСУчетомСостояния(ДеревоПоказателейЗначение, Показатели, Отбор.Статус);
		КонецЕсли;
		
		Отбор = Новый Структура("Статус", "РассчитаноСОшибками");
		Показатели = НаборИсточниковДанных.НайтиСтроки(Отбор);
		
		Если Показатели.Количество() > 0 Тогда
			ДобавитьЭлементыМонитораСУчетомСостояния(ДеревоПоказателейЗначение, Показатели, Отбор.Статус);
		КонецЕсли;
		
		ЗначениеВДанныеФормы(ДеревоПоказателейЗначение, ДеревоПоказателей);
		
	ИначеЕсли СтруктураНастроек.ВариантГруппировкиПоказателей = "ПоКатегориямЦелей"  Тогда
		ГруппыПоказателей = НаборИсточниковДанных.Скопировать();
		ГруппыПоказателей.Свернуть("Группа");
		
		Для Каждого ГруппаПоказателей Из ГруппыПоказателей Цикл 
			ПоГруппе = Новый Структура("Группа", ГруппаПоказателей.Группа);
			ПоказателиГруппы = НаборИсточниковДанных.НайтиСтроки(ПоГруппе);
		
			ДобавитьЭлементыМонитораСУчетомГруппы(ДеревоПоказателейЗначение, ПоказателиГруппы, ГруппаПоказателей.Группа);
			
		КонецЦикла;
		
		ЗначениеВДанныеФормы(ДеревоПоказателейЗначение, ДеревоПоказателей);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Процедура ДобавитьЭлементыМонитораСУчетомГруппы(ДеревоПоказателейЗначение, КоллекцияПоказателей, ГруппаПоказателей)
	
	СтрокаГруппы = ДеревоПоказателейЗначение.Строки.Найти(ГруппаПоказателей, "ВариантАнализа");
	
	ВидыПредставленияЧисел = Перечисления.ВидыПредставленияЧисел;
	
	СчетчикСтрок = 1;
	СчетчикЭлементовСтроки = 0;
	Для Каждого ЭлементМонитора Из КоллекцияПоказателей Цикл 
		ВариантАнализа = ЭлементМонитора.ВариантАнализа; 
		ИсточникДанных = ЭлементМонитора.ИсточникДанных.Получить();
		ДинамическиеСвойстваВариантаАнализа = ИсточникДанных.ДинамическиеСвойстваВариантаАнализа;
		ВидПредставленияЧисел = ВариантАнализа.КратностьЗначений;
		
		ПоказыватьТекущееЗначениеИДеталиПоказателя = (НЕ ВариантыАнализаСПодробностями.НайтиПоЗначению(ВариантАнализа) = Неопределено);
		ИспользоватьНарастающийИтог = (НЕ ВариантыАнализаСНарастающимИтогом.НайтиПоЗначению(ВариантАнализа) = Неопределено);
	
		ТочностьРасчетаДробнойЧасти = ВариантАнализа.ТочностьРасчетаДробнойЧасти;
		
		ТекстовоеПредставлениеПериода = МониторингЦелевыхПоказателей.ПредставлениеПериодаВариантаАнализа(ИсточникДанных);
		
		СтрокаПоказателя = СтрокаГруппы.Строки.Добавить();
		СтрокаПоказателя.ВариантАнализа = ВариантАнализа;
		СтрокаПоказателя.КраткоеНаименование = ВариантАнализа.Наименование + " (" + ТекстовоеПредставлениеПериода + ")";
		СтрокаПоказателя.Период = ТекстовоеПредставлениеПериода;
		
		СтрокаПоказателя.ЗонаВнимания = ЭлементМонитора.ЗонаВнимания;
		
		Если НЕ ИсточникДанных.Пустой И НЕ ИсточникДанных.ОшибкаРасчета Тогда
			ПоследнееЗначение	 = Окр(ИсточникДанных.СвойстваДанныхПоПериодам.ПоследнееЗначение, ТочностьРасчетаДробнойЧасти);
			ОтображаемоеЗначение = ПоследнееЗначение;
			
			ПоследнееЦелевоеЗначение		 = Окр(ИсточникДанных.СвойстваДанныхПоПериодам.ЦелевоеЗначение, ТочностьРасчетаДробнойЧасти);
			ПредпоследнееЗначение = Окр(ИсточникДанных.СвойстваДанныхПоПериодам.ПредпоследнееЗначение, ТочностьРасчетаДробнойЧасти);
			
			РазмерностьПоказателя = СокрЛП(Строка(ДинамическиеСвойстваВариантаАнализа.Размерность));
			
			Если ЗначениеЗаполнено(РазмерностьПоказателя) Тогда
				СтрокаРазмерности = " " + РазмерностьПоказателя;
			Иначе
				СтрокаРазмерности = "";
			КонецЕсли;
			
			СтрокаПоказателя.ТекущееЗначение = МониторингЦелевыхПоказателей.ПолучитьСокращенноеПредставлениеЧисла(ОтображаемоеЗначение, ТочностьРасчетаДробнойЧасти, ВидПредставленияЧисел) + СтрокаРазмерности;
			
			Если ПоказыватьТекущееЗначениеИДеталиПоказателя И СтруктураНастроек.ВариантОтображенияДеталей = "ПоказыватьТекущееЗначениеИДетали" Тогда
				Если НЕ ПредпоследнееЗначение = 0 Тогда
					ОтносительноеИзменение = Окр(100 * (ПоследнееЗначение - ПредпоследнееЗначение)/ПредпоследнееЗначение, ТочностьРасчетаДробнойЧасти);
					
					Если ОтносительноеИзменение > 0 Тогда
						ЗнакИзменения = "▲";
					ИначеЕсли ОтносительноеИзменение = 0 Тогда
						ЗнакИзменения = "";
					ИначеЕсли ОтносительноеИзменение < 0 Тогда
						ЗнакИзменения = "▼";
					КонецЕсли;
				
					СтрокаПоказателя.ОтнИзменение = ЗнакИзменения + ОтносительноеИзменение + " %";
				Иначе
					СтрокаПоказателя.ОтнИзменение = "---";
				КонецЕсли; 
				
				АбсолютноеИзменение = ПоследнееЗначение - ПредпоследнееЗначение;
				
				Если АбсолютноеИзменение > 0 Тогда
					ЗнакИзменения = "▲";
				ИначеЕсли АбсолютноеИзменение = 0 Тогда
					ЗнакИзменения = "";
				ИначеЕсли АбсолютноеИзменение < 0 Тогда
					ЗнакИзменения = "▼";
				КонецЕсли;
				
				СтрокаПоказателя.АбсИзменение = ЗнакИзменения
												+ МониторингЦелевыхПоказателей.ПолучитьСокращенноеПредставлениеЧисла(АбсолютноеИзменение, ТочностьРасчетаДробнойЧасти, ВидПредставленияЧисел) + СтрокаРазмерности;
				
			КонецЕсли;
			
		Иначе 
			Если ИсточникДанных.Свойство("ОписаниеОшибки") Тогда
				СтрокаПоказателя.ТекущееЗначение = ИсточникДанных.ОписаниеОшибки;
				
			Иначе
				СтрокаПоказателя.ТекущееЗначение = НСтр("ru='Ошибка расчета показателя'");
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере 
Процедура ДобавитьЭлементыМонитораСУчетомСостояния(ДеревоПоказателейЗначение, КоллекцияПоказателей, Состояние)
	
	СтрокаСостояния = ДеревоПоказателейЗначение.Строки.Найти(Состояние, "Статус");
	
	ВидыПредставленияЧисел = Перечисления.ВидыПредставленияЧисел;
	
	СчетчикСтрок = 1;
	СчетчикЭлементовСтроки = 0;
	Для Каждого ЭлементМонитора Из КоллекцияПоказателей Цикл 
		ВариантАнализа = ЭлементМонитора.ВариантАнализа; 
		ИсточникДанных = ЭлементМонитора.ИсточникДанных.Получить();
		ДинамическиеСвойстваВариантаАнализа = ИсточникДанных.ДинамическиеСвойстваВариантаАнализа;
		ВидПредставленияЧисел = ВариантАнализа.КратностьЗначений;
		
		ПоказыватьТекущееЗначениеИДеталиПоказателя = (НЕ ВариантыАнализаСПодробностями.НайтиПоЗначению(ВариантАнализа) = Неопределено);
		ИспользоватьНарастающийИтог = (НЕ ВариантыАнализаСНарастающимИтогом.НайтиПоЗначению(ВариантАнализа) = Неопределено);
	
		ТочностьРасчетаДробнойЧасти = ВариантАнализа.ТочностьРасчетаДробнойЧасти;
		
		ТекстовоеПредставлениеПериода = МониторингЦелевыхПоказателей.ПредставлениеПериодаВариантаАнализа(ИсточникДанных);
		
		СтрокаПоказателя = СтрокаСостояния.Строки.Добавить();
		СтрокаПоказателя.ВариантАнализа = ВариантАнализа;
		СтрокаПоказателя.КраткоеНаименование = ВариантАнализа.Наименование + " (" + ТекстовоеПредставлениеПериода + ")";
		СтрокаПоказателя.Период = ТекстовоеПредставлениеПериода;
		
		СтрокаПоказателя.Статус = Состояние;
		
		Если НЕ ИсточникДанных.Пустой И НЕ ИсточникДанных.ОшибкаРасчета Тогда
			ПоследнееЗначение	 = Окр(ИсточникДанных.СвойстваДанныхПоПериодам.ПоследнееЗначение, ТочностьРасчетаДробнойЧасти);
			ОтображаемоеЗначение = ПоследнееЗначение;
			
			ПоследнееЦелевоеЗначение		 = Окр(ИсточникДанных.СвойстваДанныхПоПериодам.ЦелевоеЗначение, ТочностьРасчетаДробнойЧасти);
			ПредпоследнееЗначение = Окр(ИсточникДанных.СвойстваДанныхПоПериодам.ПредпоследнееЗначение, ТочностьРасчетаДробнойЧасти);
			
			РазмерностьПоказателя = СокрЛП(Строка(ДинамическиеСвойстваВариантаАнализа.Размерность));
			
			Если ЗначениеЗаполнено(РазмерностьПоказателя) Тогда
				СтрокаРазмерности = " " + РазмерностьПоказателя;
			Иначе
				СтрокаРазмерности = "";
			КонецЕсли;
		
			СтрокаПоказателя.ТекущееЗначение = МониторингЦелевыхПоказателей.ПолучитьСокращенноеПредставлениеЧисла(ОтображаемоеЗначение, ТочностьРасчетаДробнойЧасти, ВидПредставленияЧисел) + СтрокаРазмерности;
			
			Если ПоказыватьТекущееЗначениеИДеталиПоказателя И СтруктураНастроек.ВариантОтображенияДеталей = "ПоказыватьТекущееЗначениеИДетали" Тогда
				Если НЕ ПредпоследнееЗначение = 0 Тогда
					ОтносительноеИзменение = Окр(100 * (ПоследнееЗначение - ПредпоследнееЗначение)/ПредпоследнееЗначение, ТочностьРасчетаДробнойЧасти);
					
					Если ОтносительноеИзменение > 0 Тогда
						ЗнакИзменения = "+";
					ИначеЕсли ОтносительноеИзменение = 0 Тогда
						ЗнакИзменения = "";
					ИначеЕсли ОтносительноеИзменение < 0 Тогда
						ЗнакИзменения = "-";
					КонецЕсли;
				
					СтрокаПоказателя.ОтнИзменение = ЗнакИзменения + ОтносительноеИзменение + " %";
				Иначе
					СтрокаПоказателя.ОтнИзменение = "---";
				КонецЕсли; 
				
				АбсолютноеИзменение = ПоследнееЗначение - ПредпоследнееЗначение;
				
				Если АбсолютноеИзменение > 0 Тогда
					ЗнакИзменения = "+";
				ИначеЕсли АбсолютноеИзменение = 0 Тогда
					ЗнакИзменения = "";
				ИначеЕсли АбсолютноеИзменение < 0 Тогда
					ЗнакИзменения = "-";
				КонецЕсли;
				
				СтрокаПоказателя.АбсИзменение = ЗнакИзменения
												+ МониторингЦелевыхПоказателей.ПолучитьСокращенноеПредставлениеЧисла(АбсолютноеИзменение, ТочностьРасчетаДробнойЧасти, ВидПредставленияЧисел) + СтрокаРазмерности;
				
			КонецЕсли;
			
		Иначе 
			Если ИсточникДанных.Свойство("ОписаниеОшибки") Тогда
				СтрокаПоказателя.ТекущееЗначение = ИсточникДанных.ОписаниеОшибки;
				
			Иначе
				СтрокаПоказателя.ТекущееЗначение = НСтр("ru='Ошибка расчета показателя'");
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьБазовуюСтруктуруДереваПоказателей(ДеревоПоказателейЗначение, ПолученныйСоставМонитора)
	
	ЗоныВнимания = Перечисления.ЗоныВниманияВариантовАнализа;
	
	СтатистикаПоСтрокам = ПолученныйСоставМонитора.СтатистикаПоСтрокам;
	НаборИсточниковДанных = ПолученныйСоставМонитора.НаборИсточниковДанных;
	Если СтруктураНастроек.ВариантГруппировкиПоказателей = "ПоСостоянию" Тогда
		Если СтатистикаПоСтрокам.НеприемлемоеСостояние > 0 Тогда
			
			СтруктураЗначений = Новый Структура("КраткоеНаименование, Статус");
			СтруктураЗначений.Вставить("КраткоеНаименование", НСтр("ru= 'Неприемлемое состояние'") );
			СтруктураЗначений.Вставить("Статус", "НеприемлемоеСостояние");

			ГруппаКритическоеСостояние = ДобавитьГруппирующуюСтроку(ДеревоПоказателейЗначение, СтруктураЗначений, Истина); 
			
		КонецЕсли;
		
		Если СтатистикаПоСтрокам.ПриемлемоеСостояние > 0 Тогда
			
			СтруктураЗначений = Новый Структура("КраткоеНаименование, Статус");
			СтруктураЗначений.Вставить("КраткоеНаименование", НСтр("ru= 'Приемлемое состояние'") );
			СтруктураЗначений.Вставить("Статус", "ПриемлемоеСостояние");
			
			ГруппаВажно = ДобавитьГруппирующуюСтроку(ДеревоПоказателейЗначение, СтруктураЗначений, Истина); 
			
		КонецЕсли;
		
		Если СтатистикаПоСтрокам.ЦельДостигнута > 0 Тогда
			
			СтруктураЗначений = Новый Структура("КраткоеНаименование, Статус");
			СтруктураЗначений.Вставить("КраткоеНаименование", НСтр("ru= 'Цель достигнута'") );
			СтруктураЗначений.Вставить("Статус", "ЦельДостигнута");
			
			ГруппаКСведению = ДобавитьГруппирующуюСтроку(ДеревоПоказателейЗначение, СтруктураЗначений, Истина); 
			
		КонецЕсли;
		
		Если СтатистикаПоСтрокам.СостояниеНеОпределено > 0 Тогда
			
			СтруктураЗначений = Новый Структура("КраткоеНаименование, Статус");
			СтруктураЗначений.Вставить("КраткоеНаименование", НСтр("ru= 'Состояние не определено'") );
			СтруктураЗначений.Вставить("Статус", "СостояниеНеОпределено");
			
			ГруппаРассчитанныеСОшибками = ДобавитьГруппирующуюСтроку(ДеревоПоказателейЗначение, СтруктураЗначений, Истина); 
			
		КонецЕсли;
		
		Если СтатистикаПоСтрокам.РассчитаноСОшибками > 0 Тогда
			
			СтруктураЗначений = Новый Структура("КраткоеНаименование, Статус");
			СтруктураЗначений.Вставить("КраткоеНаименование", НСтр("ru= 'Рассчитано с ошибками'") );
			СтруктураЗначений.Вставить("Статус", "РассчитаноСОшибками");
			
			ГруппаРассчитанныеСОшибками = ДобавитьГруппирующуюСтроку(ДеревоПоказателейЗначение, СтруктураЗначений, Истина); 
			
		КонецЕсли;
		
	ИначеЕсли СтруктураНастроек.ВариантГруппировкиПоказателей = "ПоКатегориямЦелей"  Тогда
		
		ГруппыПоказателей = ПолученныйСоставМонитора.НаборИсточниковДанных.Скопировать();
		ГруппыПоказателей.Свернуть("Группа");
		
		Для Каждого ГруппаПоказателей Из ГруппыПоказателей Цикл 
			СтруктураЗначений = Новый Структура("ВариантАнализа, КраткоеНаименование", ГруппаПоказателей.Группа, ГруппаПоказателей.Группа.Наименование);
			
			ДобавитьГруппирующуюСтроку(ДеревоПоказателейЗначение, СтруктураЗначений, Истина); 
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте 
Процедура ИнициализироватьОбработчикАвтообновления(ПериодАвтообновления = Неопределено)
	
	Если ПериодАвтообновления = Неопределено Тогда
		ПериодАвтообновления = СтруктураНастроек.ПериодАвтообновления * 60;
	КонецЕсли;
	
	Если ПериодАвтообновления > 0 Тогда
		ОтключитьОбработчикОжидания("ОбработчикОжидания_ОбновитьСоставМонитораКлиент");
		ПодключитьОбработчикОжидания("ОбработчикОжидания_ОбновитьСоставМонитораКлиент", ПериодАвтообновления);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Процедура ЗаполнитьСписокВыбораОтбораПоСтатусу()
	СписокВыбора = Элементы.ОтборЗонаВнимания.СписокВыбора;
	
	СписокВыбора.Добавить(0, НСтр("ru= 'Все'"));
	СписокВыбора.Добавить(1, НСтр("ru= 'Критические'"));
	СписокВыбора.Добавить(2, НСтр("ru= 'Важные'"));
	СписокВыбора.Добавить(3, НСтр("ru= 'Критические и важные'"));
	СписокВыбора.Добавить(4, НСтр("ru= 'К сведению'"));
	СписокВыбора.Добавить(5, НСтр("ru= 'Рассчитанные с ошибкой'"));
КонецПроцедуры

&НаСервере 
Процедура ОбновитьСоставМонитора(ПолученныйСоставМонитора)
	
	Элементы.ГруппаПояснениеПриЗапуске.Видимость = Ложь;
	
	ДеревоПоказателейЗначение = РеквизитФормыВЗначение("ДеревоПоказателей");
	
	// Удалим ранее заполненные показатели
	ДеревоПоказателейЗначение.Строки.Очистить();
	
	НаборИсточниковДанных = ПолученныйСоставМонитора.НаборИсточниковДанных;
	СоставМонитораНеопределен = (НаборИсточниковДанных = Неопределено);
	СоставМонитораПустойПоОтбору = ПолученныйСоставМонитора.Пустой;
	
	УстановитьВидимостьПредложенияДобавитьПоказателиВСоставМонитора(СоставМонитораНеопределен);
	УстановитьВидимостьСообщенияПустойРезультатОтбора(СоставМонитораПустойПоОтбору);
	
	Если НЕ СоставМонитораНеопределен Тогда
		ВариантыАнализаСПодробностями.Очистить();
		ОтборПоПодробным = Новый Структура("ВыводитьПодробности", Истина);
		НайденныеПоказатели = НаборИсточниковДанных.НайтиСтроки(ОтборПоПодробным);
		Для Каждого НайденныйВариантАнализа Из НайденныеПоказатели Цикл 
			ВариантыАнализаСПодробностями.Добавить(НайденныйВариантАнализа.ВариантАнализа);
			
		КонецЦикла;
		
		Если НЕ ВариантыАнализаСПодробностями.Количество() = 0 Тогда
			ЕстьПодробности = Истина;
		Иначе 
			ЕстьПодробности = Ложь;
		КонецЕсли;
		
		ВариантыАнализаСНарастающимИтогом.Очистить();
		ОтборПоНарастающемуИтогу = Новый Структура("СостояниеПоНарастающемуИтогу", Истина);
		НайденныеПоказатели = НаборИсточниковДанных.НайтиСтроки(ОтборПоНарастающемуИтогу);
		Для Каждого НайденныйВариантАнализа Из НайденныеПоказатели Цикл 
			ВариантыАнализаСНарастающимИтогом.Добавить(НайденныйВариантАнализа.ВариантАнализа);
			
		КонецЦикла;
		
		СоставМонитораОбъект = НаборИсточниковДанных.Скопировать(,"ВариантАнализа");
		СоставМонитораОбъект.Колонки.Добавить("АдресДинамическихПараметров");
		ЗначениеВДанныеФормы(СоставМонитораОбъект, СоставМонитора);
	Иначе
		Если СоставМонитораНеопределен Тогда
			ВариантыАнализаСПодробностями.Очистить();
			ЕстьПодробности = Ложь;
			
			ВариантыАнализаСНарастающимИтогом.Очистить();
			
			ДеревоПоказателейЗначение = РеквизитФормыВЗначение("ДеревоПоказателей");
			ДеревоПоказателейЗначение.Строки.Очистить();
			ЗначениеВДанныеФормы(ДеревоПоказателейЗначение, ДеревоПоказателей);
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ СоставМонитораНеопределен И НЕ СоставМонитораПустойПоОтбору Тогда
		// Создать реквизиты формы по составу монитора
		// К имени элементов добавляется строка "__"+ID_Элемента, где
		// ID_Элемента = ВариантАнализа.УникальныйИдентификатор() + Позиция, т.е. уникален
		ДобавитьЭлементыМонитора(ДеревоПоказателейЗначение, ПолученныйСоставМонитора);
	
	КонецЕсли;
	
	Элементы.ДеревоПоказателей.Видимость = (НЕ СоставМонитораНеопределен И НЕ СоставМонитораПустойПоОтбору);
	
КонецПроцедуры

&НаСервере 
Процедура ОбновлениеСтруктурыНастроекСервер()
	
	СтруктураНастроек = МониторингЦелевыхПоказателей.ПолучитьНастройкиМонитораЦелевыхПоказателей();
	
КонецПроцедуры

&НаКлиенте 
Процедура ОбработчикОжидания_ОбновитьСоставМонитораКлиент()

	ОбновитьСоставМонитораКлиент();

КонецПроцедуры

&НаКлиенте 
Процедура РазвернутьГруппыПоказателей()
	
	ЭлементыДерева = ДеревоПоказателей.ПолучитьЭлементы();
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл 
		Если ЭлементДерева.ЭтоГруппа Тогда 
			
			ИдентификаторЭлемента = ЭлементДерева.ПолучитьИдентификатор();
			Элементы.ДеревоПоказателей.Развернуть(ИдентификаторЭлемента);
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере 
Процедура УстановитьВидимостьПредложенияДобавитьПоказателиВСоставМонитора(Видимость)
	Элементы.ГруппаПриПустомСоставеМонитора.Видимость = Видимость;
	ПостояннаяЧасть = НСтр("ru= 'Нет ни одного доступного для отображения варианта анализа.'"); 
	Если ПравоДоступа("Изменение", Метаданные.Справочники.ВариантыАнализаЦелевыхПоказателей) Тогда
		Элементы.ПояснениеЕслиМониторНеНастроен.Заголовок = ПостояннаяЧасть
			+ Символы.ПС + НСтр("ru= 'Для настройки используйте рабочее место ""Финансовый результат и контроллинг"" - ""Настройка доступности вариантов анализа"".'");
	Иначе
		Элементы.ПояснениеЕслиМониторНеНастроен.Заголовок = ПостояннаяЧасть
			+ Символы.ПС + НСтр("ru= 'Обратитесь к админитратору системы для настройки доступности вариантов анализа.'");
	КонецЕсли;
	Элементы.ДеревоПоказателей.Видимость = НЕ Видимость;
КонецПроцедуры

&НаСервере 
Процедура УстановитьВидимостьСообщенияПустойРезультатОтбора(Видимость)
	
	Элементы.ГруппаПриПустомРезультатеОтбора.Видимость = Видимость;
	Элементы.ДеревоПоказателей.Видимость = НЕ Видимость;
	
КонецПроцедуры

#КонецОбласти

#Область ДлительныеОперации

&НаСервере
Функция ЗаданиеВыполнено(Знач ИдентификаторЗадания) 
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСоставМонитораКлиент(ПринудительноОбновитьДанные = Ложь)
	
	ПараметрыСоставаМонитора = Новый Структура("
		|ОтборВариантовАнализа,
		|ПринудительноОбновитьДанные,
		|СтруктураНастроек, 
		|ОтборЗонаВнимания, 
		|ОтборСтатус, 
		|УчитыватьВариантыОтображения,
		|ДемонстрационныйРежим");
	ПараметрыСоставаМонитора.ОтборВариантовАнализа 		  = Неопределено;
	ПараметрыСоставаМонитора.ПринудительноОбновитьДанные  = ПринудительноОбновитьДанные;
	ПараметрыСоставаМонитора.СтруктураНастроек 			  = СтруктураНастроек;
	ПараметрыСоставаМонитора.ОтборЗонаВнимания 			  = ОтборЗонаВнимания;
	ПараметрыСоставаМонитора.ОтборСтатус 				  = ОтборСтатус;
	ПараметрыСоставаМонитора.УчитыватьВариантыОтображения = Ложь;
	ПараметрыСоставаМонитора.ДемонстрационныйРежим		  = Ложь;
	
	ЗаданиеВыполнено = ЗаполнитьОтчетНаСервере(ПараметрыСоставаМонитора);
	Если ЗаданиеВыполнено Тогда
		РазвернутьГруппыПоказателей();
		Возврат;
	КонецЕсли;
		
	ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);	
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	
	ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	
	ОбновитьОтображениеДанных();
КонецПроцедуры

&НаСервере
Функция ЗаполнитьОтчетНаСервере(ПараметрыСоставаМонитора)
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	ЗаданиеВыполнено = Ложь; 
	
	// В файловом режиме работы выполняем операцию непосредственно (синхронно).
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		МониторингЦелевыхПоказателей.ПодготовитьДанныеДляЗаполнения(ПараметрыСоставаМонитора, АдресХранилища);
		
		ЗагрузитьПодготовленныеДанные();
		
		Возврат Истина; 
	КонецЕсли;
	
	// В клиент-серверном режиме работы выполняем операцию в фоновом задании (асинхронно).
	НаименованиеЗадания = НСтр("ru = 'Заполнение отчета ""Монитор целевых показателей""'");
	
	ПараметрыЗаполнения = Новый Массив;
	ПараметрыЗаполнения.Добавить(ПараметрыСоставаМонитора);
	ПараметрыЗаполнения.Добавить(АдресХранилища);
	
	Если ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая Тогда
		ВремяОжидания = 4;
	Иначе
		ВремяОжидания = 2;
	КонецЕсли;
	
	Задание = ФоновыеЗадания.Выполнить("МониторингЦелевыхПоказателей.ПодготовитьДанныеДляЗаполнения", 
										ПараметрыЗаполнения, , НаименованиеЗадания);
	Попытка
		Задание.ОжидатьЗавершения(ВремяОжидания);
	Исключение  
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Заполнение отчета ""Монитор целевых показателей""'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	ИдентификаторЗадания = Задание.УникальныйИдентификатор;
	// Если операция уже завершилась, то сразу обрабатываем результат.
	Если ЗаданиеВыполнено(Задание.УникальныйИдентификатор) Тогда
		ЗаданиеВыполнено = Истина;
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат ЗаданиеВыполнено;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Возврат;
		КонецЕсли;
		
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
	ПараметрыОбработчикаОжидания.ТекущийИнтервал = ПараметрыОбработчикаОжидания.ТекущийИнтервал * ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала;
	Если ПараметрыОбработчикаОжидания.ТекущийИнтервал > ПараметрыОбработчикаОжидания.МаксимальныйИнтервал Тогда
		ПараметрыОбработчикаОжидания.ТекущийИнтервал = ПараметрыОбработчикаОжидания.МаксимальныйИнтервал;
	КонецЕсли;
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 
									ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
									Истина);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Свойство("Монитор") Тогда
		СформированныйСостав = Результат.Монитор;
		ОбновитьСоставМонитора(СформированныйСостав);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
