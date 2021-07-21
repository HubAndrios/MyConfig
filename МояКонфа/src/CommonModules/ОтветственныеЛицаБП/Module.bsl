////////////////////////////////////////////////////////////////////////////////
// Ответственные лица: процедуры и функции для работы с ответственным лицами.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция возвращает пустую структуру со сведениями об ответственных лицах.
//
// Возвращаемое значение:
//	Структура с ключами, соответствующими имени значений перечисления ОтветственныеЛица вида:
//	Структура - Структура с ключами, соответствующими имени значений перечисления ОтветственныеЛица вида:
//		* Руководитель - СправочникСсылка.ФизическиеЛица.
//		* РуководительФИО - Структура - Содержит ключи:
//			** Фамилия - Строка - Фамилия.
//			** Имя - Строка - Имя.
//			** Отчество - Строка - Отчество.
//			** Представление - Строка - Полное ФИО.
//		* РуководительПредставление - строка, Фамилия И.О.
//		* РуководительДолжность - СправочникСсылка.Должности.
//		* РуководительДолжностьПредставление - строка, название должности.
//
Функция ПустаяСтруктураОтветственныхЛиц() Экспорт

	ПустоеФизЛицо	 = Справочники.ФизическиеЛица.ПустаяСсылка();
	ПустаяДолжность	 = Неопределено;

	МассивОтветственныхЛиц = Новый Массив;
	МассивОтветственныхЛиц.Добавить("Руководитель");
	МассивОтветственныхЛиц.Добавить("ГлавныйБухгалтер");
	МассивОтветственныхЛиц.Добавить("РуководительКадровойСлужбы");
	МассивОтветственныхЛиц.Добавить("Кассир");
	МассивОтветственныхЛиц.Добавить("ОтветственныйЗаБухгалтерскиеРегистры");
	МассивОтветственныхЛиц.Добавить("ОтветственныйЗаНалоговыеРегистры");    
	МассивОтветственныхЛиц.Добавить("УполномоченныйПредставитель");
	МассивОтветственныхЛиц.Добавить("Исполнитель");

	Результат = Новый Структура();
	
	Для Каждого ВидОтветственногоЛица Из МассивОтветственныхЛиц Цикл
	
		ФИО = Новый Структура;
		ФИО.Вставить("Фамилия", 		"");
		ФИО.Вставить("Имя", 			"");
		ФИО.Вставить("Отчество", 		"");
		ФИО.Вставить("Представление", 	""); // Фамилия И.О.
	
		Результат.Вставить(ВидОтветственногоЛица, 					ПустоеФизлицо);
		Результат.Вставить(ВидОтветственногоЛица + "ФИО", 			ФИО);
		Результат.Вставить(ВидОтветственногоЛица + "Представление", ""); 				// Фамилия И.О.
		Результат.Вставить(ВидОтветственногоЛица + "Должность", 	ПустаяДолжность);   
		Результат.Вставить(ВидОтветственногоЛица + "ДолжностьПредставление", "");		// Наименование должности
	
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Функция возвращает структуру со сведениями об ответственных лицах.
//
// Параметры:
//  Организация   - СправочникСсылка.Организации - Организация, для которой нужно определить ответственных лиц.
//  ДатаСреза     - Дата - Дата со временем, на которые необходимо определить сведения.
//  Подразделение - СправочникСсылка.ПодразделенияОрганизаций - Подразделение, для которого необходимо определить ответственных лиц.
//
// Возвращаемое значение:
//	Структура - Структура с ключами, соответствующими имени значений перечисления ОтветственныеЛица вида:
//		* Руководитель - СправочникСсылка.ФизическиеЛица.
//		* РуководительФИО - Структура - Содержит ключи:
//			** Фамилия - Строка - Фамилия.
//			** Имя - Строка - Имя.
//			** Отчество - Строка - Отчество.
//			** Представление - Строка - Полное ФИО.
//		* РуководительПредставление - строка, Фамилия И.О.
//		* РуководительДолжность - СправочникСсылка.Должности.
//		* РуководительДолжностьПредставление - строка, название должности.
//
Функция ОтветственныеЛица(Организация, ДатаСреза, Подразделение = Неопределено) Экспорт

	// В текущую функцию в качестве ДатаСреза обычно передается дата самого документа 
	// вместе со временем. Чтобы уменьшить число разных значений в кэше повторно используемых
	// вызовов, получим для этой даты значение последнего изменения в ответственных лица
	// и для него уже вызовем функцию из модуля с повторным использованием возвращаемых значений.
	ПриведеннаяДатаСреза = '0001-01-01';
	
	МассивДатИзменения = ОтветственныеЛицаБППовтИсп.ДатыИзмененияОтветственныхЛицОрганизаций(Организация);
	Для Каждого ДатаИзменения Из МассивДатИзменения Цикл
		Если ДатаИзменения <= ДатаСреза Тогда
			ПриведеннаяДатаСреза = Макс(ПриведеннаяДатаСреза, ДатаИзменения);
		КонецЕсли;
	КонецЦикла;
	
	Результат = ОтветственныеЛицаБППовтИсп.ОтветственныеЛица(Организация, ПриведеннаяДатаСреза, Подразделение);

	Возврат Результат;

КонецФункции

// Функция возвращает пустую структуру с описанием реквизитов подписи по умолчанию указанного пользователя.
//
// Возвращаемое значение:
//	Структура - Содержит ключи:
//		* Руководитель - СправочникСсылка.ФизическиеЛица - Руководитель.
//		* РуководительНаОсновании - Строка - Основание действий руководителя.
//		* ГлавныйБухгалтер - СправочникСсылка.ФизическиеЛица - Главный бухгалтер.
//		* ГлавныйБухгалтерНаОсновании - Строка - Основание действий главного бухгалтера.
//		* ОтветственныйЗаОформление - СправочникСсылка.ФизическиеЛица - Лицо, ответственное за оформление.
//
Функция ПустаяСтруктураУполномоченныхЛиц() Экспорт 
	
	ПустоеФизЛицо   = Справочники.ФизическиеЛица.ПустаяСсылка();
	ПустоеОснование = Неопределено;
	
	Результат = Новый Структура();
	Результат.Вставить("Руководитель", 				ПустоеФизЛицо);
	Результат.Вставить("РуководительНаОсновании", 	ПустоеОснование);
	Результат.Вставить("ГлавныйБухгалтер",			ПустоеФизЛицо);
	Результат.Вставить("ГлавныйБухгалтерНаОсновании",ПустоеОснование);
	Результат.Вставить("ОтветственныйЗаОформление",  ПустоеФизЛицо);

	Возврат Результат;

КонецФункции

// Возвращает ответственное лицо на складе на указанную дату.
//
// Параметры:
//	Склад - СправочникСсылка.Склады - Склад, для которого нужно получить ответственное лицо.
//	Дата - Дата - Дата, на которую нужно получить ответственное лицо.
//
// Возвращаемое значение:
//	СправочникСсылка.ФизическиеЛица - Ответственное лицо склада.
//
Функция ОтветственноеЛицоНаСкладе(Склад, Дата) Экспорт
	
	Возврат ОтветственныеЛицаБППереопределяемый.ОтветственноеЛицоНаСкладе(Склад, Дата);

КонецФункции

#КонецОбласти