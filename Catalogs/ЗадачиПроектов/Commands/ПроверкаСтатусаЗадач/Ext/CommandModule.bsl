﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Для Каждого Задача из ПараметрКоманды Цикл 
		УстановитьСтатусаЗадачи(Задача);
	КонецЦикла;
КонецПроцедуры
 
&НаСервере
Процедура УстановитьСтатусаЗадачи(Задача)
	Протокол = Новый ТаблицаЗначений();
	Протокол.Колонки.Добавить("Результат");
	Протокол.Колонки.Добавить("Сообщение");
	Протокол.Колонки.Добавить("Задача");
	
	Объект = Задача.Ссылка.ПолучитьОбъект();
	Объект.ПроверкаСтатусаЗадач(Протокол);
	
	Для Каждого строка Из Протокол Цикл 
		Сообщить(строка.Сообщение);
	КонецЦикла;
КонецПроцедуры
