#Область ПрограммныйИнтерфейс

// Возвращает текст запроса, отбирающего контакты (участников) предмета взаимодействия.
// Используется, если в конфигурации определен хотя бы один предмет взаимодействий.
//
// Параметры:
//  ПомещатьВоВременнуюТаблицу - Булево - признак того, что результат выполнения запроса 
//                                        необходимо поместить во временную таблицу.
//  ИмяТаблицы                 - Строка - имя таблицы предмета взаимодействий, в котором будет выполнен поиск.
//  Объединить                 - Булево - если Истина, то в запрос необходимо добавить конструкцию ОБЪЕДЕНИТЬ.
//
// Возвращаемое значение:
//  Строка - текст запроса 
Функция ТекстЗапросаПоискКонтактовПоПредмету(
	ПомещатьВоВременнуюТаблицу,
	ИмяТаблицы,
	Объединить = Ложь) Экспорт
	
	ШаблонВыбрать = ?(Объединить,"ВЫБРАТЬ РАЗЛИЧНЫЕ","ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ");
	
	ТекстВременнаяТаблица = ?(НЕ ПомещатьВоВременнуюТаблицу, "", "
		|ПОМЕСТИТЬ табКонтакты");
		
	ТекстЗапроса =" 
	|%ШаблонВыбрать%
	|	ТаблицаПартнерыИКонтактныеЛица.Партнер КАК Контакт" + ТекстВременнаяТаблица + "
	|ИЗ
	|	" + ИмяТаблицы + ".ПартнерыИКонтактныеЛица КАК ТаблицаПартнерыИКонтактныеЛица
	|ГДЕ
	|	ТаблицаПартнерыИКонтактныеЛица.Ссылка = &Предмет
	|	И (НЕ ТаблицаПартнерыИКонтактныеЛица.Партнер ЕСТЬ NULL )
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаПартнерыИКонтактныеЛица.КонтактноеЛицо
	|ИЗ
	|	" + ИмяТаблицы + ".ПартнерыИКонтактныеЛица КАК ТаблицаПартнерыИКонтактныеЛица
	|ГДЕ
	|	ТаблицаПартнерыИКонтактныеЛица.Ссылка = &Предмет
	|	И (НЕ ТаблицаПартнерыИКонтактныеЛица.КонтактноеЛицо ЕСТЬ NULL )";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%ШаблонВыбрать%",ШаблонВыбрать);
	
	Если Объединить Тогда
		
		ТекстЗапроса = "
		| ОБЪЕДИНИТЬ
		|" + ТекстЗапроса;
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Возможность переопределить владельца присоединенных файлов для письма.
// Такая необходимость может возникнуть например при массовых рассылках. В этом случае имеет смысл 
// хранить одни и те же присоединенные файлы в одном месте, а не тиражировать их на все письма рассылки.
//
// Параметры:
//  Письмо  - ДокументСсылка, ДокументОбъект - документ электронное письмо для которого необходимо получить вложения.
//
// Возвращаемое значение:
//  Структура,Неопределено  - Неопределено, если присоединенные файлы хранятся при письме.
//                            Структура, если присоединенные файлы хранятся в другом объекте. Формат структуры:
//                              - Владелец - владелец присоединенных файлов,
//                              - ИмяСправочникаПрисоединенныеФайлы - имя объекта метаданных присоединенных файлов.
//
Функция ДанныеОбъектаМетаданныхПрисоединенныхФайловПисьма(Письмо) Экспорт
	
	Если ВзаимодействияКлиентСервер.ЯвляетсяВзаимодействием(Письмо) Тогда
		РеквизитыПисьма = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Письмо, "ВзаимодействиеОснование");
		Если ТипЗнч(РеквизитыПисьма.ВзаимодействиеОснование) = Тип("ДокументСсылка.РассылкаКлиентам") Тогда
			Возврат Новый Структура ("Владелец, ИмяСправочникаПрисоединенныеФайлы",
			                         РеквизитыПисьма.ВзаимодействиеОснование, "РассылкаКлиентамПрисоединенныеФайлы"); 
		КонецЕсли;
	ИначеЕсли ТипЗнч(Письмо) = Тип("СправочникСсылка.ШаблоныСообщений") Тогда
		Возврат Новый Структура("Владелец, ИмяСправочникаПрисоединенныеФайлы",
			                         Письмо, "ШаблоныСообщенийПрисоединенныеФайлы");
	ИначеЕсли ТипЗнч(Письмо) = Тип("ДокументОбъект.ЭлектронноеПисьмоИсходящее")
		      И ТипЗнч(Письмо.ВзаимодействиеОснование) = Тип("ДокументСсылка.РассылкаКлиентам") Тогда
		Возврат Новый Структура("Владелец, ИмяСправочникаПрисоединенныеФайлы",
		                         Письмо.ВзаимодействиеОснование, "РассылкаКлиентамПрисоединенныеФайлы");
	Иначе
		Если ТипЗнч(Письмо) =Тип("ДокументСсылка.РассылкаКлиентам") Тогда
			Возврат Новый Структура("Владелец, ИмяСправочникаПрисоединенныеФайлы",
			                         Письмо, "РассылкаКлиентамПрисоединенныеФайлы"); 
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Вызывается из модулей объектов подсистемы Взаимодействия для
// возможности настройки логики ограничения в прикладном решении.
//
// Пример заполнения наборов значений доступа см. в комментарии
// к процедуре УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
//
// Параметры:
//  Объект - ДокументОбъект.Встреча,
//           ДокументОбъект.ЗапланированноеВзаимодействие,
//           ДокументОбъект.СообщениеSMS,
//           ДокументОбъект.ТелефонныйЗвонок,
//           ДокументОбъект.ЭлектронноеПисьмоВходящее,
//           ДокументОбъект.ЭлектронноеПисьмоИсходящее - объект, для которого нужно заполнить наборы.
//  
//  Таблица - ТаблицаЗначений - возвращаемая функцией УправлениеДоступом.ТаблицаНаборыЗначенийДоступа.
//
Процедура ПриЗаполненииНаборовЗначенийДоступа(Объект, Таблица) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Логика ограничения следующая: объект доступен если доступен  "Автор" или "Учетная запись" или "Ответственный".
	// Логика "ИЛИ" реализуется через различные номера наборов.
	
	// Ограничение по "Ответственный".
	НомерНабора = 1;
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.НомерНабора     = НомерНабора;
	СтрокаТаб.ЗначениеДоступа = Объект.Ответственный;

	// Ограничение по "Автор".
	Если ТипЗнч(Объект) <> Тип("ДокументОбъект.ЭлектронноеПисьмоВходящее") Тогда
		НомерНабора = НомерНабора + 1;
		
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.НомерНабора     = НомерНабора;
		СтрокаТаб.ЗначениеДоступа = Объект.Автор;
	КонецЕсли;

	// Ограничение по "УчетныеЗаписиЭлектроннойПочты".
	Если ТипЗнч(Объект) = Тип("ДокументОбъект.ЭлектронноеПисьмоВходящее") ИЛИ 
			ТипЗнч(Объект) = Тип("ДокументОбъект.ЭлектронноеПисьмоВходящее") Тогда
		НомерНабора = НомерНабора + 1;
			
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.НомерНабора     = НомерНабора;
		СтрокаТаб.ЗначениеДоступа = Объект.УчетнаяЗапись;			
	КонецЕсли;
		
	Если ТипЗнч(Объект) = Тип("ДокументОбъект.ТелефонныйЗвонок") Тогда
		Если ЗначениеЗаполнено(Объект.АбонентКонтакт) Тогда

			Если ТипЗнч(Объект.АбонентКонтакт) = Тип("СправочникСсылка.Партнеры") Тогда

				НомерНабора = НомерНабора + 1;

				СтрокаТаб = Таблица.Добавить();
				СтрокаТаб.НомерНабора     = НомерНабора;
				СтрокаТаб.ЗначениеДоступа = Объект.АбонентКонтакт;

			ИначеЕсли ТипЗнч(Объект.АбонентКонтакт) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда

				Запрос = Новый Запрос(
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	КонтактныеЛицаПартнеров.Владелец КАК Партнер
				|ИЗ
				|	Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
				|ГДЕ
				|	КонтактныеЛицаПартнеров.Ссылка =&АбонентКонтакт
				|");
				Запрос.УстановитьПараметр("АбонентКонтакт", Объект.АбонентКонтакт);
				Выборка = Запрос.Выполнить().Выбрать();

				Пока Выборка.Следующий() Цикл

					НомерНабора = НомерНабора + 1;

					СтрокаТаб = Таблица.Добавить();
					СтрокаТаб.НомерНабора     = НомерНабора;
					СтрокаТаб.ЗначениеДоступа = Выборка.Партнер;

				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ЭлектронноеПисьмоВходящее") Тогда
		МассивКонтактныхЛиц = Новый Массив;

		МассивТабличныхЧастей = Новый Массив;
		МассивТабличныхЧастей.Добавить("ПолучателиПисьма");
		МассивТабличныхЧастей.Добавить("ПолучателиКопий");
		МассивТабличныхЧастей.Добавить("ПолучателиОтвета");
		Для Каждого ТабличнаяЧасть Из МассивТабличныхЧастей Цикл

			Для Каждого СтрокаТаблицы Из Объект[ТабличнаяЧасть] Цикл

				Если Не ЗначениеЗаполнено(СтрокаТаблицы.Контакт) Тогда
					Продолжить;
				КонецЕсли;

				Если ТипЗнч(СтрокаТаблицы.Контакт) = Тип("СправочникСсылка.Партнеры") Тогда

					НомерНабора = НомерНабора + 1;

					СтрокаТаб = Таблица.Добавить();
					СтрокаТаб.НомерНабора     = НомерНабора;
					СтрокаТаб.ЗначениеДоступа = СтрокаТаблицы.Контакт;

				ИначеЕсли ТипЗнч(СтрокаТаблицы.Контакт) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда

					МассивКонтактныхЛиц.Добавить(СтрокаТаблицы.Контакт);

				КонецЕсли;

			КонецЦикла;
		КонецЦикла;

		Если МассивКонтактныхЛиц.Количество() > 0 Тогда

			Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	КонтактныеЛицаПартнеров.Владелец КАК Партнер
			|ИЗ
			|	Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
			|ГДЕ
			|	КонтактныеЛицаПартнеров.Ссылка В(&МассивКонтактныхЛиц)
			|");
			Запрос.УстановитьПараметр("МассивКонтактныхЛиц", МассивКонтактныхЛиц);
			Выборка = Запрос.Выполнить().Выбрать();

			Пока Выборка.Следующий() Цикл

				НомерНабора = НомерНабора + 1;

				СтрокаТаб = Таблица.Добавить();
				СтрокаТаб.НомерНабора     = НомерНабора;
				СтрокаТаб.ЗначениеДоступа = Выборка.Партнер;

			КонецЦикла;

		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ЭлектронноеПисьмоИсходящее") Тогда
		МассивКонтактныхЛиц = Новый Массив;

		МассивТабличныхЧастей = Новый Массив;
		МассивТабличныхЧастей.Добавить("ПолучателиПисьма");
		МассивТабличныхЧастей.Добавить("ПолучателиКопий");
		МассивТабличныхЧастей.Добавить("ПолучателиОтвета");
		МассивТабличныхЧастей.Добавить("ПолучателиСкрытыхКопий");
		Для Каждого ТабличнаяЧасть Из МассивТабличныхЧастей Цикл

			Для Каждого СтрокаТаблицы Из Объект[ТабличнаяЧасть] Цикл

				Если Не ЗначениеЗаполнено(СтрокаТаблицы.Контакт) Тогда
					Продолжить;
				КонецЕсли;

				Если ТипЗнч(СтрокаТаблицы.Контакт) = Тип("СправочникСсылка.Партнеры") Тогда

					НомерНабора = НомерНабора + 1;

					СтрокаТаб = Таблица.Добавить();
					СтрокаТаб.НомерНабора     = НомерНабора;
					СтрокаТаб.ЗначениеДоступа = СтрокаТаблицы.Контакт;

				ИначеЕсли ТипЗнч(СтрокаТаблицы.Контакт) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда

					МассивКонтактныхЛиц.Добавить(СтрокаТаблицы.Контакт);

				КонецЕсли;

			КонецЦикла;
		КонецЦикла;

		Если МассивКонтактныхЛиц.Количество() > 0 Тогда

			Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	КонтактныеЛицаПартнеров.Владелец КАК Партнер
			|ИЗ
			|	Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
			|ГДЕ
			|	КонтактныеЛицаПартнеров.Ссылка В(&МассивКонтактныхЛиц)
			|");
			Запрос.УстановитьПараметр("МассивКонтактныхЛиц", МассивКонтактныхЛиц);
			Выборка = Запрос.Выполнить().Выбрать();

			Пока Выборка.Следующий() Цикл

				НомерНабора = НомерНабора + 1;

				СтрокаТаб = Таблица.Добавить();
				СтрокаТаб.НомерНабора     = НомерНабора;
				СтрокаТаб.ЗначениеДоступа = Выборка.Партнер;

			КонецЦикла;

		КонецЕсли;
		
	Иначе
		МассивКонтактныхЛиц = Новый Массив;
		Если ТипЗнч(Объект) = Тип("ДокументОбъект.СообщениеSMS") Тогда
			ИмяТЧ = Объект.Адресаты;
		Иначе
			ИмяТЧ = Объект.Участники;
		КонецЕсли;
		Для Каждого СтрокаТаблицы Из ИмяТЧ Цикл

			Если Не ЗначениеЗаполнено(СтрокаТаблицы.Контакт) Тогда
				Продолжить;
			КонецЕсли;

			Если ТипЗнч(СтрокаТаблицы.Контакт) = Тип("СправочникСсылка.Партнеры") Тогда

				НомерНабора = НомерНабора + 1;

				СтрокаТаб = Таблица.Добавить();
				СтрокаТаб.НомерНабора     = НомерНабора;
				СтрокаТаб.ЗначениеДоступа = СтрокаТаблицы.Контакт;

			ИначеЕсли ТипЗнч(СтрокаТаблицы.Контакт) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда

				МассивКонтактныхЛиц.Добавить(СтрокаТаблицы.Контакт);

			КонецЕсли;

		КонецЦикла;

		Если МассивКонтактныхЛиц.Количество() > 0 Тогда

			Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	КонтактныеЛицаПартнеров.Владелец КАК Партнер
			|ИЗ
			|	Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
			|ГДЕ
			|	КонтактныеЛицаПартнеров.Ссылка В(&МассивКонтактныхЛиц)
			|");
			Запрос.УстановитьПараметр("МассивКонтактныхЛиц", МассивКонтактныхЛиц);
			Выборка = Запрос.Выполнить().Выбрать();

			Пока Выборка.Следующий() Цикл

				НомерНабора = НомерНабора + 1;

				СтрокаТаб = Таблица.Добавить();
				СтрокаТаб.НомерНабора     = НомерНабора;
				СтрокаТаб.ЗначениеДоступа = Выборка.Партнер;

			КонецЦикла;

		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти
