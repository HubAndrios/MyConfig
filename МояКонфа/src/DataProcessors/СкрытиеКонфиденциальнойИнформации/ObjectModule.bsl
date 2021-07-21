#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем КартинкиОбъектов;
Перем ГенераторСлучайныхЧисел;
Перем ПрограммныйВызов;

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры скрытия конфиденциальной информации в интерактивном режиме.

Процедура ВыполнитьСкрытиеНаСервере(Параметры, АдресХранилища) Экспорт
	
	ГенераторСлучайныхЧисел = Новый ГенераторСлучайныхЧисел;
	ПрограммныйВызов = Ложь;
	
	ДеревоОбрабатываемыхОбъектов = Параметры.ДеревоОбрабатываемыхОбъектов;
	ПравилаОбработки = Параметры.ПравилаОбработки;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПравилаОбработки);
	
	Для Каждого ТипМетаданных Из ДеревоОбрабатываемыхОбъектов.Строки Цикл
		Если ТипМетаданных.Пометка = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ОбъектМетаданных Из ТипМетаданных.Строки Цикл
			Если ОбъектМетаданных.Пометка = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Если ОбъектМетаданных.Тип = "Константы" Тогда
				ОбработатьКонстанты(ОбъектМетаданных);
				Продолжить;
			КонецЕсли;
			
			Если СтрНайти(ОбъектМетаданных.Тип, "Регистры") > 0 Тогда
				ОбработатьРегистры(ОбъектМетаданных);
			Иначе
				ОбработатьОбъектМетаданных(ОбъектМетаданных);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ИмяРегистраВерсииОбъектов = "ВерсииОбъектов";
	Если Метаданные.НайтиПоПолномуИмени("РегистрСведений." + ИмяРегистраВерсииОбъектов) <> Неопределено Тогда
		НаборЗаписей = РегистрыСведений[ИмяРегистраВерсииОбъектов].СоздатьНаборЗаписей();
		НаборЗаписей.Записать();
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Истина, АдресХранилища);
	
КонецПроцедуры

Процедура ОбработатьРегистры(ОбъектМетаданных)
	
	Если ОбъектМетаданных.Тип = "РегистрыСведений" Тогда
		Коллекция = РегистрыСведений;
	ИначеЕсли ОбъектМетаданных.Тип = "РегистрыНакопления" Тогда
		Коллекция = РегистрыНакопления;
	ИначеЕсли ОбъектМетаданных.Тип = "РегистрыБухгалтерии" Тогда
		Коллекция = РегистрыБухгалтерии;
	ИначеЕсли ОбъектМетаданных.Тип = "РегистрыРасчета" Тогда
		Коллекция = РегистрыРасчета;
	КонецЕсли;
	
	Регистр = Коллекция[ОбъектМетаданных.Имя];
	НаборЗаписейРегистра = Регистр.СоздатьНаборЗаписей();
	МетаданныеРегистра   = НаборЗаписейРегистра.Метаданные();
	
	Если ОбъектМетаданных.Тип = "РегистрыСведений" Тогда
		РегистрПериодический = (МетаданныеРегистра.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический);
		РежимЗаписиНезависимый = (МетаданныеРегистра.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый);
		
		// Периодический и независимый режим записи.
		Если РегистрПериодический И РежимЗаписиНезависимый Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст =
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ИмяРегистраОбъект.Период КАК Период
				|ИЗ
				|	" + ОбъектМетаданных.ПолноеИмя + " КАК ИмяРегистраОбъект";
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				НаборЗаписейРегистра.Отбор.Период.Использование = Истина;
				НаборЗаписейРегистра.Отбор.Период.Значение      = Выборка.Период;
				ОбработатьНаборЗаписей(НаборЗаписейРегистра, ОбъектМетаданных);
			КонецЦикла;
			
		// Непериодический и режим записи независимый.
		ИначеЕсли РежимЗаписиНезависимый Тогда
			ПолноеИмяРегистра = МетаданныеРегистра.ПолноеИмя();
			КоличествоЗаписей = КоличествоЗаписейРегистра(ПолноеИмяРегистра);
			
			Если КоличествоЗаписей > 100000 Тогда
				ШаблонЗапроса =
					"ВЫБРАТЬ
					|	КОЛИЧЕСТВО(*) КАК Количество
					|ПОМЕСТИТЬ ВтВыборка
					|ИЗ
					|	%1 КАК Регистр
					|
					|СГРУППИРОВАТЬ ПО
					|	Регистр.%2
					|;
					|ВЫБРАТЬ
					|	КОЛИЧЕСТВО(*) КАК ВышеПорога,
					|	МАКСИМУМ(ВтВыборка.Количество) КАК Максимум,
					|	0 КАК Всего
					|ИЗ
					|	ВтВыборка КАК ВтВыборка
					|ГДЕ
					|	ВтВыборка.Количество > 100000
					|
					|ОБЪЕДИНИТЬ ВСЕ
					|
					|ВЫБРАТЬ
					|	0 КАК ВышеПорога,
					|	0 КАК Максимум,
					|	КОЛИЧЕСТВО(*) КАК Всего
					|ИЗ
					|	ВтВыборка КАК ВтВыборка";
				
				ОписанияИзмерений = Новый ТаблицаЗначений;
				ОписанияИзмерений.Колонки.Добавить("Измерение");
				ОписанияИзмерений.Колонки.Добавить("ВышеПорога");
				ОписанияИзмерений.Колонки.Добавить("Максимум");
				ОписанияИзмерений.Колонки.Добавить("Всего");
				ЕстьИзмеренияНижеПорога = Ложь;
				Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
					Запрос = Новый Запрос;
					Запрос.Текст = ШаблонЗапроса;
					Запрос.Текст = СтрЗаменить(Запрос.Текст, "%1", ПолноеИмяРегистра);
					Запрос.Текст = СтрЗаменить(Запрос.Текст, "%2", Измерение.Имя);
					Результат = Запрос.Выполнить().Выгрузить();
					
					Строка = ОписанияИзмерений.Добавить();
					Строка.Измерение  = Измерение.Имя;
					Строка.ВышеПорога = Результат[0].ВышеПорога;
					Строка.Максимум   = Результат[0].Максимум;
					Строка.Всего      = Результат[1].Всего;
					Если Строка.ВышеПорога = 0 Тогда
						ЕстьИзмеренияНижеПорога = Истина;
					КонецЕсли;
				КонецЦикла;
				
				Если ЕстьИзмеренияНижеПорога Тогда
					ОписанияИзмерений.Сортировать("ВышеПорога Возр, Всего Возр");
				Иначе
					ОписанияИзмерений.Сортировать("Максимум Возр");
				КонецЕсли;
				
				ОптимальноеИзмерение = ОписанияИзмерений[0].Измерение;
				Запрос = Новый Запрос;
				Запрос.Текст =
					"ВЫБРАТЬ
					|	Регистр.%2 КАК ЗначениеИзмерения,
					|	КОЛИЧЕСТВО(*) КАК Количество
					|ИЗ
					|	%1 КАК Регистр
					|
					|СГРУППИРОВАТЬ ПО
					|	Регистр.%2";
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "%1", ПолноеИмяРегистра);
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "%2", ОптимальноеИзмерение);
				
				Выборка = Запрос.Выполнить().Выбрать();
				
				Пока Выборка.Следующий() Цикл
					НаборЗаписейРегистра.Отбор[ОптимальноеИзмерение].Установить(Выборка.ЗначениеИзмерения);
					ОбработатьНаборЗаписей(НаборЗаписейРегистра, ОбъектМетаданных);
				КонецЦикла;
			Иначе
				ОбработатьНаборЗаписей(НаборЗаписейРегистра, ОбъектМетаданных);
			КонецЕсли;
		Иначе
			
			Запрос = Новый Запрос;
			Запрос.Текст =
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ИмяРегистраОбъект.Регистратор КАК Регистратор
				|ИЗ
				|	" + ОбъектМетаданных.ПолноеИмя + " КАК ИмяРегистраОбъект";
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				НаборЗаписейРегистра.Отбор.Регистратор.Установить(Выборка.Регистратор);
				ОбработатьНаборЗаписей(НаборЗаписейРегистра, ОбъектМетаданных);
			КонецЦикла;
			
		КонецЕсли;
		
	Иначе // Остальные регистры.
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ИмяРегистраОбъект.Регистратор КАК Регистратор
			|ИЗ
			|	" + ОбъектМетаданных.ПолноеИмя + " КАК ИмяРегистраОбъект";
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			НаборЗаписейРегистра.Отбор.Регистратор.Установить(Выборка.Регистратор);
			ОбработатьНаборЗаписей(НаборЗаписейРегистра, ОбъектМетаданных);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция КоличествоЗаписейРегистра(ПолноеИмя)
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	%1 КАК Регистр";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%1", ПолноеИмя);
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Количество;
	
КонецФункции

Процедура ОбработатьНаборЗаписей(НаборЗаписейРегистра, ОбъектМетаданных)
	
	НаборЗаписейРегистра.Прочитать();
	
	Обработано = Истина;
	ВыполнитьЗаписьОбъекта = Ложь;
	Для Каждого ЗаписьРегистра Из НаборЗаписейРегистра Цикл
		
		Для Каждого ГруппаСвойствОбъекта Из ОбъектМетаданных.Строки Цикл
			Если ГруппаСвойствОбъекта.Пометка = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого ОбрабатываемоеСвойство Из ГруппаСвойствОбъекта.Строки Цикл
				Если ОбрабатываемоеСвойство.Пометка = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				Если ОбъектМетаданных.Тип = "РегистрыБухгалтерии" И ОбрабатываемоеСвойство.Тип = "Ресурсы" Тогда
					ЗначениеДт = ЗаписьРегистра[ОбрабатываемоеСвойство.Имя + "Дт"];
					ЗначениеДт = ?(ТипЗнч(ЗначениеДт) = Тип("Число"), ЗначениеДт, 0);
					ЗначениеКт = ЗаписьРегистра[ОбрабатываемоеСвойство.Имя + "Кт"];
					ЗначениеКт = ?(ТипЗнч(ЗначениеКт) = Тип("Число"), ЗначениеКт, 0);
					ОбработатьСвойство(ЗначениеДт, ОбрабатываемоеСвойство, Обработано);
					ОбработатьСвойство(ЗначениеКт, ОбрабатываемоеСвойство, Обработано);
					Если Обработано Тогда
						ЗаписьРегистра[ОбрабатываемоеСвойство.Имя + "Дт"] = ЗначениеДт;
						ЗаписьРегистра[ОбрабатываемоеСвойство.Имя + "Кт"] = ЗначениеКт;
					КонецЕсли;
				Иначе
					Значение = ЗаписьРегистра[ОбрабатываемоеСвойство.Имя];
					ОбработатьСвойство(Значение, ОбрабатываемоеСвойство, Обработано);
					Если Обработано Тогда
						ЗаписьРегистра[ОбрабатываемоеСвойство.Имя] = Значение;
					КонецЕсли;
				КонецЕсли;
				
				ВыполнитьЗаписьОбъекта = ВыполнитьЗаписьОбъекта Или Обработано;
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если ВыполнитьЗаписьОбъекта Тогда
		ЗаписатьДанные(НаборЗаписейРегистра);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьОбъектМетаданных(ОбъектМетаданных)
	
	Ссылка = "";
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	ОбъектМетаданных.Ссылка
		|ИЗ
		|	" + ОбъектМетаданных.ПолноеИмя + " КАК ОбъектМетаданных
		|ГДЕ
		|	ОбъектМетаданных.Ссылка > &Ссылка
		|УПОРЯДОЧИТЬ ПО
		|	ОбъектМетаданных.Ссылка";
	Результат = Запрос.Выполнить().Выгрузить();
	
	Пока Истина Цикл
		
		Если Результат.Количество() = 0 Тогда
			Прервать;
		КонецЕсли;
		
		Для Каждого СтрокаРезультата Из Результат Цикл
			
			Обработано = Истина;
			ВыполнитьЗаписьОбъекта = Ложь;
			ОбрабатываемыйОбъект = СтрокаРезультата.Ссылка.ПолучитьОбъект();
			Для Каждого ГруппаСвойствОбъекта Из ОбъектМетаданных.Строки Цикл
				Если ГруппаСвойствОбъекта.Пометка = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				Для Каждого ОбрабатываемоеСвойство Из ГруппаСвойствОбъекта.Строки Цикл
					Если ОбрабатываемоеСвойство.Пометка = 0 Тогда
						Продолжить;
					КонецЕсли;
					
					Если ГруппаСвойствОбъекта.Тип = "ТабличнаяЧасть" Тогда
						ОбрабатываемыеСвойства = ОбрабатываемыйОбъект[ГруппаСвойствОбъекта.Имя];
						
						Для Каждого СтрокаТабличнойЧасти Из ОбрабатываемыеСвойства Цикл
							Значение = СтрокаТабличнойЧасти[ОбрабатываемоеСвойство.Имя];
							ОбработатьСвойство(Значение, ОбрабатываемоеСвойство, Обработано);
							Если Обработано Тогда
								СтрокаТабличнойЧасти[ОбрабатываемоеСвойство.Имя] = Значение;
							КонецЕсли;
							
							ВыполнитьЗаписьОбъекта = ВыполнитьЗаписьОбъекта Или Обработано;
						КонецЦикла;
						
					Иначе
						Значение = ОбрабатываемыйОбъект[ОбрабатываемоеСвойство.Имя];
						ОбработатьСвойство(Значение, ОбрабатываемоеСвойство, Обработано);
						Если Обработано Тогда
							ОбрабатываемыйОбъект[ОбрабатываемоеСвойство.Имя] = Значение;
						КонецЕсли;
						
						ВыполнитьЗаписьОбъекта = ВыполнитьЗаписьОбъекта Или Обработано;
					КонецЕсли;
					
				КонецЦикла;
			КонецЦикла;
			Если ВыполнитьЗаписьОбъекта Тогда
				ЗаписатьДанные(ОбрабатываемыйОбъект);
			КонецЕсли;
		КонецЦикла;
		
		Запрос.УстановитьПараметр("Ссылка", СтрокаРезультата.Ссылка);
		Результат = Запрос.Выполнить().Выгрузить();
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции формирования дерева метаданных.

Процедура ЗаполнитьДеревоОбрабатываемыхОбъектов(Параметры, АдресХранилища) Экспорт
	
	ОбрабатываемыеМетаданные     = Параметры.ОбрабатываемыеМетаданные;
	ДеревоОбрабатываемыхОбъектов = Параметры.ДеревоОбрабатываемыхОбъектов;
	СохраненныеНастройки         = Параметры.СохраненныеНастройки;
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	ДоступноИспользованиеРазделенныхДанных = ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
	
	АдминистраторСистемы = Пользователи.ЭтоПолноправныйПользователь(, Истина);
	
	ЗаполнитьКартинки();
	СкрываемыеОбъектыПоТипам = СкрываемыеОбъекты();
	
	// Заполнение дерева объектов.
	Для Каждого ТипМетаданных Из ОбрабатываемыеМетаданные Цикл
		СтрокаДерева = ДеревоОбрабатываемыхОбъектов.Строки.Добавить();
		СтрокаДерева.Имя           = ТипМетаданных.Ключ;
		СтрокаДерева.Представление = ТипМетаданных.Значение;
		СтрокаДерева.Картинка      = КартинкиОбъектов[ТипМетаданных.Ключ];
		СтрокаДерева.ПолноеИмя     = ЭлементИмениПоТипуМетаданных(СтрокаДерева.Имя);
		
		СкрываемыеОбъекты = СкрываемыеОбъектыПоТипам[ТипМетаданных.Ключ];
		Для Каждого ОбъектМетаданных Из Метаданные[ТипМетаданных.Ключ] Цикл
			Если РазделениеВключено Тогда
				ПолноеИмя = СтрокаДерева.ПолноеИмя + "." + ОбъектМетаданных.Имя;
				
				Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
					МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
					ЭтоРазделенныйОМД = МодульРаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных(ПолноеИмя);
				Иначе
					ЭтоРазделенныйОМД = Ложь;
				КонецЕсли;
				
				Если (ДоступноИспользованиеРазделенныхДанных И Не ЭтоРазделенныйОМД)
					Или (Не ДоступноИспользованиеРазделенныхДанных И ЭтоРазделенныйОМД) Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			Если СкрываемыеОбъекты <> Неопределено
				И СкрываемыеОбъекты.Найти(ОбъектМетаданных.Имя) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ДобавитьОбъекты(ОбъектМетаданных, СтрокаДерева, ТипМетаданных);
		КонецЦикла;
		
		СтрокаДерева.Строки.Сортировать("Представление Возр");
	КонецЦикла;
	
	УстановитьНастройки(СохраненныеНастройки, ДеревоОбрабатываемыхОбъектов);
	
	ПоместитьВоВременноеХранилище(ДеревоОбрабатываемыхОбъектов, АдресХранилища);
	
КонецПроцедуры

Функция СкрываемыеОбъекты()
	СкрываемыеРегистрыСведений = Новый Массив;
	СкрываемыеРегистрыСведений.Добавить("ВерсииПодсистем");
	СкрываемыеРегистрыСведений.Добавить("ВерсииПодсистемОбластейДанных");
	СкрываемыеРегистрыСведений.Добавить("ВерсииОбъектов");
	
	СкрываемыеСправочники = Новый Массив;
	СкрываемыеСправочники.Добавить("ИдентификаторыОбъектовМетаданных");
	СкрываемыеСправочники.Добавить("ИдентификаторыОбъектовРасширений");
	
	СкрываемыеКонстанты = Новый Массив;
	СкрываемыеКонстанты.Добавить("ОтложенноеОбновлениеЗавершеноУспешно");
	СкрываемыеКонстанты.Добавить("СведенияОБлокируемыхОбъектах");
	СкрываемыеКонстанты.Добавить("СведенияОбОбновленииИБ");
	
	СкрываемыеОбъектыПоТипам = Новый Соответствие;
	СкрываемыеОбъектыПоТипам.Вставить("РегистрыСведений", СкрываемыеРегистрыСведений);
	СкрываемыеОбъектыПоТипам.Вставить("Справочники", СкрываемыеСправочники);
	СкрываемыеОбъектыПоТипам.Вставить("Константы", СкрываемыеКонстанты);
	
	Возврат СкрываемыеОбъектыПоТипам;
КонецФункции

Процедура ДобавитьОбъекты(ОбъектМетаданных, СтрокаДерева, ТипМетаданных)
	
	Если ТипМетаданных.Ключ = "Константы" Тогда
		Если Не ДопустимыйТип(ОбъектМетаданных.Тип) Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаОбъект = СтрокаДерева.Строки.Добавить();
		СтрокаОбъект.Имя           = ОбъектМетаданных.Имя;
		СтрокаОбъект.Представление = ОбъектМетаданных.Синоним + ПредставлениеТиповСвойства(ОбъектМетаданных.Тип);
		СтрокаОбъект.Картинка      = КартинкиОбъектов[ТипМетаданных.Ключ];
		СтрокаОбъект.Тип           = ТипМетаданных.Ключ;
		СтрокаОбъект.ТипЗначения   = ОбъектМетаданных.Тип;
		СтрокаОбъект.ПолноеИмя     = СтрокаДерева.ПолноеИмя + "." + СтрокаОбъект.Имя;
		СтрокаОбъект.ПредставлениеПравилаОбработки = НСтр("ru = 'По умолчанию'");
		
	Иначе
		ЕстьОбрабатываемыеСвойства = Ложь;
		
		СтрокаОбъект = СтрокаДерева.Строки.Добавить();
		СтрокаОбъект.Имя           = ОбъектМетаданных.Имя;
		СтрокаОбъект.Представление = ОбъектМетаданных.Синоним;
		СтрокаОбъект.Картинка      = КартинкиОбъектов[ТипМетаданных.Ключ];
		СтрокаОбъект.Тип           = ТипМетаданных.Ключ;
		СтрокаОбъект.ПолноеИмя     = СтрокаДерева.ПолноеИмя + "." + СтрокаОбъект.Имя;
		
		ЭтоРегистр = (СтрНайти(ТипМетаданных.Ключ, "Регистры") > 0);
		// Добавление стандартных реквизитов.
		ДобавитьСвойства(ОбъектМетаданных, СтрокаОбъект, "СтандартныеРеквизиты", ЕстьОбрабатываемыеСвойства);
		// Добавление реквизитов.
		ДобавитьСвойства(ОбъектМетаданных, СтрокаОбъект, "Реквизиты", ЕстьОбрабатываемыеСвойства);
		
		Если Не ЭтоРегистр Тогда
			Для Каждого ТабличнаяЧасть Из ОбъектМетаданных.ТабличныеЧасти Цикл
				ДобавитьСвойства(ТабличнаяЧасть, СтрокаОбъект, "ТабличнаяЧасть", ЕстьОбрабатываемыеСвойства);
			КонецЦикла;
		Иначе
			ДобавитьСвойства(ОбъектМетаданных, СтрокаОбъект, "Ресурсы", ЕстьОбрабатываемыеСвойства);
			ДобавитьСвойства(ОбъектМетаданных, СтрокаОбъект, "Измерения", ЕстьОбрабатываемыеСвойства);
		КонецЕсли;
		
		Если ТипМетаданных.Ключ = "ПланыСчетов" Тогда
			ДобавитьСвойства(ОбъектМетаданных, СтрокаОбъект, "ПризнакиУчета", ЕстьОбрабатываемыеСвойства);
		КонецЕсли;
		
		Если Не ЕстьОбрабатываемыеСвойства Тогда
			СтрокаДерева.Строки.Удалить(СтрокаОбъект); // У объекта нет реквизитов, которые можно обработать.
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьСвойства(ОбъектМетаданных, СтрокаДерева, Тип, ЕстьОбрабатываемыеСвойства)
	
	Если Тип = "СтандартныеРеквизиты" Тогда
		Имя = Тип;
		Синоним = НСтр("ru = 'Стандартные реквизиты'");
		Коллекция = ОбъектМетаданных[Тип];
	ИначеЕсли Тип = "ТабличнаяЧасть" Тогда
		Имя   = ОбъектМетаданных.Имя;
		Синоним = ОбъектМетаданных.Синоним;
		Коллекция = ОбъектМетаданных.Реквизиты;
	Иначе
		Имя = Тип;
		Если Тип = "ПризнакиУчета" Тогда
			Синоним = НСтр("ru = 'Признаки учета'");
		Иначе
			Синоним = Тип;
		КонецЕсли;
		Коллекция = ОбъектМетаданных[Тип];
	КонецЕсли;
	
	СтрокаЭлементовДобавлена = Ложь;
	Для Каждого ЭлементКоллекции Из Коллекция Цикл
		
		Если Тип = "СтандартныеРеквизиты"
			И ЭлементКоллекции.Имя <> "Наименование" Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ДопустимыйТип(ЭлементКоллекции.Тип) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не СтрокаЭлементовДобавлена Тогда
			СтрокаЭлементов = СтрокаДерева.Строки.Добавить();
			СтрокаЭлементов.Имя           = Имя;
			СтрокаЭлементов.Представление = Синоним;
			СтрокаЭлементов.Картинка      = КартинкиОбъектов[Тип];
			СтрокаЭлементов.ПолноеИмя     = СтрокаДерева.ПолноеИмя + "." + Имя;
			СтрокаЭлементов.Тип = ?(Тип = "ТабличнаяЧасть", Тип, "");
			СтрокаЭлементовДобавлена = Истина;
		КонецЕсли;
		
		ТипОбъекта = ?(Тип = "ТабличнаяЧасть", "РеквизитТабличнойЧасти", Тип);
		Если ТипОбъекта = "Ресурсы" И СтрокаДерева.Тип = "РегистрыБухгалтерии" И ЭлементКоллекции.Балансовый Тогда
			ТипОбъекта = ТипОбъекта + "Балансовый";
		КонецЕсли;
		
		ПредставлениеСвойства = ?(ЭлементКоллекции.Синоним = "", ЭлементКоллекции.Имя, ЭлементКоллекции.Синоним);
		
		СтрокаСвойство = СтрокаЭлементов.Строки.Добавить();
		СтрокаСвойство.Имя           = ЭлементКоллекции.Имя;
		СтрокаСвойство.Представление = ПредставлениеСвойства + ПредставлениеТиповСвойства(ЭлементКоллекции.Тип);
		СтрокаСвойство.Картинка      = КартинкиОбъектов[ТипОбъекта];
		СтрокаСвойство.Тип           = ТипОбъекта;
		СтрокаСвойство.ТипЗначения   = ЭлементКоллекции.Тип;
		СтрокаСвойство.ПолноеИмя     = СтрокаЭлементов.ПолноеИмя + "." + ЭлементКоллекции.Имя;
		СтрокаСвойство.ПредставлениеПравилаОбработки = НСтр("ru = 'По умолчанию'");
		
		ЕстьОбрабатываемыеСвойства = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПредставлениеТиповСвойства(ТипЗначения)
	МассивТипов = ТипЗначения.Типы();
	Представление = "";
	Для Каждого Тип Из МассивТипов Цикл
		Если Представление = "" Тогда
			Представление = Строка(Тип);
		Иначе
			Представление = Представление + ", " + Строка(Тип);
		КонецЕсли;
	КонецЦикла;
	
	Представление = " (" + Представление + ")";
	
	Возврат Представление;
КонецФункции

Функция ДопустимыйТип(ТипЗначения)
	
	Если ТипЗначения.СодержитТип(Тип("Строка"))
		Или ТипЗначения.СодержитТип(Тип("Булево"))
		Или ТипЗначения.СодержитТип(Тип("Число"))
		Или ТипЗначения.СодержитТип(Тип("Дата"))
		Или ТипЗначения.СодержитТип(Тип("ХранилищеЗначения")) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция ЭлементИмениПоТипуМетаданных(ТипМетаданных)
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("Константы", "Константа");
	Соответствие.Вставить("Справочники", "Справочник");
	Соответствие.Вставить("Документы", "Документ");
	Соответствие.Вставить("ПланыВидовХарактеристик", "ПланВидовХарактеристик");
	Соответствие.Вставить("ПланыСчетов", "ПланСчетов");
	Соответствие.Вставить("ПланыВидовРасчета", "ПланВидовРасчета");
	Соответствие.Вставить("РегистрыСведений", "РегистрСведений");
	Соответствие.Вставить("РегистрыНакопления", "РегистрНакопления");
	Соответствие.Вставить("РегистрыБухгалтерии", "РегистрБухгалтерии");
	Соответствие.Вставить("РегистрыРасчета", "РегистрРасчета");
	Соответствие.Вставить("БизнесПроцессы", "БизнесПроцесс");
	Соответствие.Вставить("Задачи", "Задача");
	
	Возврат Соответствие[ТипМетаданных];
	
КонецФункции

Процедура УстановитьНастройки(МассивНастроек, ДеревоОбрабатываемыхОбъектов, ВключаяПерсональные = Истина) Экспорт
	
	Если МассивНастроек.Количество() = 1 Тогда
		СохраненныеНастройки = ЗначениеИзСтрокиXML(МассивНастроек[0]);
	Иначе
		СохраненныеНастройки = Неопределено;
		ОбъединитьТаблицы(СохраненныеНастройки, МассивНастроек);
	КонецЕсли;
	
	Если СохраненныеНастройки <> Неопределено Тогда
		Для Каждого СохраненнаяНастройка Из СохраненныеНастройки Цикл
			НайденнаяСтрока = ДеревоОбрабатываемыхОбъектов.Строки.Найти(СохраненнаяНастройка.ПолноеИмя, "ПолноеИмя", Истина);
			Если НайденнаяСтрока = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(НайденнаяСтрока, СохраненнаяНастройка);
		КонецЦикла;
	КонецЕсли;
	
	// Отметка сведений о персональных данных.
	Если ВключаяПерсональные И Метаданные.ОбщиеМодули.Найти("ЗащитаПерсональныхДанныхПереопределяемый") <> Неопределено Тогда
		МодульЗащитаПерсональныхДанных = Вычислить("ЗащитаПерсональныхДанныхПереопределяемый");
		
		// Таблица сведений о персональных данных.
		ТаблицаСведений = Новый ТаблицаЗначений;
		ТаблицаСведений.Колонки.Добавить("Объект",          Новый ОписаниеТипов("Строка"));
		ТаблицаСведений.Колонки.Добавить("ПоляРегистрации", Новый ОписаниеТипов("Строка"));
		ТаблицаСведений.Колонки.Добавить("ПоляДоступа",     Новый ОписаниеТипов("Строка"));
		ТаблицаСведений.Колонки.Добавить("ОбластьДанных",   Новый ОписаниеТипов("Строка"));
		
		МодульЗащитаПерсональныхДанных.ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений);
		
		Для Каждого СтрокаСведения Из ТаблицаСведений Цикл
			СтрокаОбъекта = ДеревоОбрабатываемыхОбъектов.Строки.Найти(СтрокаСведения.Объект, "ПолноеИмя", Истина);
			Если СтрокаОбъекта = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ПоляДоступа = СтрокаСведения.ПоляДоступа;
			МассивПолейДоступа = СтрРазделить(ПоляДоступа, ",");
			
			Для Каждого ПолеДоступа Из МассивПолейДоступа Цикл
				ПолеДоступа = СокрЛП(ПолеДоступа);
				СтрокаПолеДоступа = СтрокаОбъекта.Строки.Найти(ПолеДоступа, "Имя", Истина);
				Если СтрокаПолеДоступа <> Неопределено Тогда
					СтрокаПолеДоступа.Пометка = 1;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого ОбрабатываемыйОбъект Из ДеревоОбрабатываемыхОбъектов.Строки Цикл
		ОбновитьФлажкиДерева(ОбрабатываемыйОбъект);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбъединитьТаблицы(ТаблицаПриемник, МассивНастроек)
	
	Для Каждого СтрокаНастроек Из МассивНастроек Цикл
		ТаблицаНастроек = ЗначениеИзСтрокиXML(СтрокаНастроек);
		Если ТаблицаПриемник = Неопределено Тогда
			ТаблицаПриемник = ТаблицаНастроек.Скопировать();
		Иначе
			Для Каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
				Если ТаблицаПриемник.Найти(СтрокаТаблицы.ПолноеИмя, "ПолноеИмя") = Неопределено Тогда
					ЗаполнитьЗначенияСвойств(ТаблицаПриемник.Добавить(), СтрокаТаблицы);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьФлажкиДерева(Родитель)
	
	ДочерниеЭлементы = Родитель.Строки;
	ПометкаРодителя = Неопределено;
	
	Для Каждого СтрокаДерева Из ДочерниеЭлементы Цикл
		Если СтрокаДерева.Строки.Количество() > 0 Тогда
			ОбновитьФлажкиДерева(СтрокаДерева);
		Иначе
			Возврат;
		КонецЕсли;
		
		ЕстьОтмеченные   = Ложь;
		ЕстьНеОтмеченные = Ложь;
		ЕстьПолуотмеченные = Ложь;
		Для Каждого Элемент Из СтрокаДерева.Строки Цикл
			ЕстьОтмеченные = ЕстьОтмеченные Или (Элемент.Пометка = 1);
			ЕстьНеОтмеченные = ЕстьНеОтмеченные Или (Элемент.Пометка = 0);
			ЕстьПолуотмеченные = ЕстьПолуотмеченные Или (Элемент.Пометка = 2);
		КонецЦикла;
		
		Если ЕстьНеОтмеченные И Не ЕстьОтмеченные И Не ЕстьПолуотмеченные Тогда
			СтрокаДерева.Пометка = 0;
			Если ПометкаРодителя = 1 Тогда
				ПометкаРодителя = 2;
			КонецЕсли;
		ИначеЕсли ЕстьОтмеченные И Не ЕстьНеОтмеченные И Не ЕстьПолуотмеченные Тогда
			СтрокаДерева.Пометка = 1;
			Если ПометкаРодителя = 0 Тогда
				ПометкаРодителя = 2;
			КонецЕсли;
		Иначе
			СтрокаДерева.Пометка = 2;
			ПометкаРодителя = 2;
		КонецЕсли;
		
		Если ПометкаРодителя = Неопределено Тогда
			ПометкаРодителя = СтрокаДерева.Пометка;
		КонецЕсли;
	КонецЦикла;
	
	Родитель.Пометка = ПометкаРодителя;
	
КонецПроцедуры

Процедура ЗаполнитьКартинки()
	
	КартинкиОбъектов = Новый Соответствие;
	КартинкиОбъектов.Вставить("Константы", БиблиотекаКартинок.Константа);
	КартинкиОбъектов.Вставить("Справочники", БиблиотекаКартинок.Справочник);
	КартинкиОбъектов.Вставить("Документы", БиблиотекаКартинок.Документ);
	КартинкиОбъектов.Вставить("ПланыВидовХарактеристик", БиблиотекаКартинок.ПланВидовХарактеристик);
	КартинкиОбъектов.Вставить("ПланыСчетов", БиблиотекаКартинок.ПланСчетов);
	КартинкиОбъектов.Вставить("ПланыВидовРасчета", БиблиотекаКартинок.ПланВидовРасчета);
	КартинкиОбъектов.Вставить("РегистрыСведений", БиблиотекаКартинок.РегистрСведений);
	КартинкиОбъектов.Вставить("РегистрыНакопления", БиблиотекаКартинок.РегистрНакопления);
	КартинкиОбъектов.Вставить("РегистрыБухгалтерии", БиблиотекаКартинок.РегистрБухгалтерии);
	КартинкиОбъектов.Вставить("РегистрыРасчета", БиблиотекаКартинок.РегистрРасчета);
	КартинкиОбъектов.Вставить("БизнесПроцессы", БиблиотекаКартинок.БизнесПроцесс);
	КартинкиОбъектов.Вставить("Задачи", БиблиотекаКартинок.Задача);
	КартинкиОбъектов.Вставить("Реквизиты", БиблиотекаКартинок.Реквизит);
	КартинкиОбъектов.Вставить("СтандартныеРеквизиты", БиблиотекаКартинок.Реквизит);
	КартинкиОбъектов.Вставить("ТабличнаяЧасть", БиблиотекаКартинок.ВложеннаяТаблица);
	КартинкиОбъектов.Вставить("Ресурсы", БиблиотекаКартинок.Ресурс);
	КартинкиОбъектов.Вставить("Измерения", БиблиотекаКартинок.Измерение);
	
КонецПроцедуры

Функция ЗначениеИзСтрокиXML(СтрокаXML)
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	
	Возврат СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции.

Процедура ОбработатьКонстанты(ОбъектМетаданных)
	
	ЗначениеКонстанты = Константы[ОбъектМетаданных.Имя].Получить();
	МенеджерКонстанты = Константы[ОбъектМетаданных.Имя].СоздатьМенеджерЗначения();
	Обработано = Истина;
	ОбработатьСвойство(ЗначениеКонстанты, ОбъектМетаданных, Обработано);
	
	Если Обработано Тогда
		МенеджерКонстанты.Значение = ЗначениеКонстанты;
		ЗаписатьДанные(МенеджерКонстанты);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьСвойство(Свойство, ПараметрыСвойства, Обработано)
	
	Обработано = Истина;
	ТипСвойства = ТипЗнч(Свойство);
	Если ТипСвойства = Тип("Строка") Тогда
		ОбработатьСтроку(Свойство, ПараметрыСвойства, Обработано);
	ИначеЕсли ТипСвойства = Тип("Число") Тогда
		ОбработатьЧисло(Свойство, ПараметрыСвойства, Обработано);
	ИначеЕсли ТипСвойства = Тип("Булево") Тогда
		ОбработатьБулево(Свойство, ПараметрыСвойства, Обработано);
	ИначеЕсли ТипСвойства = Тип("Дата") Тогда
		ОбработатьДату(Свойство, ПараметрыСвойства, Обработано);
	ИначеЕсли ТипСвойства = Тип("ХранилищеЗначения") Тогда
		ОбработатьХранилищеЗначений(Свойство, ПараметрыСвойства, Обработано);
	Иначе
		Обработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьСтроку(Свойство, ПараметрыСвойства, Обработано)
	
	Индекс = ГенераторСлучайныхЧисел.СлучайноеЧисло(100000, 999999);
	Индекс = Строка(Индекс);
	Индекс = СтрЗаменить(Индекс, Символы.НПП, "");
	
	ПравилоОбработки = ПравилоСтрока;
	Если ПараметрыСвойства.ПравилоОбработки.Количество() > 0 Тогда
		ПараметрыОбработкиСтроки = ПараметрыСвойства.ПравилоОбработки.НайтиПоЗначению("Строка");
		Если ПараметрыОбработкиСтроки <> Неопределено Тогда
			ПравилоОбработки = ПараметрыОбработкиСтроки.Представление;
		КонецЕсли;
	КонецЕсли;
	
	Если ПрограммныйВызов
		И ПараметрыСвойства.Имя = "Наименование" Тогда
		ПравилоОбработки = "ИмяОбъектаИндекс"
	КонецЕсли;
	
	Если ПравилоОбработки = "Очистить" Тогда
		Свойство = "";
	ИначеЕсли ПравилоОбработки = "СлучайноеЗначение" Тогда
		СлучайнаяСтрока = Новый УникальныйИдентификатор;
		Свойство = СтрЗаменить(СлучайнаяСтрока, "-", "");
	ИначеЕсли ПравилоОбработки = "ИмяПоляИндекс" Тогда
		Свойство = ПараметрыСвойства.Имя + Индекс;
	ИначеЕсли ПравилоОбработки = "ИмяОбъектаИндекс" Тогда
		ИмяОбъекта = СтрРазделить(ПараметрыСвойства.ПолноеИмя, ".")[1];
		Свойство = ИмяОбъекта + Индекс;
	Иначе
		Обработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьЧисло(Свойство, ПараметрыСвойства, Обработано)
	
	ПравилоОбработки = ПравилоЧисло;
	Если ПараметрыСвойства.ПравилоОбработки.Количество() > 0 Тогда
		ПараметрыОбработкиЧисел = ПараметрыСвойства.ПравилоОбработки.НайтиПоЗначению("Число");
		Если ПараметрыОбработкиЧисел <> Неопределено Тогда
			ПравилоОбработки = ПараметрыОбработкиЧисел.Представление;
		КонецЕсли;
	КонецЕсли;
	
	Если ПравилоОбработки = "Очистить" Тогда
		Свойство = 0;
	ИначеЕсли СтрНайти(ПравилоОбработки, "Умножить") > 0 Тогда
		ПравилоМассив = СтрРазделить(ПравилоОбработки, ";");
		Свойство = Свойство * Число(ПравилоМассив[1]);
	ИначеЕсли СтрНайти(ПравилоОбработки, "Разделить") > 0 Тогда
		ПравилоМассив = СтрРазделить(ПравилоОбработки, ";");
		Свойство = Свойство / Число(ПравилоМассив[1]);
	ИначеЕсли СтрНайти(ПравилоОбработки, "Прибавить") > 0 Тогда
		ПравилоМассив = СтрРазделить(ПравилоОбработки, ";");
		Свойство = Свойство + Число(ПравилоМассив[1]);
	ИначеЕсли СтрНайти(ПравилоОбработки, "Вычесть") > 0 Тогда
		ПравилоМассив = СтрРазделить(ПравилоОбработки, ";");
		Свойство = Свойство - Число(ПравилоМассив[1]);
	ИначеЕсли СтрНайти(ПравилоОбработки, "СлучайноеЗначение") > 0 Тогда
		Свойство = ГенераторСлучайныхЧисел.СлучайноеЧисло(1, 1000000);
	Иначе
		Обработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьБулево(Свойство, ПараметрыСвойства, Обработано)
	
	ПравилоОбработки = ПравилоБулево;
	Если ПараметрыСвойства.ПравилоОбработки.Количество() > 0 Тогда
		ПараметрыОбработкиБулево = ПараметрыСвойства.ПравилоОбработки.НайтиПоЗначению("Булево");
		Если ПараметрыОбработкиБулево <> Неопределено Тогда
			ПравилоОбработки = ПараметрыОбработкиБулево.Представление;
		КонецЕсли;
	КонецЕсли;
	
	Если ПравилоОбработки = "Инвертировать" Тогда
		Свойство = Не Свойство;
	Иначе
		Обработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьДату(Свойство, ПараметрыСвойства, Обработано)
	
	ПравилоОбработки = ПравилоДата;
	Если ПараметрыСвойства.ПравилоОбработки.Количество() > 0 Тогда
		ПараметрыОбработкиДат = ПараметрыСвойства.ПравилоОбработки.НайтиПоЗначению("Булево");
		Если ПараметрыОбработкиДат <> Неопределено Тогда
			ПравилоОбработки = ПараметрыОбработкиДат.Представление;
		КонецЕсли;
	КонецЕсли;
	
	Если ПрограммныйВызов = Истина Тогда
		Свойство = Неопределено;
		Возврат;
	КонецЕсли;
	
	СуткиВСекундах = 60 * 60 * 24;
	Если СтрНайти(ПравилоОбработки, "Прибавить") > 0 Тогда
		ПравилоМассив = СтрРазделить(ПравилоОбработки, ";");
		Свойство = Свойство + СуткиВСекундах * Число(ПравилоМассив[1]);
	ИначеЕсли СтрНайти(ПравилоОбработки, "Вычесть") > 0 Тогда
		ПравилоМассив = СтрРазделить(ПравилоОбработки, ";");
		Свойство = Свойство - СуткиВСекундах * Число(ПравилоМассив[1]);
	ИначеЕсли СтрНайти(ПравилоОбработки, "СлучайноеЗначение") > 0 Тогда
		Разница = ГенераторСлучайныхЧисел.СлучайноеЧисло(1, 730);
		Свойство = Свойство - СуткиВСекундах * Разница;
	Иначе
		Обработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьХранилищеЗначений(Свойство, ПараметрыСвойства, Обработано)
	
	ПравилоОбработки = ПравилоХранилищеЗначений;
	Если ПараметрыСвойства.ПравилоОбработки.Количество() > 0 Тогда
		ПараметрыОбработкиХранилищаЗначений = ПараметрыСвойства.ПравилоОбработки.НайтиПоЗначению("Булево");
		Если ПараметрыОбработкиХранилищаЗначений <> Неопределено Тогда
			ПравилоОбработки = ПараметрыОбработкиХранилищаЗначений.Представление;
		КонецЕсли;
	КонецЕсли;
	
	Если ПравилоОбработки = "Очистить" Тогда
		Свойство = Неопределено;
	Иначе
		Обработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьДанные(Знач Данные, Знач РегистрироватьНаУзлахПлановОбмена = Ложь, 
	Знач ВключитьБизнесЛогику = Ложь) Экспорт
	
	Данные.ОбменДанными.Загрузка = Не ВключитьБизнесЛогику;
	Если Не РегистрироватьНаУзлахПлановОбмена Тогда
		Данные.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
		Данные.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	КонецЕсли;
	
	Данные.Записать();
	
КонецПроцедуры

Функция ПравилаОбработкиПоУмолчанию() Экспорт
	
	Правила = Новый Структура;
	Правила.Вставить("Строка", "СлучайноеЗначение");
	Правила.Вставить("Дата", "СлучайноеЗначение");
	Правила.Вставить("Булево", "НеИзменять");
	Правила.Вставить("ХранилищаЗначений", "Очистить");
	Правила.Вставить("Числа", "СлучайноеЗначение");
	
	Возврат Правила;
	
КонецФункции

#КонецОбласти

#КонецЕсли