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

&НаКлиенте
Процедура Аванс30Проц(Команда)
	РаспределитьПлатежи( 3 );
	// ставим процент платежей
	Объект.ЭтапыГрафикаОплаты[0].ПроцентПлатежа = 30;
	//
	БалансПроцентовИСумм();
	
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
	РаспределитьПоВарианту( СписокПериодов );
	// 
	БалансПроцентовИСумм();
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

// 1 - по месяцам, начиная с начала периода до конца
// 2 - по кварталам
&НаСервере
Процедура РаспределитьПоВарианту( СпПериодов )
	СпрОб = РеквизитФормыВЗначение("Объект");
	СпрОб.ЭтапыГрафикаОплаты.Очистить();
	
	//
	ПроцентовКРаспределению  = 100;
	Процент = 100/СпПериодов.Количество();
	Для Каждого Эл ИЗ СпПериодов Цикл
		Стр = СпрОб.ЭтапыГрафикаОплаты.Добавить();
		Стр.ДатаПлатежа = Эл.Значение; 
		Если СпПериодов.Индекс( Эл ) = СпПериодов.Количество() - 1 Тогда
		// последний период
			Стр.ПроцентПлатежа = ПроцентовКРаспределению;
		Иначе
			Стр.ПроцентПлатежа = Процент;
			ПроцентовКРаспределению = ПроцентовКРаспределению - Стр.ПроцентПлатежа;
		КонецЕсли;
	КонецЦикла;	
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

&НаКлиенте
Процедура ЭтапыГрафикаОплатыПроцентПлатежаПриИзменении(Элемент)
	БалансПроцентовИСумм();
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыСуммаПлатежаПриИзменении(Элемент)
	Стр = Элементы.ЭтапыГрафикаОплаты.ТекущиеДанные;
	//
	Стр.ПроцентПлатежа = Стр.СуммаПлатежа / Объект.СуммаДокумента * 100;
	БалансПроцентовИСумм(2);
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
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ДоговорыЗадачиПроекта.Сумма) КАК Сумма,
		|	ДоговорыЗадачиПроекта.ЗадачаПроекта
		|ИЗ
		|	Документ.Договор.ЗадачиПроекта КАК ДоговорыЗадачиПроекта
		|ГДЕ
		|	ДоговорыЗадачиПроекта.Ссылка.Проект = &ДокументПроект
		|	И ДоговорыЗадачиПроекта.Ссылка.Ссылка <> &Документ
		|	И ДоговорыЗадачиПроекта.Ссылка.Ссылка.Дата < &ДокументДата
		|	И ДоговорыЗадачиПроекта.Ссылка.Проведен
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



&НаСервере
Процедура ЗаполнитьЗадачами_НаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗадачиПроекта.Очистить();
	
	ВидыЗадачи = Новый Массив;
	
	//[#129376 - Катаев]
	//Если Соглашение в Договоре не указано, то нужно отбирать все задачи без учета Типовой и Вида.
	Если ЗначениеЗаполнено(Документ.Соглашение) Тогда
		Если ВидыТиповыхЗадач.Количество() <> 0 Тогда
			//		
			ВидыЗадачи = ВидыТиповыхЗадач.ВыгрузитьЗначения();
		Иначе
			НаименованиеВТЗ_ППЛО = "ПП (ЛО)";
			
			Если Документ.Соглашение.ППЛО Тогда
				ВидыЗадачи.Добавить(Справочники.ВидыТиповыхЗадач.НайтиПоНаименованию( НаименованиеВТЗ_ППЛО));
			Иначе
		
				Запрос = Новый Запрос;
				Запрос.Текст = 
					"ВЫБРАТЬ
					|	ВидыТиповыхЗадач.Ссылка
					|ИЗ
					|	Справочник.ВидыТиповыхЗадач КАК ВидыТиповыхЗадач
					|ГДЕ
					|	ВидыТиповыхЗадач.Наименование <> &Наименование
					|	И НЕ ВидыТиповыхЗадач.ПометкаУдаления";
				
				Запрос.УстановитьПараметр("Наименование", НаименованиеВТЗ_ППЛО);
			
				ВидыЗадачи = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
			КонецЕсли;
		КонецЕсли;		
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СметаЗадачиПроектаРасчет.Сумма КАК СуммаПоСмете,
		|	СметаЗадачиПроектаРасчет.Ссылка.ЗадачаПроекта
		|ИЗ
		|	Документ.СметаЗадачиПроекта.Расчет КАК СметаЗадачиПроектаРасчет
		|ГДЕ
		|	СметаЗадачиПроектаРасчет.Статья = &Статья
		|	И СметаЗадачиПроектаРасчет.Ссылка.Проведен
		|	И СметаЗадачиПроектаРасчет.Ссылка.ЗадачаПроекта.Владелец = &Проект
		|	И (&ВсеЗадачи ИЛИ СметаЗадачиПроектаРасчет.Ссылка.ЗадачаПроекта.ТиповаяЗадача.ВидТиповойЗадачи В(&ВидыЗадачи))";

		
	
	Запрос.УстановитьПараметр("ВсеЗадачи", (ВидыЗадачи.Количество()=0));
	Запрос.УстановитьПараметр("ВидыЗадачи", ВидыЗадачи);
	Запрос.УстановитьПараметр("Проект", Документ.Проект);
	Запрос.УстановитьПараметр("Статья", Справочники.СтатьиСметы.ДохФинансовые );

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
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
		ЗаполнитьОбеспеченоРанее();

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
	БалансПроцентовИСумм(2);
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
	
	МассивКоэфф = Новый Массив;
	Для Каждого Стр ИЗ Объект.ЗадачиПроекта Цикл
		// пока самый простой вариант !!!
		//БазаРаспределения = Стр.СуммаПоСмете; //  - Стр.СуммаОбеспечено;
		
		//[#129376 - Катаев]
		//Распределение суммы договора должно производится с учетом имеющихся договоров (обеспечено ранее)
		БазаРаспределения = Стр.СуммаПоСмете - Стр.СуммаОбеспечено;
		
		МассивКоэфф.Добавить( БазаРаспределения );
	КонецЦикла;
	//
	мРез = РаспределитьПропорционально( Объект.СуммаДокумента, МассивКоэфф);
	Для Каждого Стр ИЗ Объект.ЗадачиПроекта Цикл
		Если мРез <> Неопределено Тогда
			Стр.Сумма	= мРез[Объект.ЗадачиПроекта.Индекс(Стр)];
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

&НаКлиенте
Процедура РасчитатьСумму(Команда)
	РасчитатьСуммуНаСервере();
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

&НаКлиенте
Процедура ОтгрузАванс30Проц(Команда)
	РапределитьОтгрузку(3);
	// ставим процент платежей
	Объект.ЭтапыГрафикаОплаты[0].ПроцентПлатежа = 30;
	//
	БалансПроцентовИСуммОтгр();

КонецПроцедуры

&НаКлиенте
Процедура РапределитьОтгрузку(Вариант)
	Если Объект.СуммаДокумента = 0 Тогда
		Предупреждение("Не указана сумма к распределению!", 10);
		Возврат;
	КонецЕсли;
	Если Объект.ЭтапыГрафикаОтгрузки.Количество() <> 0 Тогда
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
	РаспределитьПоВариантуОтгр( СписокПериодов );
	// 
	БалансПроцентовИСуммОтгр();
	
КонецПроцедуры

&НаСервере
Процедура РаспределитьПоВариантуОтгр( СпПериодов )
	СпрОб = РеквизитФормыВЗначение("Объект");
	СпрОб.ЭтапыГрафикаОтгрузки.Очистить();
	
	//
	ПроцентовКРаспределению  = 100;
	Процент = 100/СпПериодов.Количество();
	Для Каждого Эл ИЗ СпПериодов Цикл
		Стр = СпрОб.ЭтапыГрафикаОтгрузки.Добавить();
		Стр.ДатаОтгрузки = Эл.Значение; 
		Если СпПериодов.Индекс( Эл ) = СпПериодов.Количество() - 1 Тогда
		// последний период
			Стр.ПроцентОтгрузки = ПроцентовКРаспределению;
		Иначе
			Стр.ПроцентОтгрузки = Процент;
			ПроцентовКРаспределению = ПроцентовКРаспределению - Стр.ПроцентОтгрузки;
		КонецЕсли;
	КонецЦикла;	
	ЗначениеВРеквизитФормы(СпрОб, "Объект");
	
	
КонецПроцедуры

&НаКлиенте
Процедура БалансПроцентовИСуммОтгр( Вариант = 1)
	Если Объект.ЭтапыГрафикаОтгрузки.Количество() <> 0 Тогда
		//
		ИтогоПроцент = Объект.ЭтапыГрафикаОтгрузки.Итог("ПроцентОтгрузки");
		Стр = Объект.ЭтапыГрафикаОтгрузки[Объект.ЭтапыГрафикаОтгрузки.Количество()-1];
		Стр.ПроцентОтгрузки = Стр.ПроцентОтгрузки + (100-ИтогоПроцент);
		// чтобы округлить
		ПересчетСуммГрафикаПлатежейОтгр( Вариант );
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПересчетСуммГрафикаПлатежейОтгр( Вариант = 1 )
	//СуммаРаспределено = 0;
	Если Объект.ЭтапыГрафикаОтгрузки.Количество() <> 0 Тогда
		// последняя строка
		Стр = Объект.ЭтапыГрафикаОтгрузки[Объект.ЭтапыГрафикаОтгрузки.Количество()-1];
		Стр.СуммаОтгрузки   = Объект.СуммаДокумента;
		
		// вариант 1, сумма от процентов
		Для Н = 0 ПО Объект.ЭтапыГрафикаОтгрузки.Количество()-2 Цикл
			СтрН 				= Объект.ЭтапыГрафикаОтгрузки[Н];
			Если Вариант = 1 Тогда
				СтрН.СуммаОтгрузки	= Объект.СуммаДокумента * СтрН.ПроцентОтгрузки /100;
			Иначе
				СтрН.ПроцентОтгрузки	= СтрН.СуммаОтгрузки/Объект.СуммаДокумента * 100;
			КонецЕсли;
			
			//СуммаРаспределено 	= СуммаРаспределено + СтрН.СуммаПлатежа;
			Стр.СуммаОтгрузки  	= Стр.СуммаОтгрузки 	- СтрН.СуммаОтгрузки;
		КонецЦикла;
		
		// 
		//СуммаРаспределено 	= СуммаРаспределено + Стр.СуммаПлатежа;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ЭтапыГрафикаОтгрузкиПослеУдаления(Элемент)
	БалансПроцентовИСуммОтгр(2);
КонецПроцедуры
//////////////////////////////////////////////////////////
