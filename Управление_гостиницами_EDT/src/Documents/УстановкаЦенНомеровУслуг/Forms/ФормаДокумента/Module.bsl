
#Область ОписаниеПеременных
&НаСервере
Перем СоответствиеИнтервалаИменамКолонок;
#КонецОбласти
#Область Служебные

&НаСервереБезКонтекста
Функция ЭтоКомплекс(Гостиница)

	Возврат Гостиница.ГостиничныйКомплекс;	

КонецФункции // ЭтоКомплекс()	

Процедура УправлениеДоступностью()
		
	Если ЗначениеЗаполнено(Объект.Гостиница) Тогда
		ДоступностьКорпуса = ЭтоКомплекс(Объект.Гостиница);
	Иначе
		ДоступностьКорпуса = Ложь;
		
	КонецЕсли; 
	Элементы.Корпус.Доступность = ДоступностьКорпуса;
	
КонецПроцедуры

Процедура УправлениеПараметрамиВыбора()
	
	МасивПараметров = Новый Массив();
	МасивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец",Объект.Гостиница));
	Элементы.Корпус.ПараметрыВыбора = Новый ФиксированныйМассив(МасивПараметров);
	
	Если ЗначениеЗаполнено(Объект.Гостиница) Тогда
		Если НЕ ЭтоКомплекс(Объект.Гостиница) Тогда
		    Владелец  = Объект.Гостиница;
		ИначеЕсли ЗначениеЗаполнено(Объект.Корпус) Тогда
			Владелец = Объект.Корпус;
		Иначе
			Владелец = Справочники.Корпуса.ПустаяСсылка();
		КонецЕсли; 	
		МасивПараметров = Новый Массив();
		МасивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец",Владелец));
	КонецЕсли; 
	

КонецПроцедуры

Процедура ЗаполнитьТаблицуНомеров(Владелец)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номера.Ссылка КАК ОбъектЦены,
		|	0 КАК Цена
		|ИЗ
		|	Справочник.Номера КАК Номера
		|ГДЕ
		|	Номера.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", Владелец);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
	
		ЗначениеВРеквизитФормы(РезультатЗапроса.Выгрузить(),"СтарыйТаблицаЦенНомеров");
	
	КонецЕсли; 
	УстановитьЗаголовкиЗакладок("Номера");
	
КонецПроцедуры

Функция УстановитьЗаголовкиЗакладок(Закладка = Неопределено)

	Если Закладка = "Номера" ИЛИ Закладка = Неопределено Тогда
		
		КоличествоСтрок = СтарыйТаблицаЦенНомеров.Количество();
		Элементы.СтраницаЦенНомеров.Заголовок = "Номера" + ?(КоличествоСтрок = 0, "", " (" + КоличествоСтрок + ")");
	
	КонецЕсли; 
	
	Если Закладка = "ДополнительныеУслуги" ИЛИ Закладка = Неопределено Тогда
	
		КоличествоСтрок = СтарыйТаблицаЦенДопУслуг.Количество();
		Элементы.СтраницаЦенДопУслуг.Заголовок = "Дополнительные услуги" + ?(КоличествоСтрок = 0, "", " (" + КоличествоСтрок + ")");	
	
	КонецЕсли; 
	

КонецФункции // УстановитьЗаголовкиЗакладок()

Процедура УстановитьВидимостьЭлементовФормы()

	Если НЕ Объект.СтарыйЦены.Количество() = 0 Тогда
	
		Элементы.СтарыйСтраницыЦен.Видимость = Истина;
		Элементы.СтраницыНастройкаИУстановкаЦен.Видимость = Ложь;
	
	КонецЕсли; 

КонецПроцедуры

Процедура УстановитьРедактированиеРеквизитовДляДстарыхДокументов()

	Если НЕ Объект.СтарыйЦены.Количество() = 0 Тогда
		Элементы.Гостиница.ТолькоПросмотр = Истина;
		Элементы.Корпус.ТолькоПросмотр = Истина;
	КонецЕсли
	

КонецПроцедуры

Функция ИмяКолонкиПоИнтервалу(Интервал)
	
	Значение = СоответствиеИнтервалаИменамКолонок.Получить(Интервал);
	Если Значение = Неопределено Тогда
	    Значение = "Интервал" + СтрЗаменить(Интервал.УникальныйИдентификатор(),"-","");
		СоответствиеИнтервалаИменамКолонок.Вставить(Интервал,Значение);
	КонецЕсли;
	Возврат Значение;
	
КонецФункции // ИмяКолонкиПоВидуИнтервала()

Функция СтруктураСвойствПоля()
	
	СвойстваПоля = Новый Структура;
	СвойстваПоля.Вставить("Имя", "");
	СвойстваПоля.Вставить("Заголовок", "");
	СвойстваПоля.Вставить("ШиринаПоля", 0);
	СвойстваПоля.Вставить("ЦветФона", Неопределено);
	СвойстваПоля.Вставить("ЦветФонаЗаголовка", Неопределено);
	СвойстваПоля.Вставить("Родитель", Неопределено);
	СвойстваПоля.Вставить("КартинкаШапки", Неопределено);
	СвойстваПоля.Вставить("ПутьКДанным", Неопределено);
	СвойстваПоля.Вставить("ТолькоПросмотрПоля", Истина);
	СвойстваПоля.Вставить("СвязиПараметровВыбора", Неопределено);
	СвойстваПоля.Вставить("ОбработчикПриИзменении", "");
	СвойстваПоля.Вставить("ОбработчикНачалоВыбора", "");
	
	Возврат СвойстваПоля;
КонецФункции

Функция ДобавитьПолеФормы(СвойстваПоля)

	РодительЭлемента = СвойстваПоля.Родитель;
	Если ТипЗнч(РодительЭлемента) = Тип("ТаблицаФормы") Тогда
		ИмяРодителя = РодительЭлемента.Имя;
	Иначе
	    ИмяРодителя = РодительЭлемента.Родитель.Имя; //Если родителем является группа
	КонецЕсли;
	

	НовоеПоле                     = Элементы.Добавить(ИмяРодителя + СвойстваПоля.Имя, Тип("ПолеФормы"), РодительЭлемента);
	НовоеПоле.ПутьКДанным         = ?(ЗначениеЗаполнено(СвойстваПоля.ПутьКДанным), СвойстваПоля.ПутьКДанным, ИмяРодителя + "." + СвойстваПоля.Имя);
	НовоеПоле.Заголовок           = ?(ЗначениеЗаполнено(СвойстваПоля.Заголовок), СвойстваПоля.Заголовок, СвойстваПоля.Имя);
	НовоеПоле.РежимРедактирования = РежимРедактированияКолонки.ВходПриВводе;
	НовоеПоле.Вид                 = ВидПоляФормы.ПолеВвода;
	НовоеПоле.ТолькоПросмотр      = СвойстваПоля.ТолькоПросмотрПоля;
	НовоеПоле.Ширина              = СвойстваПоля.ШиринаПоля;
	
	Если СвойстваПоля.СвязиПараметровВыбора <> Неопределено Тогда
		НовоеПоле.СвязиПараметровВыбора = СвойстваПоля.СвязиПараметровВыбора;
	КонецЕсли;
	
	Если СвойстваПоля.ЦветФонаЗаголовка <> Неопределено Тогда
		НовоеПоле.ЦветФонаЗаголовка = СвойстваПоля.ЦветФонаЗаголовка;
	КонецЕсли;
	
	Если СвойстваПоля.ЦветФона <> Неопределено Тогда
		НовоеПоле.ЦветФона = СвойстваПоля.ЦветФона;
	КонецЕсли;
		
	Если СвойстваПоля.КартинкаШапки <> Неопределено Тогда
		НовоеПоле.КартинкаШапки = СвойстваПоля.КартинкаШапки;
	КонецЕсли;
		
	Если ЗначениеЗаполнено(СвойстваПоля.ОбработчикПриИзменении) Тогда
		НовоеПоле.УстановитьДействие("ПриИзменении", СвойстваПоля.ОбработчикПриИзменении);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СвойстваПоля.ОбработчикНачалоВыбора) Тогда
		НовоеПоле.УстановитьДействие("НачалоВыбора", СвойстваПоля.ОбработчикНачалоВыбора);
	КонецЕсли;
	
	Возврат НовоеПоле;
	
КонецФункции

Функция ДобавитьГруппуФормы(Имя,Заголовок,ОтображатьВШапке,КартинкаШапки,ГруппировкаКолонок,Родитель = Неопределено)
	
	ИмяРодителя = Родитель.Имя;
	НоваяГруппа					 = Элементы.Добавить(ИмяРодителя + Имя, Тип("ГруппаФормы"), Родитель);
	НоваяГруппа.Заголовок		 = ?(ЗначениеЗаполнено(Заголовок), Заголовок, Имя);
	НоваяГруппа.Вид				 = ВидГруппыФормы.ГруппаКолонок;
	НоваяГруппа.Группировка		 = ГруппировкаКолонок;
	НоваяГруппа.ОтображатьВШапке = ОтображатьВШапке;
	
	Если ОтображатьВШапке И КартинкаШапки <> Неопределено Тогда
		НоваяГруппа.КартинкаШапки = КартинкаШапки;
	КонецЕсли;
	
	Возврат НоваяГруппа;
	
КонецФункции

#КонецОбласти 

Процедура ЗаполнитьВидыИнтервалов(ОбъектЗаполнения)



КонецПроцедуры

&НаСервере
Процедура ПоместитьЦеныНомеровВТЧ(ТекущийОбъект,МассивИнтервалов)
	
	Для каждого СтрокаНомера Из ТаблицаЦенНомеров Цикл
		Для каждого Интервал Из МассивИнтервалов Цикл
			НоваяСтрока = ТекущийОбъект.Цены.Добавить();		
			НоваяСтрока.ОбъектЦены 		= СтрокаНомера.ОбъектЦены;
			НоваяСтрока.ИнтервалЦены 	= Интервал.ИнтервалЦены;
			НоваяСтрока.ДатаИнтервала 	= Интервал.ДатаИнтервала;
			ИмяКолонки = Интервал.ИмяКолонки;
			НоваяСтрока.Цена 			= СтрокаНомера[ИмяКолонки];
		КонецЦикла;
	КонецЦикла;		

КонецПроцедуры

&НаСервере
Процедура ПоместитьЦеныУслугВТЧ(ТекущийОбъект,МассивИнтервалов)
	Для каждого СтрокаУслуги Из ТаблицаЦенУслуг Цикл
		Для каждого Интервал Из МассивИнтервалов Цикл
			НоваяСтрока = ТекущийОбъект.Цены.Добавить();		
			НоваяСтрока.ОбъектЦены 		= СтрокаУслуги.ОбъектЦены;
			НоваяСтрока.ИнтервалЦены 	= Интервал.ИнтервалЦены;
			НоваяСтрока.ДатаИнтервала 	= Интервал.ДатаИнтервала;
			ИмяКолонки = Интервал.ИмяКолонки;
			НоваяСтрока.Цена 			= СтрокаУслуги[ИмяКолонки];
		КонецЦикла;
	КонецЦикла;		

КонецПроцедуры


&НаСервере
Процедура ЗаполнитьТаблицуЦенСервер(ТекущийОбъект)
	ТекущийОбъект.СтарыйЦены.Очистить();
	Для каждого СтрокаЦены Из СтарыйТаблицаЦенНомеров Цикл
		НоваяСтрокаЦены = ТекущийОбъект.СтарыйЦены.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаЦены,СТрокаЦены);
	КонецЦикла;		
	Для каждого СтрокаЦены Из СтарыйТаблицаЦенДопУслуг Цикл
		НоваяСтрокаЦены = ТекущийОбъект.СтарыйЦены.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаЦены,СТрокаЦены);
	КонецЦикла;
	
	ТекущийОбъект.Цены.Очистить();
	
	МассивИнтерваловНомеров = Новый Массив;
	МассивИнтерваловУслуг = Новый Массив;
	Для каждого СтрокаИнтервала Из Объект.ВидыИнтервалов Цикл
	
		Если СтрокаИнтервала.ДляУслуг Тогда
			МассивИнтерваловУслуг.Добавить(СтрокаИнтервала);		
		КонецЕсли;				
		Если СтрокаИнтервала.ДляНомеров Тогда
			МассивИнтерваловНомеров.Добавить(СтрокаИнтервала);		
		КонецЕсли;				
		
	КонецЦикла;
	Если НЕ МассивИнтерваловУслуг.Количество() = 0 Тогда
		ПоместитьЦеныУслугВТЧ(ТекущийОбъект,МассивИнтерваловУслуг);	
	КонецЕсли;
	Если НЕ МассивИнтерваловНомеров.Количество() = 0 Тогда
		ПоместитьЦеныНомеровВТЧ(ТекущийОбъект,МассивИнтерваловНомеров);	
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработчикиОповещений

&НаКлиенте
Процедура ПослеВопросаОбОчисткеИЗаполнении(Результат,ДопПараметры) Экспорт
	
	Если Результат =  КодВозвратаДиалога.Да Тогда
	
		ЗаполнитьТаблицуНомеров(ДопПараметры);	
	
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ОчисткаТаблицыПослеПредупреждения() Экспорт

	СтарыйТаблицаЦенНомеров.Очистить();

КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаОЗаполненииВИдовИнтервалов(Результат,ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьИнтервалы();
	КонецЕсли;
КонецПроцедуры


#КонецОбласти

&НаКлиенте
Процедура ЗадатьВопросОЗаполненииВидовИнтервалов(ОбъектЗаполнения)

	ДопПараметры = Новый Структура("Объект",ОбъектЗаполнения);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВопросаОЗаполненииВидовИнтервалов",ЭтаФорма,ДопПараметры);
	ПоказатьВопрос(ОписаниеОповещения,"Заполнить виды интервалов?",РежимДиалогаВопрос.ДаНет);

КонецПроцедуры


&НаСервере
Процедура ПостроитьТаблицыЦен()
	УдаляемыеКолонкиТаблицыЦен = Новый Массив;
	ДобавляемыеКолонкиТаблицыЦен = Новый Массив;
	УдаляемыеЭлементыЦен = Новый Массив;
	
	НоваяТаблицаЦенНомеров = ТаблицаЦенНомеров.Выгрузить(,"ОбъектЦены");
	НоваяТаблицаЦенУслуг = ТаблицаценУслуг.Выгрузить(,"ОбъектЦены");
	
	Для каждого СтрокаИнтервала  Из Объект.ВидыИнтервалов Цикл
		
		ИмяКолонки = ИмяКолонкиПоИнтервалу(СтрокаИнтервала.ИнтервалЦены);
		СтрокаИнтервала.ИмяКолонки = ИмяКолонки;
		ТипЧислоЦена = Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(12,2,ДопустимыйЗнак.Неотрицательный));
		ЗаголовокКолонки = "с " + Формат(СтрокаИнтервала.ИнтервалЦены.ДатаНачалаДействияЦены,"ДЛФ=DD");
		Если СтрокаИнтервала.ДляУслуг Тогда
			НоваяТаблицаЦенУслуг.Колонки.Добавить(ИмяКолонки, ТипЧислоЦена, ЗаголовокКолонки)		
		КонецЕсли;		
		
		Если СтрокаИнтервала.ДляНомеров Тогда
			НоваяТаблицаЦенНомеров.Колонки.Добавить(ИмяКолонки, ТипЧислоЦена, ЗаголовокКолонки)
		КонецЕсли;		
		
	КонецЦикла;
	
	РеквизитыТаблицыЦенУслуг = ПолучитьРеквизиты("ТаблицаЦенУслуг");
	Для каждого Реквизит Из РеквизитыТаблицыЦенУслуг Цикл
		Если СтрНайти(Реквизит.Имя,"Интервал") Тогда
			УдаляемыеКолонкиТаблицыЦен.Добавить("ТаблицаЦенУслуг." + Реквизит.Имя); 
		КонецЕсли;
	КонецЦикла;
	
	Для каждого Колонка Из НоваяТаблицаЦенУслуг.Колонки Цикл
		Если СтрНайти(Колонка.Имя,"Интервал") Тогда
			УдаляемаяКолонка = УдаляемыеКолонкиТаблицыЦен.Найти("ТаблицаЦенУслуг." + Колонка.Имя);
			Если НЕ УдаляемаяКолонка = Неопределено Тогда
				УдаляемыеКолонкиТаблицыЦен.Удалить(УдаляемаяКолонка);
			Иначе
				ДобавляемыеКолонкиТаблицыЦен.Добавить(Новый РеквизитФормы(Колонка.Имя,Колонка.ТипЗначения,"ТаблицаЦенУслуг",Колонка.Заголовок,Истина));
			КонецЕсли;		
		КонецЕсли;
	КонецЦикла;
	Если НЕ УдаляемыеКолонкиТаблицыЦен.Количество() = 0  ИЛИ НЕ ДобавляемыеКолонкиТаблицыЦен.Количество() = 0 Тогда
		ИзменитьРеквизиты(ДобавляемыеКолонкиТаблицыЦен,УдаляемыеКолонкиТаблицыЦен);	
	КонецЕсли; 
	
	Для каждого ТекЭлемент Из Элементы.ТаблицаЦенУслуг.ПодчиненныеЭлементы Цикл
		Если СтрНайти(ТекЭлемент.Имя,"Интервал") Тогда
			УдаляемыеЭлементыЦен.Добавить(ТекЭлемент);
		КонецЕсли;	
	КонецЦикла;
	
	Для каждого УдаляемыйЭлемент Из УдаляемыеЭлементыЦен Цикл
		Элементы.Удалить(УдаляемыйЭлемент);
	КонецЦикла;
	
	///////////////////////////////////////////////////////////////////
	УдаляемыеКолонкиТаблицыЦен.Очистить();
	ДобавляемыеКолонкиТаблицыЦен.Очистить();
	УдаляемыеЭлементыЦен.Очистить();
	
	РеквизитыТаблицыЦенНомеров = ПолучитьРеквизиты("ТаблицаЦенНомеров");
	Для каждого Реквизит Из РеквизитыТаблицыЦенНомеров Цикл
		Если СтрНайти(Реквизит.Имя,"Интервал") Тогда
			УдаляемыеКолонкиТаблицыЦен.Добавить("ТаблицаЦенНомеров." + Реквизит.Имя); 
		КонецЕсли;
	КонецЦикла;
	Для каждого Колонка Из НоваяТаблицаЦенНомеров.Колонки Цикл
		Если СтрНайти(Колонка.Имя,"Интервал") Тогда
			УдаляемаяКолонка = УдаляемыеКолонкиТаблицыЦен.Найти("ТаблицаЦенНомеров." + Колонка.Имя);
			Если НЕ УдаляемаяКолонка = Неопределено Тогда
				УдаляемыеКолонкиТаблицыЦен.Удалить(УдаляемаяКолонка);
			Иначе
				ДобавляемыеКолонкиТаблицыЦен.Добавить(Новый РеквизитФормы(Колонка.Имя,Колонка.ТипЗначения,"ТаблицаЦенНомеров",Колонка.Заголовок,Истина));
			КонецЕсли;		
		КонецЕсли;
	КонецЦикла;
	Если НЕ УдаляемыеКолонкиТаблицыЦен.Количество() = 0  ИЛИ НЕ ДобавляемыеКолонкиТаблицыЦен.Количество() = 0 Тогда
		ИзменитьРеквизиты(ДобавляемыеКолонкиТаблицыЦен,УдаляемыеКолонкиТаблицыЦен);	
	КонецЕсли; 
	
	Для каждого ТекЭлемент Из Элементы.ТаблицаЦенНомеров.ПодчиненныеЭлементы Цикл
		Если СтрНайти(ТекЭлемент.Имя,"Интервал") Тогда
			УдаляемыеЭлементыЦен.Добавить(ТекЭлемент);
		КонецЕсли;	
	КонецЦикла;
	
	Для каждого УдаляемыйЭлемент Из УдаляемыеЭлементыЦен Цикл
		Элементы.Удалить(УдаляемыйЭлемент);
	КонецЦикла;
	
	//Заполним колоки табличных частей формы
	                                     
	ГруппаЦенУслуг = ДобавитьГруппуФормы("грИнтервалыУслуг","Цены",Истина,,ГруппировкаКолонок.Горизонтальная,Элементы.ТаблицаЦенУслуг);
	ГруппаЦенНомеров = ДобавитьГруппуФормы("грИнтервалыУслуг","Цены",Истина,,ГруппировкаКолонок.Горизонтальная,Элементы.ТаблицаЦенНомеров);	
	Для каждого СтрокаИнтервала Из Объект.ВидыИнтервалов Цикл
			
		ИмяКолонки = СтрокаИнтервала.ИмяКолонки;
		СвойстваПоля = СтруктураСвойствПоля();
		СвойстваПоля.Имя = ИмяКолонки;
		СвойстваПоля.ТолькоПросмотрПоля = Ложь;
		СвойстваПоля.Заголовок = "с " + Формат(СтрокаИнтервала.ИнтервалЦены.ДатаНачалаДействияЦены,"ДЛФ=DD");
		СвойстваПоля.ШиринаПоля = 12;
		
		Если СтрокаИнтервала.ДляНомеров Тогда
			СвойстваПоля.Родитель = ГруппаЦенНомеров;
			СвойстваПоля.ОбработчикПриИзменении = "ТаблицаЦенНомеровПриИзменении";
			НовоеПоле = ДобавитьПолеФормы(СвойстваПоля);
		КонецЕсли;
		Если СтрокаИнтервала.ДляУслуг Тогда
			СвойстваПоля.Родитель = ГруппаЦенУслуг;
			СвойстваПоля.ОбработчикПриИзменении = "ТаблицаЦенУслугПриИзменении";
			НовоеПоле = ДобавитьПолеФормы(СвойстваПоля);
		КонецЕсли;	
	КонецЦикла;		
	
	//ТаблицаЦенНомеров.Загрузить(НоваяТаблицаЦенНомеров);
	//ТаблицаценУслуг.Загрузить(НоваяТаблицаЦенУслуг);
	
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьТаблицыЦен()
	Запрос = Новый Запрос ("ВЫБРАТЬ
	                       |	Цены.НомерКолонки КАК НомерКолонки,
	                       |	Цены.ОбъектЦены КАК ОбъектЦены,
	                       |	Цены.ИнтервалЦены КАК ИнтервалЦены,
	                       |	Цены.ДатаИнтервала КАК ДатаИнтервала,
	                       |	Цены.Цена КАК Цена
	                       |ПОМЕСТИТЬ ТаблицаЦены
	                       |ИЗ
	                       |	&Цены КАК Цены
	                       |
	                       |ИНДЕКСИРОВАТЬ ПО
	                       |	ОбъектЦены,
	                       |	ИнтервалЦены
	                       |;
	                       |
	                       |////////////////////////////////////////////////////////////////////////////////
	                       |ВЫБРАТЬ
	                       |	ТаблицаЦены.ОбъектЦены КАК ОбъектЦены,
	                       |	ТаблицаЦены.ИнтервалЦены КАК ИнтервалЦены,
	                       |	ТаблицаЦены.ДатаИнтервала КАК ДатаИнтервала,
	                       |	ТаблицаЦены.Цена КАК Цена,
	                       |	ТаблицаЦены.НомерКолонки КАК НомерКолонки
	                       |ИЗ
	                       |	ТаблицаЦены КАК ТаблицаЦены
	                       |ГДЕ
	                       |	ТИПЗНАЧЕНИЯ(ТаблицаЦены.ОбъектЦены) = ТИП(Справочник.Номера)
	                       |
	                       |УПОРЯДОЧИТЬ ПО
	                       |	НомерКолонки
	                       |ИТОГИ ПО
	                       |	ОбъектЦены
	                       |;
	                       |
	                       |////////////////////////////////////////////////////////////////////////////////
	                       |ВЫБРАТЬ
	                       |	ТаблицаЦены.ОбъектЦены КАК ОбъектЦены,
	                       |	ТаблицаЦены.ИнтервалЦены КАК ИнтервалЦены,
	                       |	ТаблицаЦены.ДатаИнтервала КАК ДатаИнтервала,
	                       |	ТаблицаЦены.Цена КАК Цена,
	                       |	ТаблицаЦены.НомерКолонки КАК НомерКолонки
	                       |ИЗ
	                       |	ТаблицаЦены КАК ТаблицаЦены
	                       |ГДЕ
	                       |	ТИПЗНАЧЕНИЯ(ТаблицаЦены.ОбъектЦены) = ТИП(Справочник.ДополнительныеУслуги)
	                       |
	                       |УПОРЯДОЧИТЬ ПО
	                       |	НомерКолонки
	                       |ИТОГИ ПО
	                       |	ОбъектЦены");
	
	ТаблицаЦены = Объект.Цены.Выгрузить();
	ОбщегоНазначения.ПронумероватьТаблицуЗначений(ТаблицаЦены,"НомерКолонки");
	Запрос.УстановитьПараметр("Цены",ТаблицаЦены);
	РезультатЗапроса = Запрос.ВыполнитьПакет();	
	
	ВыборкаПоНомерам = РезультатЗапроса[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоНомерам.Следующий() Цикл
		НоваяСтрока = ТаблицаЦенНомеров.Добавить();
		НоваяСтрока.ОбъектЦены = ВыборкаПоНомерам.ОбъектЦены;
		ВыборкаИнтервалы = ВыборкаПоНомерам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаИнтервалы.Следующий() Цикл
			ИмяКолонки = ИмяКолонкиПоИнтервалу(ВыборкаИнтервалы.ИнтервалЦены);
			НоваяСтрока[ИмяКолонки] = ВыборкаИнтервалы.Цена;			
		КонецЦикла;
	КонецЦикла;
	
	ВыборкаПоУслугам = РезультатЗапроса[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);	
	Пока ВыборкаПоУслугам.Следующий() Цикл
		НоваяСтрока = ТаблицаЦенУслуг.Добавить();
		НоваяСтрока.ОбъектЦены = ВыборкаПоУслугам.ОбъектЦены;
		ВыборкаИнтервалы = ВыборкаПоУслугам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаИнтервалы.Следующий() Цикл
			ИмяКолонки = ИмяКолонкиПоИнтервалу(ВыборкаИнтервалы.ИнтервалЦены);
			НоваяСтрока[ИмяКолонки] = ВыборкаИнтервалы.Цена;			
		КонецЦикла;
	КонецЦикла;
	
	//Для каждого СтрокаЦены Из Объект.Цены Цикл
	//
	//	Если ТипЗНЧ(СтрокаЦены.ОбъектЦены) = Тип("СправочникСсылка.Номера") Тогда //Добавляем строку в ТаблицуЦенНомеров
	//		
	//		НоваяСтрока = ТаблицаЦенНомеров.Добавить();
	//		НоваяСтрока.ОбъектЦены = СтрокаЦены.ОбъектЦены;
	//		ИмяКолонки = ИмяКолонкиПоИнтервалу(СтрокаЦены.ИнтервалЦены);
	//		НоваяСтрока[ИмяКолонки] = СтрокаЦены.Цена;			
	//		
	//	ИначеЕсли ТипЗНЧ(СтрокаЦены.ОбъектЦены) = Тип("СправочникСсылка.ДополнительныеУслуги") Тогда //Добавляем строку в таблицуЦенУслуг
	//		
	//	    НоваяСтрока = ТаблицаЦенУслуг.Добавить();
	//		НоваяСтрока.ОбъектЦены = СтрокаЦены.ОбъектЦены;
	//		ИмяКолонки = ИмяКолонкиПоИнтервалу(СтрокаЦены.ИнтервалЦены);
	//		НоваяСтрока[ИмяКолонки] = СтрокаЦены.Цена;
	//		
	//	КонецЕсли;
	//
	//КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуЦенУслуг()


КонецПроцедуры


&НаСервере
Функция ЗаполнитьИнтервалыСервер()
	РезультатОбработки = Новый Структура("Успех,ОписаниеРезультата,ЕстьИзменениеДатИнтервалов",Ложь,"",Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИнтервалыСезонныхЦен.Ссылка КАК ИнтервалЦены,
		|	ИнтервалыСезонныхЦен.ДатаНачалаДействияЦены КАК ДатаИнтервала,
		|	ИнтервалыСезонныхЦен.Период КАК Период
		|ИЗ
		|	Справочник.ИнтервалыСезонныхЦен КАК ИнтервалыСезонныхЦен
		|ГДЕ
		|	ИнтервалыСезонныхЦен.Владелец = &Гостиница
		|	И ИнтервалыСезонныхЦен.Период = &Период
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаИнтервала
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИнтервалыСезонныхЦен.Ссылка КАК ИнтервалЦены,
		|	ИнтервалыСезонныхЦен.ДатаНачалаДействияЦены КАК ДатаИнтервала,
		|	ИнтервалыСезонныхЦен.Период КАК Период
		|ИЗ
		|	Справочник.ИнтервалыСезонныхЦен КАК ИнтервалыСезонныхЦен
		|ГДЕ
		|	ИнтервалыСезонныхЦен.Период = &Период
		|	И ВЫБОР
		|			КОГДА ЗНАЧЕНИЕ(Справочник.Корпуса.ПустаяСсылка) = &Корпус
		|				ТОГДА ЛОЖЬ
		|			ИНАЧЕ ИнтервалыСезонныхЦен.Владелец = &Корпус
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаИнтервала";
	
	Запрос.УстановитьПараметр("Гостиница", Объект.Гостиница);
	Запрос.УстановитьПараметр("Корпус", Объект.Корпус);
	Запрос.УстановитьПараметр("Период", Объект.Период);
	
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ТекущийРезультат = МассивРезультатов[1]; //Предположим, что в запросе по корпусу есть интервалы, т.е. для корпуса установлены собственные интервалы
	ВладелецОбъектов = Объект.Корпус;
	Если ТекущийРезультат.Пустой() Тогда
		ТекущийРезультат = МассивРезультатов[0];
		ВладелецОбъектов = Объект.Гостиница;
	КонецЕсли;
	Если ТекущийРезультат.Пустой() Тогда
		
		ОписаниеОшибки = "Для объектов бронирования не установлены интервалы сезонных цен!";
		РезультатОбработки.ОписаниеРезультата = ОписаниеОшибки;
		Возврат РезультатОбработки;
	
	КонецЕсли;

	Если НЕ Объект.ВидыИнтервалов.Количество() = 0 Тогда
		Если НЕ Объект.ВидыИнтервалов[0].ИнтервалЦены.Владелец = ВладелецОбъектов Тогда
			Объект.ВидыИнтервалов.Очистить();				
		КонецЕсли;	
	КонецЕсли;
	
	ТаблицаИнтервалов = Объект.ВидыИнтервалов.Выгрузить();
	ЕстьИзменениеДатИнтервалов = Ложь;
	ОписаниеРезультата = "";	
	Выборка = ТекущийРезультат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПараметрыПоиска = Новый Структура("ИнтервалЦены",Выборка.ИнтервалЦены);
		НайденыеСтроки = ТаблицаИнтервалов.НайтиСтроки(ПараметрыПоиска);
		
		Если НайденыеСтроки.Количество() = 0 Тогда
			ТекущаяСтрока =	ТаблицаИнтервалов.Добавить();
		Иначе
			ТекущаяСтрока = НайденыеСтроки[0];
		КонецЕсли;
		
		Если НЕ ТекущаяСтрока.ДатаИнтервала = Дата(1,1,1,0,0,0) И НЕ Выборка.ДатаИнтервала = ТекущаяСтрока.ДатаИнтервала Тогда
			ЕстьИзменениеДатИнтервалов = Истина;		
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока,Выборка);
		ТекущаяСтрока.ИмяКолонки = ИмяКолонкиПоИнтервалу(Выборка.ИнтервалЦены);
		
	КонецЦикла;
	ТаблицаИнтервалов.Сортировать("ДатаИнтервала");
	Объект.ВидыИнтервалов.Загрузить(ТаблицаИнтервалов);
	Если ЕстьИзменениеДатИнтервалов Тогда
		РезультатОбработки.ЕстьИзменениеДатИнтервалов = ЕстьИзменениеДатИнтервалов;
	КонецЕсли;
	РезультатОбработки.Успех = Истина;
	РезультатОбработки.ОписаниеРезультата = ОписаниеРезультата;
	Возврат РезультатОбработки;

КонецФункции

&НаСервере
Процедура ЗаполнитьНомераПоКорпусу()

	

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНомераПоГостинице()

		

КонецПроцедуры                 

&НаСервере
Процедура ЗаполнитьСписокНомеровСервер()

	Если Объект.Гостиница.ГостиничныйКомплекс и ЗначениеЗаполнено(Объект.Корпус) Тогда
		ОбъектБронирования = Объект.Корпус;	
	ИначеЕсли НЕ Объект.Гостиница.ГостиничныйКомплекс и ЗначениеЗаполнено(Объект.Гостиница) Тогда
		ОбъектБронирования = Объект.Гостиница;	
	КонецЕсли;                                
	ДобавленныеНомера = ТаблицаЦенНомеров.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДобавленныеНомера.ОбъектЦены КАК ОбъектЦены
		|ПОМЕСТИТЬ ДобавленныеНомера
		|ИЗ
		|	&ДобавленныеНомера КАК ДобавленныеНомера
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Номера.Ссылка КАК ОбъектЦены
		|ИЗ
		|	Справочник.Номера КАК Номера
		|ГДЕ
		|	Номера.Владелец = &Владелец
		|	И НЕ Номера.Ссылка В
		|				(ВЫБРАТЬ
		|					ДобавленныеНомера.ОбъектЦены КАК ОбъектЦены
		|				ИЗ
		|					ДобавленныеНомера КАК ДобавленныеНомера)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Номера.Код
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДобавленныеНомера.ОбъектЦены КАК ОбъектЦены
		|ИЗ
		|	ДобавленныеНомера КАК ДобавленныеНомера
		|ГДЕ
		|	ДобавленныеНомера.ОбъектЦены.Владелец <> &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", ОбъектБронирования);
	Запрос.УстановитьПараметр("ДобавленныеНомера", ДобавленныеНомера);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ДобавляемыеНомера = РезультатЗапроса[1];
	УдаляемыеНомера = РезультатЗапроса[2];
	Если НЕ УдаляемыеНомера.Выгрузить().Количество() = 0 Тогда //Если есть номера, которые надо удалить это говорить о том, что сменился владелец
		ТаблицаЦенНомеров.Очистить();	
	КонецЕсли;

	ВыборкаНомеров = ДобавляемыеНомера.Выбрать();
	Пока ВыборкаНомеров.Следующий() Цикл
		НоваяСтрокаНомера = ТаблицаЦенНомеров.Добавить();
		НоваяСтрокаНомера.ОбъектЦены = ВыборкаНомеров.ОбъектЦены;
	КонецЦикла;
	//ТаблицаЦенНомеров.Загрузить(РезультатЗапроса);	
	Элементы.ТаблицаЦенНомеров.Обновить();
КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьСписокНомеров()

	ЗаполнитьСписокНомеровСервер();	

КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьИнтервалы()

	РезультатОбработки = ЗаполнитьИнтервалыСервер();
   	Если НЕ РезультатОбработки.Успех Тогда
		//Сообщить пльзователю результат обработки
		Возврат;	
	КонецЕсли;
	Если РезультатОбработки.ЕстьИзменениеДатИнтервалов Тогда
		//Сообщить пользователю об изменениях дат интервалов
	КонецЕсли;
	Элементы.СтраницыНастройкаИУстановкаЦен.ТекущаяСтраница = Элементы.СтраницаВыборВидовИнтервалов;
	ЗаполнитьСписокНомеров();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВидыИнтервалов(Команда)
	ЗаполнитьИнтервалы();
КонецПроцедуры

Процедура ЗаполнитьДокумент()
	//Заполним таблицы формы данными из документа
	Если НЕ Объект.СтарыйЦены.Количество() = 0 Тогда //если открывается документ с данными строго формата
		
		Для каждого СтрокаЦены Из Объект.СтарыйЦены Цикл
			
			Если ТипЗНЧ(СтрокаЦены.ОбъектЦены) = Тип("СправочникСсылка.Номера") Тогда
				ТекТаблица = СтарыйТаблицаЦенНомеров;
			Иначе
				ТекТаблица = СтарыйТаблицаЦенДопУслуг;
			КонецЕсли;
			
			НоваяСтрокаЦены = ТекТаблица.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаЦены,СтрокаЦены);
			
		КонецЦикла;
	Иначе //
		ПостроитьТаблицыЦен();
		ЗаполнитьТаблицыЦен();
	КонецЕсли;
	Если НЕ Объект.Цены.Количество() = 0 Тогда
		
		Элементы.СтраницыНастройкаИУстановкаЦен.ТекущаяСтраница = Элементы.СтраницаУстановкаЦен;	
	
	КонецЕсли;

КонецПроцедуры

#Область СобытияФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьДокумент();
	УправлениеДоступностью();
	УправлениеПараметрамиВыбора();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьЗаголовкиЗакладок();
	УстановитьВидимостьЭлементовФормы();
	УстановитьРедактированиеРеквизитовДляДстарыхДокументов();
	УстановитьЗаголовокКнопкиВыбораПериода();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	
КонецПроцедуры	

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Модифицированность ИЛИ НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьТаблицуЦенСервер(ТекущийОбъект);
	КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЦенНомеровНомерНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = ЛОЖЬ;
	Владелец = ?(ЗначениеЗаполнено(Объект.Корпус),Объект.Корпус,Объект.Гостиница);
	ПараметрыФормы = Новый Структура("РежимВыбора,Отбор",ИСТИНА,Новый Структура("Владелец",Владелец));
	ОткрытьФорму("Справочник.Номера.ФормаВыбора",ПАраметрыФормы,Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область СобытияТаблицаЦенНомеров
&НаКлиенте
Процедура ТаблицаЦенНомеровПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если НЕ ЗначениеЗаполнено(Объект.Гостиница) Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(,"Укажите Гостиницу");
		ЭтаФорма.ТекущийЭлемент = Элементы.Гостиница;
	Иначе
		Если Не ЗначениеЗаполнено(Объект.Корпус) И ЭтоКомплекс(Объект.Гостиница) Тогда
			ПоказатьПредупреждение(,"Укажите корпус гостиничного комплекса");
			Отказ = Истина;	
			ЭтаФорма.ТекущийЭлемент = Элементы.Корпус;			    
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЦенНомеровПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	УстановитьЗаголовкиЗакладок("Номера");
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЦенНомеровПослеУдаления(Элемент)
	УстановитьЗаголовкиЗакладок("Номера");
КонецПроцедуры

#КонецОбласти

#Область СобытияТаблицаЦенДопУслуг

&НаКлиенте
Процедура ТаблицаЦенДопУслугПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	УстановитьЗаголовкиЗакладок("ДополнительныеУслуги");
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ГостиницаПриИзменении(Элемент)
	
	Если НЕ ЭтоКомплекс(Объект.Гостиница) Тогда //если гостиница не является комплексом, то заполняем список интервалов цен
		
		Если НЕ Объект.ВидыИнтервалов.Количество() = 0 Тогда
			//
			//Если  Тогда
			//
			//				
			//КонецЕсли;
			
		КонецЕсли;
		ЗадатьВопросОЗаполненииВидовИнтервалов(Объект.Гостиница);	
		
		
	КонецЕсли;	
	//Если НЕ ЭтоГостиничныйКомплекс(Объект.Гостиница) Тогда
	//    Если СтарыйТаблицаЦенНомеров.Количество() = 0 Тогда
	//		ТекстВопроса = "Заполнить список номеров для выбранной гостиницы?"	
	//	Иначе
	//		ТекстВопроса = "Список номеров будет очищен.
	//		|Заполнить список номеров для выбранной гостиницы?";
	//	КонецЕсли; 
	//	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВопросаОбОчисткеИЗаполнении",ЭтаФорма,Объект.Гостиница);
	//	ПоказатьВопрос(ОписаниеОповещения,ТекстВопроса,РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да,"Внимание!");
	//Иначе	
	//	//Работа с документами старого формата
	//	Если СтарыйТаблицаЦенНомеров.Количество() Тогда
	//		ОписаниеОповещения = Новый ОписаниеОповещения("ОчисткаТаблицыПослеПредупреждения",ЭтаФорма);
	//		ПоказатьПредупреждение(ОписаниеОповещения,"Гостиница изменилась
	//		|Таблица цен номеров будет очищена!");
	//	КонецЕсли;
	//	
	//КонецЕсли; 
	
	УправлениеДоступностью();
	УправлениеПараметрамиВыбора();
	
	//Объект.Корпус = Новый (Тип("СправочникСсылка.Корпуса"));
КонецПроцедуры

&НаКлиенте
Процедура ГостиницаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ГостиницаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура КорпусАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	Отбор = Новый Структура("Владелец",Объект.Гостиница);
	ПараметрыПолученияДанных.Отбор = Отбор;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЦенДопУслугУслугаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЦенНомеровНомерАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	Владелец = ?(ЭтоКомплекс(Объект.Гостиница),Объект.Корпус,Объект.Гостиница);
	Отбор = Новый Структура("Владелец",Владелец);
	ПараметрыПолученияДанных.Отбор = Отбор;
КонецПроцедуры

&НаКлиенте
Процедура КорпусПриИзменении(Элемент)
	//Если СтарыйТаблицаЦенНомеров.Количество() = 0 Тогда
	//	ТекстВопроса = "Заполнить список номеров для выбранного корпуса?"	
	//Иначе
	//	ТекстВопроса = "Список номеров будет очищен.
	//	|Заполнить список номеров для выбранного корпуса?"	
	//КонецЕсли; 
	//
	//ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВопросаОбОчисткеИЗаполнении",ЭтаФорма,Объект.Корпус);
	//ПоказатьВопрос(ОписаниеОповещения,ТекстВопроса,РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да,"Внимание!");
	ЗадатьВопросОЗаполненииВидовИнтервалов(Объект.Корпус);	
	УправлениеДоступностью();
	УправлениеПараметрамиВыбора();
КонецПроцедуры


&НаКлиенте
Процедура ТаблицаЦенДопУслугПослеУдаления(Элемент)
	УстановитьЗаголовкиЗакладок("ДополнительныеУслуги");
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЦенНомеровНомерОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКИзменениюИнтервалов(Команда)
	Элементы.СтраницыНастройкаИУстановкаЦен.ТекущаяСтраница = Элементы.СтраницаВыборВидовИнтервалов;
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКУстановкеЦен(Команда)
	ПостроитьТаблицыЦен();	
	Элементы.СтраницыНастройкаИУстановкаЦен.ТекущаяСтраница = Элементы.СтраницаУстановкаЦен
	//ПриПереходеКУстановкеЦен();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокКнопкиВыбораПериода()
	Если Объект.Период = 0 Тогда
	    ТекстЗаголовка = "";
	Иначе
		ТекстЗаголовка = Формат(Объект.Период,"ЧГ=") + " г."			
	КонецЕсли;
	Элементы.кнВыборПериода.Заголовок = ТекстЗаголовка;	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораПериода(Результат,ДопПараметры) Экспорт

	Если НЕ Результат = Неопределено Тогда
		Если НЕ Объект.Период = Результат Тогда
			Объект.Период = Результат;			
			УстановитьЗаголовокКнопкиВыбораПериода();
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры


&НаКлиенте
Процедура ВыборПериода(Команда)
	ПараметрыФормы = Новый Структура("ТекущийПериод",Объект.Период);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораПериода",ЭтотОбъект);
	ОткрытьФорму("Обработка.ПериодыБронирования.Форма",ПараметрыФормы,ЭтотОбъект,ЭтотОбъект,,,ОписаниеОповещения,РежимОткрытияОкнаФОрмы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЦенНомеровПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЦенУслугПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КорпусОчистка(Элемент, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры


#КонецОбласти 

#Область Инициализация
СоответствиеИнтервалаИменамКолонок = Новый Соответствие
#КонецОбласти	