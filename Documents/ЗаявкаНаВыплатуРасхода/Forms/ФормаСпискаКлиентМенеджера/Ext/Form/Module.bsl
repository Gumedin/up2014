﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		ТекущийКлиентМенеджер = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
	мПользователей = СКД_ДоступныеФЛ( ТекущийКлиентМенеджер );
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора( Список.Отбор,
		"РасходПоЗадаче.ЗадачаПроекта.Владелец.МенеджерПроекта",
		мПользователей,
		ВидСравненияКомпоновкиДанных.ВСписке,,Истина);

КонецПроцедуры
