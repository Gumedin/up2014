﻿// для выбора в формах по выбранной должности

&НаСервере
Функция СтавкаПоДолжности( Должность ) Экспорт
	
	Возврат ?(Должность.Производственная, Должность.ТарифнаяСтавка, Справочники.Должности.ПустаяСсылка());
КонецФункции

// выбирает первую производственную должность 
&НаСервере
Функция ПроизводственнаяДолжностьФизЛица( ФизическоеЛицо, Подразделение, Дата = Неопределено ) Экспорт
	ДатаНачала 	 = ?(Дата = Неопределено, ТекущаяДата(), Дата );
	тзСотрудники = СотрудникиФизЛица( ФизическоеЛицо, ДатаНачала );
	Отбор = Новый Структура("Подразделение,ДолжностьПроизводственная", Подразделение, Истина );
	ВыбСтр = тзСотрудники.НайтиСтроки( Отбор );
	Если ВыбСтр.Количество() <> 0 Тогда
		Возврат ВыбСтр[0].Должность;
	КонецЕсли;
	Возврат Справочники.Должности.ПустаяСсылка();
	
КонецФункции

// есть кадровое движение другим документом по исполнению за период
// 
&НаСервере
Функция ЕстьКадровоеДвижение( КадровыйДокумент, ДатаНачала, ДатаОкончания, Исполнение ) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Сотрудники.СтатусСотрудника
		|ИЗ
		|	РегистрСведений.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И Сотрудники.Регистратор <> &КадровыйДокумент
		|	И Сотрудники.Подразделение = &Подразделение
		|	И Сотрудники.Должность = &Должность
		|	И Сотрудники.ТарифнаяСтавка = &ТарифнаяСтавка
		|	И Сотрудники.ФизическоеЛицо = &ФизическоеЛицо";

	//	
	Запрос.УстановитьПараметр("КадровыйДокумент", 	КадровыйДокумент);
	Запрос.УстановитьПараметр("ДатаНачала", 		ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", 		ДатаОкончания);
	//
	Запрос.УстановитьПараметр("Подразделение", 		Исполнение.Подразделение);
	Запрос.УстановитьПараметр("Должность", 			Исполнение.Должность);
	Запрос.УстановитьПараметр("ТарифнаяСтавка", 	Исполнение.ТарифнаяСтавка);
	Запрос.УстановитьПараметр("ФизическоеЛицо", 	КадровыйДокумент.ФизическоеЛицо);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат Истина;
	КонецЦикла;

	Возврат Ложь;
КонецФункции

// элементы справочника статусов сотрудника по их активности
//
&НаСервере
Функция ПолучитьСтатусыСотрудников( ВключатьАктивные = Истина, ВключатьНеАктивные = Ложь ) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатусыСотрудников.Ссылка
		|ИЗ
		|	Справочник.СтатусыСотрудников КАК СтатусыСотрудников
		|ГДЕ
		|	(СтатусыСотрудников.Активный
		|			И &ВключатьАктивные)
		|	ИЛИ (НЕ СтатусыСотрудников.Активный
		|			И &ВключатьНеАктивные)";

	Запрос.УстановитьПараметр("ВключатьАктивные", 	ВключатьАктивные);
	Запрос.УстановитьПараметр("ВключатьНеАктивные", ВключатьНеАктивные);

	РезультатЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку( "Ссылка" );
	Возврат РезультатЗапроса;
КонецФункции 

&НаСервере
Функция СотрудникиФизЛица( ФизическоеЛицо, ДатаНачала, СтатусыСотрудников = Неопределено ) Экспорт
	
	Если СтатусыСотрудников = Неопределено  Тогда
		СтатусыСотрудников = ПолучитьСтатусыСотрудников();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.Регистратор КАК Регистратор,
		|	СотрудникиСрезПоследних.Подразделение,
		|	СотрудникиСрезПоследних.Должность,
		|	СотрудникиСрезПоследних.ТарифнаяСтавка,
		|	СотрудникиСрезПоследних.СтатусСотрудника КАК СтатусСотрудника,
		|	СотрудникиСрезПоследних.Количество КАК Количество,
		|	СотрудникиСрезПоследних.Должность.Производственная
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(&ДатаНачала, ФизическоеЛицо = &ФизическоеЛицо) КАК СотрудникиСрезПоследних
		|ГДЕ
		|	СотрудникиСрезПоследних.СтатусСотрудника В(&СтатусыСотрудника)";

		
		
	Запрос.УстановитьПараметр("ДатаНачала", 		КонецДня(ДатаНачала));
	Запрос.УстановитьПараметр("СтатусыСотрудника",  СтатусыСотрудников);
	Запрос.УстановитьПараметр("ФизическоеЛицо", 	ФизическоеЛицо);

	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат РезультатЗапроса;
	
КонецФункции

// физические лица, работавшие в указанный период в подразделении
&НаСервере
Функция СотрудникиПодразделенияЗаПериод(Подразделение, 
										Период, 
										ВключатьНепроизводственные = Ложь, 
										СтатусыСотрудников = Неопределено,
										ВключатьНеДоступных	= Истина ) Экспорт
										
	Если СтатусыСотрудников = Неопределено  Тогда
		СтатусыСотрудников = ПолучитьСтатусыСотрудников();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.Подразделение,
		|	СотрудникиСрезПоследних.Должность,
		|	СотрудникиСрезПоследних.ТарифнаяСтавка,
		|	СотрудникиСрезПоследних.ФизическоеЛицо,
		|	СотрудникиСрезПоследних.СтатусСотрудника
		|ПОМЕСТИТЬ ВТ_ВсеСотрудники
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(&ДатаНачала, ) КАК СотрудникиСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Сотрудники.Подразделение,
		|	Сотрудники.Должность,
		|	Сотрудники.ТарифнаяСтавка,
		|	Сотрудники.ФизическоеЛицо,
		|	Сотрудники.СтатусСотрудника
		|ПОМЕСТИТЬ ВТ_Итог
		|ИЗ
		|	РегистрСведений.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И Сотрудники.Подразделение В ИЕРАРХИИ(&Подразделение)
//		|	И Сотрудники.СтатусСотрудника В(&СтатусыСотрудников)
		|	И (&ВключатьНепроизводственные
		|			ИЛИ Сотрудники.Должность.Производственная)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_ВсеСотрудники.Подразделение,
		|	ВТ_ВсеСотрудники.Должность,
		|	ВТ_ВсеСотрудники.ТарифнаяСтавка,
		|	ВТ_ВсеСотрудники.ФизическоеЛицо,
		|	ВТ_ВсеСотрудники.СтатусСотрудника
		|ИЗ
		|	ВТ_ВсеСотрудники КАК ВТ_ВсеСотрудники
		|ГДЕ
		|	ВТ_ВсеСотрудники.Подразделение В ИЕРАРХИИ(&Подразделение)
//		|	И ВТ_ВсеСотрудники.СтатусСотрудника В(&СтатусыСотрудников)
		|	И (&ВключатьНепроизводственные
		|			ИЛИ ВТ_ВсеСотрудники.Должность.Производственная)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_Итог.Подразделение,
		|	ВТ_Итог.Должность,
		|	ВТ_Итог.ТарифнаяСтавка,
		|	ВТ_Итог.ФизическоеЛицо,
		|	ВТ_Итог.СтатусСотрудника
		|ИЗ
		|	ВТ_Итог КАК ВТ_Итог
		|ГДЕ
		|	ВТ_Итог.СтатусСотрудника В(&СтатусыСотрудников)
		|	И ВЫБОР
		|			КОГДА &ВключатьНеДоступных
		|				ТОГДА Истина 
		|			ИНАЧЕ НЕ ВТ_Итог.ФизическоеЛицо.НеДоступен
		|		КОНЕЦ";

	Запрос.УстановитьПараметр("ДатаНачала", 					Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", 					Период.ДатаОкончания);
	Запрос.УстановитьПараметр("Подразделение", 					Подразделение);
	Запрос.УстановитьПараметр("СтатусыСотрудников", 			СтатусыСотрудников);
	Запрос.УстановитьПараметр("ВключатьНепроизводственные",  	ВключатьНепроизводственные);
	Запрос.УстановитьПараметр("ВключатьНеДоступных", 			ВключатьНеДоступных );

	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат РезультатЗапроса;


КонецФункции

// исправлено 2015 11 27
&НаСервере
Функция СотрудникиПодразделенияНаДату( Подразделение, Дата = Неопределено, ТолькоРаботающие = Истина, ВключатьНепроизводственные = Истина )  Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.Подразделение,
		|	СотрудникиСрезПоследних.ФизическоеЛицо,
		|	СотрудникиСрезПоследних.ТарифнаяСтавка,
		|	СотрудникиСрезПоследних.Должность,
		|	СотрудникиСрезПоследних.СтатусСотрудника,
		|	СотрудникиСрезПоследних.Количество,
		|	СотрудникиСрезПоследних.СтатусСотрудника.Активный,
		|	СотрудникиСрезПоследних.Должность.Производственная
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&ДатаОтчета,
		|			&ВсеПодразделения
		|				ИЛИ Подразделение В ИЕРАРХИИ (&Подразделение)) КАК СотрудникиСрезПоследних";
		
	//
	ДатаОтчета 	= ?(Дата =Неопределено, ТекущаяДата(), Дата );
	Запрос.УстановитьПараметр("ДатаОтчета", 		ДатаОтчета);
	//
	Запрос.УстановитьПараметр("ВсеПодразделения", 	НЕ ЗначениеЗаполнено( Подразделение));
	Запрос.УстановитьПараметр("Подразделение", 		Подразделение);
	
	// список сотрудников в подразделении, т.к. должности могут меняться, то должности не выбираем
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	// для отладки
	РезультатЗапроса.Сортировать("Подразделение,ФизическоеЛицо,Должность");
	Если ТолькоРаботающие ИЛИ ВключатьНепроизводственные Тогда
		Отбор = Новый Структура;
		Если ТолькоРаботающие Тогда
			Отбор.Вставить("СтатусСотрудникаАктивный", Истина );
		КонецЕсли;
		Если НЕ ВключатьНепроизводственные Тогда
			Отбор.Вставить("ДолжностьПроизводственная", Истина );
		КонецЕсли;
		Возврат РезультатЗапроса.Скопировать( Отбор );
	КонецЕсли;
	Возврат РезультатЗапроса;
	
КонецФункции

// массив для списка выбора должностей подразделений
//
&НаСервере
Функция МассивВыбораДолжностейПодразделения( Подразделение, Производственная = Неопределено  ) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШтатноеРасписание.Должность
		|ИЗ
		|	РегистрСведений.ШтатноеРасписание КАК ШтатноеРасписание
		|ГДЕ
		|	ШтатноеРасписание.Подразделение = &Подразделение
		|	И (&ВсеТипыДолжностей
		|			ИЛИ ШтатноеРасписание.Должность.Производственная = &Производственная)";

	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ВсеТипыДолжностей", (Производственная=Неопределено));
	Запрос.УстановитьПараметр("Производственная",  Производственная );

	РезультатЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Должность");
	
	Возврат РезультатЗапроса;
КонецФункции

&НаСервере
Функция ШтатнаяРасстановкаПодразделения( Период, Подразделение ) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиНачало.Подразделение,
		|	СотрудникиНачало.Должность,
		|	СотрудникиНачало.ТарифнаяСтавка,
		|	СотрудникиНачало.ФизическоеЛицо,
		|	СотрудникиНачало.СтатусСотрудника,
		|	СУММА(СотрудникиНачало.Количество) КАК Количество,
		|	СотрудникиНачало.Период
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&ДатаНачала,
		|			Подразделение В ИЕРАРХИИ (&Подразделение)
		|				И Количество <> 0) КАК СотрудникиНачало
		|
		|СГРУППИРОВАТЬ ПО
		|	СотрудникиНачало.СтатусСотрудника,
		|	СотрудникиНачало.ТарифнаяСтавка,
		|	СотрудникиНачало.Должность,
		|	СотрудникиНачало.ФизическоеЛицо,
		|	СотрудникиНачало.Период,
		|	СотрудникиНачало.Подразделение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Сотрудники.Подразделение,
		|	Сотрудники.Должность,
		|	Сотрудники.ТарифнаяСтавка,
		|	Сотрудники.ФизическоеЛицо,
		|	Сотрудники.СтатусСотрудника,
		|	СУММА(Сотрудники.Количество),
		|	Сотрудники.Период
		|ИЗ
		|	РегистрСведений.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Период > &ДатаНачала
		|	И Сотрудники.Подразделение В ИЕРАРХИИ(&Подразделение)
		|	И Сотрудники.Период <= &ДатаОкончания
		|
		|СГРУППИРОВАТЬ ПО
		|	Сотрудники.ФизическоеЛицо,
		|	Сотрудники.СтатусСотрудника,
		|	Сотрудники.Должность,
		|	Сотрудники.Период,
		|	Сотрудники.ТарифнаяСтавка,
		|	Сотрудники.Подразделение";

	Запрос.УстановитьПараметр("ДатаНачала", 	Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", 	Период.ДатаОкончания);
	Запрос.УстановитьПараметр("Подразделение", 	Подразделение);

	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат РезультатЗапроса;
	
КонецФункции

// либо должность есть в штатном расписании подразделения
// либо есть сотрудник, исполняющий должность сверх штатного расписания
&НаСервере
Функция ДолжностьПодразделенияПоТарифнойСтавке( ТарифнаяСтавка, Подразделение, ДатаИсполнения = Неопределено ) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ШтатноеРасписание.Должность
		|ИЗ
		|	РегистрСведений.ШтатноеРасписание КАК ШтатноеРасписание
		|ГДЕ
		|	ШтатноеРасписание.Подразделение = &Подразделение
		|	И ШтатноеРасписание.Должность.ТарифнаяСтавка = &ТарифнаяСтавка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	СотрудникиСрезПоследних.Должность
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(&ДатаИсполнения, ) КАК СотрудникиСрезПоследних
		|ГДЕ
		|	СотрудникиСрезПоследних.Подразделение = &Подразделение
		|	И СотрудникиСрезПоследних.Должность.ТарифнаяСтавка = &ТарифнаяСтавка
		|	И СотрудникиСрезПоследних.СтатусСотрудника.Активный";

	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ТарифнаяСтавка", ТарифнаяСтавка);
	Запрос.УстановитьПараметр("ДатаИсполнения", ?( ДатаИсполнения = Неопределено, ТекущаяДата(), ДатаИсполнения));

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Должность;
	КонецЦикла;
	
	Возврат Справочники.Должности.ПустаяСсылка();
КонецФункции

&НаСервере
Функция ДолжностьСотрудникаПоТарифнойСтавке( ТарифнаяСтавка, ФизическоеЛицо,  Подразделение = Неопределено, ДатаИсполнения = Неопределено ) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СотрудникиСрезПоследних.Должность
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			&ДатаИсполнения,
		|			ТарифнаяСтавка = &ТарифнаяСтавка
		|				И ФизическоеЛицо = &ФизическоеЛицо
		|				И (&ВсеПодразделения
		|					ИЛИ Подразделение = &Подразделение)) КАК СотрудникиСрезПоследних
		|ГДЕ
		|	СотрудникиСрезПоследних.Подразделение = &Подразделение
		|	И СотрудникиСрезПоследних.Должность.ТарифнаяСтавка = &ТарифнаяСтавка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	СотрудникиСрезПоследних.Должность
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(&ДатаИсполнения, ) КАК СотрудникиСрезПоследних
		|ГДЕ
		|	СотрудникиСрезПоследних.Подразделение = &Подразделение
		|	И СотрудникиСрезПоследних.Должность.ТарифнаяСтавка = &ТарифнаяСтавка
		|	И СотрудникиСрезПоследних.СтатусСотрудника.Активный";

	Запрос.УстановитьПараметр("ВсеПодразделения", 	НЕ ЗначениеЗаполнено(Подразделение));
	Запрос.УстановитьПараметр("Подразделение", 		Подразделение);
	Запрос.УстановитьПараметр("ТарифнаяСтавка", 	ТарифнаяСтавка);
	Запрос.УстановитьПараметр("ФизическоеЛицо", 	ФизическоеЛицо);
	Запрос.УстановитьПараметр("ДатаИсполнения", ?( ДатаИсполнения = Неопределено, ТекущаяДата(), ДатаИсполнения));

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Должность;
	КонецЦикла;
	
	Возврат Справочники.Должности.ПустаяСсылка();
КонецФункции


&НаСервере
Функция ПроизводственныеДолжностиПодразделения( Подразделение, ДатаИсполнения = Неопределено ) Экспорт
	мПроизвДолжностиПодразделения =  МассивВыбораДолжностейПодразделения( Подразделение, Истина );
	
	ДатаОтбора = ?( ДатаИсполнения = Неопределено, ТекущаяДата(), ДатаИсполнения);
	Отбор 		= Новый Структура;
	Отбор.Вставить( "Подразделение", Подразделение);
	ВыбСотрудники = РегистрыСведений.Сотрудники.СрезПоследних( ДатаОтбора, Отбор );
	//
	Для Каждого ТекСотрудник ИЗ ВыбСотрудники Цикл
		Если ТекСотрудник.СтатусСотрудника.Активный Тогда
			Если мПроизвДолжностиПодразделения.Найти( ТекСотрудник.Должность ) = Неопределено Тогда
				мПроизвДолжностиПодразделения.Добавить( ТекСотрудник.Должность );
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат мПроизвДолжностиПодразделения;

КонецФункции

&НаСервере
Функция ДолжностиПодразделения( Подразделение, ДатаИсполнения = Неопределено, Производственные = Неопределено ) Экспорт
	мПроизвДолжностиПодразделения =  МассивВыбораДолжностейПодразделения( Подразделение, Производственные );
	
	ДатаОтбора = ?( ДатаИсполнения = Неопределено, ТекущаяДата(), ДатаИсполнения);
	Отбор 		= Новый Структура;
	Отбор.Вставить( "Подразделение", Подразделение);
	ВыбСотрудники = РегистрыСведений.Сотрудники.СрезПоследних( ДатаОтбора, Отбор );
	//
	Для Каждого ТекСотрудник ИЗ ВыбСотрудники Цикл
		Если ТекСотрудник.СтатусСотрудника.Активный Тогда
			Если мПроизвДолжностиПодразделения.Найти( ТекСотрудник.Должность ) = Неопределено Тогда
				мПроизвДолжностиПодразделения.Добавить( ТекСотрудник.Должность );
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат мПроизвДолжностиПодразделения;

КонецФункции

&НаСервере
Функция СтатусСотрудникаНаДату( Отбор, Дата )  Экспорт
	МенЗап = РегистрыСведений.Сотрудники.ПолучитьПоследнее( Дата, Отбор );
	
	Возврат МенЗап.СтатусСотрудника;
КонецФункции


&НаСервере
Функция РуководительПодразделения( Подразделение, Дата ) Экспорт
	РП = Новый Структура;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	РуководителиПодразделенийСрезПоследних.ФизическоеЛицо КАК Руководитель,
		|	РуководителиПодразделенийСрезПоследних.Должность КАК Должность
		|ИЗ
		|	РегистрСведений.РуководителиПодразделений.СрезПоследних(&Дата, Подразделение = &Подразделение) КАК РуководителиПодразделенийСрезПоследних";

	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	РП.Вставить("Руководитель", Справочники.ФизическиеЛица.ПустаяСсылка() );
	РП.Вставить("Должность", 	Справочники.Должности.ПустаяСсылка());

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		РП.Вставить("Руководитель", ВыборкаДетальныеЗаписи.Руководитель );
		РП.Вставить("Должность", 	ВыборкаДетальныеЗаписи.Должность );
	КонецЦикла;
	Возврат РП;
КонецФункции

&НаСервере
Функция РуководительПодразделения1( Подразделение, Дата ) Экспорт
	РП = Новый Структура;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РуководителиПодразделенийСрезПоследних.ФизическоеЛицо КАК Руководитель
		|ПОМЕСТИТЬ ВТ_Руководитель
		|ИЗ
		|	РегистрСведений.РуководителиПодразделений.СрезПоследних(&Дата, Подразделение = &Подразделение) КАК РуководителиПодразделенийСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Руководитель.Руководитель,
		|	ЕСТЬNULL(СотрудникиСрезПоследних.Должность, ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка)) КАК Должность
		|ИЗ
		|	ВТ_Руководитель КАК ВТ_Руководитель
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники.СрезПоследних(&Дата, Подразделение = &Подразделение) КАК СотрудникиСрезПоследних
		|		ПО ВТ_Руководитель.Руководитель = СотрудникиСрезПоследних.ФизическоеЛицо";

	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	РП.Вставить("Руководитель", Справочники.ФизическиеЛица.ПустаяСсылка() );
	РП.Вставить("Должность", 	Справочники.Должности.ПустаяСсылка());

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		РП.Вставить("Руководитель", ВыборкаДетальныеЗаписи.Руководитель );
		РП.Вставить("Должность", 	ВыборкаДетальныеЗаписи.Должность );
	КонецЦикла;
	Возврат РП;

КонецФункции

&НаСервере
Функция ЧемРуководит( ФизическоеЛицо ) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РуководителиПодразделенийСрезПоследних.Подразделение
		|ИЗ
		|	РегистрСведений.РуководителиПодразделений.СрезПоследних(&Дата, ФизическоеЛицо = &ФизЛицо) КАК РуководителиПодразделенийСрезПоследних";
	
	Запрос.УстановитьПараметр("Дата", 		ТекущаяДата());
	Запрос.УстановитьПараметр("ФизЛицо", 	ФизическоеЛицо);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Подразделение");
	Возврат РезультатЗапроса;
	
КонецФункции

&НаСервере
Функция ДоступныеПодразделения( ФизическоеЛицо = Неопределено, НаДату = Неопределено ) Экспорт
	
	Если ФизическоеЛицо = Неопределено Тогда
		ФизическоеЛицо = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
	КонецЕсли;
	
	
	м1 = ГдеРаботает( ФизическоеЛицо, НаДату);
	
	// включают самого физ.лицо
	мДоступныеФЛ = СКД_ДоступныеФЛ( ФизическоеЛицо );
	Для Каждого дФЛ ИЗ мДоступныеФЛ Цикл
		м2 = ЧемРуководит( дФЛ );
		Для Каждого Эл ИЗ м2 Цикл
			Если м1.Найти( Эл ) = Неопределено Тогда
				м1.Добавить( Эл );
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат м1;
КонецФункции

&НаСервере
Функция ГдеРаботает( ФизическоеЛицо, НаДату = Неопределено ) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.Подразделение
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(&Дата, ФизическоеЛицо = &ФизЛицо) КАК СотрудникиСрезПоследних
		|ГДЕ
		|	СотрудникиСрезПоследних.СтатусСотрудника.Активный";
	
	Запрос.УстановитьПараметр("Дата", 		?(НаДату = Неопределено, ТекущаяДата(), НаДату));
	Запрос.УстановитьПараметр("ФизЛицо", 	ФизическоеЛицо);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Подразделение");
	Возврат РезультатЗапроса;
	
КонецФункции


&НаСервере
Функция ТарифнаяСтавкаФизЛица( ФизическоеЛицо, Дата = Неопределено ) Экспорт
	Отбор 			= Новый Структура("ФизическоеЛицо", ФизическоеЛицо );
	ДатаПоследнего 	= ?( Дата = Неопределено, ТекущаяДата(), Дата );
	сТСФизЛица 		= РегистрыСведений.ТарифныеСтавкиФизическихЛиц.ПолучитьПоследнее(ДатаПоследнего, Отбор);
	Возврат сТСФизЛица.ТарифнаяСтавка;

КонецФункции
		


//*****************************************
//	Табель рабочего времени
//*****************************************
&НаСервере
Функция  ПолучитьВидДняНаДату( ДатаНачала ) Экспорт
	
	Отбор = Новый Структура("ПроизводственныйКалендарь,Дата,Год", 	СКД_ПроизводственныйКалендарь(), ДатаНачала, Год(ДатаНачала));
	МенЗап = РегистрыСведений.ДанныеПроизводственногоКалендаря.Получить( Отбор );
	
	Возврат МенЗап.ВидДня;
КонецФункции



//******************************************************************************
//
&НаСервере
Функция РазрешеноИсправлениеТабеля( ДатаДок ) Экспорт
	ДатаЗакрытияТабеля = Константы.ДатаЗакрытияТабеля.Получить();
	Если НЕ ЗначениеЗаполнено(ДатаЗакрытияТабеля) 	Тогда Возврат Истина; КонецЕсли;
	Если ДатаДок > ДатаЗакрытияТабеля 				Тогда Возврат Истина; КонецЕсли;
	Возврат Ложь;
КонецФункции


