&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Диалог = новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Фильтр = "Документ Excel (*.xls, *.xlsx)|*.xls;*.xlsx";
	Диалог.МножественныйВыбор=Ложь;
	Если Диалог.Выбрать() Тогда
		ИмяФайла = Диалог.ПолноеИмяФайла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	ЗагрузкаНаКлиентеЕксель();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаНаКлиентеЕксель()
	
	Попытка
		Эксель = Новый COMОбъект("Excel.Application");
		Эксель.DisplayAlerts = 0;
		Эксель.Visible = 0;
	Исключение
   		Сообщить(ОписаниеОшибки()); 
   		Возврат;
	КонецПопытки;
	
	стЗаписываемыеКолонки = Новый Соответствие;
	стЗаписываемыеКолонки.Вставить("Activity ID","ИДРаботы");
	стЗаписываемыеКолонки.Вставить("Activity Name","НаименованиеРаботы");
	стЗаписываемыеКолонки.Вставить("KKS","КодОборудования");
	стЗаписываемыеКолонки.Вставить("Начало по ЦП","НачалоПоЦелевомуПлану");
	стЗаписываемыеКолонки.Вставить("Окончание по ЦП","КонецПоЦелевомуПлану");
	стЗаписываемыеКолонки.Вставить("Start","НачалоАктализировано");
	стЗаписываемыеКолонки.Вставить("Finish","КонецАктуализировано");
	
	ЭксельКнига = Эксель.Workbooks.Open(ИмяФайла);	
	КоличествоСтраниц = ЭксельКнига.Sheets.Count;
	
	Для НомерЛиста = 1 По КоличествоСтраниц Цикл 
		Лист = ЭксельКнига.Sheets(НомерЛиста);
		ИмяЛиста = ЭксельКнига.Sheets(НомерЛиста).Name;
		НомерБлока = Число(СтрЗаменить(ИмяЛиста,"Блок",""));
		КоличествоСтрок = Лист.Cells(1, 1).SpecialCells(11).Row;
		КоличествоКолонок = Лист.Cells(1, 1).SpecialCells(11).Column;
		строкаШапка = Лист.Cells(1, 1) ;

		
		СписокСтрок = Новый СписокЗначений;

		Для НомерСтроки = 2 По КоличествоСтрок Цикл 
			ДанныеСтроки = Новый Структура;
			Для НомерКолонки = 1 По КоличествоКолонок Цикл
				ИмяКолонки1С = стЗаписываемыеКолонки.Получить(строкаШапка.Columns(НомерКолонки).value);
				ИмяКолонкиЕкс = строкаШапка.Columns(НомерКолонки).value;
				
				ЗначениеВЯчейке = Лист.Cells(НомерСтроки, строкаШапка.Columns(НомерКолонки).Column).Value;

				Если  ИмяКолонки1С <> Неопределено Тогда
					ДанныеСтроки.Вставить(ИмяКолонки1С,  ЗначениеВЯчейке);
				КонецЕсли;

	
			КонецЦикла;
			
			ОбработкаПрерыванияПользователя();			
			Если ДанныеСтроки.Количество()=0 Тогда Продолжить;КонецЕсли;

			НаименованиеРаботы="";
			ДанныеСтроки.Свойство("НаименованиеРаботы",НаименованиеРаботы);
			Если НаименованиеРаботы=Неопределено Тогда Продолжить;КонецЕсли;
			
			СписокСтрок.Добавить(ДанныеСтроки);
			//Если  НомерСтроки>50 Тогда Прервать; КонецЕсли;
			
			//Возврат;
		КонецЦикла;
		
		ЗагрузитьГрафикДляБлока(НомерБлока,СписокСтрок);
		//Прервать;
	КонецЦикла;
	
	//РаскраситьНеВалидныеСтрокиКрасным();

	Эксель.Workbooks.Close();
	Эксель.Application.Quit();
КонецПроцедуры

Функция НайтиНоменклатуру(Артикул)
	
	Возврат Справочники.Номенклатура.НайтиПоРеквизиту("Артикул",Артикул);
	
КонецФункции

Функция НайтиРаботу(ИДРаботы,НомерБлока)
	
ОбщегоНазначения_аккую.НайтиРаботуВГрафике(ИДРаботы,НомерБлока);

КонецФункции


Процедура РаскраситьНеВалидныеСтрокиКрасным()
	ОбщегоНазначения_аккую.РаскраситьНеВалидныеСтрокиКрасным(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьГрафикДляБлока(НомерБлока,СписокСтрок)
	Для Каждого СпСтрока из СписокСтрок Цикл 
		
		стКолонки = СпСтрока.Значение;
		
		ИДРаботы="";
		стКолонки.Свойство("ИДРаботы",ИДРаботы);
		РаботаСсылка = НайтиРаботу(ИДРаботы,НомерБлока);
		стКолонки.Вставить("Работа",РаботаСсылка);
		
		Артикул="";
		стКолонки.Свойство("КодОборудования",Артикул);
		Номенклатура = НайтиНоменклатуру(Артикул);
		стКолонки.Вставить("Номенклатура",Номенклатура);
		
		стКолонки.Вставить("НомерБлока",НомерБлока);
		
		Строки = ЭтотОбъект.Объект["Блок"+Строка(НомерБлока)].НайтиСтроки(Новый Структура("Работа",РаботаСсылка));
		Если Строки.Количество() > 0 Тогда
			строкаТЧ = Строки[0];
		Иначе
			строкаТЧ = ЭтотОбъект.Объект["Блок"+Строка(НомерБлока)].Добавить();
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(СтрокаТЧ,стКолонки);
		                                                           
	    Состояние("Заполнение по Блоку"+Строка(НомерБлока)+" " + Строка(СписокСтрок.Индекс(СпСтрока))+"/"+Строка(СписокСтрок.Количество()));
	КонецЦикла;
	
КонецПроцедуры
