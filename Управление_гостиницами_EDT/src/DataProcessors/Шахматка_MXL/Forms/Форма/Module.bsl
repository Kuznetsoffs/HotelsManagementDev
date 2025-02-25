&НаКлиенте
Перем ОповещениеОЗавершенииФоновогоЗадания Экспорт, КнопкаДействия Экспорт, ФормаОформления;

&НаСервереБезКонтекста
Функция ПолучитьДатыИнтерваловБронирования(Период = Неопределено,ОбъектБронирования = Неопределено)
	
	Возврат Обработки.Шахматка_MXL.ПолучитьДатыИнтерваловБронирования(Период);
	
КонецФункции // ()

Функция ЭтоКомплекс(Гостиница)

	Возврат Гостиница.ГостиничныйКомплекс;	

КонецФункции // ЭтоКомплекс()

Процедура ОбработатьРезультатСервер(АдресРезультата)

	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	Если Результат.Успех Тогда
	
		ТаблицаОтчета.Очистить();
		ТаблицаОтчета.Вывести(Результат.Таблица);
		ЗаполнитьЗначенияСвойств(ТаблицаОтчета,Результат,"ФиксацияСверху,ФиксацияСлева");
	
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияОкнаПросмотраЦен(Результат,ДопПараметры) Экспорт

	

КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораИзСписка(Результат,ДопПараметры) Экспорт

	Если Результат = Неопределено Тогда // выбора не произошло
		Возврат;
	КонецЕсли; 	
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияОкнаПросмотраЦен",ЭтотОбъект);
	ПараметрыФормы = Новый Структура("СтрокиДляЗаполнения,ДействиеПриОткрытии",ДопПараметры,Результат.Значение); 
	
	Если Результат.Значение = "Создать" Тогда
	    Форма = ОткрытьФорму("Обработка.Шахматка_MXL.Форма.ПросмотрЦен",ПараметрыФормы,ЭтотОбъект,ЭтотОбъект.УникальныйИдентификатор,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли Результат.Значение = "ПросмотрЦен"  Тогда
		Форма = ОткрытьФорму("Обработка.Шахматка_MXL.Форма.ПросмотрЦен",ПараметрыФормы,ЭтотОбъект,ЭтотОбъект.УникальныйИдентификатор,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ТипЗНЧ(Результат.Значение) = Тип("ДокументСсылка.КарточкаБронирования")  Тогда
		ОткрытьФорму("Документ.КарточкаБронирования.ФормаОбъекта",Новый Структура("Ключ",Результат.Значение));
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеФормированияОтчетаВФоне(Результат, ДопПараметры = Неопределено) Экспорт

	Если ЗначениеЗаполнено(АдресРезультата) Тогда
	
		
	ИначеЕсли НЕ Результат.Свойство("АдресРезультата",АдресРезультата) Тогда
		
		
	ИначеЕсли НЕ ДопПараметры = Неопределено Тогда
		
		ДопПараметры.Свойство("АдресРезультата",АдресРезультата);
	
	КонецЕсли; 
	
	Если НЕ Результат.КраткоеПредставлениеОшибки = Неопределено Тогда
	
	Иначе
	
	КонецЕсли; 	
	
	ОбработатьРезультатСервер(АдресРезультата);
	Элементы.Сформировать.Доступность = Истина;
КонецПроцедуры

Функция СтатусФоновогоЗадания()

	СтатусЗадания = Новый Структура("Статус","Выполняется");
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Состояние = Задание.Состояние;
	Если НЕ Состояние = СостояниеФоновогоЗадания.Активно Тогда
		
		СтатусЗадания.Вставить("КраткоеПредставлениеОшибки",КраткоеПредставлениеОшибки(Задание.ИнформацияОбОшибке));
		СтатусЗадания.Вставить("ПодробноеПредставлениеОшибки",ПодробноеПредставлениеОшибки(Задание.ИнформацияОбОшибке));
		
		Если Состояние = СостояниеФоновогоЗадания.Завершено Тогда
			
			СтатусЗадания.Статус = "Завершено";
		ИначеЕсли Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
				
			СтатусЗадания.Статус = "Завершено";
		ИначеЕсли Состояние = СостояниеФоновогоЗадания.Отменено Тогда
			
			СтатусЗадания.Статус = "Отменено";
		КонецЕсли;
	    
	КонецЕсли; 
	
	Возврат СтатусЗадания;

КонецФункции // СтатусФоновогоЗадания()

&НаКлиенте
Процедура КонтрольДлительнойОперации();
	
	СтатусОперации = СтатусФоновогоЗадания();
	Если СтатусОперации.Статус = "Выполняется" Тогда
		ПодключитьОбработчикОжидания("КонтрольДлительнойОперации",3,Истина);
	Иначе
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершенииФоновогоЗадания,СтатусОперации);	
	КонецЕсли; 	

КонецПроцедуры

&НаКлиенте
Процедура ОжидатьЗавершения(Знач ДлительнаяОперация, Знач ОповещениеОЗавершении = Неопределено, 
	Знач ПараметрыОжидания = Неопределено) Экспорт
	Если ДлительнаяОперация.Статус <> "Выполняется" Тогда
		Если ОповещениеОЗавершении <> Неопределено Тогда
			Если ДлительнаяОперация.Статус <> "Отменено" Тогда
				Результат = ДлительнаяОперация;
				Результат.Вставить("Сообщения", ?(ПараметрыОжидания <> Неопределено И ПараметрыОжидания.ВыводитьСообщения, 
					ДлительнаяОперация.Сообщения, Неопределено));
			Иначе
				Результат = Неопределено;
			КонецЕсли;
			
			Если ДлительнаяОперация.Статус = "Выполнено" И ПараметрыОжидания <> Неопределено Тогда
				//ПоказатьОповещение(ПараметрыОжидания);
			КонецЕсли;
			ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	//Если на момент обработки операция не была завершена 
	//запустим обработчик ожидания пока не поменяется статус задания 
	ОповещениеОЗавершенииФоновогоЗадания = ОповещениеОЗавершении;
	ПодключитьОбработчикОжидания("КонтрольДлительнойОперации",3,Истина);
	
КонецПроцедуры	
	
Функция СформироватьНаСервере(ПараметрыПроцедуры)

	//ПараметрыОперации - структура
	//	ИдентификаторФормы ИдентификаторФормы
	//	ДополнительныйРезультат Ложь
	//	ОжидатьЗавершение  ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 4, 2));
	//	НаименованиеФоновогоЗадания  ""
	//	КлючФоновогоЗадания "");
	//	АдресРезультата  Неопределено);
	//	ЗапуститьНеВФоне Ложь);
	//	ЗапуститьВФоне Ложь);
	//	БезРасширений Ложь);
	
	ПараметрыОперации = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыОперации.НаименованиеФоновогоЗадания = "Формирование отчета 'Шахматка'";	
	//	Мы знаем, что вторым элементом массива передается адрес сохранения результата
	ПараметрыОперации.АдресРезультата = ПараметрыПроцедуры[1]; 
	
	Результат = ДлительныеОперации.ВыполнитьВФоне("Обработки.Шахматка_MXL.Сформировать",ПараметрыПроцедуры,ПараметрыОперации);
	
	Возврат Результат;
КонецФункции // СформироватьНаСервере()

&НаКлиенте
Процедура СформироватьНачало()
	АдресРезультата = Неопределено;
	ИдентификаторЗадания = Неопределено;
	Элементы.Сформировать.Доступность = Ложь;
	
	ДатыИнтервалов = ПолучитьДатыИнтерваловБронирования(ТекущийПериод);
	
	Если ДатыИнтервалов = Неопределено Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВопросаОНенастроенныхИнтервалах",ЭтаФорма,ТекущийПериод);
		
		ПоказатьВопрос(ОписаниеОповещения,"По текущему периоду не настроены интервалы бронирования!
		|Хотите настроить сейчас?",РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да,"Невозможно сформировать отчет!");
		Возврат;
	
	КонецЕсли;
	
	ПараметрыФормированияОтчета = ДатыИнтервалов;
	ПараметрыФормированияОтчета.Вставить("ТекущийПериод",ТекущийПериод);
	
	ПараметрыЭкспортнойПроцедуры = Новый Массив;
	ПараметрыЭкспортнойПроцедуры.Добавить(ПараметрыФормированияОтчета);
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено,УникальныйИдентификатор);
	ПараметрыЭкспортнойПРоцедуры.Добавить(АдресХранилища);
	
	Результат = СформироватьНаСервере(ПараметрыЭкспортнойПроцедуры);
	
	ДополнительныеПараметры = Новый Структура("АдресРезультата",АдресХранилища);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеФормированияОтчетаВФоне",ЭтаФорма,ДополнительныеПараметры);
	Если Результат.Статус = "Выполнено" Тогда
	
		ВыполнитьОбработкуОповещения(ОписаниеОповещения,Результат);
		Возврат;
	
	КонецЕсли; 
	
	//Запустим обработку ожидания выполнения фонового задания (временно, возможно, пока не напишу глобальные процедуры)
	//Вместо // ДлительныеОперацииКлиент.ОжидатьЗавершения(Результат,ОписаниеОповещения);
	
	АдресРезультата = Результат.АдресРезультата;
	ОжидатьЗавершения(Результат,ОписаниеОповещения);
	
	
	//Обработка результата и запуск ожидания завершения
КонецПроцедуры


#Область ОбработчикиОповещений

Процедура НажатиеКнопкиНачальногоМеню(Результат,ДопПараметры)

КонецПроцедуры


Процедура ПослеЗакрытияФормыНастроек(Результат,ДопПараметры)


КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияОбработкиУправленияИнтервалами(Результат,ДопПараметры) Экспорт
	
	ПодключитьОбработчикОжидания("СформироватьНачало",0.1,Истина);			

КонецПроцедуры


&НаКлиенте
Процедура ПослеВопросаОНенастроенныхИнтервалах(Результат,ДопПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
	
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияОбработкиУправленияИнтервалами",ЭтаФорма);       
		ФормаУправленияИнтервалами = ОткрытьФорму("Обработка.ПериодыБронирования.Форма.Форма",Новый Структура("ТекущийПериод",ДопПараметры),ЭтаФорма,ЭтаФорма,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	
	КонецЕсли; 
	

КонецПроцедуры


#КонецОбласти

&НаКлиенте
Процедура Настройки(Команда)
	ПараметрыФормы = Новый Структура("", );
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияФормыНастроек",ЭтаФорма,);
	ОткрытьФорму("Обработка.Шахматка_MXL.Форма.ФормаНастроек",ПараметрыФормы,ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьЗаголовокКнопкиВыбораПериода();	
	ПодключитьОбработчикОжидания("СформироватьНачало",0.1,Истина);
#Если ВЕБКЛИЕНТ Тогда
	 
	Элементы.ПолеСнизу.Видимость = Истина;
	Элементы.ПолеСправа.Видимость = Истина;
	 
#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	ПодключитьОбработчикОжидания("СформироватьНачало",0.1,Истина);
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокЗначенийРасшифровки(Значение)

	Если ТипЗнч(Значение) =  Тип("ДокументСсылка.КарточкаБронирования") Тогда
		СписокДляВывода = Новый СписокЗначений();
		СписокДляВывода.Добавить(Значение,"Открыть " + Значение);
		СписокДляВывода.Добавить(Значение,"Взрослых/Детей: " + Значение.Взрослых + "/" + Значение.Детей);
		СписокДляВывода.Добавить(Значение,"Комментарий: " + Значение.Комментарий);
	КонецЕсли; 
	Возврат СписокДляВывода;	
КонецФункции

&НаКлиенте
Функция ПараметрыОбластейДляРасшифровки(Знач Выделенные = Неопределено)
	
	ПараметрыОбластей = Новый Массив;
	
	Если Выделенные = Неопределено Тогда
		Выделенные = ТаблицаОтчета.ВыделенныеОбласти;
	КонецЕсли;
		
		
	Для каждого Область Из Выделенные Цикл
		НачСтрока = Область.Верх;
		Для Строка = НачСтрока По Область.Низ Цикл
		    ДанныеОбласти = Новый Структура;
			ДанныеОбласти.Вставить("Строка",Строка);
			ДанныеОбласти.Вставить("НачальнаяКолонка",Область.Лево);
			ДанныеОбласти.Вставить("КонечнаяКолонка",Область.Право);
			ПараметрыОбластей.Добавить(ДанныеОбласти);
		КонецЦикла; 
		
	КонецЦикла;
	Возврат ПараметрыОбластей;
КонецФункции // ПараметрыОбластейДляРасшифровки()

&НаСервере
Функция ОбработатьРасшифровкуНаСервере(Расшифровка,Области = Неопределено)
	Результат = Новый Структура("Успех,СписокДляВывода,Параметры",Ложь);
	СписокДляВывода = Новый СписокЗначений;
	СписокДляВывода.Добавить("Создать","Создать бронирование");
	СписокДляВывода.Добавить("ПросмотрЦен","Просмотр перед оформлением");
	Результат.СписокДляВывода = СписокДляВывода;
	
	ПараметрыВыделенныхОбластей = Новый ТаблицаЗначений;
	Колонки = ПараметрыВыделенныхОбластей.Колонки;
	Колонки.Добавить("ДатаНачала");
	Колонки.Добавить("ДатаОкончания");
	Колонки.Добавить("Объект");
	Колонки.Добавить("Владелец");
	Колонки.Добавить("Обработана");	
	Для каждого Область Из Области Цикл
		СтрокаОбласти = ПараметрыВыделенныхОбластей.Добавить();
		СЧ = Область.НачальнаяКолонка;
		Пока СЧ <= Область.КонечнаяКолонка - 1 Цикл
			ТекОбласть = ТаблицаОтчета.ПолучитьОбласть(Область.Строка,СЧ);
			РасшифровкаОбласти = ТекОбласть.Область().Расшифровка;
			Если РасшифровкаОбласти = Неопределено Тогда
				ПараметрыВыделенныхОбластей.Удалить(СтрокаОбласти);
				Прервать; //Если в выбранные области случайно попала область которая не должна обрабатываться
			КонецЕсли;
			Если ТипЗНЧ(РасшифровкаОбласти) = Тип("ДокументСсылка.КарточкаБронирования") Тогда
				Результат.Успех = Ложь;
				ПараметрыРезультата = Новый Структура();
				ПараметрыРезультата.Вставить("Результат","Ошибка выбора");
				ПараметрыРезультата.Вставить("Описание","Неверно выбран диапазон таблицы");
				Результат.Параметры = ПараметрыРезультата;
				Возврат Результат;
			КонецЕсли;
			Если СЧ = Область.НачальнаяКолонка Тогда
				СтрокаОбласти.ДатаНачала = РасшифровкаОбласти.Дата;
				СтрокаОбласти.Объект = РасшифровкаОбласти.Объект;
				СтрокаОбласти.Владелец = РасшифровкаОбласти.Объект.Владелец;
				СтрокаОбласти.Обработана = Ложь;
			КонецЕсли;
			Если Область.КонечнаяКолонка = СЧ + 1 Тогда
				СтрокаОбласти.ДатаОкончания = РасшифровкаОбласти.Дата;				
			КонецЕсли; 
			
			
			СЧ = СЧ + 2;
		КонецЦикла; 
		
	КонецЦикла;	
	
	ПараметрыВыделенныхОбластей.Сортировать("ДатаНачала,Владелец,Объект");
	
	ПараметрыДляПередачи = Новый Структура;
		
	Если ПараметрыВыделенныхОбластей.Количество() = 1 Тогда
		СтрокаОбласти = ПараметрыВыделенныхОбластей[0];
		ПараметрыОбласти = Новый Структура("ДатаЗаезда,ДатаВыселения,Номер",СтрокаОбласти.ДатаНачала,СтрокаОбласти.ДатаОкончания,СтрокаОбласти.Объект);
		ПараметрыДляПередачи.Вставить("Последовательность1",Новый Структура("Объект1",ПараметрыОбласти));
		Результат.Успех = Истина;
		Результат.Параметры = ПараметрыДляПередачи;
		Возврат Результат;
	КонецЕсли; 
	
	ТЗВладельцев = ПараметрыВыделенныхОбластей.Скопировать(,"Владелец");
	ТЗВладельцев.Свернуть("Владелец");
	МассивВладельцев = ТЗВладельцев.ВыгрузитьКолонку("Владелец");
	
	ТЗОбъектов = ПараметрыВыделенныхОбластей.Скопировать(,"Объект");
	ТЗОбъектов.Свернуть("Объект");
	МассивОбъектов = ТЗОбъектов.ВыгрузитьКолонку("Объект");
	//Проверим, есть ли области, принадлежащие одному объекту (номеру) 
	//(такое возможно если выделение производилось одиночным кликом, а не выделением или несколькими выделениями)
	
	Для каждого ОбъектБронирования Из МассивОбъектов Цикл
		Отбор = Новый Структура("Объект",ОбъектБронирования);
		НайденыеСтроки = ПараметрыВыделенныхОбластей.НайтиСтроки(Отбор);
		ТекСтрока = Неопределено;
		Для каждого СтрокаПараметров Из НайденыеСтроки Цикл
			Если ТекСтрока = Неопределено Тогда
				ТекСтрока = СтрокаПараметров;
				Продолжить;
			КонецЕсли;	
			Если РаботаСДатамиКлиентСервер.ПрибавитьДень(ТекСтрока.ДатаОкончания,1) = СтрокаПараметров.ДатаНачала Тогда
				ТекСтрока.ДатаОкончания = СтрокаПараметров.ДатаОкончания;
				ПараметрыВыделенныхОбластей.Удалить(СтрокаПараметров);
			Иначе
				ТекСтрока = СтрокаПараметров;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
		
	
	
	//Проверим Совпадают ли даты начала и окончания выделеных областей
	//если совпадают, то добавим их в одну последовательность для возможности оформления по ним одного документа бронирования
	//если у всех выделенных строк совпадает дата начала и окончания.
	//различные гостиницы/корпуса оформляются в разные документы
	ПерваяСтрока = ПараметрыВыделенныхОбластей[0];
	Отбор = Новый Структура("ДатаНачала,ДатаОкончания",ПерваяСтрока.ДатаНачала,ПерваяСтрока.ДатаОкончания);
	НайденыеСтроки = ПараметрыВыделенныхОбластей.НайтиСтроки(Отбор);
	
	Если НайденыеСтроки.Количество() = ПараметрыВыделенныхОбластей.Количество() Тогда
		НомерПоследовательности = 0;
		Для каждого Владелец Из МассивВладельцев Цикл
			НомерОбъекта = 0;
			СтруктураОбъектов = Новый Структура;
			НайденыеСтроки = ПараметрыВыделенныхОбластей.НайтиСтроки(Новый Структура("Владелец",Владелец));
			Для каждого СтрокаОбласти Из НайденыеСтроки Цикл
				ПараметрыОбласти = Новый Структура("ДатаЗаезда,ДатаВыселения,Номер",СтрокаОбласти.ДатаНачала,СтрокаОбласти.ДатаОкончания,СтрокаОбласти.Объект);
				СтруктураОбъектов.Вставить("Объект" + НомерОбъекта,ПараметрыОбласти);
				НомерОбъекта = НомерОбъекта + 1;
			КонецЦикла;	
			ПараметрыДляПередачи.Вставить("Последовательность" + НомерПоследовательности,СтруктураОбъектов);	
			НомерПоследовательности = НомерПоследовательности + 1;
		КонецЦикла;
		
		Результат.Успех = Истина;
		Результат.Параметры = ПараметрыДляПередачи;
		Возврат Результат;
	КонецЕсли;
	
	//возможно каждая выделеная область является продолжением другой
	//т.е. оформляется бронирование с переселением в другой номер
	НомерПоследовательности = 0;
	Для каждого Владелец Из МассивВладельцев Цикл
		НомерОбъекта = 0;
		
		НайденыеСтроки = ПараметрыВыделенныхОбластей.НайтиСтроки(Новый Структура("Владелец",Владелец));
		НачальнаяДата = Неопределено;
		КонечнаяДата = Неопределено;
		КоличествоДнейПоСтрокам = 0;
		СтруктураОбъектов = Новый Структура;
		
		Для каждого СтрокаОбласти Из НайденыеСтроки Цикл
		
			НачальнаяДата = ?(НачальнаяДата = Неопределено,СтрокаОбласти.ДатаНачала,Мин(НачальнаяДата,СтрокаОбласти.ДатаНачала));
			КонечнаяДата = ?(КонечнаяДата = Неопределено,СтрокаОбласти.ДатаОкончания,Макс(КонечнаяДата,СтрокаОбласти.ДатаОкончания));
			КоличествоДнейПоСТрокам = КоличествоДнейПоСтрокам + РаботаСДатамиКлиентСервер.КоличествоДней(СтрокаОбласти.ДатаНачала,КонецДня(СтрокаОбласти.ДатаОкончания) + 1);
			
			ПараметрыОбласти = Новый Структура("ДатаЗаезда,ДатаВыселения,Номер",СтрокаОбласти.ДатаНачала,СтрокаОбласти.ДатаОкончания,СтрокаОбласти.Объект);
			СтруктураОбъектов.Вставить("Объект" + НомерОбъекта,ПараметрыОбласти);
			НомерОбъекта = НомерОбъекта + 1;
		КонецЦикла;
		КоличествоДнейПоСтрокам = КоличествоДнейПоСтрокам - 1;
		Если РаботаСДатамиКлиентСервер.КоличествоДней(НачальнаяДата,КонечнаяДата) =  КоличествоДнейПоСтрокам Тогда
			СтруктураОбъектов.Вставить("СПереселением",Истина);
			СтруктураОбъектов.Вставить("ДатаВыселения",КонечнаяДата);
		Иначе
			
			// если среди выбранных областей нет последовательных интервалов уберем возможность автоматического ввода бронирования
			ЭлементСписка = СписокДляВывода.НайтиПоЗначению("Создать");
			Если НЕ ЭлементСписка = Неопределено Тогда
				СписокДляВывода.Удалить(ЭлементСписка);
			КонецЕсли;
			
		КонецЕсли; 
		ПараметрыДляПередачи.Вставить("Последовательность" + НомерПоследовательности,СтруктураОбъектов);	
		НомерПоследовательности = НомерПоследовательности + 1;
	КонецЦикла;
	
	Результат.Успех = Истина;
	Результат.Параметры = ПараметрыДляПередачи;
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьРасшифровкуКлиент(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		//Подготовим данные о выделеннойОбласти для передачи на сервер
		МассивВыделенныхОбластей = ПараметрыОбластейДляРасшифровки();
		Результат = ОбработатьРасшифровкуНаСервере(Расшифровка,МассивВыделенныхОбластей);
		Если НЕ Результат.Успех Тогда
			Возврат;
		КонецЕсли; 
		СписокДляВывода = Результат.СписокДляВывода;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораИзСписка",ЭтаФорма,Результат.Параметры);
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораИзСписка",ЭтаФорма,);
		СписокДляВывода = ПолучитьСписокЗначенийРасшифровки(Расшифровка);
	КонецЕсли; 

	ПоказатьВыборИзМеню(ОписаниеОповещения,СписокДляВывода,Элемент);  
КонецПроцедуры


&НаКлиенте
Процедура ТаблицаОтчетаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
#Если ВебКлиент Тогда
 	
#ИначеЕсли МобильныйКлиент Тогда
	ОбработатьРасшифровкуКлиент(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
#ИНАЧЕ	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;				
	КонецЕсли;
#КонецЕсли
КонецПроцедуры



&НаКлиенте
Процедура ТаблицаОтчетаОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
#Если ВебКлиент Тогда
    ОбработатьРасшифровкуКлиент(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
#ИначеЕсли МобильныйКлиент Тогда
	//Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
	//	СтандартнаяОбработка = Ложь;				
	//КонецЕсли;		
#ИНАЧЕ	
	ОбработатьРасшифровкуКлиент(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры);
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	ПодключитьОбработчикОжидания("СформироватьНачало",0.1,Истина);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокКнопкиВыбораПериода()

	Элементы.кнВыборПериода.Заголовок = Формат(ТекущийПериод,"ЧГ=") + " г."	

КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораПериода(Результат,ДопПараметры) Экспорт

	Если НЕ Результат = Неопределено Тогда
	
		ТекущийПериод = Результат;
		УстановитьЗаголовокКнопкиВыбораПериода();
		ПодключитьОбработчикОжидания("СформироватьНачало",0.1,Истина);
	
	КонецЕсли; 

КонецПроцедуры


&НаКлиенте
Процедура ВыборПериода(Команда)
	ПараметрыФормы = Новый Структура("ТекущийПериод",ТекущийПериод);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораПериода",ЭтаФорма);
	ОткрытьФорму("Обработка.ПериодыБронирования.Форма",ПараметрыФормы,ЭтаФорма,ЭтаФорма,,,ОписаниеОповещения,РежимОткрытияОкнаФОрмы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ТекущийПериод = 0 Тогда
		ТекущийПериод = ГОД(ТекущаяДатаСеанса());
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОтчетаОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	Состояние("Перетаскивание");
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОтчетаПриИзмененииСодержимогоОбласти(Элемент, Область, ДополнительныеПараметры)
	Состояние("ПриИзмененииСодержимого")
КонецПроцедуры


