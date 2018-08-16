﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Проект 			= Параметры.Проект;
	ЗадачаПроекта 	= Параметры.ЗадачаПроекта;
			
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Значение		= Тест;
	Элемент  = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти("ЗадачаПроекта");
	Для Каждого Эл ИЗ Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если 		Строка(Эл.Параметр) = "Проект" Тогда
			Эл.Значение = Проект;
		ИначеЕсли 	Строка(Эл.Параметр)	= "ЗадачаПроекта" Тогда
			Эл.Значение = ЗадачаПроекта;
		КонецЕсли;
	КонецЦикла;
	
	СкомпоноватьРезультат();

КонецПроцедуры
