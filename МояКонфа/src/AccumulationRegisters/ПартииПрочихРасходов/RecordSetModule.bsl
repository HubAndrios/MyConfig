#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
	 ИЛИ УниверсальныеМеханизмыПартийИСебестоимости.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	УниверсальныеМеханизмыПартийИСебестоимости.СохранитьДвиженияСформированныеРасчетомПартийИСебестоимости(ЭтотОбъект, Замещение);
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено
	 ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПартииРасходов.Период                       КАК Период,
	|	ПартииРасходов.Регистратор                  КАК Регистратор,
	|	ПартииРасходов.Организация                  КАК Организация,
	|	ПартииРасходов.Подразделение                КАК Подразделение,
	|	ПартииРасходов.СтатьяРасходов               КАК СтатьяРасходов,
	|	ПартииРасходов.АналитикаРасходов            КАК АналитикаРасходов,
	|	ПартииРасходов.АналитикаАктивовПассивов     КАК АналитикаАктивовПассивов,
	|	ПартииРасходов.ДокументПоступленияРасходов  КАК ДокументПоступленияРасходов,
	|	ПартииРасходов.АналитикаУчетаПартий         КАК АналитикаУчетаПартий,
	|	ПартииРасходов.НаправлениеДеятельности      КАК НаправлениеДеятельности,
	|	ПартииРасходов.АналитикаУчетаНоменклатуры   КАК АналитикаУчетаНоменклатуры,
	|	ПартииРасходов.ВидДеятельностиНДС           КАК ВидДеятельностиНДС,
	|	ПартииРасходов.Стоимость                    КАК Стоимость,
	|	ПартииРасходов.СтоимостьБезНДС              КАК СтоимостьБезНДС,
	|	ПартииРасходов.СтоимостьРегл                КАК СтоимостьРегл,
	|	ПартииРасходов.НДСРегл                      КАК НДСРегл,
	|	ПартииРасходов.ПостояннаяРазница            КАК ПостояннаяРазница,
	|	ПартииРасходов.ВременнаяРазница             КАК ВременнаяРазница,
	|	ПартииРасходов.НДСУпр                       КАК НДСУпр
	|
	|ПОМЕСТИТЬ ПартииПрочихРасходовПередЗаписью
	|ИЗ
	|	РегистрНакопления.ПартииПрочихРасходов КАК ПартииРасходов
	|ГДЕ
	|	ПартииРасходов.Регистратор = &Регистратор
	|	И ПартииРасходов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|");
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
	 ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено
	 ИЛИ УниверсальныеМеханизмыПартийИСебестоимости.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Период                           КАК Период,
	|	Таблица.Регистратор                      КАК Регистратор,
	|	Таблица.Подразделение                    КАК Подразделение,
	|	Таблица.Организация                      КАК Организация,
	|	Таблица.СтатьяРасходов                   КАК СтатьяРасходов,
	|	Таблица.ВариантРаспределенияРасходовУпр  КАК ВариантРаспределенияРасходовУпр,
	|	Таблица.ВариантРаспределенияРасходовРегл КАК ВариантРаспределенияРасходовРегл,
	|	Таблица.ВидЦенностиНДС                   КАК ВидЦенностиНДС,
	|	Таблица.АналитикаРасходов                КАК АналитикаРасходов,
	|	Таблица.ДокументПоступленияРасходов      КАК ДокументПоступленияРасходов,
	|	Таблица.АналитикаУчетаПартий             КАК АналитикаУчетаПартий,
	|	Таблица.АналитикаУчетаНоменклатуры       КАК АналитикаУчетаНоменклатуры,
	|	Таблица.НаправлениеДеятельности          КАК НаправлениеДеятельности,
	|	Таблица.ВидДеятельностиНДС               КАК ВидДеятельностиНДС,
	|	СУММА(Таблица.Стоимость)                 КАК Стоимость,
	|	СУММА(Таблица.СтоимостьБезНДС)           КАК СтоимостьБезНДС,
	|	СУММА(Таблица.СтоимостьРегл)             КАК СтоимостьРегл,
	|	СУММА(Таблица.НДСРегл)                   КАК НДСРегл,
	|	СУММА(Таблица.ПостояннаяРазница)         КАК ПостояннаяРазница,
	|	СУММА(Таблица.ВременнаяРазница)          КАК ВременнаяРазница,
	|	СУММА(Таблица.НДСУпр)                    КАК НДСУпр
	|ПОМЕСТИТЬ втПартийПрочихРасходовРазница
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Период                         			КАК Период,
	|		Таблица.Регистратор                     		КАК Регистратор,
	|		Таблица.Подразделение                   		КАК Подразделение,
	|		Таблица.Организация                     		КАК Организация,
	|		Таблица.СтатьяРасходов                  		КАК СтатьяРасходов,
	|		СтатьиРасходов.ВариантРаспределенияРасходовУпр 	КАК ВариантРаспределенияРасходовУпр,
	|		СтатьиРасходов.ВариантРаспределенияРасходовРегл КАК ВариантРаспределенияРасходовРегл,
	|		СтатьиРасходов.ВидЦенностиНДС           		КАК ВидЦенностиНДС,
	|		Таблица.АналитикаРасходов               		КАК АналитикаРасходов,
	|		Таблица.ДокументПоступленияРасходов     		КАК ДокументПоступленияРасходов,
	|		Таблица.АналитикаУчетаПартий            		КАК АналитикаУчетаПартий,
	|		Таблица.АналитикаУчетаНоменклатуры      		КАК АналитикаУчетаНоменклатуры,
	|		Таблица.НаправлениеДеятельности      			КАК НаправлениеДеятельности,
	|		Таблица.ВидДеятельностиНДС          			КАК ВидДеятельностиНДС,
	|		Таблица.Стоимость                               КАК Стоимость,
	|		Таблица.СтоимостьБезНДС                         КАК СтоимостьБезНДС,
	|		Таблица.СтоимостьРегл                   		КАК СтоимостьРегл,
	|		Таблица.НДСРегл                         		КАК НДСРегл,
	|		Таблица.ПостояннаяРазница                       КАК ПостояннаяРазница,
	|		Таблица.ВременнаяРазница                        КАК ВременнаяРазница,
	|		Таблица.НДСУпр                         			КАК НДСУпр
	|	ИЗ
	|		ПартииПрочихРасходовПередЗаписью КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиРасходов
	|		ПО
	|			Таблица.СтатьяРасходов =  СтатьиРасходов.Ссылка
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПартииРасходов.Период                       	КАК Период,
	|		ПартииРасходов.Регистратор                  	КАК Регистратор,
	|		ПартииРасходов.Подразделение                	КАК Подразделение,
	|		ПартииРасходов.Организация                  	КАК Организация,
	|		ПартииРасходов.СтатьяРасходов               	КАК СтатьяРасходов,
	|		СтатьиРасходов.ВариантРаспределенияРасходовУпр 	КАК ВариантРаспределенияРасходовУпр,
	|		СтатьиРасходов.ВариантРаспределенияРасходовРегл КАК ВариантРаспределенияРасходовРегл,
	|		СтатьиРасходов.ВидЦенностиНДС               	КАК ВидЦенностиНДС,
	|		ПартииРасходов.АналитикаРасходов            	КАК АналитикаРасходов,
	|		ПартииРасходов.ДокументПоступленияРасходов  	КАК ДокументПоступленияРасходов,
	|		ПартииРасходов.АналитикаУчетаПартий         	КАК АналитикаУчетаПартий,
	|		ПартииРасходов.АналитикаУчетаНоменклатуры   	КАК АналитикаУчетаНоменклатуры,
	|		ПартииРасходов.НаправлениеДеятельности      	КАК НаправлениеДеятельности,
	|		ПартииРасходов.ВидДеятельностиНДС           	КАК ВидДеятельностиНДС,
	|		-ПартииРасходов.Стоимость                       КАК Стоимость,
	|		-ПартииРасходов.СтоимостьБезНДС                 КАК СтоимостьБезНДС,
	|		-ПартииРасходов.СтоимостьРегл               	КАК СтоимостьРегл,
	|		-ПартииРасходов.НДСРегл                    		КАК НДСРегл,
	|		-ПартииРасходов.ПостояннаяРазница               КАК ПостояннаяРазница,
	|		-ПартииРасходов.ВременнаяРазница                КАК ВременнаяРазница,
	|		-ПартииРасходов.НДСУпр                         	КАК НДСУпр
	|	ИЗ
	|		РегистрНакопления.ПартииПрочихРасходов КАК ПартииРасходов
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиРасходов
	|		ПО
	|			ПартииРасходов.СтатьяРасходов =  СтатьиРасходов.Ссылка
	|	ГДЕ
	|		ПартииРасходов.Регистратор = &Регистратор
	|		И ПартииРасходов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|
	|) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.Организация,
	|	Таблица.Подразделение,
	|	Таблица.СтатьяРасходов,
	|	Таблица.ВариантРаспределенияРасходовУпр,
	|	Таблица.ВариантРаспределенияРасходовРегл,
	|	Таблица.ВидЦенностиНДС,
	|	Таблица.АналитикаРасходов,
	|	Таблица.ДокументПоступленияРасходов,
	|	Таблица.АналитикаУчетаПартий,
	|	Таблица.АналитикаУчетаНоменклатуры,
	|	Таблица.НаправлениеДеятельности,
	|	Таблица.ВидДеятельностиНДС
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Стоимость) <> 0
	|	ИЛИ СУММА(Таблица.СтоимостьБезНДС) <> 0
	|	ИЛИ СУММА(Таблица.СтоимостьРегл) <> 0
	|	ИЛИ СУММА(Таблица.НДСРегл) <> 0
	|	ИЛИ СУММА(Таблица.ПостояннаяРазница) <> 0
	|	ИЛИ СУММА(Таблица.ВременнаяРазница) <> 0
	|	ИЛИ СУММА(Таблица.НДСУпр) <> 0
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК МЕСЯЦ,
	|	Таблица.Организация                  КАК Организация,
	|	Таблица.Регистратор                  КАК Документ,
	|	ЛОЖЬ                                 КАК ИзмененыДанныеДляПартионногоУчетаВерсии21
	|ПОМЕСТИТЬ ПартииПрочихРасходовЗаданияКРасчетуСебестоимости
	|ИЗ
	|	втПартийПрочихРасходовРазница КАК Таблица
	|	
	|ГДЕ
	|	Таблица.ВариантРаспределенияРасходовУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|	ИЛИ Таблица.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(КОНЕЦПЕРИОДА(Таблица.Период, КВАРТАЛ), МЕСЯЦ)    КАК Месяц,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.РаспределениеНДС) КАК Операция,
	|	Таблица.Организация    КАК Организация,
	|	Таблица.Регистратор    КАК Документ
	|ПОМЕСТИТЬ ПартииПрочихРасходовЗаданияКЗакрытиюМесяца
	|ИЗ
	|	втПартийПрочихРасходовРазница КАК Таблица
	|ГДЕ
	|	ЕСТЬNULL(Таблица.ВариантРаспределенияРасходовРегл, НЕОПРЕДЕЛЕНО) <> ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПартииПрочихРасходовПередЗаписью
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ втПартийПрочихРасходовРазница
	|");
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
