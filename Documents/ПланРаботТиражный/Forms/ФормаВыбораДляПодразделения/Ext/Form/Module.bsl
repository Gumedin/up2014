﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СтатусыПроекта = Новый Массив;
	СтатусыПроекта.Добавить(Перечисления.СтатусыПроектов.ВРаботе);
	
	Список.Параметры.УстановитьЗначениеПараметра("Подразделение", 	Параметры.Подразделение);
	Список.Параметры.УстановитьЗначениеПараметра("СтатусыПроекта", 	СтатусыПроекта);
КонецПроцедуры
