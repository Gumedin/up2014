﻿&НаСервереБезКонтекста
Процедура ЗаполнитьОбеспеченоПоЗадачам()
	
	
КонецПроцедуры

// заполняем колонки табличной части суммами по смете задачи проекта
&НаСервере
Функция ПолучитьСуммыЗадачиПоСмете( ЗадачаПроекта )
	
	//мЗадач = Объект.РасшифровкаПлатежа.Выгрузить(,"ЗадачаПроекта");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СметаЗПРасчет.Ссылка.ЗадачаПроекта,
		|	СУММА(ВЫБОР
		|			КОГДА СметаЗПРасчет.Статья = &стДохФинансовые
		|				ТОГДА СметаЗПРасчет.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ДохФинансовые,
		|	СУММА(ВЫБОР
		|			КОГДА СметаЗПРасчет.Статья = &стДоходыВс
		|				ТОГДА СметаЗПРасчет.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ДоходыВс,
		|	СУММА(ВЫБОР
		|			КОГДА СметаЗПРасчет.Статья = &стВознагрПосредника
		|				ТОГДА СметаЗПРасчет.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ВознагрПосредника,
		|	СУММА(ВЫБОР
		|			КОГДА СметаЗПРасчет.Статья = &стРасходыВознПосредника
		|				ТОГДА СметаЗПРасчет.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК РасходыВознПосредника,
		|	СУММА(ВЫБОР
		|			КОГДА СметаЗПРасчет.Статья = &стРасходыППЛО
		|				ТОГДА СметаЗПРасчет.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК РасходыППЛО,
		|	СУММА(ВЫБОР
		|			КОГДА СметаЗПРасчет.Статья = &стРасходыКоммерческие
		|				ТОГДА СметаЗПРасчет.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК РасходыКоммерческие,
		|	СУММА(ВЫБОР
		|			КОГДА СметаЗПРасчет.Статья = &стФОТ_ПП
		|					И &РасчетФОТпоОплате
		|				ТОГДА СметаЗПРасчет.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ФОТ_ПП
		|ИЗ
		|	Документ.СметаЗадачиПроекта.Расчет КАК СметаЗПРасчет
		|ГДЕ
		|	СметаЗПРасчет.Ссылка.Проведен
		|	И СметаЗПРасчет.Ссылка.ЗадачаПроекта = &ЗадачаПроекта
		|
		|СГРУППИРОВАТЬ ПО
		|	СметаЗПРасчет.Ссылка.ЗадачаПроекта";

	Запрос.УстановитьПараметр("стДоходыВс", 				Справочники.СтатьиСметы.ДоходыВс);
	Запрос.УстановитьПараметр("стВознагрПосредника", 		Справочники.СтатьиСметы.ВознагрПосредника);
	Запрос.УстановитьПараметр("стРасходыВознПосредника", 	Справочники.СтатьиСметы.РасходыВознПосредника);
	Запрос.УстановитьПараметр("стДохФинансовые", 			Справочники.СтатьиСметы.ДохФинансовые);
	Если Объект.Дата < Дата( 2014,1,1) Тогда
		Запрос.УстановитьПараметр("стРасходыКоммерческие", 		Справочники.СтатьиСметы.РасходыКоммерческие);
	Иначе
		Запрос.УстановитьПараметр("стРасходыКоммерческие", 		Справочники.СтатьиСметы.ВознаграждениеКМ);
	КонецЕсли;
	Запрос.УстановитьПараметр("стРасходыППЛО", 				Справочники.СтатьиСметы.РасходыППЛО);
	// 2015 06 02 
	// если в виде типовой задачи установлено, что ФОТ по оплате, то считаем статью ФОТ
	Запрос.УстановитьПараметр("РасчетФОТпоОплате", 			ЗадачаПроекта.ТиповаяЗадача.ВидТиповойЗадачи.ФОТпоОплате );
	Запрос.УстановитьПараметр("стФОТ_ПП", 					Справочники.СтатьиСметы.ФОТ_ПП);
	// 2015 06 02 
	
	
	Запрос.УстановитьПараметр("ЗадачаПроекта", 				ЗадачаПроекта);
	//
	Результат = Запрос.Выполнить().Выгрузить();
	
	СтрСм = Новый Структура;
	Если Результат.Количество() <> 0 Тогда
		СтрРез = Результат[0];
		ЗаполнитьЗначенияСвойств( СтрСм, СтрРез );
		//
		СтрСм.Вставить("ДохФинансовые", 		СтрРез.ДохФинансовые);
		СтрСм.Вставить("ДоходыВс", 				СтрРез.ДоходыВс );
		СтрСм.Вставить("ВознагрПосредника", 	СтрРез.ВознагрПосредника);
		СтрСм.Вставить("РасходыВознПосредника", СтрРез.РасходыВознПосредника);
		СтрСм.Вставить("РасходыППЛО", 			СтрРез.РасходыППЛО);
		СтрСм.Вставить("РасходыКоммерческие", 	СтрРез.РасходыКоммерческие);
		//
		// 2015 06 02 
		СтрСм.Вставить("ФОТ_ПП", 				СтрРез.ФОТ_ПП);
	
	КонецЕсли;	
	Возврат СтрСм;	
КонецФункции

&НаСервере
Функция ПолучитьСуммыЗадачиПоСмете2016( ЗадачаПроекта )
	
	//мЗадач = Объект.РасшифровкаПлатежа.Выгрузить(,"ЗадачаПроекта");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СметаЗПРасчет.Статья,
		|	СУММА(СметаЗПРасчет.Сумма) КАК Сумма,
		|	СметаЗПРасчет.Статья.ИмяПредопределенныхДанных
		|ИЗ
		|	Документ.СметаЗадачиПроекта.Расчет КАК СметаЗПРасчет
		|ГДЕ
		|	СметаЗПРасчет.Ссылка.Проведен
		|	И СметаЗПРасчет.Ссылка.ЗадачаПроекта = &ЗадачаПроекта
		|
		|СГРУППИРОВАТЬ ПО
		|	СметаЗПРасчет.Статья";

	
	Запрос.УстановитьПараметр("ЗадачаПроекта", 				ЗадачаПроекта);
	//
	Результат = Запрос.Выполнить().Выгрузить();
	
	СтрСм = Новый Структура;
	Для Каждого СтрСметы ИЗ Результат Цикл
		СтрСм.Вставить( СтрСметы.СтатьяИмяПредопределенныхДанных, СтрСметы.Сумма );
	КонецЦикла;
	Возврат СтрСм;	
КонецФункции


&НаСервере
Процедура ЗаполнитьПоЗадачиПоДоговору_НаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.РасшифровкаПлатежа.Очистить();
	Если Документ.СуммаДокумента <> 0 Тогда	
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ДоговорыЗадачиПроекта.ЗадачаПроекта,
			|	ДоговорыЗадачиПроекта.Сумма КАК СуммаОбеспечено
			|ИЗ
			|	Документ.Договор.ЗадачиПроекта КАК ДоговорыЗадачиПроекта
			|ГДЕ
			|	ДоговорыЗадачиПроекта.Ссылка = &Договор";

		//
		Запрос.УстановитьПараметр("Договор", 	Документ.Договор);

		Результат = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = Результат.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Стр = Документ.РасшифровкаПлатежа.Добавить();
			// в расшифровку платежа
			ЗаполнитьЗначенияСвойств( Стр, ВыборкаДетальныеЗаписи );
			
		КонецЦикла;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиСуммОплатыПоЗадачам()
	СуммаРаспределено 	= 0;
	СуммаНеОплачено		= 0;
	Для Каждого Стр ИЗ Объект.РасшифровкаПлатежа Цикл
		//Стр.Сумма				= Стр.ДоходыВс 			+ Стр.ВознагрПосредника + Стр.РасходыВознПосредника;
		Стр.СуммаНеОплачено		= Стр.СуммаОбеспечено 	- Стр.СуммаОплачено 	- Стр.Сумма;

		СуммаРаспределено		= СуммаРаспределено + Стр.Сумма;
		СуммаНеОплачено			= СуммаНеОплачено   + Стр.СуммаНеОплачено;
	КонецЦикла;
КонецПроцедуры

// распределяем общуй сумму платежа по задаче по статьям сметы 
// 
&НаКлиенте
Процедура РаспределитьСуммуОплатыПоСтатьям( Стр );
	
	// для одной задаче проекта
	стрСм = ПолучитьСуммыЗадачиПоСмете( Стр.ЗадачаПроекта );	
	// суммы пока - из сметы задач, т.е. коэффициенты пропорциональности
	// теперь по статьям !!!
	МассивКоэфф = Новый Массив;
	МассивКоэфф.Добавить( стрСм.ДоходыВс );
	МассивКоэфф.Добавить( стрСм.ВознагрПосредника );
	МассивКоэфф.Добавить( стрСм.РасходыВознПосредника );
	
	// сумма в строке - часть платежа (суммы документа), выделенная на задачу проекта
	мРезПоСтатьям = РаспределитьПропорционально( Стр.Сумма, МассивКоэфф);
	Если мРезПоСтатьям <> Неопределено Тогда
		Стр.ДоходыВс 				=  мРезПоСтатьям[0];
		Стр.ВознагрПосредника 		=  мРезПоСтатьям[1];
		Стр.РасходыВознПосредника 	=  мРезПоСтатьям[2];
		
		// пропроционально доходам финансовым
		// 06,05,2013
		Стр.РасходыППЛО				=  Стр.Сумма * стрСм.РасходыППЛО / стрСм.ДохФинансовые;
		Если стрСм.ДоходыВс <> Стр.РасходыППЛО Тогда
			// не вся сумма, а уменьшенная на выплату по ПП ЛО (уже расчитанную)
			// не !!! РасходыППЛО а Стр.РасходыППЛО
			Стр.РасходыКоммерческие		= стрСм.РасходыКоммерческие * (Стр.ДоходыВс - Стр.РасходыППЛО)/(стрСм.ДоходыВс - стрСм.РасходыППЛО);
			
		Иначе
			Стр.РасходыКоммерческие 	= 0;
			
		КонецЕсли;
		
		// 2015 06 02 
		// оплата ФОТ пропорционально параметру статьи
		Стр.ФОТ_ПП = Стр.Сумма * стрСм.ФОТ_ПП / стрСм.ДоходыВс;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ФотПоОплатеЗадачиПроекта( ЗадачаПроекта )
	Возврат ЗадачаПроекта.ТиповаяЗадача.ВидТиповойЗадачи.ФОТпоОплате;
КонецФункции

// колонкам ТЧ Расшифровка платежа соответствуют статьи сметы 
&НаКлиенте
Функция ПолучитьРасшифровкуПоСтатьям( ЗадачаПроекта )
	сРасшифровкаПоСтатьям = Новый Структура;
	//сРасшифровкаПоСтатьям.Вставить("ДоходыВс", 					"ДоходыВс" );
	//сРасшифровкаПоСтатьям.Вставить("ВознагрПосредника", 		"ВознагрПосредника" );
	//сРасшифровкаПоСтатьям.Вставить("РасходыВознПосредника", 	"РасходыВознПосредника" );
	сРасшифровкаПоСтатьям.Вставить("РасходыППЛО", 				"РасходыППЛО" );
	Если Объект.Дата < Дата( 2014,1,1) Тогда
		сРасшифровкаПоСтатьям.Вставить("РасходыКоммерческие", 	"РасходыКоммерческие");
	Иначе
		сРасшифровкаПоСтатьям.Вставить("РасходыКоммерческие", 	"ВознаграждениеКМ");
	КонецЕсли;
	//
	ФотПоОплате = ФотПоОплатеЗадачиПроекта( ЗадачаПроекта );
	Если ФотПоОплате Тогда
		сРасшифровкаПоСтатьям.Вставить("ФОТ_ПП", 					"ФОТ_ПП" );
	КонецЕсли;
	
	Возврат сРасшифровкаПоСтатьям;
КонецФункции

// 2016 01 26 - все платежи пропорционально смете по статьям, для которых есть колонка в таблице расшифровка платежа
&НаКлиенте
Процедура РаспределитьСуммуОплатыПоСтатьям2016( Стр )
	// только дополнительные статьи, финансируемые по оплате
	сРасшифровкаПоСтатьям 	= ПолучитьРасшифровкуПоСтатьям( Стр.ЗадачаПроекта );
	
	// для одной задаче проекта
	стрСм = ПолучитьСуммыЗадачиПоСмете2016( Стр.ЗадачаПроекта );	
	// 
	// сумма оплаты задачи проекта должна точно раскладываться на 3 части
	МассивКоэфф = Новый Массив;
	МассивКоэфф.Добавить( стрСм.ДоходыВс );
	МассивКоэфф.Добавить( стрСм.ВознагрПосредника );
	МассивКоэфф.Добавить( стрСм.РасходыВознПосредника );
	
	// сумма в строке - часть платежа (суммы документа), выделенная на задачу проекта
	мРезПоСтатьям = РаспределитьПропорционально( Стр.Сумма, МассивКоэфф);
	Если мРезПоСтатьям <> Неопределено Тогда
		Стр.ДоходыВс 				=  мРезПоСтатьям[0];
		Стр.ВознагрПосредника 		=  мРезПоСтатьям[1];
		Стр.РасходыВознПосредника 	=  мРезПоСтатьям[2];
		
		Для Каждого Эл ИЗ сРасшифровкаПоСтатьям Цикл
			// 
			Стр[Эл.Ключ] = Стр.Сумма * ( стрСм[Эл.Значение]/ стрСм.ДохФинансовые );
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура РаспределитьСуммуОплатыПоЗадачам( НовыйВариант = Ложь )
	
	Если Объект.РасшифровкаПлатежа.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	Если Объект.СуммаДокумента = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивКоэфф = Новый Массив;
	Для Каждого Стр ИЗ Объект.РасшифровкаПлатежа Цикл
		// всего сумма сметы
		МассивКоэфф.Добавить( Стр.СуммаОбеспечено  );
	КонецЦикла;
	//
	мРез = РаспределитьПропорционально( Объект.СуммаДокумента, МассивКоэфф);
	Для Каждого Стр ИЗ Объект.РасшифровкаПлатежа Цикл
		Если мРез <> Неопределено Тогда
			Стр.Сумма = мРез[Объект.РасшифровкаПлатежа.Индекс(Стр)];
		Иначе
			Стр.Сумма = 0;
		КонецЕсли;
		//
		Если НовыйВариант Тогда
			РаспределитьСуммуОплатыПоСтатьям2016( Стр );
		Иначе
			РаспределитьСуммуОплатыПоСтатьям( Стр );
		КонецЕсли;
		
	КонецЦикла;
	
	ОстаткиСуммОплатыПоЗадачам();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоЗадачиПоДоговору(Команда)
	// состав табличной части Расшифровка платежа
	ЗаполнитьПоЗадачиПоДоговору_НаСервере();
	// обеспечено
	ЗаполнитьОбеспечено_НаСервере();
	// оплачено ранее
	ЗаполнитьОплачено_НаСервере();
	//
	РаспределитьСуммуОплатыПоЗадачам();
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПриИзменении(Элемент)
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// може измениться и не хранится 
	ЗаполнитьОплачено_НаСервере();
	//
	ОстаткиСуммОплатыПоЗадачам();
	//Создано по задаче #133656 от 16.10.2018 ГумединАГ
	УстановитьДоступностьЭлементовИнтерфейса()
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ЗаполнитьОплачено_НаСервере();
	//
	ОстаткиСуммОплатыПоЗадачам();
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьОплатуПоЗадачам(Команда)
	РаспределитьСуммуОплатыПоЗадачам( Ложь );
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьОплатуПоЗадачам2016(Команда)
	РаспределитьСуммуОплатыПоЗадачам( Истина );
КонецПроцедуры


&НаКлиенте
Процедура РасшифровкаПлатежаСуммаОплатыПоЗадачеПриИзменении(Элемент)
	Стр = Элементы.РасшифровкаПлатежа.ТекущиеДанные;
	// заполняем суммами по смете для получения базы
	// 
	РаспределитьСуммуОплатыПоСтатьям( Стр );
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОбеспечено_НаСервере(  )
	тз = Объект.Договор.ЗадачиПроекта.Выгрузить();
	Для Каждого СтрО ИЗ Объект.РасшифровкаПлатежа Цикл
		СтрД = тз.Найти( СтрО.ЗадачаПроекта, "ЗадачаПроекта");
		Если СтрД <> Неопределено Тогда
			СтрО.СуммаОбеспечено = СтрД.Сумма;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОплачено_НаСервере()
    СуммаОплачено = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ОплатаРасшифровкаПлатежа.Сумма) КАК СуммаОплачено,
		|	ОплатаРасшифровкаПлатежа.ЗадачаПроекта
		|ИЗ
		|	Документ.Оплата.РасшифровкаПлатежа КАК ОплатаРасшифровкаПлатежа
		|ГДЕ
		|	ОплатаРасшифровкаПлатежа.Ссылка.Договор = &Договор
		|	И ОплатаРасшифровкаПлатежа.Ссылка.Ссылка <> &Ссылка
		|	И ОплатаРасшифровкаПлатежа.Ссылка.Проведен
		|
		|СГРУППИРОВАТЬ ПО
		|	ОплатаРасшифровкаПлатежа.ЗадачаПроекта";

	//
	Запрос.УстановитьПараметр("Договор", Объект.Договор);
	Запрос.УстановитьПараметр("Ссылка",  Объект.Ссылка);

	Результат = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрО ИЗ Объект.РасшифровкаПлатежа Цикл
		СтрР = Результат.Найти( СтрО.ЗадачаПроекта, "ЗадачаПроекта");
		Если СтрР = Неопределено Тогда 
			Продолжить; 
		КонецЕсли;
		СтрО.СуммаОплачено 		= СтрР.СуммаОплачено;
		
		СуммаОплачено 			= СуммаОплачено + СтрО.СуммаОплачено;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОбеспечено(Команда)
	ЗаполнитьОбеспечено_НаСервере();
	ЗаполнитьОплачено_НаСервере();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	//Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение 
	//И НЕ ВсеЗадачиВУказанномСтатусе( Перечисления.СтатусыПроектов2013.ВРаботе, 
	//									ТекущийОбъект.РасшифровкаПлатежа.Выгрузить(, "ЗадачаПроекта") ) Тогда
	//	Сообщить("Не все проекты в статусе " + Перечисления.СтатусыПроектов2013.ВРаботе );
	//	Отказ = Истина;
	//	Возврат;
	//КонецЕсли;
	//Вставить содержимое обработчика
КонецПроцедуры

//Создано по задаче #133079 от 07.09.2018 ГумединАГ
//Заполняем суммы актов, с учетом других оплат
&НаСервере
Процедура ЗполнитьАктыНаСервере()
	//Получаем все акты по догоовру оплаты 
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДокументУТ.Ссылка КАК Акт,
		|	ДокументУТ.СуммаДокумента КАК Сумма,
		|	ДокументУТ.Дата КАК Дата
		|ИЗ
		|	Документ.ДокументУТ КАК ДокументУТ
		|ГДЕ
		|	ДокументУТ.Договор = &Договор
		|	И ДокументУТ.Проведен = &Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата";
	
	Запрос.УстановитьПараметр("Договор", Объект.Договор);
	Запрос.УстановитьПараметр("Проведен", Истина);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	ТЧАкты = Объект.АктыВыполненныхРабот;
	ТЧАкты.Очистить();
	 
	//Сумма докумета, которая будет уменьшаться с каждой оплатой акта 
	ОставшаясяСуммаДокумента = Объект.СуммаДокумента;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		//Получаем суммы
		ОбеспеченоРанее = ПолучитьОбеспеченоРанее(ВыборкаДетальныеЗаписи.Акт);
		Обеспечено = ПолучитьОбеспечено(ВыборкаДетальныеЗаписи.Сумма, ОбеспеченоРанее, ОставшаясяСуммаДокумента);
		ОставшаясяСуммаДокумента = ОставшаясяСуммаДокумента - Обеспечено;
		НеОбеспечено =  ВыборкаДетальныеЗаписи.Сумма -Обеспечено - ОбеспеченоРанее;
		НеОбеспечено = ?(НеОбеспечено<0,0,НеОбеспечено);
		//Заполняем ТЧ
		ТЧАктыСтрока = ТЧАкты.Добавить();
		ТЧАктыСтрока.Акт = ВыборкаДетальныеЗаписи.Акт;
		ТЧАктыСтрока.СуммаАкта = ВыборкаДетальныеЗаписи.Сумма;		
		ТЧАктыСтрока.ОбеспеченоРанее = ОбеспеченоРанее;		
		ТЧАктыСтрока.Обеспечено = Обеспечено;
		ТЧАктыСтрока.НеОбеспечено = НеОбеспечено;
	КонецЦикла;
КонецПроцедуры

//Создано по задаче #133079 от 07.09.2018 ГумединАГ
//Получить сумму, которую требуется обеспечить
Функция ПолучитьОбеспечено(СуммаАкта, ОбеспеченоРанее, ОставшаясяСуммаДокумента)
	ТребуетсяОбеспечить =  СуммаАкта - ОбеспеченоРанее;	
	Результат = ОставшаясяСуммаДокумента - ТребуетсяОбеспечить;
	Результат = ?(Результат<0,ОставшаясяСуммаДокумента, ТребуетсяОбеспечить);
	Возврат Результат;
КонецФункции	

//Создано по задаче #133079 от 07.09.2018 ГумединАГ
//Получить суммы обеспечено ранее по всем оплатам кроме текущей по у актов
Функция ПолучитьОбеспеченоРанее(Акт)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОплатаАктыВыполненныхРабот.Обеспечено КАК Обеспечено,
		|	ОплатаАктыВыполненныхРабот.Ссылка КАК Оплата
		|ИЗ
		|	Документ.Оплата.АктыВыполненныхРабот КАК ОплатаАктыВыполненныхРабот
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ДокументУТ.ТаблицаОплата КАК ДокументУТТаблицаОплата
		|		ПО ОплатаАктыВыполненныхРабот.Акт = ДокументУТТаблицаОплата.Ссылка
		|ГДЕ
		|	ОплатаАктыВыполненныхРабот.Акт = &Акт
		|	И ОплатаАктыВыполненныхРабот.Ссылка <> &Оплата
		|
		|СГРУППИРОВАТЬ ПО
		|	ОплатаАктыВыполненныхРабот.Обеспечено,
		|	ОплатаАктыВыполненныхРабот.Ссылка";
	
	Запрос.УстановитьПараметр("Акт", Акт);
	Запрос.УстановитьПараметр("Оплата", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Результат = 0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Результат =  Результат + ВыборкаДетальныеЗаписи.Обеспечено;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции	

&НаКлиенте
Процедура ЗполнитьАкты(Команда)
	ЗполнитьАктыНаСервере();
КонецПроцедуры

//Создано по задаче #133656 от 16.10.2018 ГумединАГ
&НаКлиенте
Процедура УстановитьДоступностьЭлементовИнтерфейса()
	//Если ЗначениеЗаполнено(Объект.ВидДокумента) Тогда 
		//Оплата перенесена из УТ, редактирование запрещено (оплата руками не заводится) 
		ЭтаФорма.Элементы.Дата.Доступность = Ложь;
		ЭтаФорма.Элементы.Номер.Доступность = Ложь;
		ЭтаФорма.Элементы.СуммаДокумента.Доступность = Ложь;
	//КонецЕсли;		
КонецПроцедуры
