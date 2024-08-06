
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РучноеИзменение = Ложь;
	ВКлассификаторе = Ложь;
	БИК			 = "";
	КоррСчет	 = "";
	Наименование = "";
	Город		 = "";
	Адрес		 = "";
	Телефоны	 = "";
	
	Если Не Параметры.Свойство("РучноеИзменение") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	РучноеИзменение = Параметры.РучноеИзменение;
	РеквизитВладельца = Параметры.Реквизит;
	
	Если Параметры.ЗначенияПолей.Свойство("БИК") Тогда
		БИК = Параметры.ЗначенияПолей.БИК;
	КонецЕсли;
	
	Если Параметры.ЗначенияПолей.Свойство("КоррСчет") Тогда
		КоррСчет = Параметры.ЗначенияПолей.КоррСчет;
	КонецЕсли;
	
	Если ПустаяСтрока(РучноеИзменение) Тогда
		РучноеИзменение = Ложь;
	КонецЕсли;
	
	ДеятельностьБанкаПрекращена = Ложь;
	Если РучноеИзменение Тогда
		БИК			 = Параметры.ЗначенияПолей.БИК;
		КоррСчет	 = Параметры.ЗначенияПолей.КоррСчет;
		Наименование = Параметры.ЗначенияПолей.Наименование;
		Город		 = Параметры.ЗначенияПолей.Город;
		Адрес		 = Параметры.ЗначенияПолей.Адрес;
		Телефоны	 = Параметры.ЗначенияПолей.Телефоны;
	Иначе
		Банк = Параметры.Банк;
		Если ТипЗнч(Банк) = Тип("СправочникСсылка.КлассификаторБанков") Тогда
			БИК				= Банк.Код;
			КоррСчет		= Банк.КоррСчет;
			Наименование	= Банк.Наименование;
			Город			= Банк.Город;
			Адрес			= Банк.Адрес;
			Телефоны		= Банк.Телефоны;
			ВКлассификаторе = Истина;
			ДеятельностьБанкаПрекращена = Банк.ДеятельностьПрекращена;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.НадписьДеятельностьБанкаПрекращена.Видимость = ДеятельностьБанкаПрекращена;
	КлючСохраненияПоложенияОкна = "ДеятельностьБанкаПрекращена=" + Строка(ДеятельностьБанкаПрекращена);
	
	ОбработатьФлагРучногоИзменения();
	УстановитьВидимостьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПринятьИзмененияЗакрытьФорму(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	
	Закрыть();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Модифицированность = Ложь;
	ОповеститьОВыборе(ПолучитьЗначенияПараметров());
	
КонецПроцедуры

Процедура ОбработатьФлагРучногоИзменения()
	
	Если РучноеИзменение Тогда
		Элементы.ПоясняющийТекст.Заголовок = НСтр("ru = 'Автоматическое обновление элемента отключено.'");
		ТолькоПросмотр = Ложь;
	Иначе
		Если ВКлассификаторе Тогда
			Элементы.ПоясняющийТекст.Заголовок = НСтр("ru = 'Элемент обновляется автоматически.'");
			ТолькоПросмотр = Истина;
		Иначе
			Элементы.ПоясняющийТекст.Заголовок = НСтр("ru = 'Элемент не найден в классификаторе.Автоматическое обновление элемента отключено.'");
			ТолькоПросмотр = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗначенияПараметров()
	
	Результат = Новый Структура;
	Результат.Вставить("Реквизит", РеквизитВладельца);

	
	Если РучноеИзменение Тогда
		Результат.Вставить("РучноеИзменение", РучноеИзменение);
		ЗначенияПолей = Новый Структура;
		ЗначенияПолей.Вставить("БИК", БИК);
		ЗначенияПолей.Вставить("Наименование", Наименование);
		ЗначенияПолей.Вставить("КоррСчет", КоррСчет);
		ЗначенияПолей.Вставить("Город", Город);
		ЗначенияПолей.Вставить("Адрес", Адрес);
		ЗначенияПолей.Вставить("Телефоны", Телефоны);
		ЗначенияПолей.Вставить("РучноеИзменение", РучноеИзменение);
		
		Результат.Вставить("ЗначенияПолей", ЗначенияПолей);
	Иначе
		Если ВКлассификаторе Тогда
			Результат.Вставить("РучноеИзменение", РучноеИзменение);
			Результат.Вставить("Банк", Банк);
		Иначе 
			Результат.Вставить("РучноеИзменение", Истина);
			ЗначенияПолей = Новый Структура;
			ЗначенияПолей.Вставить("БИК", БИК);
			ЗначенияПолей.Вставить("Наименование", Наименование);
			ЗначенияПолей.Вставить("КоррСчет", КоррСчет);
			ЗначенияПолей.Вставить("Город", Город);
			ЗначенияПолей.Вставить("Адрес", Адрес);
			ЗначенияПолей.Вставить("Телефоны", Телефоны);
			ЗначенияПолей.Вставить("РучноеИзменение", РучноеИзменение);
			
			Результат.Вставить("ЗначенияПолей", ЗначенияПолей);
		КонецЕсли;
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьКоманд()

	Если РучноеИзменение Тогда
		Элементы.ФормаКомандаЗакрыть.Видимость = Ложь;
	Иначе
		Элементы.ФормаКомандаОК.Видимость = Ложь;
		Элементы.ФормаКомандаОтмена.Видимость = Ложь;
		Элементы.ФормаКомандаЗакрыть.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
