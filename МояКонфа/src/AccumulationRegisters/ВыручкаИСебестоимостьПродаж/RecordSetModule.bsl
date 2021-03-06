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
	|	Таблица.Период                            КАК Период,
	|	Таблица.Регистратор                       КАК Регистратор,
	|	Таблица.АналитикаУчетаНоменклатуры        КАК АналитикаУчетаНоменклатуры,
	|	Таблица.АналитикаУчетаПоПартнерам         КАК АналитикаУчетаПоПартнерам,
	|	Таблица.Подразделение                     КАК Подразделение,
	|	Таблица.ТипЗапасов                        КАК ТипЗапасов,
	|	Таблица.ВидЗапасов                        КАК ВидЗапасов,
	|	Таблица.Склад                             КАК Склад,
	|	Таблица.Договор                           КАК Договор,
	|
	|	Таблица.Количество                        КАК Количество,
	|	Таблица.СуммаВыручки                      КАК СуммаВыручки,
	|	Таблица.СуммаВыручкиБезНДС                КАК СуммаВыручкиБезНДС,
	|	Таблица.Стоимость                     	  КАК Стоимость,
	|	Таблица.СтоимостьБезНДС               	  КАК СтоимостьБезНДС,
	|	Таблица.ДопРасходы       				  КАК ДопРасходы,
	|	Таблица.ДопРасходыБезНДС 				  КАК ДопРасходыБезНДС,
	|	Таблица.СтоимостьРегл                 	  КАК СтоимостьРегл,
	|	Таблица.СуммаВыручкиРегл                  КАК СуммаВыручкиРегл,
	|	Таблица.ПостояннаяРазница                 КАК ПостояннаяРазница,
	|	Таблица.ВременнаяРазница                  КАК ВременнаяРазница,
	|	Таблица.СуммаВыручкиСНДСРегл              КАК СуммаВыручкиСНДСРегл,
	|
	|	Таблица.НалогообложениеНДС                КАК НалогообложениеНДС,
	|	Таблица.ВалютаВзаиморасчетов              КАК ВалютаВзаиморасчетов,
	|	Таблица.СуммаВВалютеВзаиморасчетов        КАК СуммаВВалютеВзаиморасчетов,
	|	Таблица.СуммаБезНДСВВалютеВзаиморасчетов  КАК СуммаБезНДСВВалютеВзаиморасчетов,
	|	Таблица.ВалютаДокумента                   КАК ВалютаДокумента,
	|	Таблица.СуммаВВалютеДокумента             КАК СуммаВВалютеДокумента,
	|	Таблица.СуммаБезНДСВВалютеДокумента       КАК СуммаБезНДСВВалютеДокумента
	|ПОМЕСТИТЬ втВыручкаИСебестоимостьПродажПередЗаписью
	|ИЗ
	|	РегистрНакопления.ВыручкаИСебестоимостьПродаж КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|");
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
		
	Перем ДатаДокументаИзменена;
	
	Если ОбменДанными.Загрузка
	 ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено
	 ИЛИ УниверсальныеМеханизмыПартийИСебестоимости.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК Месяц,
	|	Таблица.Организация                  КАК Организация,
	|	Таблица.Регистратор                  КАК Документ
	|ПОМЕСТИТЬ втИзменениеСуммыВыручкиРегл
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПередЗаписью.Период                            КАК Период,
	|		ПередЗаписью.Регистратор                       КАК Регистратор,
	|		КлючиАналитикаУчетаПоПартнерам.Организация     КАК Организация,
	|		
	|		ПередЗаписью.СуммаВыручкиРегл                  КАК СуммаВыручкиРегл
	|	ИЗ
	|		втВыручкаИСебестоимостьПродажПередЗаписью КАК ПередЗаписью
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			РегистрСведений.АналитикаУчетаПоПартнерам КАК КлючиАналитикаУчетаПоПартнерам
	|		ПО
	|			ПередЗаписью.АналитикаУчетаПоПартнерам = КлючиАналитикаУчетаПоПартнерам.КлючАналитики
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПослеЗаписи.Период                            КАК Период,
	|		ПослеЗаписи.Регистратор                       КАК Регистратор,
	|		КлючиАналитикаУчетаПоПартнерам.Организация    КАК Организация,
	|
	|		-ПослеЗаписи.СуммаВыручкиРегл                 КАК СуммаВыручкиРегл
	|	ИЗ
	|		РегистрНакопления.ВыручкаИСебестоимостьПродаж КАК ПослеЗаписи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			РегистрСведений.АналитикаУчетаПоПартнерам КАК КлючиАналитикаУчетаПоПартнерам
	|		ПО
	|			ПослеЗаписи.АналитикаУчетаПоПартнерам = КлючиАналитикаУчетаПоПартнерам.КлючАналитики
	|	ГДЕ
	|		ПослеЗаписи.Регистратор = &Регистратор) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ),
	|	Таблица.Регистратор,
	|	Таблица.Организация
	|	
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.СуммаВыручкиРегл) <> 0
	|;
	|
	|//////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК Месяц,
	|	Таблица.Организация                  КАК Организация,
	|	Таблица.Регистратор                  КАК Документ,
	|	ЛОЖЬ                                 КАК ИзмененыДанныеДляПартионногоУчетаВерсии21
	|ПОМЕСТИТЬ ВыручкаИСебестоимостьПродажЗаданияКРасчетуСебестоимости
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПередЗаписью.Период                            КАК Период,
	|		ПередЗаписью.Регистратор                       КАК Регистратор,
	|		КлючиАналитикаУчетаПоПартнерам.Организация     КАК Организация,
	|		ПередЗаписью.АналитикаУчетаНоменклатуры        КАК АналитикаУчетаНоменклатуры,
	|		ПередЗаписью.АналитикаУчетаПоПартнерам         КАК АналитикаУчетаПоПартнерам,
	|		ПередЗаписью.Подразделение                     КАК Подразделение,
	|		ПередЗаписью.ТипЗапасов                        КАК ТипЗапасов,
	|		ПередЗаписью.ВидЗапасов                        КАК ВидЗапасов,
	|		ПередЗаписью.Склад                             КАК Склад,
	|		ПередЗаписью.Договор                           КАК Договор,
	|
	|		ПередЗаписью.Количество                        КАК Количество,
	|		ПередЗаписью.СуммаВыручки                      КАК СуммаВыручки,
	|		ПередЗаписью.СуммаВыручкиБезНДС                КАК СуммаВыручкиБезНДС,
	|		ПередЗаписью.Стоимость                     	   КАК Стоимость,
	|		ПередЗаписью.СтоимостьБезНДС               	   КАК СтоимостьБезНДС,
	|		ПередЗаписью.ДопРасходы       				   КАК ДопРасходы,
	|		ПередЗаписью.ДопРасходыБезНДС 				   КАК ДопРасходыБезНДС,
	|		ПередЗаписью.СтоимостьРегл                 	   КАК СтоимостьРегл,
	|		ПередЗаписью.СуммаВыручкиРегл                  КАК СуммаВыручкиРегл,
	|		ПередЗаписью.ПостояннаяРазница                 КАК ПостояннаяРазница,
	|		ПередЗаписью.ВременнаяРазница                  КАК ВременнаяРазница,
	|		ПередЗаписью.СуммаВыручкиСНДСРегл              КАК СуммаВыручкиСНДСРегл
	|	ИЗ
	|		втВыручкаИСебестоимостьПродажПередЗаписью КАК ПередЗаписью
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			РегистрСведений.АналитикаУчетаПоПартнерам КАК КлючиАналитикаУчетаПоПартнерам
	|		ПО
	|			ПередЗаписью.АналитикаУчетаПоПартнерам = КлючиАналитикаУчетаПоПартнерам.КлючАналитики
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПослеЗаписи.Период                             КАК Период,
	|		ПослеЗаписи.Регистратор                        КАК Регистратор,
	|		КлючиАналитикаУчетаПоПартнерам.Организация     КАК Организация,
	|		ПослеЗаписи.АналитикаУчетаНоменклатуры         КАК АналитикаУчетаНоменклатуры,
	|		ПослеЗаписи.АналитикаУчетаПоПартнерам          КАК АналитикаУчетаПоПартнерам,
	|		ПослеЗаписи.Подразделение                      КАК Подразделение,
	|		ПослеЗаписи.ТипЗапасов                         КАК ТипЗапасов,
	|		ПослеЗаписи.ВидЗапасов                         КАК ВидЗапасов,
	|		ПослеЗаписи.Склад                              КАК Склад,
	|		ПослеЗаписи.Договор                            КАК Договор,
	|
	|		-ПослеЗаписи.Количество                        КАК Количество,
	|		-ПослеЗаписи.СуммаВыручки                      КАК СуммаВыручки,
	|		-ПослеЗаписи.СуммаВыручкиБезНДС                КАК СуммаВыручкиБезНДС,
	|		-ПослеЗаписи.Стоимость                     	   КАК Стоимость,
	|		-ПослеЗаписи.СтоимостьБезНДС               	   КАК СтоимостьБезНДС,
	|		-ПослеЗаписи.ДопРасходы       				   КАК ДопРасходы,
	|		-ПослеЗаписи.ДопРасходыБезНДС 				   КАК ДопРасходыБезНДС,
	|		-ПослеЗаписи.СтоимостьРегл                 	   КАК СтоимостьРегл,
	|		-ПослеЗаписи.СуммаВыручкиРегл                  КАК СуммаВыручкиРегл,
	|		-ПослеЗаписи.ПостояннаяРазница                 КАК ПостояннаяРазница,
	|		-ПослеЗаписи.ВременнаяРазница                  КАК ВременнаяРазница,
	|		-ПослеЗаписи.СуммаВыручкиСНДСРегл              КАК СуммаВыручкиСНДСРегл
	|	ИЗ
	|		РегистрНакопления.ВыручкаИСебестоимостьПродаж КАК ПослеЗаписи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			РегистрСведений.АналитикаУчетаПоПартнерам КАК КлючиАналитикаУчетаПоПартнерам
	|		ПО
	|			ПослеЗаписи.АналитикаУчетаПоПартнерам = КлючиАналитикаУчетаПоПартнерам.КлючАналитики
	|	ГДЕ
	|		ПослеЗаписи.Регистратор = &Регистратор
	|	) КАК Таблица
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.Организация,
	|	Таблица.АналитикаУчетаНоменклатуры,
	|	Таблица.АналитикаУчетаПоПартнерам,
	|	Таблица.Подразделение,
	|	Таблица.ТипЗапасов,
	|	Таблица.ВидЗапасов,
	|	Таблица.Склад,
	|	Таблица.Договор
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Количество) <> 0
	|	ИЛИ СУММА(Таблица.СуммаВыручки) <> 0
	|	ИЛИ СУММА(Таблица.СуммаВыручкиБезНДС) <> 0
	|	ИЛИ СУММА(Таблица.Стоимость) <> 0
	|	ИЛИ СУММА(Таблица.СтоимостьБезНДС) <> 0
	|	ИЛИ СУММА(Таблица.ДопРасходы) <> 0
	|	ИЛИ СУММА(Таблица.ДопРасходыБезНДС) <> 0
	|	ИЛИ СУММА(Таблица.СтоимостьРегл) <> 0
	|	ИЛИ СУММА(Таблица.СуммаВыручкиРегл) <> 0
	|	ИЛИ СУММА(Таблица.ПостояннаяРазница) <> 0
	|	ИЛИ СУММА(Таблица.ВременнаяРазница) <> 0
	|	ИЛИ СУММА(Таблица.СуммаВыручкиСНДСРегл) <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Месяц                             						КАК Месяц,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.РаспределениеНДС) 	КАК Операция,
	|	Таблица.Организация                       						КАК Организация,
	|	Таблица.Документ                                                КАК Документ
	|ПОМЕСТИТЬ ВыручкаИСебестоимостьПродажЗаданияКЗакрытиюМесяца
	|ИЗ
	|	втИзменениеСуммыВыручкиРегл КАК Таблица
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РаспределениеНДС КАК РаспределениеНДС
	|	ПО
	|		Таблица.Месяц = НАЧАЛОПЕРИОДА(РаспределениеНДС.Дата, МЕСЯЦ)
	|		И Таблица.Организация = РаспределениеНДС.Организация
	|		И РаспределениеНДС.Проведен
	|
	|ОБЪЕДИНИТЬ 
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(КОНЕЦПЕРИОДА(Таблица.Месяц, КВАРТАЛ),	МЕСЯЦ)		КАК Месяц,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.РаспределениеНДС) 	КАК Операция,
	|	Таблица.Организация                       						КАК Организация,
	|	Таблица.Документ                                                КАК Документ
	|ИЗ
	|	втИзменениеСуммыВыручкиРегл КАК Таблица
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РаспределениеНДС КАК РаспределениеНДС
	|	ПО
	|		КОНЕЦПЕРИОДА(Таблица.Месяц, КВАРТАЛ) = КОНЕЦПЕРИОДА(РаспределениеНДС.Дата, МЕСЯЦ)
	|		И Таблица.Организация = РаспределениеНДС.Организация
	|		И РаспределениеНДС.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ втВыручкаИСебестоимостьПродажПередЗаписью
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ втИзменениеСуммыВыручкиРегл
	|");

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
