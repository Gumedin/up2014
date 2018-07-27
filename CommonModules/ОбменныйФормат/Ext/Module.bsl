﻿
//Добавлено 26.07.2018 по задаче #132324 Гумедин А.Г.
Функция ПреобразоватьВОбменныйФормат(ИмяМетаданныхФормата, ТипДействия, СтркутураПараметров = Неопределено) Экспорт
	
	Если ТипДействия = 1 Тогда 
		СтруктураПараметров = Новый Структура();
		
		//... Парматретры требуется сформировать под каждый тип документа 
		Если  ИмяМетаданныхФормата = "ОФ_ОборотыБУ" Тогда 
			СтруктураПараметров.Вставить("", "");
			СтруктураПараметров.Вставить("", "");
			СтруктураПараметров.Вставить("", "");
		ИначеЕсли ИмяМетаданныхФормата = "ОФ_Смета" Тогда
			СтруктураПараметров.Вставить("", "");
			СтруктураПараметров.Вставить("", "");
			СтруктураПараметров.Вставить("", "");
		ИначеЕсли ИмяМетаданныхФормата = "ОФ_ГрафикОплаты" Тогда
			СтруктураПараметров.Вставить("", "");
			СтруктураПараметров.Вставить("", "");
			СтруктураПараметров.Вставить("", "");
		ИначеЕсли ИмяМетаданныхФормата = "ОФ_ЗаявкаНаПлатеж" Тогда
			СтруктураПараметров.Вставить("", "");
			СтруктураПараметров.Вставить("", "");
			СтруктураПараметров.Вставить("", "");
		КонецЕсли;
		
		Возврат СтруктураПараметров;
			
	ИначеЕсли ТипДействия = 2 Тогда
		
		Если  ИмяМетаданныхФормата = "ОФ_ОборотыБУ" Тогда 
			ТаблицаЗначений = ПолучитьОбороты(СтруктураПараметров);
		ИначеЕсли ИмяМетаданныхФормата = "ОФ_Смета" Тогда
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
	ТаблицаЗначений.Колонки.Добавить("Проект");
	ТаблицаЗначений.Колонки.Добавить("Спецификация");
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	"+ТекущаяДата()+" КАК ДатаФормирования,
		|	БюджетПоМесяцам.ЗадачаПроекта.ГодЗадачи КАК Год,
		|	БюджетПоМесяцам.ЗадачаПроекта.Владелец.Наименование КАК Проект
		|ИЗ
		|	РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
		|ГДЕ
		|	БюджетПоМесяцам.Период = &Период
		|
		|СГРУППИРОВАТЬ ПО
		|	"+ТекущаяДата()+",
		|	БюджетПоМесяцам.ЗадачаПроекта.ГодЗадачи,
		|	БюджетПоМесяцам.ЗадачаПроекта.Владелец.Наименование";
		
	 	Запрос.УстановитьПараметр("Период", СтркутураПараметров.Период);			
		//... добавить условия по вкусу
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Стр = ТаблицаЗначений.Добавить();
		Стр.ДатаФормирования = ВыборкаДетальныеЗаписи.ДатаФормирования;
		Стр.Год = ВыборкаДетальныеЗаписи.Год;
		Стр.Проект = ВыборкаДетальныеЗаписи.Проект;		
				
			//Формируем спецификации			
			ТаблицаЗначенийВлож = Новый ТаблицаЗначений();
			ТаблицаЗначенийВлож.Колонки.Добавить("ВидПлана");
			ТаблицаЗначенийВлож.Колонки.Добавить("СтатьяСметы");
			ТаблицаЗначенийВлож.Колонки.Добавить("ТипСуммы");
			ТаблицаЗначенийВлож.Колонки.Добавить("Месяц");
			ТаблицаЗначенийВлож.Колонки.Добавить("Сумма");			
						
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	БюджетПоМесяцам.ВидПлана.Порядок КАК ВидПланаПорядок,
				|	БюджетПоМесяцам.СтатьяСметы.Код КАК СтатьяСметыКод,
				|	БюджетПоМесяцам.ТипСуммы.Порядок КАК ТипСуммыПорядок,
				|	БюджетПоМесяцам.Месяц КАК Месяц,
				|	БюджетПоМесяцам.Сумма КАК Сумма
				|ИЗ
				|	РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
				|ГДЕ
				|	БюджетПоМесяцам.ЗадачаПроекта.Владелец.Наименование = &Наименование
				|	И БюджетПоМесяцам.ЗадачаПроекта.ГодЗадачи = &ГодЗадачи";
			
			Запрос.УстановитьПараметр("ГодЗадачи", ВыборкаДетальныеЗаписи.Год);
			Запрос.УстановитьПараметр("Наименование", ВыборкаДетальныеЗаписи.Проект);
			
			РезультатЗапросаВлож = Запрос.Выполнить();			
			ВыборкаДетальныеЗаписиВлож = РезультатЗапросаВлож.Выбрать();
		
			Пока ВыборкаДетальныеЗаписиВлож.Следующий() Цикл
				СтрВлож = ТаблицаЗначенийВлож.Добавить();	
				СтрВлож.ВидПлана = ВыборкаДетальныеЗаписиВлож.ВидПлана;
				СтрВлож.СтатьяСметы = ВыборкаДетальныеЗаписиВлож.СтатьяСметы;
				СтрВлож.ТипСуммы = ВыборкаДетальныеЗаписиВлож.ТипСуммы;
				СтрВлож.Месяц = ВыборкаДетальныеЗаписиВлож.Месяц;
				СтрВлож.Сумма = ВыборкаДетальныеЗаписиВлож.Сумма;
			КонецЦикла;
			// конец формирования спецификации
		
		Стр.Спецификация = ТаблицаЗначенийВлож;
		
	КонецЦикла;
	
	Возврат ТаблицаЗначений;
	
КонецФункции

//Получаем данные по Оборотам БУ
Функция ПолучитьОбороты(СтркутураПараметров)
	
	ТаблицаЗначений = Новый ТаблицаЗначений();
	ТаблицаЗначений.Колонки.Добавить("Период");
	ТаблицаЗначений.Колонки.Добавить("Год");
	ТаблицаЗначений.Колонки.Добавить("Дата");
	ТаблицаЗначений.Колонки.Добавить("Дб");
	ТаблицаЗначений.Колонки.Добавить("АнДб1");
	ТаблицаЗначений.Колонки.Добавить("АнДб2");
	ТаблицаЗначений.Колонки.Добавить("АнДб3");
	ТаблицаЗначений.Колонки.Добавить("Кр");
	ТаблицаЗначений.Колонки.Добавить("АнДб1");
	ТаблицаЗначений.Колонки.Добавить("АнДб2");
	ТаблицаЗначений.Колонки.Добавить("АнДб3");
	ТаблицаЗначений.Колонки.Добавить("Сумма");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	???
		|ИЗ
		|	??? КАК ОборотыБУ
		|ГДЕ
		|	??? = &Период
		|	И ??? = &Регистратор";
		
	 	Запрос.УстановитьПараметр("Период", СтркутураПараметров.Период);
		Запрос.УстановитьПараметр("Регистратор", СтркутураПараметров.Регистратор);			
		//... добавить условия по вкусу
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Стр = ТаблицаЗначений.Добавить();
		Стр.Период = ВыборкаДетальныеЗаписи.Период;
		Стр.Год = ВыборкаДетальныеЗаписи.Год;
		Стр.Дата = ВыборкаДетальныеЗаписи.Дата;
		Стр.Дб = ВыборкаДетальныеЗаписи.Дб;
		Стр.АнДб1 = ВыборкаДетальныеЗаписи.АнДб1;
		Стр.АнДб2 = ВыборкаДетальныеЗаписи.АнДб2;
		Стр.АнДб3 = ВыборкаДетальныеЗаписи.АнДб3;
		Стр.Кр = ВыборкаДетальныеЗаписи.Кр;
		Стр.АнДб1 = ВыборкаДетальныеЗаписи.АнДб1;
		Стр.АнДб2 = ВыборкаДетальныеЗаписи.АнДб2;
		Стр.АнДб3 = ВыборкаДетальныеЗаписи.АнДб3;
		Стр.Сумма = ВыборкаДетальныеЗаписи.Сумма;
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
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	"+ТекущаяДата()+" КАК ДатаФормирования,
		|	ОбеспечениеОплата.ЗадачаПроекта.ГодЗадачи КАК Год,
		|	ОбеспечениеОплата.ЗадачаПроекта.Владелец.Наименование КАК Проект
		|ИЗ
		|	РегистрНакопления.ОбеспечениеОплата КАК ОбеспечениеОплата
		|ГДЕ
		|	ОбеспечениеОплата.Период = &Период
		|
		|СГРУППИРОВАТЬ ПО
		|	"+ТекущаяДата()+",
		|	ОбеспечениеОплата.ЗадачаПроекта.ГодЗадачи,
		|	ОбеспечениеОплата.ЗадачаПроекта.Владелец.Наименование";
		
	 	Запрос.УстановитьПараметр("Период", СтркутураПараметров.Период);
		Запрос.УстановитьПараметр("Регистратор", СтркутураПараметров.Регистратор);			
		//... добавить условия по вкусу
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Стр = ТаблицаЗначений.Добавить();
		Стр.ДатаФормирования = ВыборкаДетальныеЗаписи.ДатаФормирования;
		Стр.Год = ВыборкаДетальныеЗаписи.Год;
		Стр.Проект = ВыборкаДетальныеЗаписи.Проект;
		
			//Формируем спецификации		
			ТаблицаЗначенийВлож = Новый ТаблицаЗначений();
			ТаблицаЗначенийВлож.Колонки.Добавить("Договор");
			ТаблицаЗначенийВлож.Колонки.Добавить("Дата");
			ТаблицаЗначенийВлож.Колонки.Добавить("ТипПлана");
			ТаблицаЗначенийВлож.Колонки.Добавить("ВидСредств");
			ТаблицаЗначенийВлож.Колонки.Добавить("Сумма"); 

			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	ОбеспечениеОплата.Договор КАК Договор,
				|	ОбеспечениеОплата.Месяц КАК Дата,
				|	0 КАК ТипПлана,
				|	0 КАК ВидСредств,
				|	ОбеспечениеОплата.СуммаОплачено КАК Сумма
				|ИЗ
				|	РегистрНакопления.ОбеспечениеОплата КАК ОбеспечениеОплата
				|ГДЕ
				|	ОбеспечениеОплата.ЗадачаПроекта.Владелец.Наименование = &Наименование
				|	И ОбеспечениеОплата.ЗадачаПроекта.ГодЗадачи = &ГодЗадачи";
			
			Запрос.УстановитьПараметр("ГодЗадачи", ВыборкаДетальныеЗаписи.Год);
			Запрос.УстановитьПараметр("Наименование", ВыборкаДетальныеЗаписи.Проект);
			
			РезультатЗапросаВлож = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписиВлож = РезультатЗапросаВлож.Выбрать();
		
			Пока ВыборкаДетальныеЗаписиВлож.Следующий() Цикл
				СтрВлож = ТаблицаЗначенийВлож.Добавить();	
				СтрВлож.Договор = ВыборкаДетальныеЗаписиВлож.Договор;
				СтрВлож.Дата = ВыборкаДетальныеЗаписиВлож.Дата;
				СтрВлож.ТипПлана = ВыборкаДетальныеЗаписиВлож.ТипПлана;
				СтрВлож.ВидСредств = ВыборкаДетальныеЗаписиВлож.ВидСредств;
				СтрВлож.Сумма = ВыборкаДетальныеЗаписиВлож.Сумма;
			КонецЦикла;
			// конец формирования спецификации
		
		Стр.Спецификация = ТаблицаЗначенийВлож;    
		
	КонецЦикла;
	
	Возврат ТаблицаЗначений;
	
КонецФункции
	
//Получаем данные по Заявке
Функция ПолучитьЗаявкуНаПлатеж(СтркутураПараметров)
	
	ТаблицаЗначений = Новый ТаблицаЗначений();
	ТаблицаЗначений.Колонки.Добавить("UID");
	ТаблицаЗначений.Колонки.Добавить("Проект");
	ТаблицаЗначений.Колонки.Добавить("СуммаДокумента");
	ТаблицаЗначений.Колонки.Добавить("ИсполнительДокумента");
	ТаблицаЗначений.Колонки.Добавить("Комментарий");
	ТаблицаЗначений.Колонки.Добавить("Спецификация");
	
	//Заявка на выплату	
	Для Каждого Элемент Из Документы.ЗаявкаНаВыплату Цикл
		Стр = ТаблицаЗначений.Добавить();
		Стр.UID = Элемент.Сылка;
		Стр.Проект = Элемент.Проект.Наименование;
		Стр.СуммаДокумента = Элемент.СуммаДокумента;
		Стр.ИсполнительДокумента = Элемент.ИсполнительДокумента.Наименование;
		//Стр.Комментарий = Элемента.Комментарий;
		
			//Формирование спецификации  			
			ТаблицаЗначенийВлож = Новый ТаблицаЗначений();
			ТаблицаЗначенийВлож.Колонки.Добавить("РКО");
			ТаблицаЗначенийВлож.Колонки.Добавить("СтатьяСметы");
			ТаблицаЗначенийВлож.Колонки.Добавить("ТипПлатежа");
			ТаблицаЗначенийВлож.Колонки.Добавить("ВидПлатежа");
			ТаблицаЗначенийВлож.Колонки.Добавить("Дата");
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	БюджетПоМесяцам.РКО КАК РКО,
				|	БюджетПоМесяцам.СтатьяСметы.Код КАК СтатьяСметы,
				|	БюджетПоМесяцам.ТипСуммы.Порядок КАК ТипПлатежа,
				|	БюджетПоМесяцам.ВидПлана.Порядок КАК ВидПлатежа,
				|	БюджетПоМесяцам.Период КАК Дата
				|ИЗ
				|	РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
				|ГДЕ
				|	БюджетПоМесяцам.Регистратор = &Регистратор";
			
			Запрос.УстановитьПараметр("Регистратор", Элемент);	
			РезультатЗапроса = Запрос.Выполнить(); 	
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				СтрВлож = ТаблицаЗначенийВлож.Добавить();
				СтрВлож.РКО = ВыборкаДетальныеЗаписи.РКО;
				СтрВлож.СтатьяСметы = ВыборкаДетальныеЗаписи.СтатьяСметы;
				СтрВлож.ТипПлатежа = ВыборкаДетальныеЗаписи.ТипПлатежа;
				СтрВлож.ВидПлатежа = ВыборкаДетальныеЗаписи.ВидПлатежа;
				СтрВлож.Дата = ВыборкаДетальныеЗаписи.Дата;
			КонецЦикла;
			
		Стр.Спецификация = ТаблицаЗначенийВлож;				
		Стр.ТипЗаявки = "ЗаявкаНаВыплату";
	КонецЦикла;
	
	//Заявка на выплату	расхода
	Для Каждого Элемент Из Документы.ЗаявкаНаВыплатуРасхода Цикл
		Стр = ТаблицаЗначений.Добавить();
		Стр.UID = Элемент.Сылка;
		Стр.Проект = Элемент.РасходПоЗадаче.ЗадачаПроекта.Владелец.Наименование;
		Стр.СуммаДокумента = Элемент.СуммаДокумента;
		//Стр.ИсполнительДокумента = Элемент.ИсполнительДокумента.Наименование;
		Стр.Комментарий = Элемент.Название;
		
			//Формирование спецификации  			
			ТаблицаЗначенийВлож = Новый ТаблицаЗначений();
			ТаблицаЗначенийВлож.Колонки.Добавить("РКО");
			ТаблицаЗначенийВлож.Колонки.Добавить("СтатьяСметы");
			ТаблицаЗначенийВлож.Колонки.Добавить("ТипПлатежа");
			ТаблицаЗначенийВлож.Колонки.Добавить("ВидПлатежа");
			ТаблицаЗначенийВлож.Колонки.Добавить("Дата");
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	БюджетПоМесяцам.РКО КАК РКО,
				|	БюджетПоМесяцам.СтатьяСметы.Код КАК СтатьяСметы,
				|	БюджетПоМесяцам.ТипСуммы.Порядок КАК ТипПлатежа,
				|	БюджетПоМесяцам.ВидПлана.Порядок КАК ВидПлатежа,
				|	БюджетПоМесяцам.Период КАК Дата
				|ИЗ
				|	РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
				|ГДЕ
				|	БюджетПоМесяцам.Регистратор = &Регистратор";
			
			Запрос.УстановитьПараметр("Регистратор", Элемент);	
			РезультатЗапроса = Запрос.Выполнить(); 	
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				СтрВлож = ТаблицаЗначенийВлож.Добавить();
				СтрВлож.РКО = ВыборкаДетальныеЗаписи.РКО;
				СтрВлож.СтатьяСметы = ВыборкаДетальныеЗаписи.СтатьяСметы;
				СтрВлож.ТипПлатежа = ВыборкаДетальныеЗаписи.ТипПлатежа;
				СтрВлож.ВидПлатежа = ВыборкаДетальныеЗаписи.ВидПлатежа;
				СтрВлож.Дата = ВыборкаДетальныеЗаписи.Дата;
			КонецЦикла;
			
		Стр.Спецификация = ТаблицаЗначенийВлож;				
		Стр.ТипЗаявки = "ЗаявкаНаВыплатуРасхода";
	КонецЦикла;
	
	//Заявка на выплату	поставщику
	Для Каждого Элемент Из Документы.ЗаявкаНаОплатуПоставщику Цикл
		Стр = ТаблицаЗначений.Добавить();
		Стр.UID = Элемент.Сылка;
		Стр.Проект = Элемент.ЗакупкаППЛО.ЗадачаПроекта.Владелец.Наименование;
		Стр.СуммаДокумента = Элемент.СуммаДокумента;
		Стр.ИсполнительДокумента = Элемент.ИсполнительДокумента.Наименование;
		Стр.Комментарий = Элемент.Комментарий;
		
			//Формирование спецификации  			
			ТаблицаЗначенийВлож = Новый ТаблицаЗначений();
			ТаблицаЗначенийВлож.Колонки.Добавить("РКО");
			ТаблицаЗначенийВлож.Колонки.Добавить("СтатьяСметы");
			ТаблицаЗначенийВлож.Колонки.Добавить("ТипПлатежа");
			ТаблицаЗначенийВлож.Колонки.Добавить("ВидПлатежа");
			ТаблицаЗначенийВлож.Колонки.Добавить("Дата");
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	БюджетПоМесяцам.РКО КАК РКО,
				|	БюджетПоМесяцам.СтатьяСметы.Код КАК СтатьяСметы,
				|	БюджетПоМесяцам.ТипСуммы.Порядок КАК ТипПлатежа,
				|	БюджетПоМесяцам.ВидПлана.Порядок КАК ВидПлатежа,
				|	БюджетПоМесяцам.Период КАК Дата
				|ИЗ
				|	РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
				|ГДЕ
				|	БюджетПоМесяцам.Регистратор = &Регистратор";
			
			Запрос.УстановитьПараметр("Регистратор", Элемент);	
			РезультатЗапроса = Запрос.Выполнить(); 	
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				СтрВлож = ТаблицаЗначенийВлож.Добавить();
				СтрВлож.РКО = ВыборкаДетальныеЗаписи.РКО;
				СтрВлож.СтатьяСметы = ВыборкаДетальныеЗаписи.СтатьяСметы;
				СтрВлож.ТипПлатежа = ВыборкаДетальныеЗаписи.ТипПлатежа;
				СтрВлож.ВидПлатежа = ВыборкаДетальныеЗаписи.ВидПлатежа;
				СтрВлож.Дата = ВыборкаДетальныеЗаписи.Дата;
			КонецЦикла;
			
		Стр.Спецификация = ТаблицаЗначенийВлож;				
		Стр.ТипЗаявки = "ЗаявкаНаОплатуПоставщику";
	КонецЦикла;
	
	//Заявка на выплату	поставщику
	Для Каждого Элемент Из Документы.ЗаявкаНаРасходПоСотруднику Цикл
		Стр = ТаблицаЗначений.Добавить();
		Стр.UID = Элемент.Сылка;
		Стр.Проект = Элемент.Расходы.Проект.Наименование;
		Стр.СуммаДокумента = Элемент.СуммаДокумента;
		Стр.ИсполнительДокумента = Элемент.ИсполнительДокумента.Наименование;
		//Стр.Комментарий = Элемента.Комментарий;
		
			//Формирование спецификации  			
			ТаблицаЗначенийВлож = Новый ТаблицаЗначений();
			ТаблицаЗначенийВлож.Колонки.Добавить("РКО");
			ТаблицаЗначенийВлож.Колонки.Добавить("СтатьяСметы");
			ТаблицаЗначенийВлож.Колонки.Добавить("ТипПлатежа");
			ТаблицаЗначенийВлож.Колонки.Добавить("ВидПлатежа");
			ТаблицаЗначенийВлож.Колонки.Добавить("Дата");
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	БюджетПоМесяцам.РКО КАК РКО,
				|	БюджетПоМесяцам.СтатьяСметы.Код КАК СтатьяСметы,
				|	БюджетПоМесяцам.ТипСуммы.Порядок КАК ТипПлатежа,
				|	БюджетПоМесяцам.ВидПлана.Порядок КАК ВидПлатежа,
				|	БюджетПоМесяцам.Период КАК Дата
				|ИЗ
				|	РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
				|ГДЕ
				|	БюджетПоМесяцам.Регистратор = &Регистратор";
			
			Запрос.УстановитьПараметр("Регистратор", Элемент);	
			РезультатЗапроса = Запрос.Выполнить(); 	
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				СтрВлож = ТаблицаЗначенийВлож.Добавить();
				СтрВлож.РКО = ВыборкаДетальныеЗаписи.РКО;
				СтрВлож.СтатьяСметы = ВыборкаДетальныеЗаписи.СтатьяСметы;
				СтрВлож.ТипПлатежа = ВыборкаДетальныеЗаписи.ТипПлатежа;
				СтрВлож.ВидПлатежа = ВыборкаДетальныеЗаписи.ВидПлатежа;
				СтрВлож.Дата = ВыборкаДетальныеЗаписи.Дата;
			КонецЦикла;
			
		Стр.Спецификация = ТаблицаЗначенийВлож;				
		Стр.ТипЗаявки = "ЗаявкаНаРасходПоСотруднику";
	КонецЦикла;
	
	Возврат ТаблицаЗначений;
	
КонецФункции	
