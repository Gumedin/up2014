﻿
//&НаСервере
//Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
//	ТекущийКлиентМенеджер = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
//	мПользователей = СКД_ДоступныеФЛ( ТекущийКлиентМенеджер );
//	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора( Список.Отбор,
//		"ЗадачаПроекта.Владелец.МенеджерПроекта",
//		мПользователей,
//		ВидСравненияКомпоновкиДанных.ВСписке,,Истина);

//КонецПроцедуры


// с учетом директора проекта
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекущийПроектМенеджер = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
	мПользователей = СКД_ДоступныеФЛ( ТекущийПроектМенеджер );
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора( Список.Отбор,
		"ЗадачаПроекта.ПроектМенеджер",
		мПользователей,
		ВидСравненияКомпоновкиДанных.ВСписке,,Истина);
		
КонецПроцедуры

