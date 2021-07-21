#Область ПрограммныйИнтерфейс

#Область ПроверкаНеобходимостиПроведенияДокументов


// Функция возвращает ИСТИНА, если в конфигурации поддерживается учет по подразделениями.
//
// Возвращаемое значение:
//	Булево - Признак ведения учета по подразделениям.
//
Функция ВестиУчетПоПодразделениям() Экспорт

	Возврат Истина;

КонецФункции

// Функция возвращает ИСТИНА, если в конфигурации используются подразделения.
//
// Возвращаемое значение:
//	Булево - Признак использования подразделений.
//
Функция ИспользоватьПодразделения() Экспорт

	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения");

КонецФункции

// Функция возвращает ИСТИНА, если в конфигурации используется управленческая организация.
//
// Возвращаемое значение:
//	Булево - Признак использования управленческой организации.
//
Функция ИспользоватьУправленческуюОрганизацию() Экспорт

	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьУправленческуюОрганизацию");

КонецФункции

// Функция возвращает ИСТИНА, если в конфигурации поддерживается учет по договорам.
//
// Возвращаемое значение:
//	Булево - Признак учета по договорам.
//
Функция ВестиУчетПоДоговорам() Экспорт

	Возврат Истина;

КонецФункции

// Функция возвращает ИСТИНА, если в конфигурации используются направления деятельности.
//
// Возвращаемое значение:
//	Булево - Истина, если направления деятельности используются.
//
Функция ИспользоватьНаправленияДеятельности() Экспорт

	Возврат ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат")
		И (ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоходовПоНаправлениямДеятельности")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьУчетДСпоНаправлениямДеятельностиРаздельно")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности"));

КонецФункции

// Функция возвращает признак использования одной номенклатурной группы.
//
// Возвращаемое значение:
//	Булево - Признак использования одной номенклатурной группы.
//
Функция ИспользоватьОднуНоменклатурнуюГруппу() Экспорт

	// Совместимость с БП.
	Возврат Ложь;

КонецФункции

#КонецОбласти


#Область ОпределенияТипов

// Функция возвращает типы значений, для которых имеет смысл отбор по организации
//
// Возвращаемое значение:
//	ОписаниеТипов - Описание типов справочников, которые зависят от организации.
//
Функция ТипыСвязанныеСОрганизацией() Экспорт
	
	СтрокаТипов = "СправочникСсылка.БанковскиеСчетаОрганизаций,
		|СправочникСсылка.ДоговорыКонтрагентов, СправочникСсылка.РегистрацииВНалоговомОргане";
	
	Возврат Новый ОписаниеТипов(Документы.ТипВсеСсылки(), СтрокаТипов);
	
КонецФункции // ТипыСвязанныеСОрганизацией()

#КонецОбласти

#Область СвойстваОрганизации


// Возвращает перечень (массив) всех структурных частей переданной головной организации, имеющих отдельный баланс.
// В перечень входит головная организация и все ее обособленные подразделения на выделенном балансе.
// В перечень входят только те организации, данные по которым доступны текущему пользователю.
//
// Параметры:
//	Организация - СправочникСсылка.Организации - Исходная организация.
//
// Возвращаемое значение:
//	Массив - Головная организация и все ее обособленные подразделения, выделенные на отдельный баланс.
//
Функция ВсяОрганизация(Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.ГоловнаяОрганизация = &Организация
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	&Организация
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организация";

	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Организация");

КонецФункции

// Функция строит текст запроса для получения наименования организации для печатных форм.
//
// Параметры:
//	ПолеОрганизация - Строка - Выражение языка запросов для выбора ссылки на организацию.
//
// Возвращаемое значение:
//	Строка - Выражение для получения полного наименования организации.
//
Функция ТекстЗапросаВариантНаименованияОрганизацииДляПечатныхФорм(ПолеОрганизация) Экспорт

	Возврат СтрЗаменить("Организация.НаименованиеПолное",
						"Организация",
						ПолеОрганизация);

КонецФункции // ТекстЗапросаВариантНаименованияОрганизацииДляПечатныхФорм()


#КонецОбласти

#Область СведенияОбОрганизацииИлиКонтрагенте

// Функция формирует сведения об указанном ЮрФизЛице. К сведениям относятся -
// наименование, адрес, номер телефона, банковские реквизиты.
//
// Параметры: 
//  ЮрФизЛицо - СправочникСсылка.Организации, СправочникСсылка.Контрагенты - Лицо, о котором собираются сведения.
//  Период - Дата - Дата, на которую выбираются сведения о ЮрФизЛице.
//  БанковскийСчет - СправочникСсылка.БанковскиеСчетаОрганизаций, СправочникСсылка.БанковскиеСчетаКонтрагентов - счет, 
//					реквизиты которого выводятся.
//
// Возвращаемое значение:
//  Сведения - собранные сведения.
//
Функция СведенияОЮрФизЛице(ЮрФизЛицо, Период = '20200101', Знач БанковскийСчет = Неопределено) Экспорт

	Возврат ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ЮрФизЛицо, Период, Истина, БанковскийСчет);

КонецФункции // СведенияОЮрФизЛице()

// Функция возвращает ссылку на вид контактной информации EMAILКонтрагента.
//
// Возвращаемое значение:
//  СправочникСсылка.ВидыКонтактнойИнформации - ссылка на вид контактной информации EMAILКонтрагента.
//
Функция ВидКонтактнойИнформацииEMAILКонтрагента() Экспорт
	
	Возврат Справочники.ВидыКонтактнойИнформации.EmailКонтрагента;
	
КонецФункции

#КонецОбласти

#Область СвойстваПодразделения

// Возвращает структуру данных со сводным описанием контрагента.
//
// Параметры:
//  СписокСведений - СписокЗначений - Список значений со значениями параметров организации.
//   СписокСведений формируется функцией СведенияОЮрФизЛице.
//  Список         - Строка - Список запрашиваемых параметров организации.
//  СПрефиксом     - Булево - Признак выводить или нет префикс параметра организации.
//
// Возвращаемое значение:
//  Строка - описатель организации / контрагента / физ.лица.
//
Функция ОписаниеОрганизации(СписокСведений, Список = "", СПрефиксом = Истина) Экспорт
	
	Возврат ФормированиеПечатныхФорм.ОписаниеОрганизации(СписокСведений, Список, СПрефиксом);
	
КонецФункции // ОписаниеОрганизации()

// Функция возвращает ссылку на пустое подразделение.
//
// Возвращаемое значение:
//	СправочникСсылка.СтруктураПредприятия - пустая ссылка подразделения.
//
Функция ПустоеПодразделение() Экспорт

	Возврат Справочники.СтруктураПредприятия.ПустаяСсылка();

КонецФункции // ПустоеПодразделение()


#КонецОбласти


#Область НастройкиПользователей

// Функция возвращает значение по умолчанию для передаваемого пользователя и настройки.
//
// Параметры:
//  Настройка    - Строка - вид настройки, значение по умолчанию которой необходимо получить.
//  Пользователь - СправочникСсылка.Пользователи - пользователь программы, настройка которого
//				   запрашивается, если параметр не передается настройка возвращается для текущего пользователя.
//
// Возвращаемое значение:
//  Произвольный - Значение по умолчанию для настройки.
//
Функция ПолучитьЗначениеПоУмолчанию(Настройка, Пользователь = Неопределено) Экспорт

	НастройкаВРег = ВРег(Настройка);
	НастройкаТипаСсылка = Ложь;

	Если НастройкаВРег = ВРег("ОсновнаяОрганизация") Тогда
		Возврат Справочники.Организации.ОрганизацияПоУмолчанию();
	ИначеЕсли НастройкаВРег = ВРег("ОсновноеПодразделениеОрганизации") Тогда
		ПустоеЗначение = ПустоеПодразделение();
		НастройкаТипаСсылка = Истина;
	ИначеЕсли НастройкаВРег = ВРег("ОсновнойСклад") Тогда
		ПустоеЗначение = Справочники.Склады.ПустаяСсылка();
		НастройкаТипаСсылка = Истина;
	ИначеЕсли НастройкаВРег = ВРег("РабочаяДата") Тогда
		// Для совместимости с предыдущими версиями.
		Возврат ОбщегоНазначения.РабочаяДатаПользователя(Пользователь);
	ИначеЕсли НастройкаВРег = ВРег("Подпись") Тогда
		ПустоеЗначение = НоваяПодпись();
	Иначе
		Возврат Неопределено;
	КонецЕсли;

	ЗначениеНастройки = ХранилищеОбщихНастроек.Загрузить(НастройкаВРег,,, Пользователь);

	Если ТипЗнч(ЗначениеНастройки) = ТипЗнч(ПустоеЗначение) Тогда
		Если НастройкаТипаСсылка Тогда
			Если НЕ ОбщегоНазначения.СсылкаСуществует(ЗначениеНастройки) Тогда
				ЗначениеНастройки = ПустоеЗначение;
			КонецЕсли;
		КонецЕсли;
	Иначе
		ЗначениеНастройки = ПустоеЗначение;
	КонецЕсли;
	
	Возврат ?(ЗначениеНастройки = Неопределено, ПустоеЗначение, ЗначениеНастройки);

КонецФункции // ПолучитьЗначениеПоУмолчанию()


#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НоваяПодпись()
	
	Подпись = НСтр("ru='С уважением%1'");
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	ДанныеПользователя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(АвторизованныйПользователь, "Наименование, Служебный");
	Если ДанныеПользователя.Служебный Тогда
		ПредставлениеПользователя = ".";
		
	Иначе
		ПредставлениеПользователя = ", " + ДанныеПользователя.Наименование + ".";
		
	КонецЕсли;
	
	Подпись = СтрШаблон(Подпись, ПредставлениеПользователя);
	
	Возврат Подпись;
	
КонецФункции

#КонецОбласти
