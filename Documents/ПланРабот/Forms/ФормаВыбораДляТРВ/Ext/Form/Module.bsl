﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Список.Параметры.УстановитьЗначениеПараметра("мПланыРабот", 	Параметры.ПланыРабот.ВыгрузитьЗначения());
	Если 		Параметры.Свойство("Физическоелицо") Тогда
		ЭтаФорма.Заголовок = "Планы работ ("+ Параметры.Физическоелицо +")";
	ИначеЕсли	Параметры.Свойство("Подразделение") Тогда
		ЭтаФорма.Заголовок = "Планы работ ("+ Параметры.Подразделение +")";
	КонецЕсли;
КонецПроцедуры

