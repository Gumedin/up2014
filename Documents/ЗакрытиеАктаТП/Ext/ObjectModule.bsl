﻿// проверка после проведения документов
// -закрытие актов тиражных работ 
// -закрытие тиражных проектов
Функция ОстаткиПоПлануТР() 

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗакрытиеАТП.Номенклатура,
		|	ЗакрытиеАТП.Цена,
		|	ЗакрытиеАТП.ЦенаФОТ
		|ПОМЕСТИТЬ ВТНоменклатураЦены
		|ИЗ
		|	Документ.ЗакрытиеАктаТП.ФизическиеЛица КАК ЗакрытиеАТП
		|ГДЕ
		|	ЗакрытиеАТП.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОстаткиПТР.Номенклатура,
		|	ОстаткиПТР.Цена,
		|	ОстаткиПТР.ЦенаФОТ,
		|	СУММА(ОстаткиПТР.КоличествоОстаток) КАК Остаток
		|ИЗ
		|	ВТНоменклатураЦены КАК ВТНоменклатураЦены
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПланТиражныхРабот.Остатки(, ПланРаботТиражный = &ПланРаботТиражный) КАК ОстаткиПТР
		|		ПО ВТНоменклатураЦены.Номенклатура = ОстаткиПТР.Номенклатура
		|			И ВТНоменклатураЦены.Цена = ОстаткиПТР.Цена
		|			И ВТНоменклатураЦены.ЦенаФОТ = ОстаткиПТР.ЦенаФОТ
		|ГДЕ
		|	ОстаткиПТР.КоличествоОстаток < 0
		|
		|СГРУППИРОВАТЬ ПО
		|	ОстаткиПТР.Номенклатура,
		|	ОстаткиПТР.Цена,
		|	ОстаткиПТР.ЦенаФОТ";

	Запрос.УстановитьПараметр("Ссылка", 			Ссылка);
	Запрос.УстановитьПараметр("ПланРаботТиражный", 	АктТиражногоПодразделения.ПланРабот);
	//

	Результат = Запрос.Выполнить().Выгрузить();
	Возврат Результат;

КонецФункции


Процедура ОбработкаПроведения(Отказ, Режим)
	//
	ПланРабот = АктТиражногоПодразделения.ПланРабот;
	
	Если НЕ РазрешеноПроводитьДокумент( Ссылка, ПланРабот.ЗадачаПроекта.Владелец ) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;		
	
	Если 	ФизическиеЛица.Количество() = 0 
	или		ФизическиеЛица.Итог("Количество")=0 
	или		ФизическиеЛица.Итог("Сумма")=0 Тогда
		Сообщение 		= Новый СообщениеПользователю;
        Сообщение.Текст = "Не заполнена табличная часть";
        Сообщение.Сообщить();

        Отказ = Истина;      
		Возврат;
	КонецЕсли;
	
	
	// 2014
	// новый регистр взамен ОстаткиАктов и Остатк Лимита
	Движения.ОстаткиТирАиП.Записывать = Истина;
	Для Каждого ТекСтрока Из ФизическиеЛица Цикл
		Движение = Движения.ОстаткиТирАиП.Добавить();
		Движение.ВидДвижения 				= ВидДвиженияНакопления.Расход;
		Движение.Период 					= Дата;
		Движение.Источник 					= АктТиражногоПодразделения;
		Движение.ПланРабот 					= ПланРабот;
		//
		Движение.Сумма 						= ТекСтрока.Сумма;
	КонецЦикла;
	

	// регистр ЗакрытиеПоСотрудникам 
	Движения.ЗакрытиеПоСотрудникам.Записывать = Истина;
	Для Каждого ТекСтрока Из ФизическиеЛица Цикл
		Движение = Движения.ЗакрытиеПоСотрудникам.Добавить();
		Движение.Период 		= Дата;
		Движение.ФизическоеЛицо = ТекСтрока.ФизическоеЛицо;
		Движение.Источник 		= АктТиражногоПодразделения;
		Движение.Подразделение 	= АктТиражногоПодразделения.Подразделение;
		Движение.ПланРабот 		= ПланРабот;
		Движение.Сумма 			= ТекСтрока.Сумма;
	КонецЦикла;

	// регистр ПланТиражныхРабот Расход
	Если ЗначениеЗаполнено( ПланРабот ) Тогда
		тзЗакрытие = ФизическиеЛица.Выгрузить();
		тзЗакрытие.Свернуть("Номенклатура,Цена,ЦенаФОТ", "Количество,Скидка");
		Движения.ПланТиражныхРабот.Записывать = Истина;
		Для Каждого СтрТЗ Из тзЗакрытие Цикл
			Движение = Движения.ПланТиражныхРабот.Добавить();
			Движение.ВидДвижения 		= ВидДвиженияНакопления.Расход;
			Движение.Период 			= Дата;
			//
			Движение.ПланРаботТиражный 	= АктТиражногоПодразделения.ПланРабот;
			Движение.Номенклатура 		= СтрТЗ.Номенклатура;
			Движение.Цена 				= СтрТЗ.Цена;
			Движение.ЦенаФОТ 			= СтрТЗ.ЦенаФОТ;
			// ресурс
			Движение.Количество 		= СтрТЗ.Количество;
			// реквизит
			Движение.Месяц 				= НачалоМесяца(Дата);
			Движение.Скидка				= СтрТЗ.Скидка;
			
		КонецЦикла;
		
			ОстаткиПоПлануТиражныхРабот = ОстаткиПоПлануТР(  );
			Для Каждого Остаток ИЗ ОстаткиПоПлануТиражныхРабот Цикл
				Сообщение = Новый СообщениеПользователю;
		        Сообщение.Текст = "Не хватает " + (-Остаток.Остаток)+ " " + Остаток.Номенклатура.ЕдиницаИзмерения + " " + Остаток.Номенклатура + ", по цене "+ Остаток.Цена + 
				" (Цена ФОТ " + Остаток.ЦенаФОТ + ")";
		        Сообщение.Сообщить();
				
				//
				Если НЕ УП_ПереносДанных.ПроведениеПриПереносе() Тогда
					Отказ = Истина;      
				КонецЕсли;		
				
			КонецЦикла;
			
	Иначе
		Сообщение = Новый СообщениеПользователю;
        Сообщение.Текст = "В документе " + Ссылка + ", в акте ТП не заполнен план работ";
        Сообщение.Сообщить();
		
	КонецЕсли;
	// записываем проведение	
	Движения.Записать();
	

КонецПроцедуры

