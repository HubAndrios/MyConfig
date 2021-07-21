#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//Возвращает имена реквизитов, которые не должны отображаться в списке реквизитов обработки ГрупповоеИзменениеОбъектов
//
//	Возвращаемое значение:
//		Массив - массив имен реквизитов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("ВместимостьПредставление");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// Обработчик УТ 11.2.2
Процедура ЗаполнитьЕдиницыИзмерения() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Т.Ссылка
	|ИЗ
	|	Справочник.ТипыТранспортныхСредств КАК Т
	|ГДЕ
	|	Т.ВесЕдиницаИзмерения = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)";
	
	ЕдиницыИзмерения = Новый Структура;
	ЕдиницыИзмерения.Вставить("ОбъемЕдиницаИзмерения", Справочники.УпаковкиЕдиницыИзмерения.НайтиПоКоду("113"));
	ЕдиницыИзмерения.Вставить("ВесЕдиницаИзмерения",   Справочники.УпаковкиЕдиницыИзмерения.НайтиПоКоду("168"));
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СпрОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(СпрОбъект,ЕдиницыИзмерения);
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СпрОбъект);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли