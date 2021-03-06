﻿
//&НаСервере
//Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
//	ТекущийКлиентМенеджер = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
//	мПользователей = СКД_ДоступныеФЛ( ТекущийКлиентМенеджер );
//	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора( Список.Отбор,
//		"Договор.Проект.МенеджерПроекта",
//		мПользователей,
//		ВидСравненияКомпоновкиДанных.ВСписке,,Истина);

//КонецПроцедуры


// с учетом директора проекта
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ГруппаОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора( Список.Отбор.Элементы,
	"Менеджеры проектов", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли );
	
	//
	ТекущийКлиентМенеджер = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
	мПользователей = СКД_ДоступныеФЛ( ТекущийКлиентМенеджер );
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтбора, "Договор.Проект.МенеджерПроекта", ВидСравненияКомпоновкиДанных.ВСписке, мПользователей);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтбора, "Договор.Проект.ДиректорПроекта", ВидСравненияКомпоновкиДанных.ВСписке, мПользователей);
		
КонецПроцедуры
