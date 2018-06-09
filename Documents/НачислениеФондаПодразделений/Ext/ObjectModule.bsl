﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	ИсполнительДокумента 	= ПараметрыСеанса.ТекущийПользователь;
	ПериодРегистрации	 	= НачалоМесяца( ТекущаяДата());
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	// регистр БюджетПоМесяцам 
	Движения.БюджетПоМесяцам.Записывать = Истина;
	Для Каждого ТекСтрокаРаспределение Из Начисления Цикл
		Если ТекСтрокаРаспределение.Сумма = 0 Тогда Продолжить; КонецЕсли;
		
		//Структура сметы
		СметаЗадачиПроекта = УП_СметаПроекта.ПодборСметыЗадачи(ТекСтрокаРаспределение.ЗадачаПроекта);
		Если СметаЗадачиПроекта = Неопределено Тогда 
			Сообщить("Не найдена проведенная смета для задачи " + ТекСтрокаРаспределение.ЗадачаПроекта);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		сСметы 	= УП_СметаПроекта.ПолучитьСтруктуруСметыЗадачи( ТекСтрокаРаспределение.ЗадачаПроекта.ГодЗадачи );

		сСтатей = Новый Соответствие;
		пСтатей = Новый Соответствие;
		oСтатей = Новый Соответствие;
		Для Каждого статья Из СметаЗадачиПроекта.Расчет Цикл
			сСтатей[статья.ИмяСтатьи] = 0;
			пСтатей[статья.ИмяСтатьи] = статья.ЗначениеПараметра / 100;
			oСтатей[статья.ИмяСтатьи] = статья.Статья;
		КонецЦикла;
		
		Начисление_ФондПодр = Справочники.СтатьиСметы.Начисление_ФондПодр.ИмяПредопределенныхДанных;
		сСтатей[Начисление_ФондПодр] = ТекСтрокаРаспределение.Сумма; 
		
		//Пересчет
		УП_СметаПроекта.ПересчетСметыЗадачи( сСметы, сСтатей );
		
		//Бюджет факт
		Для Каждого статья Из СметаЗадачиПроекта.Расчет Цикл
			Если сСтатей[статья.ИмяСтатьи] <> 0 Тогда 
				Движение = Движения.БюджетПоМесяцам.Добавить();
				Движение.Период 		= Дата;
				Движение.ЗадачаПроекта 	= ТекСтрокаРаспределение.ЗадачаПроекта;
				Движение.СтатьяСметы 	= oСтатей[статья.ИмяСтатьи];
				Движение.ТипСуммы 		= Перечисления.ТипСуммыБюджета.Факт;  // факт
				Движение.Месяц 			= НачалоМесяца(ПериодРегистрации);
				Движение.Сумма          = сСтатей[статья.ИмяСтатьи];	
				Движение.РКО			= Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;	
	
	// регистр ФондПодразделений Приход
	Движения.ФондПодразделений.Записывать = Истина;
	Движение = Движения.ФондПодразделений.Добавить();
	Движение.ВидДвижения 	= ВидДвиженияНакопления.Приход;
	//Движение.Период 		= ПериодРегистрации;
	Движение.Период 		= Дата;
	Движение.Подразделение 	= Подразделение;
	Движение.Год			= Год(ПериодРегистрации);
	Движение.Сумма			= Начисления.Итог("Сумма");

	//СтатьяСметы = Справочники.СтатьиСметы.Начисление_ФондПодр;
	//// регистр БюджетПоМесяцам 
	//Движения.БюджетПоМесяцам.Записывать = Истина;
	//Для Каждого ТекСтрокаНачисления Из Начисления Цикл
	//	Если ТекСтрокаНачисления.Сумма = 0 Тогда
	//		Продолжить;
	//	КонецЕсли;
	//	Движение = Движения.БюджетПоМесяцам.Добавить();
	//	Движение.Период 		= Дата;
	//	Движение.ЗадачаПроекта 	= ТекСтрокаНачисления.ЗадачаПроекта;
	//	Движение.СтатьяСметы	= СтатьяСметы;
	//	Движение.ТипСуммы		= Перечисления.ТипСуммыБюджета.Факт;
	//	Движение.Месяц 			= ПериодРегистрации;
	//	//
	//	Движение.Сумма 			= ТекСтрокаНачисления.Сумма;
	//	Движение.РКО			= Истина;
	//КонецЦикла;
	
	
КонецПроцедуры

