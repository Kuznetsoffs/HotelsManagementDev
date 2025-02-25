
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ИмяОбработки = "ЗагрузкаКлассификатораБанков";
	ЕстьИсточникЗагрузкиДанных = Метаданные.Обработки.Найти(ИмяОбработки) <> Неопределено;
	
	//МожноОбновлятьКлассификатор = ПравоДоступа("Изменение", Метаданные.Справочники.КлассификаторБанков);
	
	Элементы.ФормаЗагрузитьКлассификатор.Видимость = ЕстьИсточникЗагрузкиДанных;
	
	//Если Не Пользователи.ЭтоПолноправныйПользователь() Или Не МожноОбновлятьКлассификатор Тогда
	//	ТолькоПросмотр = Истина;
	//КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьКлассификатор(Команда)
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеятельностьПрекращена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

#КонецОбласти