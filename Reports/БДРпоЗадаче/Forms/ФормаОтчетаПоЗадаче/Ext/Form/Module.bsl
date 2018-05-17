﻿//ФормаОтчета
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ЗадачаПроекта") Тогда
		ЗадачаПроекта.Добавить(Параметры.ЗадачаПроекта);
	КонецЕсли;
	
	Если Параметры.Свойство("Проект") Тогда
		мЗадачи = ЗадачиПроекта(Параметры.Проект);
		Для Каждого задача Из мЗадачи Цикл 
			ЗадачаПроекта.Добавить(задача);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЗадачиПроекта(Проект)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗадачиПроектов.Ссылка КАК Задача
		|ИЗ
		|	Справочник.ЗадачиПроектов КАК ЗадачиПроектов
		|ГДЕ
		|	ЗадачиПроектов.Владелец = &Проект";
	
	Запрос.УстановитьПараметр("Проект", Проект);
	
	тзРезультат = Запрос.Выполнить().Выгрузить();
	мРезультат = тзРезультат.ВыгрузитьКолонку("Задача");
	
	Возврат мРезультат;
КонецФункции

&НаСервере
Процедура ПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	Для Каждого Эл ИЗ Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если Строка(Эл.Параметр) = "ЗадачаПроекта" Тогда
			Эл.Значение = ЗадачаПроекта;
		КонецЕсли;
	КонецЦикла;
	
	СкомпоноватьРезультат();
КонецПроцедуры
