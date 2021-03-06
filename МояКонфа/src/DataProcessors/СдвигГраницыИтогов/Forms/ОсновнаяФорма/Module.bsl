#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	Если Не УправлениеИтогамиИАгрегатамиСлужебный.НадоСдвинутьГраницуИтогов() Тогда
		Отказ = Истина; // Период уже был установлен в сеансе другого пользователя.
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДлительнаяОперация = ДлительнаяОперацияЗапускСервер(УникальныйИдентификатор);
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
	
	Обработчик = Новый ОписаниеОповещения("ДлительнаяОперацияЗавершениеКлиент", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, НастройкиОжидания);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ДлительнаяОперацияЗапускСервер(УникальныйИдентификатор)
	ИмяМетода = "Обработки.СдвигГраницыИтогов.ВыполнитьКоманду";
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Итоги и агрегаты: Ускорение проведения документов и формирования отчетов'");
	НастройкиЗапуска.ОжидатьЗавершение = 0;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, Неопределено, НастройкиЗапуска);
КонецФункции

&НаКлиенте
Процедура ДлительнаяОперацияЗавершениеКлиент(Операция, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры = Новый Структура("Результат", Ложь);
	Обработчик = Новый ОписаниеОповещения("ДлительнаяОперацияПослеВыводаРезультата", ЭтотОбъект, ДополнительныеПараметры);
	Если Операция = Неопределено Тогда
		ВыполнитьОбработкуОповещения(Обработчик);
	Иначе
		Если Операция.Статус = "Выполнено" Тогда
			ПоказатьОповещениеПользователя(НСтр("ru = 'Оптимизация успешно завершена'"),,, БиблиотекаКартинок.Успешно32);
			ДополнительныеПараметры.Результат = Истина;
			ВыполнитьОбработкуОповещения(Обработчик);
		Иначе
			Предупреждение = Новый Структура();
			Предупреждение.Вставить("Текст", Операция.КраткоеПредставлениеОшибки);
			Предупреждение.Вставить("Подробно", Операция.ПодробноеПредставлениеОшибки);
			СтандартныеПодсистемыКлиент.ВывестиПредупреждение(ЭтотОбъект, Предупреждение, Обработчик);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДлительнаяОперацияПослеВыводаРезультата(Результат, ДополнительныеПараметры) Экспорт
	Если ОписаниеОповещенияОЗакрытии <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗакрытии, ДополнительныеПараметры.Результат); // Обход особенности вызова из ПриОткрытии.
	КонецЕсли;
	Если Открыта() Тогда
		Закрыть(ДополнительныеПараметры.Результат);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти