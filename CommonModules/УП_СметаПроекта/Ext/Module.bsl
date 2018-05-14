﻿// по сводной статье сметы расчета 
// составляет массив первичных статей
// формулу расчета расворачивает в формулу от первичных статей
&НаСервере
Процедура СтатьиФормулыРасчета( СтруктураСметы, ФормулаРасчета, мСтатьиФормулы  )  Экспорт
	Для Каждого Эл ИЗ СтруктураСметы Цикл
		Н = СтрНайти(ФормулаРасчета, Эл.Ключ );
		Если Н = 0 Тогда Продолжить; КонецЕсли;
		
		Если Эл.Значение.Итоговая Тогда
			// подставляем имя статьи на формулу ее расчета
			ФормулаРасчета = СтрЗаменить( ФормулаРасчета, Эл.Ключ, "(" + Эл.Значение.ФормулаРасчета +")");
			
			СтатьиФормулыРасчета( СтруктураСметы, ФормулаРасчета, мСтатьиФормулы );
		Иначе
			Если мСтатьиФормулы.Найти( Эл.Значение.Статья ) = Неопределено Тогда
				мСтатьиФормулы.Добавить(  Эл.Значение.Статья );
			КонецЕсли;
		КОнецЕсли;
	КонецЦикла;
КонецПроцедуры


&НаСервере
Функция ОборотыПоМассивуСтатейЗаПериод( мЗадачиПроектов, МесяцыРегистрации, мСтатьиФормулы  ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	БюджетПоМесяцамОбороты.ЗадачаПроекта,
		|	БюджетПоМесяцамОбороты.СтатьяСметы,
		|	БюджетПоМесяцамОбороты.Месяц,
		|	СУММА(ВЫБОР
		|			КОГДА БюджетПоМесяцамОбороты.ТипСуммы = &СуммаПлан
		|				ТОГДА БюджетПоМесяцамОбороты.СуммаОборот
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК СуммаПлан,
		|	СУММА(ВЫБОР
		|			КОГДА БюджетПоМесяцамОбороты.ТипСуммы = &СуммаФакт
		|				ТОГДА БюджетПоМесяцамОбороты.СуммаОборот
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК СуммаФакт,
		|	БюджетПоМесяцамОбороты.СтатьяСметы.ИмяПредопределенныхДанных КАК ИмяСтатьи
		|ИЗ
		|	РегистрНакопления.БюджетПоМесяцам.Обороты КАК БюджетПоМесяцамОбороты
		|ГДЕ
		|	БюджетПоМесяцамОбороты.Месяц В(&Месяцы)
		|	И БюджетПоМесяцамОбороты.СтатьяСметы В(&СтатьиСметы)
		|	И БюджетПоМесяцамОбороты.ЗадачаПроекта В(&ЗадачиПроектов)
		|
		|СГРУППИРОВАТЬ ПО
		|	БюджетПоМесяцамОбороты.Месяц,
		|	БюджетПоМесяцамОбороты.СтатьяСметы,
		|	БюджетПоМесяцамОбороты.ЗадачаПроекта,
		|	БюджетПоМесяцамОбороты.СтатьяСметы.ИмяПредопределенныхДанных";
		
		
	//		
	Запрос.УстановитьПараметр("СуммаПлан", Перечисления.ТипСуммыБюджета.План);
	Запрос.УстановитьПараметр("СуммаФакт", Перечисления.ТипСуммыБюджета.Факт);
	//
	Запрос.УстановитьПараметр("Месяцы", 		МесяцыРегистрации);
	Запрос.УстановитьПараметр("СтатьиСметы", 	мСтатьиФормулы);
	Запрос.УстановитьПараметр("ЗадачиПроектов", мЗадачиПроектов);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат РезультатЗапроса;
КонецФункции



// если документ включен в смету задачи, то запрещается его распроводить
// 20131112 - если документ копия, то можно
&НаСервере
Функция Есть_СметаЗадачи_СодержащаяДокумент( Документ )  Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДокументыСЗ.Ссылка КАК СметаЗадачи,
		|	ДокументыСЗ.Ссылка.ЗадачаПроекта,
		|	ДокументыСЗ.Ссылка.ЗадачаПроекта.Владелец КАК Проект
		|ИЗ
		|	Документ.СметаЗадачиПроекта.Документы КАК ДокументыСЗ
		|ГДЕ
		|	ДокументыСЗ.Ссылка.Проведен
		|	И ДокументыСЗ.Документ = &Документ";

	Запрос.УстановитьПараметр("Документ", Документ);
	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сообщить("Документ не можеть быть распроведен, т.к. он включен в смету задачи " +  Символы.ПС + 
				 ВыборкаДетальныеЗаписи.СметаЗадачи + Символы.ПС +
				 "задачи "  + ВыборкаДетальныеЗаписи.ЗадачаПроекта + Символы.ПС +
				 "проекта " + ВыборкаДетальныеЗаписи.Проект );
		Возврат Истина;
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

// структура (иерархия) итоговых статей сметы
&НаСервере
Функция ПолучитьСтруктуруСметыЗадачи( Год = Неопределено, СтатьяРодитель = Неопределено ) Экспорт
	ГодСметы 	= ?( Год = Неопределено, Год( ТекущаяДата()), Год );
	СтрСметы	= РегистрыСведений.СтруктураСметыПоГодам.ПолучитьПоследнее( Дата(Год,1,1)).СтруктураСметы;
	Если СтрСметы.Пустая() Тогда 
		Возврат Неопределено;
	КонецЕсли;
	СтруктураСметыЗадачи = Новый Структура;
	Для Каждого СтрСтруктуры ИЗ СтрСметы.Структура Цикл
		Если СтатьяРодитель <> Неопределено Тогда
			// фильтруем по родителю
			Если СтрСтруктуры.Родитель <> СтатьяРодитель Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		// структура статьи не из справочника а из описания структуры сметы
		сСтатья = Новый Структура;
		сСтатья.Вставить("КодСтатьи", 		СтрСтруктуры.КодСтатьи );
		сСтатья.Вставить("Статья", 			СтрСтруктуры.Статья);
		сСтатья.Вставить("Итоговая", 		СтрСтруктуры.Итоговая );
		сСтатья.Вставить("НомерПересчета", 	СтрСтруктуры.НомерПересчета );
		сСтатья.Вставить("ФормулаРасчета", 	СтрСтруктуры.ФормулаРасчета );
		
		//
		СтруктураСметыЗадачи.Вставить( СтрСтруктуры.Статья.ИмяПредопределенныхДанных, сСтатья );
	КонецЦикла;
	Возврат СтруктураСметыЗадачи;
	
КонецФункции

// для удобства
&НаСервере
Функция Получить_ССЗ_ПоЗадаче( ЗадачаПроекта ) Экспорт
	Год				 = ЗадачаПроекта.Владелец.ГодПроекта;
	Возврат ПолучитьСтруктуруСметыЗадачи( Год );
КонецФункции


// пересчет статей сметы 
&НаСервере
Функция ПолучитьСтруктуруРасчетаСтатейСметыЗадачи( ВидТиповойЗадачи, Год = Неопределено ) Экспорт
	ГодСметы 	= ?( (Год = Неопределено) или (Год = 0), Год( ТекущаяДата()), Год );
	Отбор		= Новый Структура;
	Отбор.Вставить( "ВидТиповойЗадачи", ВидТиповойЗадачи );
	СтрРасчета	= РегистрыСведений.РасчетСметыПоГодам.ПолучитьПоследнее( Дата(ГодСметы,1,1),Отбор).РасчетСтатейСметы;
	Если СтрРасчета.Пустая() Тогда 
		Возврат Неопределено;
	КонецЕсли;
	// переводим в структура
	СтруктураРасчета = Новый Структура;
	Для Каждого СтрСтруктуры ИЗ СтрРасчета.РасчетСметы Цикл
		СтруктураРасчета.Вставить( СтрСтруктуры.ИмяСтатьи, СтрСтруктуры );
	КонецЦикла;
	Возврат СтруктураРасчета;
	
КонецФункции

&НаСервере
Функция Получить_СРССЗ_ПоЗадаче( ЗадачаПроекта ) Экспорт
	ВидТиповойЗадачи = ЗадачаПроекта.ТиповаяЗадача.ВидТиповойЗадачи;
	Год				 = ЗадачаПроекта.Владелец.ГодПроекта;
	Возврат ПолучитьСтруктуруРасчетаСтатейСметыЗадачи( ВидТиповойЗадачи, Год);
	
КонецФункции



// имя статьи может частично совпать с частью другой статьи
// допустимо слева и справа символы
// пробел, +, -, /, (, )
&НаСервере
Функция ЗаменитьСтатьюВФормуле(Формула, ИмяЭлемента, СуммаПоСтатье )
	ДопустимыеСимволы = "+-/() ";
	Н = Найти( Формула, ИмяЭлемента );
	Если Н = 1 Тогда
		// следующий символ
		Символ = Сред( Формула, СтрДлина( ИмяЭлемента )+1, 1);
		Если Найти( ДопустимыеСимволы, Символ ) = 0 Тогда
			Возврат Формула;
		КонецЕсли;
	Иначе
		Символ1 = Сред( Формула, Н-1, 1);
		Символ2 = Сред( Формула, Н + СтрДлина( ИмяЭлемента )+1, 1);
		Если Найти( ДопустимыеСимволы, Символ1 ) = 0 Тогда
			Возврат Формула;
		КонецЕсли;
		Если Найти( ДопустимыеСимволы, Символ2 ) = 0 Тогда
			Возврат Формула;
		КонецЕсли;
	КонецЕсли;
		
	Возврат СтрЗаменить( Формула, ИмяЭлемента, СуммаПоСтатье );
КонецФункции


// расчитываем и устанавливаем сумму 
// статья бюджета
&НаСервере
Процедура ПересчетФормулы( СтрокаСтрСметы, КлючСтатьи, сСтатейСметы, сПараметровФормул, ФормулаРасчета = Неопределено ) Экспорт
	Сумма = 0;
	// если формулы нет, то сумма - 0
	Если ФормулаРасчета = Неопределено Тогда
		Формула = СтрокаСтрСметы.ФормулаРасчета;
	Иначе
		Формула = ФормулаРасчета;
	КонецЕсли;
	
	Если ЗначениеЗаполнено( Формула ) Тогда
		// сначала меняем параметры
		Если сПараметровФормул <> Неопределено Тогда
			Для Каждого Параметр ИЗ сПараметровФормул Цикл
				ИмяПараметра	= Параметр.Ключ;
				Если Найти( Формула, ИмяПараметра ) = 0 Тогда Продолжить; КонецЕсли;
				
				// !!! текстовое, правильно отформатированное значение
				ЗначПараметра	= сПараметровФормул.Получить(ИмяПараметра);
				Формула 		= СтрЗаменить( Формула, ИмяПараметра, ЗначПараметра );
			КонецЦикла;
		КонецЕсли;			
		
		// заменяем внутри формулы имя предопределенного на его значение
		Для Каждого Статья ИЗ сСтатейСметы Цикл
			// имя предопределенного 
		    ИмяЭлемента = Статья.Ключ;
			Если Найти( Формула, ИмяЭлемента ) = 0 Тогда Продолжить; КонецЕсли;
			
			// в текстовом формате
			СуммаПоСтатье 	= Формат( сСтатейСметы.Получить( ИмяЭлемента ), "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=");
			Если НЕ ЗначениеЗаполнено( СуммаПоСтатье ) Тогда
				СуммаПоСтатье = "0";
			КонецЕсли;
			// сразу меняем 
			//Формула = ЗаменитьСтатьюВФормуле(Формула, ИмяЭлемента, СуммаПоСтатье );
			// без проверки совпадения части имени статьи с другими статьями
			Формула = СтрЗаменить( Формула, ИмяЭлемента, СуммаПоСтатье );
			
		КонецЦикла;
		// пытаемся расчитать
		Попытка
			Выполнить("Сумма = " + Формула);
		Исключение
		КонецПопытки;
	КонецЕсли;
	// вставляем формулу в структуры для текущей статьи
	сСтатейСметы.Вставить( КлючСтатьи, Сумма);
	
КонецПроцедуры


// пересчет только иерархии, первичные строки уже посчитаны
//
&НаСервере
Процедура ПересчетСметыЗадачи(  сСметы, сСтатейСметы, сПараметровФормул = Неопределено ) Экспорт
	// список пересчитываемых показателей
	сПересчетов = Новый Соответствие;
	// 
	Для Каждого СтатьяСметы из сСтатейСметы Цикл
		// все статьи присутствуют в структуре сметы
		СтрокаССм = сСметы[СтатьяСметы.Ключ];
		
		// переводим ключ в ссылку 
		//СтатьяСс = Справочники.СтруктураБюджета[сСтатейСметы.Ключ];
		Если СтрокаССм.Итоговая Тогда
			НомерПересчета = СтрокаССм.НомерПересчета;
			// если в списке еще нет списка пересчетов
			сСтатейПересчета =  сПересчетов.Получить( НомерПересчета );
			Если сСтатейПересчета = Неопределено Тогда
				сПересчетов.Вставить( НомерПересчета, Новый Соответствие );
				сСтатейПересчета =  сПересчетов.Получить( НомерПересчета );
			КонецЕсли;		
			
			// ссылку
			сСтатейПересчета.Вставить( СтатьяСметы.Ключ );
		КонецЕсли;
	КонецЦикла;
	
	// Н уровней пересчета
	Для НомерПересчета = 0 По 9 Цикл
		// для пересчета конкретных статей
		сСтатейПересчетаН = сПересчетов.Получить(НомерПересчета);
		Если сСтатейПересчетаН <> Неопределено Тогда 
		// пересчитываем статьи
			Для Каждого СтатьяСметы из сСтатейПересчетаН Цикл
			// возвращаем сумму
				ПересчетФормулы( сСметы[СтатьяСметы.Ключ], СтатьяСметы.Ключ, сСтатейСметы, сПараметровФормул );
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Процедура печати документа.
// Печатает смету проекта и, как частный случай смету задачи проекта
&НаСервере
Функция ПечатьСметы(МассивОбъектов, ОбъектыПечати, ИмяМакета = "", ТипИсточника) Экспорт
	
	Если ТипИсточника = "Калькулятор сметы" Тогда
		Текст =
		"ВЫБРАТЬ
		|	КалькуляторСметы.Родитель.Наименование КАК Проект,
		|	КалькуляторСметы.Ссылка,
		|	КалькуляторСметы.ГодПроекта,
		|	КалькуляторСметы.Расчет.(
		|		КодСтатьи,
		|		ИмяСтатьи,
		|		Статья,
		|		ЗначениеПараметра,
		|		Сумма,
		|		ИзмененоДокументом,
		|		Итоговая
		|	),
		|	КалькуляторСметы.Наименование,
		|	КалькуляторСметы.ТиповаяЗадача
		|ИЗ
		|	Справочник.КалькуляторСметы КАК КалькуляторСметы
		|ГДЕ
		|	КалькуляторСметы.Ссылка В ИЕРАРХИИ(&МассивОбъектов)
		|	И НЕ КалькуляторСметы.ЭтоГруппа";
		
		
	ИначеЕсли	ТипИсточника = "Сметы задач проекта" Тогда

		Текст = 
		"ВЫБРАТЬ
		|	СметаЗадачиПроекта.ЗадачаПроекта.Владелец.Наименование КАК Проект,
		|	СметаЗадачиПроекта.Ссылка,
		|	СметаЗадачиПроекта.ЗадачаПроекта.Владелец.ГодПроекта КАК ГодПроекта,
		|	СметаЗадачиПроекта.Представление КАК Наименование,
		|	СметаЗадачиПроекта.Расчет.(
		|		Ссылка,
		|		НомерСтроки,
		|		КодСтатьи,
		|		ИмяСтатьи,
		|		Статья,
		|		ЗначениеПараметра,
		|		Сумма,
		|		ИзмененоДокументом,
		|		Итоговая
		|	),
		|	СметаЗадачиПроекта.ЗадачаПроекта.ТиповаяЗадача КАК ТиповаяЗадача
		|ИЗ
		|	Документ.СметаЗадачиПроекта КАК СметаЗадачиПроекта
		|ГДЕ
		|	СметаЗадачиПроекта.Ссылка В(&МассивОбъектов)";

		
	ИначеЕсли ТипИсточника = "Смета проекта" Тогда
		
		Текст = 
		"ВЫБРАТЬ
		|	СметаДокументы.Документ.Ссылка
		|ПОМЕСТИТЬ ВТ_СметыЗадач
		|ИЗ
		|	Документ.Смета.Документы КАК СметаДокументы
		|ГДЕ
		|	СметаДокументы.Ссылка В(&МассивОбъектов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СметаЗадачиПроекта.ЗадачаПроекта.Владелец КАК Проект,
		|	СметаЗадачиПроекта.Ссылка,
		|	СметаЗадачиПроекта.ЗадачаПроекта.Владелец.ГодПроекта КАК ГодПроекта,
		|	СметаЗадачиПроекта.Представление КАК Наименование,
		|	СметаЗадачиПроекта.Расчет.(
		|		Ссылка,
		|		НомерСтроки,
		|		КодСтатьи,
		|		ИмяСтатьи,
		|		Статья,
		|		ЗначениеПараметра,
		|		Сумма,
		|		ИзмененоДокументом,
		|		Итоговая
		|	)
		|ИЗ
		|	ВТ_СметыЗадач КАК ВТ_СметыЗадач
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СметаЗадачиПроекта КАК СметаЗадачиПроекта
		|		ПО ВТ_СметыЗадач.ДокументСсылка = СметаЗадачиПроекта.Ссылка";
		
		
	КонецЕсли;
		
	
	Запрос = Новый Запрос;
	Запрос.Текст = Текст;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Результат = Запрос.Выполнить().Выгрузить();
	
	ТабличныйДокумент 	= Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "КалькуляторСметы";
	
	//
	Макет = УправлениеПечатью.ПолучитьМакет("ОбщиеМакеты.ПФ_MXL_Смета");
	// шапка
	
	// выводим документ
	ОблЗаг	= Макет.ПолучитьОбласть("Заголовок");
	ОблЗаг.Параметры.Проект 		= Результат[0].Проект;
	ОблЗаг.Параметры.ТипИсточника 	= ТипИсточника;
	ТабличныйДокумент.Вывести(ОблЗаг);
	

	ОблШН = Макет.ПолучитьОбласть("РасчетШапка|Начало");
	ТабличныйДокумент.Вывести(ОблШН);
	
	// расчет шапки
	Для Н = 1 ПО Результат.Количество() Цикл
		ОблШД = Макет.ПолучитьОбласть("РасчетШапка|СметаЗадачи");
		ОблШД.Параметры.Заполнить( Результат[Н-1]);
		ТабличныйДокумент.Присоединить(ОблШД);
	КонецЦикла;
	ОблШИ = Макет.ПолучитьОбласть("РасчетШапка|Итого");
	ТабличныйДокумент.Присоединить(ОблШИ);
	
	// считаем итого заранее
	сСтатей = ИтогиПоСметамЗадач( Результат);
	
	// по первой строке
	Структура = Результат.Получить(0).Расчет;
	Для Каждого СтрСметы ИЗ Структура Цикл
		
		ИмяОбл 	= "Расчет" + ?(СтрСметы.Итоговая, "Итоговая", "")+ "|";
		ОблНР	= Макет.ПолучитьОбласть(ИмяОбл + "Начало");
		ОблНР.Параметры.Заполнить(СтрСметы);
		ТабличныйДокумент.Вывести(ОблНР);
		
		Для Н = 1 ПО Результат.Количество() Цикл
			ОблРД = Макет.ПолучитьОбласть(ИмяОбл + "СметаЗадачи");
			ЗаполнитьЗначенияСвойств( ОблРД.Параметры,  Результат.Получить(Н-1).Расчет.Получить( Структура.Индекс(СтрСметы)));
			
			ТабличныйДокумент.Присоединить(ОблРД);
		КонецЦикла;
		
		
		ОблРИ = Макет.ПолучитьОбласть(ИмяОбл + "Итого");
		ОблРИ.Параметры.Сумма = сСтатей.Получить( СтрСметы.ИмяСтатьи );
		ТабличныйДокумент.Присоединить(ОблРИ);
	КонецЦикла;
	// 
	ОблПодвал						= Макет.ПолучитьОбласть("Подвал");
	ОблПодвал.Параметры.Исполнитель = ПараметрыСеанса.ТекущийПользователь;
	ТабличныйДокумент.Вывести(ОблПодвал);
	
	//
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ?(Результат.Количество() < 3, ОриентацияСтраницы.Портрет, ОриентацияСтраницы.Ландшафт);
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ИтогиПоСметамЗадач( Результат )
	сСтатей = Новый Соответствие;
	Структура 	= Результат.Получить(0).Расчет;
	ГодПроекта 	= Результат.Получить(0).ГодПроекта;
	Для Каждого СтрСметы ИЗ Структура Цикл
		// инициализируем
		сСтатей.Вставить( СтрСметы.ИмяСтатьи, 0);
		
		Для Н = 1 ПО Результат.Количество() Цикл
			СтрРезультата = Результат.Получить(Н-1).Расчет.Получить( Структура.Индекс(СтрСметы));
			Если НЕ СтрСметы.Итоговая Тогда
				Сумма = сСтатей.Получить( СтрСметы.ИмяСтатьи );
				сСтатей.Вставить( СтрСметы.ИмяСтатьи, ?(Сумма=Неопределено, 0, Сумма ) + СтрРезультата.Сумма );
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;	
	
	// 2014
	сСметы 	= УП_СметаПроекта.ПолучитьСтруктуруСметыЗадачи( ГодПроекта );
	УП_СметаПроекта.ПересчетСметыЗадачи( сСметы, сСтатей );
	
	
	Возврат сСтатей;
КонецФункции

&НаСервере
Функция ПолучитьОстатокВознагражденияПоПроекту( Проект, Посредник = Неопределено )  Экспорт
	Отбор = Новый Структура("Проект", Проект);
	Если ЗначениеЗаполнено( Посредник ) Тогда
		Отбор.Вставить( "Посредник", Посредник );
	КонецЕсли;
	Возврат РегистрыНакопления.ВознаграждениеПосредника.Остатки(, Отбор).Итог("Сумма");
КонецФункции


&НаСервере
Функция ПолучитьОборотБюджетаПоСтатье( СтатьяСметы, 
									   Проект, 
									   ЗадачаПроекта = Неопределено, 
									   ТипСуммы 	 = Неопределено )  Экспорт
									   
	Если ТипСуммы = Неопределено Тогда
		ТипСуммы = Перечисления.ТипСуммыБюджета.Факт;	
	КонецЕсли;		
	// если передали только проект
	ВсеЗадачиПроекта =  (ЗадачаПроекта = Неопределено);
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(БюджетПоМесяцамОбороты.СуммаОборот) КАК СуммаОборот
		|ИЗ
		|	РегистрНакопления.БюджетПоМесяцам.Обороты(
		|			,
		|			,
		|			,
		|			ЗадачаПроекта.Владелец = &Проект
		|				И (&ВсеЗадачиПроекта
		|					ИЛИ ЗадачаПроекта = &ЗадачаПроекта)
		|				И ТипСуммы = &ТипСуммы
		|				И СтатьяСметы = &СтатьяСметы) КАК БюджетПоМесяцамОбороты";
	
	Запрос.УстановитьПараметр("Проект", 			Проект);
	Запрос.УстановитьПараметр("СтатьяСметы", 		СтатьяСметы);
	Запрос.УстановитьПараметр("ВсеЗадачиПроекта", 	ВсеЗадачиПроекта);
	Запрос.УстановитьПараметр("ЗадачаПроекта", 		ЗадачаПроекта);
	Запрос.УстановитьПараметр("ТипСуммы", 			ТипСуммы);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат РезультатЗапроса.Итог("СуммаОборот");
	
КонецФункции


// если обеспечено по договорам меньше суммы, то остаток распределяем по распределению по этапам оплаты задачи проекта
// если этапы не описаны, тогда пишем обеспечение на конец года
&НаСервере
Функция РаспределитьОстатокОбеспеченияПоЗадаче( ЗадачаПроекта,  ОстатокОб ) Экспорт

	сОбесп		= Новый Соответствие;
	Если ОстатокОб > 0 Тогда 
		ЭтапыОбеспеченияЗадачи = ЗадачаПроекта.ЭтапыГрафикаОплаты.Выгрузить();
		Если ЭтапыОбеспеченияЗадачи.Количество() > 0 Тогда
			мК = ЭтапыОбеспеченияЗадачи.ВыгрузитьКолонку( "ПроцентПлатежа" );
			мРез = РаспределитьПропорционально( ОстатокОб, мК, 2);
			Индекс = 0;
			Для Каждого Этап ИЗ ЭтапыОбеспеченияЗадачи Цикл
				сОбесп.Вставить( НачалоМесяца( Этап.ДатаПлатежа), мРез[Индекс]);
				Индекс = Индекс + 1;
			КонецЦикла;
			
		Иначе 
			// конец года
			ГодЗадачиПроекта = ЗадачаПроекта.Владелец.ГодПроекта;
			сОбесп.Вставить( НачалоМесяца( Дата( ГодЗадачиПроекта, 12, 31)), ОстатокОб );
		КонецЕсли;
	КонецЕсли;
	Возврат сОбесп;
	
КонецФункции

