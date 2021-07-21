
#Область ПрограммныйИнтерфейс

// Возвращает ссылку на элемент списка по штрихкоду
//
// Параметры:
//  Штрихкод - Строка - Штрихкод
//  Менеджеры - Массив - Пустые ссылки на документы, в которых требуется выполнить поиск по штрихкоду
//
// Возвращаемое значение:
//  ЛюбаяСсылка - Ссылка на найденный элемент
//
Функция ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры = Неопределено) Экспорт
	
	Возврат ШтрихкодированиеПечатныхФорм.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

#Область ДляРаботыСЖурналами

// Возвращает ссылку на элемент списка по штрихкоду
//
// Параметры:
//  Штрихкод - Строка - Штрихкод
//  ДоступныеХозяйственныеОперацииИДокументы - ТаблицаЗначений с колонками:
//		* ХозяйственнаяОперация
//		* ИдентификаторОбъектаМетаданных
//		* Отбор
//		* ДокументПредставление
//
// Возвращаемое значение:
//  ЛюбаяСсылка - Ссылка на найденный элемент
//
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод, ДоступныеХозяйственныеОперацииИДокументы) Экспорт 
	
	МассивМенеджеров = ОбщегоНазначенияУТ.ИспользуемыеМенеджерыДокументов(ДоступныеХозяйственныеОперацииИДокументы);
	
	Возврат ШтрихкодированиеПечатныхФормВызовСервера.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, ?(МассивМенеджеров.Количество() > 0, МассивМенеджеров, Неопределено));
	
КонецФункции
	
#КонецОбласти

#КонецОбласти
