﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ФизическоеЛицо = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
	//мПодразделений = УП_КадрыСервер.ЧемРуководит(  ФизическоеЛицо );
	//мПодразделений = УП_КадрыСервер.ГдеРаботает(  ФизическоеЛицо );
	
	// 2015 12 09
	мПодразделений = УП_КадрыСервер.ДоступныеПодразделения( ФизическоеЛицо);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора( Список.Отбор,
		"Подразделение",
		мПодразделений,
		ВидСравненияКомпоновкиДанных.ВСписке,,Истина);

КонецПроцедуры
