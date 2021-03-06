﻿&НаСервереБезКонтекста
Функция ПолучитьОстатокПоМенеджеру( КлиентМенеджер )
	Возврат ПолучитьОстатокКоммерческихРасходовПоМенеджеру( КлиентМенеджер );
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокВидовТиповыхЗадач()
	ВыбСпр = Справочники.ВидыТиповыхЗадач.Выбрать();
	Пока ВыбСпр.Следующий() Цикл
		ВидыТиповыхЗадач.Добавить( ВыбСпр.Ссылка, ВыбСпр.Наименование, Ложь );
	КонецЦикла;
	
	// проставлям отметки включенных в распределение типовых задач
	Если ЗначениеЗаполнено( Объект.РаспределениеПоДокументам ) Тогда
		Для каждого СтрД Из Объект.РаспределениеПоДокументам Цикл
			// есть в списке
			Элем = ВидыТиповыхЗадач.НайтиПоЗначению( СтрД.ЗадачаПроекта.ТиповаяЗадача.ВидТиповойЗадачи );
			Если Элем <> Неопределено Тогда
				Элем.Пометка = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьСписокВидовТиповыхЗадач();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКлиентМенеджеров( )
	Объект.КлиентМенеджеры.Очистить();
	
	Пользователь = ПользовательПоФизЛицу( Объект.КлиентМенеджер );
	
	мКМ = МассивКлиентМенджеров( Пользователь );
	Объект.КлиентМенеджеры.ЗагрузитьКолонку( мКМ, "КлиентМенеджер");
	//Для Каждого Сотрудник ИЗ ТСотрудники Цикл
	//	Стр = Объект.КлиентМенеджеры.Добавить();
	//	Стр.КлиентМенеджер = Сотрудник;
	//КонецЦикла;
	
КонецПроцедуры

//&НаСервере
//Процедура Распределить_НаСервере()
//	
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	Смета2013Документы.Документ.Ссылка,
//		|	Смета2013Документы.Документ.ЗадачаПроекта
//		|ПОМЕСТИТЬ СметыЗадач
//		|ИЗ
//		|	Документ.Смета.Документы КАК Смета2013Документы
//		|ГДЕ
//		|	Смета2013Документы.Ссылка.Проект.Статус = &Статус
//		|	И Смета2013Документы.Ссылка.Проект.МенеджерПроекта В(&МенеджерыПроекта)
//		|;
//		|
//		|////////////////////////////////////////////////////////////////////////////////
//		|ВЫБРАТЬ
//		|	СметаЗадачиПроектаРасчет.Сумма КАК СуммаПоСмете,
//		|	СметыЗадач.ДокументСсылка 		КАК СметаЗадачи,
//		|	СметыЗадач.ДокументЗадачаПроекта КАК ЗадачаПроекта
//		|ПОМЕСТИТЬ РасходыПоСмете
//		|ИЗ
//		|	Документ.СметаЗадачиПроекта.Расчет КАК СметаЗадачиПроектаРасчет
//		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СметыЗадач КАК СметыЗадач
//		|		ПО СметаЗадачиПроектаРасчет.Ссылка = СметыЗадач.ДокументСсылка
//		|ГДЕ
//		|	СметаЗадачиПроектаРасчет.Статья = &стРасходыКоммерческие
//		|;
//		|
//		|////////////////////////////////////////////////////////////////////////////////
//		|ВЫБРАТЬ
//		|	РасходыПоСмете.ЗадачаПроекта,
//		|	СУММА(РасходыПоСмете.СуммаПоСмете) КАК СуммаПоСмете,
//		|	СУММА(ЕСТЬNULL(ОплаченоКРзаМесяц.СуммаПриход, 0)) КАК СуммаНачислено,
//		|	СУММА(ЕСТЬNULL(ВыплаченоКРПредыдущие.СуммаРасход, 0)) КАК СуммаВыплаченоРанее,
//		|	0 КАК Сумма
//		|ИЗ
//		|	РасходыПоСмете КАК РасходыПоСмете
//		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОбеспеченоПоСтатье.Обороты(&НачалоМесяца, &КонецМесяца, , СтатьяСметы = &стРасходыКоммерческие) КАК ОплаченоКРзаМесяц
//		|		ПО РасходыПоСмете.ЗадачаПроекта = ОплаченоКРзаМесяц.ЗадачаПроекта
//		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОбеспеченоПоСтатье.Обороты(, &НачалоМесяца, , СтатьяСметы = &стРасходыКоммерческие) КАК ВыплаченоКРПредыдущие
//		|		ПО (РасходыПоСмете.ЗадачаПроекта = ОплаченоКРзаМесяц.ЗадачаПроекта)
//		|
//		|СГРУППИРОВАТЬ ПО
//		|	РасходыПоСмете.ЗадачаПроекта";

//	Запрос.УстановитьПараметр("Статус", 				Перечисления.СтатусыПроектов.ВРаботе);
//	Запрос.УстановитьПараметр("МенеджерыПроекта", 		Объект.КлиентМенеджеры.Выгрузить(,"КлиентМенеджер").ВыгрузитьКолонку("КлиентМенеджер"));
//	Запрос.УстановитьПараметр("стРасходыКоммерческие", 	Справочники.СтатьиСметы.РасходыКоммерческие);
//	// 
//	Запрос.УстановитьПараметр("НачалоМесяца", 			НачалоМесяца( Объект.ПериодРегистрации));
//	Запрос.УстановитьПараметр("КонецМесяца", 			КонецМесяца( Объект.ПериодРегистрации));

//	ДокОб = РеквизитФормыВЗначение("Объект");
//	ДокОб.Распределение.Очистить();
//	
//	// база распределения
//	тзБазаРаспр = Запрос.Выполнить().Выгрузить();
//	Для Каждого Стр из тзБазаРаспр Цикл
//		// базой распределения является сумма начислено
//		//Если Стр.СуммаНачислено <> 0 Тогда
//			СтрДок = ДокОб.Распределение.Добавить();
//			ЗаполнитьЗначенияСвойств( СтрДок, Стр );
//		//КонецЕсли;
//	КонецЦикла;
//	
//	ЗначениеВРеквизитФормы(ДокОб, "Объект");
//КонецПроцедуры

//&НаКлиенте
//Процедура ПересчетСтроки(Стр)
//	Стр.ОстатокКВыплате = Стр.СуммаПоСмете 		- Стр.СуммаВыплаченоРанее;
//	Стр.СуммаОстаток 	= Стр.ОстатокКВыплате 	- Стр.СуммаВыплаченоРанее + Стр.СуммаНачислено - Стр.Сумма;
//КонецПроцедуры

//&НаКлиенте
//Процедура РаспределитьСуммуПоБазе()
//	// 
//	мКоэффКР 	= Новый Массив;
//	Для Каждого Стр ИЗ Объект.Распределение Цикл
//		мКоэффКР.Добавить( Стр.СуммаНачислено );	
//	КонецЦикла;
//	мКР			= ОбщегоНазначенияУТ.РаспределитьПропорционально( Объект.СуммаДокумента, мКоэффКР);
//	Для Каждого Стр ИЗ Объект.Распределение Цикл
//		Если мКР = Неопределено Тогда
//			Стр.Сумма = 0;
//		Иначе
//			Стр.Сумма = мКР[ Объект.Распределение.Индекс( Стр )];
//		КонецЕсли;
//	КонецЦикла;
//	
//	//
//	ПересчетСтрок();
//	
//КонецПроцедуры


//&НаКлиенте
//Процедура Распределить(Команда)
//	Если Объект.КлиентМенеджер.Пустая() Тогда
//		Предупреждение("Укажите клиент менеджера!", 10);
//		Возврат;
//	КонецЕсли;
//	Распределить_НаСервере();
//	
//	//
//	РаспределитьСуммуПоБазе();
//	
//КонецПроцедуры

&НаКлиенте
Процедура КлиентМенеджерПриИзменении(Элемент)
	Объект.Распределение.Очистить();
	//
	ЗаполнитьСписокКлиентМенеджеров();
	//
	//УстановитьОстатокСуммы();
КонецПроцедуры

//&НаКлиенте
//Процедура РаспределениеПриИзменении(Элемент)
//	//
//	//РаспределитьСуммуПоБазе();
//		

//КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	Объект.ПериодРегистрации = НачалоМесяца( Объект.ПериодРегистрации );
КонецПроцедуры

//&НаКлиенте
//Процедура РаспределениеСуммаПриИзменении(Элемент)
//	Объект.СуммаДокумента = Объект.Распределение.Итог("Сумма");
//КонецПроцедуры


&НаКлиенте
Процедура СнятьФлажки(Команда)
	ВидыТиповыхЗадач.ЗаполнитьПометки( Ложь );
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	ВидыТиповыхЗадач.ЗаполнитьПометки( Истина );
КонецПроцедуры

//********************************************************************************************
// Новое распределение ПО ДОКУМЕНТАМ
// включая типовые задачи без актов
&НаСервере
Процедура РаспределитьПоДокументам_НаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Акт.ЗадачаПроекта.Владелец КАК Проект,
		|	Акт.ЗадачаПроекта,
		|	Акт.Ссылка КАК Акт,
		|	Акт.Ссылка.Менеджер,
		|	СУММА(Акт.СуммаВознаграждения) КАК СуммаКРпоАкту,
		|	Акт.Ссылка.Оплата
		|ПОМЕСТИТЬ АктыЗаПериод
		|ИЗ
		|	Документ.ДокументУТ.КоммерческоеВознаграждение КАК Акт
		|ГДЕ
		|	НЕ Акт.Ссылка.Аванс
		|	И Акт.Ссылка.Оплата <> ЗНАЧЕНИЕ(Документ.Оплата.ПустаяСсылка)
		|	И Акт.Ссылка.Оплата.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И Акт.Ссылка.Менеджер <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
		|	И Акт.Ссылка.Проведен
		|	И Акт.Ссылка.Оплата.Проведен
		|	И Акт.ЗадачаПроекта.ТиповаяЗадача.ВидТиповойЗадачи В(&ОтмеченныеВидыТЗ)
		|	И Акт.Ссылка.Менеджер В(&МенеджерыПроекта)
		|
		|СГРУППИРОВАТЬ ПО
		|	Акт.ЗадачаПроекта,
		|	Акт.Ссылка,
		|	Акт.ЗадачаПроекта.Владелец,
		|	Акт.Ссылка.Менеджер,
		|	Акт.Ссылка.Оплата
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Акт.ЗадачаПроекта.Владелец,
		|	Акт.ЗадачаПроекта,
		|	Акт.Ссылка,
		|	Акт.Ссылка.Менеджер,
		|	СУММА(Акт.СуммаВознаграждения),
		|	ЗНАЧЕНИЕ(Документ.Оплата.ПустаяСсылка)
		|ИЗ
		|	Документ.ДокументУТ.КоммерческоеВознаграждение КАК Акт
		|ГДЕ
		|	Акт.Ссылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И Акт.Ссылка.Менеджер <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
		|	И Акт.Ссылка.Аванс
		|	И Акт.ЗадачаПроекта.ТиповаяЗадача.ВидТиповойЗадачи В(&ОтмеченныеВидыТЗ)
		|	И Акт.Ссылка.Менеджер В(&МенеджерыПроекта)
		|	И Акт.Ссылка.Проведен
		|	И Акт.Ссылка.Оплата = ЗНАЧЕНИЕ(Документ.Оплата.ПустаяСсылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	Акт.Ссылка,
		|	Акт.ЗадачаПроекта,
		|	Акт.ЗадачаПроекта.Владелец,
		|	Акт.Ссылка.Менеджер
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Акт.ЗадачаПроекта.Владелец,
		|	Акт.ЗадачаПроекта,
		|	Акт.Ссылка,
		|	Акт.Ссылка.Менеджер,
		|	СУММА(Акт.СуммаВознаграждения),
		|	Акт.Ссылка.Оплата
		|ИЗ
		|	Документ.ДокументУТ.КоммерческоеВознаграждение КАК Акт
		|ГДЕ
		|	Акт.Ссылка.Аванс
		|	И Акт.Ссылка.Оплата <> ЗНАЧЕНИЕ(Документ.Оплата.ПустаяСсылка)
		|	И Акт.Ссылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И Акт.Ссылка.Менеджер <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
		|	И Акт.Ссылка.Проведен
		|	И Акт.Ссылка.Оплата.Проведен
		|	И Акт.ЗадачаПроекта.ТиповаяЗадача.ВидТиповойЗадачи В(&ОтмеченныеВидыТЗ)
		|	И Акт.Ссылка.Менеджер В(&МенеджерыПроекта)
		|
		|СГРУППИРОВАТЬ ПО
		|	Акт.ЗадачаПроекта,
		|	Акт.Ссылка,
		|	Акт.Ссылка.Менеджер,
		|	Акт.Ссылка.Оплата,
		|	Акт.ЗадачаПроекта.Владелец
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	АктыЗаПериод.Проект,
		|	АктыЗаПериод.ЗадачаПроекта,
		|	АктыЗаПериод.Акт,
		|	АктыЗаПериод.Менеджер,
		|	АктыЗаПериод.СуммаКРпоАкту,
		|	СУММА(ЕСТЬNULL(ВыплатыКР.Сумма, 0)) КАК Сумма,
		|	АктыЗаПериод.Оплата
		|ПОМЕСТИТЬ АктОплаченные
		|ИЗ
		|	АктыЗаПериод КАК АктыЗаПериод
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаВыплатуКоммРасходов.РаспределениеПоДокументам КАК ВыплатыКР
		|		ПО АктыЗаПериод.ЗадачаПроекта = ВыплатыКР.ЗадачаПроекта
		|			И АктыЗаПериод.Оплата = ВыплатыКР.Оплата
		|
		|СГРУППИРОВАТЬ ПО
		|	АктыЗаПериод.Проект,
		|	АктыЗаПериод.ЗадачаПроекта,
		|	АктыЗаПериод.Акт,
		|	АктыЗаПериод.Менеджер,
		|	АктыЗаПериод.СуммаКРпоАкту,
		|	АктыЗаПериод.Оплата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	АктОплаченные.Проект КАК Проект,
		|	АктОплаченные.ЗадачаПроекта КАК ЗадачаПроекта,
		|	АктОплаченные.Акт,
		|	АктОплаченные.Менеджер,
		|	АктОплаченные.СуммаКРпоАкту,
		|	АктОплаченные.Сумма,
		|	АктОплаченные.Оплата,
		|	СУММА(ОплатаЗадач.РасходыКоммерческие) КАК СуммаКРпоОплате
		|ИЗ
		|	АктОплаченные КАК АктОплаченные
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Оплата.РасшифровкаПлатежа КАК ОплатаЗадач
		|		ПО АктОплаченные.ЗадачаПроекта = ОплатаЗадач.ЗадачаПроекта
		|			И АктОплаченные.Оплата = ОплатаЗадач.Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	АктОплаченные.ЗадачаПроекта,
		|	АктОплаченные.Акт,
		|	АктОплаченные.Менеджер,
		|	АктОплаченные.Оплата,
		|	АктОплаченные.Проект,
		|	АктОплаченные.СуммаКРпоАкту,
		|	АктОплаченные.Сумма
		|
		|УПОРЯДОЧИТЬ ПО
		|	Проект,
		|	ЗадачаПроекта";

		
	Запрос.УстановитьПараметр("ТекущийДокумент", 		Объект.Ссылка);
	//
	ОтмеченныеВидыТЗ = Новый Массив;
	Для Каждого Эл ИЗ ВидыТиповыхЗадач Цикл
		Если Эл.Пометка Тогда
			ОтмеченныеВидыТЗ.Добавить( Эл.Значение );
		КонецЕсли;
	КонецЦикла;
	Запрос.УстановитьПараметр("ОтмеченныеВидыТЗ",		ОтмеченныеВидыТЗ);
	
	Запрос.УстановитьПараметр("МенеджерыПроекта", 		Объект.КлиентМенеджеры.Выгрузить(,"КлиентМенеджер").ВыгрузитьКолонку("КлиентМенеджер"));
	Запрос.УстановитьПараметр("ДатаНачала", 			НачалоМесяца( Объект.ПериодРегистрации));
	Запрос.УстановитьПараметр("ДатаОкончания", 			КонецМесяца( Объект.ПериодРегистрации));

	// готовим 
	ДокОб = РеквизитФормыВЗначение("Объект");
	ДокОб.РаспределениеПоДокументам.Очистить();
	
	// база распределения
	тзБазаРаспр = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Стр из тзБазаРаспр Цикл
			СтрДок = ДокОб.РаспределениеПоДокументам.Добавить();
			ЗаполнитьЗначенияСвойств( СтрДок, Стр );
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДокОб, "Объект");
КонецПроцедуры

//&НаКлиенте
//Процедура ПересчетСтроки_ПоДокументам(Стр)
//	Стр.СуммаОстаток 	= Стр.СуммаКРПоАкту - Стр.СуммаВыплачено; // + Стр.СуммаНачислено - Стр.Сумма;
//КонецПроцедуры

//&НаКлиенте
//Процедура ПересчетСтрок_ПоДокументам()
//	Для Каждого Стр ИЗ Объект.РаспределениеПоДокументам Цикл
//		ПересчетСтроки_ПоДокументам(Стр);
//	КонецЦикла;
//КонецПроцедуры

//&НаКлиенте
//Процедура РаспределитьПоДокументам_СуммуПоБазе()
//	мКоэффКР 	= Новый Массив;
//	Для Каждого Стр ИЗ Объект.РаспределениеПоДокументам Цикл
//		мКоэффКР.Добавить( Стр.СуммаКРпоАкту);	
//	КонецЦикла;
//	// с учетом аванса
//	СуммаКРаспределению = Объект.СуммаДокумента - Объект.СуммаАванса;
//	мКР					= РаспределитьПропорционально( СуммаКРаспределению, мКоэффКР);
//	
//	Для Каждого Стр ИЗ Объект.РаспределениеПоДокументам Цикл
//		Если мКР = Неопределено Тогда
//			Стр.Сумма = 0;
//		Иначе
//			Стр.Сумма = мКР[ Объект.РаспределениеПоДокументам.Индекс( Стр )];
//		КонецЕсли;
//	КонецЦикла;
//	//
//	ПересчетСтрок_ПоДокументам();
//КонецПроцедуры

&НаКлиенте
Процедура ПолныйПересчетРаспределенияПоДокументам()
	//
	РаспределитьПоДокументам_НаСервере();
	
	ЭтаФорма.Модифицированность=Истина;
	//Если Объект.РаспределениеПоДокументам.Итог("СуммаКРпоАкту") = 0 Тогда 
	//	Предупреждение("Нет базы распределения!", 10);
	//	Возврат;
	//КонецЕсли;
	//
	////
	//РаспределитьПоДокументам_СуммуПоБазе();
КонецПроцедуры


&НаКлиенте
Процедура РаспределитьПоДокументам(Команда)
	ПолныйПересчетРаспределенияПоДокументам();
КонецПроцедуры

&НаКлиенте
Процедура СуммаДокументаПриИзменении(Элемент)
	ПолныйПересчетРаспределенияПоДокументам();
КонецПроцедуры

//&НаКлиенте
//Процедура РаспределениеПоДокументамСуммаПриИзменении(Элемент)
//	Стр = Элементы.РаспределениеПоДокументам.ТекущиеДанные;
//	Стр.СуммаОстаток		= Стр.СуммаВыплачено - Стр.Сумма;
//	Объект.СуммаДокумента 	= Объект.РаспределениеПоДокументам.Итог("Сумма");
//	
//	
//	
//КонецПроцедуры

//&НаСервере
//Процедура ЗаполнитьЗадачи_НаСервере()
//	// список задач проектов по менеджерам и типам задач, не включенным в закладку ПоДокументам

//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	ЗадачиПроектов.Ссылка КАК ЗадачаПроекта
//		|ИЗ
//		|	Справочник.ЗадачиПроектов КАК ЗадачиПроектов
//		|ГДЕ
//		|	ЗадачиПроектов.Владелец.Статус = &Статус
//		|	И ЗадачиПроектов.ТиповаяЗадача.ВидТЗ В(&ОтмеченныеВидыТЗ)
//		|	И ЗадачиПроектов.Владелец.МенеджерПроекта В(&МенеджерыПроекта)
//		|	И НЕ ЗадачиПроектов.Ссылка В (&мЗадачиПроекта)";

//		
//	Запрос.УстановитьПараметр("Статус", 				Перечисления.СтатусыПроектов2013.ВРаботе);
//	//
//	ОтмеченныеВидыТЗ = Новый Массив;
//	Для Каждого Эл ИЗ ВидыТиповыхЗадач Цикл
//		Если Эл.Пометка Тогда
//			ОтмеченныеВидыТЗ.Добавить( Эл.Значение );
//		КонецЕсли;
//	КонецЦикла;
//	Запрос.УстановитьПараметр("ОтмеченныеВидыТЗ",		ОтмеченныеВидыТЗ);
//	Запрос.УстановитьПараметр("МенеджерыПроекта", 		Объект.КлиентМенеджеры.Выгрузить(,"КлиентМенеджер").ВыгрузитьКолонку("КлиентМенеджер"));
//	Запрос.УстановитьПараметр("мЗадачиПроекта", 		Объект.РаспределениеПоДокументам.Выгрузить(,"ЗадачаПроекта").ВыгрузитьКолонку("ЗадачаПроекта"));

//	Результат = Запрос.Выполнить().Выгрузить();
//	
//	//
//	Док = РеквизитФормыВЗначение("Объект");
//	Док.Авансы.Очистить();
//	
//	Для Каждого СтрРез ИЗ Результат Цикл
//		Если Док.Авансы.Найти( СтрРез.ЗадачаПроекта, "ЗадачаПроекта") = Неопределено Тогда
//			СтрДок = Док.Авансы.Добавить();
//			ЗаполнитьЗначенияСвойств( СтрДок, СтрРез );
//		КонецЕсли;
//	КонецЦикла;
//	
//	ЗначениеВРеквизитФормы(Док, "Объект");
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ЗаполнитьЗадачиДляАванса(Команда)
//	ЗаполнитьЗадачи_НаСервере();	
//КонецПроцедуры

//&НаКлиенте
//Процедура АвансыПриИзменении(Элемент)
//	Объект.СуммаАванса = Объект.Авансы.Итог("Сумма");
//КонецПроцедуры

//&НаСервере
//Процедура УбратьНулевыеАвансыСервере()
//	Док = РеквизитФормыВЗначение("Объект");
//	тзАвансы = Док.Авансы.Выгрузить();
//	Док.Авансы.Очистить();
//	Для каждого стрА Из тзАвансы Цикл
//		Если стрА.Сумма <> 0 Тогда
//			стрД = Док.Авансы.Добавить();
//			ЗаполнитьЗначенияСвойств(СтрД, СтрА );
//		КонецЕсли;
//	КонецЦикла;
//	ЗначениеВРеквизитФормы( Док, "Объект");
//КонецПроцедуры

//&НаКлиенте
//Процедура УбратьНулевыеСуммы(Команда)
//	УбратьНулевыеАвансыСервере();
//КонецПроцедуры
