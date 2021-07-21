#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДокументРезультат.Очистить();
	СегментСсылка = КомпоновщикНастроек.ФиксированныеНастройки.ДополнительныеСвойства.Сегмент;
	ПараметрыПриДинамическомФормировании = Неопределено;
	
	РеквизитыСКДСегмента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		СегментСсылка,
		"СхемаКомпоновкиДанных,ХранилищеНастроекКомпоновкиДанных,ИмяШаблонаСКД");
		
	НастройкиСегмента = РеквизитыСКДСегмента.ХранилищеНастроекКомпоновкиДанных.Получить();
		
	Если ПустаяСтрока(РеквизитыСКДСегмента.ИмяШаблонаСКД) Тогда
		
		СКД = РеквизитыСКДСегмента.СхемаКомпоновкиДанных.Получить();
		
	Иначе
		
		СКД_Макета = СегментыСервер.ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета(СегментСсылка, РеквизитыСКДСегмента.ИмяШаблонаСКД);
		СКД = СКД_Макета.СхемаКомпоновкиДанных;
		
	КонецЕсли;
	
	Если НастройкиСегмента = Неопределено Тогда
		НастройкиСегмента = СКД.НастройкиПоУмолчанию;
	КонецЕсли;
	
	Если СегментСсылка.СпособФормирования <>
		Перечисления.СпособыФормированияСегментов.ФормироватьДинамически Тогда
		
		Если СКД.НаборыДанных.Найти("СписокСегмента") <> Неопределено Тогда
			
			НаборСписка = СКД.НаборыДанных.Найти("СписокСегмента");
			
			//заменить запрос списка на обращение к регистру
			Если ТипЗнч(СегментСсылка) = Тип("СправочникСсылка.СегментыНоменклатуры") Тогда
				НаборСписка.Запрос = 
				"ВЫБРАТЬ
				|	НоменклатураСегмента.Номенклатура КАК ЭлементСписка,
				|	НоменклатураСегмента.Характеристика КАК ХарактеристикаЭлемента,
				|	НоменклатураСегмента.Сегмент
				|ИЗ
				|	РегистрСведений.НоменклатураСегмента КАК НоменклатураСегмента";
			Иначе
				НаборСписка.Запрос =
				"ВЫБРАТЬ
				|	ПартнерыСегмента.Партнер КАК ЭлементСписка,
				|	ПартнерыСегмента.Сегмент
				|ИЗ
				|	РегистрСведений.ПартнерыСегмента КАК ПартнерыСегмента";
			КонецЕсли; //заменить запрос списка на обращение к регистру
			
			//удалить отбор, соответствующий старому запросу
			ЭлементыОтбора = НастройкиСегмента.Отбор.Элементы;
			ЭлементыОтбора.Очистить();
			
			//добавить отбор по сегменту
			КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(
			НастройкиСегмента, Новый ПолеКомпоновкиДанных("Сегмент"), СегментСсылка);
			
			//включить автозаполнение полей
			СКД.НаборыДанных.СписокСегмента.АвтоЗаполнениеДоступныхПолей = Истина;
			
		КонецЕсли;
		
	Иначе
		
		Если СКД.НаборыДанных.Найти("ВыводСегмента") <> Неопределено И СКД.НаборыДанных.Найти("ФормированиеСегмента") <> Неопределено Тогда
			
			КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
			МакетКомпоновки = КомпоновщикМакета.Выполнить(
			СКД,
			НастройкиСегмента);
			
			ПараметрыПриДинамическомФормировании = МакетКомпоновки.ЗначенияПараметров;
			
			ПодзапросыВыводСегмента = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СКД.НаборыДанных.ВыводСегмента.Запрос,";");
			Если ПодзапросыВыводСегмента.Количество() < 2 Тогда
				Возврат ;
			КонецЕсли;
			
			ТекстЗапросаФормированиеСегмента = МакетКомпоновки.НаборыДанных.ФормированиеСегмента.Запрос;
			ПодзапросыФормированиеСегмента = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТекстЗапросаФормированиеСегмента,";");
			Если ПодзапросыФормированиеСегмента.Количество() > 1 Тогда
				
				ЗапросДляИзменения = ПодзапросыФормированиеСегмента[ПодзапросыФормированиеСегмента.Количество() - 1];
				НайденнаяПозицияИЗ = СтрНайти(ЗапросДляИзменения,"ИЗ");
				Если НайденнаяПозицияИЗ <> 0 Тогда
					ЗапросДляИзменения = Лев(ЗапросДляИзменения,НайденнаяПозицияИЗ - 1) + "  ПОМЕСТИТЬ СоставСегмента
					|  " + Прав(ЗапросДляИзменения,СтрДлина(ЗапросДляИзменения) - НайденнаяПозицияИЗ + 1);
				КонецЕсли;
				
				ТекстЗапросаФормированиеСегмента = "";
				Для инд = 0 По ПодзапросыФормированиеСегмента.Количество() - 2 Цикл
				
					ТекстЗапросаФормированиеСегмента = ТекстЗапросаФормированиеСегмента 
					                                   + ПодзапросыФормированиеСегмента[инд] 
					                                   + Символы.ПС + ";";
				
				КонецЦикла;
				ТекстЗапросаФормированиеСегмента = ТекстЗапросаФормированиеСегмента + ЗапросДляИзменения;
				
			Иначе
				
				НайденнаяПозицияИЗ = СтрНайти(ТекстЗапросаФормированиеСегмента,"ИЗ");
				ТекстПустаяХарактеристика = "";
				Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
					ТекстПустаяХарактеристика = ", ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК Характеристика
					|";
				КонецЕсли;
					
				Если НайденнаяПозицияИЗ <> 0 Тогда
					ТекстЗапросаФормированиеСегмента = Лев(ТекстЗапросаФормированиеСегмента,НайденнаяПозицияИЗ - 1) + ТекстПустаяХарактеристика + "  ПОМЕСТИТЬ СоставСегмента
					|  " + Прав(ТекстЗапросаФормированиеСегмента,СтрДлина(ТекстЗапросаФормированиеСегмента) - НайденнаяПозицияИЗ + 1);
					
				КонецЕсли;
				
			КонецЕсли;
			
			СКД.НаборыДанных.ВыводСегмента.Запрос = ТекстЗапросаФормированиеСегмента + Символы.ПС + ";" + Символы.ПС;
			Для инд = 1 По ПодзапросыВыводСегмента.Количество() - 1 Цикл
				
				СКД.НаборыДанных.ВыводСегмента.Запрос = СКД.НаборыДанных.ВыводСегмента.Запрос + ПодзапросыВыводСегмента[инд] 
				                                        + ?(инд = ПодзапросыВыводСегмента.Количество() - 1,"",Символы.ПС + ";");
				
			КонецЦикла;
			
			СКД.НаборыДанных.ВыводСегмента.АвтоЗаполнениеДоступныхПолей = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если СКД.НаборыДанных.Найти("ВыводСегмента") <> Неопределено Тогда 
		
		НастройкиИсточник = НастройкиСегмента;
		НастройкиПриемник = СКД.ВариантыНастроек.ВыводСегмента.Настройки;
		
		КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(НастройкиПриемник.ПараметрыДанных, НастройкиИсточник.ПараметрыДанных);
		КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(НастройкиПриемник.Отбор, НастройкиИсточник.Отбор);
		
		НаборФормированиеСегмента = СКД.НаборыДанных.Найти("ФормированиеСегмента");
		Если НаборФормированиеСегмента <> Неопределено Тогда
			СКД.НаборыДанных.Удалить(НаборФормированиеСегмента);
		КонецЕсли;
		
		Настройки = НастройкиПриемник;
		
		КомпоновщикНастроекВспомогательный = Новый КомпоновщикНастроекКомпоновкиДанных;
		КомпоновщикНастроекВспомогательный.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД));
		КомпоновщикНастроекВспомогательный.ЗагрузитьНастройки(Настройки);
		КомпоновщикНастроекВспомогательный.Восстановить();
		
		Настройки = КомпоновщикНастроекВспомогательный.Настройки;
		
		Если СегментСсылка.СпособФормирования <>
			Перечисления.СпособыФормированияСегментов.ФормироватьДинамически Тогда
			
			КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(
			Настройки, Новый ПолеКомпоновкиДанных("Сегмент"), СегментСсылка);
			
		КонецЕсли;
		
	Иначе
		
		Настройки = СКД.НастройкиПоУмолчанию;
		
	КонецЕсли;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		СКД,
		Настройки,
		ДанныеРасшифровки);
	
	Если ПараметрыПриДинамическомФормировании <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ПараметрыПриДинамическомФормировании, МакетКомпоновки.ЗначенияПараметров);
	КонецЕсли;
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.НачатьВывод();
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
	ПроцессорВывода.ЗакончитьВывод();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
