﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	Если НЕ ЗначениеЗаполнено( СтатусПослеОтсутствия) Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не указан статус после отсутствия";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	

	// регистр Сотрудники
	Движения.Сотрудники.Записывать = Истина;
	Для Каждого ТекСтрокаСотрудник Из Сотрудник Цикл
		// не должно быть движений других кадровых документов за период
		Если УП_КадрыСервер.ЕстьКадровоеДвижение( Ссылка, ДатаНачала, ДатаОкончания, ТекСтрокаСотрудник ) Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "За период " + ПредставлениеПериода( ДатаНачала, ДатаОкончания) + " есть другое кадровое движение";
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;
			
		
		// уход и возвращение
		// 1
		Движение = Движения.Сотрудники.Добавить();
		Движение.Период 			= ДатаНачала;
		Движение.Подразделение 		= ТекСтрокаСотрудник.Подразделение;
		Движение.Должность 			= ТекСтрокаСотрудник.Должность;
		Движение.ТарифнаяСтавка 	= ТекСтрокаСотрудник.ТарифнаяСтавка;
		Движение.ФизическоеЛицо 	= ФизическоеЛицо;
		// без уточнений
		ТекущийСтатус = ?(ЗначениеЗаполнено(СтатусОтсутствия), СтатусОтсутствия, Справочники.СтатусыСотрудников.Отпуск);
		Движение.СтатусСотрудника 	= ТекущийСтатус;
		Движение.Количество 		= ТекСтрокаСотрудник.Количество;
		//
		Движение.Основание 			= Основание;
		
		// 2
		Движение = Движения.Сотрудники.Добавить();
		СекундВСутках				= 24 * 60 * 60;
		Движение.Период 			= ДатаОкончания + СекундВСутках; // следующий день после отпуска
		Движение.Подразделение 		= ТекСтрокаСотрудник.Подразделение;
		Движение.Должность 			= ТекСтрокаСотрудник.Должность;
		Движение.ТарифнаяСтавка 	= ТекСтрокаСотрудник.ТарифнаяСтавка;
		Движение.ФизическоеЛицо 	= ФизическоеЛицо;
		// без уточнений
		Движение.СтатусСотрудника 	= СтатусПослеОтсутствия;
		Движение.Количество 		= ТекСтрокаСотрудник.Количество;
		//
		Движение.Основание 			= Основание;
		
		
	КонецЦикла;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ИсполнительДокумента 	= ПараметрыСеанса.ТекущийПользователь;

КонецПроцедуры
