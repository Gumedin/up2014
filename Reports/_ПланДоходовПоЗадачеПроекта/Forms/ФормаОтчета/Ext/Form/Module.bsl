﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ЗадачаПроекта") Тогда
		ЗадачаПроекта = Параметры.ЗадачаПроекта;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено( ЗадачаПроекта ) Тогда
		
		Элемент  = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти("ЗадачаПроекта");
		Для Каждого Эл ИЗ Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
			Если 	Строка(Эл.Параметр)	= "ЗадачаПроекта" Тогда
				Эл.Значение = ЗадачаПроекта;
			КонецЕсли;
		КонецЦикла;
		
		СкомпоноватьРезультат();
	КонецЕсли;
КонецПроцедуры
