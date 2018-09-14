﻿Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Ложь;
	// печать счёта на оплату            
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЦепочкиРабот") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЦепочкиРабот",
			НСтр("ru = 'Цепочки работ'"),
			ПечатьЦепочек( МассивОбъектов ),
			,
			"ПФ_MXL_ЦепочкиРабот");
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СтруктураРабот") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"СтруктураРабот",
			НСтр("ru = 'Структура работ задачи'"),
			ПечатьСтруктурыРабот( МассивОбъектов ),
			,
			"ПФ_MXL_ЦепочкиРабот");
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Постановка") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"Постановка",
			НСтр("ru = 'Постановка задачи'"),			
			ПечатьПостановки(МассивОбъектов, ОбъектыПечати, "Справочник.ЗадачиПроектов.ПФ_MXL_Постановка"),
			,
			"ПФ_MXL_Постановка");
	КонецЕсли;
	
КонецПроцедуры

#Область ПечатьПостановки
Функция ПечатьПостановки(Документ, ОбъектыПечати, ИмяМакета)
    // Создаем табличный документ и устанавливаем имя параметров печати.
    ТабличныйДокумент = Новый ТабличныйДокумент;
    ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_Постановка";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы(ИмяМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.Заполнить(Документ);
	ТабличныйДокумент.Вывести(ОбластьМакета);
				
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок1");
	ОбластьМакета.Параметры.Заполнить(Документ);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("КонтрольныеТочки");
	Для Каждого точка из Документ.КонтрольныеТочки Цикл
		ОбластьМакета.Параметры.Заполнить(точка);
		ТабличныйДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок2");
	ОбластьМакета.Параметры.Заполнить(Документ);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Исполнители");
	Для Каждого исполнитель из Документ.Исполнители Цикл
		ОбластьМакета.Параметры.Заполнить(исполнитель);
		ТабличныйДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
	ОбластьМакета.Параметры.Заполнить(Документ);
	ОбластьМакета.Параметры["Дата"] = ТекущаяДата();
	ОбластьМакета.Параметры["КлиентМенеджер"] = Документ.Владелец.МенеджерПроекта;
	ОбластьМакета.Параметры["ДиректорПроекта"] = Документ.Владелец.ДиректорПроекта;
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	Возврат ТабличныйДокумент;
КонецФункции
#КонецОбласти

#Область ПечатьЦепочекРабот

Функция ПечатьЦепочек( МассивОбъектов ) Экспорт
	ТаблДок 	= Новый ТабличныйДокумент;
	
	ЗадачаПроекта = МассивОбъектов[0];
	Цепочки		= УП_РаботыСервер.ПолучитьЦепочкиЗадачиПроекта( ЗадачаПроекта );
	Если Цепочки.Количество() = 0 Тогда
		Возврат ТаблДок;
	КонецЕсли;
	
	ПериодРабот = Новый СтандартныйПериод;	
	ПериодРабот.ДатаНачала 		= ЗадачаПроекта.НачалоРабот;
	ПериодРабот.ДатаОкончания	= ЗадачаПроекта.ОкончаниеРабот;
	
	Макет = Справочники.ЗадачиПроектов.ПолучитьМакет("ПФ_MXL_ЦепочкиРабот");
	ОблШ  = Макет.ПолучитьОбласть("Заголовок|Начало");
	ОблШ.Параметры.ЗадачаПроекта	= ЗадачаПроекта;
	ОблШ.Параметры.ПериодРабот		= ПредставлениеПериода( ПериодРабот.ДатаНачала, 
															ПериодРабот.ДатаОкончания,"ФП=Истина");
	ТаблДок.Вывести(ОблШ);
	
	МаксКолЭтапов = 0;
	Для Каждого Цепочка ИЗ Цепочки Цикл
		МаксКолЭтапов = Макс( МаксКолЭтапов, Цепочка.Количество());
	КонецЦикла;
	
	
	Обл = Макет.ПолучитьОбласть("Заголовок|Этап");
	Для Н = 1 ПО МаксКолЭтапов Цикл
		ТаблДок.Присоединить(Обл);
	КонецЦикла;
	Обл = Макет.ПолучитьОбласть("Заголовок|Итог");
	ТаблДок.Присоединить(Обл);
	
	
	
	Для Каждого Цепочка ИЗ Цепочки Цикл
		Обл = Макет.ПолучитьОбласть("Цепочка|Начало");
		Обл.Параметры.НомерЦепочки = Цепочки.Найти( Цепочка )+ 1;
		ТаблДок.Вывести( Обл );
		
		РезервЦепочки = 0;
		Для Н = 1 ПО МаксКолЭтапов Цикл
			Если Н > Цепочка.Количество() Тогда
				ОблЭтап = Макет.ПолучитьОбласть("Цепочка|НетЭтапа");
			Иначе
				ОблЭтап = Макет.ПолучитьОбласть("Цепочка|Этап");
				
				Этап 			= Цепочка[Н-1];
				РезервЦепочки 	= РезервЦепочки + Этап.Резерв;
				ЗаполнитьЗначенияСвойств( ОблЭтап.Параметры, Этап );
				ОблЭтап.Параметры.ПредставлениеЭтапа = "" + Этап.Код + ". " +  Этап.Наименование;
			КонецЕсли;
			
			ТаблДок.Присоединить( ОблЭтап );
		КонецЦикла;
		
		Обл = Макет.ПолучитьОбласть("Цепочка|Итог");
		Обл.Параметры.Резерв = РезервЦепочки;
		ТаблДок.Присоединить( Обл );
		Если РезервЦепочки = 0 Тогда 
		// критический путь, расцвечиваем строку
			Высота = ТаблДок.ВысотаТаблицы;
			Ширина = ТаблДок.ШиринаТаблицы;
			ОблКП = ТаблДок.Область(Высота-3,1,Высота,Ширина);
			ОблКП.ЦветФона = ЦветаСтиля.ЦветФонаШапкиОтчета;
		
		КонецЕсли;
		
	КонецЦикла;
	
	ТаблДок.АвтоМасштаб			= Истина;
	ТаблДок.ОриентацияСтраницы	= ОриентацияСтраницы.Ландшафт;
	
	Возврат ТаблДок;
КонецФункции

#КонецОбласти


 #Область ПечатьСтруктурыРабот

Функция ПечатьСтруктурыРабот( МассивОбъектов ) Экспорт
	ТаблДок 	= Новый ТабличныйДокумент;
	
	ЗадачаПроекта = МассивОбъектов[0];
	Если НЕ ЗначениеЗаполнено( ЗадачаПроекта ) Тогда
		Возврат ТаблДок;
	КонецЕсли;
	//
	Связи 	= УП_РаботыСервер.ПолучитьСвязиРабот( ЗадачаПроекта );
	
	// этапы
	Этапы = СтруктураТаблицыРабот();
	ЗаполнитьТаблицуЭтапов( Этапы, Связи );
	
	//
	Этапы.Сортировать("Этап");
	// заполняем уровни для выдачи этапов
	Уровни = РасчитатьУровниЭтапов( Этапы );

	// 
	ПараметрыТД = ПараметрыТабличногоДокумента();
	
	
	ЛевоЭтапа = ПараметрыТД.ШиринаОтступа;
	Для каждого СтруктураХ Из Уровни.Х Цикл
		
		Если СтруктураХ.Ключ Тогда
			ЛевоЭтапа = ЛевоЭтапа + Макс(СтруктураХ.Значение.ОтступХ + 1, 2) * 
							ПараметрыТД.ШиринаОтступа + ПараметрыТД.ШиринаЭтапа;
		КонецЕсли;
		
		СтруктураХ.Значение.Вставить("ЛевоЭтапа", ЛевоЭтапа);
		
	КонецЦикла;
	
	ВерхЭтапа = ПараметрыТД.ВысотаОтступа;
	Для каждого СтруктураУ Из Уровни.У Цикл
		
		Если СтруктураУ.Ключ Тогда
			ВерхЭтапа = ВерхЭтапа + Макс(Уровни.У[СтруктураУ.Ключ - 1].ОтступУ + 1, 1) * 
							ПараметрыТД.ВысотаОтступа + ПараметрыТД.ВысотаЭтапа;
		КонецЕсли;
		
		СтруктураУ.Значение.Вставить("ВерхЭтапа", ВерхЭтапа);
		
	КонецЦикла;
	
	Для каждого СтруктураХ Из Уровни.Х Цикл
		
		СтрокиУровня = Этапы.НайтиСтроки(Новый Структура("УровеньХ", СтруктураХ.Ключ));
		
		Для каждого СтрокаЭтапа Из СтрокиУровня Цикл
			
			НарисоватьСвязи(ТаблДок, СтрокаЭтапа, Уровни, ПараметрыТД );
			
		КонецЦикла;
		
	КонецЦикла;
	
	ДлительностьНарастающая = 0;
	Для каждого СтруктураХ Из Уровни.Х Цикл
		
		СтрокиУровня = Этапы.НайтиСтроки(Новый Структура("УровеньХ", СтруктураХ.Ключ));
		
		Для каждого СтрокаЭтапа Из СтрокиУровня Цикл
			
			НарисоватьЭтап(ТаблДок, СтрокаЭтапа, Уровни, ПараметрыТД);
			ДлительностьНарастающая = Макс(ДлительностьНарастающая, СтрокаЭтапа.ДлительностьНарастающая)
		КонецЦикла;
		
	КонецЦикла;
	
	
	Макет = Справочники.ЗадачиПроектов.ПолучитьМакет("ПФ_MXL_СтруктураРабот");
	Макет.Параметры.ЗадачаПроекта          	= ЗадачаПроекта;
	Макет.Параметры.ДлительностьНарастающая = ДлительностьНарастающая;
	
	//ПолеТабличногоДокумента.Вывести(Макет.ПолучитьОбласть("Заголовок"));
	//ПолеТабличногоДокумента.АвтоМасштаб			= Истина;
	//ПолеТабличногоДокумента.ОриентацияСтраницы	= ОриентацияСтраницы.Ландшафт;
	//ПолеТабличногоДокумента.Вывести(ТабличныйДокумент);

	
	
	
	//
	ТаблДок.АвтоМасштаб			= Истина;
	ТаблДок.ОриентацияСтраницы	= ОриентацияСтраницы.Ландшафт;
	Возврат ТаблДок;
	
КонецФункции

Процедура НарисоватьЭтап(ТабличныйДокумент, СтрокаЭтапа, Уровни, ПараметрыТД)
	//
	Этап		= СтрокаЭтапа.Этап;
	
	Расшифровка = Этап;
	
	ШиринаИзгиба 	= ПараметрыТД.ШиринаИзгиба;
	ШиринаОтступа	= ПараметрыТД.ШиринаОтступа;
	ШиринаЭтапа		= ПараметрыТД.ШиринаЭтапа;
	ВысотаЭтапа		= ПараметрыТД.ВысотаЭтапа;
	ШиринаВехи		= ПараметрыТД.ШиринаВехи;
	
	ВерхЭтапа = Уровни.У[СтрокаЭтапа.УровеньУ].ВерхЭтапа;
	ЛевоЭтапа = Уровни.Х[СтрокаЭтапа.УровеньХ].ЛевоЭтапа;
	
	ВысотаСтрокиТекста 	= 4;
	
	Если (ТипЗнч( Этап ) = Тип("СправочникСсылка.ЗадачиПроектовСтруктура")) Тогда
		
		Текст1 = "" + СтрокаЭтапа.Код + ". " + СтрокаЭтапа.Этап ;
		Если Этап.Продолжительность <> 0 Тогда // веха
			Рисунок = ТабличныйДокумент.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Прямоугольник);
			Рисунок.Лево 	= ЛевоЭтапа;
			Рисунок.Верх 	= ВерхЭтапа;
			Рисунок.Ширина 	= ШиринаЭтапа;
			Рисунок.Высота 	= ВысотаЭтапа;
			Рисунок.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.Сплошная, 2);
		
			Текст2 = "Длит.:  " + Этап.Продолжительность + 	" раб.дн." + Символы.ПС +
					 "Резерв: " + Этап.Резерв 		  + 	" раб.дн.";
			Текст3 = "Р.старт: " + Формат( Этап.РаннийСтарт, "ДЛФ=D" ) + " Р.финиш: " + Формат( Этап.РаннийФиниш, "ДЛФ=D" ) + Символы.ПС+
					 "П.старт: " + Формат( Этап.ПозднийСтарт, "ДЛФ=D" )+ " П.финиш: " + Формат( Этап.ПозднийФиниш, "ДЛФ=D" );
					 
			Рисунок = НарисоватьТекст(ТабличныйДокумент, Текст1, Расшифровка, ЛевоЭтапа, ВерхЭтапа, 
										ШиринаЭтапа, ВысотаСтрокиТекста * 3, СтрокаЭтапа.КритическийПуть);
			
			Рисунок = НарисоватьТекст(ТабличныйДокумент, Текст2, Расшифровка, ЛевоЭтапа, ВерхЭтапа + ВысотаСтрокиТекста * 3, 
										ШиринаЭтапа, ВысотаСтрокиТекста * 2, СтрокаЭтапа.КритическийПуть);
			
			Рисунок = НарисоватьТекст(ТабличныйДокумент, Текст3, Расшифровка, ЛевоЭтапа, ВерхЭтапа + ВысотаСтрокиТекста * 5, 
							ШиринаЭтапа, ВысотаЭтапа - ВысотаСтрокиТекста * 5, СтрокаЭтапа.КритическийПуть);
							
			Рисунок.РазмещениеТекста 	= ТипРазмещенияТекстаТабличногоДокумента.Обрезать;
				 
					 
		Иначе
			Рисунок = НарисоватьКартинку(ТабличныйДокумент, "Веха", Расшифровка, ЛевоЭтапа, ВерхЭтапа, ШиринаЭтапа, ВысотаСтрокиТекста * 5 );
			Если 		СтрокаЭтапа.ФиксированныйСтарт Тогда
				Текст1 = Текст1 + " " + Формат( СтрокаЭтапа.РаннийСтарт,  "ДЛФ=D");
			ИначеЕсли 	СтрокаЭтапа.ФиксированныйФиниш Тогда
				Текст1 = Текст1 + " " + Формат( СтрокаЭтапа.ПозднийФиниш,  "ДЛФ=D");
			КонецЕсли;
			Рисунок = НарисоватьТекст(ТабличныйДокумент, 	Текст1, Расшифровка, ЛевоЭтапа, ВерхЭтапа + ВысотаСтрокиТекста * 5, 
							ШиринаЭтапа, ВысотаСтрокиТекста * 2, СтрокаЭтапа.КритическийПуть);
							
			Рисунок.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
			
		КонецЕсли;
		
	Иначе
	// старт или финиш
		Текст 	= СтрокаЭтапа.Этап;
		
		Рисунок = НарисоватьКартинку(ТабличныйДокумент, Текст, Расшифровка, ЛевоЭтапа, ВерхЭтапа, ШиринаЭтапа, ВысотаСтрокиТекста * 8 );
		// 
		//Если 		СтрокаЭтапа.ФиксированныйСтарт Тогда
		Если Этап = "Старт" Тогда
			Текст = Текст + " " + Формат( СтрокаЭтапа.РаннийСтарт,  "ДЛФ=D");
			
		//ИначеЕсли 	СтрокаЭтапа.ФиксированныйФиниш Тогда
		Иначе
			Текст = Текст + " " + Формат( СтрокаЭтапа.ПозднийФиниш,  "ДЛФ=D");
		КонецЕсли;
		Рисунок = НарисоватьТекст(ТабличныйДокумент, 	Текст, Расшифровка, ЛевоЭтапа, ВерхЭтапа + ВысотаСтрокиТекста * 8, 
						ШиринаЭтапа, ВысотаСтрокиТекста * 2);
						
		Рисунок.Шрифт = Новый Шрифт(Рисунок.Шрифт,"Arial Narrow",10,Истина);
		Рисунок.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура НарисоватьЛинию(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, ШиринаЛинии, ВысотаЛинии);
	
	Линия = ТабличныйДокумент.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Прямая);
	Линия.Лево   = ЛевоЛинии;
	Линия.Верх   = ВерхЛинии;
	Линия.Ширина = ШиринаЛинии;
	Линия.Высота = ВысотаЛинии;
	
	Линия.Расшифровка = Расшифровка;
	Линия.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.Сплошная, 2);
	
	ЛевоЛинии = ЛевоЛинии + ШиринаЛинии;
	ВерхЛинии = ВерхЛинии + ВысотаЛинии;
	
КонецПроцедуры

Процедура НарисоватьСвязи( ТабличныйДокумент, СтрокаЭтапа, Уровни, ПараметрыТД)
	ШиринаИзгиба 	= ПараметрыТД.ШиринаИзгиба;
	ШиринаОтступа	= ПараметрыТД.ШиринаОтступа;
	ШиринаЭтапа		= ПараметрыТД.ШиринаЭтапа;
	ВысотаЭтапа		= ПараметрыТД.ВысотаЭтапа;
	ВысотаОтступа	= ПараметрыТД.ВысотаОтступа;
	
	ВерхЭтапа = Уровни.У[СтрокаЭтапа.УровеньУ].ВерхЭтапа;
	
	ЛевоЭтапа = Уровни.Х[СтрокаЭтапа.УровеньХ].ЛевоЭтапа;
	
	Для каждого СтрокаПредшественника Из СтрокаЭтапа.ЭтапыПредшественники Цикл
		
		СтрокаЭтапаПредшественника = СтрокаПредшественника.СтрокаЭтапа;
		
		ВерхПредшественника = Уровни.У[СтрокаЭтапаПредшественника.УровеньУ].ВерхЭтапа;
		ЛевоПредшественника = Уровни.Х[СтрокаЭтапаПредшественника.УровеньХ].ЛевоЭтапа;
		
		Расшифровка = Новый Структура("Этап, ЭтапПредшественник", СтрокаЭтапа.Этап, СтрокаПредшественника.ЭтапПроцесса);
		Флаг = ?(СтрокаЭтапаПредшественника.УровеньУ > СтрокаЭтапа.УровеньУ, -1, 1);
		Если СтрокаЭтапаПредшественника.УровеньХ + 1 = СтрокаЭтапа.УровеньХ Тогда
			ЛевоЛинии   = ЛевоПредшественника + ШиринаЭтапа;
			ВерхЛинии   = ВерхПредшественника + ВысотаЭтапа / 4;
			
			НарисоватьЛинию(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, 
					ЛевоЭтапа - ЛевоЛинии - СтрокаПредшественника.ОтступХ * ШиринаОтступа - ШиринаИзгиба, 0);
					
			Если СтрокаЭтапаПредшественника.УровеньУ = СтрокаЭтапа.УровеньУ Тогда
				НарисоватьИзгиб(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, ШиринаИзгиба, ШиринаИзгиба);
				НарисоватьЛинию(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, 0, ВысотаЭтапа / 2 - ШиринаИзгиба * 2);
				НарисоватьИзгиб(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, ШиринаИзгиба, ШиринаИзгиба);
			Иначе
				НарисоватьИзгиб(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, ШиринаИзгиба, Флаг * ШиринаИзгиба);
				НарисоватьЛинию(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, 0, ВерхЭтапа + ВысотаЭтапа / 4 * 3 - ВерхЛинии - Флаг * ШиринаИзгиба);
				НарисоватьИзгиб(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, ШиринаИзгиба, Флаг * ШиринаИзгиба);
			КонецЕсли;
			
			НарисоватьЛинию(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, ЛевоЭтапа - ЛевоЛинии, 0);
			НарисоватьСтрелку(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии);
			
		Иначе
			
			ЛевоЛинии   = ЛевоПредшественника + ШиринаЭтапа / 4 * 3;
			ВерхЛинии   = ВерхПредшественника + ВысотаЭтапа;
			
			НарисоватьЛинию(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, 0, ВысотаОтступа* СтрокаПредшественника.ОтступУ - ШиринаИзгиба);
			НарисоватьИзгиб(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, ШиринаИзгиба, ШиринаИзгиба);
			
			НарисоватьЛинию(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, 
							ЛевоЭтапа - ЛевоЛинии - СтрокаПредшественника.ОтступХ*ШиринаОтступа - ШиринаИзгиба, 0);
			
			Если СтрокаЭтапаПредшественника.УровеньУ = СтрокаЭтапа.УровеньУ Тогда
				НарисоватьИзгиб(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, ШиринаИзгиба, - ШиринаИзгиба);
				НарисоватьЛинию(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, 0, ВерхЭтапа + ВысотаЭтапа / 4 * 3 - ВерхЛинии + ШиринаИзгиба);
				НарисоватьИзгиб(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, ШиринаИзгиба, - ШиринаИзгиба);
			Иначе
				НарисоватьИзгиб(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, ШиринаИзгиба, Флаг * ШиринаИзгиба);
				НарисоватьЛинию(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, 0, ВерхЭтапа + ВысотаЭтапа / 4 * 3 - ВерхЛинии - Флаг * ШиринаИзгиба);
				НарисоватьИзгиб(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, ШиринаИзгиба, Флаг * ШиринаИзгиба);
			КонецЕсли;
			
			НарисоватьЛинию(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, ЛевоЭтапа - ЛевоЛинии, 0);
			НарисоватьСтрелку(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии);
			
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура НарисоватьИзгиб(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии, ШиринаЛинии, ВысотаЛинии);
	
	Отступ = 0.1;
	СдвигЛево = ?(ШиринаЛинии > 0, Отступ, -Отступ);
	СдвигВерх = ?(ВысотаЛинии > 0, Отступ, -Отступ);
	
	Линия = ТабличныйДокумент.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Прямая);
	Линия.Лево   = ЛевоЛинии + СдвигЛево;
	Линия.Верх   = ВерхЛинии + СдвигВерх;
	Линия.Ширина = ШиринаЛинии - СдвигЛево * 2;
	Линия.Высота = ВысотаЛинии - СдвигВерх * 2;
	
	Линия.Расшифровка = Расшифровка;
	Линия.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.Сплошная, 2);
	
	ЛевоЛинии = ЛевоЛинии + ШиринаЛинии;
	ВерхЛинии = ВерхЛинии + ВысотаЛинии;
	
КонецПроцедуры

Функция НарисоватьКартинку(ТабличныйДокумент, Текст, Расшифровка, Лево, Верх, Ширина, Высота)
	//ТабличныйДокумент = Новый ТабличныйДокумент;
	Рисунок 		= ТабличныйДокумент.Рисунки.Добавить( ТипРисункаТабличногоДокумента.Картинка );
	Рисунок.Лево   	= Лево;
	Рисунок.Верх   	= Верх;
	Рисунок.Ширина 	= Ширина;
	Рисунок.Высота 	= Высота;
	Рисунок.ГраницаСлева 	= Ложь;
	Рисунок.ГраницаСверху 	= Ложь;
	Рисунок.ГраницаСнизу	= Ложь;
	Рисунок.ГраницаСправа	= Ложь;
	Рисунок.Картинка		= БиблиотекаКартинок[Текст];//.Старт;
	Рисунок.РазмерКартинки  = РазмерКартинки.Пропорционально;
	
	
	
	Возврат Рисунок;
	
КонецФункции // ()

Процедура НарисоватьСтрелку(ТабличныйДокумент, Расшифровка, ЛевоЛинии, ВерхЛинии)
	
	Линия = ТабличныйДокумент.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Прямая);
	Линия.Лево   = ЛевоЛинии - 2;
	Линия.Верх   = ВерхЛинии - 1.5;
	Линия.Ширина = 1.5;
	Линия.Высота = 1.5;
	
	Линия.Расшифровка = Расшифровка;
	Линия.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.Сплошная, 2);
	
	Линия = ТабличныйДокумент.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Прямая);
	Линия.Лево   = ЛевоЛинии - 2;
	Линия.Верх   = ВерхЛинии + 1.5;
	Линия.Ширина = 1.5;
	Линия.Высота = -1.5;
	
	Линия.Расшифровка = Расшифровка;
	Линия.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.Сплошная, 2);
	
КонецПроцедуры

Функция НарисоватьТекст(ТабличныйДокумент, Текст, Расшифровка, Лево, Верх, Ширина, Высота, КритическийПуть = Ложь)

	Рисунок = ТабличныйДокумент.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Текст);
	Рисунок.Лево   = Лево;
	Рисунок.Верх   = Верх;
	Рисунок.Ширина = Ширина;
	Рисунок.Высота = Высота;
	
	Рисунок.Расшифровка 	= Расшифровка;
	Рисунок.Текст 			= Текст;
	// +++
	Рисунок.Шрифт 			= Новый Шрифт(Рисунок.Шрифт,"Arial Narrow",,Истина);
	Рисунок.ЦветФона 		= ?(КритическийПуть, ЦветаСтиля.ЦветФонаШапкиОтчета, ЦветаСтиля.ЦветФонаПоля );
	
	Возврат Рисунок;
	
КонецФункции // ()

Функция МаксимальныйУровеньПредшественников( СтрЭтап, ЭтапыПредшественники )
	Если ЭтапыПредшественники.Количество() = 0 Тогда
		Возврат 0;
	Иначе
		МаксУровеньЭтапа = 0;
		Для Каждого с ИЗ ЭтапыПредшественники Цикл
			СтрЭтапаПредшественника = с.СтрокаЭтапа;
			попытка
 				МаксУровеньЭтапа = Макс( МаксУровеньЭтапа, 
						МаксимальныйУровеньПредшественников( 
						СтрЭтапаПредшественника, 
						СтрЭтапаПредшественника.ЭтапыПредшественники )
										);
						
			Исключение
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = ОписаниеОшибки();
				Сообщение.Сообщить();
				
			КонецПопытки;
		КонецЦикла;
		Возврат МаксУровеньЭтапа + 1;
	КонецЕсли;
КонецФункции

Процедура СтрокиЭтаповСхемы( тзЭтапы) 
	тзУХ = тзЭтапы.Скопировать(,"УровеньХ");
	тзУХ.Колонки.Добавить("Количество");
	тзУХ.ЗаполнитьЗначения(1, "Количество");
	тзУХ.Свернуть("УровеньХ", "Количество");
	
	Для Каждого стУровеньХ ИЗ тзУХ Цикл
		мЭтапыХ 	= тзЭтапы.НайтиСтроки( Новый Структура("УровеньХ", стУровеньХ.УровеньХ ));
		УровеньУ	= 0;
		Для Каждого Эл ИЗ мЭтапыХ  Цикл
			Эл.УровеньУ = УровеньУ;
			УровеньУ	= УровеньУ + 1;
		КонецЦикла;
		
	КонецЦикла;
КонецПроцедуры

Функция ОпределитьНовуюПозициюВУровнеY(СтрокаЭтапа, ЗанятыеУровниПоУ, Предпочтение = Неопределено)
	
	Если Не Предпочтение = Неопределено и ЗанятыеУровниПоУ[Предпочтение] = Неопределено Тогда
		Результат = Предпочтение;
	Иначе
		Результат = 0;
		
		Пока Не ЗанятыеУровниПоУ[Результат] = Неопределено Цикл
			Результат = Результат + 1;
		КонецЦикла;
		
	КонецЕсли;
	ЗанятыеУровниПоУ.Вставить(Результат, Истина);
	Возврат Результат;
	
КонецФункции

Функция РасчитатьУровниЭтапов( Этапы );
	Этапы.Колонки.Добавить("УровеньУ"); 					// строка
	Этапы.Колонки.Добавить("УровеньХ"); 					// колонка
	
	// расчитываем колонки схемы
	Для Каждого СтрЭтап ИЗ Этапы Цикл
		СтрЭтап.УровеньХ = МаксимальныйУровеньПредшественников( СтрЭтап, СтрЭтап.ЭтапыПредшественники ) ;
	КонецЦикла;
	// расчитываем строки схемы
	СтрокиЭтаповСхемы( Этапы );
	
	
	// из консолидации
	Уровни = Новый Структура("Х, У", Новый Соответствие, Новый Соответствие);
	
	УровеньХ = 0;
	СтрокиУровня = Этапы.НайтиСтроки(Новый Структура("УровеньХ", УровеньХ));
	Пока СтрокиУровня.Количество() Цикл
		СтруктураХ = Новый Структура("ОтступХ, ЗанятыеУровниПоУ", 0, Новый Соответствие);
		Уровни.Х.Вставить(УровеньХ, СтруктураХ);
		УровеньУ = -1;
		Для каждого СтрокаЭтапа Из СтрокиУровня Цикл
			
			Если СтрокаЭтапа.ЭтапыПредшественники.Количество() = 0 Тогда
				СтрокаЭтапа.ДлительностьНарастающая = СтрокаЭтапа.Продолжительность;
				УровеньУ = УровеньУ + 1;
			Иначе
				
				Если СтрокаЭтапа.ЭтапыПредшественники.Количество() = 1 Тогда
					Предпочтение = СтрокаЭтапа.ЭтапыПредшественники[0].СтрокаЭтапа.УровеньУ;
				Иначе
					Предпочтение = Неопределено;
				КонецЕсли;
				
				УровеньУ = ОпределитьНовуюПозициюВУровнеY(СтрокаЭтапа, СтруктураХ.ЗанятыеУровниПоУ, Предпочтение);
				
				Для каждого СтрокаПредшественника Из СтрокаЭтапа.ЭтапыПредшественники Цикл
					
					СтрокаЭтапа.ДлительностьНарастающая = Макс(СтрокаЭтапа.ДлительностьНарастающая, 
														СтрокаПредшественника.СтрокаЭтапа.ДлительностьНарастающая + 
														СтрокаЭтапа.Продолжительность);
					
					СтруктураХ.ОтступХ = СтруктураХ.ОтступХ + 1;
					
					Если Не СтрокаЭтапа.УровеньХ = СтрокаПредшественника.СтрокаЭтапа.УровеньХ + 1 Тогда
						СтруктураУ = Уровни.У[СтрокаПредшественника.СтрокаЭтапа.УровеньУ];
						СтруктураУ.ОтступУ = СтруктураУ.ОтступУ + 1;
						СтрокаПредшественника.ОтступУ = СтруктураУ.ОтступУ;
					КонецЕсли;
					
					СтрокаПредшественника.ОтступХ = СтруктураХ.ОтступХ;
					
				КонецЦикла;
				
			КонецЕсли;
			
			СтруктураУ = Уровни.У[УровеньУ];
			Если СтруктураУ = Неопределено Тогда
				СтруктураУ = Новый Структура("ОтступУ", 0);
				Уровни.У.Вставить(УровеньУ, СтруктураУ);
			КонецЕсли;
			
			СтрокаЭтапа.УровеньУ = УровеньУ;
			
		КонецЦикла;
		
		УровеньХ = УровеньХ + 1;
		СтрокиУровня = Этапы.НайтиСтроки(Новый Структура("УровеньХ", УровеньХ));
	КонецЦикла;
	Возврат Уровни;
КонецФункции 

Функция ПолучитьСтрокуЭтапа( Этап, Этапы)
	СтрЭтап = Этапы.Найти( Этап, "Этап");
	Если СтрЭтап = Неопределено Тогда
		СтрЭтап 					= Этапы.Добавить();
		СтрЭтап.Этап				= Этап;
		Если ТипЗнч( Этап ) = Тип("СправочникСсылка.ЗадачиПроектовСтруктура") Тогда
			ЗаполнитьЗначенияСвойств( СтрЭтап, Этап );
		Иначе
			СтрЭтап.Продолжительность 	= 0;
			
		КонецЕсли;
		СтрЭтап.ЭтапыПредшественники	= СтруктураТаблицыЭтаповПредшественников();
		СтрЭтап.ЭтапыПоследователи 		= СтруктураТаблицыЭтаповПредшественников();
	КонецЕсли;
	Возврат СтрЭтап;
КонецФункции

Процедура ЗаполнитьТаблицуЭтапов( тзЭтапы, тзСвязи )
	Для Каждого сСвязь ИЗ тзСвязи Цикл
		
		ТипСвязи = сСвязь.ТипСвязи;
		//Если ТипСвязи = Перечисления.ТипыСвязиРабот.НачалоКонец Тогда
		Если ТипСвязи = Перечисления.ТипыСвязиРабот.КонецНачало Тогда
			СтрЭтап 			= ПолучитьСтрокуЭтапа( сСвязь.Этап, тзЭтапы );
			ЭтапПредшественник 	= сСвязь.ВедущаяРабота;
			Если ЗначениеЗаполнено( ЭтапПредшественник ) Тогда
				СтрПр 								= СтрЭтап.ЭтапыПредшественники.Добавить();
				СтрПр.ЭтапПроцесса 					= ЭтапПредшественник;
				// строка этапа предшественника
				СтрокаЭтапаПредшественника			= ПолучитьСтрокуЭтапа( ЭтапПредшественник, тзЭтапы );
				СтрПос = СтрокаЭтапаПредшественника.ЭтапыПоследователи.Добавить();
				СтрПос.ЭтапПроцесса 				= СтрЭтап.Этап;
				СтрПос.СтрокаЭтапа 					= СтрЭтап;
				СтрокаЭтапаПредшественника.КоличествоПоследователей = 
								СтрокаЭтапаПредшественника.ЭтапыПоследователи.Количество();
				
				СтрПр.СтрокаЭтапа					= СтрокаЭтапаПредшественника;
				СтрЭтап.КоличествоПредшественников 	= СтрЭтап.ЭтапыПредшественники.Количество();
				
			КонецЕсли;
			
		Иначе
			// пока не заморачиваемся
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	
	// добавляем старт и финиш
	ДобавитьКрайнийЭтап( тзЭтапы );
	ДобавитьКрайнийЭтап( тзЭтапы, Ложь );
	
КонецПроцедуры

Функция ПараметрыТабличногоДокумента()
	с = Новый Структура;
	с.Вставить("ВысотаОтступа", 8);
	с.Вставить("ВысотаЭтапа", 	20);
	с.Вставить("ШиринаВехи", 	35);
	с.Вставить("ШиринаИзгиба", 1.2);
	с.Вставить("ШиринаОтступа", 8);
	с.Вставить("ШиринаЭтапа",	35);
	Возврат с;
КонецФункции

Функция СтруктураТаблицыРабот()
	тз = Новый ТаблицаЗначений;
	тз.Колонки.Добавить("Этап");                        // не суммарная работа
	тз.Колонки.Добавить("Код");                        
	тз.Колонки.Добавить("ЭтапыПредшественники"); 		// таблица значений
	тз.Колонки.Добавить("ЭтапыПоследователи"); 			// таблица значений
	тз.Колонки.Добавить("ДлительностьНарастающая",		Новый ОписаниеТипов("Число"));
	тз.Колонки.Добавить("Продолжительность",			Новый ОписаниеТипов("Число"));
	тз.Колонки.Добавить("Резерв",						Новый ОписаниеТипов("Число"));
	тз.Колонки.Добавить("КоличествоПредшественников", 	Новый ОписаниеТипов("Число"));
	тз.Колонки.Добавить("КоличествоПоследователей", 	Новый ОписаниеТипов("Число"));
	//
	тз.Колонки.Добавить("КритическийПуть", 				Новый ОписаниеТипов("Булево")); 					// 
	//
	тз.Колонки.Добавить("РаннийСтарт", 			Новый ОписаниеТипов("Дата")); // для старта, финиша и вех
	тз.Колонки.Добавить("РаннийФиниш", 			Новый ОписаниеТипов("Дата")); // для старта, финиша и вех
	тз.Колонки.Добавить("ПозднийСтарт", 		Новый ОписаниеТипов("Дата")); // для старта, финиша и вех
	тз.Колонки.Добавить("ПозднийФиниш", 		Новый ОписаниеТипов("Дата")); // для старта, финиша и вех
	// 
	тз.Колонки.Добавить("ФиксированныйСтарт", Новый ОписаниеТипов("Булево"));
	тз.Колонки.Добавить("ФиксированныйФиниш", Новый ОписаниеТипов("Булево"));
	Возврат тз;
КонецФункции

Функция СтруктураТаблицыЭтаповПредшественников()
	тз = Новый ТаблицаЗначений;
	тз.Колонки.Добавить("ОтступУ");
	тз.Колонки.Добавить("ОтступХ");
	тз.Колонки.Добавить("СтрокаЭтапа");
	тз.Колонки.Добавить("ЭтапПроцесса");
	
	Возврат тз;
	
КонецФункции

Процедура ДобавитьКрайнийЭтап(  тзЭтапы, ЭтоСтарт = Истина )
	Если ЭтоСтарт Тогда
		КрайнийЭтап = "Старт";
		КонтрольноеЧисло  	= "КоличествоПредшественников";
		ТаблицаДобавлений   = "ЭтапыПоследователи";
		ИзмКонтрольноеЧисло = "КоличествоПоследователей";
		ИзмТаблица   		= "ЭтапыПредшественники";
	Иначе
		КрайнийЭтап 		= "Финиш";
		КонтрольноеЧисло  	= "КоличествоПоследователей";
		ТаблицаДобавлений   = "ЭтапыПредшественники";
		ИзмКонтрольноеЧисло = "КоличествоПредшественников";
		ИзмТаблица   		= "ЭтапыПоследователи";
	КонецЕсли;
	
	СтрКрЭтапа = ПолучитьСтрокуЭтапа( КрайнийЭтап, тзЭтапы );
	
	Для Каждого СтрЭтапа ИЗ тзЭтапы Цикл
		Если СтрЭтапа.Этап = КрайнийЭтап ИЛИ СтрЭтапа[КонтрольноеЧисло] <> 0 Тогда
			Продолжить;
		КонецЕсли;
		ЭтапД 								= СтрКрЭтапа[ТаблицаДобавлений].Добавить();
		ЭтапД.СтрокаЭтапа 					= СтрЭтапа;
		ЭтапД.ЭтапПроцесса 					= СтрЭтапа.Этап;
		СтрКрЭтапа[ИзмКонтрольноеЧисло]		= СтрКрЭтапа[ТаблицаДобавлений].Количество();
		
		// изменяем в найденой строке
		ЭтапД1 = СтрЭтапа[ИзмТаблица].Добавить();
		ЭтапД1.СтрокаЭтапа 			= СтрКрЭтапа;
		ЭтапД1.ЭтапПроцесса 		= КрайнийЭтап;
		СтрЭтапа[КонтрольноеЧисло]	= 1;
		
	КонецЦикла;
КонецПроцедуры
	
#КонецОбласти

&НаСервере
Функция ПроверкаСтатусаЗадач(Объект) Экспорт
	Сообщить("Проверка:" + Объект.Владелец + "-" + Объект.Ссылка);
	Результат = Перечисления.СтатусыЗадачПроектов.Корректный;
	
	//Отчет корректности данных [#129889]  
	ГодЗадачи = Объект.ГодЗадачи;
	ГодНачала = ?(Формат(Объект.НачалоРабот,"ДФ=гггг")="",0,Число(Формат(Объект.НачалоРабот,"ДФ=гггг")));
	ГодОкончания = ?(Формат(Объект.ОкончаниеРабот,"ДФ=гггг")="",0,Число(Формат(Объект.ОкончаниеРабот,"ДФ=гггг")));
		
	Если НЕ ГодЗадачи = ГодНачала Тогда 
		Сообщить("Год начала работ не соотвествует году задачи");
		Результат = Перечисления.СтатусыЗадачПроектов.Ошибки;
	КонецЕсли;
	Если НЕ  ГодЗадачи = ГодОкончания Тогда
		Сообщить("Год окончания работ не соотвествует году задачи");
		Результат = Перечисления.СтатусыЗадачПроектов.Ошибки;
	КонецЕсли;

	План = Объект.ЭтапыГрафикаРеализации.Итог("СуммаПлан");
	Если План <> Объект.Сумма Тогда 
		Сообщить("Сумма задачи не распределена в графике реализации.");
		Результат = Перечисления.СтатусыЗадачПроектов.Ошибки;
	КонецЕсли;
	
	План = СуммаПоСметеЗадачиПроекта(Объект.Ссылка, Справочники.СтатьиСметы.ДохФинансовые);
	Если План <> 0 И План <> Объект.Сумма Тогда 
		Сообщить("Сумма задачи не равна смете.");  
		Результат = Перечисления.СтатусыЗадачПроектов.Ошибки;
	КонецЕсли;	
	
	Отбор = Новый Структура();
	Отбор.Вставить("ВидПлана", Перечисления.ВидыПланаБюджета.Гарантия);
	Отбор.Вставить("ВидПлана", Перечисления.ВидыПланаБюджета.Прогноз);
	этапы = Объект.ЭтапыГрафикаРеализации.НайтиСтроки(Отбор);
	Для Каждого этап из этапы Цикл 
		Если этап.ДатаРеализации < НачалоМесяца(ТекущаяДата()) Тогда 
			Сообщить("Дата " + этап.ДатаРеализации + " графика реализации (" + этап.ВидПлана + ") меньше текущей даты.");  
		КонецЕсли;
	КонецЦикла;		

	ГрафикРеализации = ГрафикРеализацииЗадачиДоговорам( Объект.Ссылка );
	ГрафикРеализации.Свернуть("ВидПлана","СуммаПлан");
	
	Для Каждого график Из ГрафикРеализации Цикл
		Отбор = Новый Структура();
		Отбор.Вставить("ВидПлана", график.ВидПлана);
		этапы = Объект.ЭтапыГрафикаРеализации.НайтиСтроки(Отбор);
		
		сумма = 0;
		Для Каждого этап из этапы Цикл 
			сумма = сумма + этап.СуммаПлан;
		КонецЦикла;		
		
		//Добавлены условия по задаче #131869 13.07.2018 Гумедин А.Г.
		
		МодульСуммы = ?(сумма-график.СуммаПлан > 0, сумма-график.СуммаПлан, -(сумма-график.СуммаПлан));
		
		Если МодульСуммы >= 1 Тогда 
			Сообщить("Сумма по графику реализации задачи (" + график.ВидПлана + ") не соответствует графику реализации обеспечения.");  
			Результат = Перечисления.СтатусыЗадачПроектов.Ошибки;
		КонецЕсли;
		
		сумма = УП_СметаПроекта.ПолучитьОборотБюджетаПоСтатье(Справочники.СтатьиСметы.ДохФинансовые, 
			Объект.Владелец.Ссылка, Объект.Ссылка, Перечисления.ТипСуммыБюджета.План, график.ВидПлана);
			
		МодульСуммы = ?(сумма-график.СуммаПлан > 0, сумма-график.СуммаПлан, -(сумма-график.СуммаПлан));	
			
		Если МодульСуммы >= 1 Тогда 
			Сообщить("Сумма по графику реализации задачи (" + график.ВидПлана + ") не соответствует бюджету (смете).");  
			Результат = Перечисления.СтатусыЗадачПроектов.Ошибки;
		КонецЕсли;
		//////////////////////////////////////////////////////////
	КонецЦикла;	
	
	//Добавлено по задаче #132237 25.07.2018 Гумедин А.Г.
	ЕстьОшибки = Ложь;
	ЕстьОшибки = ПроверкаКонтрольныхСуммФакта(Объект);
	Если ЕстьОшибки Тогда  
		Результат = Перечисления.СтатусыЗадачПроектов.Ошибки;
	КонецЕсли;	
	/////////////////////////////////////////////////////
	
	Возврат Результат;
КонецФункции

//Добавлено по задаче #132237 25.07.2018 Гумедин А.Г.
//Функция проверки контрольных сумм по факту
&НаСервере
Функция ПроверкаКонтрольныхСуммФакта(Объект)
	
	СуммыПоСтатьям = Новый СписокЗначений;	
	Результат = Ложь;

	//Получим все суммы
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	БюджетПоМесяцам.СтатьяСметы.Код КАК СтатьяСметы,
		|	СУММА(БюджетПоМесяцам.Сумма) КАК Сумма
		|ИЗ
		|	РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
		|ГДЕ
		|	БюджетПоМесяцам.ТипСуммы.Порядок = 2
		|	И БюджетПоМесяцам.ЗадачаПроекта = &ЗадачаПроекта
		|
		|СГРУППИРОВАТЬ ПО
		|	БюджетПоМесяцам.СтатьяСметы.Код,
		|	БюджетПоМесяцам.ЗадачаПроекта
		|
		|УПОРЯДОЧИТЬ ПО
		|	БюджетПоМесяцам.ЗадачаПроекта";
	
	Запрос.УстановитьПараметр("ЗадачаПроекта", Объект.Ссылка);	
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	 
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 	 	
		СуммыПоСтатьям.Добавить(ВыборкаДетальныеЗаписи.СтатьяСметы, Число(ВыборкаДетальныеЗаписи.Сумма)); 	
	КонецЦикла;
	
	Ст1 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000006")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000006").Представление));
	Ст1_1 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000007")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000007").Представление));
	Ст1_2 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000002")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000002").Представление));
	Ст1_3 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000010")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000010").Представление));
	Ст2 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000008")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000008").Представление));
	Ст2_1 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000009")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000009").Представление));
	Ст2_2 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000005")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000005").Представление));
	Ст3 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000021")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000021").Представление));
	Ст4 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000016")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000016").Представление));
	Ст5 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000011")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000011").Представление));
	Ст5_1 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000003")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000003").Представление));
	Ст5_2 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000013")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000013").Представление));
	Ст6 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000017")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000017").Представление));
	Ст6_1 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000020")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000020").Представление));
	Ст6_2 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000035")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000035").Представление));
	Ст6_3 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000015")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000015").Представление));
	Ст6_4 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000012")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000012").Представление));
	Ст6_5 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000034")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000034").Представление));
	Ст7 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000023")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000023").Представление));
	Ст9 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000028")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000028").Представление));
	Ст9_1 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000025")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000025").Представление));
	Ст9_2 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000029")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000029").Представление));
	Ст10 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000030")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000030").Представление));
	Ст10_1 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000031")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000031").Представление));
	Ст10_2 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000032")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000032").Представление));
	Ст11 = ?(СуммыПоСтатьям.НайтиПоЗначению("000000001")=Неопределено,0,Число(СуммыПоСтатьям.НайтиПоЗначению("000000001").Представление));
	
	///////	Доходы финансовые
	Если НЕ Ст1 = (Ст1_1+Ст1_2+Ст1_3) Тогда
			Сообщить("Контрольная сумма по статье  'Доходы финансовые' задачи '" + Объект.Наименование + "' не прошла проверку.");
			Результат = Истина;
	КонецЕсли;
	///////	Доходы вычитаемые
	Если НЕ Ст2 = (Ст2_1+Ст2_2) Тогда
			Сообщить("Контрольная сумма по статье  'Доходы вычитаемые' задачи '" + Объект.Наименование + "' не прошла проверку.");
			Результат = Истина;
	КонецЕсли;
	/////// ЧИСТЫЙ ДОХОД
	Если НЕ Ст3 = (Ст1-Ст2) Тогда
			Сообщить("Контрольная сумма по статье  'ЧИСТЫЙ ДОХОД' задачи '" + Объект.Наименование + "' не прошла проверку.");
			Результат = Истина;
	КонецЕсли;
	/////// Коммерческие расходы по проекту
	Если НЕ Ст5 = (Ст5_1+Ст5_2) Тогда
		Сообщить("Контрольная сумма по статье  'Коммерческие расходы по проекту' задачи '" + Объект.Наименование + "' не прошла проверку.");
		Результат = Истина;
	КонецЕсли;
	/////// Прямые производственные расходы
	Если НЕ Ст6 = (Ст6_1+Ст6_2+Ст6_3+Ст6_4+Ст6_5) Тогда
		Сообщить("Контрольная сумма по статье  'Прямые производственные расходы' задачи '" + Объект.Наименование + "' не прошла проверку.");
		Результат = Истина;
	КонецЕсли;
	///////	ДОХОД ОТ РЕАЛИЗАЦИИ
	Если НЕ Ст7 = (Ст3-Ст4-Ст5-Ст6) Тогда
		Сообщить("Контрольная сумма по статье  'ДОХОД ОТ РЕАЛИЗАЦИИ' задачи '" + Объект.Наименование + "' не прошла проверку.");
		Результат = Истина;
	КонецЕсли;
	/////// Фонд директора проекта
	Если НЕ Ст9 = (Ст9_1+Ст9_2) Тогда
		Сообщить("Контрольная сумма по статье  'Фонд директора проекта' задачи '" + Объект.Наименование + "' не прошла проверку.");
		Результат = Истина;
	КонецЕсли;
	/////// Фонд клиент менеджера
	Если НЕ Ст10 = (Ст10_1+Ст10_2) Тогда
		Сообщить("Контрольная сумма по статье  'Фонд клиент менеджера' задачи '" + Объект.Наименование + "' не прошла проверку.");
		Результат = Истина;
	КонецЕсли;
	/////// ВАЛОВЫЙ ДОХОД
	Если НЕ Ст11 = (Ст7-Ст9-Ст10) Тогда
		Сообщить("Контрольная сумма по статье  'ВАЛОВЫЙ ДОХОД' задачи '" + Объект.Наименование + "' не прошла проверку.");
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;	
	
КонецФункции
