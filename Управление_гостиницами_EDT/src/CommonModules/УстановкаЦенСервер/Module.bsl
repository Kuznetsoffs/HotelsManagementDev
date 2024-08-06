

Функция ПолучитьЦену(Номер,Дата) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЦеныУслугСрезПоследних.Цена КАК Цена
		|ИЗ
		|	РегистрСведений.ЦеныУслуг.СрезПоследних(НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ), Услуга = &Номер) КАК ЦеныУслугСрезПоследних";
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Номер", Номер);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат 0;
	Иначе
		Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Цена")[0];	
	КонецЕсли; 
		


КонецФункции // ПолучитьЦену()

Функция ПериодыЦеныНомера(Номер,НачДата,КонДата) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЦеныУслуг.Период КАК Период
		|ИЗ
		|	РегистрСведений.ЦеныУслуг КАК ЦеныУслуг
		|ГДЕ
		|	ЦеныУслуг.Услуга = &Номер
		|	И ЦеныУслуг.Период МЕЖДУ &НачДата И &КонДата";
	
	Запрос.УстановитьПараметр("Номер", Номер);
	Запрос.УстановитьПараметр("НачДата", КонецДня(НачДата));
	Запрос.УстановитьПараметр("КонДата", НачалоДня(КонДата));
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Период");
	КонецЕсли;

КонецФункции // ПериодыЦеныНомера()
