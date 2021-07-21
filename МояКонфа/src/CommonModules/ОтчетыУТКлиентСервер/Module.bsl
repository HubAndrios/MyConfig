
#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПереключитьТекущуюСтраницуВыбораПериода(ВидПериода, Страницы, ПараметрыСтраниц = Неопределено) Экспорт
	
	Если ПараметрыСтраниц = Неопределено Тогда
		ПараметрыСтраниц = Новый Структура;
		ПараметрыСтраниц.Вставить("ПроизвольныйПериод", "ГруппаПроизвольныйПериод");
		ПараметрыСтраниц.Вставить("ПериодПоВидам"     , "ГруппаПериодПоВидам");
		ПараметрыСтраниц.Вставить("День"              , "ГруппаДень");
	КонецЕсли;
	
	Если ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.ПроизвольныйПериод") Тогда
		Страницы.ТекущаяСтраница = Страницы.ПодчиненныеЭлементы[ПараметрыСтраниц.ПроизвольныйПериод];
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.День") Тогда
		Страницы.ТекущаяСтраница = Страницы.ПодчиненныеЭлементы[ПараметрыСтраниц.День];
	Иначе
		Страницы.ТекущаяСтраница = Страницы.ПодчиненныеЭлементы[ПараметрыСтраниц.ПериодПоВидам];
	КонецЕсли;
	
КонецПроцедуры

// Возвращает представление периода
Функция ПолучитьПредставлениеПериодаОтчета(ВидПериода, Знач НачалоПериода, Знач КонецПериода) Экспорт
	
	Если ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.ПроизвольныйПериод") Тогда	
		Если Не ЗначениеЗаполнено(НачалоПериода) И Не ЗначениеЗаполнено(КонецПериода) Тогда
			Возврат "";
		Иначе
			Возврат Формат(НачалоПериода, "ДФ=dd.MM.yy") + " - " + Формат(КонецПериода, "ДФ=dd.MM.yy");
		КонецЕсли;
	Иначе
		НачалоПериода = НачалоДня(НачалоПериода);
		КонецПериода = КонецДня(КонецПериода);
		РасчетныйВидПериода = ОтчетыКлиентСервер.ПолучитьВидПериода(НачалоПериода, КонецПериода);
		Если РасчетныйВидПериода <> ВидПериода И ЗначениеЗаполнено(НачалоПериода) Тогда
			ВидПериода = РасчетныйВидПериода;
		КонецЕсли;
		
		Список = СписокФиксированныхПериодов(НачалоПериода, ВидПериода);
		
		ЭлементСписка = Список.НайтиПоЗначению(НачалоПериода);
		Если ЭлементСписка <> Неопределено тогда
			Возврат ЭлементСписка.Представление;
		Иначе
			Возврат "";
		КонецЕсли;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Возвращает список периодов в диапазоне начала периода.
Функция СписокФиксированныхПериодов(Знач НачалоПериода, ВидПериода) Экспорт
	СписокПериодов = Новый СписокЗначений;
	
	Если НачалоПериода = '00010101' Тогда
		Возврат СписокПериодов;
	КонецЕсли;
	
	НачалоПериода = НачалоДня(НачалоПериода);
	ВыборОтносительногоПериода = (НачалоПериода = "ВыборОтносительногоПериода");
	ПоказыватьВсеОтносительныеПериоды = Ложь;
	
	#Если Клиент Тогда
		Сегодня = ОбщегоНазначенияКлиент.ДатаСеанса();
	#Иначе
		Сегодня = ТекущаяДатаСеанса();
	#КонецЕсли
	Сегодня = НачалоДня(Сегодня);
	
	НавигационныйПунктРанееПредставление = НСтр("ru = 'Ранее...'");
	НавигационныйПунктПозжеПредставление = НСтр("ru = 'Позже...'");
	
	Если ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.День") Тогда
		ТекущийДеньНедели   = ДеньНедели(Сегодня);
		ВыбранныйДеньНедели = ДеньНедели(НачалоПериода);
		
		// Вычисление начального и конечного периода по формуле. В 1 дне 86400 секунд.
		НачальныйДеньНедели = ТекущийДеньНедели - 5;
		КонечныйДеньНедели  = ТекущийДеньНедели + 1;
		Если ВыбранныйДеньНедели > КонечныйДеньНедели Тогда
			ВыбранныйДеньНедели = ВыбранныйДеньНедели - 7;
		КонецЕсли;
		
		Период = НачалоПериода - 86400 * (ВыбранныйДеньНедели - НачальныйДеньНедели);
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		СписокПериодов.Добавить(Период - 86400 * 7, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Счетчик = 1 По 7 Цикл
			СписокПериодов.Добавить(Период, Формат(Период, "ДФ='dd MMMM yyyy, dddd'") + ?(Период = Сегодня, " - " + НСтр("ru = 'сегодня'"), ""));
			Период = Период + 86400;
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		СписокПериодов.Добавить(Период + 86400 * 6, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Неделя") Тогда
		ТекущееНачалоНедели   = НачалоНедели(Сегодня);
		ВыбранноеНачалоНедели = НачалоНедели(НачалоПериода);
		
		// Вычисление начального и конечного периода по формуле. В 7 днях 604800 секунд.
		РазностьНедель = (ВыбранноеНачалоНедели - ТекущееНачалоНедели) / 604800;
		Коэффициент = (РазностьНедель - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальнаяНеделя = ТекущееНачалоНедели + (2 + Коэффициент*7) * 604800;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		СписокПериодов.Добавить(НачальнаяНеделя - 7 * 604800, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Счетчик = 0 По 6 Цикл
			Период = НачальнаяНеделя + Счетчик * 604800;
			КонецПериода  = КонецНедели(Период);
			ПредставлениеПериода = Формат(Период, "ДФ=dd.MM") + " - " + Формат(КонецПериода, "ДЛФ=D") + " (" + НеделяГода(КонецПериода) + " " + НСтр("ru = 'неделя года'") + ")";
			Если Период = ТекущееНачалоНедели Тогда
				ПредставлениеПериода = ПредставлениеПериода + " - " + НСтр("ru = 'эта неделя'");
			КонецЕсли;
			СписокПериодов.Добавить(Период, ПредставлениеПериода);
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		СписокПериодов.Добавить(НачальнаяНеделя + 13 * 604800, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Декада") Тогда
		ТекущийГод   = Год(Сегодня);
		ВыбранныйГод = Год(НачалоПериода);
		ТекущийМесяц   = Месяц(Сегодня);
		ВыбранныйМесяц = Месяц(НачалоПериода);
		ТекущийДень   = День(Сегодня);
		ВыбранныйДень = День(НачалоПериода);
		ТекущаяДекада   = ?(ТекущийДень   <= 10, 1, ?(ТекущийДень   <= 20, 2, 3));
		ВыбраннаяДекада = ?(ВыбранныйДень <= 10, 1, ?(ВыбранныйДень <= 20, 2, 3));
		ТекущаяДекадаАбсолютно   = ТекущийГод*36 + (ТекущийМесяц-1)*3 + (ТекущаяДекада-1);
		ВыбраннаяДекадаАбсолютно = ВыбранныйГод*36 + (ВыбранныйМесяц-1)*3 + (ВыбраннаяДекада-1);
		СтрокаДекада = НСтр("ru = 'декада'");
		
		// Вычисление начального и конечного периода по формуле.
		Коэффициент = (ВыбраннаяДекадаАбсолютно - ТекущаяДекадаАбсолютно - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальнаяДекада = ТекущаяДекадаАбсолютно + 2 + Коэффициент*7;
		КонечнаяДекада  = НачальнаяДекада + 6;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		Декада = НачальнаяДекада - 7;
		Год = Цел(Декада/36);
		ДекадаВГоду = Декада - Год*36;
		МесяцВГоду = Цел(ДекадаВГоду/3) + 1;
		ДекадаВМесяце = ДекадаВГоду - (МесяцВГоду-1)*3 + 1;
		Период = Дата(Год, МесяцВГоду, (ДекадаВМесяце - 1) * 10 + 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Декада = НачальнаяДекада По КонечнаяДекада Цикл
			Год = Цел(Декада/36);
			ДекадаВГоду = Декада - Год*36;
			МесяцВГоду = Цел(ДекадаВГоду/3) + 1;
			ДекадаВМесяце = ДекадаВГоду - (МесяцВГоду-1)*3 + 1;
			Период = Дата(Год, МесяцВГоду, (ДекадаВМесяце - 1) * 10 + 1);
			Представление = Формат(Период, "ДФ='MMMM yyyy'") + ", " + Лев("III", ДекадаВМесяце) + " " + СтрокаДекада + ?(Декада = ТекущаяДекадаАбсолютно, " - " + НСтр("ru = 'эта декада'"), "");
			СписокПериодов.Добавить(Период, Представление);
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		Декада = КонечнаяДекада + 1;
		Год = Цел(Декада/36);
		ДекадаВГоду = Декада - Год*36;
		МесяцВГоду = Цел(ДекадаВГоду/3) + 1;
		ДекадаВМесяце = ДекадаВГоду - (МесяцВГоду-1)*3 + 1;
		Период = Дата(Год, МесяцВГоду, (ДекадаВМесяце - 1) * 10 + 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Месяц") Тогда
		ТекущийГод   = Год(Сегодня);
		ВыбранныйГод = Год(НачалоПериода);
		ТекущийМесяц   = ТекущийГод*12   + Месяц(Сегодня);
		ВыбранныйМесяц = ВыбранныйГод*12 + Месяц(НачалоПериода);
		
		// Вычисление начального и конечного периода по формуле.
		Коэффициент = (ВыбранныйМесяц - ТекущийМесяц - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальныйМесяц = ТекущийМесяц + 2 + Коэффициент*7;
		КонечныйМесяц  = НачальныйМесяц + 6;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		Месяц = НачальныйМесяц - 7;
		Год = Цел((Месяц - 1) / 12);
		МесяцВГоду = Месяц - Год * 12;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Месяц = НачальныйМесяц По КонечныйМесяц Цикл
			Год = Цел((Месяц - 1) / 12);
			МесяцВГоду = Месяц - Год * 12;
			Период = Дата(Год, МесяцВГоду, 1);
			СписокПериодов.Добавить(Период, Формат(Период, "ДФ='MMMM yyyy'") + ?(Год = ТекущийГод И ТекущийМесяц = Месяц, " - " + НСтр("ru = 'этот месяц'"), ""));
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		Месяц = КонечныйМесяц + 1;
		Год = Цел((Месяц - 1) / 12);
		МесяцВГоду = Месяц - Год * 12;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Квартал") Тогда
		ТекущийГод = Год(Сегодня);
		ВыбранныйГод = Год(НачалоПериода);
		ТекущийКвартал   = 1 + Цел((Месяц(Сегодня)-1)/3);
		ВыбранныйКвартал = 1 + Цел((Месяц(НачалоПериода)-1)/3);
		ТекущийКварталАбсолютно   = ТекущийГод*4   + ТекущийКвартал   - 1;
		ВыбранныйКварталАбсолютно = ВыбранныйГод*4 + ВыбранныйКвартал - 1;
		СтрокаКвартал = НСтр("ru = 'квартал'");
		
		// Вычисление начального и конечного периода по формуле.
		Коэффициент = (ВыбранныйКварталАбсолютно - ТекущийКварталАбсолютно - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальныйКвартал = ТекущийКварталАбсолютно + 2 + Коэффициент*7;
		КонечныйКвартал  = НачальныйКвартал + 6;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		Квартал = НачальныйКвартал - 7;
		Год = Цел(Квартал/4);
		КварталВГоду = Квартал - Год*4 + 1;
		МесяцВГоду = (КварталВГоду-1)*3 + 1;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Квартал = НачальныйКвартал По КонечныйКвартал Цикл
			Год = Цел(Квартал/4);
			КварталВГоду = Квартал - Год*4 + 1;
			МесяцВГоду = (КварталВГоду-1)*3 + 1;
			Период = Дата(Год, МесяцВГоду, 1);
			Представление = ?(КварталВГоду = 4, "IV", Лев("III", КварталВГоду)) + " " + СтрокаКвартал + " " + Формат(Период, "ДФ='yyyy'") + ?(Квартал = ТекущийКварталАбсолютно, " - " + НСтр("ru = 'этот квартал'"), "");
			СписокПериодов.Добавить(Период, Представление);
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		Квартал = КонечныйКвартал + 1;
		Год = Цел(Квартал/4);
		КварталВГоду = Квартал - Год*4 + 1;
		МесяцВГоду = (КварталВГоду-1)*3 + 1;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Полугодие") Тогда
		ТекущийГод = Год(Сегодня);
		ВыбранныйГод = Год(НачалоПериода);
		ТекущееПолугодие   = 1 + Цел((Месяц(Сегодня)-1)/6);
		ВыбранноеПолугодие = 1 + Цел((Месяц(НачалоПериода)-1)/6);
		ТекущееПолугодиеАбсолютно   = ТекущийГод*2   + ТекущееПолугодие   - 1;
		ВыбранноеПолугодиеАбсолютно = ВыбранныйГод*2 + ВыбранноеПолугодие - 1;
		СтрокаПолугодие = НСтр("ru = 'полугодие'");
		
		// Вычисление начального и конечного периода по формуле.
		Коэффициент = (ВыбранноеПолугодиеАбсолютно - ТекущееПолугодиеАбсолютно - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальноеПолугодие = ТекущееПолугодиеАбсолютно + 2 + Коэффициент*7;
		КонечноеПолугодие  = НачальноеПолугодие + 6;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		Полугодие = НачальноеПолугодие - 7;
		Год = Цел(Полугодие/2);
		ПолугодиеВГоду = Полугодие - Год*2 + 1;
		МесяцВГоду = (ПолугодиеВГоду-1)*6 + 1;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Полугодие = НачальноеПолугодие По КонечноеПолугодие Цикл
			Год = Цел(Полугодие/2);
			ПолугодиеВГоду = Полугодие - Год*2 + 1;
			МесяцВГоду = (ПолугодиеВГоду-1)*6 + 1;
			Период = Дата(Год, МесяцВГоду, 1);
			Представление = Лев("II", ПолугодиеВГоду) + " " + СтрокаПолугодие + " " + Формат(Период, "ДФ='yyyy'") + ?(Полугодие = ТекущееПолугодиеАбсолютно, " - " + НСтр("ru = 'это полугодие'"), "");
			СписокПериодов.Добавить(Период, Представление);
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		Полугодие = КонечноеПолугодие + 1;
		Год = Цел(Полугодие/2);
		ПолугодиеВГоду = Полугодие - Год*2 + 1;
		МесяцВГоду = (ПолугодиеВГоду-1)*6 + 1;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Год") Тогда
		ТекущийГод = Год(Сегодня);
		ВыбранныйГод = Год(НачалоПериода);
		
		// Вычисление начального и конечного периода по формуле.
		Коэффициент = (ВыбранныйГод - ТекущийГод - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальныйГод = ТекущийГод + 2 + Коэффициент*7;
		КонечныйГод = НачальныйГод + 6;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		СписокПериодов.Добавить(Дата(НачальныйГод-7, 1, 1), НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Год = НачальныйГод По КонечныйГод Цикл
			СписокПериодов.Добавить(Дата(Год, 1, 1), Формат(Год, "ЧГ=") + ?(Год = ТекущийГод, " - " + НСтр("ru = 'этот год'"), ""));
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		СписокПериодов.Добавить(Дата(КонечныйГод+7, 1, 1), НавигационныйПунктПозжеПредставление);
		
	КонецЕсли;
	
	Возврат СписокПериодов;
КонецФункции

// Функция возвращает значение отбора пользователя, установленного в отчете.
Функция ПолучитьЗначениеОтбора(КомпоновщикНастроек, ИмяПоля, МассивОперацийСравнения = Неопределено, ТолькоЕслиИспользуется = Ложь) Экспорт
	Значение = Неопределено;
	ПолеОтбора = Новый ПолеКомпоновкиДанных(ИмяПоля);
	ПоВсемОперациям = ?(ЗначениеЗаполнено(МассивОперацийСравнения), Ложь, Истина);
	Для Каждого Поле Из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		Если ТипЗнч(Поле) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		Если Поле.ЛевоеЗначение = ПолеОтбора И (НЕ ТолькоЕслиИспользуется ИЛИ Поле.Использование) Тогда
			Если ПоВсемОперациям Тогда
				ПолеЗначения = ОтчетыКлиентСервер.НайтиПользовательскуюНастройку(КомпоновщикНастроек.ПользовательскиеНастройки, Поле.ИдентификаторПользовательскойНастройки);
				Значение = ПолеЗначения.ПравоеЗначение;
			Иначе
				Для Каждого ОперацияСравнения Из МассивОперацийСравнения Цикл
					Если Поле.ВидСравнения = ОперацияСравнения Тогда
						ПолеЗначения = ОтчетыКлиентСервер.НайтиПользовательскуюНастройку(КомпоновщикНастроек.ПользовательскиеНастройки, Поле.ИдентификаторПользовательскойНастройки);
						Если ПолеЗначения <> Неопределено Тогда
							Значение = ПолеЗначения.ПравоеЗначение;
						КонецЕсли;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Значение;
КонецФункции

// Возвращает окончание периода отчета. Используется в методах
// по актуализации оффлайновых регистров, служит датой окончания расчета.
//	Параметры:
//		КомпоновщикНастроек - КомпоновщикНастроек - Компоновщик настроек отчета
//		ИмяПоля - Строка - Имя поля в параметрах, которое отвечает за период отчета.
//	ВозвращаемоеЗначение:
//		Дата
Функция ГраницаРасчета(КомпоновщикНастроек, ИмяПоля) Экспорт
	ПараметрПериодОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, ИмяПоля);
	Если ТипЗнч(ПараметрПериодОтчета.Значение) = Тип("СтандартныйПериод") Тогда
		ГраницаРасчета = ?(ПараметрПериодОтчета.Использование, ПараметрПериодОтчета.Значение.ДатаОкончания, ОбщегоНазначенияУТВызовСервера.ДатаСеанса());
	Иначе
		ГраницаРасчета = ?(ПараметрПериодОтчета.Использование, ПараметрПериодОтчета.Значение, ОбщегоНазначенияУТВызовСервера.ДатаСеанса());
	КонецЕсли;
	Возврат КонецМесяца(ГраницаРасчета) + 1;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
