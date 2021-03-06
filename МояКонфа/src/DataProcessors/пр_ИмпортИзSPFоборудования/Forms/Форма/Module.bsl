
&НаКлиенте
Процедура Загрузить(Команда)
	 ТзРазниц.Очистить();
	ЗагрузкаНаКлиентеOLE();
	
КонецПроцедуры
  
  
&НаКлиенте
Процедура ЗагрузкаНаКлиентеOLE()
	Попытка
		Эксель = Новый COMОбъект("Excel.Application");
		Эксель.DisplayAlerts = 0;
		Эксель.Visible = 0;
	Исключение
   		Сообщить(ОписаниеОшибки()); 
   		Возврат;
	КонецПопытки;
	
	
	стЗаписываемыеКолонки = Новый Соответствие;
	стЗаписываемыеКолонки.Вставить("NAME","Наименование");
	стЗаписываемыеКолонки.Вставить("KKS","Артикул");
	стЗаписываемыеКолонки.Вставить("ED_ISM","ЕдиницаИзмерения");
	стЗаписываемыеКолонки.Вставить("ED_MASSA","ВесЕдиницаИзмерения");
	стЗаписываемыеКолонки.Вставить("MASSA_ALL","ВесЧислитель");
	стЗаписываемыеКолонки.Вставить("KOLVO","ВесЗнаменатель");
	стЗаписываемыеКолонки.Вставить("BLOCK_NUMBER","пр_НомерБлока");
	стЗаписываемыеКолонки.Вставить("TEC","пр_ТехническиеХарактеристики");
	стЗаписываемыеКолонки.Вставить("NOTE","Описание");


	ЭксельКнига = Эксель.Workbooks.Open(ИмяФайла);	
	КоличествоСтраниц = ЭксельКнига.Sheets.Count;
	
	Для НомерЛиста = 1 По КоличествоСтраниц Цикл 
		Лист = ЭксельКнига.Sheets(НомерЛиста);
		КоличествоСтрок = Лист.Cells(1, 1).SpecialCells(11).Row;
		КоличествоКолонок = Лист.Cells(1, 1).SpecialCells(11).Column;
		строкаШапка = Лист.Cells(2, 1) ;
		
		Для НомерСтроки = 3 По КоличествоСтрок Цикл 
			ДанныеСтроки = Новый Структура;
			Для НомерКолонки = 1 По КоличествоКолонок Цикл
				ИмяКолонкиСпр = стЗаписываемыеКолонки.Получить(строкаШапка.Columns(НомерКолонки).value);
				ИмяКолонкиЕкс = строкаШапка.Columns(НомерКолонки).value;
				
				ЗначениеВЯчейке = Лист.Cells(НомерСтроки, строкаШапка.Columns(НомерКолонки).Column).Value;

				Если  ИмяКолонкиСпр <> Неопределено Тогда
					ДанныеСтроки.Вставить(ИмяКолонкиСпр,  ЗначениеВЯчейке);
				иначе
					попытка
					ДанныеСтроки.Вставить("пр_"+СокрЛП(ИмяКолонкиЕкс),  ЗначениеВЯчейке);
				Исключение
					Сообщить(ОписаниеОшибки());
					КонецПопытки;
				КонецЕсли;
				
			КонецЦикла;
			
			ЗаписатьНоменклатуру(ДанныеСтроки);
			//Возврат;
		КонецЦикла;	
		Прервать;
	КонецЦикла;
	
	Эксель.Workbooks.Close();
	Эксель.Application.Quit();
	Если ТзРазниц.Количество()>0 и ПоказатьИзменение Тогда
		ВывестиОтчет();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиОтчет()
	Запрос = Новый Запрос; 
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТзРазниц.Номенклатура КАК Номенклатура,
	               |	ТзРазниц.Реквизит КАК Реквизит,
	               |	ТзРазниц.Было КАК Было,
	               |	ТзРазниц.Стало КАК Стало
	               |ПОМЕСТИТЬ ВТРазниц
	               |ИЗ
	               |	&Тз КАК ТзРазниц
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТРазниц.Номенклатура КАК Номенклатура,
	               |	ВТРазниц.Реквизит КАК Реквизит,
	               |	ВТРазниц.Было КАК Было,
	               |	ВТРазниц.Стало КАК Стало
	               |ИЗ
	               |	ВТРазниц КАК ВТРазниц
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВТРазниц.Номенклатура,
	               |	ВТРазниц.Реквизит,
	               |	ВТРазниц.Стало,
	               |	ВТРазниц.Было"; 
	
	Запрос.УстановитьПараметр("Тз", ТзРазниц.Выгрузить()); 
	
	Результат = Запрос.Выполнить(); 
	
	Макет = Обработки.пр_ИмпортИзSPFоборудования.ПолучитьМакет("Макет"); 
	ТабДок = Новый ТабличныйДокумент; 
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ТабДок.Вывести(ОбластьЗаголовок);
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка"); 
	
	Выборка = Результат.Выбрать(); 
	
	Пока Выборка.Следующий() Цикл 
		ОбластьСтрока.Параметры.Заполнить(Выборка); 
		ТабДок.Вывести(ОбластьСтрока); 
	КонецЦикла;
	ТабДок.Показать("Разница в реквизитах");

КонецПроцедуры


&НаСервере
Процедура ЗаписатьНоменклатуру(ДанныеСтроки)
	
	
	Артикул="";
	АртикулЗаполнен = ДанныеСтроки.Свойство("Артикул",Артикул);	
	Если Не АртикулЗаполнен Тогда Возврат; КонецЕсли;

	ДанныеСтроки.Вставить("ВидНоменклатуры",  Справочники.ВидыНоменклатуры.НайтиПоНаименованию("Оборудование"));  
	ДанныеСтроки.Вставить("Родитель",  Справочники.Номенклатура.НайтиПоНаименованию("Оборудование"));
	ДанныеСтроки.Вставить("ТипНоменклатуры",  Справочники.ВидыНоменклатуры.НайтиПоНаименованию("Оборудование").ТипНоменклатуры);
	
	Значение="";
	ДанныеСтроки.Свойство("Наименование",Значение);	
	ДанныеСтроки.Вставить("НаименованиеПолное", Значение);
	
	ДанныеСтроки.Свойство("ЕдиницаИзмерения",Значение);
	Значение = Справочники.УпаковкиЕдиницыИзмерения.НайтиПоНаименованию(Значение);
	ДанныеСтроки.Вставить("ЕдиницаИзмерения",Значение);
	
	ДанныеСтроки.Вставить("ВесИспользовать",  Истина);
	ДанныеСтроки.Свойство("ВесЕдиницаИзмерения",Значение);
	Значение = Справочники.УпаковкиЕдиницыИзмерения.НайтиПоНаименованию(Значение);
	ДанныеСтроки.Вставить("ВесЕдиницаИзмерения",Значение);
	ДанныеСтроки.Вставить("Качество",Перечисления.ГрадацииКачества.Новый);
	ДанныеСтроки.Вставить("СтавкаНДС",Перечисления.СтавкиНДС.НДС0);



	Номенклатура = Справочники.Номенклатура.НайтиПоРеквизиту("Артикул",Артикул);
	Если НЕ ЗначениеЗаполнено(Номенклатура) Тогда
		Номенклатура = Справочники.Номенклатура.СоздатьЭлемент();
	иначе
		Номенклатура= Номенклатура.Получитьобъект();
	КонецЕсли;
	
	
	Для Каждого ст из ДанныеСтроки Цикл 
		Если Метаданные.Справочники.Номенклатура.Реквизиты.Найти(ст.Ключ)=Неопределено Тогда Продолжить;КонецЕсли;
		Если СокрЛП(Номенклатура[ст.Ключ])<>Лев(СокрЛП(ст.Значение),СтрДлина(СокрЛП(Номенклатура[ст.Ключ]))) Тогда
			строкаТЗ = ТзРазниц.Добавить();
			строкаТЗ.Номенклатура = Номенклатура.Ссылка;
			строкаТЗ.Реквизит = ст.Ключ;
			строкаТЗ.Было = Номенклатура[ст.Ключ];
			строкаТЗ.Стало = ст.Значение;
		КонецЕсли;
		
	КонецЦикла;
	
	
	
	Справочники.Номенклатура.ЗаполнитьРеквизитыПоВидуНоменклатуры(Номенклатура); 

	
	ЗаполнитьЗначенияСвойств(Номенклатура, ДанныеСтроки);
	//Номенклатура.Наименование = "Удале_"+Номенклатура.Наименование;
	//Номенклатура.Артикул = "Удале_"+Номенклатура.Артикул;
	

	Номенклатура.Записать(); 
					
	Сообщить(СокрЛП(Номенклатура.Артикул)+" - загружен.");
	
КонецПроцедуры



&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Диалог = новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Фильтр = "Документ Excel (*.xls, *.xlsx)|*.xls;*.xlsx";
	Диалог.МножественныйВыбор=Ложь;
	Если Диалог.Выбрать() Тогда
		ИмяФайла = Диалог.ПолноеИмяФайла;
	КонецЕсли;
КонецПроцедуры



Процедура ЗагрузкаНаКлиентеOLEДоп()
	Попытка
		Эксель = Новый COMОбъект("Excel.Application");
		Эксель.DisplayAlerts = 0;
		Эксель.Visible = 0;
	Исключение
   		Сообщить(ОписаниеОшибки()); 
   		Возврат;
	КонецПопытки;
	
	стЗаписываемыеКолонки = Новый Соответствие;
	стЗаписываемыеКолонки.Вставить("NAME","Наименование");
	стЗаписываемыеКолонки.Вставить("KKS","Артикул");

	

	ЭксельКнига = Эксель.Workbooks.Open(ИмяФайла);	
	КоличествоСтраниц = ЭксельКнига.Sheets.Count;
	
	Для НомерЛиста = 1 По КоличествоСтраниц Цикл 
		Лист = ЭксельКнига.Sheets(НомерЛиста);
		КоличествоСтрок = Лист.Cells(1, 1).SpecialCells(11).Row;
		КоличествоКолонок = Лист.Cells(1, 1).SpecialCells(11).Column;
		строкаШапка = Лист.Cells(2, 1) ;
		
		Для НомерСтроки = 3 По КоличествоСтрок Цикл 
			ДанныеСтроки = Новый Структура;
			Для НомерКолонки = 1 По КоличествоКолонок Цикл
				ИмяКолонкиСпр = стЗаписываемыеКолонки.Получить(строкаШапка.Columns(НомерКолонки).value);
				ИмяКолонкиЕкс = строкаШапка.Columns(НомерКолонки).value;
				
				ЗначениеВЯчейке = Лист.Cells(НомерСтроки, строкаШапка.Columns(НомерКолонки).Column).Value;

				Если  ИмяКолонкиСпр <> Неопределено Тогда
					ДанныеСтроки.Вставить(ИмяКолонкиСпр,  ЗначениеВЯчейке);
					ДанныеСтроки.Вставить(СокрЛП(ИмяКолонкиЕкс),  ЗначениеВЯчейке);
				иначе
					попытка
					ДанныеСтроки.Вставить(СокрЛП(ИмяКолонкиЕкс),  ЗначениеВЯчейке);
				Исключение
					Сообщить(ОписаниеОшибки());
					КонецПопытки;
				КонецЕсли;
				
			КонецЦикла;
			
			ЗаписатьНоменклатуруДопРекв(ДанныеСтроки);
			//Возврат;
		КонецЦикла;	
		Прервать;
	КонецЦикла;
	
	Эксель.Workbooks.Close();
	Эксель.Application.Quit();
КонецПроцедуры

&НаСервере
Функция ПоискЗначенияПоКлючу(ст, Ключ, ДляСоответствия=Ложь)
		Если ДляСоответствия Тогда
			Возврат ст[Ключ];
		Иначе
			ЗначениеПоиска = Неопределено;
			ст.Свойство(Ключ,ЗначениеПоиска);
			Возврат ЗначениеПоиска;
		КонецЕсли;
КонецФункции 
		
&НаСервере
Процедура ЗаписатьНоменклатуруДопРекв(ДанныеСтроки)
	  	Артикул="";
	АртикулЗаполнен = ДанныеСтроки.Свойство("Артикул",Артикул);	
	Если Не АртикулЗаполнен Тогда Возврат; КонецЕсли;
	Наименование="";
	ДанныеСтроки.Свойство("Наименование",Наименование);	
	
	
	Номенклатура = Справочники.Номенклатура.НайтиПоРеквизиту("Артикул",Артикул);
	Если НЕ ЗначениеЗаполнено(Номенклатура) Тогда
		Номенклатура = Справочники.Номенклатура.СоздатьЭлемент();
	иначе
		Номенклатура= Номенклатура.Получитьобъект();
	КонецЕсли;
	
	Справочники.Номенклатура.ЗаполнитьРеквизитыПоВидуНоменклатуры(Номенклатура); 

	//ЗаполнитьЗначенияСвойств(Номенклатура, ДанныеСтроки);
	//Номенклатура.Наименование = "Удале_"+Номенклатура.Наименование;
	//Номенклатура.Артикул = "Удале_"+Номенклатура.Артикул;
	Номенклатура.Артикул = Артикул;	
	Номенклатура.Наименование = Наименование;
	Номенклатура.НаименованиеПолное = Наименование;
	Номенклатура.Записать(); 
	
	для Каждого ст Из ДанныеСтроки Цикл 
		если ст.Ключ = "Артикул" или ст.Ключ = "Наименование" Тогда Продолжить;КонецЕсли;

		СоздатьДопРеквизитНаСервере(ст.Ключ);
		ТаблицаСвойств = Новый ТаблицаЗначений;
		ТаблицаСвойств.Колонки.Добавить("Свойство");
		ТаблицаСвойств.Колонки.Добавить("Значение");
		строкаТС = ТаблицаСвойств.Добавить();
		строкаТС.Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(ст.Ключ);
		//ЗначениеПоиска = Неопределено;
		//ст.Свойство(Ключ,ЗначениеПоиска);
		строкаТС.Значение = ст.Значение;
	

		УправлениеСвойствами.ЗаписатьСвойстваУОбъекта(Номенклатура.Ссылка,ТаблицаСвойств);
		
	КонецЦикла;
	
	
	
	Сообщить(СокрЛП(Номенклатура.Артикул)+" - загружен.");

	
КонецПроцедуры

&НаСервере
Процедура СоздатьДопРеквизитНаСервере(ИмяРеквизита)
	
    //включим константу использования
    Если Не Константы.ИспользоватьДополнительныеРеквизитыИСведения.Получить() Тогда
        Константы.ИспользоватьДополнительныеРеквизитыИСведения.Установить(Истина);
    КонецЕсли;
	
	//попробуем найти реквизит по наименованию
	ДопРеквизитСсылка = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(ИмяРеквизита);
	Если НЕ ЗначениеЗаполнено(ДопРеквизитСсылка) Тогда
		//если не нашли реквизит - будем его создавать
		ДопРеквизитОбъект = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.СоздатьЭлемент();
		ДопРеквизитОбъект.Заголовок = ИмяРеквизита;
		ДопРеквизитОбъект.НаборСвойств = Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Номенклатура;
		ДопРеквизитОбъект.ТипЗначения = Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(250));
		ДопРеквизитОбъект.Наименование = ДопРеквизитОбъект.Заголовок + " ("+ДопРеквизитОбъект.НаборСвойств+")";
		ДопРеквизитОбъект.Виден = Истина;
		ДопРеквизитОбъект.Доступен = Истина;
		ДопРеквизитОбъект.ДополнительныеЗначенияИспользуются = ложь;
		//зададим имя нового реквизита
		//ДопРеквизитОбъект.Имя = "filap_"+СтрЗаменить(ИмяРеквизита," ","");
		ДопРеквизитОбъект.Записать();
		ДопРеквизитСсылка = ДопРеквизитОбъект.Ссылка;		
	КонецЕсли;
	
    //добавим наш реквизит в набор дополнительных реквизитов 
    НаборДополнительныхРеквизитов = Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Номенклатура.ПолучитьОбъект();
    Если НаборДополнительныхРеквизитов.ДополнительныеРеквизиты.Найти(ДопРеквизитСсылка, "Свойство") = Неопределено Тогда
        //добавим реквизит в набор
        Стр = НаборДополнительныхРеквизитов.ДополнительныеРеквизиты.Добавить();
        Стр.Свойство = ДопРеквизитСсылка;
	НаборДополнительныхРеквизитов.Записать();
    КонецЕсли;
	
КонецПроцедуры

