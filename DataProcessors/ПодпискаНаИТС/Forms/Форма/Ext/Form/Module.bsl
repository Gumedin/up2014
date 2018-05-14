﻿&НаСервереБезКонтекста
Функция ПолучитьПодпискиПоУсловиям( Период, Платная, БезПлатная )
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПодпискаНаИТССрезПоследних.КонтрагентПП.Владелец КАК Контрагент,
		|	ПодпискаНаИТССрезПоследних.ИТС,
		|	ПодпискаНаИТССрезПоследних.Платная,
		|	ПодпискаНаИТССрезПоследних.Количество,
		|	ПодпискаНаИТССрезПоследних.КонтрагентПП.ПрограммныйПродукт КАК ПрограммныйПродукт,
		|	КОНЕЦПЕРИОДА(ПодпискаНаИТССрезПоследних.Период, МЕСЯЦ) КАК КонецПодписки,
		|	НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПодпискаНаИТССрезПоследних.Период, МЕСЯЦ, 1-ПодпискаНаИТССрезПоследних.Количество), МЕСЯЦ) КАК НачалоПодписки,
		|	ПодпискаНаИТССрезПоследних.КонтрагентПП.Код КАК РегНомер
		|ИЗ
		|	РегистрСведений.ПодпискаНаИТС.СрезПоследних КАК ПодпискаНаИТССрезПоследних
		|ГДЕ
		|	ПодпискаНаИТССрезПоследних.Период >= &НачалоПериодаОтчета
		|	И ДОБАВИТЬКДАТЕ(ПодпискаНаИТССрезПоследних.Период, МЕСЯЦ, -ПодпискаНаИТССрезПоследних.Количество) <= &КонецПериодаОтчета
		|	И (ПодпискаНаИТССрезПоследних.Платная = &Платная
		|			ИЛИ НЕ ПодпискаНаИТССрезПоследних.Платная = &БезПлатная)
		|
		|УПОРЯДОЧИТЬ ПО
		|	КонецПодписки";
		
		
	Запрос.УстановитьПараметр("НачалоПериодаОтчета", 	Период.ДатаНачала);	
	Запрос.УстановитьПараметр("КонецПериодаОтчета", 	Период.ДатаОкончания);	
	Запрос.УстановитьПараметр("Платная", 	Платная	);	
	Запрос.УстановитьПараметр("БезПлатная", БезПлатная);
	//
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	мПодписок		 = Новый Массив;
	Для Каждого ТекПодписка ИЗ РезультатЗапроса Цикл
		сПодписка = Новый Структура;
		сПодписка.Вставить("Контрагент", 			ТекПодписка.Контрагент);
		сПодписка.Вставить("ИТС", 					ТекПодписка.ИТС);
		сПодписка.Вставить("Платная", 				ТекПодписка.Платная);
		сПодписка.Вставить("ПрограммныйПродукт", 	ТекПодписка.ПрограммныйПродукт);
		сПодписка.Вставить("КонецПодписки", 		ТекПодписка.КонецПодписки);
		сПодписка.Вставить("НачалоПодписки", 		ТекПодписка.НачалоПодписки);
		сПодписка.Вставить("РегНомер", 				ТекПодписка.РегНомер);
		мПодписок.Добавить( сПодписка );
	КонецЦикла;
	Возврат мПодписок;
	
	

КонецФункции


&НаКлиенте
Процедура СформироватьДиаграммуИТС( ДГ )
	мПодписки = ПолучитьПодпискиПоУсловиям( Период, Платные, БезПлатные);
	// цвет платной подписки
	ЦветПлатной 	= WebЦвета.СинеСерый;
	ЦветБезПлатной 	= WebЦвета.БледноЗеленый;
	
	ДГ.Очистить();
	
	//
	ДГ.АвтоОпределениеПолногоИнтервала 	= Истина;
	ДГ.ОтображениеИнтервала  			= ОтображениеИнтервалаДиаграммыГанта.Объемный;
	ДГ.ОтображениеТекстаЗначения		= ОтображениеТекстаЗначенияДиаграммыГанта.Право;
	ДГ.ОтображатьЛегенду				= Ложь;
	
	// установка шкалы времени - месяц
	ШкалаВремени 			= ДГ.ОбластьПостроения.ШкалаВремени;
	ЭлементШВ 				= ШкалаВремени.Элементы.Получить(0);
	ЭлементШВ.Единица 		= ТипЕдиницыШкалыВремени.Месяц;
	ЭлементШВ.Кратность		= 1;
	
	// 
	Серия =  ДГ.Серии.Добавить();
	
	Для Каждого Подписка ИЗ мПодписки Цикл
		Точка 				= ДГ.УстановитьТочку( Подписка.Контрагент); // + ", " + Подписка.РегНомер );
		Точка.Расшифровка	= Подписка.Контрагент;
		Точка.Текст			= СокрЛП(Подписка.Контрагент) + ", " + Подписка.РегНомер;
		
		ЗначениеДГ 			= ДГ.ПолучитьЗначение(Точка, Серия );
		Интервал			= ЗначениеДГ.Добавить();
		Интервал.Текст		= Подписка.ИТС;
		Интервал.Начало 	= Подписка.НачалоПодписки;
		Интервал.Конец 		= Подписка.КонецПодписки;
		Интервал.Цвет 		= ?(Подписка.Платная,ЦветПлатной,ЦветБезПлатной);
		
	КонецЦикла;
	
	ДГ.ПоказатьУровеньТочек();
	ДГ.Обновление = Истина;

КонецПроцедуры


&НаКлиенте
Процедура СформироватьДиаграмму(Команда)
	СформироватьДиаграммуИТС( ДиаграммаПодписки );
	
	//мПодписки = ПолучитьПодпискиПоУсловиям( Период, Платные, БезПлатные);
	//// цвет платной подписки
	//ЦветПлатной 	= WebЦвета.СинеСерый;
	//ЦветБезПлатной 	= WebЦвета.БледноЗеленый;
	//
	//ДиаграммаПодписки.Очистить();
	//
	////
	//ДиаграммаПодписки.АвтоОпределениеПолногоИнтервала 	= Истина;
	//ДиаграммаПодписки.ОтображениеИнтервала  			= ОтображениеИнтервалаДиаграммыГанта.Объемный;
	//ДиаграммаПодписки.ОтображениеТекстаЗначения			= ОтображениеТекстаЗначенияДиаграммыГанта.Право;
	//ДиаграммаПодписки.ОтображатьЛегенду					= Ложь;
	//
	//// установка шкалы времени - месяц
	//ШкалаВремени = ДиаграммаПодписки.ОбластьПостроения.ШкалаВремени;
	//ЭлементШВ 				= ШкалаВремени.Элементы.Получить(0);
	//ЭлементШВ.Единица 		= ТипЕдиницыШкалыВремени.Месяц;
	//ЭлементШВ.Кратность		= 1;
	//
	//// 
	//Серия =  ДиаграммаПодписки.Серии.Добавить();
	//
	//Для Каждого Подписка ИЗ мПодписки Цикл
	//	Точка 				= ДиаграммаПодписки.УстановитьТочку( Подписка.Контрагент); // + ", " + Подписка.РегНомер );
	//	Точка.Расшифровка	= Подписка.Контрагент;
	//	Точка.Текст			= СокрЛП(Подписка.Контрагент) + ", " + Подписка.РегНомер;
	//	
	//	ЗначениеДГ 			= ДиаграммаПодписки.ПолучитьЗначение(Точка, Серия );
	//	Интервал			= ЗначениеДГ.Добавить();
	//	Интервал.Текст		= Подписка.ИТС;
	//	Интервал.Начало 	= Подписка.НачалоПодписки;
	//	Интервал.Конец 		= Подписка.КонецПодписки;
	//	Интервал.Цвет 		= ?(Подписка.Платная,ЦветПлатной,ЦветБезПлатной);
	//	
	//КонецЦикла;
	//
	//ДиаграммаПодписки.ПоказатьУровеньТочек();
	//ДиаграммаПодписки.Обновление = Истина;

КонецПроцедуры


&НаСервере
Процедура ОбластьДиаграммы(ВыводимыйДокумент)
	Макет 		= Обработки.ПодпискаНаИТС.ПолучитьМакет("ДиаграммаИТС");
	Область		= Макет.ПолучитьОбласть();//"ОбластьДиаграммы");
	ВыводимыйДокумент.Вывести( Область );
КонецПроцедуры


&НаКлиенте
Процедура ПечатьДиаграммы(Команда)
	
	ВыводимыйДокумент = Новый ТабличныйДокумент;
	ОбластьДиаграммы( ВыводимыйДокумент );
	
	ТекущаяДиаграмма = ВыводимыйДокумент.Рисунки[0].Объект;
	//
	СформироватьДиаграммуИТС( ТекущаяДиаграмма );	
	//
	ВыводимыйДокумент.АвтоМасштаб			= Истина;
	ВыводимыйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Ландшафт;
	ВыводимыйДокумент.Показать();
	
КонецПроцедуры





