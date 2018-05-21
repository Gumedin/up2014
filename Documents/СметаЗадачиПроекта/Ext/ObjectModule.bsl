﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ЗадачиПроектов") Тогда
		// Заполнение шапки
		ЗадачаПроекта = ДанныеЗаполнения.Ссылка;
	КонецЕсли;
	ИсполнительДокумента = ПараметрыСеанса.ТекущийПользователь;
КонецПроцедуры

// 
Функция РаспределитьРавномерноПоПериодуЗадачи( Статья, Сумма )
	мМесяцыЗадачи = УП_ПланыРаботПоПроектам.МесяцыЗадачиПроекта( ЗадачаПроекта );
	тзПоМесяцам = Новый ТаблицаЗначений;
	тзПоМесяцам.Колонки.Добавить("Месяц");
	тзПоМесяцам.Колонки.Добавить("Сумма");
	// 
	Для Н = 1 По мМесяцыЗадачи.Количество() Цикл
		СтрТЗ = тзПоМесяцам.Добавить();
		СтрТЗ.Месяц = мМесяцыЗадачи[Н-1];
		СтрТЗ.Сумма = 1;
	КонецЦикла;
	
	РаспределитьПоМесяцам( Статья, Сумма, СтрТЗ, тзПоМесяцам);
КонецФункции
	
// распределяем пропорционально фронтам работ по месяцам
// тзПоМесяцам - две колонки: Сумма и Месяц
Процедура РаспределитьПоМесяцам( Статья, Сумма, тзПоМесяцам, тзПоВидам)
	//тзПоВидам ==>
	//тзПоВидам.Колонки.Добавить("Месяц");
	//тзПоВидам.Колонки.Добавить("ВидПлана");
	//тзПоВидам.Колонки.Добавить("Доля");

	ТипСуммы = Перечисления.ТипСуммыБюджета.План;
	
	Если тзПоМесяцам = Неопределено ИЛИ тзПоМесяцам.Количество() = 0 Тогда
		ВызватьИсключение "План распределения по месяцам не задан. [Статья:" + Статья + "]";
	КонецЕсли;
	
	Если тзПоВидам = Неопределено ИЛИ тзПоВидам.Количество() = 0 Тогда
		ВызватьИсключение "План распределения по типам плана не задан. [Статья:" + Статья + "]";
	КонецЕсли;                                             

	// коэффициенты 
	мКоэфф = Новый Массив;
	Для Каждого Стр ИЗ тзПоМесяцам Цикл
		//мКоэфф.Добавить( Стр.Сумма );
		мКоэфф.Добавить( Стр["Сумма"] );
	КонецЦикла;
	                                                
	мРезПоСтатье = РаспределитьПропорционально( Сумма, мКоэфф);
	Если мРезПоСтатье = Неопределено Тогда
		ВызватьИсключение "Коэфициенты распределения по месяцам не заданы. [Статья:" + Статья + "]";
	КонецЕсли;
		
	// может быть неопределено, если все коэффициенты = 0
	// теперь делаем движения по регистру Бюджет по месяцам 
	Для Каждого Стр ИЗ тзПоМесяцам Цикл
		Сумма = мРезПоСтатье[тзПоМесяцам.Индекс( Стр )];
		Если Сумма <> 0 Тогда
			
			//Для учета остатка
			суммаВсего = 0;
				
			//ОБеспечение на указанный масяц
//			Отбор = Новый Структура();
//			Отбор.Вставить("Месяц", Месяц(Стр.Месяц));
//			обеспечение = тзПоВидам.НайтиСтроки(Отбор);
			обеспечение = Новый ТаблицаЗначений;
			обеспечение.Колонки.Добавить("ВидПлана");
			обеспечение.Колонки.Добавить("Доля");
			Для Каждого о ИЗ тзПоВидам Цикл 
				Если о.Месяц = Месяц(Стр.Месяц) Тогда
					с = обеспечение.Добавить();
					с.ВидПлана = о.ВидПлана;        
					с.Доля = о.Доля;        
				КонецЕсли;
			КонецЦикла;
			всегоДоляОбеспечения = обеспечение.Итог("Доля");
			
			//Частный случай, когда обеспечения на данный период нет.       
			//Всю сумму ставим на Прогноз
			Если всегоДоляОбеспечения <> 0 Тогда 
				Для Каждого тип ИЗ обеспечение Цикл
					Если тип.Доля <> 0 Тогда 
						Движение = Движения.БюджетПоМесяцам.Добавить();
						Движение.Период 		= Дата; // 
						Движение.ЗадачаПроекта 	= ЗадачаПроекта;
						Движение.СтатьяСметы 	= Статья;
						Движение.ТипСуммы 		= ТипСуммы; 
						Движение.Месяц			= НачалоМесяца(Стр.Месяц); // 
						Движение.ВидПлана		= тип.ВидПлана;
						Движение.Сумма			= Сумма * тип.Доля / всегоДоляОбеспечения;
						
						суммаВсего = суммаВсего + Движение.Сумма;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		
			Если Сумма <> суммаВсего Тогда
				Движение = Движения.БюджетПоМесяцам.Добавить();
				Движение.Период 		= Дата; // 
				Движение.ЗадачаПроекта 	= ЗадачаПроекта;
				Движение.СтатьяСметы 	= Статья;
				Движение.ТипСуммы 		= ТипСуммы; 
				Движение.ВидПлана		= Перечисления.ВидыПланаБюджета.Прогноз;
				Движение.Месяц			= НачалоМесяца( Стр.Месяц); // 
				Движение.Сумма			= Сумма - суммаВсего;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры


// ПП и прочие прямые расходы
Процедура РаспределитьПоДвижениямПервичныхДокументов( Статья, Сумма, тзПоВидам )
	//тзПоВидам = Новый ТаблицаЗначений;
	//тзПоВидам.Колонки.Добавить("ВидПлана");
	//тзПоВидам.Колонки.Добавить("Доля");
	
	Запрос = Новый Запрос;
	// исправил 2014 08 12
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(БюджетПоМесяцам.Сумма) КАК Сумма,
		|	НАЧАЛОПЕРИОДА(БюджетПоМесяцам.Месяц, МЕСЯЦ) КАК Месяц
		|ИЗ
		|	РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
		|ГДЕ
		|	БюджетПоМесяцам.ЗадачаПроекта = &ЗадачаПроекта
		|	И БюджетПоМесяцам.ТипСуммы = &ТипСуммы
		|	И БюджетПоМесяцам.СтатьяСметы = &СтатьяСметы
		|
		|СГРУППИРОВАТЬ ПО
		|	НАЧАЛОПЕРИОДА(БюджетПоМесяцам.Месяц, МЕСЯЦ)";

		
	Запрос.УстановитьПараметр("ТипСуммы", 		Перечисления.ТипСуммыБюджета.ПервичныйДокумент);
	Запрос.УстановитьПараметр("ЗадачаПроекта", 	ЗадачаПроекта);
	Запрос.УстановитьПараметр("СтатьяСметы", 	Статья);
	Результат = Запрос.Выполнить().Выгрузить();
	Результат.Сортировать("Месяц");
	// 	
	РаспределитьПоМесяцам( Статья, Сумма, Результат, тзПоВидам);
	
КонецПроцедуры


//
Функция СуммаДоходаФинансового()	
	Стр = Расчет.Найти( Справочники.СтатьиСметы.ДохФинансовые, "Статья");
	Если Стр = Неопределено Тогда Возврат 0; КонецЕсли;
	Возврат Стр.Сумма;
КонецФункции


// из уже сделанных движений отбираем по статье - базе распределения
Функция ПолучитьДвиженияПоСтатье( ДвиженияБюджетПоМесяцам, СтатьяОтбора )
	тз = ДвиженияБюджетПоМесяцам.Выгрузить(,"СтатьяСметы,Месяц,Сумма");
	Отбор = Новый Структура("СтатьяСметы", СтатьяОтбора);
	Возврат тз.Скопировать( Отбор );
КонецФункции



Функция ПолучитьРаспределениеПоСтатье( Статья,  ГодПроекта)
	Отбор = Новый Структура("СтатьяСметы", Статья );
	СтрРаспределения = РегистрыСведений.РаспределениеСтатейПоМесяцам.ПолучитьПоследнее( Дата( ГодПроекта, 1, 1));
	Возврат СтрРаспределения;
КонецФункции

//[#129398 - Катаев]
//сформировать по договорам и смете базу коэффициентов распределения по Видам плана
Функция ПолучитьДоходПоГрафикуДоговор(СуммаДФ, ЗадачаПроекта)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(ДоговорЭтапыГрафикаРеализации.ДатаРеализации, МЕСЯЦ) КАК Месяц,
		|	СУММА(ДоговорЭтапыГрафикаРеализации.СуммаРеализации) КАК Сумма
		|ИЗ
		|	Документ.Договор.ЭтапыГрафикаРеализации КАК ДоговорЭтапыГрафикаРеализации
		|ГДЕ
		|	ДоговорЭтапыГрафикаРеализации.ЗадачаПроекта = &ЗадачаПроекта
		|
		|СГРУППИРОВАТЬ ПО
		|	НАЧАЛОПЕРИОДА(ДоговорЭтапыГрафикаРеализации.ДатаРеализации, МЕСЯЦ)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Месяц";     

	Запрос.УстановитьПараметр("ЗадачаПроекта", ЗадачаПроекта);
	тзОбеспечено   	= Запрос.Выполнить().Выгрузить();
	
	тзПоВидам = Новый ТаблицаЗначений;
	тзПоВидам.Колонки.Добавить("Месяц");
	тзПоВидам.Колонки.Добавить("Сумма");
	
	СуммаПрогноз = СуммаДФ;
	// коэффициенты
	Для Каждого Обеспечение ИЗ тзОбеспечено Цикл
		стр = тзПоВидам.Добавить();
		стр.Месяц = Обеспечение.Месяц;
		стр.Сумма = Обеспечение.Сумма;
		СуммаПрогноз = СуммаПрогноз - Обеспечение.Сумма;
	КонецЦикла;

	Если СуммаПрогноз <> 0 Тогда
		Если стр.Месяц >= НачалоМесяца(ЗадачаПроекта.ОкончаниеРабот) Тогда
			стр = тзПоВидам.Добавить();
			стр.Месяц = НачалоМесяца(ЗадачаПроекта.ОкончаниеРабот);
			стр.Сумма = 0;
		КонецЕсли;
		стр.Сумма = стр.Сумма + СуммаПрогноз;
	КонецЕсли;

	Возврат тзПоВидам;
КонецФункции	

//[#129398 - Катаев]
//сформировать по договорам и смете базу коэффициентов распределения по Видам плана
Функция ПолучитьДоходПоГрафикуЗадача(СуммаДФ, ЗадачаПроекта)
	тзОбеспечено = ЗадачаПроекта.ЭтапыГрафикаРеализации.Выгрузить();
	тзОбеспечено.Свернуть("ДатаРеализации", "СуммаПлан");
	
	тзПоВидам = Новый ТаблицаЗначений;
	тзПоВидам.Колонки.Добавить("Месяц");
	тзПоВидам.Колонки.Добавить("Сумма");
	
	// коэффициенты по месяцам
	Для Каждого Обеспечение ИЗ тзОбеспечено Цикл
		стр = тзПоВидам.Добавить();
		стр.Месяц = НачалоМесяца(Обеспечение.ДатаРеализации);
		//Доход финансовый сумме строк графика реализации по задаче
		стр.Сумма = Обеспечение.СуммаПлан; 
	КонецЦикла;

	Возврат тзПоВидам;
КонецФункции	

//[#129398 - Катаев]
//сформировать обеспечение по графику отгрузки договоров
Функция ПолучитьДолиОбеспеченияПоГрафикуДоговор(СуммаДФ, ЗадачаПроекта)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(ДоговорЭтапыГрафикаРеализации.ДатаРеализации) КАК Месяц,
		|	ДоговорЭтапыГрафикаРеализации.СуммаРеализации,
		|	ДоговорЭтапыГрафикаРеализации.Ссылка.Фиктивный
		|ИЗ
		|	Документ.Договор.ЭтапыГрафикаРеализации КАК ДоговорЭтапыГрафикаРеализации
		|ГДЕ
		|	ДоговорЭтапыГрафикаРеализации.ЗадачаПроекта = &ЗадачаПроекта";     

	Запрос.УстановитьПараметр("ЗадачаПроекта", ЗадачаПроекта);
	тзОбеспечено   	= Запрос.Выполнить().Выгрузить();
	
	тзПоВидам = Новый ТаблицаЗначений;
	тзПоВидам.Колонки.Добавить("Месяц");
	тзПоВидам.Колонки.Добавить("ВидПлана");
	тзПоВидам.Колонки.Добавить("Доля");

	мОбеспечено = Новый Массив(13);                 
	мГарантия = Новый Массив(13);
	мПрогноз = Новый Массив(13);
	мВсего = Новый Массив(13);
	Для индекс = 1 по 12 Цикл 
		мОбеспечено[индекс] = 0;
		мГарантия[индекс] = 0;
		мПрогноз[индекс] = 0;
		мВсего[индекс] = 0;
	КонецЦикла; 
	
	СуммаПрогноз = СуммаДФ;
		
	// коэффициенты по месяцам
	Для Каждого Обеспечение ИЗ тзОбеспечено Цикл
		доля = Обеспечение.СуммаРеализации / СуммаДФ;
		Если Обеспечение.Фиктивный = Истина Тогда
			мГарантия[ Месяц(Обеспечение.Месяц) ] = доля;
		Иначе
			мОбеспечено[ Месяц(Обеспечение.Месяц) ] = доля;
		КонецЕсли;
		СуммаПрогноз = СуммаПрогноз - Обеспечение.СуммаРеализации;
		мВсего[Месяц(Обеспечение.Месяц)] = мВсего[Месяц(Обеспечение.Месяц)] + доля;
	КонецЦикла;

	//остаток суммы на прогноз
	Если СуммаПрогноз <> 0 Тогда 
		доля = Обеспечение.СуммаРеализации / СуммаДФ;
		мПрогноз[Месяц(ЗадачаПроекта.ОкончаниеРабот)] = доля;
		мВсего[Месяц(ЗадачаПроекта.ОкончаниеРабот)] = мВсего[Месяц(ЗадачаПроекта.ОкончаниеРабот)] + доля;
	КонецЕсли;
	
	//Накопительный итог
	Для индекс = 2 по 12 Цикл
		мОбеспечено[индекс] = мОбеспечено[индекс-1] + мОбеспечено[индекс];
		мГарантия[индекс] = мГарантия[индекс-1] + мГарантия[индекс];
		мПрогноз[индекс] = мПрогноз[индекс-1] + мПрогноз[индекс];
		мВсего[индекс] = мВсего[индекс-1] + мВсего[индекс];
	КонецЦикла; 
	
	//Результат
	Для индекс = 1 по 12 Цикл
		стр = тзПоВидам.Добавить();
		стр.Месяц = индекс;
		стр.ВидПлана = Перечисления.ВидыПланаБюджета.Обеспечено;
		стр.Доля = мОбеспечено[индекс];
	
		стр = тзПоВидам.Добавить();
		стр.Месяц = индекс;
		стр.ВидПлана = Перечисления.ВидыПланаБюджета.Гарантия;
		стр.Доля = мГарантия[индекс];
		
		стр = тзПоВидам.Добавить();
		стр.Месяц = индекс;
		стр.ВидПлана = Перечисления.ВидыПланаБюджета.Прогноз;
		стр.Доля = мПрогноз[индекс];
	КонецЦикла; 
	
	Возврат тзПоВидам;
КонецФункции	

//[#129398 - Катаев]
//сформировать обеспечение по графику отгрузки договоров
Функция ПолучитьДолиОбеспеченияПоГрафикуЗадача(СуммаДФ, ЗадачаПроекта)
	тзОбеспечено   	= ЗадачаПроекта.ЭтапыГрафикаРеализации.Выгрузить();
		
	тзПоВидам = Новый ТаблицаЗначений;
	тзПоВидам.Колонки.Добавить("Месяц");
	тзПоВидам.Колонки.Добавить("ВидПлана");
	тзПоВидам.Колонки.Добавить("Доля");
//----
	мОбеспечено = Новый Массив(13);                 
	мГарантия = Новый Массив(13);
	мПрогноз = Новый Массив(13);
	мВсего = Новый Массив(13);
	Для индекс = 1 по 12 Цикл 
		мОбеспечено[индекс] = 0;
		мГарантия[индекс] = 0;
		мПрогноз[индекс] = 0;
		мВсего[индекс] = 0;
	КонецЦикла; 
	
	СуммаПрогноз = СуммаДФ;
	сГарантия = 0;
	сОбеспечено = 0;
	сПрогноз = 0;
	
	//Итоги по видам
	тзИтого = тзОбеспечено.Скопировать();
	тзИтого.Свернуть("ВидПлана", "СуммаПлан"); 
	Для Каждого Обеспечение ИЗ тзИтого Цикл
		Если Обеспечение.ВидПлана = Перечисления.ВидыПланаБюджета.Гарантия Тогда
			сГарантия = Обеспечение.СуммаПлан;
		ИначеЕсли Обеспечение.ВидПлана = Перечисления.ВидыПланаБюджета.Обеспечено Тогда 
			сОбеспечено = Обеспечение.СуммаПлан;
		Иначе 
			сПрогноз = Обеспечение.СуммаПлан;
		КонецЕсли;
	КонецЦикла;
	
	// коэффициенты по месяцам
	Для Каждого Обеспечение ИЗ тзОбеспечено Цикл
		доля = 0;
		Если Обеспечение.ВидПлана = Перечисления.ВидыПланаБюджета.Гарантия Тогда
			доля = Обеспечение.СуммаПлан / сГарантия;
			мГарантия[ Месяц(Обеспечение.ДатаРеализации) ] = доля;
		ИначеЕсли Обеспечение.ВидПлана = Перечисления.ВидыПланаБюджета.Обеспечено Тогда 
			доля = Обеспечение.СуммаПлан / сОбеспечено;
			мОбеспечено[ Месяц(Обеспечение.ДатаРеализации) ] = доля;
		Иначе 
			доля = Обеспечение.СуммаПлан / сПрогноз;
			мПрогноз[ Месяц(Обеспечение.ДатаРеализации) ] = доля;
		КонецЕсли;
		СуммаПрогноз = СуммаПрогноз - Обеспечение.СуммаПлан;
		мВсего[Месяц(Обеспечение.ДатаРеализации)] = мВсего[Месяц(Обеспечение.ДатаРеализации)] + доля;
	КонецЦикла;

	//остаток суммы на прогноз
	Если СуммаПрогноз <> 0 Тогда 
		доля = Обеспечение.СуммаПлан / СуммаДФ;
		мПрогноз[Месяц(ЗадачаПроекта.ОкончаниеРабот)] = доля;
		мВсего[Месяц(ЗадачаПроекта.ОкончаниеРабот)] = мВсего[Месяц(ЗадачаПроекта.ОкончаниеРабот)] + доля;
	КонецЕсли;
	
	//Накопительный итог
	Для индекс = 2 по 12 Цикл
		Если мОбеспечено[индекс-1] < 1 Тогда
			мОбеспечено[индекс] = мОбеспечено[индекс-1] + мОбеспечено[индекс];
		КонецЕсли;
		Если мГарантия[индекс-1] < 1 Тогда
			мГарантия[индекс] = мГарантия[индекс-1] + мГарантия[индекс];
		КонецЕсли;
		Если мПрогноз[индекс-1] < 1 Тогда
			мПрогноз[индекс] = мПрогноз[индекс-1] + мПрогноз[индекс];
		КонецЕсли;
		мВсего[индекс] = мВсего[индекс-1] + мВсего[индекс];
	КонецЦикла; 
	
	//Результат
	Для индекс = 1 по 12 Цикл
		стр = тзПоВидам.Добавить();
		стр.Месяц = индекс;
		стр.ВидПлана = Перечисления.ВидыПланаБюджета.Обеспечено;
		стр.Доля = мОбеспечено[индекс];
	
		стр = тзПоВидам.Добавить();
		стр.Месяц = индекс;
		стр.ВидПлана = Перечисления.ВидыПланаБюджета.Гарантия;
		стр.Доля = мГарантия[индекс];
		
		стр = тзПоВидам.Добавить();
		стр.Месяц = индекс;
		стр.ВидПлана = Перечисления.ВидыПланаБюджета.Прогноз;
		стр.Доля = мПрогноз[индекс];
	КонецЦикла; 
//----	
	//// коэффициенты по месяцам
	//Для Каждого Обеспечение ИЗ тзОбеспечено Цикл
	//	стр = тзПоВидам.Добавить();
	//	стр.Месяц = НачалоМесяца(Обеспечение.ДатаРеализации);
	//	стр.ВидПлана = Обеспечение.ВидПлана;
	//	//Доход финансовый сумме строк графика реализации по задаче
	//	стр.Доля = Обеспечение.СуммаПлан / СуммаДФ; 
	//КонецЦикла;
	
	Возврат тзПоВидам;
КонецФункции	

// надо сделать в статье реквизит тип распределения !!
// 25 06 2017
Процедура ОбработкаПроведения(Отказ, Режим)
	//
	Проект		= ЗадачаПроекта.Владелец;
	ТипСуммы	= Перечисления.ТипСуммыБюджета.План; // план по смете задачи, т.е
	ГодПроекта 	= Проект.ГодПроекта;
	Если НЕ ЗначениеЗаполнено( ГодПроекта ) Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "В смете " + Номер + " от " + Дата + " Для проекта "+ Проект + " не указан год ";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	// распределение фот по месяцам
	
	// сумма дохода финансового для учета
	СуммаДФ = СуммаДоходаФинансового();
	
	//Проверка на соотвествие графика отгрузки по задаче смете
	график = ЗадачаПроекта.ЭтапыГрафикаРеализации.Выгрузить();
	Если СуммаДФ <> график.Итог("СуммаПлан") Тогда 
		Сообщить("Сумма финансового дохода по смете не совпадает с графиком реализации задачи.");
		Отказ = Истина;
		Возврат;		
	КонецЕсли;
	
	// распределение обеспечения
	//тзДоляОбеспеченияДоговор= ПолучитьДолиОбеспеченияПоГрафикуДоговор(СуммаДФ, ЗадачаПроекта);
	тзДоляОбеспеченияЗадача = ПолучитьДолиОбеспеченияПоГрафикуЗадача(СуммаДФ, ЗадачаПроекта);
	
	// указываем сумму по смете, т.к. смета задачи может проводиться первый раз
	// распределение с учетом этапов оплаты задачи проекта
	//тзПланДоходов 	= РаспределениеДоходовПоЗадачеПроекта( ЗадачаПроекта, СуммаДФ );
	//тзПланДоходовДоговор= ПолучитьДоходПоГрафикуДоговор(СуммаДФ, ЗадачаПроекта );
	тзПланДоходовЗадача	= ПолучитьДоходПоГрафикуЗадача(СуммаДФ, ЗадачаПроекта );
	
	//********************************************************************************
	Движения.БюджетПоМесяцам.Записывать = Истина;
	Для Каждого ТекСтрокаРасходыЗадачиПроекта Из Расчет Цикл
		
		// итоговые статьи пропускаем, они будут формироваться в отчете
		Если ТекСтрокаРасходыЗадачиПроекта.Итоговая Тогда Продолжить; КонецЕсли;
		
		Статья				= ТекСтрокаРасходыЗадачиПроекта.Статья;
		//СтрРаспределения 	= ПолучитьРаспределениеПоСтатье( Статья,  ГодПроекта); 
		//Из регистра СпособРаспределенияСуммыПоМесяцам который ни кто не изменят
		СпособРаспределения = Статья.СпособРаспределения; //СтрРаспределения.СпособРаспределения;
		
		Сумма 				= ТекСтрокаРасходыЗадачиПроекта.Сумма;
		Если Сумма = 0 Тогда                                              
			Продолжить;
		КонецЕсли;
		
		Если СпособРаспределения = Справочники.СпособРаспределенияСуммыПоМесяцам.ПоГрафикуОплатыДоговора Тогда
			// все пропорционально поступлению графику оплаты договора 
			//РаспределитьПоМесяцам( Статья, Сумма, тзПланДоходовДоговор, тзДоляОбеспеченияДоговор );
			Сообщить("Статья '" + Статья + "': распеределение по графику оплаты не предусмотрено");
			Отказ = Истина;
		ИначеЕсли СпособРаспределения = Справочники.СпособРаспределенияСуммыПоМесяцам.ПоГрафикуРеализацииЗадачи Тогда
			// все пропорционально поступлению графику оплаты договора 
			РаспределитьПоМесяцам( Статья, Сумма, тзПланДоходовЗадача, тзДоляОбеспеченияЗадача );
			
		ИначеЕсли 	СпособРаспределения = Справочники.СпособРаспределенияСуммыПоМесяцам.РавномерноПоМесяцам Тогда
			// 2017 09 19
			РаспределитьРавномерноПоПериодуЗадачи( Статья, Сумма );
			
		ИначеЕсли СпособРаспределения = Справочники.СпособРаспределенияСуммыПоМесяцам.ПоСтатьеСметы Тогда
			// 
			Если ЗначениеЗаполнено( Статья.БазоваяСтатьяСметы ) Тогда
				//Если ЗначениеЗаполнено( СтрРаспределения.БазоваяСтатьяСметы ) Тогда
				тзДвиженияБазы = ПолучитьДвиженияПоСтатье( Движения.БюджетПоМесяцам, Статья.БазоваяСтатьяСметы );
				//тзДвиженияБазы = ПолучитьДвиженияПоСтатье( Движения.БюджетПоМесяцам, СтрРаспределения.БазоваяСтатьяСметы );
				РаспределитьПоМесяцам( Статья, Сумма, тзДвиженияБазы, тзДоляОбеспеченияЗадача);
			Иначе                                                                                
				// если выбран способ по статье и статья не указана, то по доходам 
				//РаспределитьПоМесяцам( Статья, Сумма, тзПланДоходов, тзДоляОбеспеченияЗадача );
				
				//Сообщение = Новый СообщениеПользователю;
				//Сообщение.Текст = "Для статьи " + Статья + " не указана базовая статья распределения";        
				//Сообщение.Сообщить();
				Сообщить("Статья '" + Статья + "': не указана базовая статья распределения");
				Отказ = Истина;
			КонецЕсли;					
		ИначеЕсли 	СпособРаспределения = Справочники.СпособРаспределенияСуммыПоМесяцам.ПоДатамПервичныхДокументов Тогда
			РаспределитьПоДвижениямПервичныхДокументов( Статья, Сумма, тзДоляОбеспеченияЗадача);
			//Сообщить("Статья '" + Статья + "': первичный документ для распределения по месяцам не найден");
			//Отказ = Истина;
		//ИначеЕсли ТекСтрокаРасходыЗадачиПроекта.ИзмененоДокументом Тогда
		//	// 2017 06 09 - если заполнено по документам - то движения ТОЛЬКО по первичным документам
		//	//[#129398 - Катаев]
		//	//распределить сумму кроме основного алгоритма еще и по коэффициентам Вида плана
		//	РаспределитьПоДвижениямПервичныхДокументов( Статья, Сумма, тзДоляОбеспеченияЗадача);
		Иначе				
			//Сообщение = Новый СообщениеПользователю;
			//Сообщение.Текст = "Для статьи " + Статья + " не указан способ распределения по месяцам";
			//Сообщение.Сообщить();
			Сообщить("Статья '" + Статья + "': не указан способ распределения по месяцам");
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


Процедура ОбработкаУдаленияПроведения(Отказ)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СметаДокументы.Ссылка КАК Смета,
		|	СметаДокументы.Ссылка.Проект
		|ИЗ
		|	Документ.Смета.Документы КАК СметаДокументы
		|ГДЕ
		|	СметаДокументы.Документ = &Смета
		|	И СметаДокументы.Ссылка.Проведен";

	Запрос.УстановитьПараметр("Смета", 		Ссылка );

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сообщить("Текущая смета задачи включена в смету " + 
					ВыборкаДетальныеЗаписи.Смета + ", проекта " +
					ВыборкаДетальныеЗаписи.Проект );
		Отказ = Истина;
		Возврат;
	КонецЦикла;

КонецПроцедуры

// 2013,07,03
// проверка осуществляется только при интерактивном проведении, т.е. в форме
// т.к. при проведении программном ( из документа Договор )
// проводится должно не зависимо от статуса проекта
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если УП_ПереносДанных.ПроведениеПриПереносе() Тогда
		Возврат;
	КонецЕсли;
	
	
	//Если РежимЗаписи = РежимЗаписиДокумента.Проведение 
	//И НЕ РазрешеноПроводитьДокумент( Ссылка, Ссылка.ЗадачаПроекта.Владелец ) Тогда
	//	Отказ = Истина;
	//	Возврат;
	//КонецЕсли;		

КонецПроцедуры
