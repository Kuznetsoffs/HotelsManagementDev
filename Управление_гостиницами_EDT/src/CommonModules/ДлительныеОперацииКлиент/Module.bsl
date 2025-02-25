Функция ПараметрыОжидания(ФормаВладелец) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ФормаВладелец", ФормаВладелец);
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("ВыводитьОкноОжидания", Истина);
	Результат.Вставить("ВыводитьПрогрессВыполнения", Ложь);
	Результат.Вставить("ОповещениеОПрогрессеВыполнения", Неопределено);
	Результат.Вставить("ВыводитьСообщения", Ложь);
	Результат.Вставить("Интервал", 0);
	Результат.Вставить("ПолучатьРезультат", Ложь);
	
	ОповещениеПользователя = Новый Структура;
	ОповещениеПользователя.Вставить("Показать", Ложь);
	ОповещениеПользователя.Вставить("Текст", Неопределено);
	ОповещениеПользователя.Вставить("НавигационнаяСсылка", Неопределено);
	ОповещениеПользователя.Вставить("Пояснение", Неопределено);
	Результат.Вставить("ОповещениеПользователя", ОповещениеПользователя);
	
	Возврат Результат;
	
КонецФункции

Процедура ПоказатьОповещение(ДлительнаяОперация) Экспорт
	
	Оповещение = ДлительнаяОперация.ОповещениеПользователя;
	Если Не Оповещение.Показать Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(?(Оповещение.Текст <> Неопределено, Оповещение.Текст, НСтр("ru = 'Действие выполнено'")), 
		Оповещение.НавигационнаяСсылка, Оповещение.Пояснение);

КонецПроцедуры


Процедура ОжидатьЗавершения(Знач ДлительнаяОперация, Знач ОповещениеОЗавершении = Неопределено, 
	Знач ПараметрыОжидания = Неопределено) Экспорт
	
	Если ДлительнаяОперация.Статус <> "Выполняется" Тогда
		Если ОповещениеОЗавершении <> Неопределено Тогда
			Если ДлительнаяОперация.Статус <> "Отменено" Тогда
				Результат = Новый Структура;
				Результат.Вставить("Статус", ДлительнаяОперация.Статус);
				Результат.Вставить("АдресРезультата", ДлительнаяОперация.АдресРезультата);
				Результат.Вставить("АдресДополнительногоРезультата", ДлительнаяОперация.АдресДополнительногоРезультата);
				Результат.Вставить("КраткоеПредставлениеОшибки", ДлительнаяОперация.КраткоеПредставлениеОшибки);
				Результат.Вставить("ПодробноеПредставлениеОшибки", ДлительнаяОперация.ПодробноеПредставлениеОшибки);
				Результат.Вставить("Сообщения", ?(ПараметрыОжидания <> Неопределено И ПараметрыОжидания.ВыводитьСообщения, 
				ДлительнаяОперация.Сообщения, Неопределено));
			Иначе
				Результат = Неопределено;
			КонецЕсли;
			
			Если ДлительнаяОперация.Статус = "Выполнено" И ПараметрыОжидания <> Неопределено Тогда
				ПоказатьОповещение(ПараметрыОжидания);
			КонецЕсли;
			ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = ПараметрыОжидания(Неопределено);
	Если ПараметрыОжидания <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыФормы, ПараметрыОжидания);
	КонецЕсли;
	ПараметрыФормы.Вставить("АдресРезультата", ДлительнаяОперация.АдресРезультата);
	ПараметрыФормы.Вставить("АдресДополнительногоРезультата", ДлительнаяОперация.АдресДополнительногоРезультата);
	ПараметрыФормы.Вставить("ИдентификаторЗадания", ДлительнаяОперация.ИдентификаторЗадания);
	
	Если ПараметрыФормы.ВыводитьОкноОжидания Тогда
		ПараметрыФормы.Удалить("ФормаВладелец");
		
		ОткрытьФорму("ОбщаяФорма.ДлительнаяОперация", ПараметрыФормы, 
			?(ПараметрыОжидания <> Неопределено, ПараметрыОжидания.ФормаВладелец, Неопределено),
			,,,ОповещениеОЗавершении);
	Иначе
		ПараметрыФормы.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
		ПараметрыФормы.Вставить("ТекущийИнтервал", ?(ПараметрыФормы.Интервал <> 0, ПараметрыФормы.Интервал, 1));
		ПараметрыФормы.Вставить("Контроль", ТекущаяДата() + ПараметрыФормы.ТекущийИнтервал); // дата сеанса не используется
		
		//ПодключитьОбработчикОжидания("КонтрольДлительныхОпераций", ПараметрыФормы.ТекущийИнтервал, Истина);
	КонецЕсли;
	
КонецПроцедуры