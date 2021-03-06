﻿&НаСервереБезКонтекста
Функция ЧасовИзФайлаExcel( ЧасовТекст )
	Если НЕ ЗначениеЗаполнено( ЧасовТекст ) Тогда Возврат 0; КонецЕсли;
	Возврат Число( ЧасовТекст );
		
КонецФункции

&НаСервереБезКонтекста
Функция ДатаИзФайлаExcel( ДатаТекст)
	Попытка
		День 	= Число(Лев(ДатаТекст,2));
		Месяц 	= Число(Сред(ДатаТекст,4,2));	 
		Год 	= Число(Сред(ДатаТекст,7,4));	 
		Возврат Дата( Год, Месяц, День );
	Исключение
		Возврат Неопределено;
	КонецПопытки;
КонецФункции

&НаСервереБезКонтекста
Функция ПроведеннаяСметаЗадачи( ПланРабот )
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СметаЗадачиПроектаДокументы.Ссылка
		|ИЗ
		|	Документ.СметаЗадачиПроекта.Документы КАК СметаЗадачиПроектаДокументы
		|ГДЕ
		|	СметаЗадачиПроектаДокументы.Документ = &Документ
		|	И СметаЗадачиПроектаДокументы.Ссылка.Проведен";

	Запрос.УстановитьПараметр("Документ", ПланРабот);
	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	Возврат Неопределено;

КонецФункции

&НаСервереБезКонтекста
Функция МассивИсполнителейЗадачиПроекта( ПланРабот, ПериодРегистрации )
	ЗадачаПроекта = ПланРабот.ЗадачаПроекта;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗадачиПроектовИсполнители.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ЗадачиПроектовИсполнители.ФизическоеЛицо.Представление КАК ФизическоеЛицоПредставление
		|ИЗ
		|	Справочник.ЗадачиПроектов.Исполнители КАК ЗадачиПроектовИсполнители
		|ГДЕ
		|	ЗадачиПроектовИсполнители.Ссылка.Ссылка = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СотрудникиСрезПоследних.ФизическоеЛицо,
		|	СотрудникиСрезПоследних.ФизическоеЛицо.Представление
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&Дата,
		|			СтатусСотрудника.Активный
		|				И Подразделение = &Подразделение
		|				И &ВключаяСотрудниковПодразделения) КАК СотрудникиСрезПоследних
		|
		|УПОРЯДОЧИТЬ ПО
		|	ФизическоеЛицоПредставление";

	Запрос.УстановитьПараметр("Ссылка", ЗадачаПроекта );
	Запрос.УстановитьПараметр("Дата", 	ПериодРегистрации );
	Запрос.УстановитьПараметр("Подразделение", ЗадачаПроекта.Подразделение );
	Запрос.УстановитьПараметр("ВключаяСотрудниковПодразделения", НЕ ЗадачаПроекта.ТолькоИсполнители );

	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизическоеЛицо");
	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Функция ПланНаМесяцПоПлануРабот( ПланРабот, ПериодРегистрации )
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФронтРаботОбороты.ТарифнаяСтавка,
		|	СУММА(ФронтРаботОбороты.КоличествоОборот) КАК План,
		|	ФронтРаботОбороты.Должность
		|ИЗ
		|	РегистрНакопления.ФронтРабот.Обороты КАК ФронтРаботОбороты
		|ГДЕ
		|	ФронтРаботОбороты.Месяц = &Месяц
		|	И ФронтРаботОбороты.ТипСуммы = 0
		|	И ФронтРаботОбороты.ПланРабот = &ПланРабот
		|
		|СГРУППИРОВАТЬ ПО
		|	ФронтРаботОбороты.ТарифнаяСтавка,
		|	ФронтРаботОбороты.Должность";

	Запрос.УстановитьПараметр("Месяц", 		ПериодРегистрации);
	Запрос.УстановитьПараметр("ПланРабот", 	ПланРабот);
	
	Результат = Запрос.Выполнить().Выгрузить();
	Возврат Результат;
	
КонецФункции


&НаСервереБезКонтекста
Функция СписокПодзадачЗадачиПроекта( ПланРабот );
	ЗадачаПроекта = ПланРабот.ЗадачаПроекта;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтруктураЗадачиПроекта.Ссылка КАК Подзадача,
		|	СтруктураЗадачиПроекта.Код,
		|	СтруктураЗадачиПроекта.Наименование
		|ИЗ
		|	Справочник.ЗадачиПроектовСтруктура КАК СтруктураЗадачиПроекта
		|ГДЕ
		|	СтруктураЗадачиПроекта.Владелец = &Владелец
		|	И НЕ СтруктураЗадачиПроекта.Закрыта
		|
		|УПОРЯДОЧИТЬ ПО
		|	СтруктураЗадачиПроекта.Код";

	Запрос.УстановитьПараметр("Владелец", ЗадачаПроекта);

	Сп = Новый СписокЗначений;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Сп.Добавить( Выборка.Подзадача, "" + Выборка.Код + ", " + Выборка.Наименование );
	КонецЦикла;
	Возврат Сп;

КонецФункции

&НаСервереБезКонтекста
Функция МассивСтавокПоЗадачеПроекта( ПланРабот, ПериодРегистрации )
	
	// 2015 07 06
	//Результат = ПланНаМесяцПоЗадачеПроекта( ПланРабот.ЗадачаПроекта, ПериодРегистрации );
	Результат 	= ПланНаМесяцПоПлануРабот( ПланРабот, ПериодРегистрации );
	
	Возврат Результат.ВыгрузитьКолонку("ТарифнаяСтавка");
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗагрузитьЗадачуСтруктурыПроекта( ЗадачаПроекта, НазваниеЗадачиСтруктурыПроекта )
	Если ЗначениеЗаполнено( НазваниеЗадачиСтруктурыПроекта ) Тогда
		СпрСс = Справочники.ЗадачиПроектовСтруктура.НайтиПоНаименованию( НазваниеЗадачиСтруктурыПроекта, Истина, , ЗадачаПроекта);
		Если НЕ СпрСс.Пустая() Тогда
			Возврат СпрСс.Ссылка;
		Иначе
			Сообщение 		= Новый СообщениеПользователю;
			Сообщение.Текст = "Не найдена задача " + НазваниеЗадачиСтруктурыПроекта;
			Сообщение.Сообщить();
			
		КонецЕсли;
	КонецЕсли;
	Возврат "";
КонецФункции

&НаСервереБезКонтекста
Функция ЗагрузитьТарифнуюСтавку( ФизическоеЛицо, Дата, НазваниеТарифнойСтавки )
	Если ЗначениеЗаполнено( НазваниеТарифнойСтавки ) Тогда
		СпрСс = Справочники.ТарифныеСтавки.НайтиПоНаименованию( НазваниеТарифнойСтавки, Истина );
		Если НЕ СпрСс.Пустая() Тогда
			Возврат СпрСс;
		Иначе
			Сообщение 		= Новый СообщениеПользователю;
			Сообщение.Текст = "Не найдена тарифная ставка [" + НазваниеТарифнойСтавки + "] у " + ФизическоеЛицо + " на " + Формат( Дата, "ДЛФ=DD");
			Сообщение.Сообщить();
			
		КонецЕсли;
	КонецЕсли;
	Возврат ТарифнаяСтавкаФизическогоЛица( ФизическоеЛицо, Дата );
			
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуОстатков( )
	ОстаткиПлана.Очистить();
	// 2015 07 06
	//ЗадачаПроекта 	= Объект.ПланРабот.ЗадачаПроекта;
	//ПланНаМесяц 	= ПланНаМесяцПоЗадачеПроекта( ЗадачаПроекта, Объект.ПериодРегистрации );
	ПланНаМесяц 	= ПланНаМесяцПоПлануРабот( Объект.ПланРабот, Объект.ПериодРегистрации );
	ОстаткиПлана.Загрузить( ПланНаМесяц );
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСпискиВыбора()
	ПланРабот = Объект.ПланРабот;
	// 1 
	мСтавок = МассивСтавокПоЗадачеПроекта( ПланРабот, Объект.ПериодРегистрации  );
	ЭтаФорма.Элементы.РабочееВремяТарифнаяСтавка.СписокВыбора.ЗагрузитьЗначения( мСтавок );
	// 2
	мИсполнители = МассивИсполнителейЗадачиПроекта( ПланРабот, Объект.ПериодРегистрации );
	Если мИсполнители.Количество() = 0 Тогда
		ЭтаФорма.Элементы.РабочееВремяФизическоеЛицо.РежимВыбораИзСписка	=	Ложь;
	Иначе
		ЭтаФорма.Элементы.РабочееВремяФизическоеЛицо.РежимВыбораИзСписка	=	Истина;
		ЭтаФорма.Элементы.РабочееВремяФизическоеЛицо.СписокВыбора.ЗагрузитьЗначения( мИсполнители );
	КонецЕсли;
	
	// 3
	сЗадач	= СписокПодзадачЗадачиПроекта( ПланРабот );
	Если сЗадач.Количество() = 0 Тогда
		ЭтаФорма.Элементы.РабочееВремяЗадача.Доступность			=	Ложь;
	Иначе
		ЭтаФорма.Элементы.РабочееВремяЗадача.Доступность			=	Истина;
		ЭтаФорма.Элементы.РабочееВремяЗадача.РежимВыбораИзСписка	=	Истина;
		Для Каждого Эл ИЗ сЗадач Цикл
			ЭтаФорма.Элементы.РабочееВремяЗадача.СписокВыбора.Добавить(  Эл.Значение, Эл.Представление );
		КонецЦикла;
	КонецЕсли;
	// заполняем таблицу остатков
	ЗаполнитьТаблицуОстатков();
	
	
КонецПроцедуры


// с учетом должности
&НаКлиенте
Процедура ОбновитьОстаткиПлана()
	Для Каждого СтрОст ИЗ ОстаткиПлана Цикл
		СтрОст.Закрыто 		= 0;
		СтрОст.НеЗакрыто 	= СтрОст.План;
	КонецЦикла;
	
	мУдалить = Новый Массив;
	//
	Для Каждого Стр ИЗ Объект.РабочееВремя Цикл
		м = ОстаткиПлана.НайтиСтроки( Новый Структура( "ТарифнаяСтавка,Должность", Стр.ТарифнаяСтавка, Стр.Должность ));
		Если м.Количество() <> 0 Тогда
			СтрОст = м[0];
		Иначе
			СтрОст = ОстаткиПлана.Добавить();
			СтрОст.ТарифнаяСтавка 	= Стр.ТарифнаяСтавка;
			СтрОст.Должность 		= Стр.Должность;
		КонецЕсли;
		//
		СтрОст.Закрыто 		= СтрОст.Закрыто	+ Стр.Количество;
		СтрОст.НеЗакрыто 	= СтрОст.План  		- СтрОст.Закрыто;
		
		
	КонецЦикла;
	
	Для Каждого СтрОст ИЗ ОстаткиПлана Цикл
		Если СтрОст.Закрыто = 0 И СтрОст.План = 0 И СтрОст.НеЗакрыто = 0 Тогда
			ОстаткиПлана.Удалить( ОстаткиПлана.Индекс( СтрОст ));
		КонецЕсли;
		
	КонецЦикла;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗакрытоФронтРабот();	
	ПересчетЗакрытия();
	ЗаполнитьСпискиВыбора();
	//
	ОбновитьОстаткиПлана();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	Объект.ПериодРегистрации = НачалоМесяца( Объект.ПериодРегистрации );
	ПересчетЗакрытия();
	ЗаполнитьСпискиВыбора();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Отказ = Истина;
	
	НачалоМесяца = НачалоМесяца( Объект.ПериодРегистрации );
	КонецМесяца	 = КонецМесяца( Объект.ПериодРегистрации );
	Для Каждого СтрТабеля ИЗ Объект.РабочееВремя Цикл
		Если НЕ ДатаМежду( СтрТабеля.ДатаТабеля, НачалоМесяца, КонецМесяца ) Тогда
			Сообщение = Новый СообщениеПользователю;
			сообщение.Текст = "В строке " + СтрТабеля.НомерСтроки + " дата не входит в отчетный месяц!";
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	Отказ = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура РабочееВремяПриИзменении(Элемент)
	ЗакрытоФронтРабот();
	ПересчетЗакрытия();
	ОбновитьОстаткиПлана();
КонецПроцедуры

&НаКлиенте
Процедура РабочееВремяКоличествоЧасовПриИзменении(Элемент)
	ОбновитьОстаткиПлана();
КонецПроцедуры

//&НаКлиенте
//Процедура РабочееВремяНормаСтоимостиПриИзменении(Элемент)
//	ОбновитьОстаткиПлана();
//КонецПроцедуры

&НаКлиенте
Процедура ПланРаботПриИзменении(Элемент)
	ПересчетЗакрытия();
	ЗаполнитьСпискиВыбора();
	
КонецПроцедуры

&НаСервере
Процедура ПеренестиОтстаткиПлана( сПеренести )
	СуммаИзменений = 0;
	ДокОб	= Объект.ПланРабот.ПолучитьОбъект();
	//
	тзФР 	= ДокОб.ФронтРабот.Выгрузить();
	тзФР.Свернуть("Месяц,Должность,ТарифнаяСтавка,СтавкаФОТ", "Количество,Сумма");
	Для Каждого Эл ИЗ сПеренести Цикл
		// вычитаем из текущего месяца !!!
		Отбор 			= Новый Структура;
		ТарифнаяСтавка	= Эл.Ключ.ТарифнаяСтавка;
		Должность		= Эл.Ключ.Должность;
		
		МесяцОтКуда 	= Объект.ПериодРегистрации;
		Отбор.Вставить("Месяц", 			МесяцОтКуда );
		Отбор.Вставить("ТарифнаяСтавка",	ТарифнаяСтавка	);
		Отбор.Вставить("Должность",			Должность	);
		
		//Стр = ДокОб.ФронтРабот.НайтиСтроки( Отбор );
		Стр = тзФР.НайтиСтроки( Отбор );
		Если Стр.Количество() = 0 Тогда
		// такого быть не должно !!!
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не найден месяц " + МесяцОтКуда + " по " + ТарифнаяСтавка + ", добавлен";
			Сообщение.Сообщить();
			//
			СтрФР 					= тзФР.Добавить(); //ДокОб.ФронтРабот.Добавить();
			СтрФР.Месяц 			= МесяцОтКуда;
			СтрФР.Должность 		= Должность;
			СтрФР.ТарифнаяСтавка 	= ТарифнаяСтавка;
			
			// 2015 10 02
			Если Объект.ПланРабот.БезКоэффициентовФОТ Тогда
				СтрФР.СтавкаФОТ			= ПоказательТарифнойСтавки( ТарифнаяСтавка, МесяцОтКуда, "СтавкаФОТ"); // 
				
			ИначеЕсли Объект.ПланРабот.ЗадачаПроекта.Владелец.ГодПроекта >= 2017 Тогда
				// 2017 01 10
				СтрФР.СтавкаФОТ			= ПоказательТарифнойСтавки( ТарифнаяСтавка, МесяцОтКуда, "СтавкаФОТ"); // 
			
			Иначе
				// 2014 10 25 
				//СтрФР.СтавкаФОТ			= СтавкаФОТПодразделения( ДокОб.Подразделение, ТарифнаяСтавка, МесяцОтКуда);
				// 2014 12 16
				СтрФР.СтавкаФОТ			= СтавкаФОТПодразделенияЗакрытия( ДокОб.Подразделение, ТарифнаяСтавка, МесяцОтКуда);
			КонецЕсли;			
		Иначе
			СтрФР = Стр[0];
		КонецЕсли;
		СтрФР.Количество = СтрФР.Количество - Эл.Значение;
		СтрФР.Сумма		 = СтрФР.Количество * СтрФР.СтавкаФОТ;
		// вычитаемая сумма
		СуммаИзменений	 = СуммаИзменений - (Эл.Значение * СтрФР.СтавкаФОТ);
		// 04.02.2014
		// если сумма = 0 Тогда удаляем ее из фронта работ
		
		// 2014.10.24 если сумма меньше 0
		// если несколько строк с одной тарифной ставкой 
		Если СтрФР.Количество = 0 Тогда
			//ДокОб.ФронтРабот.Удалить( ДокОб.ФронтРабот.Индекс(СтрФР));
			тзФР.Удалить( тзФР.Индекс(СтрФР));
		КонецЕсли;
		
		
		
		// добавляем в следующий 
		МесяцКуда 	= ДобавитьМесяц( Объект.ПериодРегистрации, 1);
		Отбор 		= Новый Структура;
		Отбор.Вставить("Месяц", 			МесяцКуда);
		Отбор.Вставить("ТарифнаяСтавка", 	ТарифнаяСтавка );
		Отбор.Вставить("Должность",			Должность	);
		
		//Стр = ДокОб.ФронтРабот.НайтиСтроки( Отбор );
		Стр = тзФР.НайтиСтроки( Отбор );
		Если Стр.Количество() = 0 Тогда
		// такого быть не должно !!!
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не найден план на " + МесяцКуда + " по " + ТарифнаяСтавка + ", добавлен";
			Сообщение.Сообщить();
		
			СтрФР 					= тзФР.Добавить(); // ДокОб.ФронтРабот.Добавить();
			СтрФР.Месяц 			= МесяцКуда;
			СтрФР.ТарифнаяСтавка 	= ТарифнаяСтавка;
			СтрФР.Должность 		= Должность;							//  ????? - видимо ошибка
			
			// 2015 10 02
			Если Объект.ПланРабот.БезКоэффициентовФОТ Тогда
				СтрФР.СтавкаФОТ		= ПоказательТарифнойСтавки( ТарифнаяСтавка, МесяцКуда, "СтавкаФОТ"); // /8; не помню
				
			ИначеЕсли Объект.ПланРабот.ЗадачаПроекта.Владелец.ГодПроекта >= 2017 Тогда
				// 2017 01 10
				СтрФР.СтавкаФОТ		= ПоказательТарифнойСтавки( ТарифнаяСтавка, МесяцКуда, "СтавкаФОТ"); // 
				
			Иначе
				// 2014 10 25 
				//СтрФР.СтавкаФОТ			= СтавкаФОТПодразделения( ДокОб.Подразделение, ТарифнаяСтавка, МесяцКуда);
				// 2014 12 16
				СтрФР.СтавкаФОТ		= СтавкаФОТПодразделенияЗакрытия( ДокОб.Подразделение, ТарифнаяСтавка, МесяцКуда);
			КонецЕсли;			
			
		Иначе
			СтрФР = Стр[0];
		КонецЕсли;
		// переносим
		СтрФР.Количество = СтрФР.Количество + Эл.Значение;
		СтрФР.Сумма		 = СтрФР.Количество * СтрФР.СтавкаФОТ;
		// прибавляемая сумма
		СуммаИзменений	 = СуммаИзменений + (Эл.Значение * СтрФР.СтавкаФОТ);
		
	КонецЦикла;
	// из-за того, что ставки фот могут быть изменены между месяцами правим сумму остаток по смете
	// 
	ДокОб.ФронтРабот.Загрузить( тзФР );
	ДокОб.ОстатокПоСмете 	= ДокОб.ОстатокПоСмете - СуммаИзменений;
	
	Попытка
		// перепроводим план работ
		ДокОб.Записать( РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный );
		
		//НЕ НУЖНО ПЕРЕПРОВОДИТЬ СМЕТУ ЗАДАЧИ, ЕСЛИ ДАЖЕ и ПОТРЕБУЕТСЯ НУЖНО ЭТО ДЕЛАТЬ В ПЛАНЕ РАБОТ
		//ДокСметаЗадачи			= ПроведеннаяСметаЗадачи( Объект.ПланРабот );
		//Если ДокСметаЗадачи <> Неопределено Тогда
		//	ДокСметаЗадачи_Об = ДокСметаЗадачи.ПолучитьОбъект();
		//	// 
		//	УстановитьПривилегированныйРежим( Истина );
		//	ДокСметаЗадачи_Об.Записать( РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный );
		//	УстановитьПривилегированныйРежим( Ложь );
		//КонецЕсли;
		
		// заново читаем таблицу остатков
		ЗаполнитьТаблицуОстатков();
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки();
		Сообщение.Сообщить();
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсправитьППЗ( РезультатВопроса, ДопПарам ) Экспорт
	сПеренести = Новый Соответствие;
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Для Каждого СтрОП ИЗ ОстаткиПлана Цикл
			Если 		 СтрОП.НеЗакрыто < 0 Тогда
				ПоказатьПредупреждение(,"Отрицательные значения колонки 'Не закрыто' не переносятся!", 10);
				Возврат;
			ИначеЕсли 	 СтрОП.НеЗакрыто > 0 Тогда
				//
				сКлюч = Новый Структура;
				сКлюч.Вставить( "ТарифнаяСтавка",  	СтрОП.ТарифнаяСтавка);
				сКлюч.Вставить( "Должность",  		СтрОП.Должность);
				
				сПеренести.Вставить(сКлюч, СтрОП.НеЗакрыто );
				//сПеренести.Вставить(СтрОП.ТарифнаяСтавка, СтрОП.НеЗакрыто );
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Если сПеренести.Количество() <> 0 Тогда
		ПеренестиОтстаткиПлана( сПеренести );
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсправитьПланПоЗакрытию(Команда)
	ОпОповещения = Новый ОписаниеОповещения("ИсправитьППЗ", ЭтаФорма);
	ПоказатьВопрос(ОпОповещения, "Перенести не закрытые остатки плана работ на следующий месяц?", РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
	Если ПустаяСтрока(ФайлЗагрузкиExcel) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Укажите файл Microsoft Excel.";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	//Если Объект.РабочееВремя.Количество() <> 0 Тогда
	//	Если Вопрос("При загрузке текущий табель будет очищен, продолжить?", РежимДиалогаВопрос.ДаНет)=КодВозвратаДиалога.Да Тогда
	//	Иначе
	//		Возврат;
	//	КонецЕсли;
	//КонецЕсли;
		
	ОбработкаФайла();
	//
	ОбновитьОстаткиПлана();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаФайла()
	ТаблицаЗагрузки = Новый ТабличныйДокумент;
	
	Попытка
		// Загрузка Microsoft Excel
		//Сообщить("Загрузка Microsoft Excel...");
		ExcelПриложение = Новый COMОбъект("Excel.Application");
		
	Исключение
		Сообщение = новый СообщениеПользователю;
		Сообщение.Текст = "Ошибка при загрузке Microsoft Excel." + Символы.ПС + ОписаниеОшибки();
		сообщение.Сообщить();
		Возврат;
		
	КонецПопытки;
		
	Попытка
		
		// Открытие файла Microsoft Excel
		//Состояние("Открытие файла Microsoft Excel...");
		ExcelФайл = ExcelПриложение.WorkBooks.Open(ФайлЗагрузкиExcel);
		
		// Обработка файла Microsoft Excel
		//Состояние("Обработка файла Microsoft Excel...");
		ExcelЛист = ExcelФайл.Sheets(1);
		xlCellTypeLastCell = 11;
		ExcelПоследняяСтрока = ExcelЛист.Cells.SpecialCells(xlCellTypeLastCell).Row;
		ExcelПоследняяКолонка = ExcelЛист.Cells.SpecialCells(xlCellTypeLastCell).Column;
		
		//ТаблицаЗагрузки.Очистить();
		
		Для Строка = 1 По ExcelПоследняяСтрока Цикл
			
			Для Колонка = 1 По ExcelПоследняяКолонка Цикл
				
				//Состояние("Обработка файла Microsoft Excel : "
							//+ "строка " + Строка + " из " + ExcelПоследняяСтрока
							//+ ", колонка " + Колонка + " из " + ExcelПоследняяКолонка);
				ExcelЯчейка = ExcelЛист.Cells(Строка, Колонка);
				ТаблицаЗагрузки.Область(Строка, Колонка, Строка, Колонка).Текст = ExcelЯчейка.Value;
				
			КонецЦикла;
			
		КонецЦикла;
		
	Исключение
		Сообщение = новый СообщениеПользователю;
		Сообщение.Текст = "Ошибка при открытии/чтении файла " + ФайлЗагрузкиExcel + "." + Символы.ПС + ОписаниеОшибки();
		Сообщение.Сообщить();
		
		
	КонецПопытки;
			
	ExcelПриложение.Quit();
	
	ОтбработатьТаблицуЗагрузки( ТаблицаЗагрузки );
	
КонецПроцедуры // ОбработкаФайла(Элемент)

&НаСервереБезКонтекста
Функция ПланРаботИзФайлаExcel( НомерПланаРабот, Дата )
	// если в номере плана работ есть указание на структуру задачи
	сПР = УП_ПланыРаботПоПроектам.ПланРаботИзФайлаExcel( НомерПланаРабот, Дата );
	
	Возврат сПР.Основание;
	
	//ДокСс = Документы.ПланРабот.НайтиПоНомеру( НомерПланаРабот, Дата );
	//Возврат ДокСс;
КонецФункции

&НаСервереБезКонтекста
Функция ТарифнаяСтавкаФизическогоЛица( ФизическоеЛицо, Дата )
	МенЗап = РегистрыСведений.ТарифныеСтавкиФизическихЛиц.ПолучитьПоследнее( Дата, Новый Структура( "ФизическоеЛицо", ФизическоеЛицо ));
	Возврат МенЗап.ТарифнаяСтавка;
	
КонецФункции


&НаСервере
Процедура ОтбработатьТаблицуЗагрузки( ТаблицаЗагрузки )
	
	//ТаблицаЗагрузки = Новый ТабличныйДокумент;
	ФИО = ТаблицаЗагрузки.Область(1,1).Текст;
	Если НЕ ЗначениеЗаполнено( ФИО ) Тогда
		Сообщение = новый СообщениеПользователю;
		Сообщение.Текст = "Не указан сотрудник!";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	Документ 		= РеквизитФормыВЗначение("Объект");
	
	// ???
	//Документ.РабочееВремя.Очистить();
	// по умолчанию
	КодОтметкиТабеляПоУмолчанию	= "02"; // работы по проекту
	ФизическоеЛицо				= Справочники.ФизическиеЛица.НайтиПоКоду( ФИО );
	
	Если ФизическоеЛицо.Пустая() Тогда
		Сообщение = новый СообщениеПользователю;
		Сообщение.Текст = "Не найден сотрудник [" + ФизическоеЛицо + "]";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	//
	Для Н = 3 ПО ТаблицаЗагрузки.ВысотаТаблицы Цикл
		
		// дата 
		Дата = ДатаИзФайлаExcel( ТаблицаЗагрузки.Область(Н,1).Текст);
		Если Дата = Неопределено Тогда Прервать; КонецЕсли;
		Если НЕ ДатаМежду( Дата, НачалоМесяца( Документ.ПериодРегистрации), КонецМесяца( Документ.ПериодРегистрации )) Тогда
			Продолжить;
		КонецЕсли;
		//
		// отметка табеля
		ОтметкаТабеля	= ТаблицаЗагрузки.Область(Н,3).Текст;
		Если ОтметкаТабеля <> КодОтметкиТабеляПоУмолчанию Тогда Продолжить; КонецЕсли;
		
		
		// план работ
		ПланРабот = ПланРаботИзФайлаExcel( ТаблицаЗагрузки.Область(Н,4).Текст, Дата );
		Если ПланРабот <>  Объект.ПланРабот Тогда Продолжить; КонецЕсли;
		
		// продолжительность
		КоличествоЧасов = ЧасовИзФайлаExcel( ТаблицаЗагрузки.Область(Н,2).Текст );
		Если КоличествоЧасов 	= 0 Тогда Продолжить; КонецЕсли;
		
		// дата и время есть !!!
		СтрТаб = Документ.РабочееВремя.Добавить();
		//
		сДолжности 	= ДолжностиДляПланаРабот( ФизическоеЛицо, Дата, Объект.ПланРабот);
		ЗаполнитьЗначенияСвойств( СтрТаб, сДолжности );
		
		СтрТаб.ТарифнаяСтавка	= ЗагрузитьТарифнуюСтавку( ФизическоеЛицо, Дата, СокрЛП(ТаблицаЗагрузки.Область(Н,7).Текст) );
		//СтрТаб.Подразделение 	= ПодразделениеСотрудника( ФизическоеЛицо, Дата, ПланРабот );
		//СтрТаб.Должность		= 
		СтрТаб.ДатаТабеля 		= Дата;
		СтрТаб.ФизическоеЛицо	= ФизическоеЛицо;
		СтрТаб.Количество		= КоличествоЧасов;
		СтрТаб.Результат		= ТаблицаЗагрузки.Область(Н,5).Текст;
		СтрТаб.Задача			= ЗагрузитьЗадачуСтруктурыПроекта( Объект.ПланРабот.ЗадачаПроекта, СокрЛП(ТаблицаЗагрузки.Область(Н,6).Текст) );
		
	КонецЦикла;
	Документ.РабочееВремя.Сортировать("ДатаТабеля,ФизическоеЛицо");
	
	// закрываем
	ЗначениеВРеквизитФормы(Документ, "Объект");
	
КонецПроцедуры


&НаКлиенте
Процедура ФайлЗагрузкиExcelНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла( РежимДиалогаВыбораФайла.Открытие );
	ДиалогОткрытияФайла.ПолноеИмяФайла 	= "";
	ДиалогОткрытияФайла.Фильтр			= "Лист Excel(*.xls)|*.xls|Лист Excel2007-...(*.xlsx)|*.xlsx";
	
	ДиалогОткрытияФайла.ПолноеИмяФайла	= ФайлЗагрузкиExcel;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Укажите файл для загрзки'");
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ФайлЗагрузкиExcel = ДиалогОткрытияФайла.ПолноеИмяФайла;
	КонецЕсли;
	

КонецПроцедуры


&НаКлиенте
Процедура Обновить(Команда)
	ЗаполнитьТаблицуОстатков();
	ОбновитьОстаткиПлана();
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьПоТРВ_НаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	//Документ = Документы.ТабельРаботПоЗадачеПроекта.СоздатьДокумент();
	Документ.РабочееВремя.Очистить();
	
	// 
	Результат = УП_ПланыРаботПоПроектам.ОтметкиРабочегоВремениПоПлануРабот( Документ.ПериодРегистрации, Документ.ПланРабот );

	Документ.РабочееВремя.Загрузить( Результат );
	
	ЗначениеВРеквизитФормы(Документ, "Объект");

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТРВ( РезультатВопроса, ДопПарам ) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПоТРВ_НаСервере();
		ОбновитьОстаткиПлана();
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоТРВ(Команда)
	ОпОповещения = Новый ОписаниеОповещения("ЗаполнитьТРВ", ЭтаФорма);
	ПоказатьВопрос(ОпОповещения,"Заполнить по Табелям рабочего времени сотрудников?", РежимДиалогаВопрос.ДаНет);
	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодразделениеСотрудника( ФизическоеЛицо, Дата, ПланРабот )
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.Подразделение
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&Дата,
		|			ФизическоеЛицо = &ФизическоеЛицо
		|				И СтатусСотрудника.Активный) КАК СотрудникиСрезПоследних";
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Подразделение;
	КонецЦикла;
	
	Возврат  ПланРабот.ЗадачаПроекта.Подразделение;
КонецФункции


// если должность
&НаСервереБезКонтекста
Функция ДолжностиДляПланаРабот( ФизическоеЛицо, ПериодРегистрации, ПланРабот )
	тз 		= УП_КадрыСервер.СотрудникиФизЛица( ФизическоеЛицо, ПериодРегистрации );
	сДолжн 	= Новый Структура("ТарифнаяСтавка,Должность,Подразделение");
	Если тз.Количество() <> 0 Тогда
		ЗаполнитьЗначенияСвойств( сДолжн, тз[0] );
	КонецЕсли;
	Возврат сДолжн; 
	
КонецФункции


&НаКлиенте
Процедура РабочееВремяФизическоеЛицоПриИзменении(Элемент)
	ТекДанные 	= Элементы.РабочееВремя.ТекущиеДанные;
	сДолжности 	= ДолжностиДляПланаРабот( ТекДанные.ФизическоеЛицо, Объект.ПериодРегистрации, Объект.ПланРабот);
	ЗаполнитьЗначенияСвойств( ТекДанные, сДолжности );
	ОбновитьОстаткиПлана();
	
	//ТекДанные.Подразделение = ПодразделениеСотрудника( ТекДанные.ФизическоеЛицо, Объект.ПериодРегистрации, Объект.ПланРабот );
КонецПроцедуры


&НаКлиенте
Процедура РабочееВремяДолжностьПриИзменении(Элемент)
	ОбновитьОстаткиПлана();
КонецПроцедуры


&НаКлиенте
Процедура РабочееВремяТарифнаяСтавкаПриИзменении(Элемент)
	ОбновитьОстаткиПлана();
КонецПроцедуры

&НаСервере
Процедура ЗакрытоФронтРабот()
	Подразделение 	= Объект.ПланРабот.Подразделение;
	ИтЗакрытоФР 	= 0;
	Для Каждого Стр ИЗ Объект.РабочееВремя Цикл;
		// 2015 10 02
		Если Объект.ПланРабот.БезКоэффициентовФОТ Тогда
			Цена	= ПоказательТарифнойСтавки( Стр.ТарифнаяСтавка, Объект.ПериодРегистрации, "СтавкаФОТ"); // /8; не помню
			
		ИначеЕсли Объект.ПланРабот.ЗадачаПроекта.Владелец.ГодПроекта >= 2017 Тогда
			// 2017 01 10
			Цена 	= ПоказательТарифнойСтавки( Стр.ТарифнаяСтавка, Объект.ПериодРегистрации, "СтавкаФОТ"); // /8; не помню
			
		Иначе
			
			Цена	= СтавкаФОТПодразделения( Подразделение, Стр.ТарифнаяСтавка, Объект.ПериодРегистрации);
		КонецЕсли;
		
		Сумма		= Цена * Стр.Количество;
		ИтЗакрытоФР = ИтЗакрытоФР + Сумма;
	КонецЦикла;
	СуммаПоСмете 	= Объект.ПланРабот.ФронтРабот.Итог("Сумма") + Объект.ПланРабот.ОстатокПоСмете;
	Если СуммаПоСмете <> 0 Тогда
		ЗакрытоФР		= Окр( ИтЗакрытоФР  / СуммаПоСмете * 100, 1);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПересчетЗакрытия()
	сЗакрыто 					= ПрочитатьЗакрытоДоТекущегоМесяца( Объект.ПериодРегистрации, Объект.ПланРабот);
	ЗакрытоДоТекущегоМесяца 	= сЗакрыто.ЗакрытоФакт;
	ЗакрытоФРдоТекущегоМесяца 	= сЗакрыто.ЗакрытоФР;
	//
	ЗакрытоИтого 	= Объект.ПроцентЗакрытия 	+ ЗакрытоДоТекущегоМесяца;
	ЗакрытоФРИтого	= ЗакрытоФР				 	+ ЗакрытоФРдоТекущегоМесяца;
КонецПроцедуры

&НаКлиенте
Процедура ПроцентЗакрытияПриИзменении(Элемент)
	ПересчетЗакрытия();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрочитатьЗакрытоДоТекущегоМесяца( ПериодРегистрации, ПланРабот )
	сЗакрыто = Новый Структура;
	сЗакрыто.Вставить("ЗакрытоФакт", 0);
	сЗакрыто.Вставить("ЗакрытоФР",	 0);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ЗакрытиеПлановРабот.ПроцентФакт) 	КАК ПроцентФакт,
		|	СУММА(ЗакрытиеПлановРабот.ПроцентСмета) КАК ПроцентФР
		|ИЗ
		|	РегистрНакопления.ЗакрытиеПлановРабот КАК ЗакрытиеПлановРабот
		|ГДЕ
		|	ЗакрытиеПлановРабот.ПланРабот = &ПланРабот
		|	И ЗакрытиеПлановРабот.Период < &ПериодРегистрации";
	
	Запрос.УстановитьПараметр("ПериодРегистрации", 	ПериодРегистрации);
	Запрос.УстановитьПараметр("ПланРабот", 			ПланРабот);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		сЗакрыто.Вставить("ЗакрытоФакт", ВыборкаДетальныеЗаписи.ПроцентФакт);
		сЗакрыто.Вставить("ЗакрытоФР",	 ВыборкаДетальныеЗаписи.ПроцентФР);
	КонецЦикла;
	Возврат сЗакрыто;
	
КонецФункции

&НаКлиенте
Процедура Группа2ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница.Имя = "ГруппаРабочееВремя" Тогда
		//ЗакрытоФронтРабот();	
		//ПересчетЗакрытия();
		//ЗаполнитьСпискиВыбора();
		////
		//ОбновитьОстаткиПлана();
	КонецЕсли;
КонецПроцедуры



&НаКлиенте
Процедура ПланРаботНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ФормаВыбора 	= ПолучитьФорму( "Документ.ПланРабот.Форма.ФормаВыбораДляТРЗП",, Элемент );
	ФормаВыбора.Открыть();
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

#Область ЗаполнениеПоПосещениям

&НаСервере
Процедура ЗаполнитьДокумент_НаСервере()
	Док = РеквизитФормыВЗначение("Объект");
	Док.РабочееВремя.Очистить();
	
	Посещения = УП_РаботаСРабочимКалендаремСервер.ПолучитьПосещенияПоПредметуПосещенияЗаМесяц( Док.ПланРабот, Док.ПериодРегистрации);
	Для Каждого СтрПосещения ИЗ Посещения Цикл
		СтрДок = Док.РабочееВремя.Добавить();
		ЗаполнитьЗначенияСвойств( СтрДок, СтрПосещения );
		// изменяем 
		СтрДок.Количество 	= СтрПосещения.Часов;
		СтрДок.Должность	= СтрПосещения.Уточнение;
		Если НЕ ЗначениеЗаполнено( СтрДок.Должность ) Тогда
			СтрДок.Должность =  УП_КадрыСервер.ПроизводственнаяДолжностьФизЛица( СтрДок.ФизическоеЛицо, СтрДок.Подразделение, СтрДок.ДатаТабеля );
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено( СтрДок.ТарифнаяСтавка ) Тогда
			СтрДок.ТарифнаяСтавка = УП_КадрыСервер.СтавкаПоДолжности( СтрДок.Должность );
		КонецЕсли;
		
	КонецЦикла;
	ЗначениеВРеквизитФормы( Док, "Объект");
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьДокументПоПосещениям( РезультатВопроса, ДопПараметры ) Экспорт
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	// непосредтвенно заполняем
	ЗаполнитьДокумент_НаСервере();

	
КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьПоПосещениям(Команда)
	Если Объект.РабочееВремя.Количество() <> 0 Тогда 
		ДопПарам = Новый Структура;
		ОпОповещения	= Новый ОписаниеОповещения( "ЗаполнитьДокументПоПосещениям", ЭтаФорма, ДопПарам );
		ПоказатьВопрос(ОпОповещения,"Перед заполнением документа он будет очищен, продолжить?", РежимДиалогаВопрос.ДаНет)
	Иначе
		ЗаполнитьДокумент_НаСервере();
	КонецЕсли;

КонецПроцедуры


#КонецОбласти