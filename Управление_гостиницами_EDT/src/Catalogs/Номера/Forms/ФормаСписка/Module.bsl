//&НаСервере
//Процедура УстановитьПараметрыОтбора(Отбор)
//	
//	Для каждого ПолеОтбора Из Отбор Цикл
//		ТекПараметр = ПолеОтбора.Ключ;
//		ТекЗначение = ПолеОтбора.Значение;
//				
//		ЭлементОтбора = Список.Отбор.Элементы.Добавить(ТИП("ЭлементОтбораКомпоновкиДанных"));
//		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
//		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ТекПараметр);
//		ЭлементОтбора.ПравоеЗначение = ТекЗначение;		
//	КонецЦикла;

//КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//УстановитьПараметрыОтбора(Параметры.Отбор);	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры
