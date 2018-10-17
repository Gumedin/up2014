﻿// заполняем все задачи одинаково - сверху вниз
&НаСервере
Процедура ЗаполнитьСметуПоДокументам_НаСервере(  )
	// все 
	
	// движения регистраторов сметы задачи сгруппированные по статьям
	тзДвиж = ПолучитьДвиженияДокументов();
	// по существующим движениям
	Для Каждого СтрДв ИЗ тзДвиж Цикл
		мСтр = Объект.Расчет.НайтиСтроки( Новый Структура("Статья", СтрДВ.Статья ));
		Если мСтр.Количество() <> 0 Тогда
			СтрР = мСтр[0];
			// в сумму по документам !!!
			СтрР.Сумма 				= СтрДв.Сумма;
			СтрР.ИзмененоДокументом = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
	
&НаСервереБезКонтекста
Функция СтруктураСтроки_ПоВидуТЗ( СтрокаРасчет, ЗадачаПроекта, НовыйДокумент )
	Если СтрокаРасчет = Неопределено Тогда Возврат Неопределено;КонецЕсли;
	
	//
	Стр 	= Новый Структура;
	Стр.Вставить("ПараметрДоступен", СтрокаРасчет.ЗнПараметраРучнойВвод );
	
	// если есть формула - считаем
	Процент = 0;
	Если НовыйДокумент Тогда
		Формула = СокрЛП(СтрокаРасчет.ЗнПараметраФормула);
		
		Если ЗначениеЗаполнено( Формула ) Тогда 
			// локальные переменные, чтобы упростить формулы в справочнике
			Проект 			= ЗадачаПроекта.Владелец;
			ТиповаяЗадача 	= ЗадачаПроекта.ТиповаяЗадача;
			Попытка
				Выполнить("Процент = " + Формула );
			Исключение
				Сообщить("Формула [" + Формула + "], " + ОписаниеОшибки());
				Возврат Неопределено;
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	// 
	Стр.Вставить("Процент", 				Процент);
	Стр.Вставить("ЗаполняетсяДокументами", 	СтрокаРасчет.ЗаполняетсяДокументами);
	Стр.Вставить("СуммаРучнойВвод",		 	СтрокаРасчет.СуммаРучнойВвод);
	
	Возврат Стр;
КонецФункции

&НаСервере
Процедура УстановитьПараметрыСтрок_НаСервере( НовыйДокумент )
	// чтобы не парится
	//сРасчет = УП_СметаПроекта.Получить_СРССЗ_ПоЗадаче(  Объект.ЗадачаПроекта );
	Если Объект.РасчетыСтатейСметы = Справочники.РасчетыСтатейСметы.ПустаяСсылка() Тогда 
		//Если нет параметров или конвертация при переходе, 
		//то подбираем параметры по типовой задаче и источнику финансирования
		Отбор		= Новый Структура;
		Отбор.Вставить("ВидТиповойЗадачи", Объект.ЗадачаПроекта.ТиповаяЗадача.ВидТиповойЗадачи);
		Отбор.Вставить("ИсточникФинансирования", Объект.ЗадачаПроекта.ИсточникФинансирования );
		Объект.РасчетыСтатейСметы = РегистрыСведений.РасчетСметыПоГодам
			.ПолучитьПоследнее( Дата(Объект.ЗадачаПроекта.ГодЗадачи,1,1), Отбор).РасчетСтатейСметы;
	КонецЕсли;
	
	// переводим в структура
	сРасчет = Новый Структура;
	Для Каждого СтрСтруктуры ИЗ Объект.РасчетыСтатейСметы.РасчетСметы Цикл
		сРасчет.Вставить( СтрСтруктуры.ИмяСтатьи, СтрСтруктуры );
	КонецЦикла;
	
	Если сРасчет.Количество() = 0 Тогда Возврат; КонецЕсли;
	
	// структуру параметров	
	Для Каждого Стр ИЗ Объект.Расчет Цикл
		Если НовыйДокумент Тогда
			Стр.ЗначениеПараметра 	= 0;
		КонецЕсли;
		Стр.ПараметрДоступен= Ложь;
		Стр.СуммаДоступна	= Ложь;
		
		СтрокаРасчет  		= Неопределено;
		Если ЗначениеЗаполнено(Стр.ИмяСтатьи) Тогда
		Если сРасчет.Свойство( Стр.ИмяСтатьи, СтрокаРасчет ) Тогда
			
			сП 	= СтруктураСтроки_ПоВидуТЗ( СтрокаРасчет, Объект.ЗадачаПроекта, НовыйДокумент);
			Если сП <> Неопределено Тогда
				// 2017 06 09
				Если  Стр.ИзмененоДокументом Тогда
					Стр.СуммаДоступна		= Ложь;
					Стр.ЗначениеПараметра	= 0;
					Стр.ПараметрДоступен	= Ложь;
				Иначе
					
					Если НовыйДокумент Тогда
						Стр.ЗначениеПараметра	= сП["Процент"];
					КонецЕсли;
					Стр.ПараметрДоступен	= сП["ПараметрДоступен"];
					Стр.СуммаДоступна		= сП["СуммаРучнойВвод"];
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыСтрок(  НовыйДокумент = Ложь )
	//
	УстановитьПараметрыСтрок_НаСервере(  НовыйДокумент );
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если НЕ ЗначениеЗаполнено( Объект.Ссылка ) Тогда
		УстановитьПараметрыСтрок(Истина);
		ПересчетСметыЗадачи();
	Иначе
		УстановитьПараметрыСтрок();
		
	КонецЕсли;
	// пока не разобрались
	ПересчитатьСтатьиСметы("");
КонецПроцедуры
 
// заполняем строки нового документа
&НаСервере
Процедура ИнициализироватьСметуЗадачи()
	ДокОб = РеквизитФормыВЗначение("Объект");
	ДокОб.Расчет.Очистить();
	
	// структура сметы
	ГодПроекта 		= ДокОб.ЗадачаПроекта.Владелец.ГодПроекта;
	СтруктураСметы 	= УП_СметаПроекта.ПолучитьСтруктуруСметыЗадачи( ГодПроекта );	
	Если СтруктураСметы = Неопределено Тогда
		Сообщить("Структура сметы не определена на указанный год "+ ГодПроекта);
		Возврат;
	КонецЕсли;
	// 
	СтатьяДоходы = Справочники.СтатьиСметы.ДохФинансовые;
	
	
	// по табличной части документа
	Для Каждого СтрСС ИЗ СтруктураСметы Цикл
		СтрР 			= ДокОб.Расчет.Добавить();
		ЗаполнитьЗначенияСвойств( СтрР, СтрСС.Значение );
		СтрР.ИмяСтатьи 	= СтрСС.Ключ;
		
		// сумму задачи записываем в доходы всего 
		Если СтрР.Статья	=   СтатьяДоходы Тогда
			СтрР.Сумма 	= Объект.ЗадачаПроекта.Сумма;
		КонецЕсли;
	КонецЦикла;
	
	// переводим назад в форму
	ЗначениеВРеквизитФормы(ДокОб, "Объект");
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено( Объект.ЗадачаПроекта ) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Смета задачи создается на основании задачи проекта";
		Сообщение.Сообщить();
		Отказ = Истина;
	Иначе
	
		Если Объект.Расчет.Количество() = 0 Тогда
			// заполняем строки
			ИнициализироватьСметуЗадачи();
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура РасчетПередНачаломИзменения(Элемент, Отказ)
	Стр = Элемент.ТекущиеДанные;
	// ввод параметра 
	Если Элемент.ТекущийЭлемент.Имя = "РасчетЗначениеПараметра" Тогда
		Если Стр.ПараметрДоступен Тогда
		Иначе
			Отказ = Истина;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// ввод параметра 
	Если Элемент.ТекущийЭлемент.Имя = "РасчетСумма" Тогда
		Если Стр.СуммаДоступна И НЕ Стр.ИзмененоДокументом Тогда
		Иначе
			Отказ = Истина;
		КонецЕсли;
		Возврат;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПересчетСметыЗадачи_НаСервере( ЗадачаПроекта, сРасчета, П, С, ИзмД, сРезультатСумма, сРезультатПараметр)
	// текущие значения параметров и сумм расчета
	                                                 
	// расчет по формулам справочника,                                              
	//сРасчета 	= УП_СметаПроекта.Получить_СРССЗ_ПоЗадаче( ЗадачаПроекта );
	Для Каждого РасчетСтатьи ИЗ сРасчета.РасчетСметы Цикл
		//РасчетСтатьи = Эл.Значение;
		// вводится вручную
		Если РасчетСтатьи.СуммаРучнойВвод						Тогда Продолжить; КонецЕсли;
		// нет формулы
		Если НЕ ЗначениеЗаполнено( РасчетСтатьи.СуммаФормула )  Тогда Продолжить; КонецЕсли;
		// 
		Если РасчетСтатьи.ЗаполняетсяДокументами И ИзмД[РасчетСтатьи.ИмяСтатьи] Тогда 
			Если С.Свойство(РасчетСтатьи.ИмяСтатьи) Тогда
				Сумма = С[РасчетСтатьи.ИмяСтатьи];
				
				//Пробуем в обратной пропорции посчитать %
				Если ЗначениеЗаполнено(РасчетСтатьи.СуммаФормула)
						И Сумма <> 0 И П.Свойство(РасчетСтатьи.ИмяСтатьи) Тогда 
					Попытка
						Параметр = 0;
						Формула = "Параметр = Сумма / (" + СокрЛП( РасчетСтатьи.СуммаФормула ) + ")";
						П[РасчетСтатьи.ИмяСтатьи] = 1;
						Выполнить( Формула );
						
						сРезультатПараметр.Вставить( РасчетСтатьи.ИмяСтатьи, Окр(Параметр, 2));
					Исключение
						Сообщить("Статья " + РасчетСтатьи.ИмяСтатьи +  Символы.ПС + 
								 "ошибка в формуле [" + Формула + "]" + Символы.ПС + 
								 ОписаниеОшибки());
					КонецПопытки;
				КонецЕсли;
			КонецЕсли;
		Иначе
			Попытка
				Формула = "Сумма = " + СокрЛП( РасчетСтатьи.СуммаФормула );
				Выполнить( Формула );
			Исключение
				Сообщить("Статья " + РасчетСтатьи.ИмяСтатьи +  Символы.ПС + 
						 "ошибка в формуле [" + Формула + "]" + Символы.ПС + 
						 ОписаниеОшибки());
				Сумма = 0;
			КонецПопытки;
			// ставим назад
			Если С.Свойство(РасчетСтатьи.ИмяСтатьи) Тогда
				С[РасчетСтатьи.ИмяСтатьи]	= Окр(Сумма,2);
			КонецЕсли;
			
		КонецЕсли;
		//
		сРезультатСумма.Вставить( РасчетСтатьи.ИмяСтатьи, Окр(Сумма,2));
	КонецЦикла;
	
	// пересчитываем формулы по справочнику структура бюджета 
	сСметы 	= УП_СметаПроекта.Получить_ССЗ_ПоЗадаче( ЗадачаПроекта );
	УП_СметаПроекта.ПересчетСметыЗадачи( сСметы, сРезультатСумма );
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяСтатьи( Статья )
	Возврат Статья.ИмяПредопределенныхДанных;
КонецФункции

&НаКлиенте
Процедура ПересчетСметыЗадачи()
	сРезультатСумма	= Новый Соответствие;
	сРезультатПарам = Новый Соответствие;
	сПар		= Новый Структура;
	сСуммы		= Новый Структура;
	сИзмД		= Новый Структура;
	Для Каждого Стр ИЗ Объект.Расчет Цикл
		ИмяСтатьи = ИмяСтатьи( Стр.Статья); 
		
		сПар.Вставить( 	ИмяСтатьи, Стр.ЗначениеПараметра/100 );
		сСуммы.Вставить(ИмяСтатьи, Стр.Сумма );
		сИзмД.Вставить( ИмяСтатьи, Стр.ИзмененоДокументом );

		// возвращаемый результат
		сРезультатСумма.Вставить( Стр.ИмяСтатьи, Стр.Сумма );
	КонецЦикла;
	
	// исправленные и пересчитанные суммы
	ПересчетСметыЗадачи_НаСервере( Объект.ЗадачаПроекта, Объект.РасчетыСтатейСметы,
		сПар, сСуммы, сИзмД, сРезультатСумма, сРезультатПарам);
	
	Для Каждого Стр ИЗ Объект.Расчет Цикл
		ИмяСтатьи = ИмяСтатьи(Стр.Статья); 
		Стр.Сумма = сРезультатСумма.Получить(ИмяСтатьи);
		
		Если сРезультатПарам.Получить(ИмяСтатьи) <> Неопределено Тогда 
			Стр.ЗначениеПараметра = сРезультатПарам.Получить(ИмяСтатьи) * 100;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура РасчетПриИзменении(Элемент)
	ПересчетСметыЗадачи();
КонецПроцедуры

&НаСервере
Функция ПолучитьДвиженияДокументов()
	мДок = Новый Массив;
	Для Каждого СтрД  ИЗ Объект.Документы Цикл
		мДок.Добавить( СтрД.Документ );
	КонецЦикла;
	
	Запрос = Новый Запрос;

	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(БюджетПоМесяцам.Сумма) КАК Сумма,
		|	БюджетПоМесяцам.СтатьяСметы КАК Статья
		|ИЗ
		|	РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
		|ГДЕ
		|	БюджетПоМесяцам.Регистратор В(&Регистраторы)
		|
		|СГРУППИРОВАТЬ ПО
		|	БюджетПоМесяцам.СтатьяСметы";
	
	
	Запрос.УстановитьПараметр("Регистраторы", мДок);
	Результат = Запрос.Выполнить().Выгрузить();
	
	// первичные документы доходы пишут всегда в статью ДоходыВс
	Стр = Результат.Найти( Справочники.СтатьиСметы.ДоходыВс, "Статья" );
	Если Стр <> Неопределено Тогда
		//!!!!
		РасчетСметы = УП_СметаПроекта.Получить_СРССЗ_ПоЗадаче( Объект.ЗадачаПроекта );
		СтрРС 		= Неопределено;
		Если РасчетСметы.Свойство( "ДоходыВс", СтрРС) Тогда
			// если в схеме расчета на статье доходы всего стоит флажок "Заполняется документами"
			// оставляем 
			Если НЕ СтрРС.ЗаполняетсяДокументами Тогда
			// если не стоит, то проверяем стоит ли флажок на доходах финансовых
				// 
				СтрРС 		= Неопределено;
				Если РасчетСметы.Свойство( "ДохФинансовые", СтрРС) Тогда
					Если СтрРС.ЗаполняетсяДокументами Тогда
					// изменяем статью на доходы финансовые
						Стр.Статья = Справочники.СтатьиСметы.ДохФинансовые;
						
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокДокументов_НаСервере()
	ДокОб = РеквизитФормыВЗначение("Объект");
	ДокОб.Документы.Очистить();
	
	// убрал отбор по типу регистратора, т.к. 
	// достаточно по типу суммы !!!
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	БюджетПоМесяцам.Регистратор КАК Документ,
		|	ИСТИНА КАК ВключитьВСмету
		|ИЗ
		|	РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
		|ГДЕ
		|	БюджетПоМесяцам.Регистратор.ЗадачаПроекта = &ЗадачаПроекта
		|	И БюджетПоМесяцам.ТипСуммы = ЗНАЧЕНИЕ(Перечисление.ТипСуммыБюджета.ПервичныйДокумент)
		|
		|СГРУППИРОВАТЬ ПО
		|	БюджетПоМесяцам.Регистратор";

		
	Запрос.УстановитьПараметр("ЗадачаПроекта", 	Объект.ЗадачаПроекта);

	Результат = Запрос.Выполнить().Выгрузить();
	ДокОб.Документы.Загрузить( Результат );
	
	ЗначениеВРеквизитФормы( ДокОб, "Объект");

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДокументам(Команда)
	// автоматически сбрасываем
	СброситьЗаполнено(Команда);
	
	// сначала обновляем список документов
	ЗаполнитьСписокДокументов_НаСервере();
	// заполняем расчет суммами по документам
	ЗаполнитьСметуПоДокументам_НаСервере( );
	//
	УстановитьПараметрыСтрок();
	//
	ПересчетСметыЗадачи();
	//
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура СброситьЗаполнено_НаСервере()
	Объект.Документы.Очистить();
	Для Каждого Стр ИЗ Объект.Расчет Цикл
		Стр.ИзмененоДокументом = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СброситьЗаполнено(Команда)
	СброситьЗаполнено_НаСервере();
	
	// 2017 06 09
	УстановитьПараметрыСтрок();
	// 
	ПересчетСметыЗадачи();
	//
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыСметы_Завершение( Результат, ДопПарам ) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		УстановитьПараметрыСтрок( Истина );
		ПересчетСметыЗадачи();
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыСметы(Команда)
	ДопПарам 		= Новый Структура;
	ОпОповещения 	= Новый ОписаниеОповещения("ОбновитьПараметрыСметы_Завершение", ЭтаФорма, ДопПарам );
	ПоказатьВопрос(ОпОповещения,"Заполнить значения параметров значениями по умолчанию?", РежимДиалогаВопрос.ДаНет); 
КонецПроцедуры


&НаКлиенте
Процедура ПересчитатьСтатьиСметы(Команда)
	Для Каждого Стр ИЗ Объект.Расчет Цикл
		Стр.ИмяСтатьи = ИмяСтатьи( Стр.Статья );
	КонецЦикла;
	ЭтаФорма.Модифицированность=Истина;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.Редактор 		= ПараметрыСеанса.ТекущийПользователь;
	ТекущийОбъект.ДатаИзменения	= ТекущаяДата();

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
КонецПроцедуры


&НаСервереБезКонтекста
Функция ТабДокКалькулятор(КалькуляторСметы)
		МассивОбъектов 	= Новый Массив;
		МассивОбъектов.Добавить( КалькуляторСметы );
		ОбъектыПечати	= Новый СписокЗначений;
		ИмяМакета		= "Смета";
		ТипИсточника 	= "Калькулятор сметы";
		
		// получаем табличный документ
		КалькуляторТД =  УП_СметаПроекта.ПечатьСметы( МассивОбъектов, ОбъектыПечати, ИмяМакета, ТипИсточника);
		Возврат КалькуляторТД;
КонецФункции

&НаКлиенте
Процедура ЗаписатьПрисоединенныйКалькуляторСметы( КалькуляторСметы )
	// сохраняем в локальный файл на клиенте
	
	#Если НЕ ВебКлиент Тогда
		
	
		РасширениеФайла		= "PDF";
		ИмяВременногоФайла  = ПолучитьИмяВременногоФайла(РасширениеФайла);
		
		// получаем табличный документ
		КалькуляторТД =  ТабДокКалькулятор(КалькуляторСметы);

		// сохраняем в виде файла PDF
		КалькуляторТД.Записать( ИмяВременногоФайла, ТипФайлаТабличногоДокумента.PDF );
		
		
		// теперь добавляем к задаче проекта
		ДвоичныеДанные       = Новый ДвоичныеДанные(ИмяВременногоФайла);
		АдресФайлаВХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
		
		Описание = "Смета задачи " + Объект.Номер + " заполненая из " + 
					КалькуляторСметы + " " + Формат(ТекущаяДата(),"ДЛФ=DDT");
					
		ЗаписатьКалькуляторСметы_НаСервере( Объект.ЗадачаПроекта,
											КалькуляторСметы, 
											РасширениеФайла,,,
											АдресФайлаВХранилище,,
											Описание);
		//
		ПоказатьПредупреждение(,"Калькулятор сметы добавлен в файлы задачи проекта",10);
		// сбрасываем
		КалькуляторСметы = ПредопределенноеЗначение("Справочник.КалькуляторСметы.ПустаяСсылка");
			
	#КонецЕсли

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьКалькуляторСметы_НаСервере( 	Знач ВладелецФайлов,
                     							Знач ИмяБезРасширения,
                     							Знач РасширениеБезТочки = Неопределено,
                     							Знач ВремяИзменения = Неопределено,
                     							Знач ВремяИзмененияУниверсальное = Неопределено,
                     							Знач АдресФайлаВоВременномХранилище,
                     							Знач АдресВременногоХранилищаТекста = "",
                     							Знач Описание = "",
                     							Знач НоваяСсылкаНаФайл = Неопределено);
												
	ПрисоединенныеФайлы.ДобавитьФайл(ВладелецФайлов,
                     				ИмяБезРасширения,
                     				РасширениеБезТочки,
                     				ВремяИзменения,
                     				ВремяИзмененияУниверсальное,
                     				АдресФайлаВоВременномХранилище,
                     				АдресВременногоХранилищаТекста,
                     				Описание,
                     				НоваяСсылкаНаФайл);
												

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение
	и 	 ЗначениеЗаполнено( КалькуляторСметы ) Тогда
	    // пока не записываем 
		//ЗаписатьПрисоединенныйКалькуляторСметы( КалькуляторСметы );
		
	КонецЕсли;
	
КонецПроцедуры


#Область КонвертацияСметы


// 2015 08 10
// только добавляем новую статью Субподряд
&НаКлиенте
Процедура ПослеСогласияНаКонвертациюСметы( РезультатВопроса, ДополнительныеПараметры ) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		КонвертироватьСтруктуруСметы();
	КонецЕсли;
КонецПроцедуры

// 2015 08 10
// только добавляем новую статью Субподряд
&НаСервере
Процедура КонвертироватьСтруктуруСметы()
	Докум = РеквизитФормыВЗначение("Объект");
	// чтобы сортировать по номеру строки
	тзРасчет = Докум.Расчет.Выгрузить();
	
	НомерСтроки = 0;
	ГодПроекта 	= Докум.ЗадачаПроекта.Владелец.ГодПроекта;
	СтрСметы 	= РегистрыСведений.СтруктураСметыПоГодам.Получить( Дата(ГодПроекта,1,1));
	Для Каждого СтрСметы ИЗ СтрСметы.СтруктураСметы.Структура Цикл
		НомерСтроки = НомерСтроки + 1;
		СтрокаСметы = тзРасчет.Найти( СтрСметы.Статья, "Статья" );
		Если  СтрокаСметы = Неопределено Тогда
			СтрокаСметы 			= тзРасчет.Добавить();
			ЗаполнитьЗначенияСвойств( СтрокаСметы, СтрСметы );
			//СтрокаСметы.ИмяСтатьи	= СтрСметы.Статья.ИмяПредопределенныхДанных;
		КонецЕсли;
		СтрокаСметы.ИмяСтатьи	= СтрСметы.Статья.ИмяПредопределенныхДанных;
		СтрокаСметы.КодСтатьи	= СтрСметы.КодСтатьи;
		СтрокаСметы.НомерСтроки = НомерСтроки;
	КонецЦикла;
	
	тзРасчет.Сортировать("НомерСтроки");
	Докум.Расчет.Загрузить(тзРасчет);
	
	// 
	ЗначениеВРеквизитФормы( Докум, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура КонвертацияСтруктурыСметы(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеСогласияНаКонвертациюСметы", ЭтаФорма );
	ПоказатьВопрос(ОписаниеОповещения,"Обновить структуру сметы?", РежимДиалогаВопрос.ДаНет, 10);
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеИзКалькулятора

&НаСервере
Процедура ЗаполнитьИзКалькулятораНаСервере( Калькулятор )
	// ничего не проверяем проверяем 
	Док = РеквизитФормыВЗначение("Объект");
	
	ЗаполнитьЗначенияСвойств( Док, Калькулятор );
	
	//Док.Комментарий = Док.Комментарий + ?(ЗначениеЗаполнено(Док.Комментарий), Символы.ПС, "") +
	//"Калькулятор:" + Калькулятор.УникальныйИдентификатор();
	//"Калькулятор:" + ПолучитьНавигационнуюСсылку( Калькулятор );
	
	тзР = Калькулятор.Расчет.Выгрузить();
	Док.Расчет.Загрузить( тзР );
	
	ЗначениеВРеквизитФормы( Док, "Объект");
	
	
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Калькулятор ) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьИзКалькулятораНаСервере( Калькулятор );
		ПоказатьПредупреждение(,"Смета заполнена из калькулятора " + Калькулятор, 10);
		// запоминаем в реквизите формы для записи присоединенного файла при проведении сметы
		КалькуляторСметы = Калькулятор;
	Иначе
	// очищаем калькулятр
		КалькуляторСметы = ПредопределенноеЗначение("Справочник.КалькуляторСметы.ПустаяСсылка");
		
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция СтатьиЗаполняемыеДокументами( ЗадачаПроекта )
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасчетСметыПоГодамСрезПоследних.РасчетСтатейСметы
		|ПОМЕСТИТЬ ВТ_РасчетСтатей
		|ИЗ
		|	РегистрСведений.РасчетСметыПоГодам.СрезПоследних(&НачалоГода, ВидТиповойЗадачи = &ВидТиповойЗадачи) КАК РасчетСметыПоГодамСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РасчетыСтатейСметыРасчетСметы.Статья
		|ИЗ
		|	ВТ_РасчетСтатей КАК ВТ_РасчетСтатей
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РасчетыСтатейСметы.РасчетСметы КАК РасчетыСтатейСметыРасчетСметы
		|		ПО ВТ_РасчетСтатей.РасчетСтатейСметы.Ссылка = РасчетыСтатейСметыРасчетСметы.Ссылка
		|ГДЕ
		|	РасчетыСтатейСметыРасчетСметы.ЗаполняетсяДокументами";
	
	Запрос.УстановитьПараметр("ВидТиповойЗадачи", 	ЗадачаПроекта.ТиповаяЗадача.ВидТиповойЗадачи);
	Запрос.УстановитьПараметр("НачалоГода", 		Дата( ЗадачаПроекта.Владелец.ГодПроекта, 1, 1 ));
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Статья");
	Возврат РезультатЗапроса;
	
КонецФункции

// проверяем соответствие статей, заполняемых документами с данными калькулятора сметы
&НаСервере
Функция ПроверитьПараметрыКалькулятора( Калькулятор, Знач Смета )
	// год проекта
	мОшибки 	= Новый Массив;
	ГодСметы 	= Смета.ЗадачаПроекта.Владелец.ГодПроекта;
	Если Калькулятор.ГодПроекта <> ГодСметы Тогда
		Текст = "Год проекта в калькуляторе (" + Калькулятор.ГодПроекта + ") не совпадает с годом сметы ("+ГодСметы+")";
		мОшибки.Добавить( Текст );
	КонецЕсли;
	Если Калькулятор.ТиповаяЗадача <> Смета.ЗадачаПроекта.ТиповаяЗадача Тогда
		Текст = "Типовая задача в калькуляторе (" + Калькулятор.ТиповаяЗадача + ") не совпадает с типовой задачей сметы ("+
												Смета.ЗадачаПроекта.ТиповаяЗадача+")";
		мОшибки.Добавить( Текст );
	КонецЕсли;
	
	// все статьи, которые заполняются документами в текущей задаче проекта
	мСтатьи = СтатьиЗаполняемыеДокументами( Смета.ЗадачаПроекта );
	// движения документов, включенных в смету
	тзДвиж 	= ПолучитьДвиженияДокументов();
	//
	Для Каждого Статья ИЗ мСтатьи Цикл
		Отбор = Новый Структура("Статья", Статья );
		// по калькулятору
		СтрКальк 	= Калькулятор.Расчет.НайтиСтроки( Отбор );
		СуммаКальк 	= ?(СтрКальк.Количество() = 1, СтрКальк[0].Сумма,0);
		
		// по движениям
		СтрДвиж  	= тзДвиж.НайтиСтроки( Отбор );
		СуммаДвиж 	= ?(СтрДвиж.Количество() = 1, СтрДвиж[0].Сумма,0);
		
		
		Если СуммаКальк <> СуммаДвиж Тогда 
			Текст = "Суммы по статье " + 	Статья + " не совпадает" + Символы.ПС +
					" в калькуляторе (" + 	Формат(СуммаКальк,"ЧЦ=15; ЧДЦ=2") + ") не совпадает с суммой по документам ("+
											Формат(СуммаДвиж,"ЧЦ=15; ЧДЦ=2")+")";
			мОшибки.Добавить( Текст );
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат мОшибки;
КонецФункции

&НаКлиенте
Процедура ПодтвердитьЗаполнение(Калькулятор, ДопПараметры ) Экспорт
	Если Калькулятор = Неопределено Тогда Возврат; КонецЕсли;
	
	мОшибки = ПроверитьПараметрыКалькулятора( Калькулятор, Объект );
	Если ЗначениеЗаполнено( мОшибки ) Тогда
		Для Каждого Текст ИЗ мОшибки Цикл
			Сообщить(Текст);
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	ОпОповещения = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма, Калькулятор  );
	ПоказатьВопрос(ОпОповещения, "Заполнить текущую смету задачи из выбранного калькулятора?",
						РежимДиалогаВопрос.ДаНет);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИзКалькулятора(Команда)
	Перем Калькулятор;
	//Если Объект.Проведен Тогда
	//	ПоказатьПредупреждение(,"Заполнить из калькулятора можно только непроведенную смету!",10);
	//	Возврат;
	//КонецЕсли;
	
	ОпОповещения = Новый ОписаниеОповещения("ПодтвердитьЗаполнение", ЭтаФорма );
	ПоказатьВводЗначения( ОпОповещения, Калькулятор,, Тип("СправочникСсылка.КалькуляторСметы"));

КонецПроцедуры
#КонецОбласти
