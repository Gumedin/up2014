﻿Функция РодительКалькуляциПланаРабот( Исполнитель, Проект )
	РодительКЗ 	= СоздатьИерархию( "КалькуляторПланаРаботТиражного", 
									СокрЛП( Исполнитель ) + "/" + 
									СокрЛП( Проект ));
									
	Возврат РодительКЗ;
КонецФункции

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Исполнитель = ПараметрыСеанса.ТекущийПользователь;
	ГодПроекта	= Год( ТекущаяДата());
	
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПланРаботТиражный") Тогда
		// Заполнение шапки
		
		Подразделение 	= ДанныеЗаполнения.Подразделение;
		ЗадачаПроекта	= ДанныеЗаполнения.ЗадачаПроекта;
		Наименование 	= ДанныеЗаполнения.ЗадачаПроекта.Наименование;
		ГодПроекта		= ДанныеЗаполнения.ЗадачаПроекта.Владелец.ГодПроекта;
		Родитель		= РодительКалькуляциПланаРабот( Исполнитель, ДанныеЗаполнения.ЗадачаПроекта.Владелец);
		ИсполненВключая = УП_ПланыРаботПоПроектам.ДатаИсполненияПланаРаботПоФронтуРабот( ДанныеЗаполнения.Ссылка );
		ОстатокПоСмете	= ДанныеЗаполнения.ОстатокПоСмете;
		СкидкаКлиенту	= ДанныеЗаполнения.СкидкаКлиенту;
		
		
		Для Каждого ТекСтрокаФронтРабот Из ДанныеЗаполнения.Расчет Цикл
			НоваяСтрока 			= Расчет.Добавить();
			ЗаполнитьЗначенияСвойств( НоваяСтрока, ТекСтрокаФронтРабот );
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры
