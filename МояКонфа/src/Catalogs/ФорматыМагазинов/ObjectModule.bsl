#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
		
	МассивНепроверяемыхРеквизитов = Новый Массив;

	Если НЕ ЭтоГруппа Тогда
		
		Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен") Тогда
			МассивНепроверяемыхРеквизитов.Добавить("РозничныйВидЦены");
		КонецЕсли;
		
	КонецЕсли;
	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

#КонецЕсли