﻿
&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	Объект.ПериодРегистрации = НачалоМесяца( Объект.ПериодРегистрации );
КонецПроцедуры


#Область Начисление

//&НаСервере
//Процедура ЗаполнитьТаблицуНачисления()
//	Док = РеквизитФормыВЗначение("Объект");
//	Док.Начисление.Очистить();
//	
//	
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	СУММА(ВЫБОР
//		|			КОГДА БюджетПоМесяцам.СтатьяСметы = &СтатьяБазы
//		|				ТОГДА БюджетПоМесяцам.Сумма
//		|			ИНАЧЕ 0
//		|		КОНЕЦ) КАК СуммаБазаРаспределения,
//		|	СУММА(ВЫБОР
//		|			КОГДА БюджетПоМесяцам.СтатьяСметы = &СтатьяНачисления
//		|				ТОГДА БюджетПоМесяцам.Сумма
//		|			ИНАЧЕ 0
//		|		КОНЕЦ) КАК СуммаРанее,
//		|	БюджетПоМесяцам.ЗадачаПроекта,
//		|	СУММА(0) КАК СуммаВычета,
//		|	СУММА(0) КАК СуммаНачислено,
//		|	СУММА(0) КАК СуммаНачисленоВычета
//		|ИЗ
//		|	РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
//		|ГДЕ
//		|	БюджетПоМесяцам.Месяц = &ПериодРегистрации
//		|	И БюджетПоМесяцам.ЗадачаПроекта.Владелец.ГодПроекта = &ГодПроекта
//		|	И (БюджетПоМесяцам.СтатьяСметы = &СтатьяБазы
//		|			ИЛИ БюджетПоМесяцам.СтатьяСметы = &СтатьяНачисления)
//		|	И БюджетПоМесяцам.ТипСуммы = &ТипСуммы
//		|	И БюджетПоМесяцам.РКО
//		|
//		|СГРУППИРОВАТЬ ПО
//		|	БюджетПоМесяцам.ЗадачаПроекта";
//	
//	Запрос.УстановитьПараметр("ГодПроекта", 			Объект.ГодПроекта);
//	Запрос.УстановитьПараметр("ПериодРегистрации", 		НачалоМесяца(Объект.ПериодРегистрации));
//	Запрос.УстановитьПараметр("СтатьяБазы", 			Объект.СтатьяБазыНачисления);
//	Запрос.УстановитьПараметр("СтатьяНачисления", 		Объект.СтатьяНачисления);
//	Запрос.УстановитьПараметр("ТипСуммы", 				Перечисления.ТипСуммыБюджета.Факт );
//	//Запрос.УстановитьПараметр("ПроцентНачисления", 		Объект.ПроцентНачисления/100);
//	
//	РезультатЗапроса 	= Запрос.Выполнить().Выгрузить();
//	МассивКоэфф 		= РезультатЗапроса.ВыгрузитьКолонку("СуммаБазаРаспределения");
//	Если Объект.СуммаВычета <> 0 Тогда
//		мВычеты				= РаспределитьПропорционально( Объект.СуммаВычета, 	МассивКоэфф);
//	КонецЕсли;
//	Для Каждого СтрРЗ ИЗ РезультатЗапроса Цикл
//		Индекс					= РезультатЗапроса.Индекс(СтрРЗ);
//		Если Объект.СуммаВычета <> 0 Тогда
//			СтрРЗ.СуммаВычета 		= мВычеты[Индекс];
//		КонецЕсли;
//		// %
//		СтрРЗ.СуммаНачислено		= Окр( (СтрРЗ.СуммаБазаРаспределения - СтрРЗ.СуммаВычета) * Объект.ПроцентНачисления/100, 2);
//		СтрРЗ.СуммаНачисленоВычета	= Окр( СтрРЗ.СуммаВычета * Объект.ПроцентВычета/100, 2);
//	КонецЦикла;
//	
//	
//	Док.Начисление.Загрузить( РезультатЗапроса );
//	Док.СуммаДокумента = РезультатЗапроса.Итог("СуммаНачислено") + РезультатЗапроса.Итог("СуммаНачисленоВычета");
//	
//	ЗначениеВРеквизитФормы(Док, "Объект");
//КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуНачисления_Уст()
	Док = РеквизитФормыВЗначение("Объект");
	Док.Начисление.Очистить();
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ВЫБОР
		|			КОГДА БюджетПоМесяцам.СтатьяСметы = &СтатьяБазы
		|				ТОГДА БюджетПоМесяцам.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК СуммаБазаРаспределения,
		|	СУММА(ВЫБОР
		|			КОГДА БюджетПоМесяцам.СтатьяСметы = &СтатьяНачисления
		|				ТОГДА БюджетПоМесяцам.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК СуммаРанее,
		|	БюджетПоМесяцам.ЗадачаПроекта,
		|	СУММА(0) КАК СуммаВычета,
		|	СУММА(0) КАК СуммаНачислено,
		|	СУММА(0) КАК СуммаНачисленоВычета
		|ИЗ
		|	РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
		|ГДЕ
		|	БюджетПоМесяцам.Месяц = &ПериодРегистрации
		|	И БюджетПоМесяцам.ЗадачаПроекта.Владелец.ГодПроекта = &ГодПроекта
		|	И (БюджетПоМесяцам.СтатьяСметы = &СтатьяБазы
		|			ИЛИ БюджетПоМесяцам.СтатьяСметы = &СтатьяНачисления)
		|	И БюджетПоМесяцам.ТипСуммы = &ТипСуммы
		|	И БюджетПоМесяцам.РКО
		|	И (&ГодЗадачи = 0
		|			ИЛИ ВЫБОР
		|				КОГДА БюджетПоМесяцам.ЗадачаПроекта.НачалоРабот = ДАТАВРЕМЯ(1, 1, 1)
		|					ТОГДА БюджетПоМесяцам.ЗадачаПроекта.Владелец.ГодПроекта
		|				ИНАЧЕ ГОД(БюджетПоМесяцам.ЗадачаПроекта.НачалоРабот)
		|			КОНЕЦ = &ГодЗадачи)
		|
		|СГРУППИРОВАТЬ ПО
		|	БюджетПоМесяцам.ЗадачаПроекта";
	
	Запрос.УстановитьПараметр("ГодПроекта", 			Объект.ГодПроекта);
	Запрос.УстановитьПараметр("ГодЗадачи", 				Объект.ГодЗадачи);
	Запрос.УстановитьПараметр("ПериодРегистрации", 		НачалоМесяца(Объект.ПериодРегистрации));
	Запрос.УстановитьПараметр("СтатьяБазы", 			Объект.СтатьяБазыНачисления);
	Запрос.УстановитьПараметр("СтатьяНачисления", 		Объект.СтатьяНачисления);
	Запрос.УстановитьПараметр("ТипСуммы", 				Перечисления.ТипСуммыБюджета.Факт );
	//Запрос.УстановитьПараметр("ПроцентНачисления", 		Объект.ПроцентНачисления/100);
	
	РезультатЗапроса 	= Запрос.Выполнить().Выгрузить();
	МассивКоэфф 		= РезультатЗапроса.ВыгрузитьКолонку("СуммаБазаРаспределения");
	Если Объект.СуммаВычета <> 0 Тогда
		мВычеты				= РаспределитьПропорционально( Объект.СуммаВычета, 	МассивКоэфф);
	КонецЕсли;
	Для Каждого СтрРЗ ИЗ РезультатЗапроса Цикл
		Индекс					= РезультатЗапроса.Индекс(СтрРЗ);
		Если Объект.СуммаВычета <> 0 Тогда
			СтрРЗ.СуммаВычета 		= мВычеты[Индекс];
		КонецЕсли;
		// %
		СтрРЗ.СуммаНачислено		= Окр( (СтрРЗ.СуммаБазаРаспределения - СтрРЗ.СуммаВычета) * Объект.ПроцентНачисления/100, 2);
		СтрРЗ.СуммаНачисленоВычета	= Окр( СтрРЗ.СуммаВычета * Объект.ПроцентВычета/100, 2);
	КонецЦикла;
	
	
	Док.Начисление.Загрузить( РезультатЗапроса );
	Док.СуммаДокумента = РезультатЗапроса.Итог("СуммаНачислено") + РезультатЗапроса.Итог("СуммаНачисленоВычета");
	
	ЗначениеВРеквизитФормы(Док, "Объект");
КонецПроцедуры

// по реквизиту год задачи
&НаСервере
Процедура ЗаполнитьТаблицуНачисления()
	Док = РеквизитФормыВЗначение("Объект");
	Док.Начисление.Очистить();
	
	//Добавлно условние "Регистратор <> &Регистратор" по задаче #131841 от 11.07.2018 Гумедин А.Г.
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ВЫБОР
		|			КОГДА БюджетПоМесяцам.СтатьяСметы = &СтатьяБазы
		|				ТОГДА БюджетПоМесяцам.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК СуммаБазаРаспределения,
		|	СУММА(ВЫБОР
		|			КОГДА БюджетПоМесяцам.СтатьяСметы = &СтатьяНачисления
		|				ТОГДА БюджетПоМесяцам.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК СуммаРанее,
		|	БюджетПоМесяцам.ЗадачаПроекта,
		|	СУММА(0) КАК СуммаВычета,
		|	СУММА(0) КАК СуммаНачислено,
		|	СУММА(0) КАК СуммаНачисленоВычета
		|ИЗ
		|	РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
		|ГДЕ
		|	БюджетПоМесяцам.Месяц = &ПериодРегистрации
		|	И (&ГодПроекта = 0
		|			ИЛИ БюджетПоМесяцам.ЗадачаПроекта.Владелец.ГодПроекта = &ГодПроекта)
		|	И (БюджетПоМесяцам.СтатьяСметы = &СтатьяБазы
		|			ИЛИ БюджетПоМесяцам.СтатьяСметы = &СтатьяНачисления)
		|	И БюджетПоМесяцам.ТипСуммы = &ТипСуммы
		|	И БюджетПоМесяцам.РКО
		|	И (&ГодЗадачи = 0
		|			ИЛИ БюджетПоМесяцам.ЗадачаПроекта.ГодЗадачи = &ГодЗадачи)
		|	И БюджетПоМесяцам.Регистратор <> &Регистратор
		|
		|СГРУППИРОВАТЬ ПО
		|	БюджетПоМесяцам.ЗадачаПроекта";
	
	Запрос.УстановитьПараметр("ГодПроекта", 			Объект.ГодПроекта);
	Запрос.УстановитьПараметр("ГодЗадачи", 				Объект.ГодЗадачи);
	Запрос.УстановитьПараметр("ПериодРегистрации", 		НачалоМесяца(Объект.ПериодРегистрации));
	Запрос.УстановитьПараметр("СтатьяБазы", 			Объект.СтатьяБазыНачисления);
	Запрос.УстановитьПараметр("СтатьяНачисления", 		Объект.СтатьяНачисления);
	Запрос.УстановитьПараметр("ТипСуммы", 				Перечисления.ТипСуммыБюджета.Факт );
	Запрос.УстановитьПараметр("Регистратор", 			Объект.Ссылка);
	//Запрос.УстановитьПараметр("ПроцентНачисления", 		Объект.ПроцентНачисления/100);
	
	РезультатЗапроса 	= Запрос.Выполнить().Выгрузить();
	МассивКоэфф 		= РезультатЗапроса.ВыгрузитьКолонку("СуммаБазаРаспределения");
	Если Объект.СуммаВычета <> 0 Тогда
		мВычеты				= РаспределитьПропорционально( Объект.СуммаВычета, 	МассивКоэфф);
	КонецЕсли;
	Для Каждого СтрРЗ ИЗ РезультатЗапроса Цикл
		Индекс					= РезультатЗапроса.Индекс(СтрРЗ);
		Если Объект.СуммаВычета <> 0 Тогда
			СтрРЗ.СуммаВычета 		= мВычеты[Индекс];
		КонецЕсли;
		// %
		СтрРЗ.СуммаНачислено		= Окр( (СтрРЗ.СуммаБазаРаспределения - СтрРЗ.СуммаВычета) * Объект.ПроцентНачисления/100, 2);
		СтрРЗ.СуммаНачисленоВычета	= Окр( СтрРЗ.СуммаВычета * Объект.ПроцентВычета/100, 2);
	КонецЦикла;
	
	
	Док.Начисление.Загрузить( РезультатЗапроса );
	Док.СуммаДокумента = РезультатЗапроса.Итог("СуммаНачислено") + РезультатЗапроса.Итог("СуммаНачисленоВычета");
	
	ЗначениеВРеквизитФормы(Док, "Объект");
КонецПроцедуры


&НаСервере
Процедура НачислитьНаСервере()
	ЗаполнитьТаблицуНачисления();
	
КонецПроцедуры

&НаКлиенте
Процедура Начислить(Команда)
	НачислитьНаСервере();
	ЭтаФорма.ОбновитьОтображениеДанных();
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти