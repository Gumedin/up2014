﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекущийПроектМенеджер = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
	мПользователей = СКД_ДоступныеФЛ( ТекущийПроектМенеджер );
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора( Список.Отбор,
		"ЗадачаПроекта.ПроектМенеджер",
		мПользователей,
		ВидСравненияКомпоновкиДанных.ВСписке,,Истина);

КонецПроцедуры
