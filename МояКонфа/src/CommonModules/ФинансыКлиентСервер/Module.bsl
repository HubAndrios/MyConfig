
#Область ПрограммныйИнтерфейс

// Процедура пересчитывает сумму в строке табличной части "Расшифровка платежа" при изменении суммы в шапке документа.
//
// Параметры:
//	Объект - ДанныеФормыСтруктура, ДокументОбъект - Текущий документ
//	СуммаДокумента - Число - Сумма документа
//
Процедура ПересчитатьСуммыВСтрокеРасшифровкиПлатежа(Объект, СуммаДокумента, УдалятьЕдинственнуюСтроку = Истина) Экспорт
	
	Если СуммаДокумента = 0 И (УдалятьЕдинственнуюСтроку Или Объект.РасшифровкаПлатежа.Количество() > 1) Тогда
		
		Объект.РасшифровкаПлатежа.Очистить();
		
	ИначеЕсли Объект.РасшифровкаПлатежа.Количество() = 1 Тогда
		
		СтрокаТаблицы = Объект.РасшифровкаПлатежа[0];
		СтрокаТаблицы.Сумма = СуммаДокумента;
		СтрокаТаблицы.СуммаВзаиморасчетов = 0;
		
	ИначеЕсли Объект.РасшифровкаПлатежа.Количество() = 0 И СуммаДокумента > 0 Тогда
		
		СтрокаТаблицы = Объект.РасшифровкаПлатежа.Добавить();
		СтрокаТаблицы.Сумма = СуммаДокумента;
		
	ИначеЕсли Объект.РасшифровкаПлатежа.Итог("Сумма") <> СуммаДокумента Тогда
		
		СуммаРазницы = Объект.РасшифровкаПлатежа.Итог("Сумма") - СуммаДокумента;
		НомерСтроки = Объект.РасшифровкаПлатежа.Количество() - 1;
		
		Пока НомерСтроки >= 0 Цикл
			
			СтрокаРасшифровки = Объект.РасшифровкаПлатежа[НомерСтроки];
			
			Если СтрокаРасшифровки.Сумма = СуммаРазницы Тогда
				
				Объект.РасшифровкаПлатежа.Удалить(НомерСтроки);
				Прервать;
				
			ИначеЕсли СтрокаРасшифровки.Сумма > СуммаРазницы Тогда
				
				СтрокаРасшифровки.Сумма = СтрокаРасшифровки.Сумма - СуммаРазницы;
				СтрокаРасшифровки.СуммаВзаиморасчетов = 0;
				Прервать;
				
			ИначеЕсли СтрокаРасшифровки.Сумма < СуммаРазницы Тогда
				
				СуммаРазницы = СуммаРазницы - СтрокаРасшифровки.Сумма;
				Объект.РасшифровкаПлатежа.Удалить(НомерСтроки);
				
			КонецЕсли;
			
			НомерСтроки = НомерСтроки - 1;
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти