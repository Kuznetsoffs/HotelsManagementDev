
Функция ПолучитьЗначениеЦветаОформления(НазваниеЦвета)

	Если НазваниеЦвета = "ЦветОбъекта" Тогда
		Возврат ЦветаСтиля.Шахматка_ЦветОбъекта
	ИначеЕсли НазваниеЦвета = "ЦветСвободного" Тогда
		Возврат ЦветаСтиля.Шахматка_ЦветСвободного;
	ИначеЕсли НазваниеЦвета = "ЦветТекстаСвободного" Тогда
		Возврат ЦветаСтиля.Шахматка_ЦветТекстаСвободного;
	ИначеЕсли НазваниеЦвета = "ЦветВнимание" Тогда
		Возврат ЦветаСтиля.Шахматка_ЦветВнимание;
	ИначеЕсли НазваниеЦвета = "ЦветНедоступного" Тогда
		Возврат ЦветаСтиля.Шахматка_ЦветНедоступного;
	ИначеЕсли НазваниеЦвета = "ЦветЗабронированного" Тогда
		Возврат ЦветаСтиля.Шахматка_ЦветЗабронированного;
	ИначеЕсли НазваниеЦвета = "ЦветПредБронированного" Тогда
		Возврат ЦветаСтиля.Шахматка_ЦветПредБронированного;
	ИначеЕсли НазваниеЦвета = "ФонШапки" Тогда
		Возврат ЦветаСтиля.Шахматка_ЦветФонаШапки;
	ИначеЕсли НазваниеЦвета = "ТекстШапки" Тогда
		Возврат ЦветаСтиля.Шахматка_ЦветТекстаШапки;
	КонецЕсли;

КонецФункции // ПолучитьЗначениеЦветаОформления()()

Функция ПолучитьДанныеПоОбъекту(Знач ОбъектОтчета, ПараметрыОтчета = Неопределено) Экспорт
	ТаблицаДанных  = "Номера";
	Если ТипЗнч(ОбъектОтчета) = Тип("СправочникСсылка.Гостиницы") Тогда
		Если УправлениеГостиницамиВызовСервера.ЭтоГостиничныйКомплекс(ОбъектОтчета) Тогда
			ТаблицаДанных = "Корпуса";
		КонецЕсли;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
				   |	Таблица.Ссылка КАК Ссылка
				   |ИЗ
				   |	Справочник." + ТаблицаДанных + " КАК Таблица
													   |ГДЕ
													   |	Таблица.Владелец = &ОбъектОтчета
													   |УПОРЯДОЧИТЬ ПО
													   |	Таблица.Наименование";

	Запрос.УстановитьПараметр("ОбъектОтчета", ОбъектОтчета);

	РезультатЗапроса = Запрос.Выполнить();

	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");

КонецФункции // ПолучитьДанныеПоОбъекту()

Функция ВывестиПустую(Знач ОбъектОтчета, ПараметрыОтчета, Макет, Уровень)
	Таблица = Новый ТабличныйДокумент;

	ЦветОбъекта = ПолучитьЗначениеЦветаОформления("ЦветОбъекта");
	НетЛинии = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, , );

	ОбластьЗаголовкаОбъекта = Макет.ПолучитьОбласть("Строка" + Уровень + "|Объекты");
	ОбластьЗаголовкаОбъекта.Параметры.Объект = ОбъектОтчета;
	ТекОбласть = Таблица.Вывести(ОбластьЗаголовкаОбъекта, Уровень);
	ТекОбласть.ЦветФона = ЦветОбъекта;

	ТекущаяДата = ПараметрыОтчета.ДатаНачала;
	ПустаяОбласть = Неопределено;
	ОбластьДляДобавления = Макет.ПолучитьОбласть("Строка|Даты");
	Пока ТекущаяДата <= ПараметрыОтчета.ДатаОкончания Цикл
		Если ПустаяОбласть = Неопределено Тогда
			ПустаяОбласть = Новый ТабличныйДокумент;
			ТекОбласть = ПустаяОбласть.Вывести(ОбластьДляДобавления);
		Иначе
			ТекОбласть = ПустаяОбласть.Присоединить(ОбластьДляДобавления);
		КонецЕсли;
		Если Не ТекущаяДата = ПараметрыОтчета.ДатаОкончания Тогда
			ТекОбласть.ГраницаСправа = НетЛинии;
		КонецЕсли;

		ТекущаяДата = КонецДня(ТекущаяДата) + 1;
	КонецЦикла;

	ТекОбласть = Таблица.Присоединить(ПустаяОбласть);
	ТекОбласть.ЦветФона = ЦветОбъекта;
//	ТекОбласть.Объединить();
	Возврат Таблица;

КонецФункции // ВывестиПустую()

Функция ПолучитьДатыИнтерваловБронирования(Период = Неопределено, ОбъектБронирования = Неопределено) Экспорт

	Если Период = Неопределено Тогда

		Период = ГОД(ТекущаяДатаСеанса());

	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(МИНИМУМ(ПериодыБронирования.ДатаНачалаБронирования),ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ДатаНачала,
	|	ЕСТЬNULL(МАКСИМУМ(ПериодыБронирования.ДатаОкончанияБронирования),ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ДатаОкончания
	|ИЗ
	|	РегистрСведений.ПериодыБронирования КАК ПериодыБронирования
	|ГДЕ
	|	ПериодыБронирования.ПериодБронирования = &Период";
	Запрос.Текст = Запрос.Текст + ?(ОбъектБронирования = Неопределено, "", "
																		   |	И ПериодыБронирования.Объект = &Объект");
	Запрос.УстановитьПараметр("Период", Период);
	Если Не ОбъектБронирования = Неопределено Тогда

		Запрос.УстановитьПараметр("Объект", ОбъектБронирования);

	КонецЕсли;
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	ДатыИнтервалов = Новый Структура("ДатаНачала,ДатаОкончания");
	Пока Выборка.Следующий() Цикл
		Если Выборка.ДатаНачала = '00010101000000' Или Выборка.ДатаОкончания = '00010101000000' Тогда
			Возврат Неопределено;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ДатыИнтервалов, Выборка);
	КонецЦикла;

	Возврат ДатыИнтервалов;

КонецФункции // ()


Функция ЗаполнитьТаблицуПоОбъектам(ПараметрыОтчета, Макет,Знач ДанныеПоОбъектам)
	Таблица = Новый ТабличныйДокумент;
	//Определим цвета
	ЦветОбъекта 		= ПолучитьЗначениеЦветаОформления("ЦветОбъекта");
	ЦветСвободного 		= ПолучитьЗначениеЦветаОформления("ЦветСвободного");
	ЦветТекстаСвободного= ПолучитьЗначениеЦветаОформления("ЦветТекстаСвободного");
	ЦветНедоступного 	= ПолучитьЗначениеЦветаОформления("ЦветНедоступного");
	ЦветЗабронированного 	= ПолучитьЗначениеЦветаОформления("ЦветЗабронированного");
	ЦветПредБронированного 	= ПолучитьЗначениеЦветаОформления("ЦветПредБронированного");
	ЦветВнимание = ПолучитьЗначениеЦветаОформления("ЦветВнимание");
	РазделяющаяЛиния = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Двойная, 1, Истина);
	ЛинияРазделяющаяБронирования = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2, Истина);
	НетЛинии = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, , );
	
	Объекты = ДанныеПоОбъектам.Строки;
	
	Для Каждого ДанныеГостиницы Из Объекты Цикл 
		СтрокаОбъекта = ВывестиПустую(ДанныеГостиницы.Гостиница, ПараметрыОтчета, Макет, 0);
		Таблица.Вывести(СтрокаОбъекта, 0);
		
		Для Каждого ДанныеКорпуса Из ДанныеГостиницы.Строки Цикл
			Если ЗначениеЗаполнено(ДанныеКорпуса.Корпус) Тогда
				СтрокаОбъекта = ВывестиПустую(ДанныеКорпуса.Корпус, ПараметрыОтчета, Макет, 1);
				Таблица.Вывести(СтрокаОбъекта, 0);
			КонецЕсли;
			
			Для Каждого ДанныеНомера Из ДанныеКорпуса.Строки Цикл
				//Выведем заголовки номера
				ОбластьЗаголовкаОбъекта = Макет.ПолучитьОбласть("Строка" + 2 + "|Объекты");
				ОбластьЗаголовкаОбъекта.Параметры.Объект = ДанныеНомера.Номер;
				ТекОбласть = Таблица.Вывести(ОбластьЗаголовкаОбъекта, 2);
				ТекОбласть.ЦветФона = ЦветОбъекта;
				//заполним данные по номеру
				ТекущаяДата = ПараметрыОтчета.ДатаНачала;

				ОбластьДаты = Макет.ПолучитьОбласть("Строка|Даты");
				Пока ТекущаяДата <= ПараметрыОтчета.ДатаОкончания Цикл
					ДанныеДляВывода = ДанныеНомера.Строки;
					СтрокаСтатуса = ДанныеДляВывода.Найти(ТекущаяДата, "Дата");
					Если СтрокаСтатуса = Неопределено Тогда

						ПараметрРасшифровки = Новый Структура;
						ПараметрРасшифровки.Вставить("Дата", ТекущаяДата);
						ПараметрРасшифровки.Вставить("Объект", ДанныеНомера.Номер);
						ОбластьДаты.Параметры.ДанныеБронирования = Строка(День(ТекущаяДата)) + " " + Формат(
							ТекущаяДата, "ДФ=ММММ");
						ОбластьДаты.Параметры.ПараметрРасшифровки = ПараметрРасшифровки;

						ТекОбласть = Таблица.Присоединить(ОбластьДаты);
						ТекущийДеньСтрокой = Строка(Формат(День(ТекущаяДата), "ЧЦ=2; ЧВН="));
						Если Не СтрНайти("10 20", ТекущийДеньСтрокой) = 0 Тогда
							ТекОбласть.ГраницаСправа = РазделяющаяЛиния;
						ИначеЕсли КонецДня(ТекущаяДата) = КонецМесяца(ТекущаяДата) Тогда
							ТекОбласть.ГраницаСправа = РазделяющаяЛиния;
						КонецЕсли;
						Если ТекущаяДата <= ДанныеНомера.ДатаОкончанияБронирования И ТекущаяДата
							>= ДанныеНомера.ДатаНачалаБронирования Тогда
							ТекОбласть.ЦветФона   = ЦветСвободного;
							ТекОбласть.ЦветТекста = ЦветСвободного; //ЦветТекстаСвободного;
						Иначе
							ТекОбласть.ЦветФона   = ЦветНедоступного;
							ТекОбласть.ЦветТекста = ЦветНедоступного;
						КонецЕсли;
						ТекОбласть.Отступ = 6;

					Иначе
						ДокументБронирования = СтрокаСтатуса.Регистратор;
						Отбор = Новый Структура("Регистратор", ДокументБронирования);
						НайденыеСтроки = ДанныеДляВывода.НайтиСтроки(Отбор);
						ОбластьДляВывода = Неопределено;
						Для Каждого СтрокаБронирования Из НайденыеСтроки Цикл

							Если СтрокаБронирования.Дата - ТекущаяДата > 86400 Тогда //по текущему номеру есть разрыв бронирования

								Прервать;

							КонецЕсли;

							Если ОбластьДляВывода = Неопределено Тогда
								ОбластьДляВывода = Новый ТабличныйДокумент;
								ОбластьДаты.Параметры.ДанныеБронирования = СтрокаБронирования.Клиент;
								ОбластьДаты.Параметры.ПараметрРасшифровки = ДокументБронирования;
								ОбластьДляВывода.Вывести(ОбластьДаты);
							Иначе
								ОбластьДаты.Параметры.ДанныеБронирования = "";
								ОбластьДляВывода.Присоединить(ОбластьДаты);
							КонецЕсли;
							ТекущаяДата = Макс(ТекущаяДата, СтрокаБронирования.Дата);
							СтрокаБронирования.Дата = Дата('00010101');
							СтрокаБронирования.Регистратор = Неопределено;

						КонецЦикла;
						ТекОбласть = Таблица.Присоединить(ОбластьДляВывода);
						Если СтрокаСтатуса.СтатусБрони = Перечисления.СтатусБрони.Предварительная Тогда
							Если ЗначениеЗаполнено(ДокументБронирования.ДатаПлатежа) И ДокументБронирования.ДатаПлатежа
								<= ТекущаяДатаСеанса() Тогда
								ЦветФона = ЦветВнимание;
								ТекОбласть.Текст = "! " + ТекОбласть.Текст;
							Иначе
								ЦветФона = ЦветПредБронированного;
							КонецЕсли;
						Иначе
							ЦветФона = ЦветЗабронированного;

						КонецЕсли;
						ТекОбласть.ЦветФона = ЦветФона;
						ТекОбласть.Объединить();
						ТекОбласть.ГраницаСправа = ЛинияРазделяющаяБронирования;
						ТекОбласть.ЦветРамки = ЦветСвободного;			
						ТекОбласть.Отступ = 0;
					КонецЕсли;
					ТекущаяДата = КонецДня(ТекущаяДата) + 1;
				КонецЦикла;
				
				
			КонецЦикла;
			
						
		КонецЦикла;	
		
	КонецЦикла;

	Возврат Таблица;

КонецФункции

Функция СформироватьШапку(ПараметрыОтчета, Макет)
	Таблица = Новый ТабличныйДокумент;
	РазделяющаяЛиния = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Двойная, 1, Истина);
	НетЛинии = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, , );
	ДатаНачала = ПараметрыОтчета.ДатаНачала;
	ДатаОкончания = ПараметрыОтчета.ДатаОкончания;
	// неизменяемая часть шапки
	ОбластьШапки = Макет.ПолучитьОбласть("Шапка|Объекты");
	ОбластьЯчеекШапки = ОбластьШапки.Область();

	ЗаголовкиМесяцев = Новый Массив;
	Таблица.Вывести(ОбластьШапки);
	// Формируемая часть шапки

	ТекущаяДата = ДатаНачала;
	ТекущийМесяц = "";
	ОбластьЗаголовокМесяца = Неопределено;
	ОбластьШапкиЗаголовкиМесяцев = Неопределено;
	ОбластьШапкиДни = Неопределено;
	ОбластьМесяц = Макет.ПолучитьОбласть("ШапкаМесяц|Даты");
	ОбластьДень = Макет.ПолучитьОбласть("ШапкаДата|Даты");
	ВыведеноДней = 0;

	Пока ТекущаяДата <= ДатаОкончания Цикл

		Месяц = Формат(ТекущаяДата, "ДФ=ММММ");

		Если Не ТекущийМесяц = Месяц Тогда  //Сменился месяц

			Если Не ОбластьЗаголовокМесяца = Неопределено Тогда
				ОбластьДляВывода = ОбластьЗаголовокМесяца.ПолучитьОбласть(1, 1, 1, ВыведеноДней * 2);
				Если ОбластьШапкиЗаголовкиМесяцев = Неопределено Тогда
					ОбластьШапкиЗаголовкиМесяцев = Новый ТабличныйДокумент;
					ТекОбласть = ОбластьШапкиЗаголовкиМесяцев.Вывести(ОбластьДляВывода);
				Иначе
					ТекОбласть = ОбластьШапкиЗаголовкиМесяцев.Присоединить(ОбластьДляВывода);
				КонецЕсли;
				ТекОбласть.Объединить();
				ТекОбласть.ГраницаСправа = РазделяющаяЛиния;
				//ТекОбласть.ГраницаСлева = НетЛинии;
			КонецЕсли;
			ОбластьЗаголовокМесяца = Новый ТабличныйДокумент;
			ОбластьМесяц.Параметры.Месяц = Месяц;
			ОбластьЗаголовокМесяца.Вывести(ОбластьМесяц);

			ВыведеноДней = 0;
			ТекущийМесяц = Месяц;
		Иначе
			//Дополнение заголовка месяца ячейками для соответствия количеству дней
			ОбластьМесяц.Параметры.Месяц = "";
			ОбластьЗаголовокМесяца.Присоединить(ОбластьМесяц);
		КонецЕсли;
		
		
		//ВыводДней
		ОбластьДень.Параметры.День = День(ТекущаяДата);

		Если ОбластьШапкиДни = Неопределено Тогда
			ОбластьШапкиДни = Новый ТабличныйДокумент;
			ТекОбластьШапки = ОбластьШапкиДни.Вывести(ОбластьДень);
		Иначе
			ТекОбластьШапки = ОбластьШапкиДни.Присоединить(ОбластьДень);	
			//ТекОбластьШапки.ГраницаСлева = НетЛинии;
		КонецЕсли;

		ТекущийДеньСтрокой = Строка(Формат(День(ТекущаяДата), "ЧЦ=2; ЧВН="));
		Если Не СтрНайти("10 20", ТекущийДеньСтрокой) = 0 Тогда
			ТекОбластьШапки.ГраницаСправа = РазделяющаяЛиния;
		ИначеЕсли КонецДня(ТекущаяДата) = КонецМесяца(ТекущаяДата) Тогда
			ТекОбластьШапки.ГраницаСправа = РазделяющаяЛиния;
		КонецЕсли;

		ВыведеноДней = ВыведеноДней + 1;
		ТекущаяДата = КонецДня(ТекущаяДата) + 1;
	КонецЦикла;

	ОбластьДляВывода = ОбластьЗаголовокМесяца.ПолучитьОбласть(1, 1, 1, ВыведеноДней * 2);

	Если ОбластьШапкиЗаголовкиМесяцев = Неопределено Тогда
		ОбластьШапкиЗаголовкиМесяцев = Новый ТабличныйДокумент;
		ТекОбласть = ОбластьШапкиЗаголовкиМесяцев.Вывести(ОбластьДляВывода);
	Иначе
		ТекОбласть = ОбластьШапкиЗаголовкиМесяцев.Присоединить(ОбластьДляВывода);
	КонецЕсли;
	ТекОбласть.Объединить();
	ОбластьШапкиПрограммно = Новый ТабличныйДокумент;
	ОбластьШапкиПрограммно.Вывести(ОбластьШапкиЗаголовкиМесяцев);
	ОбластьШапкиПрограммно.Вывести(ОбластьШапкиДни);
	Таблица.Присоединить(ОбластьШапкиПрограммно);

	Возврат Таблица;

КонецФункции // СформироватьШапку()

Функция ПолучитьДанныеПоОбъектам(ПараметрыОтчета)
	ЗапросДанных = Новый Запрос;
	ЗапросДанных.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПериодыБронирования.Объект КАК Объект,
		|	ПериодыБронирования.ДатаНачалаБронирования КАК ДатаНачалаБронирования,
		|	ПериодыБронирования.ДатаОкончанияБронирования КАК ДатаОкончанияБронирования
		|ПОМЕСТИТЬ ОбъектыИДатыБронирования
		|ИЗ
		|	РегистрСведений.ПериодыБронирования КАК ПериодыБронирования
		|ГДЕ
		|	ПериодыБронирования.ПериодБронирования = &Период
		|СГРУППИРОВАТЬ ПО
		|	ПериодыБронирования.Объект,
		|	ПериодыБронирования.ДатаНачалаБронирования,
		|	ПериодыБронирования.ДатаОкончанияБронирования
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Номера.Ссылка КАК Номер,
		|	Номера.Владелец КАК Владелец
		|ПОМЕСТИТЬ Номера
		|ИЗ
		|	Справочник.Номера КАК Номера
		|ГДЕ
		|	Номера.Владелец В
		|		(ВЫБРАТЬ
		|			ОбъектыИДатыБронирования.Объект КАК Объект
		|		ИЗ
		|			ОбъектыИДатыБронирования КАК ОбъектыИДатыБронирования)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(Номера.Владелец) = ТИП(Справочник.Корпуса)
		|			ТОГДА Номера.Владелец.Владелец
		|		ИНАЧЕ Номера.Владелец
		|	КОНЕЦ КАК Гостиница,
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(Номера.Владелец) = ТИП(Справочник.Корпуса)
		|			ТОГДА Номера.Владелец
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Корпуса.ПустаяСсылка)
		|	КОНЕЦ КАК Корпус,
		|	Номера.Номер КАК Номер,
		|	ОбъектыИДатыБронирования.ДатаНачалаБронирования КАК ДатаНачалаБронирования,
		|	ОбъектыИДатыБронирования.ДатаОкончанияБронирования КАК ДатаОкончанияБронирования,
		|	СтатусыНомеров.Регистратор КАК Регистратор,
		|	СтатусыНомеров.Дата КАК Дата,
		|	СтатусыНомеров.Статус КАК Статус,
		|	СтатусыНомеров.Регистратор.Клиент Как Клиент,
		|	СтатусыНомеров.Регистратор.СтатусБрони КАК СтатусБрони
		|ИЗ
		|	Номера КАК Номера
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыНомеров КАК СтатусыНомеров
		|		ПО (Номера.Номер = СтатусыНомеров.Номер)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ОбъектыИДатыБронирования КАК ОбъектыИДатыБронирования
		|		ПО (Номера.Владелец = ОбъектыИДатыБронирования.Объект)
		|ГДЕ
		|	СтатусыНомеров.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|
		|УПОРЯДОЧИТЬ ПО
		|	Гостиница,
		|	Корпус,
		|	Номер,
		|	Дата
		|АВТОУПОРЯДОЧИВАНИЕ
		|ИТОГИ
		|	МИНИМУМ(ДатаНачалаБронирования),
		|	МАКСИМУМ(ДатаОкончанияБронирования)
		|ПО
		|	Гостиница,
		|	Корпус,
		|	Номер";

	ЗапросДанных.УстановитьПараметр("ДатаНачала", ПараметрыОтчета.ДатаНачала);
	ЗапросДанных.УстановитьПараметр("ДатаОкончания", ПараметрыОтчета.ДатаОкончания);
	ЗапросДанных.УстановитьПараметр("Период", ПараметрыОтчета.ТекущийПериод);
	
	Результат = ЗапросДанных.Выполнить();
	ДанныеПоОбъектам = Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	Возврат ДанныеПоОбъектам;
	
КонецФункции

Процедура Сформировать(ПараметрыОтчета,АдресХранилища="") Экспорт
	
	Результат = Новый Структура("Успех,Результат",Истина,"Возвращаемый результат выполнения процедуры");
	// Основные цвета таблицы
	ФонШапки 	= ПолучитьЗначениеЦветаОформления("ФонШапки");
	ТекстШапки 	= ПолучитьЗначениеЦветаОформления("ТекстШапки");
	
	// Сформеруем таблицу отчета
	Таблица = Новый ТабличныйДокумент;
	ИмяМакета = "ПФ_XML_Шахматка";
	Макет = ПолучитьМакет(ИмяМакета);
	// начнем с заполненияи и вывода шапкики отчета
	ДанныеШапки = СформироватьШапку(ПараметрыОтчета, Макет);
	ТекОбласть = Таблица.Вывести(ДанныеШапки);
	ТекОбласть.ЦветФона = ФонШапки;
	ТекОбласть.ЦветТекста = ТекстШапки;

	ОбластьУглаШапки = Макет.ПолучитьОбласть("Шапка|Объекты").Область();
	
	ДанныеПоОбъектам = ПолучитьДанныеПоОбъектам(ПараметрыОтчета);						 
	
	ДанныеОбъектов = ЗаполнитьТаблицуПоОбъектам(ПараметрыОтчета,Макет,ДанныеПООбъектам);
	Таблица.Вывести(ДанныеОбъектов);
	
	Результат.Вставить("Таблица",Таблица);
	Результат.Вставить("ФиксацияСверху",ОбластьУглаШапки.Низ);
	Результат.Вставить("ФиксацияСлева",ОбластьУглаШапки.Право);
	ПоместитьВоВременноеХранилище(Результат,АдресХранилища);

КонецПроцедуры

#Область СтарыйКод
//Функция ЗаполнитьТаблицуПоНомеру(ОбъектОтчета, ПараметрыОтчета, Макет, Уровень)
//	Таблица = Новый ТабличныйДокумент;	
//	//Определим цвета
//	ЦветОбъекта 		= ПолучитьЗначениеЦветаОформления("ЦветОбъекта");
//	ЦветСвободного 		= ПолучитьЗначениеЦветаОформления("ЦветСвободного");
//	ЦветТекстаСвободного= ПолучитьЗначениеЦветаОформления("ЦветТекстаСвободного");
//	ЦветНедоступного 	= ПолучитьЗначениеЦветаОформления("ЦветНедоступного");
//	ЦветЗабронированного 	= ПолучитьЗначениеЦветаОформления("ЦветЗабронированного");
//	ЦветПредБронированного 	= ПолучитьЗначениеЦветаОформления("ЦветПредБронированного");
//	ЦветВнимание = ПолучитьЗначениеЦветаОформления("ЦветВнимание");
//	РазделяющаяЛиния = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Двойная, 1, Истина);
//	ЛинияРазделяющаяБронирования = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2, Истина);
//	НетЛинии = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, , );
//	//Выведем заголовок объекта
//	ОбластьЗаголовкаОбъекта = Макет.ПолучитьОбласть("Строка" + Уровень + "|Объекты");
//	ОбластьЗаголовкаОбъекта.Параметры.Объект = ОбъектОтчета;
//	ТекОбласть = Таблица.Вывести(ОбластьЗаголовкаОбъекта, Уровень);
//	ТекОбласть.ЦветФона = ЦветОбъекта;
//	//Получим данные для вывода по дням
//	ДанныеДляВывода = ПолучитьДанныеПоНомеру(ОбъектОтчета, ПараметрыОтчета.ДатаНачала, ПараметрыОтчета.ДатаОкончания);
//	ТекущаяДата = ПараметрыОтчета.ДатаНачала;
//	ДатыБронированияПоОбъекту = ПолучитьДатыИнтерваловБронирования(ПараметрыОтчета.ТекущийПериод, ОбъектОтчета.Владелец);
//	ОбластьДаты = Макет.ПолучитьОбласть("Строка|Даты");
//	Пока ТекущаяДата <= ПараметрыОтчета.ДатаОкончания Цикл
//
//		СтрокаСтатуса = ДанныеДляВывода.Найти(ТекущаяДата, "Дата");
//		Если СтрокаСтатуса = Неопределено Тогда
//
//			ПараметрРасшифровки = Новый Структура;
//			ПараметрРасшифровки.Вставить("Дата", ТекущаяДата);
//			ПараметрРасшифровки.Вставить("Объект", ОбъектОтчета);
//			ОбластьДаты.Параметры.ДанныеБронирования = Строка(День(ТекущаяДата)) + " " + Формат(ТекущаяДата, "ДФ=ММММ");
//			ОбластьДаты.Параметры.ПараметрРасшифровки = ПараметрРасшифровки;
//
//			ТекОбласть = Таблица.Присоединить(ОбластьДаты);
//			ТекущийДеньСтрокой = Строка(Формат(День(ТекущаяДата), "ЧЦ=2; ЧВН="));
//			Если Не СтрНайти("10 20", ТекущийДеньСтрокой) = 0 Тогда
//				ТекОбласть.ГраницаСправа = РазделяющаяЛиния;
//			ИначеЕсли КонецДня(ТекущаяДата) = КонецМесяца(ТекущаяДата) Тогда
//				ТекОбласть.ГраницаСправа = РазделяющаяЛиния;
//			КонецЕсли;
//			Если ТекущаяДата <= ДатыБронированияПоОбъекту.ДатаОкончания И ТекущаяДата
//				>= ДатыБронированияПоОбъекту.ДатаНачала Тогда
//				ТекОбласть.ЦветФона   = ЦветСвободного;
//				ТекОбласть.ЦветТекста = ЦветСвободного; //ЦветТекстаСвободного;
//			Иначе
//				ТекОбласть.ЦветФона   = ЦветНедоступного;
//				ТекОбласть.ЦветТекста = ЦветНедоступного;
//			КонецЕсли;
//			ТекОбласть.Отступ = 6;
//
//		Иначе
//			ДокументБронирования = СтрокаСтатуса.Регистратор;
//			Отбор = Новый Структура("Регистратор", ДокументБронирования);
//			НайденыеСтроки = ДанныеДляВывода.НайтиСтроки(Отбор);
//			ОбластьДляВывода = Неопределено;
//			Для Каждого СтрокаБронирования Из НайденыеСтроки Цикл
//
//				Если СтрокаБронирования.Дата - ТекущаяДата > 86400 Тогда //по текущему номеру есть разрыв бронирования
//
//					Прервать;
//
//				КонецЕсли;
//
//				Если ОбластьДляВывода = Неопределено Тогда
//					ОбластьДляВывода = Новый ТабличныйДокумент;
//					ОбластьДаты.Параметры.ДанныеБронирования = ДокументБронирования.Клиент;
//					ОбластьДаты.Параметры.ПараметрРасшифровки = ДокументБронирования;
//					ОбластьДляВывода.Вывести(ОбластьДаты);
//				Иначе
//					ОбластьДаты.Параметры.ДанныеБронирования = "";
//					ОбластьДляВывода.Присоединить(ОбластьДаты);
//				КонецЕсли;
//				ТекущаяДата = Макс(ТекущаяДата, СтрокаБронирования.Дата);
//				СтрокаБронирования.Дата = Дата('00010101');
//				СтрокаБронирования.Регистратор = Неопределено;
//
//			КонецЦикла;
//			ТекОбласть = Таблица.Присоединить(ОбластьДляВывода);
//			Если ДокументБронирования.СтатусБрони = Перечисления.СтатусБрони.Предварительная Тогда
//				Если ЗначениеЗаполнено(ДокументБронирования.ДатаПлатежа) И ДокументБронирования.ДатаПлатежа
//					<= ТекущаяДатаСеанса() Тогда
//					ЦветФона = ЦветВнимание;
//					ТекОбласть.Текст = "! " + ТекОбласть.Текст;
//				Иначе
//					ЦветФона = ЦветПредБронированного;
//				КонецЕсли;
//			Иначе
//				ЦветФона = ЦветЗабронированного;
//
//			КонецЕсли;
//			ТекОбласть.ЦветФона = ЦветФона;
//			ТекОбласть.Объединить();
//			ТекОбласть.ГраницаСправа = ЛинияРазделяющаяБронирования;
//			ТекОбласть.ЦветРамки = ЦветСвободного;			
//			//ТекОбласть.Отступ = 0;
//		КонецЕсли;
//		ТекущаяДата = КонецДня(ТекущаяДата) + 1;
//	КонецЦикла;
//	Возврат Таблица;
//КонецФункции // ЗаполнитьТаблицуПоНомеру()
//
//Функция ЗаполнитьТаблицуПоОбъекту(Знач ОбъектОтчета, ПараметрыОтчета, Макет, Знач ТекущийУровень = 0)
//	Таблица = Новый ТабличныйДокумент;
//	Если ТипЗнч(ОбъектОтчета) = Тип("СправочникСсылка.Гостиницы") Тогда
//		//Выведем строку по гостинице
//		СтрокаОбъекта = ВывестиПустую(ОбъектОтчета, ПараметрыОтчета, Макет, ТекущийУровень);
//		Таблица.Вывести(СтрокаОбъекта, ТекущийУровень);
//		ДанныеДляВывода = ПолучитьДанныеПоОбъекту(ОбъектОтчета);
//		Для Каждого ОбъектДляВывода Из ДанныеДляВывода Цикл
//			ДатыБронированияПоОбъекту = ПолучитьДатыИнтерваловБронирования(ПараметрыОтчета.ТекущийПериод,
//				ОбъектДляВывода);
//			Если ДатыБронированияПоОбъекту = Неопределено Тогда
//				Продолжить;
//			КонецЕсли;
//			ДанныеОбъекта = ЗаполнитьТаблицуПоОбъекту(ОбъектДляВывода, ПараметрыОтчета, Макет, ТекущийУровень);
//			Таблица.Вывести(ДанныеОбъекта, ТекущийУровень);
//		КонецЦикла;
//	ИначеЕсли ТипЗнч(ОбъектОтчета) = Тип("СправочникСсылка.Корпуса") Тогда
//		//Выведем строку по корпусу;
//		ТекущийУровень = ТекущийУровень + 1;
//		СтрокаОбъекта = ВывестиПустую(ОбъектОтчета, ПараметрыОтчета, Макет, ТекущийУровень);
//		Таблица.Вывести(СтрокаОбъекта, ТекущийУровень);
//		ДанныеДляВывода = ПолучитьДанныеПоОбъекту(ОбъектОтчета);
//		Для Каждого ОбъектДляВывода Из ДанныеДляВывода Цикл
//			ДанныеОбъекта = ЗаполнитьТаблицуПоОбъекту(ОбъектДляВывода, ПараметрыОтчета, Макет, ТекущийУровень);
//			Таблица.Вывести(ДанныеОбъекта, ТекущийУровень);
//		КонецЦикла;
//	Иначе
//		ТекущийУровень = ТекущийУровень + 1;
//		ДанныеОбъекта = ЗаполнитьТаблицуПоНомеру(ОбъектОтчета, ПараметрыОтчета, Макет, ТекущийУровень);
//		Таблица.Вывести(ДанныеОбъекта, ТекущийУровень);
//	КонецЕсли;
//
//	Возврат Таблица;
//КонецФункции // ЗаполнитьТаблицуПоОбъекту()
//Функция ПолучитьСписокОбъектов(ПериодБронирования) Экспорт
//
//	Запрос = Новый Запрос;
//	Запрос.Текст =
//	"ВЫБРАТЬ
//	|	ВЫБОР
//	|		КОГДА ТИПЗНАЧЕНИЯ(ПериодыБронирования.Объект.Ссылка) = ТИП(Справочник.Корпуса)
//	|			ТОГДА ПериодыБронирования.Объект.Ссылка.Владелец
//	|		ИНАЧЕ ПериодыБронирования.Объект.Ссылка
//	|	КОНЕЦ КАК Ссылка
//	|ИЗ
//	|	РегистрСведений.ПериодыБронирования КАК ПериодыБронирования
//	|ГДЕ
//	|	ПериодыБронирования.ПериодБронирования = &ПериодБронирования
//	|
//	|СГРУППИРОВАТЬ ПО
//	|	ВЫБОР
//	|		КОГДА ТИПЗНАЧЕНИЯ(ПериодыБронирования.Объект.Ссылка) = ТИП(Справочник.Корпуса)
//	|			ТОГДА ПериодыБронирования.Объект.Ссылка.Владелец
//	|		ИНАЧЕ ПериодыБронирования.Объект.Ссылка
//	|	КОНЕЦ
//	|АВТОУПОРЯДОЧИВАНИЕ";
//
//	Запрос.УстановитьПараметр("ПериодБронирования", ПериодБронирования);
//
//	РезультатЗапроса = Запрос.Выполнить();
//	Если РезультатЗапроса.Пустой() Тогда
//		Возврат Новый Массив;
//	Иначе
//		Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
//	КонецЕсли;
//
//КонецФункции // ПолучитьСписокОбъектов()
//Функция ПолучитьДанныеПоНомеру(ОбъектОтчета, ДатаНачала, ДатаОкончания) Экспорт
//
//	Запрос = Новый Запрос;
//	Запрос.Текст =
//	"ВЫБРАТЬ
//	|	СтатусыНомеров.Регистратор КАК Регистратор,
//	|	СтатусыНомеров.Статус КАК Статус,
//	|	СтатусыНомеров.Дата КАК Дата
//	|ИЗ
//	|	РегистрСведений.СтатусыНомеров КАК СтатусыНомеров
//	|ГДЕ
//	|	СтатусыНомеров.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
//	|	И СтатусыНомеров.Номер = &ОбъектОтчета
//	|
//	|УПОРЯДОЧИТЬ ПО
//	|	Дата";
//
//	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
//	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
//	Запрос.УстановитьПараметр("ОбъектОтчета", ОбъектОтчета);
//
//	РезультатЗапроса = Запрос.Выполнить();
//	Возврат РезультатЗапроса.Выгрузить();
//
//КонецФункции // ПолучитьДанныеПоНомеру()
#КонецОбласти
