﻿Функция ЗакрытоПоПлануРабот()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФронтРаботОбороты.Месяц КАК Месяц,
		|	ФронтРаботОбороты.Должность,
		|	ФронтРаботОбороты.ТарифнаяСтавка,
		|	СУММА(ФронтРаботОбороты.КоличествоОборот) КАК Количество,
		|	СУММА(ФронтРаботОбороты.СуммаОборот) КАК Сумма
		|ИЗ
		|	РегистрНакопления.ФронтРабот.Обороты КАК ФронтРаботОбороты
		|ГДЕ
		|	ФронтРаботОбороты.ПланРабот = &ПланРабот
		|	И ФронтРаботОбороты.ТипСуммы = &ТипСуммыФакт
		|
		|СГРУППИРОВАТЬ ПО
		|	ФронтРаботОбороты.ТарифнаяСтавка,
		|	ФронтРаботОбороты.Месяц,
		|	ФронтРаботОбороты.Должность
		|
		|УПОРЯДОЧИТЬ ПО
		|	Месяц";
	
	Запрос.УстановитьПараметр("ПланРабот", 		Ссылка);
	Запрос.УстановитьПараметр("ТипСуммыФакт", 	1);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат РезультатЗапроса;
	
КонецФункции

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ИсполнительДокумента 	= ПараметрыСеанса.ТекущийПользователь;
	////Календарь			 	= Справочники.Календари.КалендарьРабочегоВремени;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ЗадачиПроектов") Тогда
		// Заполнение шапки
		ЗадачаПроекта 	= ДанныеЗаполнения.Ссылка;
		Подразделение	= ДанныеЗаполнения.Подразделение;
	КонецЕсли;
КонецПроцедуры

// 2017 07 14
// если план работ был снят с проведения, то и смета тоже снята
// проверяем по закрытому фронту работ часть плана до месяца закрытия
// должна совпадать с проводимым документом
Функция СовпадаетПоЗакрытомуПериоду()	
	ЗакрытыйФронтРабот = ЗакрытоПоПлануРабот();
	Если ЗакрытыйФронтРабот.Количество() = 0 Тогда
		Возврат Истина;
	КонецЕсли;
	ДатаПоследнегоЗакрытия 	= ЗакрытыйФронтРабот[ЗакрытыйФронтРабот.Количество()-1].Месяц;
	
	
	ТекущийФронтРабот 		= ФронтРабот.Выгрузить();
	ТекущийФронтРабот.Свернуть("Месяц,Должность,ТарифнаяСтавка", "Количество,Сумма");
	
	// сначала по текущему фронту работ
	Для Каждого СтрокаФР ИЗ ТекущийФронтРабот Цикл
		// более поздние сроки не проверяем
		Если СтрокаФР.Месяц > ДатаПоследнегоЗакрытия Тогда Продолжить; КонецЕсли;
		
		// месяц попадает в закрытый период
		Отбор = Новый Структура("Месяц,Должность,ТарифнаяСтавка");
		ЗаполнитьЗначенияСвойств( Отбор, СтрокаФР );
		ЗакрытоЗаМесяц = ЗакрытыйФронтРабот.Скопировать( Отбор );
		Если ЗакрытоЗаМесяц.Количество() = 0 Тогда
			Количество 	= 0;
			Сумма		= 0;
		Иначе
			Количество 	= ЗакрытоЗаМесяц.Итог("Количество");
			Сумма		= ЗакрытоЗаМесяц.Итог("Сумма");
		КонецЕсли;
		
		Если СтрокаФР.Количество 	<> Количество 
		ИЛИ	 СтрокаФР.Сумма	  		<> Сумма Тогда
			СообшениеОНесоответствии( СтрокаФР, Сумма, Количество, СтрокаФР.Сумма, СтрокаФР.Количество);		
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	// теперь по закрытому периоду, т.к. из плана работ может быть удалена строка полностью
	// и по первому циклу не диагностируется
	Для Каждого СтрокаФР ИЗ ЗакрытыйФронтРабот Цикл
		Отбор = Новый Структура("Месяц,Должность,ТарифнаяСтавка");
		ЗаполнитьЗначенияСвойств( Отбор, СтрокаФР );
		ПланЗаМесяц = ТекущийФронтРабот.Скопировать( Отбор );
		Если ПланЗаМесяц.Количество() = 0 Тогда
			Количество 	= 0;
			Сумма		= 0;
		Иначе
			Количество 	= ПланЗаМесяц.Итог("Количество");
			Сумма		= ПланЗаМесяц.Итог("Сумма");
		КонецЕсли;
		
		Если СтрокаФР.Количество 	<> Количество 
		ИЛИ	 СтрокаФР.Сумма	  		<> Сумма Тогда
			СообшениеОНесоответствии( СтрокаФР, СтрокаФР.Сумма, СтрокаФР.Количество, Сумма, Количество );		
			Возврат Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Процедура СообшениеОНесоответствии( СтрокаФР, СуммаЗакрыто, КоличествоЗакрыто, СуммаПлан, КоличествоПлан )		
	Сообщение = Новый СообщениеПользователю();
	Сообщение.Текст = "Работы по плану закрыты в " + Формат( СтрокаФР.Месяц, "ДФ = 'ММММ гг'") + Символы.ПС +
					  "по " + СтрокаФР.Должность + " (" + СтрокаФР.ТарифнаяСтавка + ") " + Символы.ПС +
					  "на сумму " + Формат( СуммаЗакрыто, "ЧЦ=15; ЧДЦ=2")  + " ("  +  КоличествоЗакрыто +" ч.), изменено на " + 
					   Формат( СуммаПлан, "ЧЦ=15; ЧДЦ=2" )+ " (" + КоличествоПлан +" ч.)" ;
	Сообщение.Сообщить();
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	//
	ГодПроекта 	= ЗадачаПроекта.Владелец.ГодПроекта;
	СтатьяФОТ	= Справочники.СтатьиСметы.ФОТ_ПП;
	Проект		= ЗадачаПроекта.Владелец;
	
	Если НЕ СовпадаетПоЗакрытомуПериоду() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	
	// по тарифным ставка и месяцам
	// должности не записываем
	Движения.ФронтРабот.Записывать = Истина;
	тзФР = ФронтРабот.Выгрузить();
	тзФР.Свернуть("Должность,ТарифнаяСтавка,Месяц", "Количество,Сумма");
	Для Каждого СтрФР ИЗ тзФР Цикл
		Если СтрФР.Сумма <> 0 Тогда
			Движение = Движения.ФронтРабот.Добавить();
			Движение.Период = Дата;
			//
			Движение.ПланРабот		= Ссылка;
			Движение.Должность 		= СтрФР.Должность;
			Движение.ТарифнаяСтавка = СтрФР.ТарифнаяСтавка;
			Движение.Месяц 			= НачалоМесяца(СтрФР.Месяц); // на всякий случай
			// 23,04,2013 - тип суммы - 0 - план
			Движение.ТипСуммы		= 0;
			//
			Движение.Количество		= СтрФР.Количество;
			Движение.Сумма			= СтрФР.Сумма;
		КонецЕсли;
	КонецЦикла;
	
	
	// 20140609
	ПоследнийМесяцПланаРабот = НачалоГода( Дата( ЗадачаПроекта.Владелец.ГодПроекта, 1, 1));
	Движения.БюджетПоМесяцам.Записывать = Истина;
	Для Каждого СтрФР ИЗ ФронтРабот Цикл
		Если СтрФР.Сумма <> 0 Тогда
		
			Движение = Движения.БюджетПоМесяцам.Добавить();
			Движение.Период 			= Дата;
			Движение.ЗадачаПроекта		= ЗадачаПроекта;
			Движение.СтатьяСметы		= СтатьяФОТ;
			// 28,03,2013
			Движение.ТипСуммы 			= Перечисления.ТипСуммыБюджета.ПервичныйДокумент;  // первичка
			Движение.Месяц 				= НачалоМесяца( СтрФР.Месяц );
			// 
			Движение.Сумма				= СтрФР.Сумма;
			
			// 20140609
			ПоследнийМесяцПланаРабот	= Макс( Движение.Месяц, ПоследнийМесяцПланаРабот );
			
		КонецЕсли;		
	КонецЦикла;
	
	// 20140609
	Если ОстатокПоСмете <> 0 Тогда
	// записываем в бюджет по месяцам на последний месяц
		Движение = Движения.БюджетПоМесяцам.Добавить();
		Движение.Период 			= Дата;
		Движение.ЗадачаПроекта		= ЗадачаПроекта;
		Движение.СтатьяСметы		= СтатьяФОТ;
		// 28,03,2013
		Движение.ТипСуммы 			= Перечисления.ТипСуммыБюджета.ПервичныйДокумент;  // первичка
		Движение.Месяц 				= ПоследнийМесяцПланаРабот;
		Движение.Сумма				= ОстатокПоСмете;
		
	КонецЕсли;		
	
	// 2015 07 03
	// надо проверить, существуют ли сейчас движения прошлого перепроведения
	//СметаПланаРабот 		= Документы.ПланРабот.СметаПланаРабот( Ссылка );
	СметаПланаРабот 		= УП_ПланыРаботПоПроектам.СметаПланаРабот(  Ссылка );
	ЗакрытиеПоПлану			= Документы.ПланРабот.ЗакрытиеПланаРабот( Ссылка );
	
	Если СметаПланаРабот <> Неопределено Тогда
		Если ОстатокПоСмете < 0 Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Остаток по смете " + ОстатокПоСмете + " меньше 0";
			Сообщение.Сообщить();
			
			Отказ = Истина;
			Возврат;			
		КонецЕсли;
		
		// есть смета в которую входит план работ, проверяем общую сумму
		ТекущаяСуммаПлан = ФронтРабот.Итог("Сумма") + ОстатокПоСмете;
		Если СметаПланаРабот.СуммаПлан <>  ТекущаяСуммаПлан Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Сумма плана " + ТекущаяСуммаПлан + " не равна плану по смете " + СметаПланаРабот.СуммаПлан;
			Сообщение.Сообщить();
			
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		// проверяем суммы закрытого периода
		СуммаЗакрыто = 0;
		Для Каждого СтрФР ИЗ ФронтРабот Цикл
			Если СтрФР.Месяц <= ЗакрытиеПоПлану.Месяц Тогда
				СуммаЗакрыто = СуммаЗакрыто + СтрФР.Сумма;
				
			КонецЕсли;
		КонецЦикла;
		
		Если ЗакрытиеПоПлану.СуммаЗакрыто <> СуммаЗакрыто Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "План закрыт по " + Формат( ЗакрытиеПоПлану.Месяц, "ДФ = 'ММММ гг'") + 
							  " на сумму " + Формат( ЗакрытиеПоПлану.СуммаЗакрыто, "ЧЦ=15; ЧДЦ=2")  + Символы.ПС +
							  ", попытка изменить на " + Формат( СуммаЗакрыто, "ЧЦ=15; ЧДЦ=2" );
			Сообщение.Сообщить();
			
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	Иначе
		ОстатокПоСмете = 0;
	КонецЕсли;			
	
	Движения.Записать();			
	
	//НЕ НУЖНО ПЕРЕПРОВОДИТЬ СМЕТУ ЗАДАЧИ
	// перепроводим смету задачи проекта, считаем что одна !!!
	//Если СметаПланаРабот <> Неопределено Тогда
	//	Попытка
	//		СмЗадачиОб = СметаПланаРабот.СметаЗадачиПроекта.ПолучитьОбъект();
	//		СмЗадачиОб.Записать( РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный );
	//	Исключение
	//		Сообщить(ОписаниеОшибки());
	//		Отказ = Истина;
	//	КонецПопытки;
	//КонецЕсли;
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	Если УП_СметаПроекта.Есть_СметаЗадачи_СодержащаяДокумент( Ссылка ) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если УП_ПереносДанных.ПроведениеПриПереносе() Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение 
	И НЕ РазрешеноПроводитьДокумент( Ссылка, Ссылка.ЗадачаПроекта.Владелец ) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;		

КонецПроцедуры


