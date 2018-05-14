﻿
Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр ФондПодразделений Расход
	ГодФонда = ГодФондаПодразделения( ПериодРегистрации );	
	
	Движения.ФондПодразделений.Записывать = Истина;
	Для Каждого ТекСтрокаРасходы Из Расходы Цикл
		Движение = Движения.ФондПодразделений.Добавить();
		Движение.ВидДвижения 	= ВидДвиженияНакопления.Расход;
		Движение.Период 		= Дата;
		Движение.Подразделение 	= Подразделение;
		Движение.Год			= ГодФонда;
		Движение.Сумма 			= ТекСтрокаРасходы.Сумма;
		// статья
		Движение.СтатьяРасходов = СтатьяРасходов;
	КонецЦикла;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ИсполнительДокумента = ПараметрыСеанса.ТекущийПользователь;
	ПериодРегистрации		= НачалоМесяца( ТекущаяДата());
	ФизическоеЛицо			= ИсполнительДокумента.ФизическоеЛицо;
	мПодразделения 			= УП_КадрыСервер.ГдеРаботает( ФизическоеЛицо );
	Если мПодразделения.Количество() <> 0 Тогда
		Подразделение = мПодразделения[0];
	КонецЕсли;
	
	
КонецПроцедуры
