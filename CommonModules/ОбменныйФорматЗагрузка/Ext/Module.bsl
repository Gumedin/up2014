﻿Процедура ЗагрузитьДанные(ИмяМетаданныхФормата, ТаблицаЗначений) Экспорт
	
	Если  ИмяМетаданныхФормата = "ОФ_ОборотыБУ" Тогда 
		ЗагрузитьОбороты(ТаблицаЗначений);
	ИначеЕсли ИмяМетаданныхФормата = "ОФ_Смета" Тогда
		ЗагрузитьСмету(ТаблицаЗначений);
	ИначеЕсли ИмяМетаданныхФормата = "ОФ_ГрафикОплаты" Тогда
		ЗагрузитьГрафикОплаты(ТаблицаЗначений);
	ИначеЕсли ИмяМетаданныхФормата = "ОФ_ЗаявкаНаПлатеж" Тогда
		ЗагрузитьЗаявкуНаПлатеж(ТаблицаЗначений);
	КонецЕсли;
	
КонецПроцедуры

//Загрузка оборотов
Процедура ЗагрузитьОбороты(ТаблицаЗначений)
	
	Для Каждого ТекСтрока Из ТаблицаЗначений Цикл
		
	КонецЦикла;
	
КонецПроцедуры

//Загрузка сметы
Процедура ЗагрузитьСмету(ТаблицаЗначений)
	
	Для Каждого ТекСтрока Из ТаблицаЗначений Цикл
		
	КонецЦикла;
	
КонецПроцедуры

//Загрузка графика оплаты
Процедура ЗагрузитьГрафикОплаты(ТаблицаЗначений)
	
	Для Каждого ТекСтрока Из ТаблицаЗначений Цикл
		
	КонецЦикла;
	
КонецПроцедуры

//Загрузка заявок
Процедура ЗагрузитьЗаявкуНаПлатеж(ТаблицаЗначений)
	
	Для Каждого ТекСтрока Из ТаблицаЗначений Цикл
		
		Если ТекСтрока["ТипЗаявки"] = "ЗаявкаНаВыплату" Тогда
			НовыйДокумент = Документы.ЗаявкаНаВыплату.СоздатьДокумент();
			//НовыйДокумент.Дата = 
			НовыйДокумент.Записать();
		ИначеЕсли ТекСтрока["ТипЗаявки"] = "ЗаявкаНаВыплатуРасхода" Тогда
			НовыйДокумент = Документы.ЗаявкаНаВыплатуРасхода.СоздатьДокумент();
			//НовыйДокумент.Дата = 
			НовыйДокумент.Записать();
		ИначеЕсли ТекСтрока["ТипЗаявки"] = "ЗаявкаНаОплатуПоставщику" Тогда
			НовыйДокумент = Документы.ЗаявкаНаОплатуПоставщику.СоздатьДокумент();
			//НовыйДокумент.Дата = 
			НовыйДокумент.Записать();
		ИначеЕсли ТекСтрока["ТипЗаявки"] = "ЗаявкаНаРасходПоСотруднику" Тогда
			НовыйДокумент = Документы.ЗаявкаНаРасходПоСотруднику.СоздатьДокумент();
			//НовыйДокумент.Дата = 
			НовыйДокумент.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
