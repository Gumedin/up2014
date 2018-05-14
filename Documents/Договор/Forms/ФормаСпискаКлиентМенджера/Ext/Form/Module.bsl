﻿
//&НаСервере
//Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
//	ТекущийКлиентМенеджер = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
//	мПользователей = СКД_ДоступныеФЛ( ТекущийКлиентМенеджер );
//	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора( Список.Отбор,
//		"Проект.МенеджерПроекта",
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
		ГруппаОтбора, "Проект.МенеджерПроекта", ВидСравненияКомпоновкиДанных.ВСписке, мПользователей);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтбора, "Проект.ДиректорПроекта", ВидСравненияКомпоновкиДанных.ВСписке, мПользователей);
		
КонецПроцедуры
