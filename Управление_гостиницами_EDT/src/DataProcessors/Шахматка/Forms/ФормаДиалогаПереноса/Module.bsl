&НаКлиенте
Перем ПараметрыЗакрытия;
&НаКлиенте
Процедура Переместить(Команда)
	ЗаполнитьЗначенияСвойств(ПараметрыЗакрытия,ЭтотОбъект,"БронированиеСсылка,Начало,Конец,Номер");
	ПараметрыЗакрытия.Результат = "Переместить";
	ЭтаФорма.Закрыть(ПараметрыЗакрытия);// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ЭтаФорма.Закрыть(ПараметрыЗакрытия);// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьЗначенияСвойств(ЭтотОбъект,Параметры,"БронированиеСсылка,Начало,Конец,Номер");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПараметрыЗакрытия = Новый Структура("Результат,БронированиеСсылка,Начало,Конец,Номер","Отмена");
КонецПроцедуры
