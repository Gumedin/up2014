﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	ИсполнительДокумента 	= ПараметрыСеанса.ТекущийПользователь;
	ПериодРегистрации	 	= НачалоМесяца( ТекущаяДата());
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	тзИтогиНачисления = Начисления.Выгрузить();
	тзИтогиНачисления.Свернуть("ЗадачаПроекта", "Сумма");
	
	Начисление_ФондПодр = Справочники.СтатьиСметы.Начисление_ФондПодр.ИмяПредопределенныхДанных;
	
	// регистр БюджетПоМесяцам 
	Движения.БюджетПоМесяцам.Записывать = Истина;
	Для Каждого ТекСтрокаРаспределение Из тзИтогиНачисления Цикл
		Если ТекСтрокаРаспределение.Сумма = 0 Тогда Продолжить; КонецЕсли;
		
		сСметы =  Новый Соответствие;
		сСтатей = Новый Соответствие;
		пСтатей = Новый Соответствие;            
		oСтатей = Новый Соответствие;
		УП_СметаПроекта.ПодготовкаФактБюджета(сСметы, сСтатей, пСтатей, oСтатей, ТекСтрокаРаспределение.ЗадачаПроекта);	
		
		сСтатей[Начисление_ФондПодр] = ТекСтрокаРаспределение.Сумма; 
		
		УП_СметаПроекта.ПроведениеФактБюджета(сСметы, сСтатей, oСтатей, Движения, ТекСтрокаРаспределение.ЗадачаПроекта,
			ПериодРегистрации, Дата);
	КонецЦикла;	
	
	// регистр ФондПодразделений Приход
	Движения.ФондПодразделений.Записывать = Истина;
	Для Каждого ТекСтрокаРаспределение Из Начисления Цикл
		Если ТекСтрокаРаспределение.Сумма = 0 Тогда Продолжить; КонецЕсли;
		Движение = Движения.ФондПодразделений.Добавить();
		Движение.ВидДвижения 	= ВидДвиженияНакопления.Приход;
		Движение.Период 		= Дата;
		Движение.Подразделение 	= Подразделение;
		Движение.Сотрудник		=  ТекСтрокаРаспределение.Сотрудник;
		Движение.Год			= Год(ПериодРегистрации);
		Движение.Сумма			= ТекСтрокаРаспределение.Сумма;
		Движение.Фонд			= Справочники.Фонды.ФондПП;
	КонецЦикла;
КонецПроцедуры

