﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ФизическоеЛицо = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
	мПодразделений = УП_КадрыСервер.ЧемРуководит(  ФизическоеЛицо );
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора( Список.Отбор,
		"ПланРаботТиражный.Подразделение",
		мПодразделений,
		ВидСравненияКомпоновкиДанных.ВСписке,,Истина);

КонецПроцедуры
