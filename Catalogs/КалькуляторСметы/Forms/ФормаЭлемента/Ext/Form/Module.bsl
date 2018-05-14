﻿
&НаСервере
Процедура ИнициализироватьКалькуляцию()
	СпрОб = РеквизитФормыВЗначение("Объект");
	СпрОб.Расчет.Очистить();
	
	СтруктураСметы 	= УП_СметаПроекта.ПолучитьСтруктуруСметыЗадачи( СпрОб.ГодПроекта );	
	Если СтруктураСметы = Неопределено Тогда
		Сообщить("Структура сметы не определена на указанный год "+ СпрОб.ГодПроекта);
		Возврат;
	КонецЕсли;
	
	// по табличной части документа
	Для Каждого СтрСС ИЗ СтруктураСметы Цикл
		СтрР 			= СпрОб.Расчет.Добавить();
		ЗаполнитьЗначенияСвойств( СтрР, СтрСС.Значение );
		СтрР.ИмяСтатьи 	= СтрСС.Ключ;
	КонецЦикла;
	//
	ЗначениеВРеквизитФормы(СпрОб, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ТипЗнч( ЭтаФорма.Параметры.Основание ) = Тип("СправочникСсылка.Проекты") 
	или	 ТипЗнч( ЭтаФорма.Параметры.Основание ) = Тип("СправочникСсылка.ЗадачиПроектов") 
	Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Если Объект.Расчет.Количество() = 0 Тогда
		ИнициализироватьКалькуляцию();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтруктураСтроки_ПоВидуТЗ( СтрокаРасчет, ТиповаяЗадача, НовыйОбъект )
	Если СтрокаРасчет = Неопределено Тогда Возврат Неопределено;КонецЕсли;
	
	//
	Стр 	= Новый Структура;
	Стр.Вставить("ПараметрДоступен", СтрокаРасчет.ЗнПараметраРучнойВвод );
	
	
	// по пустым
	Проект 			= Справочники.Проекты.СоздатьЭлемент();
	ЗадачаПроекта 	= Справочники.ЗадачиПроектов.СоздатьЭлемент();
	Процент 		= 0;
	//	
	Формула = СокрЛП( СтрокаРасчет.ЗнПараметраФормула);
	Если ЗначениеЗаполнено( Формула ) Тогда 
		Попытка
			Выполнить("Процент = " + Формула );
		Исключение
			Сообщить("Формула [" + Формула + "], " + ОписаниеОшибки());
			Возврат Неопределено;
			
			
			
		КонецПопытки;
		// если формула не вычисляется (процент =0), то делаем параметр доступным для редактирования 
		Если Процент = 0 Тогда
			Стр.Вставить("ПараметрДоступен", Истина );
		КонецЕсли;
	КонецЕсли;
	// 
	Стр.Вставить("Процент", Процент);
	Стр.Вставить("ЗаполняетсяДокументами", 	СтрокаРасчет.ЗаполняетсяДокументами);
	Стр.Вставить("СуммаРучнойВвод",		 	СтрокаРасчет.СуммаРучнойВвод);
	
	
	Возврат Стр;
КонецФункции

&НаСервереБезКонтекста
Функция СтатьяИтоговая( Статья )
	Возврат Статья.Итоговая;
КонецФункции


&НаСервере
Процедура УстановитьПараметрыСтрок_НаСервере(НовыйОбъект)
	
	сРасчет = УП_СметаПроекта.ПолучитьСтруктуруРасчетаСтатейСметыЗадачи( Объект.ТиповаяЗадача.ВидТиповойЗадачи, Объект.ГодПроекта); 
	Если сРасчет = Неопределено Тогда Возврат; КонецЕсли;
	
	
	Для Каждого Стр ИЗ Объект.Расчет Цикл
		Если НовыйОбъект Тогда
			Стр.ЗначениеПараметра 	= 0;
		КонецЕсли;
		Стр.ПараметрДоступен	= Ложь;
		Стр.СуммаДоступна		= Ложь;
		
		СтрокаРасчет  		= Неопределено;
		Если сРасчет.Свойство( Стр.ИмяСтатьи, СтрокаРасчет ) Тогда
			сП = СтруктураСтроки_ПоВидуТЗ( СтрокаРасчет, Объект.ТиповаяЗадача,  НовыйОбъект);
			Если сП <> Неопределено Тогда
				Если НовыйОбъект Тогда
					Стр.ЗначениеПараметра	= сП["Процент"];
				КонецЕсли;
				Стр.ПараметрДоступен		= сП["ПараметрДоступен"];
				Стр.СуммаДоступна			= сП["СуммаРучнойВвод"];
				Стр.ИзмененоДокументом  	= сП["ЗаполняетсяДокументами"];
				Стр.ЗаполняетсяДокументами  = сП["ЗаполняетсяДокументами"];
			КонецЕсли;			
		КонецЕсли;
		//Стр.Итоговая = СтатьяИтоговая( Стр.Статья );
	КонецЦикла;
КонецПроцедуры
	
&НаКлиенте
Процедура УстановитьПараметрыСтрок(  НовыйОбъект = Ложь )
	УстановитьПараметрыСтрок_НаСервере(  НовыйОбъект );

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПересчетКалькуляции_НаСервере( ГодПроекта, ТиповаяЗадача, П, С, ИзмененоДокументом, сРезультат )
	// расчет по формулам справочника,
	сРасчета 	= УП_СметаПроекта.ПолучитьСтруктуруРасчетаСтатейСметыЗадачи( ТиповаяЗадача.ВидТиповойЗадачи, ГодПроекта );
	Если сРасчета = Неопределено Тогда
		возврат;
	КонецЕсли;
	
	// расчет по формулам справочника,
	Для Каждого Эл ИЗ  сРасчета Цикл
	
		РасчетСтатьи = Эл.Значение;
		// вводится вручную
		Если РасчетСтатьи.СуммаРучнойВвод						Тогда Продолжить; КонецЕсли;
		// нет формулы
		Если НЕ ЗначениеЗаполнено( РасчетСтатьи.СуммаФормула )  Тогда Продолжить; КонецЕсли;
		// 
		Если РасчетСтатьи.ЗаполняетсяДокументами И ИзмененоДокументом[РасчетСтатьи.ИмяСтатьи] Тогда 
			Если С.Свойство(РасчетСтатьи.ИмяСтатьи) Тогда
				Сумма = С[РасчетСтатьи.ИмяСтатьи]; 			
			КонецЕсли;
		Иначе
		
			Попытка
				Формула = "Сумма = " + СокрЛП( РасчетСтатьи.СуммаФормула );
				Выполнить( Формула );
			Исключение
				Сообщить(Формула + ", " + ОписаниеОшибки());
				Сумма = 0;
			КонецПопытки;
			// ставим назад
			Если С.Свойство(РасчетСтатьи.ИмяСтатьи) Тогда
				С[РасчетСтатьи.ИмяСтатьи]	= Окр(Сумма,2);
			КонецЕсли;		
		КонецЕсли;
		//
		сРезультат.Вставить( РасчетСтатьи.ИмяСтатьи, Окр(Сумма,2));
		
	КонецЦикла;
	// пересчитываем формулы по справочнику структура бюджета 
	сСметы 	= УП_СметаПроекта.ПолучитьСтруктуруСметыЗадачи( ГодПроекта );
	УП_СметаПроекта.ПересчетСметыЗадачи( сСметы, сРезультат );
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчетКалькуляции()
	сРезультат 	= Новый Соответствие;
	сПар		= Новый Структура;
	сСуммы		= Новый Структура;
	сИзмД		= Новый Структура;
	Для Каждого Стр ИЗ Объект.Расчет Цикл
		сПар.Вставить( 		Стр.ИмяСтатьи, Стр.ЗначениеПараметра/100 );
		сСуммы.Вставить( 	Стр.ИмяСтатьи, Стр.Сумма );
		сИзмД.Вставить( 	Стр.ИмяСтатьи, Стр.ИзмененоДокументом );
		// возвращаемый результат
		сРезультат.Вставить( Стр.ИмяСтатьи, Стр.Сумма );
	КонецЦикла;
	
	// исправленные и пересчитанные суммы
	ПересчетКалькуляции_НаСервере( Объект.ГодПроекта, Объект.ТиповаяЗадача, сПар, сСуммы, сИзмД, сРезультат );
	
	// 
	Для Каждого Стр ИЗ Объект.Расчет Цикл
		Стр.Сумма = сРезультат.Получить( Стр.ИмяСтатьи );
	КонецЦикла;
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если НЕ ЗначениеЗаполнено( Объект.Ссылка ) Тогда
		УстановитьПараметрыСтрок(Истина);
		ПересчетКалькуляции();
		
	Иначе 
		УстановитьПараметрыСтрок();
	КонецЕсли;
	
	//Вставить содержимое обработчика
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
		// так в смете задачи
		//Если Стр.СуммаДоступна И НЕ Стр.ИзмененоДокументом Тогда
		
		// так в калькуляции,
		// т.е документ имитируется руками
		Если Стр.СуммаДоступна ИЛИ Стр.ИзмененоДокументом Тогда 
		Иначе
			Отказ = Истина;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// флажок можно ставить только на статьях, которые "ЗаполняетсяДокументами"
	Если Элемент.ТекущийЭлемент.Имя = "РасчетИзмененоДокументом" Тогда
		Если НЕ Стр.ЗаполняетсяДокументами Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура РасчетПриИзменении(Элемент)
	ПересчетКалькуляции();
КонецПроцедуры

&НаКлиенте
Процедура ТиповаяЗадачаПриИзменении(Элемент)
	УстановитьПараметрыСтрок(Истина);
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПересчетКалькуляции();
	УстановитьПараметрыСтрок();
КонецПроцедуры


&НаКлиенте
Процедура ГодПроектаПриИзменении(Элемент)
	ИнициализироватьКалькуляцию();
	УстановитьПараметрыСтрок(Истина);
	ПересчетКалькуляции();
	
КонецПроцедуры

