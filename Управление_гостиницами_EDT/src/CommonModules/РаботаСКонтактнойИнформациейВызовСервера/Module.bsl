Функция ПолучитьВЛадельцаКО(РеквизитКО,Значение)   Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КонтактнаяИнформация.Владелец КАК Владелец
		|ИЗ
		|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация." + РеквизитКО + " = &ЗначениеРеквизита";
	
	Запрос.УстановитьПараметр("ЗначениеРеквизита", ЗНачение);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Владелец")[0];
	КонецЕсли; 
	


КонецФункции // ПолучитьВЛадельцаКО()
Функция ПолучитьЗначенияКО(Владелец) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КонтактнаяИнформация.ЭлектроннаяПочта КАК ЭлектроннаяПочта,
		|	КонтактнаяИнформация.НомерСохраненный КАК Телефон
		|ИЗ
		|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", Владелец);
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаРезультата = РезультатЗапроса.Выгрузить();
	
	Результат = Новый Структура;
	Для каждого Колонка Из ТаблицаРезультата.Колонки Цикл
		Результат.Вставить(Колонка.Имя);	
	КонецЦикла;
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ЗаполнитьЗначенияСВойств(Результат,ТаблицаРезультата[0]);
	КонецЕсли;
	Возврат Результат;


КонецФункции // ПолучитьЗначенияКО()

