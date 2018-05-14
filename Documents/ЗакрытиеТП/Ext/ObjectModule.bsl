﻿// проверка после проведения документов
// -закрытие актов тиражных работ 
// -закрытие тиражных проектов
Функция ОстаткиПоПлануТР( )

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗакрытиеТП.Номенклатура,
		|	ЗакрытиеТП.Цена,
		|	ЗакрытиеТП.ЦенаФОТ
		|ПОМЕСТИТЬ ВТНоменклатураЦены
		|ИЗ
		|	Документ.ЗакрытиеТП.Закрытие КАК ЗакрытиеТП
		|ГДЕ
		|	ЗакрытиеТП.Ссылка = &ЗакрытиеТиражногоПроекта
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

	Запрос.УстановитьПараметр("ЗакрытиеТиражногоПроекта", 	Ссылка);
	Запрос.УстановитьПараметр("ПланРаботТиражный", 			ПланРабот);
	//

	Результат = Запрос.Выполнить().Выгрузить();
	Возврат Результат;

КонецФункции


Процедура ОбработкаПроведения(Отказ, Режим)
	//
	Если НЕ РазрешеноПроводитьДокумент( Ссылка, Ссылка.ПланРабот.ЗадачаПроекта.Владелец ) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;		
	
	
	
	// 2014
	// новый регистр взамен ОстаткиАктов и ОстаткиЛимитаТП
	Движения.ОстаткиТирАиП.Записывать = Истина;
	Движение = Движения.ОстаткиТирАиП.Добавить();
	Движение.ВидДвижения 				= ВидДвиженияНакопления.Расход;
	Движение.Период 					= Дата;
	Движение.Источник 					= Проект;
	Движение.ПланРабот 					= ПланРабот;
	//
	Движение.Сумма 						= Закрытие.Итог("Сумма");


	// регистр ЗакрытиеПоСотрудникам 
	Движения.ЗакрытиеПоСотрудникам.Записывать = Истина;
	Для Каждого ТекСтрокаЗакрытие Из Закрытие Цикл
		Движение 				= Движения.ЗакрытиеПоСотрудникам.Добавить();
		Движение.Период 		= МесяцНачисления; // месяц начисления
		Движение.ФизическоеЛицо	= ТекСтрокаЗакрытие.ФизическоеЛицо;
		Движение.Источник 		= Проект;
		Движение.Подразделение 	= Проект.Подразделение;
		Движение.ПланРабот		= ПланРабот; // с 11,02,2013
		Движение.Сумма 			= ТекСтрокаЗакрытие.Сумма;
	КонецЦикла;

	// регистр ПланТиражныхРабот Расход
	тзЗакрытие = Закрытие.Выгрузить();
	тзЗакрытие.Свернуть("Номенклатура,Цена,ЦенаФОТ", "Количество,Скидка");
	
	Движения.ПланТиражныхРабот.Записывать = Истина;
	Для Каждого СтрТЗ Из тзЗакрытие Цикл
		Движение = Движения.ПланТиражныхРабот.Добавить();
		Движение.ВидДвижения 		= ВидДвиженияНакопления.Расход;
		Движение.Период 			= Дата;
		Движение.ПланРаботТиражный 	= ПланРабот;
		Движение.Номенклатура 		= СтрТЗ.Номенклатура;
		Движение.Цена 				= СтрТЗ.Цена;
		Движение.ЦенаФОТ 			= СтрТЗ.ЦенаФОТ;
		//
		Движение.Количество 		= СтрТЗ.Количество;
		// реквизиты
		Движение.Месяц 				= НачалоМесяца(МесяцНачисления);
		Движение.Скидка				= СтрТЗ.Скидка;
	КонецЦикла;
	// записываем проведение	
	Движения.Записать();
	
	
	//
	ОстаткиПоПлануТиражныхРабот = ОстаткиПоПлануТР();
	Для Каждого Остаток ИЗ ОстаткиПоПлануТиражныхРабот Цикл
		Сообщение = Новый СообщениеПользователю;
        Сообщение.Текст = "Не хватает " + (-Остаток.Остаток)+ " " + Остаток.Номенклатура.ЕдиницаИзмерения + " " + Остаток.Номенклатура + ", по цене "+ Остаток.Цена + 
		" (Цена ФОТ " + Остаток.ЦенаФОТ + ")";

        Сообщение.Сообщить();
		Если НЕ УП_ПереносДанных.ПроведениеПриПереносе() Тогда
        	Отказ = Истина;      
		КонецЕсли;
		
	КонецЦикла;
	
	// здесь надо написать остатки по лимиту плана работ !!!
	
	
КонецПроцедуры

