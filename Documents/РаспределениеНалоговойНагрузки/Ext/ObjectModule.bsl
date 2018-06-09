﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	// регистр БюджетПоМесяцам 
	Движения.БюджетПоМесяцам.Записывать = Истина;
	Для Каждого ТекСтрокаРаспределение Из Распределение Цикл
		СуммаНН	= ТекСтрокаРаспределение.Сумма;
		Если СуммаНН = 0 Тогда Продолжить; КонецЕсли;
		
		//Структура сметы
		СметаЗадачиПроекта = УП_СметаПроекта.ПодборСметыЗадачи(ТекСтрокаРаспределение.ЗадачаПроекта);
		сСметы 	= УП_СметаПроекта.ПолучитьСтруктуруСметыЗадачи( ТекСтрокаРаспределение.ЗадачаПроекта.ГодЗадачи );

		сСтатей = Новый Соответствие;
		пСтатей = Новый Соответствие;
		oСтатей = Новый Соответствие;
		Для Каждого статья Из СметаЗадачиПроекта.Расчет Цикл
			сСтатей[статья.ИмяСтатьи] = 0;
			пСтатей[статья.ИмяСтатьи] = статья.ЗначениеПараметра / 100;
			oСтатей[статья.ИмяСтатьи] = статья.Статья;
		КонецЦикла;
		
		НалогНагрузкаВыч = Справочники.СтатьиСметы.НалогНагрузкаВыч.ИмяПредопределенныхДанных;
		сСтатей[НалогНагрузкаВыч] = СуммаНН; 
		
		//Пересчет
		УП_СметаПроекта.ПересчетСметыЗадачи( сСметы, сСтатей );
		
		//Бюджет факт
		Движения.БюджетПоМесяцам.Записывать = Истина;
		Для Каждого статья Из СметаЗадачиПроекта.Расчет Цикл
			Если сСтатей[статья.ИмяСтатьи] <> 0 Тогда 
				Движение = Движения.БюджетПоМесяцам.Добавить();
				Движение.Период 		= Дата;
				Движение.ЗадачаПроекта 	= ТекСтрокаРаспределение.ЗадачаПроекта;
				Движение.СтатьяСметы 	= oСтатей[статья.ИмяСтатьи];
				Движение.ТипСуммы 		= Перечисления.ТипСуммыБюджета.Факт;  // факт
				Движение.Месяц 			= НачалоМесяца(ТекСтрокаРаспределение.МесяцОплаты);
				Движение.Сумма          = сСтатей[статья.ИмяСтатьи];	
				Движение.РКО			= Истина;
			КонецЕсли;
		КонецЦикла;
		
		/////////////////////////////
		//СуммаНН	= ТекСтрокаРаспределение.Сумма;
		//Если СуммаНН = 0 Тогда Продолжить; КонецЕсли;
		//
		//Движение = Движения.БюджетПоМесяцам.Добавить();
		//Движение.Период 		= Дата;
		//Движение.ЗадачаПроекта 	= ТекСтрокаРаспределение.ЗадачаПроекта;
		//Движение.СтатьяСметы	= СтатьяСметы; 	
		//Движение.ТипСуммы 		= Перечисления.ТипСуммыБюджета.Факт; 		// факт
		//Движение.Месяц 			= НачалоМесяца(ТекСтрокаРаспределение.МесяцОплаты);
		//// сумма
		//Движение.Сумма 			= СуммаНН;
			
	КонецЦикла;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ИсполнительДокумента 	= ПараметрыСеанса.ТекущийПользователь;

КонецПроцедуры

