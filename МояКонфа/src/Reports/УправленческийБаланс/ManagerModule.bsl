#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Проверяет актуальность расчета себестоимости и вслчучае его не акутальности
// выводит предупреждающую надпись в табличном документе отчета
//
// Параметры:
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - Компоновщик настроек отчета
//  ДокументРезультат - ТабличныйДокумент - табличный документ результата отчета
//
Процедура ВывестиАктуальностьОтчета(КомпоновщикНастроек, ДокументРезультат) Экспорт
	
	СписокОрганизаций = ОтчетыУТКлиентСервер.ПолучитьЗначениеОтбора(КомпоновщикНастроек, "Организация");
	МассивОрганизаций = Новый Массив;
	Если ТипЗнч(СписокОрганизаций) = Тип("СписокЗначений") Тогда
		МассивОрганизаций = СписокОрганизаций.ВыгрузитьЗначения();
	КонецЕсли;
	
	ПериодОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ПериодОтчета").Значение;
	
	СостояниеРасчета = УниверсальныеМеханизмыПартийИСебестоимости.ТекущееСостояниеРасчета(ПериодОтчета.ДатаОкончания, МассивОрганизаций);
	ВыполненоРаспределениеВзаиморасчетов = ВзаиморасчетыАктуальны(МассивОрганизаций, ПериодОтчета);
		
	ТекстПредупреждения = "";
	УстановитьПривилегированныйРежим(Истина);
	ЗаполненыДвиженияАктивовПассивов = Константы.ЗаполненыДвиженияАктивовПассивов.Получить();
	Если НЕ ЗаполненыДвиженияАктивовПассивов Тогда
		ТекстПредупреждения = НСтр("ru ='Для работы отчета после обновления конфигурации на новую редакцию требуется выполнить первоначальное заполнение данных по статьям активов и пассивов.
								|Для этого необходимо выполнить одноименную команду из раздела НСИ и администрирование - Финансовый результат и контроллинг.'");
	ИначеЕсли СостояниеРасчета = Перечисления.СостоянияОперацийЗакрытияМесяца.ВыполненоСОшибками
	 ИЛИ СостояниеРасчета = Перечисления.СостоянияОперацийЗакрытияМесяца.НеВыполнено
	 ИЛИ НЕ ВыполненоРаспределениеВзаиморасчетов Тогда
		ТекстПредупреждения = НСтр("ru ='Данные отчета могут быть не актуальны, так как выполнены не все этапы закрытия месяца, влияющие на финансовый результат в управленческом учете.'");
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ТекстПредупреждения) Тогда
		ТаблицаПредупреждение = Новый ТабличныйДокумент;
		ОбластьПредупреждение = ТаблицаПредупреждение.Область(1,1,1,1);
		ОбластьПредупреждение.Текст = ТекстПредупреждения;
		ОбластьПредупреждение.ЦветТекста = ЦветаСтиля.ЦветОтрицательногоЧисла;
		ДокументРезультат.ВставитьОбласть(ОбластьПредупреждение, ДокументРезультат.Область(1,1,1,1), ТипСмещенияТабличногоДокумента.ПоВертикали);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


Функция ВзаиморасчетыАктуальны(Организации, ПериодОтчета)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Расчеты.АналитикаУчетаПоПартнерам
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами КАК Расчеты
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаПоПартнерам КАК Аналитики
	|	ПО Расчеты.АналитикаУчетаПоПартнерам = Аналитики.Ссылка
	|ГДЕ
	|	Расчеты.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|	И (Аналитики.Организация В (&МассивОрганизаций) ИЛИ &ПоВсемОрганизациям)
	|	И Расчеты.Активность
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Расчеты.АналитикаУчетаПоПартнерам
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК Расчеты
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаПоПартнерам КАК Аналитики
	|	ПО Расчеты.АналитикаУчетаПоПартнерам = Аналитики.Ссылка
	|ГДЕ
	|	Расчеты.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|	И (Аналитики.Организация В (&МассивОрганизаций) ИЛИ &ПоВсемОрганизациям)
	|	И Расчеты.Активность";
	
	Запрос.УстановитьПараметр("НачалоПериода", ПериодОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ПериодОтчета.ДатаОкончания);
	Запрос.УстановитьПараметр("МассивОрганизаций", Организации);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", НЕ ЗначениеЗаполнено(Организации));
	
	АналитикиРасчета = РаспределениеВзаиморасчетовВызовСервера.АналитикиРасчета();
	АналитикиРасчета.Организации = Организации;
	
	НачалоРасчета = РаспределениеВзаиморасчетовВызовСервера.НачалоРасчетов(КонецМесяца(ПериодОтчета.ДатаОкончания), АналитикиРасчета);
	
	ЕстьДвиженияПоРасчетам = НЕ Запрос.Выполнить().Пустой();
	ПериодВДиапазонеПересчета = (ЗначениеЗаполнено(НачалоРасчета) И НачалоРасчета <= ПериодОтчета.ДатаОкончания);

	Возврат (ЕстьДвиженияПоРасчетам И НЕ ПериодВДиапазонеПересчета) ИЛИ НЕ ЕстьДвиженияПоРасчетам;
	
КонецФункции
	
#КонецЕсли