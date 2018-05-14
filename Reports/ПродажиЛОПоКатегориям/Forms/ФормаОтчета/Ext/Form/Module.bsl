﻿&НаСервереБезКонтекста
Функция СписокМесяцевОтчета(ПериодПродаж)
	СпМесяцев = Новый СписокЗначений;
	Д1 = НачалоМесяца( ПериодПродаж.ДатаНачала);
	Пока Д1 <= КонецМесяца(ПериодПродаж.ДатаОкончания) Цикл
		СпМесяцев.Добавить( Д1, ПредставлениеПериода( Д1, КонецМесяца( Д1), "ФП=Истина"));
		Д1 = ДобавитьМесяц(Д1,1);
	КонецЦикла;
	Возврат СпМесяцев;
КонецФункции

&НаСервереБезКонтекста
Функция  ДанныеОПродажахЗаПериод( Период, Организация )
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОтгрузкаАбонемента.Контрагент,
		|	ОтгрузкаАбонемента.ВидНоменклатуры КАК Категория,
		|	ОтгрузкаАбонемента.СуммаАбонемента,
		|	ОтгрузкаАбонемента.СуммаВендора,
		|	ОтгрузкаАбонемента.СуммаНакладныеРасходы,
		|	ОтгрузкаАбонемента.НомерСубЛицензионногоАкта КАК Номер,
		|	ОтгрузкаАбонемента.ДатаСубЛицензионногоАкта КАК Дата,
		|	ВЫБОР
		|		КОГДА ОтгрузкаАбонемента.СуммаАбонемента = 0
		|			ТОГДА 0
		|		ИНАЧЕ 100 * (1 - ОтгрузкаАбонемента.СуммаВендора / ОтгрузкаАбонемента.СуммаАбонемента)
		|	КОНЕЦ КАК ЛОСкидка,
		|	ОтгрузкаАбонемента.СуммаОплачено,
		|	ВЫБОР
		|		КОГДА ОтгрузкаАбонемента.СуммаАбонемента = 0
		|			ТОГДА 0
		|		ИНАЧЕ 100 * (1 - ОтгрузкаАбонемента.СуммаОплачено / ОтгрузкаАбонемента.СуммаАбонемента)
		|	КОНЕЦ КАК СкидкаКлиента,
		|	ОтгрузкаАбонемента.СуммаОплачено - ОтгрузкаАбонемента.СуммаВендора - ОтгрузкаАбонемента.СуммаНакладныеРасходы КАК Сумма,
		|	ОтгрузкаАбонемента.Дата КАК Месяц,
		|	ВЫБОР
		|		КОГДА ОтгрузкаАбонемента.ПровереноБух
		|			ТОГДА ""Проверено""
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК Проверено,
		|	ОтгрузкаАбонемента.Примечание
		|ИЗ
		|	Документ.ОтгрузкаАбонемента КАК ОтгрузкаАбонемента
		|ГДЕ
		|	ОтгрузкаАбонемента.Дата МЕЖДУ &НачПериода И &КонПериода
		|	И ОтгрузкаАбонемента.Проведен";
		
	Если ЗначениеЗаполнено( Организация ) Тогда
		Запрос.Текст = Запрос.Текст + "		
			|	И ОтгрузкаАбонемента.Организация = &Организация";
		Запрос.УстановитьПараметр( "Организация", Организация);
	КонецЕсли;

		
	Запрос.УстановитьПараметр( "НачПериода",  НачалоМесяца(Период.ДатаНачала));
	Запрос.УстановитьПараметр( "КонПериода",  КонецМесяца( Период.ДатаОкончания));
	
	Результат = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаР ИЗ Результат Цикл
		СтрокаР.Месяц = НачалоМесяца( СтрокаР.Месяц);
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ВывестиПодпись(ТабДок, ПечДолжность,	ПечФио, ПечДата )
	Макет 		= Отчеты.ПродажиЛОПоКатегориям.ПолучитьМакет("Отчет");
	ОбластьП	= Макет.ПолучитьОбласть("Подпись");
	
	ОбластьП.Параметры.ПечДолжность = ПечДолжность;
	ОбластьП.Параметры.ПечФио 		= ПечФио;
	ОбластьП.Параметры.ПечДата 		= Формат( ПечДата, "ДЛФ=DD");
	ТабДок.Вывести( ОбластьП );
	

КонецПроцедуры

&НаСервере
Процедура ОтчетОПродажахЛО_НаСервере( ТабДок )
	Макет 		= Отчеты.ПродажиЛОПоКатегориям.ПолучитьМакет("Отчет");
	
	// шапка
	ОбластьШ	= Макет.ПолучитьОбласть("Шапка");
	ПечПериод	= ПредставлениеПериода( НачалоМесяца( ПериодПродаж.ДатаНачала),
															КонецМесяца(  ПериодПродаж.ДатаОкончания), "ФП=Истина");
	ОбластьШ.Параметры.ПечПериод 	= ПечПериод;															
	ОбластьШ.Параметры.Организация	= ?(ЗначениеЗаполнено(Организация), Организация.Наименование, "Все организации");
	ТабДок.Вывести( ОбластьШ );
	
	
	СпМесяцев 	= СписокМесяцевОтчета(ПериодПродаж);
	тзПродажи	= ДанныеОПродажахЗаПериод( ПериодПродаж, Организация );
	
	//
	Для Каждого Месяц Из СпМесяцев Цикл
		ОбластьМ = Макет.ПолучитьОбласть("Месяц");
		ОбластьМ.Параметры.ПечМесяц = Месяц.Представление;
		ТабДок.Вывести( ОбластьМ );
		
		тзПродажиЗаМесяц = тзПродажи.Скопировать( Новый Структура("Месяц", Месяц.Значение));
		Для Каждого Продажа ИЗ тзПродажиЗаМесяц Цикл
			ОбластьК = Макет.ПолучитьОбласть("Клиент");
			ОбластьК.Параметры.Заполнить( Продажа );
			ТабДок.Вывести( ОбластьК );
		КонецЦикла;
		// продажи всего
		ОбластьВ = Макет.ПолучитьОбласть("ИтогВсего");
		ОбластьВ.Параметры.НазвИтогов 				= Месяц.Представление;
		ОбластьВ.Параметры.СуммаВендора				= тзПродажиЗаМесяц.Итог("СуммаВендора");
		ОбластьВ.Параметры.СуммаОПлачено			= тзПродажиЗаМесяц.Итог("СуммаОПлачено");
		ОбластьВ.Параметры.СуммаНакладныеРасходы	= тзПродажиЗаМесяц.Итог("СуммаНакладныеРасходы");
		ОбластьВ.Параметры.Сумма					= тзПродажиЗаМесяц.Итог("Сумма");
		ТабДок.Вывести( ОбластьВ );
		
		// по категориям
		тзПродажиЗаМесяц.Свернуть("Категория", "СуммаВендора,СуммаОПлачено,СуммаНакладныеРасходы,Сумма");
		Для Каждого ПродажаПоКатегории ИЗ тзПродажиЗаМесяц Цикл
			ОбластьИ = Макет.ПолучитьОбласть("ИтогПоКатегории");
			ОбластьИ.Параметры.Заполнить( ПродажаПоКатегории );
			ТабДок.Вывести( ОбластьИ );
		КонецЦикла;
	КонецЦикла;
	ОбластьВ = Макет.ПолучитьОбласть("ИтогВсего");
	ОбластьВ.Параметры.НазвИтогов 				= ПечПериод;
	ОбластьВ.Параметры.СуммаВендора				= тзПродажи.Итог("СуммаВендора");
	ОбластьВ.Параметры.СуммаОПлачено			= тзПродажи.Итог("СуммаОПлачено");
	ОбластьВ.Параметры.СуммаНакладныеРасходы	= тзПродажи.Итог("СуммаНакладныеРасходы");
	ОбластьВ.Параметры.Сумма					= тзПродажи.Итог("Сумма");
	ТабДок.Вывести( ОбластьВ );
	
	// по категориям
	тзПродажи.Свернуть("Категория", "СуммаВендора,СуммаОПлачено,СуммаНакладныеРасходы,Сумма");
	Для Каждого ПродажаПоКатегории ИЗ тзПродажи Цикл
		ОбластьИ = Макет.ПолучитьОбласть("ИтогПоКатегории");
		ОбластьИ.Параметры.Заполнить( ПродажаПоКатегории );
		ТабДок.Вывести( ОбластьИ );
	КонецЦикла;
	
	
КонецПроцедуры


&НаКлиенте
Процедура СформироватьОтчет(Команда)
	// если нет даты - то 
	Если ЗначениеЗаполнено( ПериодПродаж.ДатаНачала ) И
		ЗначениеЗаполнено( ПериодПродаж.ДатаОкончания) Тогда 
	Иначе
		Предупреждение("Заполните период отчета!", 10);
		Возврат;
	КонецЕсли;
			 
	ТабДок = Новый ТабличныйДокумент;
	ОтчетОПродажахЛО_НаСервере( ТабДок );
	
	// подписи
	ВывестиПодпись(ТабДок, "Заместитель руководителя", 		"С.В. Голуб", 	ТекущаяДата());
	ВывестиПодпись(ТабДок, "Руководитель отдела логистики", "Р.В. Филатов", ТекущаяДата());
	
	
	ТабДок.ТолькоПросмотр 		= Истина;
	ТабДок.АвтоМасштаб 			= Истина;
	ТабДок.ОриентацияСтраницы 	= ОриентацияСтраницы.Ландшафт;
	
	ТабДок.Показать();

КонецПроцедуры
