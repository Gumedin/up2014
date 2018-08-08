﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ИсполнительДокумента = ПараметрыСеанса.ТекущийПользователь;
КонецПроцедуры

Процедура ЗаполнитьДвижениеПоМесяцам( Стр, Движения, ИмяСтатьи, ИмяСуммы = "" )
	
	// 2017 08 09 
	Сумма = Стр[ ?(ЗначениеЗаполнено(ИмяСуммы), ИмяСуммы,  ИмяСтатьи )]; // Стр[ИмяСтатьи];
	Если Сумма = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Движение = Движения.БюджетПоМесяцам.Добавить();
	
	Движение.Период 		= Дата;
	Движение.ЗадачаПроекта 	= Стр.ЗадачаПроекта;
	Движение.СтатьяСметы 	= Справочники.СтатьиСметы[ИмяСтатьи];
	// 08,04,20013
	Движение.ТипСуммы 		= Перечисления.ТипСуммыБюджета.Факт;  // факт
	Движение.Месяц 			= НачалоМесяца(Дата);
	// 2016 02 15 
	Движение.РКО			= Истина;
	//
	Движение.Сумма			= Сумма;
КонецПроцедуры		

// по регистру обеспечено
Процедура ЗаполнитьДвижениеОбеспечено( Стр, Движения, ИмяСтатьи )
	
	Сумма = Стр[ИмяСтатьи];
	Если Сумма = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Движение = Движения.ОбеспеченоПоСтатье.Добавить();
	Движение.ВидДвижения 	= ВидДвиженияНакопления.Приход;
	Движение.Период 		= Дата;
	Движение.ЗадачаПроекта 	= Стр.ЗадачаПроекта;
	Движение.СтатьяСметы 	= Справочники.СтатьиСметы[ИмяСтатьи];
	//
	Движение.Сумма 			= Сумма;
	
КонецПроцедуры		

// определяет задолженность по посредникам по движениям первичных документов и начислениям в регистре
Функция ПланНачисленияПосредникамПоЗадачеПроекта( ЗадачаПроекта )
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПланВознагражденияПосредникаНачисления.Посредник,
		|	СУММА(ПланВознагражденияПосредникаНачисления.Сумма) КАК Сумма
		|ИЗ
		|	Документ.ПланВознагражденияПосредника.Начисления КАК ПланВознагражденияПосредникаНачисления
		|ГДЕ
		|	ПланВознагражденияПосредникаНачисления.Ссылка.Проведен
		|	И ПланВознагражденияПосредникаНачисления.Ссылка.ЗадачаПроекта = &ЗадачаПроекта
		|
		|СГРУППИРОВАТЬ ПО
		|	ПланВознагражденияПосредникаНачисления.Посредник";
	
	Запрос.УстановитьПараметр("ЗадачаПроекта", ЗадачаПроекта);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат РезультатЗапроса;
	
КонецФункции

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// регистр ОбеспеченоПоСтатье Приход
	Движения.ОбеспеченоПоСтатье.Записывать = Истина;
	Для Каждого ТекСтрокаРасшифровкаПлатежа Из РасшифровкаПлатежа Цикл
		ЗаполнитьДвижениеОбеспечено( ТекСтрокаРасшифровкаПлатежа, Движения, "РасходыКоммерческие");
		ЗаполнитьДвижениеОбеспечено( ТекСтрокаРасшифровкаПлатежа, Движения, "РасходыППЛО");
	КонецЦикла;

	
	// 2017 06 09
	// в разрезе задач
	// регистр ВознаграждениеПосредника Приход
	Движения.ВознаграждениеПосредника.Записывать = Истина;
	Для Каждого СтрРасшифровкаПлатежа ИЗ РасшифровкаПлатежа Цикл
		Если СтрРасшифровкаПлатежа.ВознагрПосредника = 0 Тогда 
			Продолжить;
		КонецЕсли;
		// посредник, сумма
		тзЗПП 	= ПланНачисленияПосредникамПоЗадачеПроекта(СтрРасшифровкаПлатежа.ЗадачаПроекта);
		//Если тзЗПП = Неопределено Тогда
		// 2017 06 19
		Если тзЗПП.Количество() = 0 Тогда
		// нет данных по данной задаче, записываем на анонимного посредника
			Движение 				= Движения.ВознаграждениеПосредника.Добавить();
			Движение.ВидДвижения 	= ВидДвиженияНакопления.Приход;
			Движение.Период 		= Дата;
			Движение.Проект  		= Договор.Проект;
			Движение.Сумма 			= СтрРасшифровкаПлатежа.ВознагрПосредника;
			Движение.ЗадачаПроекта  = СтрРасшифровкаПлатежа.ЗадачаПроекта;
		Иначе
			мК 		= тзЗПП.ВыгрузитьКолонку("Сумма");
			мСумм 	= РаспределитьПропорционально(  СтрРасшифровкаПлатежа.ВознагрПосредника, мК, 2);
			Если мСумм <> Неопределено Тогда
			// может быть неопределено, если все коэффициенты = 0
				// теперь делаем движения по регистру Бюджет по месяцам 
				Для Каждого Стр ИЗ тзЗПП Цикл
					СуммаПосреднику = мСумм[тзЗПП.Индекс( Стр )];
					Если СуммаПосреднику <> 0 Тогда
						Движение 				= Движения.ВознаграждениеПосредника.Добавить();
						Движение.ВидДвижения 	= ВидДвиженияНакопления.Приход;
						Движение.Период 		= Дата;
						Движение.Проект  		= Договор.Проект;
						Движение.Посредник		= Стр.Посредник;
						// сумма по посреднику
						Движение.Сумма			= СуммаПосреднику;
						Движение.ЗадачаПроекта  = СтрРасшифровкаПлатежа.ЗадачаПроекта;
					КонецЕсли;
				КонецЦикла;	
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// старый вариант
	//Движения.ВознаграждениеПосредника.Записывать = Истина;
	//Движение 				= Движения.ВознаграждениеПосредника.Добавить();
	//Движение.ВидДвижения 	= ВидДвиженияНакопления.Приход;
	//Движение.Период 		= Дата;
	//Движение.Проект  		= Договор.Проект;
	//Движение.Сумма 		= РасшифровкаПлатежа.Итог("ВознагрПосредника");
	
	
	//*********************************************************************
	//  29,04,2013
	// регистр БюджетПоМесяцам
	//Движения.БюджетПоМесяцам.Записывать = Истина;
	//Для Каждого ТекСтрокаРасшифровкаПлатежа Из РасшифровкаПлатежа Цикл
	//	// 1, доходы всего                                                                              
	//	ЗаполнитьДвижениеПоМесяцам(ТекСтрокаРасшифровкаПлатежа, Движения, "ДоходыВс" );
	//	// 2, вознаграждение		
	//	ЗаполнитьДвижениеПоМесяцам(ТекСтрокаРасшифровкаПлатежа, Движения, "ВознагрПосредника" );
	//	// 3, расходы на вознаграждение		
	//	ЗаполнитьДвижениеПоМесяцам(ТекСтрокаРасшифровкаПлатежа, Движения, "РасходыВознПосредника" );
	//	// 4.
	//	// 2015 06 02 ФОТ по оплате
	//	ЗаполнитьДвижениеПоМесяцам(ТекСтрокаРасшифровкаПлатежа, Движения, "ФОТ_ПП" );
	//	
	//	// 5. 
	//	// 2017 08 09 - оплата дает факт по статье 5.1 вознаграждение клиент менкеджера по проекту
	//	Если  ГодЗадачиПроекта( ТекСтрокаРасшифровкаПлатежа.ЗадачаПроекта ) >= 2017 Тогда
	//		// расходы коммерческие - на статью ВознаграждениеКМ
	//		ЗаполнитьДвижениеПоМесяцам(ТекСтрокаРасшифровкаПлатежа, Движения, "ВознаграждениеКМ", "РасходыКоммерческие" );
	//	КонецЕсли;
	//	
	//КонецЦикла;
	
	// 2015 09 29
	// сумма фот по оплате в фонды подразделений
	//Движения.ФондПодразделений.Записывать = Истина;
	//Для Каждого ТекСтрокаРасшифровкаПлатежа Из РасшифровкаПлатежа Цикл
	//	СуммаФП = ТекСтрокаРасшифровкаПлатежа.ФОТ_ПП;		
	//	Если СуммаФП <> 0 Тогда
	//		Движение 				= Движения.ФондПодразделений.Добавить();
	//		Движение.Период 		= Дата;
	//		Движение.ВидДвижения 	= ВидДвиженияНакопления.Приход;
	//		Движение.Подразделение	= ТекСтрокаРасшифровкаПлатежа.ЗадачаПроекта.Подразделение;
	//		Движение.Год			= ГодФондаПодразделения( Дата );
	//		Движение.Сумма			= СуммаФП;
	//	КонецЕсли;
	//КонецЦикла;
	
	// 2016 11 02
	// регистр обеспечено-оплачено
	// график платежа всегда заполнен
	Движения.ОбеспечениеОплата.Записывать = Истина;
	Для Каждого ТекСтрокаРасшифровкаПлатежа Из РасшифровкаПлатежа Цикл
		//
		Движение 				= Движения.ОбеспечениеОплата.Добавить();
		Движение.Период 		= Дата;
		Движение.ЗадачаПроекта 	= ТекСтрокаРасшифровкаПлатежа.ЗадачаПроекта;
		Движение.Договор 		= Договор;
		Движение.Месяц 			= НачалоМесяца( Дата );
		//
		Движение.СуммаОплачено	= ТекСтрокаРасшифровкаПлатежа.Сумма;
	КонецЦикла;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	//Если Константы.ПереносДанных.Получить() Тогда
	//// для массового перепроведения докуентов
	//	Возврат;
	//КонецЕсли;
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение 
	И НЕ ВсеЗадачиВУказанномСтатусе( Перечисления.СтатусыПроектов.ВРаботе, 
										Ссылка.РасшифровкаПлатежа.Выгрузить(, "ЗадачаПроекта") ) Тогда
		Сообщить("Не все проекты в статусе " + Перечисления.СтатусыПроектов.ВРаботе );
		Отказ = Истина;
		Возврат;
	КонецЕсли;

КонецПроцедуры


