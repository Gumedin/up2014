﻿
&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	ПересчетИсполненийСотрудника();
КонецПроцедуры

&НаСервере
Процедура ПересчетИсполненийСотрудника()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.Сотрудник.Очистить();
	
	// активные исполнения на момент увольнения
	тзИсполнения =  УП_КадрыСервер.СотрудникиФизЛица( Документ.ФизическоеЛицо, Документ.ДатаУвольнения );
	Если  тзИсполнения.Количество() <> 0 Тогда 
		Документ.Сотрудник.Загрузить(  тзИсполнения );
	КонецЕсли;
	
	Для Каждого Стр ИЗ Документ.Сотрудник Цикл
		Стр.Активна = Истина;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы( Документ, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено( Объект.ДатаУвольнения ) Тогда
		Объект.ДатаУвольнения = ТекущаяДата();
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	ПересчетИсполненийСотрудника();
КонецПроцедуры


