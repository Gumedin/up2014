﻿&НаКлиенте
Процедура ПересчетСуммГрафикаПлатежей( Вариант = 1 )
	//СуммаРаспределено = 0;
	Если Объект.ЭтапыГрафикаОплаты.Количество() <> 0 Тогда
		// последняя строка
		Стр = Объект.ЭтапыГрафикаОплаты[Объект.ЭтапыГрафикаОплаты.Количество()-1];
		Стр.СуммаПлатежа   = Объект.СуммаДокумента;
		
		// вариант 1, сумма от процентов
		Для Н = 0 ПО Объект.ЭтапыГрафикаОплаты.Количество()-2 Цикл
			СтрН 				= Объект.ЭтапыГрафикаОплаты[Н];
			Если Вариант = 1 Тогда
				СтрН.СуммаПлатежа	= Объект.СуммаДокумента * СтрН.ПроцентПлатежа /100;
			Иначе
				СтрН.ПроцентПлатежа	= СтрН.СуммаПлатежа/Объект.СуммаДокумента * 100;
			КонецЕсли;
			
			//СуммаРаспределено 	= СуммаРаспределено + СтрН.СуммаПлатежа;
			Стр.СуммаПлатежа   	= Стр.СуммаПлатежа 	- СтрН.СуммаПлатежа;
		КонецЦикла;
		
		// 
		//СуммаРаспределено 	= СуммаРаспределено + Стр.СуммаПлатежа;
	КонецЕсли;
КонецПроцедуры

//Создано 11.05.2018 Гумединым А.Г. по задаче #129069
&НаКлиенте
Процедура ПересчетСуммГрафикаПлатежей_ПоЗадачам( Вариант = 1,  Сумма, ЗадачаПроекта)
	//СуммаРаспределено = 0;
	Если Объект.ЭтапыГрафикаОплаты.Количество() <> 0 Тогда		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ЗадачаПроекта", ЗадачаПроекта); 
		ГрафикиОплаты = Объект.ЭтапыГрафикаОплаты.НайтиСтроки(ПараметрыОтбора);
		
		// последняя строка
		Стр = ГрафикиОплаты[ГрафикиОплаты.Количество()-1];
		Стр.СуммаПлатежа = Сумма;
		
		// вариант 1, сумма от процентов
		Для Н = 0 ПО (ГрафикиОплаты.Количество() - 2) Цикл
			СтрН = ГрафикиОплаты[Н];
			Если Вариант = 1 Тогда
				СтрН.СуммаПлатежа	= Сумма * СтрН.ПроцентПлатежа /100;
			Иначе
				СтрН.ПроцентПлатежа	= СтрН.СуммаПлатежа/Сумма * 100;
			КонецЕсли;
			  
			Стр.СуммаПлатежа = Стр.СуммаПлатежа - СтрН.СуммаПлатежа;
		КонецЦикла;		
	КонецЕсли;
КонецПроцедуры

//*****************************************************
// при изменении процента в строке, в т.ч. удалении или добавлении строки
// баланс в 100% складывается в последнюю строку
&НаКлиенте
Процедура БалансПроцентовИСумм( Вариант = 1)
	Если Объект.ЭтапыГрафикаОплаты.Количество() <> 0 Тогда
		//
		ИтогоПроцент = Объект.ЭтапыГрафикаОплаты.Итог("ПроцентПлатежа");
		Стр = Объект.ЭтапыГрафикаОплаты[Объект.ЭтапыГрафикаОплаты.Количество()-1];
		Стр.ПроцентПлатежа = Стр.ПроцентПлатежа + (100-ИтогоПроцент);
		// чтобы округлить
		ПересчетСуммГрафикаПлатежей( Вариант );
	КонецЕсли;
КонецПроцедуры

//Создано 11.05.2018 Гумединым А.Г. по задаче #129069
&НаКлиенте
Процедура БалансПроцентовИСумм_ПоЗадачам( Вариант = 1, Сумма, ЗадачаПроекта)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ЗадачаПроекта", ЗадачаПроекта); 
	ГрафикиОплаты = Объект.ЭтапыГрафикаОплаты.НайтиСтроки(ПараметрыОтбора);
	
	ИтогоПроцент = 0;
	Для Каждого ГрафикОплаты ИЗ ГрафикиОплаты Цикл
		ИтогоПроцент = ИтогоПроцент + ГрафикОплаты.ПроцентПлатежа;		
	КонецЦикла;
	
	Если ГрафикиОплаты.Количество() <> 0 Тогда
		//
		Стр = ГрафикиОплаты[ГрафикиОплаты.Количество()-1];
		Стр.ПроцентПлатежа = Стр.ПроцентПлатежа + (100-ИтогоПроцент);
		// чтобы округлить
		ПересчетСуммГрафикаПлатежей_ПоЗадачам( Вариант , Сумма, ЗадачаПроекта);
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	//Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение 
	//И	НЕ ВсеЗадачиВУказанномСтатусе( Перечисления.СтатусыПроектов2013.ВРаботе, 
	//									ТекущийОбъект.ЗадачиПроекта.Выгрузить(, "ЗадачаПроекта") ) Тогда
	//	Сообщить("Не все проекты в статусе " + Перечисления.СтатусыПроектов2013.ВРаботе );
	//	Отказ = Истина;
	//	Возврат;
	//КонецЕсли;
	// 
	Если Объект.ЗадачиПроекта.Итог("Сумма" ) <> Объект.СуммаДокумента Тогда
		Сообщить("Сумма документа не полностью распределена по задачам!");
	КонецЕсли;
	
КонецПроцедуры

//Изменено 14.05.2015 Гумединым А.Г. по задаче #129069
&НаКлиенте
Процедура Аванс30Проц(Команда)
	РаспределитьПлатежи( 3 );
	
	Для Каждого ЗадачаПроекта из Объект.ЗадачиПроекта Цикл 
		// ставим процент платежей
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ЗадачаПроекта", ЗадачаПроекта.ЗадачаПроекта); 
		ЭтапГрафикаОплаты = Объект.ЭтапыГрафикаОплаты.НайтиСтроки(ПараметрыОтбора)[0];	
		ЭтапГрафикаОплаты.ПроцентПлатежа = 30;
		
		//Формирование сумм и процентов по задачам проекта 
		БалансПроцентовИСумм_ПоЗадачам(1, ЗадачаПроекта.Сумма, ЗадачаПроекта.ЗадачаПроекта);
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьПлатежи( Вариант )
	Если Объект.СуммаДокумента = 0 Тогда
		Предупреждение("Не указана сумма к распределению!", 10);
		Возврат;
	КонецЕсли;
	Если Объект.ЭтапыГрафикаОплаты.Количество() <> 0 Тогда
		Если Вопрос("Текущее распределение будет очищено, продолжить?", РежимДиалогаВопрос.ДаНет)=КодВозвратаДиалога.Да	Тогда
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	СписокПериодов = СписокПериодовРаспределения(Вариант);
	Если СписокПериодов.Количество() = 0 Тогда
		Предупреждение("Неправильно выбран период!", 10);
		Возврат;
	КонецЕсли;
	//Добавлено 11.05.2015 Гумединым А.Г. по задаче #129069
	Если Объект.ЗадачиПроекта.Количество() = 0 Тогда
		Предупреждение("Отсутствуют задачи для распределения", 10);
		Возврат;
	КонецЕсли;
	
	Объект.ЭтапыГрафикаОплаты.Очистить();
	Для Каждого ЗадачаПроекта из Объект.ЗадачиПроекта Цикл  
		
		СписокПериодовПоЗадачам = СписокПериодовРаспределения_ПоЗадачам(Вариант, ЗадачаПроекта.ЗадачаПроекта);
		
		РаспределитьПоВарианту( СписокПериодовПоЗадачам , ЗадачаПроекта.ЗадачаПроекта);
		//Формирование сумм и процентов по задачам проекта 
		БалансПроцентовИСумм_ПоЗадачам(1, ЗадачаПроекта.Сумма, ЗадачаПроекта.ЗадачаПроекта);
	КонецЦикла;
	////////////////////////////////////////////////////////////
КонецПроцедуры

&НаКлиенте
Функция СписокПериодовРаспределения(Вариант)
	СпПериодов = Новый СписокЗначений;
	Если 		Вариант = 1 Тогда 
	// по месяцам, с учетом смещения !!!
		ДН = ДобавитьМесяц( НачалоМесяца( ПериодРаспределения.ДатаНачала ), Смещение );
		ДК = ДобавитьМесяц( НачалоМесяца( ПериодРаспределения.ДатаОкончания), Смещение );
		Пока ДН <=  ДК Цикл
			СпПериодов.Добавить( ДН );
			ДН = ДобавитьМесяц( ДН, 1);
		КонецЦикла;
	ИначеЕсли 	Вариант = 2 Тогда
	// по кварталам, с учетом смещения !!!
		ДН = ДобавитьМесяц( НачалоКвартала( ПериодРаспределения.ДатаНачала ), 	Смещение );
		ДК = ДобавитьМесяц( НачалоКвартала( ПериодРаспределения.ДатаОкончания), Смещение );
		Пока ДН <=  ДК Цикл
			СпПериодов.Добавить( ДН );
			ДН = ДобавитьМесяц( ДН, 3);
		КонецЦикла;
		
	ИначеЕсли	Вариант = 3 Тогда
	// аванс - первый месяц + смещение
		Д1 = ДобавитьМесяц( НачалоМесяца( ПериодРаспределения.ДатаНачала ), Смещение );
		СпПериодов.Добавить( Д1 );
		Д2 = ДобавитьМесяц( НачалоМесяца( ПериодРаспределения.ДатаОкончания ),1);
		СпПериодов.Добавить( Д2 );
		
		
	КонецЕсли;

    Возврат СпПериодов;
	
КонецФункции

//Добавлено 14.05.2015 Гумединым А.Г. по задаче #129069
&НаСервере
Функция СписокПериодовРаспределения_ПоЗадачам(Вариант, ЗадачаПроекта)
	СпПериодов = Новый СписокЗначений;
	
	Если Объект.Фиктивный Тогда
		ДатаНачалаРабот = ТекущаяДата();
		Если ЗадачаПроекта.ОкончаниеРабот = Дата(1,1,1) Тогда 
			Сообщить("Не заполнена дата окончания работ по задаче " + ЗадачаПроекта.Наименование);
		ИначеЕсли ДатаНачалаРабот>ЗадачаПроекта.ОкончаниеРабот Тогда
			Сообщить("Дата начала работ (текущая дата) меньше даты окончания работ по задаче " + ЗадачаПроекта.Наименование);
		КонецЕсли;		
	Иначе	
		ДатаНачалаРабот = ЗадачаПроекта.НачалоРабот;
	КонецЕсли;	
	
	Если Вариант = 1 Тогда 
	// по месяцам, с учетом смещения !!!
		ДН = ДобавитьМесяц( НачалоМесяца( ДатаНачалаРабот ), Смещение );
		ДК = ДобавитьМесяц( НачалоМесяца( ЗадачаПроекта.ОкончаниеРабот), Смещение );
		Пока ДН <=  ДК Цикл
			СпПериодов.Добавить( ДН );
			ДН = ДобавитьМесяц( ДН, 1);
		КонецЦикла;
	ИначеЕсли 	Вариант = 2 Тогда
		// по кварталам, с учетом смещения !!!
		ДН = ДобавитьМесяц( НачалоКвартала( ДатаНачалаРабот ), 	Смещение );
		ДК = ДобавитьМесяц( НачалоКвартала( ЗадачаПроекта.ОкончаниеРабот ), Смещение );
		
		//Ошибки в Догворах [#129886]
		// Если фиктивный, то начиная со следующего квартала
		Если Объект.Фиктивный Тогда
			ДН = КонецКвартала( ДатаНачалаРабот ) + 1;
			
			Если (ДН > ДК) И (ДК > ДатаНачалаРабот) Тогда 
				//Дата начала с учетом перехода в следующий квартал меньше даты завершения работ
				// но больше текущей даты
				ДН = НачалоМесяца(ДК);
			КонецЕсли;
		КонецЕсли;
		
		Пока ДН <=  ДК Цикл
			СпПериодов.Добавить( ДН );
			ДН = ДобавитьМесяц( ДН, 3);
		КонецЦикла;
		
	ИначеЕсли	Вариант = 3 Тогда
	// аванс - первый месяц + смещение
		Д1 = ДобавитьМесяц( НачалоМесяца( ДатаНачалаРабот ), Смещение );
		СпПериодов.Добавить( Д1 );
		Д2 = ДобавитьМесяц( НачалоМесяца( ЗадачаПроекта.ОкончаниеРабот ),1);
		СпПериодов.Добавить( Д2 );	
	КонецЕсли;
	
    Возврат СпПериодов;	
КонецФункции


// 1 - по месяцам, начиная с начала периода до конца
// 2 - по кварталам
//Изменено 14.05.2015 Гумединым А.Г. по задаче #129069
&НаСервере
Процедура РаспределитьПоВарианту( СпПериодов , ЗадачаПроекта)
	//    		
	СпрОб = РеквизитФормыВЗначение("Объект");

	ПроцентовКРаспределению  = 100;
	
	Если СпПериодов.Количество() = 0 Тогда 
		Сообщить("Количество периодов равно 0, невозможно сформировать график!");
	Иначе		
		Процент = 100/СпПериодов.Количество();
		Для Каждого Эл ИЗ СпПериодов Цикл
			Стр = СпрОб.ЭтапыГрафикаОплаты.Добавить();
			Стр.ЗадачаПроекта = ЗадачаПроекта;
			Стр.ДатаПлатежа = Эл.Значение; 
			Если СпПериодов.Индекс( Эл ) = СпПериодов.Количество() - 1 Тогда
			// последний период
				Стр.ПроцентПлатежа = ПроцентовКРаспределению;
			Иначе
				Стр.ПроцентПлатежа = Процент;
				ПроцентовКРаспределению = ПроцентовКРаспределению - Стр.ПроцентПлатежа;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(СпрОб, "Объект");
	
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьПоКварталам(Команда)
	РаспределитьПлатежи( 2 );
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьПоМесяцам(Команда)
	РаспределитьПлатежи(  1);
КонецПроцедуры

//Изменено 11.05.2018 Гумединым А.Г. по задаче #129069
&НаКлиенте
Процедура ЭтапыГрафикаОплатыПроцентПлатежаПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ЗадачаПроекта", ЭтаФорма.ТекущийЭлемент.ТекущиеДанные.ЗадачаПроекта); 
	ЗадачаПроекта = Объект.ЗадачиПроекта.НайтиСтроки(ПараметрыОтбора)[0];
	
	БалансПроцентовИСумм_ПоЗадачам(1, ЗадачаПроекта.Сумма, ЗадачаПроекта.ЗадачаПроекта);
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыСуммаПлатежаПриИзменении(Элемент)
	//Изменено 14.05.2018 Гумединым А.Г. по задачче #129069
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ЗадачаПроекта", ЭтаФорма.ТекущийЭлемент.ТекущиеДанные.ЗадачаПроекта); 
	ЗадачаПроекта = Объект.ЗадачиПроекта.НайтиСтроки(ПараметрыОтбора)[0];
	
	Стр = Элементы.ЭтапыГрафикаОплаты.ТекущиеДанные;
	//
	Стр.ПроцентПлатежа = Стр.СуммаПлатежа / ЗадачаПроекта.Сумма * 100;

	БалансПроцентовИСумм_ПоЗадачам(2, ЗадачаПроекта.Сумма, ЗадачаПроекта.ЗадачаПроекта);
	////////////////////////////////////////////////////////
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПериодРаспределения.Вариант=ВариантСтандартногоПериода.ЭтотГод;
	ЗаполнитьОбеспеченоРанее();
	ПересчетТаблицыЗадач();
КонецПроцедуры


//// кроме
//&НаСервереБезКонтекста
//Функция РанееОбеспеченоПоДоговору( Документ )

//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	СУММА(ДоговорыЗадачиПроекта.Сумма) КАК Сумма,
//		|	ДоговорыЗадачиПроекта.ЗадачаПроекта
//		|ИЗ
//		|	Документ.Договор.ЗадачиПроекта КАК ДоговорыЗадачиПроекта
//		|ГДЕ
//		|	ДоговорыЗадачиПроекта.ЗадачаПроекта В
//		|			(ВЫБРАТЬ
//		|				ДоговорыЗадачиПроекта.ЗадачаПроекта
//		|			ИЗ
//		|				Документ.Договор.ЗадачиПроекта КАК ДоговорыЗадачиПроекта
//		|			ГДЕ
//		|				ДоговорыЗадачиПроекта.Ссылка = &Документ)
//		|	И ДоговорыЗадачиПроекта.Ссылка.Проведен
//		|	И ДоговорыЗадачиПроекта.Ссылка.Ссылка <> &Документ
//		|
//		|СГРУППИРОВАТЬ ПО
//		|	ДоговорыЗадачиПроекта.ЗадачаПроекта";

//	//
//	Запрос.УстановитьПараметр("Документ", Документ );

//	Результат = Запрос.Выполнить().Выгрузить();
//	Возврат Результат;
//КонецФункции


//&НаКлиенте
//Процедура ЗаполнитьОбеспеченоРанее()
//	// обеспечено другими договорами
//	тз = РанееОбеспеченоПоДоговору( Объект.Ссылка );

//	//
//	Для Каждого СтрОб ИЗ Объект.ЗадачиПроекта Цикл
//		СтрРез = тз.Найти( СтрОб.ЗадачаПроекта, "ЗадачаПроекта");
//		Если СтрРез <> Неопределено Тогда
//			СтрОб.СуммаОбеспечено 	= СтрРез.Сумма;
//		КонецЕсли;
//	КонецЦикла;
//	
//КонецПроцедуры

// исправлено для тонкого клиента
&НаСервереБезКонтекста
Функция РанееОбеспеченоПоДоговору( Документ )

	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	СУММА(ДоговорыЗадачиПроекта.Сумма) КАК Сумма,
//		|	ДоговорыЗадачиПроекта.ЗадачаПроекта
//		|ИЗ
//		|	Документ.Договор.ЗадачиПроекта КАК ДоговорыЗадачиПроекта
//		|ГДЕ
//		|	ДоговорыЗадачиПроекта.ЗадачаПроекта В
//		|			(ВЫБРАТЬ
//		|				ДоговорыЗадачиПроекта.ЗадачаПроекта
//		|			ИЗ
//		|				Документ.Договор.ЗадачиПроекта КАК ДоговорыЗадачиПроекта
//		|			ГДЕ
//		|				ДоговорыЗадачиПроекта.Ссылка = &Документ)
//		|	И ДоговорыЗадачиПроекта.Ссылка.Проведен
//		|	И ДоговорыЗадачиПроекта.Ссылка.Ссылка <> &Документ
//		|
//		|СГРУППИРОВАТЬ ПО
//		|	ДоговорыЗадачиПроекта.ЗадачаПроекта";

	//[#129376 - Катаев]
	//Считать сумму обеспечения ранее по всем задачам, без учета задач в документе.
	//Условие закомментировано 23.07.2018 Гумедин А.Г. по задаче #131955
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ДоговорыЗадачиПроекта.Сумма) КАК Сумма,
		|	ДоговорыЗадачиПроекта.ЗадачаПроекта
		|ИЗ
		|	Документ.Договор.ЗадачиПроекта КАК ДоговорыЗадачиПроекта
		|ГДЕ
		|	ДоговорыЗадачиПроекта.Ссылка.Проект = &ДокументПроект
		|	И ДоговорыЗадачиПроекта.Ссылка.Ссылка <> &Документ
		//|	И ДоговорыЗадачиПроекта.Ссылка.Ссылка.Дата < &ДокументДата
		//По фиктивным договорам требуется брать и не проведенные
		|	И (ДоговорыЗадачиПроекта.Ссылка.Проведен ИЛИ ДоговорыЗадачиПроекта.Ссылка.Фиктивный)
		|
		|СГРУППИРОВАТЬ ПО
		|	ДоговорыЗадачиПроекта.ЗадачаПроекта";
	
	//
	Запрос.УстановитьПараметр("Документ", Документ );
	Запрос.УстановитьПараметр("ДокументПроект", Документ.Проект );
	Запрос.УстановитьПараметр("ДокументДата", Документ.Дата );

	Результат = Запрос.Выполнить().Выгрузить();
	сСуммы = Новый Соответствие;
	Для Каждого Стр ИЗ Результат Цикл
		сСуммы.Вставить( Стр.ЗадачаПроекта, Стр.Сумма );
	КонецЦикла;
	Возврат сСуммы;
	//Возврат Результат;
КонецФункции


&НаКлиенте
Процедура ЗаполнитьОбеспеченоРанее()
	// обеспечено другими договорами
	сСуммы = РанееОбеспеченоПоДоговору( Объект.Ссылка );

	//
	Для Каждого СтрОб ИЗ Объект.ЗадачиПроекта Цикл
		Сумма = сСуммы.Получить(СтрОб.ЗадачаПроекта);
		//СтрРез = тз.Найти( СтрОб.ЗадачаПроекта, "ЗадачаПроекта");
		Если Сумма <> Неопределено Тогда
			СтрОб.СуммаОбеспечено 	= Сумма;			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

//Добавлено 15.05.2018 Гумединым А.Г. по задаче #129069 
&НаКлиенте
Процедура ЗаполнитьОбеспечено_ПриЗаполненииЗадач()
	 // обеспечено другими договорами
 	сСуммы = РанееОбеспеченоПоДоговору( Объект.Ссылка );

 	//
 	Для Каждого СтрОб ИЗ Объект.ЗадачиПроекта Цикл
  		Сумма = сСуммы.Получить(СтрОб.ЗадачаПроекта);
	
  		Если Сумма = Неопределено Тогда 
   			Сумма = 0
  		КонецЕсли;
  
		СтрОб.СуммаОбеспечено = Сумма;
	  	СтрОб.СуммаНеОбеспечено = СтрОб.СуммаПоСмете - СтрОб.СуммаОбеспечено;
  
  		//СтрРез = тз.Найти( СтрОб.ЗадачаПроекта, "ЗадачаПроекта");
  		Если СтрОб.СуммаНеОбеспечено = 0 Тогда   
		   ПараметрыОтбора = Новый Структура;
		   ПараметрыОтбора.Вставить("ЗадачаПроекта", СтрОб.ЗадачаПроекта); 
		   ЗадачаПроекта = Объект.ЗадачиПроекта.НайтиСтроки(ПараметрыОтбора)[0];
		  
		   Объект.ЗадачиПроекта.Удалить(ЗадачаПроекта);   
  		КонецЕсли;
 	КонецЦикла;   
КонецПроцедуры

//Добавлено 23.07.2018 Гумедин А.Г. по задаче #131955
&НаКлиенте
Процедура ЗаполнитьОбеспечено_ПриЗаполненииЗадач_2()
	 // обеспечено другими договорами
 	сСуммы = РанееОбеспеченоПоДоговору( Объект.Ссылка );

 	//
	КолСтрок = Объект.ЗадачиПроекта.Количество();
	СтрОб = Объект.ЗадачиПроекта;  
	пн = 0;
	Пока пн < КолСтрок Цикл
		
		Сумма = сСуммы.Получить(СтрОб[пн].ЗадачаПроекта);
	
  		Если Сумма = Неопределено Тогда 
   			Сумма = 0
  		КонецЕсли;
  
		СтрОб[пн].СуммаОбеспечено = Сумма;
	  	СтрОб[пн].СуммаНеОбеспечено = СтрОб[пн].СуммаПоСмете - СтрОб[пн].СуммаОбеспечено;
		
		Если СтрОб[пн].СуммаНеОбеспечено = 0 Тогда   
		   ПараметрыОтбора = Новый Структура;
		   ПараметрыОтбора.Вставить("ЗадачаПроекта", СтрОб[пн].ЗадачаПроекта); 
		   ЗадачаПроекта = Объект.ЗадачиПроекта.НайтиСтроки(ПараметрыОтбора)[0];
		  
		   Объект.ЗадачиПроекта.Удалить(пн); 
		   КолСтрок = КолСтрок - 1;
		   пн = пн - 1;
	   КонецЕсли;
	   пн = пн + 1;
 	КонецЦикла;   
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗадачами_НаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗадачиПроекта.Очистить();
	
	//ВидыЗадачи = Новый Массив;
	//
	////[#129376 - Катаев]
	////Если Соглашение в Договоре не указано, то нужно отбирать все задачи без учета Типовой и Вида.
	//Если ЗначениеЗаполнено(Документ.Соглашение) Тогда
	//	Если ВидыТиповыхЗадач.Количество() <> 0 Тогда
	//		//		
	//		ВидыЗадачи = ВидыТиповыхЗадач.ВыгрузитьЗначения();
	//	Иначе
	//		НаименованиеВТЗ_ППЛО = "ПП (ЛО)";
	//		
	//		Если Документ.Соглашение.ППЛО Тогда
	//			ВидыЗадачи.Добавить(Справочники.ВидыТиповыхЗадач.НайтиПоНаименованию( НаименованиеВТЗ_ППЛО));
	//		Иначе
	//	
	//			Запрос = Новый Запрос;
	//			Запрос.Текст = 
	//				"ВЫБРАТЬ
	//				|	ВидыТиповыхЗадач.Ссылка
	//				|ИЗ
	//				|	Справочник.ВидыТиповыхЗадач КАК ВидыТиповыхЗадач
	//				|ГДЕ
	//				|	ВидыТиповыхЗадач.Наименование <> &Наименование
	//				|	И НЕ ВидыТиповыхЗадач.ПометкаУдаления";
	//			
	//			Запрос.УстановитьПараметр("Наименование", НаименованиеВТЗ_ППЛО);
	//		
	//			ВидыЗадачи = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	//	
	//		КонецЕсли;
	//	КонецЕсли;		
	//КонецЕсли;

	//Изменено 18.05.2018 Гумединым А.Г. По задаче #129069
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗадачиПроектов.Сумма КАК СуммаПоСмете,
		|	ЗадачиПроектов.Ссылка КАК ЗадачаПроекта
		|ИЗ
		|	Справочник.ЗадачиПроектов КАК ЗадачиПроектов
		|ГДЕ
		|	ЗадачиПроектов.Владелец = &Проект";
		//|	И (&ВсеЗадачи
		//|			ИЛИ ЗадачиПроектов.ТиповаяЗадача.ВидТиповойЗадачи В (&ВидыЗадачи))";

	
	//Запрос.УстановитьПараметр("ВсеЗадачи", (ВидыЗадачи.Количество()=0));
	//Запрос.УстановитьПараметр("ВидыЗадачи", ВидыЗадачи);
	Запрос.УстановитьПараметр("Проект", Документ.Проект);
	
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		//Добавлено условине 15.05.2018 Гумединым А.Г по задаче #129069
		//Условие обновлено 23.07.2018 Гумедин А.Г. по задаче #132007
		Контрагент = ВыборкаДетальныеЗаписи.ЗадачаПроекта.Контрагент;
		Если ЗначениеЗаполнено(Объект.Контрагент) 
			И ЗначениеЗаполнено(Контрагент) 
			И Контрагент <> Объект.Контрагент Тогда
			Продолжить;
		КонецЕсли;
                                                                                                        
		
		//Ошибки в Догворах [#129886]
		Если ВыборкаДетальныеЗаписи.ЗадачаПроекта.ИсточникФинансирования.НеУчитыватьДоговора Тогда
			Продолжить;
		КонецЕсли;
	
		Стр = Документ.ЗадачиПроекта.Добавить();
		ЗаполнитьЗначенияСвойств( Стр, ВыборкаДетальныеЗаписи );
	КонецЦикла;
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры

&НаКлиенте
Процедура ПересчетТаблицыЗадач()
	Для Каждого Стр ИЗ Объект.ЗадачиПроекта Цикл
		Стр.СуммаНеОбеспечено = Стр.СуммаПоСмете - Стр.Сумма - Стр.СуммаОбеспечено;
	КонецЦикла;
	// итоги
	ИтогОбеспечено = Объект.ЗадачиПроекта.Итог("СуммаОбеспечено");
	ИтогНеОбеспечено = Объект.ЗадачиПроекта.Итог("СуммаНеОбеспечено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗаполнениеЗадачами( РезультатВопроса, ДополнительныеПараметры = Неопределено ) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьЗадачами_НаСервере();
		// заполняем колонку обеспечено ранее
		//ЗаполнитьОбеспеченоРанее();
		//Изменено 23.07.2018 Гумедин А.Г. по задаче 
		//ЗаполнитьОбеспечено_ПриЗаполненииЗадач();
		ЗаполнитьОбеспечено_ПриЗаполненииЗадач_2();


		// пересчет таблицы
		ПересчетТаблицыЗадач();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗадачами(Команда)
	Если Объект.Проект.Пустая() Тогда
		ПоказатьПредупреждение(,"Укажите проект!", 10);
		Возврат;
	КонецЕсли;
	
	
	Если Объект.ЗадачиПроекта.Количество() <> 0 Тогда
		Оповещение = Новый ОписаниеОповещения( "ОбработатьЗаполнениеЗадачами", ЭтаФорма );
		
		ПоказатьВопрос(Оповещение,"Текущее распределение будет очищено, продолжить?", РежимДиалогаВопрос.ДаНет);
	Иначе
		ОбработатьЗаполнениеЗадачами( КодВозвратаДиалога.Да );
	КонецЕсли;
	//
	//РасчитатьСуммуТиповыхЗадач();
КонецПроцедуры


&НаКлиенте
Процедура ЭтапыГрафикаОплатыПослеУдаления(Элемент)
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ЗадачаПроекта", ЭтаФорма.ТекущийЭлемент.ТекущиеДанные.ЗадачаПроекта); 
	ЗадачаПроекта = Объект.ЗадачиПроекта.НайтиСтроки(ПараметрыОтбора)[0];

	БалансПроцентовИСумм_ПоЗадачам(2, ЗадачаПроекта.Сумма, ЗадачаПроекта.ЗадачаПроекта);
	//БалансПроцентовИСумм_ПоЗадачам(2);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПроект(Команда)
	Форма = ПолучитьФорму( "Справочник.Проекты.ФормаВыбора");
	Объект.Проект = Форма.ОткрытьМодально();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ЗаполнитьОбеспеченоРанее();
	// пересчет таблицы
	ПересчетТаблицыЗадач();
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиПроектаСуммаПриИзменении(Элемент)
	Если Элемент.Имя = "ЗадачиПроектаСумма" Тогда
		Стр = Элементы.ЗадачиПроекта.ТекущиеДанные;
		Стр.СуммаНеОбеспечено = Стр.СуммаПоСмете - Стр.Сумма - Стр.СуммаОбеспечено;
		Стр.Изменено = Истина;
	ИначеЕсли Элемент.Имя = "ЗадачиПроектаСуммаОстатокНеОбеспечено" Тогда
		Стр = Элементы.ЗадачиПроекта.ТекущиеДанные;
		Стр.Сумма = Стр.СуммаПоСмете - Стр.СуммаОбеспечено - Стр.СуммаНеОбеспечено;
		Стр.Изменено = Истина;
	КонецЕсли;
	ПересчетТаблицыЗадач();
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьСуммуПоЗадачам(Команда)
	
	Если Объект.ЗадачиПроекта.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	Если Объект.СуммаДокумента = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДляРаспределения = Объект.СуммаДокумента;
	МассивКоэфф = Новый Массив;
	Для Каждого Стр ИЗ Объект.ЗадачиПроекта Цикл
		// пока самый простой вариант !!!
		//БазаРаспределения = Стр.СуммаПоСмете; //  - Стр.СуммаОбеспечено;
		
		//[#129376 - Катаев]
		//Распределение суммы договора должно производится с учетом имеющихся договоров (обеспечено ранее)
		Если НЕ Стр.Изменено Тогда
			БазаРаспределения = Стр.СуммаПоСмете - Стр.СуммаОбеспечено;
		Иначе 
			БазаРаспределения = 0;
			СуммаДляРаспределения = СуммаДляРаспределения - Стр.Сумма; 
		КонецЕсли;
		МассивКоэфф.Добавить( БазаРаспределения );
	КонецЦикла;
	//
	мРез = РаспределитьПропорционально( СуммаДляРаспределения, МассивКоэфф);
	Для Каждого Стр ИЗ Объект.ЗадачиПроекта Цикл
		Если мРез <> Неопределено Тогда
			Если НЕ Стр.Изменено Тогда
				Стр.Сумма	= мРез[Объект.ЗадачиПроекта.Индекс(Стр)];
			КонецЕсли;
		Иначе
			Стр.Сумма	= 0;
		КонецЕсли;
	КонецЦикла;
	
	ПересчетТаблицыЗадач();
	
КонецПроцедуры

//Добавлено по задаче  #129161 17.04.2018 Гумединым А.Г.
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	Контрагент = ЭтаФорма.Объект.Проект.Контрагент;
	
	Если ЭтаФорма.Объект.Контрагент.Пустая() Тогда 
		ЭтаФорма.Объект.Контрагент = Контрагент;
	КонецЕсли

КонецПроцедуры
//Добавлено по задаче  #129161 18.04.2018 Гумединым А.Г.
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	// Вставить содержимое обработчика.
	Фиктивный = ЭтаФорма.Объект.Фиктивный;
	Номер = ЭтаФорма.Объект.Номер;
	
	//Проверка на корректность заполнения номера
	Если Фиктивный И Не ПустаяСтрока(Номер) Тогда 
		Сообщить("У фиктивного договора не может быть номера");
		Отказ = истина;
	ИначеЕсли Не Фиктивный И ПустаяСтрока(Номер) Тогда
		Сообщить("У не фиктивного договора должен быть заполнен номер");
		Отказ = истина;
	КонецЕсли;
	 
КонецПроцедуры

//Добавлено по задаче  #129161 18.04.2018 Гумединым А.Г.
&НаСервере
Процедура РасчитатьСуммуНаСервере()
	Проект = ЭтаФорма.Объект.Проект;	
	
	Сумма = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сумма(СметаЗадачиПроектаРасчет.Сумма) КАК СуммаПоСмете		
		|ИЗ
		|	Документ.СметаЗадачиПроекта.Расчет КАК СметаЗадачиПроектаРасчет
		|ГДЕ
		|	СметаЗадачиПроектаРасчет.Статья = &Статья
		|	И СметаЗадачиПроектаРасчет.Ссылка.Проведен
		|	И СметаЗадачиПроектаРасчет.Ссылка.ЗадачаПроекта.Владелец = &Проект";
	
	Запрос.УстановитьПараметр("Проект", Проект);
	Запрос.УстановитьПараметр("Статья", Справочники.СтатьиСметы.ДохФинансовые );

	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сумма = ВыборкаДетальныеЗаписи.СуммаПоСмете;
	КонецЦикла;

	//Находим все документы проекта
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ 
		|   Договор.СуммаДокумента КАК СуммаДоговора,
		|   Договор.Ссылка КАК Договор
		|   
		|ИЗ
		|	Документ.Договор КАК Договор
		|ГДЕ
		|	Договор.Проект = &Проект
		|	И Договор.Проведен";
	
	Запрос.УстановитьПараметр("Проект", Проект);	
	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сумма = Сумма - ВыборкаДетальныеЗаписи.СуммаДоговора;
	КонецЦикла;
	
	//Оставлееся помещаем в поде СуммаДокумета на форме текущего документа
	ЭтаФорма.Объект.СуммаДокумента = Сумма;	
КонецПроцедуры

//Добавлено по задаче  #132007 20.07.2018 Гумединым А.Г.
&НаСервере
Процедура РасчитатьСуммуНаСервере_v2()
	
	Сумма = 0;
	СуммаПоСмете = 0;
	СуммаОбеспеченоРанее = 0;
	
	//Выбираем все задачи из поля «ЗадачиПроекта» Договора
	ЗадачиПроекта = ЭтаФорма.Объект.ЗадачиПроекта;
	
	//Считаем сумму «СуммаПоСмете» всех выбранных задач 
	Для Каждого ЗадачаПроекта ИЗ ЗадачиПроекта Цикл
		СуммаПоСмете = СуммаПоСмете+ЗадачаПроекта.СуммаПоСмете;
	КонецЦикла; 	
	
	//Считаем сумму «ОбеспеченоРане» всех выбранных задач
	Для Каждого ЗадачаПроекта ИЗ ЗадачиПроекта Цикл
		СуммаОбеспеченоРанее = СуммаОбеспеченоРанее+ЗадачаПроекта.СуммаОбеспечено;
	КонецЦикла;
	
	//Получаем разность ОбщаяСуммаПоЗадачам – СуммаОбеспечено
	ЭтаФорма.Объект.СуммаДокумента = СуммаПоСмете - СуммаОбеспеченоРанее;
	
КонецПроцедуры


&НаКлиенте
Процедура РасчитатьСумму(Команда)
	//Добавлено по задаче  #132007 20.07.2018 Гумединым А.Г.
	//РасчитатьСуммуНаСервере();
	РасчитатьСуммуНаСервере_v2();
КонецПроцедуры



//////////////////////////////////////////////////////////
//Добавлено по задаче #129069 04.05.2018 Катаевым Д.В.
&НаКлиенте
Процедура ОтгрузМесяцы(Команда)
	РапределитьОтгрузку(1);
КонецПроцедуры

&НаКлиенте
Процедура ОтгрузКварталы(Команда)
	РапределитьОтгрузку(2);
КонецПроцедуры

//Изменено 14.05.2015 Гумединым А.Г. по задаче #129069
&НаКлиенте
Процедура ОтгрузАванс30Проц(Команда)
	РапределитьОтгрузку(3);
	//// ставим процент платежей
	//Объект.ЭтапыГрафикаОплаты[0].ПроцентПлатежа = 30;
	////
	//БалансПроцентовИСуммОтгр_ПоЗадачаим();
	
	Для Каждого ЗадачаПроекта из Объект.ЗадачиПроекта Цикл 
		// ставим процент платежей
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ЗадачаПроекта", ЗадачаПроекта.ЗадачаПроекта); 
		ЭтапГрафикаРеализации = Объект.ЭтапыГрафикаРеализации.НайтиСтроки(ПараметрыОтбора)[0];	
		ЭтапГрафикаРеализации.ПроцентРеализации = 30;
		
		//Формирование сумм и процентов по задачам проекта 
		БалансПроцентовИСуммОтгр_ПоЗадачам(1, ЗадачаПроекта.Сумма, ЗадачаПроекта.ЗадачаПроекта);
	КонецЦикла;	

КонецПроцедуры


&НаКлиенте
Процедура РапределитьОтгрузку(Вариант)
	Если Объект.СуммаДокумента = 0 Тогда
		Предупреждение("Не указана сумма к распределению!", 10);
		Возврат;
	КонецЕсли;
	Если Объект.ЭтапыГрафикаРеализации.Количество() <> 0 Тогда
		Если Вопрос("Текущее распределение будет очищено, продолжить?", РежимДиалогаВопрос.ДаНет)=КодВозвратаДиалога.Да	Тогда
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	СписокПериодов = СписокПериодовРаспределения(Вариант);
	Если СписокПериодов.Количество() = 0 Тогда
		Предупреждение("Неправильно выбран период!", 10);
		Возврат;
	КонецЕсли;
	//РаспределитьПоВариантуОтгр( СписокПериодов );
	//// 
	//БалансПроцентовИСуммОтгр();
	
	//Добавлено 14.05.2015 Гумединым А.Г. по задаче #129069
	Если Объект.ЗадачиПроекта.Количество() = 0 Тогда
		Предупреждение("Отсутствуют задачи для распределения", 10);
		Возврат;
	КонецЕсли;
	
	Объект.ЭтапыГрафикаРеализации.Очистить();
	Для Каждого ЗадачаПроекта из Объект.ЗадачиПроекта Цикл  
		
		СписокПериодовПоЗадачам = СписокПериодовРаспределения_ПоЗадачам(Вариант, ЗадачаПроекта.ЗадачаПроекта);
		
		РаспределитьПоВариантуОтгр( СписокПериодовПоЗадачам, ЗадачаПроекта.Сумма, ЗадачаПроекта.ЗадачаПроекта);
		//Формирование сумм и процентов по задачам проекта 
		//БалансПроцентовИСуммОтгр_ПоЗадачам(1, ЗадачаПроекта.Сумма, ЗадачаПроекта.ЗадачаПроекта);
	КонецЦикла;
	///////////////////////////////////////////////////////
КонецПроцедуры

//Изменено 14.05.2015 Гумединым А.Г. по задаче #129069
&НаСервере
Процедура РаспределитьПоВариантуОтгр( СпПериодов, Сумма, ЗадачаПроекта)
	Если (СпПериодов.Количество() > 0) И (Сумма <> 0) Тогда 
		СпрОб = РеквизитФормыВЗначение("Объект");
		
		СуммаКРаспределению  = Сумма;
		СуммаПериода = СуммаКРаспределению/СпПериодов.Количество();
		Для Каждого Эл ИЗ СпПериодов Цикл
			Стр = СпрОб.ЭтапыГрафикаРеализации.Добавить();
			Стр.ЗадачаПроекта = ЗадачаПроекта;  // Добевлено по задаче #129069
			Стр.ДатаРеализации = Эл.Значение; 
			Если СпПериодов.Индекс( Эл ) = СпПериодов.Количество() - 1 Тогда
			// последний период
				Стр.СуммаРеализации = СуммаКРаспределению;
			Иначе
				Стр.СуммаРеализации = СуммаПериода;
				СуммаКРаспределению = СуммаКРаспределению - Стр.СуммаРеализации;
			КонецЕсли;
		КонецЦикла;	
		ЗначениеВРеквизитФормы(СпрОб, "Объект");
	КонецЕсли;
	
КонецПроцедуры

//&НаКлиенте
//Процедура БалансПроцентовИСуммОтгр( Вариант = 1)
//	Если Объект.ЭтапыГрафикаРеализации.Количество() <> 0 Тогда
//		//
//		ИтогоПроцент = Объект.ЭтапыГрафикаРеализации.Итог("ПроцентРеализации");
//		Стр = Объект.ЭтапыГрафикаРеализации[Объект.ЭтапыГрафикаРеализации.Количество()-1];
//		Стр.ПроцентРеализации = Стр.ПроцентРеализации + (100-ИтогоПроцент);
//		// чтобы округлить
//		ПересчетСуммГрафикаПлатежейОтгр( Вариант );
//	КонецЕсли;
//КонецПроцедуры

//Добавлено 14.05.2015 Гумединым А.Г. по задаче #129069 
&НаКлиенте
Процедура БалансПроцентовИСуммОтгр_ПоЗадачам(Вариант = 1, Сумма, ЗадачаПроекта)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ЗадачаПроекта", ЗадачаПроекта); 
	ГрафикиРеализации = Объект.ЭтапыГрафикаРеализации.НайтиСтроки(ПараметрыОтбора);
	
	ИтогоПроцент = 0;
	Для Каждого ГрафикРеализации ИЗ ГрафикиРеализации Цикл
		ИтогоПроцент = ИтогоПроцент + ГрафикРеализации.ПроцентРеализации;		
	КонецЦикла;
	
	Если ГрафикиРеализации.Количество() <> 0 Тогда
		//
		Стр = ГрафикиРеализации[ГрафикиРеализации.Количество()-1];
		Стр.ПроцентРеализации = Стр.ПроцентРеализации + (100-ИтогоПроцент);
		// чтобы округлить
		ПересчетСуммГрафикаПлатежейОтгр_ПоЗадачам( Вариант , Сумма, ЗадачаПроекта);
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПересчетСуммГрафикаПлатежейОтгр( Вариант = 1 )
	//СуммаРаспределено = 0;
	Если Объект.ЭтапыГрафикаРеализации.Количество() <> 0 Тогда
		// последняя строка
		Стр = Объект.ЭтапыГрафикаРеализации[Объект.ЭтапыГрафикаРеализации.Количество()-1];
		Стр.СуммаРеализации   = Объект.СуммаДокумента;
		
		// вариант 1, сумма от процентов
		Для Н = 0 ПО Объект.ЭтапыГрафикаРеализации.Количество()-2 Цикл
			СтрН 				= Объект.ЭтапыГрафикаРеализации[Н];
			Если Вариант = 1 Тогда
				СтрН.СуммаРеализации	= Объект.СуммаДокумента * СтрН.ПроцентРеализации /100;
			Иначе
				СтрН.ПроцентРеализации	= СтрН.СуммаРеализации/Объект.СуммаДокумента * 100;
			КонецЕсли;
			
			//СуммаРаспределено 	= СуммаРаспределено + СтрН.СуммаПлатежа;
			Стр.СуммаРеализации  	= Стр.СуммаРеализации 	- СтрН.СуммаРеализации;
		КонецЦикла;
		
		// 
		//СуммаРаспределено 	= СуммаРаспределено + Стр.СуммаПлатежа;
	КонецЕсли;
КонецПроцедуры

//Добавлено 14.05.2015 Гумединым А.Г. по задаче #129069 
&НаКлиенте
Процедура ПересчетСуммГрафикаПлатежейОтгр_ПоЗадачам(Вариант = 1, Сумма, ЗадачаПроекта)
	//СуммаРаспределено = 0;
	Если Объект.ЭтапыГрафикаРеализации.Количество() <> 0 Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ЗадачаПроекта", ЗадачаПроекта); 
		ГрафикиРеализации = Объект.ЭтапыГрафикаРеализации.НайтиСтроки(ПараметрыОтбора);
		
		// последняя строка
		Стр = ГрафикиРеализации[ГрафикиРеализации.Количество()-1];
		Стр.СуммаРеализации = Сумма;
		
		// вариант 1, сумма от процентов
		Для Н = 0 ПО (ГрафикиРеализации.Количество() - 2) Цикл
			СтрН = ГрафикиРеализации[Н];
			Если Вариант = 1 Тогда
				СтрН.СуммаРеализации	= Сумма * СтрН.ПроцентРеализации /100;
			Иначе
				СтрН.ПроцентРеализации	= СтрН.СуммаРеализации/Сумма * 100;
			КонецЕсли;
			  
			Стр.СуммаРеализации = Стр.СуммаРеализации - СтрН.СуммаРеализации;
		КонецЦикла;		
	КонецЕсли;
КонецПроцедуры

//Изменено 14.05.2018 Гумединм А.Г. по задачче #129069
&НаКлиенте
Процедура ЭтапыГрафикаРеализацииПослеУдаления(Элемент)
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ЗадачаПроекта", ЭтаФорма.ТекущийЭлемент.ТекущиеДанные.ЗадачаПроекта); 
	ЗадачаПроекта = Объект.ЗадачиПроекта.НайтиСтроки(ПараметрыОтбора)[0];

	БалансПроцентовИСуммОтгр_ПоЗадачам(2, ЗадачаПроекта.Сумма, ЗадачаПроекта.ЗадачаПроекта);
	//БалансПроцентовИСуммОтгр(2);
КонецПроцедуры

//Добавлено 11.05.2018 Гумединм А.Г. по задачче #129069
&НаКлиенте
Процедура ЭтапыГрафикаРеализацииПроцентРеализацииПриИзменении(Элемент)
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ЗадачаПроекта", ЭтаФорма.ТекущийЭлемент.ТекущиеДанные.ЗадачаПроекта); 
	ЗадачаПроекта = Объект.ЗадачиПроекта.НайтиСтроки(ПараметрыОтбора)[0];
	
	БалансПроцентовИСуммОтгр_ПоЗадачам(1, ЗадачаПроекта.Сумма, ЗадачаПроекта.ЗадачаПроекта);
КонецПроцедуры

//Добавлено 11.05.2018 Гумединм А.Г. по задачче #129069
&НаКлиенте
Процедура ЭтапыГрафикаРеализацииСуммаРеализацииПриИзменении(Элемент)
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ЗадачаПроекта", ЭтаФорма.ТекущийЭлемент.ТекущиеДанные.ЗадачаПроекта); 
	ЗадачаПроекта = Объект.ЗадачиПроекта.НайтиСтроки(ПараметрыОтбора)[0];
	
	Стр = Элементы.ЭтапыГрафикаРеализации.ТекущиеДанные;
	//
	Стр.ПроцентРеализации = Стр.СуммаРеализации / ЗадачаПроекта.Сумма * 100;
	
	БалансПроцентовИСуммОтгр_ПоЗадачам(2, ЗадачаПроекта.Сумма, ЗадачаПроекта.ЗадачаПроекта);
	
КонецПроцедуры

//Добавлено 14.05.2018 Гумединм А.Г. по задачче #129069
&НаКлиенте
Процедура ПоГрафикуРеализации(Команда)
	// Вставить содержимое обработчика.
	Если Объект.ЭтапыГрафикаОплаты.Количество() <> 0 Тогда
		Если Вопрос("Текущее распределение будет очищено, продолжить?", РежимДиалогаВопрос.ДаНет)=КодВозвратаДиалога.Да	Тогда
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Объект.ЭтапыГрафикаОплаты.Очистить();
	Для Каждого ЭтапРеализации ИЗ Объект.ЭтапыГрафикаРеализации	Цикл
		СтрокаСостава = Объект.ЭтапыГрафикаОплаты.Добавить();
		СтрокаСостава.ЗадачаПроекта = ЭтапРеализации.ЗадачаПроекта;
		СтрокаСостава.ДатаПлатежа =  ДобавитьМесяц(ЭтапРеализации.ДатаРеализации, 1);
		СтрокаСостава.СуммаПлатежа = ЭтапРеализации.СуммаРеализации;
		СтрокаСостава.ПроцентПлатежа = ЭтапРеализации.ПроцентРеализации;
		СтрокаСостава.Комментарий = ЭтапРеализации.Комментарий;
	КонецЦикла; 	
КонецПроцедуры

//Добавлено 15.05.2018 Гумединым А.Г. по задаче #129069
&НаКлиенте
Процедура ЗадачиПроектаПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.ЗадачиПроекта.ТекущиеДанные;
	ПоказатьВсе = Объект.ПоказатьВсеГрафики;
	
	Если ТекущиеДанные = Неопределено ИЛИ ПоказатьВсе Тогда
        // ТЧ Контрагенты пустая
        Элементы.ЭтапыГрафикаОплаты.ОтборСтрок = Неопределено;
		Элементы.ЭтапыГрафикаРеализации.ОтборСтрок = Неопределено;
    Иначе
		ЗадачаПроекта = ТекущиеДанные.ЗадачаПроекта;
		Элементы.ЭтапыГрафикаОплаты.ОтборСтрок = Новый ФиксированнаяСтруктура("ЗадачаПроекта", ЗадачаПроекта);
		Элементы.ЭтапыГрафикаРеализации.ОтборСтрок = Новый ФиксированнаяСтруктура("ЗадачаПроекта", ЗадачаПроекта);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура БалансПроцентовИСуммОтгр( Вариант = 1)
	Если Объект.ЭтапыГрафикаРеализации.Количество() <> 0 Тогда
		//
		ИтогоПроцент = Объект.ЭтапыГрафикаРеализации.Итог("ПроцентРеализации");
		Стр = Объект.ЭтапыГрафикаРеализации[Объект.ЭтапыГрафикаРеализации.Количество()-1];
		Стр.ПроцентРеализации = Стр.ПроцентРеализации + (100-ИтогоПроцент);
		// чтобы округлить
		ПересчетСуммГрафикаПлатежейОтгр( Вариант );
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ОплатаДоговор(Команда)
	Если Объект.ЭтапыГрафикаОплатыПоДоговорам.Количество() = 0 Тогда
		Предупреждение("График оплаты в торговле не определен.", 10);
		Возврат;
	КонецЕсли;
	
	Если Объект.ЗадачиПроекта.Количество() = 0 Тогда
		Предупреждение("Отсутствуют задачи для распределения", 10);
		Возврат;
	КонецЕсли;
	
	ОплатаДоговорСервер();
КонецПроцедуры

&НаКлиенте
Процедура ОтгрузкаДоговор(Команда)
	Если Объект.ЭтапыГрафикаОтгрузкиПоДоговорам.Количество() = 0 Тогда
		Предупреждение("График отгрузки в торговле не определен.", 10);
		Возврат;
	КонецЕсли;
	
	Если Объект.ЗадачиПроекта.Количество() = 0 Тогда
		Предупреждение("Отсутствуют задачи для распределения", 10);
		Возврат;
	КонецЕсли;
	
	ОтгрузкаДоговорСервер();
КонецПроцедуры

&НаСервере
Процедура ОтгрузкаДоговорСервер()
	Объект.ЭтапыГрафикаРеализации.Очистить();
	Для Каждого ТипНоменклатуры Из Перечисления.ТипыНоменклатуры Цикл        		
		МассивКоэфф = Новый Массив;
		Для Каждого Стр ИЗ Объект.ЗадачиПроекта Цикл
			Если Стр.ЗадачаПроекта.ТиповаяЗадача.ВидНоменклатуры.ТипНоменклатуры = ТипНоменклатуры Тогда
				БазаРаспределения = Стр.Сумма;
			Иначе 
				БазаРаспределения = 0;
			КонецЕсли;
			МассивКоэфф.Добавить( БазаРаспределения );
		КонецЦикла;
		
		Для Каждого этапОтгрузки ИЗ Объект.ЭтапыГрафикаОтгрузкиПоДоговорам Цикл
			Если этапОтгрузки.ТипНоменклатуры = ТипНоменклатуры Тогда
				мРез = РаспределитьПропорционально(ЭтапОтгрузки.СуммаОтгрузки, МассивКоэфф);
				Для Каждого задача ИЗ Объект.ЗадачиПроекта Цикл
					Если мРез[Объект.ЗадачиПроекта.Индекс(задача)] <> 0 Тогда 
						строка = Объект.ЭтапыГрафикаРеализации.Добавить();
						строка.ЗадачаПроекта = задача.ЗадачаПроекта;
						строка.ДатаРеализации = этапОтгрузки.ДатаОтгрузки;
						строка.СуммаРеализации = мРез[Объект.ЗадачиПроекта.Индекс(задача)];
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОплатаДоговорСервер()
	Объект.ЭтапыГрафикаОплаты.Очистить();
	Для Каждого ТипНоменклатуры Из Перечисления.ТипыНоменклатуры Цикл        		
		МассивКоэфф = Новый Массив;
		Для Каждого Стр ИЗ Объект.ЗадачиПроекта Цикл
			Если Стр.ЗадачаПроекта.ТиповаяЗадача.ВидНоменклатуры.ТипНоменклатуры = ТипНоменклатуры Тогда
				БазаРаспределения = Стр.Сумма;
			Иначе 
				БазаРаспределения = 0;
			КонецЕсли;
			МассивКоэфф.Добавить( БазаРаспределения );
		КонецЦикла;
		
		Для Каждого этапОплаты ИЗ Объект.ЭтапыГрафикаОплатыПоДоговорам Цикл
			Если этапОплаты.ТипНоменклатуры = ТипНоменклатуры Тогда
				мРез = РаспределитьПропорционально(этапОплаты.СуммаПлатежа, МассивКоэфф);
				Для Каждого задача ИЗ Объект.ЗадачиПроекта Цикл
					Если мРез[Объект.ЗадачиПроекта.Индекс(задача)] <> 0 Тогда 
						строка = Объект.ЭтапыГрафикаОплаты.Добавить();
						строка.ЗадачаПроекта = задача.ЗадачаПроекта;
						строка.ДатаПлатежа = этапОплаты.ДатаПлатежа;
						строка.СуммаПлатежа = мРез[Объект.ЗадачиПроекта.Индекс(задача)];
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры
//////////////////////////////////////////////////////////
