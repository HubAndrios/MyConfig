
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	БольшеНеСпрашивать = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	Если БольшеНеСпрашивать = Истина Тогда
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
			"НастройкиОткрытияФайлов", "СпрашиватьРежимРедактированияПриОткрытииФайла", Ложь,,, Истина);
	КонецЕсли;
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("БольшеНеСпрашивать", БольшеНеСпрашивать);
	РезультатВыбора.Вставить("КакОткрывать", КакОткрывать);
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	ОповеститьОВыборе(КодВозвратаДиалога.Отмена);
КонецПроцедуры

#КонецОбласти
