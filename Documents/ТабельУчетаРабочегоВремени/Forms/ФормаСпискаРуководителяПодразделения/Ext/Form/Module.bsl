﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ФизическоеЛицо = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
	//мПодразделений = УП_КадрыСервер.ЧемРуководит(  ФизическоеЛицо );
	//
	//// 26,01,2015
	//// если у пользователя есть права начальника подразделения, но он не начальник, то 
	//// подразделение - где он работает
	//Если НЕ ЗначениеЗаполнено( мПодразделений ) Тогда
	//	мПодразделений = УП_КадрыСервер.ГдеРаботает( ФизическоеЛицо );
	//КонецЕсли;
	
	// 2015 12 09
	мПодразделений = УП_КадрыСервер.ДоступныеПодразделения( ФизическоеЛицо);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора( Список.Отбор,
		"Подразделение",
		мПодразделений,
		ВидСравненияКомпоновкиДанных.ВСписке,,Истина);

КонецПроцедуры
