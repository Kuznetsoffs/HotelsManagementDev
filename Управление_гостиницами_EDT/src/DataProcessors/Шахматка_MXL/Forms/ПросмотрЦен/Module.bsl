&НаСервере
Функция ПолучитьЦенуСервер(Номер,Дата)

	Возврат УстановкаЦенСервер.ПолучитьЦену(Номер,Дата);

КонецФункции // ПолучитьЦенуСервер()

&НаСервере
Процедура УстановитьЦену(ДанныеТекущейСтроки)
	
	Цена = ПолучитьЦенуСервер(ДанныеТекущейСтроки.Номер,ДанныеТекущейСтроки.ДатаЗаезда);
	ДанныеТекущейСтроки.Цена = Цена;
	ДанныеТекущейСтроки.Сумма = Цена * ДанныеТекущейСТроки.КоличествоДней;

КонецПроцедуры

&НаСервере
Процедура Периодами(Последовательность)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЦеныУслугСрезПоследних.Период КАК Период,
	                      |	ЦеныУслугСрезПоследних.Цена КАК Цена
	                      |ИЗ
	                      |	РегистрСведений.ЦеныУслуг.СрезПоследних(, Услуга = &Номер) КАК ЦеныУслугСрезПоследних
	                      |ИТОГИ ПО
	                      |	Цена,
	                      |	Период ПЕРИОДАМИ(ДЕНЬ, &ДатаЗаезда, &ДатаВыселения)");
	
	Запрос.УстановитьПараметр("Номер",Последовательность.Номер);
	Запрос.УстановитьПараметр("ДатаЗаезда",Последовательность.ДатаЗаезда);
	Запрос.УстановитьПараметр("ДатаВыселения",Последовательность.ДатаВыселения);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка1 = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Период","Все");
	Пока Выборка1.Следующий() Цикл
		Выборка2 = Выборка1.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Цена","Все");
		Пока Выборка2.Следующий() Цикл
		//	ВыборкаПоЦенам = ВыборкаПоНомеру.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Цена","Все");
		//	Пока ВыборкаПоЦенам.Следующий() Цикл
		//		
		//	КонецЦикла;
		КонецЦикла;
		
	
	КонецЦикла;
	
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СтрокиДляЗаполнения = Параметры.СтрокиДляЗаполнения;
	НомерОбласти = 0;
	Для каждого Последовательность Из СтрокиДляЗаполнения Цикл
		//Реквизит для оформления
		СПереселением = Последовательность.Значение.Свойство("СПереселением");
		ДатаВыселения = Неопределено;
		Последовательность.Значение.Свойство("ДатаВыселения",ДатаВыселения);
		
		НомерПоследовательности = Число(СтрЗаменить(Последовательность.Ключ,"Последовательность",""));
		ПоследовательностьЧетный = РаботаСЧисламиКлиентСервер.Четный(НомерПоследовательности);
		Для каждого ДанныеОбъекта Из Последовательность.Значение Цикл
			
			Если СтрНайти(ДанныеОбъекта.Ключ,"Объект") = 0 Тогда
				Продолжить;
			КонецЕсли; 
			//Периодами(ДанныеОбъекта.Значение);
			
			НомерОбласти = НомерОбласти + 1;
			ДанныеДляДобавления = ДанныеОбъекта.Значение;
			ПериодыЦеныНомера = УстановкаЦенСервер.ПериодыЦеныНомера(ДанныеДляДобавления.Номер,ДанныеДляДобавления.ДатаЗаезда,ДанныеДляДобавления.ДатаВыселения);
			НоваяСтрока = ТаблицаРасчета.Добавить();
			НоваяСтрока.НомерОбласти = НомерОбласти;
			НоваяСтрока.Последовательность = Последовательность.Ключ;
			НоваяСтрока.ПоследовательностьЧетный = ПоследовательностьЧетный;
			НоваяСтрока.ОбъектЧетный = РаботаСЧисламиКлиентСервер.Четный(НомерОбласти);
			НоваяСтрока.Пометка = Истина;
			ЗаполнитьЗначенияСвойств(НоваяСтрока,ДанныеДляДобавления);
			НоваяСтрока.КоличествоДней = РаботаСДатамиКлиентСервер.КоличествоДней(ДанныеДляДобавления.ДатаЗаезда,ДанныеДляДобавления.ДатаВыселения);
			
			Если ПериодыЦеныНомера = Неопределено Тогда
				УстановитьЦену(НоваяСтрока);
			Иначе
				Для каждого ДатаЦены Из ПериодыЦеныНомера Цикл
					НоваяСтрока.ДатаВыселения = НачалоДня(НачалоДня(ДатаЦены)-1);
					НоваяСтрока.КоличествоДней = РаботаСДатамиКлиентСервер.КоличествоДней(НоваяСтрока.ДатаЗаезда,ДатаЦены);
					УстановитьЦену(НоваяСтрока);
					НоваяСтрока = ТаблицаРасчета.Добавить();
					НоваяСтрока.НомерОбласти = НомерОбласти;
					НоваяСтрока.Последовательность = Последовательность.Ключ;
					НоваяСтрока.ПоследовательностьЧетный = ПоследовательностьЧетный;
					НоваяСтрока.ОбъектЧетный = РаботаСЧисламиКлиентСервер.Четный(НомерОбласти);
					НоваяСтрока.Пометка = Истина;
					ЗаполнитьЗначенияСвойств(НоваяСтрока,ДанныеДляДобавления);
					НоваяСтрока.ДатаЗаезда = ДатаЦены;
				КонецЦикла;
				НоваяСтрока.КоличествоДней = РаботаСДатамиКлиентСервер.КоличествоДней(НоваяСтрока.ДатаЗаезда,НоваяСтрока.ДатаВыселения);
				УстановитьЦену(НоваяСтрока);
			КонецЕсли; 
			Если СПереселением И НЕ НоваяСТрока.ДатаВыселения = ДатаВыселения ТОгда
				НоваяСтрока.КоличествоДней = НоваяСтрока.КоличествоДней + 1;
				НоваяСтрока.Сумма = НоваяСтрока.КоличествоДней * НоваяСтрока.Цена;
			КонецЕсли;
			
		КонецЦикла;
		//т.к. на шахматке дата выезда не выделяется 
		//то нам необходимо у элементов с максимальной датой увеличить дату на 1 день
		//Это и будет дата выезда в документе
		МассивДатВыездов = РеквизитФормыВЗначение(ТаблицаРасчета,Тип("ТаблицаЗначений")).Скопировать(,"ДатаВыселения").ВыгрузитьКолонку("ДатаВыселения");
		МаксДата = Неопределено;
		Для каждого ДатаВыезда Из МассивДатВыездов Цикл
			
			Если МаксДата = Неопределено Тогда
				МаксДата = ДатаВыезда;
			Иначе
				МаксДата = Макс(МаксДата,ДатаВыезда);
			КонецЕсли; 		
			
		КонецЦикла;
		НоваяДатаВыселения = РаботаСДатамиКлиентСервер.ПрибавитьДень(МаксДата,1);
		НайденыеСтроки = ТаблицаРасчета.НайтиСтроки(Новый Структура("ДатаВыселения,Последовательность",МаксДата, Последовательность.Ключ));
		Для каждого НайденаяСтрока Из НайденыеСтроки Цикл
			//ПериодыЦеныНомера = УстановкаЦенСервер.ПериодыЦеныНомера(НайденаяСтрока.Номер,НайденаяСтрока.ДатаВыселения-1,НоваяДатаВыселения);
			//Если ПериодыЦеныНомера = Неопределено ИЛИ НЕ ПериодыЦеныНомера[ПериодыЦеныНомера.ВГраница()]= НайденаяСтрока.ДатаВыселения Тогда
				НайденаяСтрока.ДатаВыселения = НоваяДатаВыселения;
				НайденаяСтрока.КоличествоДней = НайденаяСтрока.КоличествоДней + 1;
				НайденаяСтрока.Сумма = НайденаяСтрока.КоличествоДней * НайденаяСтрока.Цена;
			//Иначе
			//	НоваяСтрока = ТаблицаРасчета.Вставить(ТаблицаРасчета.Индекс(НайденаяСтрока) + 1);
			//	ЗаполнитьЗначенияСвойств(НоваяСтрока,НайденаяСтрока);
			//	НоваяСтрока.ДатаЗаезда = НоваяСтрока.ДатаВыселения;
			//	НоваяСтрока.ДатаВыселения = НоваяДатаВыселения;
			//	НоваяСтрока.КоличествоДней = 1;
			//	УстановитьЦену(НоваяСтрока);
			//КонецЕсли; 
			
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры
Процедура УстановитьЗаголовокИтого()

	Элементы.ТекстИтого.Заголовок = "Итого: " + Формат(ТаблицаРасчета.Итог("Сумма"),"ЧДЦ=2; ЧГ=3,0")

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
#Если МобильныйКлиент Тогда
	//Элементы.ТаблицаРасчета.Шапка = Ложь; 
    
#КонецЕсли
	Если ЭтаФорма.Параметры.ДействиеПриОткрытии = "Создать" Тогда
		Отказ = Истина;
		МассивПоследовательностей = ПолучитьМассивПоследовательностей();
		ПослеПредупрежденияОСпособеОформлениия(МассивПоследовательностей);
	КонецЕсли;
	УстановитьЗаголовокИтого();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРасчетаПометкаПриИзменении(Элемент)
	ТекущаяСтрокаДанных = ТаблицаРасчета.НайтиПоИдентификатору(Элемент.Родитель.ТекущаяСтрока);
	Отбор = Новый Структура("НомерОбласти", ТекущаяСтрокаДанных.НомерОбласти);
	НайденыеСтроки = ТаблицаРасчета.НайтиСтроки(Отбор);
	Если НайденыеСтроки.Количество() > 1 Тогда
		ЗначениеПереключателя = Элемент.Родитель.ТекущиеДанные.Пометка;
		Для каждого ТекущаяСтрока Из НайденыеСтроки Цикл
			
			ТекущаяСтрока.Пометка = ЗначениеПереключателя;
		
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Функция ПолучитьМассивПоследовательностей(Знач МассивСтрок = Неопределено)
	Если МассивСТрок = Неопределено Тогда
		Отбор = Новый Структура("Пометка",Истина);
		МассивСтрок = ТаблицаРасчета.НайтиСтроки(Отбор);	
	КонецЕсли;
	
	МассивПоследовательностей = Новый Структура;
	Если МассивСтрок.Количество() = 0 Тогда
		Возврат МассивПоследовательностей;
	КонецЕсли;
	ТекПоследовательность = "";
	МассивСтрокПоследовательности = Новый Массив;
	Для каждого ТекущаяСтрока Из МассивСтрок Цикл
		Если НЕ ТекПоследовательность = ТекущаяСтрока.Последовательность Тогда
			Если Не ТекПоследовательность = "" Тогда
				МассивПоследовательностей.Вставить(ТекПоследовательность,МассивСтрокПоследовательности);
				ТекПоследовательность = ТекущаяСтрока.Последовательность;
				МассивСтрокПоследовательности = Новый Массив;
			Иначе
				ТекПоследовательность = ТекущаяСтрока.Последовательность;
			КонецЕсли; 
		КонецЕсли; 
		МассивСтрокПоследовательности.Добавить(ТекущаяСтрока);	
	КонецЦикла;
	МассивПоследовательностей.Вставить(ТекПоследовательность,МассивСтрокПоследовательности);
	
	Возврат МассивПоследовательностей;

КонецФункции // ЕстьНесколькоПоследовательностей()

&НаСервереБезКонтекста
Функция ПолучитьВладельца(Ссылка)

	Возврат Ссылка.Владелец;

КонецФункции


&НаКлиенте
Процедура ЗаполнитьДанные(ДанныеФормы,СтрокиДляДобавления)
	
	Для каждого СтрокаДляДобавления Из СтрокиДляДобавления Цикл
	
		Если НЕ ЗначениеЗаполнено(ДанныеФормы.Гостиница) Тогда
		
			ВладелецНомера = ПолучитьВладельца(СтрокаДляДобавления.Номер);
			Если ТипЗНЧ(ВладелецНомера) = Тип("СправочникСсылка.Гостиницы") Тогда
				ДанныеФормы.Гостиница = ВладелецНомера;
			ИначеЕсли ТипЗНЧ(ВладелецНомера) = Тип("СправочникСсылка.Корпуса") Тогда
				
				ДанныеФормы.Корпус = ВладелецНомера;
				ДанныеФормы.Гостиница = ПолучитьВладельца(ВладелецНомера);
			
			КонецЕсли; 
		    ДанныеФормы.ДатаЗаезда = СтрокаДляДобавления.ДатаЗаезда;
			ДанныеФормы.ДатаВыселения = СтрокаДляДобавления.ДатаВыселения;
			
		Иначе
			ДанныеФормы.ДатаЗаезда = Мин(СтрокаДляДобавления.ДатаЗаезда,ДанныеФормы.ДатаЗаезда);
			ДанныеФормы.ДатаВыселения = Макс(СтрокаДляДобавления.ДатаВыселения,ДанныеФормы.ДатаВыселения);	
		КонецЕсли;
		НоваяСтрока = ДанныеФормы.СоставБрони.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаДляДобавления);
	
	КонецЦикла;
	

КонецПроцедуры


&НаКлиенте
Процедура ПослеПредупрежденияОСпособеОформлениия(МассивПоследовательностей) Экспорт
	
	Для каждого Последовательность Из МассивПоследовательностей Цикл
		ФормаДокумента = ОткрытьФорму("Документ.КарточкаБронирования.Форма.ФормаДокумента",,ЭтаФорма.ВладелецФормы,Последовательность.Ключ);
		ДанныеОбъектаФормы = ФормаДокумента.Объект;
		ЗаполнитьДанные(ДанныеОбъектаФормы,Последовательность.Значение);		
	    КопироватьДанныеФормы(ДанныеОбъектаФормы,ФормаДокумента.Объект);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОформитьБронирования(Команда)
	МассивПоследовательностей = ПолучитьМассивПоследовательностей();
	Если МассивПоследовательностей.Количество() = 0 Тогда
	
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не выделено ни одной строки для оформления";
		Сообщение.Поле = "ТаблицаРасчета[0].Пометка";
		Сообщение.Сообщить(); 
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПредупрежденияОСпособеОформлениия",ЭтаФорма,МассивПоследовательностей);	
		Если МассивПоследовательностей.Количество() = 1 Тогда
			ПослеПредупрежденияОСпособеОформлениия(МассивПоследовательностей);
		Иначе
			ПоказатьПредупреждение(ОписаниеОповещения,"Непоследовательные диапазоны будут оформелены в отдельных документах",,"Внимание!");
		КонецЕсли; 	
		ЭтаФорма.Закрыть(Команда.Имя);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьВыделеные(Команда)
	МассивИДВыделеных = Элементы.ТаблицаРасчета.ВыделенныеСтроки;
	МассивСтрок = Новый Массив;
	Для каждого ИД Из МассивИДВыделеных  Цикл
		МассивСтрок.Добавить(ТаблицаРасчета.НайтиПоИдентификатору(ИД));
	КонецЦикла;
	МассивПоследовательностей = ПолучитьМассивПоследовательностей(МассивСтрок);
	ПослеПредупрежденияОСпособеОформлениия(МассивПоследовательностей);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРасчетаЦенаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ТаблицаРасчета.ТекущиеДанные;
	ТекущиеДанные.Сумма = ТекущиеДанные.Цена * ТекущиеДанные.КоличествоДней;
	УстановитьЗаголовокИтого();
КонецПроцедуры
