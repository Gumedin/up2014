﻿
//Добавлено 26.07.2018 по задаче #132324 Гумедин А.Г.
///////// ВЫГРУЗКА //////////
Функция ПреобразоватьВОбменныйФормат(ИмяМетаданныхФормата, ТипДействия, СтруктураПараметров = Неопределено) Экспорт
	
	Если ТипДействия = 1 Тогда 
		СтруктураПараметров = Новый Структура();
		
		//... Парматретры требуется сформировать под каждый тип документа 
		Если ИмяМетаданныхФормата = "ОФ_Смета" Тогда
			СтруктураПараметров.Вставить("ГодЗадачи", "Год задачи");
		ИначеЕсли ИмяМетаданныхФормата = "ОФ_ГрафикОплаты" Тогда
			СтруктураПараметров.Вставить("ГодЗадачи", "Год задачи");
		ИначеЕсли ИмяМетаданныхФормата = "ОФ_ЗаявкаНаПлатеж" Тогда
			СтруктураПараметров.Вставить("ГодЗадачи", "Год задачи");
		КонецЕсли;
		
		Возврат СтруктураПараметров;
			
	ИначеЕсли ТипДействия = 2 Тогда
		
		Если  ИмяМетаданныхФормата = "ОФ_Смета" Тогда
			ТаблицаЗначений = ПолучитьСмету(СтруктураПараметров);
		ИначеЕсли ИмяМетаданныхФормата = "ОФ_ГрафикОплаты" Тогда
			ТаблицаЗначений = ПолучитьГрафикОплаты(СтруктураПараметров);
		ИначеЕсли ИмяМетаданныхФормата = "ОФ_ЗаявкаНаПлатеж" Тогда
			ТаблицаЗначений = ПолучитьЗаявкуНаПлатеж(СтруктураПараметров);
		КонецЕсли;
				
		Возврат ТаблицаЗначений;
			
	КонецЕсли;
	                                                
КонецФункции

//Получаем данные по смете
Функция ПолучитьСмету(СтркутураПараметров)
	
	ТаблицаЗначений = Новый ТаблицаЗначений();
	ТаблицаЗначений.Колонки.Добавить("ДатаФормирования");
	ТаблицаЗначений.Колонки.Добавить("Год");
	ТаблицаЗначений.Колонки.Добавить("Код");
	ТаблицаЗначений.Колонки.Добавить("Проект");
	ТаблицаЗначений.Колонки.Добавить("Спецификация");   	
	
	ТекущаяДата = Формат(ТекущаяДата(), "ДЛФ=Д");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	&ТекущаяДата КАК ДатаФормирования,
		|	БюджетПоМесяцам.ЗадачаПроекта.ГодЗадачи КАК Год,
		|	БюджетПоМесяцам.ЗадачаПроекта.Владелец.Наименование КАК Проект,
		|	БюджетПоМесяцам.ЗадачаПроекта.Владелец.Код КАК КодПроекта,
		|	БюджетПоМесяцам.СтатьяСметы.Наименование КАК СтатьяСметы,
		|	БюджетПоМесяцам.Месяц КАК Месяц,
		|	СУММА(БюджетПоМесяцам.Сумма) КАК Сумма,
		|	ВЫБОР
		|		КОГДА БюджетПоМесяцам.ВидПлана = ЗНАЧЕНИЕ(Перечисление.ВидыПланаБюджета.Обеспечено)
		|			ТОГДА 1
		|		КОГДА БюджетПоМесяцам.ВидПлана = ЗНАЧЕНИЕ(Перечисление.ВидыПланаБюджета.Гарантия)
		|			ТОГДА 2
		|		КОГДА БюджетПоМесяцам.ВидПлана = ЗНАЧЕНИЕ(Перечисление.ВидыПланаБюджета.Прогноз)
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ВидПлана,
		|	ВЫБОР
		|		КОГДА БюджетПоМесяцам.ТипСуммы = ЗНАЧЕНИЕ(Перечисление.ТипСуммыБюджета.План)
		|			ТОГДА 1
		|		КОГДА БюджетПоМесяцам.ТипСуммы = ЗНАЧЕНИЕ(Перечисление.ТипСуммыБюджета.Факт)
		|			ТОГДА 2
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ТипСуммы
		|ИЗ
		|	РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
		|ГДЕ
		|	БюджетПоМесяцам.ЗадачаПроекта.ГодЗадачи = &ГодЗадачи
		|	И НЕ БюджетПоМесяцам.ТипСуммы = &ТипСуммыПорядок
		|
		|СГРУППИРОВАТЬ ПО
		|	БюджетПоМесяцам.ЗадачаПроекта.ГодЗадачи,
		|	БюджетПоМесяцам.ЗадачаПроекта.Владелец.Наименование,
		|	БюджетПоМесяцам.СтатьяСметы.Наименование,
		|	БюджетПоМесяцам.Месяц,
		|	ВЫБОР
		|		КОГДА БюджетПоМесяцам.ВидПлана = ЗНАЧЕНИЕ(Перечисление.ВидыПланаБюджета.Обеспечено)
		|			ТОГДА 1
		|		КОГДА БюджетПоМесяцам.ВидПлана = ЗНАЧЕНИЕ(Перечисление.ВидыПланаБюджета.Гарантия)
		|			ТОГДА 2
		|		КОГДА БюджетПоМесяцам.ВидПлана = ЗНАЧЕНИЕ(Перечисление.ВидыПланаБюджета.Прогноз)
		|			ТОГДА 3
		|		ИНАЧЕ 0
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА БюджетПоМесяцам.ТипСуммы = ЗНАЧЕНИЕ(Перечисление.ТипСуммыБюджета.План)
		|			ТОГДА 1
		|		КОГДА БюджетПоМесяцам.ТипСуммы = ЗНАЧЕНИЕ(Перечисление.ТипСуммыБюджета.Факт)
		|			ТОГДА 2
		|		ИНАЧЕ 0
		|	КОНЕЦ,
		|	БюджетПоМесяцам.ЗадачаПроекта.Владелец.Код
		|
		|УПОРЯДОЧИТЬ ПО
		|	Год,
		|	Проект";
	
	 	Запрос.УстановитьПараметр("ГодЗадачи", СтркутураПараметров.ГодЗадачи);
		Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата); 
		Запрос.УстановитьПараметр("ТипСуммыПорядок", Перечисления.ТипСуммыБюджета.ПервичныйДокумент);
		//... добавить условия по вкусу
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Ограничитель = "";
	
	Для Каждого Элемент Из РезультатЗапроса Цикл
		
		Если НЕ Ограничитель = "" + Элемент.Год + Элемент.Проект Тогда 
			
			Ограничитель = "" + Элемент.Год + Элемент.Проект;
		
			Стр = ТаблицаЗначений.Добавить();
			Стр.ДатаФормирования = Элемент.ДатаФормирования;
			Стр.Год = Элемент.Год;
			Стр.Код = Элемент.КодПроекта;
			Стр.Проект = Элемент.Проект;
			
			Отбор = Новый Структура();
			Отбор.Вставить("Год", Элемент.Год);
			Отбор.Вставить("КодПроекта", Элемент.КодПроекта);
			Отбор.Вставить("Проект", Элемент.Проект);
			
			Спецификации = РезультатЗапроса.НайтиСтроки(Отбор);
					
				//Формируем спецификации
				ТаблицаЗначенийВлож = Новый ТаблицаЗначений();
				ТаблицаЗначенийВлож.Колонки.Добавить("ВидПлана");
				ТаблицаЗначенийВлож.Колонки.Добавить("СтатьяСметы");
				ТаблицаЗначенийВлож.Колонки.Добавить("ТипСуммы");
				ТаблицаЗначенийВлож.Колонки.Добавить("Месяц");
				ТаблицаЗначенийВлож.Колонки.Добавить("Сумма");
				
				Для Каждого ЭлементСпец Из Спецификации Цикл
					СтрВлож = ТаблицаЗначенийВлож.Добавить();	
					СтрВлож.ВидПлана = ЭлементСпец.ВидПлана;
					СтрВлож.СтатьяСметы = ЭлементСпец.СтатьяСметы;
					СтрВлож.ТипСуммы = ЭлементСпец.ТипСуммы;
					СтрВлож.Месяц = ЭлементСпец.Месяц;
					СтрВлож.Сумма = ЭлементСпец.Сумма;
				КонецЦикла;
				// конец формирования спецификации
			
			Стр.Спецификация = ТаблицаЗначенийВлож;
		КонецЕсли;		
	КонецЦикла;
	
	Возврат ТаблицаЗначений;
	
КонецФункции

//Получаем данные по Графику Оплаты
Функция ПолучитьГрафикОплаты(СтркутураПараметров)
	
	ТаблицаЗначений = Новый ТаблицаЗначений();
	ТаблицаЗначений.Колонки.Добавить("ДатаФормирования");
	ТаблицаЗначений.Колонки.Добавить("Год");
	ТаблицаЗначений.Колонки.Добавить("Проект");
	ТаблицаЗначений.Колонки.Добавить("Спецификация");
	
	ТекущаяДата = Формат(ТекущаяДата(), "ДЛФ=Д");
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	&ТекущаяДата КАК ДатаФормирования,
		|	Реализация.ЗадачаПроекта.ГодЗадачи КАК Год,
		|	Реализация.ЗадачаПроекта.Владелец.Наименование КАК Проект,
		|	Реализация.Договор КАК Договор,
		|	Реализация.Период КАК Дата,
		|	Реализация.ВидПлана.Порядок КАК ВидПлана,
		|	ВЫБОР
		|		КОГДА Реализация.План = 0
		|			ТОГДА 2
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК ТипСуммы,
		|	СУММА(ВЫБОР
		|			КОГДА Реализация.План = 0
		|				ТОГДА Реализация.Факт
		|			ИНАЧЕ Реализация.План
		|		КОНЕЦ) КАК Сумма
		|ИЗ
		|	РегистрНакопления.Реализация КАК Реализация
		|ГДЕ
		|	Реализация.ЗадачаПроекта.ГодЗадачи = &ГодЗадачи
		|	И НЕ Реализация.ВидПлана = &ВидПланаПорядок
		|
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА Реализация.План = 0
		|			ТОГДА 2
		|		ИНАЧЕ 1
		|	КОНЕЦ,
		|	Реализация.ВидПлана.Порядок,
		|	Реализация.Договор,
		|	Реализация.ЗадачаПроекта.Владелец.Наименование,
		|	Реализация.ЗадачаПроекта.ГодЗадачи,
		|	Реализация.Период
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	Проект";
		
	 	Запрос.УстановитьПараметр("ГодЗадачи", СтркутураПараметров.ГодЗадачи);
		Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата); 
		Запрос.УстановитьПараметр("ВидПланаПорядок", Перечисления.ВидыПланаБюджета.Гарантия);
		//... добавить условия по вкусу
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Ограничитель = "";
	
	Для Каждого Элемент Из РезультатЗапроса Цикл
		
		Если НЕ Ограничитель = "" + Элемент.Год + Элемент.Проект Тогда 
			
			Ограничитель = "" + Элемент.Год + Элемент.Проект;
		
			Стр = ТаблицаЗначений.Добавить();
			Стр.ДатаФормирования = Элемент.ДатаФормирования;
			Стр.Год = Элемент.Год;
			Стр.Проект = Элемент.Проект;
			
			Отбор = Новый Структура();
			Отбор.Вставить("Год", Элемент.Год);
			Отбор.Вставить("Проект",Элемент.Проект);
			
			Спецификации = РезультатЗапроса.НайтиСтроки(Отбор);
					
				//Формируем спецификации
				ТаблицаЗначенийВлож = Новый ТаблицаЗначений();
				ТаблицаЗначенийВлож.Колонки.Добавить("Договор");
				ТаблицаЗначенийВлож.Колонки.Добавить("Дата");
				ТаблицаЗначенийВлож.Колонки.Добавить("ВидПлана");
				ТаблицаЗначенийВлож.Колонки.Добавить("ТипСуммы");
				ТаблицаЗначенийВлож.Колонки.Добавить("Сумма");
				
				Для Каждого ЭлементСпец Из Спецификации Цикл
					СтрВлож = ТаблицаЗначенийВлож.Добавить();	
					СтрВлож.Договор = ЭлементСпец.Договор;
					СтрВлож.Дата = ЭлементСпец.Дата;
					СтрВлож.ВидПлана = ЭлементСпец.ВидПлана;
					СтрВлож.ТипСуммы = ЭлементСпец.ТипСуммы;
					СтрВлож.Сумма = ЭлементСпец.Сумма;
				КонецЦикла;
				// конец формирования спецификации
			
			Стр.Спецификация = ТаблицаЗначенийВлож;
		КонецЕсли;		
	КонецЦикла;
	
	Возврат ТаблицаЗначений;
	
КонецФункции
	
//Получаем данные по Заявке
Функция ПолучитьЗаявкуНаПлатеж(СтркутураПараметров)
	
	ТаблицаЗначений = Новый ТаблицаЗначений();
	ТаблицаЗначений.Колонки.Добавить("ДатаФормирования");
	ТаблицаЗначений.Колонки.Добавить("UID_документа");
	ТаблицаЗначений.Колонки.Добавить("Проект");
	ТаблицаЗначений.Колонки.Добавить("НомерОплаты");
	ТаблицаЗначений.Колонки.Добавить("ДатаОплаты");
	ТаблицаЗначений.Колонки.Добавить("Сумма");
	ТаблицаЗначений.Колонки.Добавить("ИсполнительДокумента");
	ТаблицаЗначений.Колонки.Добавить("ТипЗаявки");
	ТаблицаЗначений.Колонки.Добавить("Комментарий");
	ТаблицаЗначений.Колонки.Добавить("Спецификация");
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	&ТекущаяДата КАК ДатаФормирования,
		|	ЗаявкаНаВыплату.Ссылка КАК UID_документа,
		|	ЗаявкаНаВыплату.Проект.Наименование КАК Проект,
		|	ЗаявкаНаВыплату.НомерОплаты КАК НомерОплаты,
		|	ЗаявкаНаВыплату.ДатаОплаты КАК ДатаОплаты,
		|	ЗаявкаНаВыплату.СуммаДокумента КАК Сумма,
		|	ЗаявкаНаВыплату.ИсполнительДокумента.Наименование КАК ИсполнительДокумента,
		|	&ЗаявкаНаПлатеж КАК ТипЗаявки,
		|	NULL КАК Комментарий,
		|	БюджетПоМесяцам.РКО КАК РКО,
		|	БюджетПоМесяцам.СтатьяСметы.ИмяПредопределенныхДанных КАК СтатьяСметы,
		|	ВЫБОР
		|		КОГДА БюджетПоМесяцам.ТипСуммы.Порядок = 0
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК ТипСуммы,
		|	БюджетПоМесяцам.ВидПлана.Порядок КАК ВидПлана
		|ИЗ
		|	Документ.ЗаявкаНаВыплату КАК ЗаявкаНаВыплату
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
		|		ПО ЗаявкаНаВыплату.Ссылка = БюджетПоМесяцам.Регистратор
		|ГДЕ
		|	БюджетПоМесяцам.ЗадачаПроекта.ГодЗадачи = &ГодЗадачи
		|	И НЕ БюджетПоМесяцам.ТипСуммы = &ТипСуммыПорядок
		|	И НЕ БюджетПоМесяцам.ВидПлана = &ВидПланаПорядок
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&ТекущаяДата,
		|	ЗаявкаНаОплатуПоставщику.Ссылка,
		|	ЗаявкаНаОплатуПоставщику.ЗакупкаППЛО.ЗадачаПроекта.Владелец.Наименование,
		|	ЗаявкаНаОплатуПоставщику.НомерОплаты,
		|	ЗаявкаНаОплатуПоставщику.ДатаОплаты,
		|	ЗаявкаНаОплатуПоставщику.СуммаДокумента,
		|	ЗаявкаНаОплатуПоставщику.ИсполнительДокумента.Наименование,
		|	&ЗаявкаНаОплатуПоставщику,
		|	ЗаявкаНаОплатуПоставщику.Комментарий,
		|	БюджетПоМесяцам.РКО,
		|	БюджетПоМесяцам.СтатьяСметы.ИмяПредопределенныхДанных,
		|	ВЫБОР
		|		КОГДА БюджетПоМесяцам.ТипСуммы.Порядок = 0
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ,
		|	БюджетПоМесяцам.ВидПлана.Порядок
		|ИЗ
		|	Документ.ЗаявкаНаОплатуПоставщику КАК ЗаявкаНаОплатуПоставщику
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
		|		ПО ЗаявкаНаОплатуПоставщику.Ссылка = БюджетПоМесяцам.Регистратор
		|ГДЕ
		|	БюджетПоМесяцам.ЗадачаПроекта.ГодЗадачи = &ГодЗадачи
		|	И НЕ БюджетПоМесяцам.ТипСуммы = &ТипСуммыПорядок
		|	И НЕ БюджетПоМесяцам.ВидПлана = &ВидПланаПорядок
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&ТекущаяДата,
		|	ЗаявкаНаРасходПоСотруднику.Ссылка,
		|	ЗаявкаНаРасходПоСотрудникуРасходы.ЗадачаПроекта.Владелец.Наименование,
		|	NULL,
		|	ЗаявкаНаРасходПоСотруднику.ДатаОплаты,
		|	ЗаявкаНаРасходПоСотрудникуРасходы.Сумма,
		|	ЗаявкаНаРасходПоСотруднику.ИсполнительДокумента.Наименование,
		|	&ЗаявкаНаРасходПоСотруднику,
		|	ЗаявкаНаРасходПоСотрудникуРасходы.Комментарий,
		|	БюджетПоМесяцам.РКО,
		|	БюджетПоМесяцам.СтатьяСметы.ИмяПредопределенныхДанных,
		|	ВЫБОР
		|		КОГДА БюджетПоМесяцам.ТипСуммы.Порядок = 0
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ,
		|	БюджетПоМесяцам.ВидПлана.Порядок
		|ИЗ
		|	Документ.ЗаявкаНаРасходПоСотруднику КАК ЗаявкаНаРасходПоСотруднику
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаРасходПоСотруднику.Расходы КАК ЗаявкаНаРасходПоСотрудникуРасходы
		|		ПО ЗаявкаНаРасходПоСотруднику.Ссылка = ЗаявкаНаРасходПоСотрудникуРасходы.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
		|		ПО ЗаявкаНаРасходПоСотруднику.Ссылка = БюджетПоМесяцам.Регистратор
		|ГДЕ
		|	БюджетПоМесяцам.ЗадачаПроекта.ГодЗадачи = &ГодЗадачи
		|	И НЕ БюджетПоМесяцам.ТипСуммы = &ТипСуммыПорядок
		|	И НЕ БюджетПоМесяцам.ВидПлана = &ВидПланаПорядок
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&ТекущаяДата,
		|	ЗаявкаНаВыплатуРасхода.Ссылка,
		|	ЗаявкаНаВыплатуРасхода.РасходПоЗадаче.ЗадачаПроекта.Владелец.Наименование,
		|	ЗаявкаНаВыплатуРасхода.НомерОплаты,
		|	ЗаявкаНаВыплатуРасхода.ДатаОплаты,
		|	ЗаявкаНаВыплатуРасхода.СуммаДокумента,
		|	ЗаявкаНаВыплатуРасхода.ИсполнительДокумента.Наименование,
		|	&ЗаявкаНаВыплатуРасхода,
		|	NULL,
		|	БюджетПоМесяцам.РКО,
		|	БюджетПоМесяцам.СтатьяСметы.ИмяПредопределенныхДанных,
		|	ВЫБОР
		|		КОГДА БюджетПоМесяцам.ТипСуммы.Порядок = 0
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ,
		|	БюджетПоМесяцам.ВидПлана.Порядок
		|ИЗ
		|	Документ.ЗаявкаНаВыплатуРасхода КАК ЗаявкаНаВыплатуРасхода
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
		|		ПО ЗаявкаНаВыплатуРасхода.Ссылка = БюджетПоМесяцам.Регистратор
		|ГДЕ
		|	БюджетПоМесяцам.ЗадачаПроекта.ГодЗадачи = &ГодЗадачи
		|	И НЕ БюджетПоМесяцам.ТипСуммы = &ТипСуммыПорядок
		|	И НЕ БюджетПоМесяцам.ВидПлана = &ВидПланаПорядок";
	
	Запрос.УстановитьПараметр("ГодЗадачи", СтркутураПараметров.ГодЗадачи);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	Запрос.УстановитьПараметр("ЗаявкаНаПлатеж", "ЗаявкаНаПлатеж");
	Запрос.УстановитьПараметр("ЗаявкаНаОплатуПоставщику", "ЗаявкаНаОплатуПоставщику");
	Запрос.УстановитьПараметр("ЗаявкаНаРасходПоСотруднику", "ЗаявкаНаРасходПоСотруднику");
	Запрос.УстановитьПараметр("ЗаявкаНаВыплатуРасхода", "ЗаявкаНаВыплатуРасхода");
	Запрос.УстановитьПараметр("ТипСуммыПорядок", Перечисления.ТипСуммыБюджета.ПервичныйДокумент);
	Запрос.УстановитьПараметр("ВидПланаПорядок", Перечисления.ВидыПланаБюджета.Прогноз);

	//Группируем полученные данные
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	//РезультатЗапросаСГруппировкой = ГруппировкаИтоговогоРезультата(РезультатЗапроса);
	РезультатЗапросаСГруппировкой = РезультатЗапроса.Скопировать(,"ДатаФормирования, UID_документа, Проект, НомерОплаты, ДатаОплаты, Сумма, ИсполнительДокумента, Комментарий, ТипЗаявки");
	РезультатЗапросаСГруппировкой.Свернуть("ДатаФормирования, UID_документа, Проект, НомерОплаты, ДатаОплаты, Сумма, ИсполнительДокумента, Комментарий, ТипЗаявки");
	
	Для Каждого Элемент Из РезультатЗапросаСГруппировкой Цикл
		
		СтрокаGUID=СОКРЛП(Элемент.UID_документа.УникальныйИдентификатор());
				
		Стр = ТаблицаЗначений.Добавить();
		Стр.ДатаФормирования = Элемент.ДатаФормирования;
		Стр.UID_документа = СтрокаGUID;
		Стр.Проект = Элемент.Проект;
		Стр.НомерОплаты = Элемент.НомерОплаты;
		Стр.ДатаОплаты = Элемент.ДатаОплаты;
		Стр.Сумма = Элемент.Сумма;
		Стр.ИсполнительДокумента = Элемент.ИсполнительДокумента;
		Стр.ТипЗаявки = Элемент.ТипЗаявки;
		Стр.Комментарий = Элемент.Комментарий;
		
		Отбор = Новый Структура();
		Отбор.Вставить("UID_документа", Элемент.UID_документа);
		Отбор.Вставить("Проект",Элемент.Проект);
		Отбор.Вставить("НомерОплаты",Элемент.НомерОплаты);             
		Отбор.Вставить("ДатаОплаты",Элемент.ДатаОплаты);
		Отбор.Вставить("Сумма",Элемент.Сумма); 
		Отбор.Вставить("ИсполнительДокумента",Элемент.ИсполнительДокумента);
		Отбор.Вставить("ТипЗаявки",Элемент.ТипЗаявки); 	
		Отбор.Вставить("Комментарий",Элемент.Комментарий);		
		Спецификации = РезультатЗапроса.НайтиСтроки(Отбор);
				
			//Формируем спецификации
			ТаблицаЗначенийВлож = Новый ТаблицаЗначений();
			ТаблицаЗначенийВлож.Колонки.Добавить("РКО");
			ТаблицаЗначенийВлож.Колонки.Добавить("СтатьяСметы");
			ТаблицаЗначенийВлож.Колонки.Добавить("ТипСуммы");
			ТаблицаЗначенийВлож.Колонки.Добавить("ВидПлана");
			
			Для Каждого ЭлементСпец Из Спецификации Цикл
				СтрВлож = ТаблицаЗначенийВлож.Добавить();	
				СтрВлож.РКО = ЭлементСпец.РКО;
				СтрВлож.СтатьяСметы = ЭлементСпец.СтатьяСметы;
				СтрВлож.ТипСуммы = ЭлементСпец.ТипСуммы;
				СтрВлож.ВидПлана = ЭлементСпец.ВидПлана;
			КонецЦикла;
			ТаблицаЗначенийВлож.Свернуть("РКО, СтатьяСметы, ТипСуммы, ВидПлана");
			// конец формирования спецификации
		
		Стр.Спецификация = ТаблицаЗначенийВлож;		
	КонецЦикла;
		 
	Возврат ТаблицаЗначений;
	
КонецФункции

Функция ГруппировкаИтоговогоРезультата(РезультатЗапроса)		
	ТЗ_РезультатЗапроса = Новый ТаблицаЗначений;
    ТЗ_РезультатЗапроса.Колонки.Добавить("ДатаФормирования", Новый ОписаниеТипов("Дата",, Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	ТЗ_РезультатЗапроса.Колонки.Добавить("UID_документа", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(40, ДопустимаяДлина.Переменная)));
	ТЗ_РезультатЗапроса.Колонки.Добавить("Ссылка", Новый ОписаниеТипов(Документы.ТипВсеСсылки()));
	ТЗ_РезультатЗапроса.Колонки.Добавить("Проект", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100, ДопустимаяДлина.Переменная)));
	ТЗ_РезультатЗапроса.Колонки.Добавить("НомерОплаты", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100, ДопустимаяДлина.Переменная)));
	ТЗ_РезультатЗапроса.Колонки.Добавить("ДатаОплаты", Новый ОписаниеТипов("Дата",, Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	ТЗ_РезультатЗапроса.Колонки.Добавить("ИсполнительДокумента", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(50, ДопустимаяДлина.Переменная)));
	ТЗ_РезультатЗапроса.Колонки.Добавить("ТипЗаявки", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100, ДопустимаяДлина.Переменная)));
	ТЗ_РезультатЗапроса.Колонки.Добавить("Комментарий", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(400, ДопустимаяДлина.Переменная)));
	ТЗ_РезультатЗапроса.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2)));
	
	Для Каждого Элемент Из РезультатЗапроса Цикл
		
		СтрокаGUID=СОКРЛП(Элемент.UID_документа.УникальныйИдентификатор());
		
		Стр = ТЗ_РезультатЗапроса.Добавить();
		Стр.ДатаФормирования = Элемент.ДатаФормирования;
		Стр.UID_документа = СтрокаGUID;
		Стр.Ссылка = Элемент.UID_документа;
		Стр.Проект = Элемент.Проект;
		Стр.НомерОплаты = Элемент.НомерОплаты;
		Стр.ДатаОплаты = Элемент.ДатаОплаты;
		Стр.ИсполнительДокумента = Элемент.ИсполнительДокумента;
		Стр.ТипЗаявки = Элемент.ТипЗаявки;
		Стр.Комментарий = Элемент.Комментарий;
		Стр.Сумма = Элемент.Сумма;
	КонецЦикла;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
    Запрос.Текст = 
		"ВЫБРАТЬ
		|	РезультатЗапроса.ДатаФормирования КАК ДатаФормирования,
		|	РезультатЗапроса.UID_документа КАК UID_документа,
		|	РезультатЗапроса.Ссылка КАК Ссылка,
		|	РезультатЗапроса.Проект КАК Проект,
		|	РезультатЗапроса.НомерОплаты КАК НомерОплаты,
		|	РезультатЗапроса.ДатаОплаты КАК ДатаОплаты,
		|	РезультатЗапроса.ИсполнительДокумента КАК ИсполнительДокумента,
		|	РезультатЗапроса.ТипЗаявки КАК ТипЗаявки,
		|	РезультатЗапроса.Комментарий КАК Комментарий,
		|	РезультатЗапроса.Сумма КАК Сумма
		|ПОМЕСТИТЬ ВТ
		|ИЗ
		|	&РезультатЗапроса КАК РезультатЗапроса
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ.ДатаФормирования КАК ДатаФормирования,
		|	ВТ.UID_документа КАК UID_документа,
		| 	ВТ.Ссылка КАК Ссылка,
		|	ВТ.Проект КАК Проект,
		|	ВТ.НомерОплаты КАК НомерОплаты,
		|	ВТ.ДатаОплаты КАК ДатаОплаты,
		|	ВТ.ИсполнительДокумента КАК ИсполнительДокумента,
		|	ВТ.ТипЗаявки КАК ТипЗаявки,
		|	ВТ.Комментарий КАК Комментарий,
		|	ВТ.Сумма КАК Сумма
		|ИЗ
		|	ВТ КАК ВТ
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ.ДатаФормирования,
		|	ВТ.UID_документа,
		|	ВТ.Ссылка,
		|	ВТ.Проект,
		|	ВТ.НомерОплаты,
		|	ВТ.ДатаОплаты,
		|	ВТ.ИсполнительДокумента,
		|	ВТ.ТипЗаявки,
		|	ВТ.Комментарий,
		|	ВТ.Сумма
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТипЗаявки,
		|	ДатаФормирования,
		|	UID_документа,
		|	Ссылка,
		|	Проект,
		|	ДатаОплаты,		 				
		|	НомерОплаты,
		|	ИсполнительДокумента,
		|	Комментарий,
		|	Сумма";	
	
	Запрос.УстановитьПараметр("РезультатЗапроса", ТЗ_РезультатЗапроса);
	
	ТаблицаЗначений = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаЗначений;
КонецФункции

///////// ЗАГРУЗКА //////////
Процедура ПреобразоватьИЗОбменногоФормата(Документ) Экспорт	
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.ОФ_ЗаявкаНаПлатеж") Тогда
		ЗагрузитьЗаявкуНаПлатеж(Документ);
	//ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.Оф_Смета") Тогда  
	//	ЗагрузитьСмету(Документ);		
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ОФ_НачислениеЗП") Тогда  
		ЗагрузитьНачислениеЗП(Документ);		
	КонецЕсли;		
КонецПроцедуры

//Загрузка заявок
Процедура ЗагрузитьЗаявкуНаПлатеж(Документ)
	Если Документ["ТипЗаявки"] = "ЗаявкаНаВыплату" Тогда
		НовыйДокумент = Документы.ЗаявкаНаВыплату.СоздатьДокумент();
		//НовыйДокумент.Дата = 
		НовыйДокумент.Записать();
	ИначеЕсли Документ["ТипЗаявки"] = "ЗаявкаНаВыплатуРасхода" Тогда
		НовыйДокумент = Документы.ЗаявкаНаВыплатуРасхода.СоздатьДокумент();
		//НовыйДокумент.Дата = 
		НовыйДокумент.Записать();
	ИначеЕсли Документ["ТипЗаявки"] = "ЗаявкаНаОплатуПоставщику" Тогда
		НовыйДокумент = Документы.ЗаявкаНаОплатуПоставщику.СоздатьДокумент();
		//НовыйДокумент.Дата = 
		НовыйДокумент.Записать();
	ИначеЕсли Документ["ТипЗаявки"] = "ЗаявкаНаРасходПоСотруднику" Тогда
		НовыйДокумент = Документы.ЗаявкаНаРасходПоСотруднику.СоздатьДокумент();
		//НовыйДокумент.Дата = 
		НовыйДокумент.Записать();
	КонецЕсли;
КонецПроцедуры

//Загрузка начисления зарплаты
Процедура ЗагрузитьНачислениеЗП(ДокументОбъект)

	НеНайденные = Новый Соответствие();
	
	Ошибки = Ложь;
	Фонд = Справочники.Фонды.НайтиПоКоду(ДокументОбъект.Фонд);
	Если Фонд = Справочники.Фонды.ПустаяСсылка() Тогда 
		Сообщить("Фонд с кодом '" + ДокументОбъект.Фонд + "' не найден!");
		Ошибки = Истина;			
	КонецЕсли;
	
	Для Каждого строка из ДокументОбъект.Спецификация Цикл
		Подразделение = Справочники.Подразделения.НайтиПоРеквизиту("Сокращение", строка.Подразделение);
		Сотрудник = Справочники.ФизическиеЛица.НайтиПоНаименованию(строка.Сотрудник);
		
		Если Подразделение = Справочники.Подразделения.ПустаяСсылка() Тогда 
			Если НеНайденные.Получить(строка.Подразделение) = Неопределено Тогда 
				НеНайденные.Вставить(строка.Подразделение, строка.Подразделение);
				Сообщить("Подразделение с кодом '" + строка.Подразделение + "' не найдено!");
				Ошибки = Истина;			
			КонецЕсли;
		КонецЕсли;
		
		Если Сотрудник = Справочники.ФизическиеЛица.ПустаяСсылка() Тогда 
			Если НеНайденные.Получить(строка.Сотрудник) = Неопределено Тогда 
				НеНайденные.Вставить(строка.Сотрудник, строка.Сотрудник);
				Сообщить("Сотрудник '" + строка.Сотрудник + "' не найден!");
				Ошибки = Истина;			
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Ошибки Тогда 
		Сообщить("Импорт прерван!");
	Иначе 
		НовыйДокумент = Документы.ВыплатаЗППроизводства.СоздатьДокумент();
		
		НовыйДокумент.Дата = ТекущаяДата();
		НовыйДокумент.ПериодРегистрации = ДокументОбъект.Дата;
		НовыйДокумент.Фонд = Фонд;
	
		Для Каждого строка из ДокументОбъект.Спецификация Цикл
			запись = НовыйДокумент.Выплаты.Добавить();
			запись.Подразделение = Справочники.Подразделения.НайтиПоРеквизиту("Сокращение", строка.Подразделение);
			запись.Сотрудник = Справочники.ФизическиеЛица.НайтиПоНаименованию(строка.Сотрудник);
			запись.Сумма = строка.Сумма;
		КонецЦикла;
		
		НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
		
		Объект = ДокументОбъект.Ссылка.ПолучитьОбъект();
		Объект.Записать(РежимЗаписиДокумента.Проведение);			
	КонецЕсли;
КонецПроцедуры

////Загрузка сметы
//Процедура ЗагрузитьСмету(ДокументОбъект)
//	//Удаляем предудущие данные
//	НаборДанных = РегистрыСведений.Сит_БДРПоПроектам.СоздатьНаборЗаписей();
//	НаборДанных.Отбор.Год.Установить(ДокументОбъект.Год);
//	НаборДанных.Отбор.Проект.Установить(ДокументОбъект.Проект);
//	НаборДанных.Прочитать();
//	НаборДанных.Очистить();
//	НаборДанных.Записать(Истина);
//	
//	//Добавляем новые
//	строки = Новый ТаблицаЗначений();
//	строки.Колонки.Добавить("Год");
//	строки.Колонки.Добавить("Проект");
//	строки.Колонки.Добавить("СтатьяСметы");
//	строки.Колонки.Добавить("Месяц");
//	строки.Колонки.Добавить("ПланОбеспечено");
//	строки.Колонки.Добавить("ПланГарантия");
//	строки.Колонки.Добавить("ПланПрогноз");
//	строки.Колонки.Добавить("Факт");
//	
//	Для Каждого строка из ДокументОбъект.Спецификация Цикл
//		запись = строки.Добавить();
//		
//		запись.Год = ДокументОбъект.Год;
//		запись.Проект = ДокументОбъект.Проект;
//		запись.СтатьяСметы = строка.СтатьяСметы;
//		запись.Месяц = Дата(строка.Месяц + " 00:00:00");
//		Если строка.ТипСуммы = 2 Тогда 
//			//Факт
//			запись.Факт = строка.Сумма;
//		ИначеЕсли строка.ВидПлана = 1 Тогда 
//			//Обеспечено
//			запись.ПланОбеспечено = строка.Сумма;
//		ИначеЕсли строка.ВидПлана = 2 Тогда 
//			//Гарантия
//			запись.ПланГарантия = строка.Сумма;
//		Иначе
//			//Прогноз
//			запись.ПланПрогноз = строка.Сумма;
//		КонецЕсли;
//	КонецЦикла;
//	
//	строки.Свернуть("Год, Проект, СтатьяСметы, Месяц", "Факт, ПланОбеспечено, ПланГарантия, ПланПрогноз");
//	
//	Для Каждого строка из строки Цикл
//		запись = НаборДанных.Добавить();
//		
//		запись.Регистратор = ДокументОбъект.Ссылка;
//		запись.Год = строка.Год;
//		запись.Проект = строка.Проект;
//		запись.СтатьяСметы = строка.СтатьяСметы;
//		запись.Месяц = строка.Месяц;
//		запись.ПланОбеспечено = строка.ПланОбеспечено;
//		запись.ПланГарантия = строка.ПланГарантия;
//		запись.ПланПрогноз = строка.ПланПрогноз;
//		запись.Факт = строка.Факт;
//	КонецЦикла;
//	
//	НаборДанных.Записать(Истина);
//	
//	Объект = ДокументОбъект.Ссылка.ПолучитьОбъект();
//	Объект.Записать(РежимЗаписиДокумента.Проведение);			
//КонецПроцедуры

