#Область ПрограммныйИнтерфейс

// Определить объекты метаданных, в модулях менеджеров которых ограничивается возможность
// редактирования реквизитов с помощью экспортной функции ПолучитьБлокируемыеРеквизитыОбъекта.
//
// Функция ПолучитьБлокируемыеРеквизитыОбъекта должна возвращать значение Массив - строки в формате
// ИмяРеквизита[;ИмяЭлементаФормы,...], где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы -
// имя элемента формы, связанного с реквизитом. Например, "Объект.Автор", "ПолеАвтор".
//
// Поле надписи, связанное с реквизитом, не блокируется. Если требуется блокировать,
// имя элемента надписи нужно указать после точки с запятой, как написано выше.
//
// Параметры:
//   Объекты - Соответствие - в качестве ключа указать полное имя объекта метаданных,
//             подключенного к подсистеме "Запрет редактирования реквизитов объектов",
//             в качестве значения - пустую строку.
//
// Пример:
//   Объекты.Вставить(Метаданные.Документы.ЗаказПокупателя.ПолноеИмя(), "");
//
//   При этом в модуле менеджера документа ЗаказПокупателя размещается код:
//   // См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами.
//   Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
//   	БлокируемыеРеквизиты = Новый Массив;
//   	БлокируемыеРеквизиты.Добавить("Организация"); // заблокировать редактирование реквизита Организация
//   	Возврат БлокируемыеРеквизиты;
//   КонецФункции
//
Процедура ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты) Экспорт
	
	//++ НЕ ГИСМ
	ОбменДаннымиУТУП.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты);
	
	Объекты.Вставить(Метаданные.ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.ПланыВидовХарактеристик.КаналыРекламныхВоздействий.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.ПланыВидовХарактеристик.СтатьиАктивовПассивов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.БанковскиеСчетаКонтрагентов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.БанковскиеСчетаОрганизаций.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.БонусныеПрограммыЛояльности.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВариантыКомплектацииНоменклатуры.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыКартЛояльности.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыКонтактнойИнформации.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыНоменклатуры.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыПланов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыПодарочныхСертификатов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыСделокСКлиентами.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыЦен.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ВидыЦенПоставщиков.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ГрафикиОплаты.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ГруппыРассылокИОповещений.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ДоговорыКонтрагентов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ДоговорыКредитовИДепозитов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.КартыЛояльности.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.Кассы.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.КассыККМ.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ЛицензииПоставщиковАлкогольнойПродукции.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.НаборыУпаковок.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.Номенклатура.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ОбластиХранения.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.Организации.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ПодарочныеСертификаты.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ПолитикиУчетаСерий.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ПравилаНачисленияИСписанияБонусныхБаллов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ПравилаОбменаСПодключаемымОборудованиемOffline.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.РабочиеУчастки.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СегментыНоменклатуры.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СегментыПартнеров.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СкидкиНаценки.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СкладскиеГруппыНоменклатуры.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СкладскиеПомещения.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СкладскиеЯчейки.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.Склады.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СтруктураПредприятия.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.СценарииТоварногоПланирования.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.УпаковкиЕдиницыИзмерения.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.УсловияПредоставленияСкидокНаценок.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.УчетныеПолитикиОрганизаций.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ФорматыМагазинов.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	Объекты.Вставить(Метаданные.Справочники.ЭквайринговыеТерминалы.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	
	//-- НЕ ГИСМ
	
КонецПроцедуры

#КонецОбласти
