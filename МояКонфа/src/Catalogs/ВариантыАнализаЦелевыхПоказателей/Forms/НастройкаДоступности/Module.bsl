
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВариантОтображенияПоУмолчанию = Параметры.ВариантОтображенияПоУмолчанию;

	ЗаполнитьНастройкиДоступности();
	
	УстановитьВидимостьГруппыПоиска(Элементы);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиДоступности

&НаКлиенте
Процедура НастройкиДоступностиДоступностьПоПодразделениюПриИзменении(Элемент)
	
	Если Элементы.НастройкиДоступности.ТекущиеДанные <> Неопределено Тогда
		
		ОбновитьСоставДоступностиВниз(Элементы.НастройкиДоступности.ТекущаяСтрока, 
			Элементы.НастройкиДоступности.ТекущиеДанные.ДоступностьПоПодразделению);
			
		ОбновитьСоставДоступностиВверх(Элементы.НастройкиДоступности.ТекущаяСтрока);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиДоступностиДоступностьПриИзменении(Элемент)
	
	Если Элементы.НастройкиДоступности.ТекущиеДанные <> Неопределено Тогда
		
		ОбновитьСоставДоступностиВниз(Элементы.НастройкиДоступности.ТекущаяСтрока, 
			Число(Элементы.НастройкиДоступности.ТекущиеДанные.Доступность));
			
		ОбновитьСоставДоступностиВверх(Элементы.НастройкиДоступности.ТекущаяСтрока);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыбранныеПользователи

&НаКлиенте
Процедура ВыбранныеПользователиДоступностьПриИзменении(Элемент)
	
	ВыбранныйПользователь = Элементы.ВыбранныеПользователи.ТекущиеДанные;
	
	ОбновляемаяСтрока = НастройкиДоступности.НайтиПоИдентификатору(ВыбранныйПользователь.ИдентификаторНастройкиДоступности);
	ОбновляемаяСтрока.Доступность = ВыбранныйПользователь.Доступность;
	
	ОбновитьСоставДоступностиВверх(ВыбранныйПользователь.ИдентификаторНастройкиДоступности);
			
	Если НЕ ВыбранныйПользователь.Доступность Тогда
		
		ВыбранныеПользователи.Удалить(ВыбранныеПользователи.Индекс(ВыбранныйПользователь));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	Если Элементы.СтраницыНастроекДоступности.ТекущаяСтраница = Элементы.СтраницаВыбранныеПользователи Тогда
		Для Каждого ВыбранныйПользователь Из ВыбранныеПользователи Цикл
			ТекущиеДанные = НастройкиДоступности.НайтиПоИдентификатору(ВыбранныйПользователь.ИдентификаторНастройкиДоступности);
			ТекущиеДанные.Доступность = ВыбранныйПользователь.Доступность;
			ТекущиеДанные.ВариантОтображения = ВыбранныйПользователь.ВариантОтображения;
			
		КонецЦикла; 
	Иначе
		ВыбранныеПользователи.Очистить();
		
		ЗаполнитьСписокВыбранныеПользователи();
		
	КонецЕсли;
	
	АдресХранилищаВыбранныхПользователей = АдресХранилищаВыбранныхПользователей();
	
	Закрыть(АдресХранилищаВыбранныхПользователей);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	ОбновитьСоставДоступностиВниз(Неопределено, Истина);
	
	ОбновитьСписокВыбранныеПользователи();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьТолькоВыбранныхПользователей(Команда)
	
	ТолькоВыбранные = Элементы.ФормаПоказатьТолькоВыбранныхПользователей.Пометка;
	
	Если ТолькоВыбранные Тогда
		
		Для Каждого ВыбранныйПользователь Из ВыбранныеПользователи Цикл 
			
			ТекущиеДанные = НастройкиДоступности.НайтиПоИдентификатору(ВыбранныйПользователь.ИдентификаторНастройкиДоступности);
			ТекущиеДанные.Доступность = ВыбранныйПользователь.Доступность;
			
			ОбновитьСоставДоступностиВверх(ВыбранныйПользователь.ИдентификаторНастройкиДоступности);
			
		КонецЦикла;
		
		Элементы.СтраницыНастроекДоступности.ТекущаяСтраница = Элементы.СтраницаНастройкиДоступности;
		
	Иначе
		
		ВыбранныеПользователи.Очистить();
		
		ЗаполнитьСписокВыбранныеПользователи();
		
		Элементы.СтраницыНастроекДоступности.ТекущаяСтраница = Элементы.СтраницаВыбранныеПользователи;
		
	КонецЕсли;
	
	Элементы.ФормаПоказатьТолькоВыбранныхПользователей.Пометка = Не ТолькоВыбранные;
	
	УстановитьВидимостьГруппыПоиска(Элементы);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметки(Команда)
	
	ОбновитьСоставДоступностиВниз(Неопределено, Ложь);
	
	ОбновитьСписокВыбранныеПользователи();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиДоступностиПользователь.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиДоступностиДоступность.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиДоступности.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиДоступностиПодразделение.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиДоступностиДоступностьПоПодразделению.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиДоступности.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиДоступностиПодразделение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиДоступности.Подразделение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Подразделение не указано>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиДоступностиПодразделение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиДоступности.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиДоступности.ДоступностьПоПодразделению");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Истина, Ложь, Ложь, Ложь, ));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиДоступностиПользователь.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиДоступности.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиДоступности.Доступность");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Истина, Ложь, Ложь, Ложь, ));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВыбранныеПользователиПользователь.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВыбранныеПользователи.Доступность");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Истина, Ложь, Ложь, Ложь, ));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВыбранныеПользователиПодразделение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВыбранныеПользователи.Подразделение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Подразделение не указано>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиДоступностиВариантОтображения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиДоступности.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиДоступности.Доступность");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиДоступностиВариантОтображения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиДоступности.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	
КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаКлиенте 
Процедура ОбновитьСоставДоступностиВверх(ИдентификаторСтроки)
	
	ТекущиеДанные = НастройкиДоступности.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	ТекущиеДанныеРодитель = ТекущиеДанные.ПолучитьРодителя();
	
	Если НЕ ТекущиеДанныеРодитель = Неопределено Тогда
		ЭлементыРодителя = ТекущиеДанныеРодитель.ПолучитьЭлементы();
		
		КоличествоНулей = 0;
		КоличествоЕдиниц = 0;
		КоличествоДвоек = 0;
		Для Каждого ЭлементРодителя Из ЭлементыРодителя Цикл 
			Если ЭлементРодителя.ТипСтроки = 0 Тогда 
				ЗначениеДоступности = ЭлементРодителя.ДоступностьПоПодразделению;
				
			ИначеЕсли ЭлементРодителя.ТипСтроки = 1 Тогда 
				ЗначениеДоступности = ЭлементРодителя.Доступность;
				
			КонецЕсли;
			
			Если ЗначениеДоступности = 0 Тогда
				КоличествоНулей = КоличествоНулей + 1;
				
			ИначеЕсли ЗначениеДоступности = 1 Тогда
				КоличествоЕдиниц = КоличествоЕдиниц + 1;
				
			ИначеЕсли ЗначениеДоступности = 2 Тогда
				КоличествоДвоек = КоличествоДвоек + 1;
				
			КонецЕсли;
			
		КонецЦикла;
		
		КоличествоЭлементов = ЭлементыРодителя.Количество();
		
		Если КоличествоНулей = 0 Тогда
			Если КоличествоЕдиниц = КоличествоЭлементов Тогда
				ТекущиеДанныеРодитель.ДоступностьПоПодразделению = 1;
				
			Иначе
				ТекущиеДанныеРодитель.ДоступностьПоПодразделению = 2;
				
			КонецЕсли;
		Иначе
			Если КоличествоНулей = КоличествоЭлементов Тогда
				ТекущиеДанныеРодитель.ДоступностьПоПодразделению = 0;
				
			Иначе
				ТекущиеДанныеРодитель.ДоступностьПоПодразделению = 2;
				
			КонецЕсли;
		КонецЕсли;
		
		ОбновитьСоставДоступностиВверх(ТекущиеДанныеРодитель.ПолучитьИдентификатор());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте 
Процедура ОбновитьСоставДоступностиВниз(ИдентификаторСтроки, Состояние)
	
	Если ИдентификаторСтроки = Неопределено Тогда
		КоллекцияПользователей = НастройкиДоступности.ПолучитьЭлементы();
		
	Иначе
		ТекущиеДанные = НастройкиДоступности.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		Состояние = ?(Состояние = 2, 0, Состояние);
		
		Если ТекущиеДанные.ТипСтроки = 0 Тогда
			ТекущиеДанные.ДоступностьПоПодразделению = Состояние;
			
		ИначеЕсли ТекущиеДанные.ТипСтроки = 1 Тогда
			ТекущиеДанные.Доступность = Состояние;
			
			ТекущиеДанные.ВариантОтображения = ВариантОтображенияПоУмолчанию;
		КонецЕсли;
		
		КоллекцияПользователей = ТекущиеДанные.ПолучитьЭлементы();
		
	КонецЕсли;
	
	Для каждого ЭлементКоллекцииПользователей Из КоллекцияПользователей Цикл
		Если ЭлементКоллекцииПользователей.ТипСтроки = 0 Тогда
			ЭлементКоллекцииПользователей.ДоступностьПоПодразделению = Состояние;
			
			ОбновитьСоставДоступностиВниз(ЭлементКоллекцииПользователей.ПолучитьИдентификатор(), Состояние);
			
		ИначеЕсли ЭлементКоллекцииПользователей.ТипСтроки = 1 Тогда
			ЭлементКоллекцииПользователей.Доступность = Состояние;
			
			ЭлементКоллекцииПользователей.ВариантОтображения = ВариантОтображенияПоУмолчанию;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Помещает во временное хранилище таблицу значений с выбранными пользователями
// и возвращает адрес
// 
// Возвращаемое значение:
//	Строка - адрес хранилища значений таблицы значений во временном хранилище
//
&НаСервере 
Функция АдресХранилищаВыбранныхПользователей()
	
	ВыбранныеПользователиОбъект = ДанныеФормыВЗначение(ВыбранныеПользователи, Тип("ТаблицаЗначений"));
	
	АдресНастроекДоступности = ПоместитьВоВременноеХранилище(Новый ХранилищеЗначения(ВыбранныеПользователиОбъект));
	
	Возврат АдресНастроекДоступности;
	
КонецФункции

&НаСервере 
Процедура ЗаполнитьНастройкиДоступности()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("НастройкиДоступности", Параметры.Пользователи.Выгрузить());
	Запрос.УстановитьПараметр("ВариантОтображенияПоУмолчанию", ВариантОтображенияПоУмолчанию);
	Запрос.Текст = "ВЫБРАТЬ
	|	НастройкиДоступности.Пользователь,
	|	НастройкиДоступности.ВариантОтображения
	|ПОМЕСТИТЬ НастройкиДоступности
	|ИЗ
	|	&НастройкиДоступности КАК НастройкиДоступности
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Пользователи.Подразделение КАК Подразделение,
	|	Пользователи.Ссылка КАК Пользователь,
	|	&ВариантОтображенияПоУмолчанию КАК ВариантОтображенияПоУмолчанию
	|ПОМЕСТИТЬ Пользователи
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Пользователи.Подразделение КАК Подразделение,
	|	Пользователи.Пользователь КАК Пользователь,
	|	ЛОЖЬ КАК ДоступностьПоПодразделению,
	|	1 КАК ТипСтроки,
	|	ВЫБОР
	|		КОГДА ПользователиВНесохраненномВарианте.Количество = 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Доступность,
	|	ВЫБОР
	|		КОГДА ПользователиВНесохраненномВарианте.ВариантОтображения = ЗНАЧЕНИЕ(Перечисление.ВариантыОтображенияВариантовАнализа.ПустаяСсылка)
	|				ИЛИ ПользователиВНесохраненномВарианте.ВариантОтображения ЕСТЬ NULL 
	|			ТОГДА Пользователи.ВариантОтображенияПоУмолчанию
	|		ИНАЧЕ ПользователиВНесохраненномВарианте.ВариантОтображения
	|	КОНЕЦ КАК ВариантОтображения
	|ИЗ
	|	Пользователи КАК Пользователи
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			НастройкиДоступности.Пользователь КАК Пользователь,
	|			КОЛИЧЕСТВО(НастройкиДоступности.Пользователь) КАК Количество,
	|			НастройкиДоступности.ВариантОтображения КАК ВариантОтображения
	|		ИЗ
	|			НастройкиДоступности КАК НастройкиДоступности
	|		
	|		СГРУППИРОВАТЬ ПО
	|			НастройкиДоступности.Пользователь,
	|			НастройкиДоступности.ВариантОтображения) КАК ПользователиВНесохраненномВарианте
	|		ПО Пользователи.Пользователь = ПользователиВНесохраненномВарианте.Пользователь
	|
	|УПОРЯДОЧИТЬ ПО
	|	Пользователи.Подразделение.Наименование,
	|	Пользователи.Пользователь.Наименование
	|ИТОГИ
	|	ВЫБОР
	|		КОГДА МАКСИМУМ(Доступность) = ИСТИНА
	|				И МИНИМУМ(Доступность) = ИСТИНА
	|			ТОГДА 1
	|		КОГДА МАКСИМУМ(Доступность) = ЛОЖЬ
	|				И МИНИМУМ(Доступность) = ЛОЖЬ
	|			ТОГДА 0
	|		КОГДА МАКСИМУМ(Доступность) = ИСТИНА
	|				И МИНИМУМ(Доступность) = ЛОЖЬ
	|			ТОГДА 2
	|	КОНЕЦ КАК ДоступностьПоПодразделению,
	|	СРЕДНЕЕ(ВЫБОР
	|			КОГДА Пользователь ЕСТЬ NULL 
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ТипСтроки
	|ПО
	|	Подразделение ИЕРАРХИЯ";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		НастройкиДоступностиЗначение = РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		ЗначениеВДанныеФормы(НастройкиДоступностиЗначение, НастройкиДоступности);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте 
Процедура ЗаполнитьСписокВыбранныеПользователи(ИдентификаторСтроки = Неопределено)
	
	Если ИдентификаторСтроки = Неопределено Тогда
		// Обработка всех
		КоллекцияПользователей = НастройкиДоступности.ПолучитьЭлементы();
		
	Иначе
		ТекущиеДанные = НастройкиДоступности.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		КоллекцияПользователей = ТекущиеДанные.ПолучитьЭлементы();
		
	КонецЕсли;
	
	Для каждого ЭлементКоллекцииПользователей Из КоллекцияПользователей Цикл
		
		ИдентификаторЭлемента = ЭлементКоллекцииПользователей.ПолучитьИдентификатор();
		
		Если ЭлементКоллекцииПользователей.ТипСтроки = 0 Тогда
			ЗаполнитьСписокВыбранныеПользователи(ИдентификаторЭлемента);
			
		ИначеЕсли ЭлементКоллекцииПользователей.ТипСтроки = 1 И ЭлементКоллекцииПользователей.Доступность Тогда
			НовыйВыбранныйПользователь = ВыбранныеПользователи.Добавить();
			НовыйВыбранныйПользователь.Пользователь = ЭлементКоллекцииПользователей.Пользователь;
			НовыйВыбранныйПользователь.Доступность = Истина;
			НовыйВыбранныйПользователь.Подразделение = ЭлементКоллекцииПользователей.Подразделение;
			НовыйВыбранныйПользователь.ВариантОтображения = ЭлементКоллекцииПользователей.ВариантОтображения;
			НовыйВыбранныйПользователь.ИдентификаторНастройкиДоступности = ИдентификаторЭлемента;
			
		КонецЕсли;
	КонецЦикла;
	
	ВыбранныеПользователи.Сортировать("Пользователь");
	
КонецПроцедуры

&НаКлиенте 
Процедура ОбновитьСписокВыбранныеПользователи()
	
	ВыбранныеПользователи.Очистить();
	
	ЗаполнитьСписокВыбранныеПользователи();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
Процедура УстановитьВидимостьГруппыПоиска(Элементы)
	
	ТолькоВыбранные = Элементы.ФормаПоказатьТолькоВыбранныхПользователей.Пометка;
	
	Элементы.ГруппаПоискаПоВыбранным.Видимость = ТолькоВыбранные;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
