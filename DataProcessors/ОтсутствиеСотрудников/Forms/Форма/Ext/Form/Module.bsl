﻿&НаСервере
Функция ПолучитьОтсутствияПоДокументам()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КадрыОтсутствиеСотрудник.Подразделение,
		|	КадрыОтсутствиеСотрудник.Должность,
		|	КадрыОтсутствиеСотрудник.ТарифнаяСтавка,
		|	КадрыОтсутствиеСотрудник.Ссылка.ДатаНачала,
		|	КадрыОтсутствиеСотрудник.Ссылка.ДатаОкончания,
		|	КадрыОтсутствиеСотрудник.Ссылка.Факт,
		|	КадрыОтсутствиеСотрудник.Ссылка.Проведен,
		|	КадрыОтсутствиеСотрудник.Ссылка.СтатусОтсутствия,
		|	КадрыОтсутствиеСотрудник.Ссылка.СтатусОтсутствия.Цвет КАК Цвет,
		|	КадрыОтсутствиеСотрудник.Ссылка.ФизическоеЛицо,
		|	КадрыОтсутствиеСотрудник.Ссылка
		|ИЗ
		|	Документ.КадрыОтсутствие.Сотрудник КАК КадрыОтсутствиеСотрудник
		|ГДЕ
		|	КадрыОтсутствиеСотрудник.Подразделение = &Подразделение
		|	И НЕ КадрыОтсутствиеСотрудник.Ссылка.ПометкаУдаления
		|	И КадрыОтсутствиеСотрудник.Ссылка.ДатаНачала <= &ДатаОкончания
		|	И КадрыОтсутствиеСотрудник.Ссылка.ДатаОкончания >= &ДатаНачала
		|
		|СГРУППИРОВАТЬ ПО
		|	КадрыОтсутствиеСотрудник.Должность,
		|	КадрыОтсутствиеСотрудник.Подразделение,
		|	КадрыОтсутствиеСотрудник.ТарифнаяСтавка,
		|	КадрыОтсутствиеСотрудник.Ссылка.ДатаНачала,
		|	КадрыОтсутствиеСотрудник.Ссылка.ДатаОкончания,
		|	КадрыОтсутствиеСотрудник.Ссылка.Факт,
		|	КадрыОтсутствиеСотрудник.Ссылка.Проведен,
		|	КадрыОтсутствиеСотрудник.Ссылка.СтатусОтсутствия,
		|	КадрыОтсутствиеСотрудник.Ссылка.СтатусОтсутствия.Цвет,
		|	КадрыОтсутствиеСотрудник.Ссылка.ФизическоеЛицо,
		|	КадрыОтсутствиеСотрудник.Ссылка";
	
	Запрос.УстановитьПараметр("ДатаНачала", 	ПериодОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", 	ПериодОтчета.ДатаОкончания);
	Запрос.УстановитьПараметр("Подразделение", 	Подразделение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	// передаем структуру
	сОтсутствия = НОвый Структура;
	// состав структуры - массивы
	мСерии 		= Новый Массив;
	мДолжности 	= Новый Массив;
	
	мОтсутствия = Новый Массив;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Цвет	= УП_РаботаСРабочимКалендаремСервер.ПолучитьЦветТабличногоДокумента( ВыборкаДетальныеЗаписи.Цвет);
		
		Если мСерии.Найти(ВыборкаДетальныеЗаписи.СтатусОтсутствия ) = Неопределено Тогда
			сСерия = Новый Структура;
			сСерия.Вставить("Значение", 		ВыборкаДетальныеЗаписи.СтатусОтсутствия );

			сСерия.Вставить("Цвет", 			Цвет );
			сСерия.Вставить("Текст", 			ВыборкаДетальныеЗаписи.СтатусОтсутствия );
			//сСерия.Вставить("ПриоритетЦвета", 	Ложь );
			
			мСерии.Добавить(сСерия);
		КонецЕсли;
		Если мДолжности.Найти( ВыборкаДетальныеЗаписи.Должность ) = Неопределено Тогда
			мДолжности.Добавить(ВыборкаДетальныеЗаписи.Должность);
		КОнецЕсли;
		
		
		сОт = Новый Структура("Ссылка,Должность,ТарифнаяСтавка,СтатусОтсутствия,ФизическоеЛицо,Факт,ДатаНачала,ДатаОкончания,Цвет");
		ЗаполнитьЗначенияСвойств( сОт, ВыборкаДетальныеЗаписи,,"Цвет" );
		Если ВыборкаДетальныеЗаписи.Факт Тогда
			сОт.Цвет = WebЦвета.ЦианТемный;
		Иначе
			сОт.Цвет = Цвет;
		КонецЕсли;
		
		// 
		мОтсутствия.Добавить( сОт );
		
	КонецЦикла;
	сОтсутствия.Вставить("Серии", мСерии );
	сОтсутствия.Вставить("Должности", мДолжности );
	сОтсутствия.Вставить("Точки", мОтсутствия );
	Возврат сОтсутствия;
	
КонецФункции

&НаСервере
Процедура СформироватьДиаграммуПоОтпускамСотрудников( ОтсутствиеДГ )
	сОтсутствия = ПолучитьОтсутствияПоДокументам();
	Серия				= ОтсутствиеДГ.Серии.Добавить();
	
	Для Каждого Отсутствие ИЗ сОтсутствия.Точки Цикл
		ТочкаДолжность		= ОтсутствиеДГ.УстановитьТочку( Отсутствие.Должность  );
		//
		//Цвет				= УП_РаботаСРабочимКалендаремСервер.ПолучитьЦветТабличногоДокумента( Отсутствие.Цвет);;
		
		// само отстутствие
		Точка				= ОтсутствиеДГ.УстановитьТочку( Отсутствие.ФизическоеЛицо, Отсутствие.Должность );
		Точка.Текст 		= Отсутствие.ФизическоеЛицо;
		ЗначениеДГ  		= ОтсутствиеДГ.ПолучитьЗначение( Точка, Серия );
		//
		Интервал 			= ДобавитьИнтервал( ЗначениеДГ, 
								Отсутствие.Ссылка,
								НачалоДня(Отсутствие.ДатаНачала), 
								КонецДня(Отсутствие.ДатаОкончания), 
								Отсутствие.Цвет,
								Отсутствие.СтатусОтсутствия);   
								
	КонецЦикла;
	
	// отрисовываем выходные дни
	ОтсутствиеДГ.ИнтервалыФона.Очистить();
	ДниСхемыРабот = МассивНеРабочихДней( ОтсутствиеДГ.НачалоПолногоИнтервала,  ОтсутствиеДГ.КонецПолногоИнтервала);
	Для Каждого День ИЗ ДниСхемыРабот Цикл
		Выходной = ОтсутствиеДГ.ИнтервалыФона.Добавить(НачалоДня(День), КонецДня(День));
		// 
		Выходной.Цвет = WebЦвета.СветлоСерый;
		
	КонецЦикла;
		
	
КонецПроцедуры

&НаСервере
Функция ДобавитьИнтервал( ЗначениеДГ, Значение, Начало, Конец, Цвет, Статус )
	Интервал = ЗначениеДГ.Добавить();
	Интервал.Начало 		= Начало;
	Интервал.Конец  		= Конец;
	Интервал.Расшифровка 	= Значение;
	Интервал.Цвет			= Цвет;
	// срок отсутствия
	Интервал.Текст			= "" + Статус + ", " + Формат(Начало,"ДЛФ=D" ) + "-" + Формат(Конец, "ДЛФ=D");
	Возврат Интервал;
КонецФункции


&НаСервереБезКонтекста
Функция МассивНеРабочихДней( НачалоПолногоИнтервала, КонецПолногоИнтервала )
	Возврат УП_РаботыСервер.МассивНеРабочихДней( НачалоПолногоИнтервала, КонецПолногоИнтервала );
КонецФункции

&НаСервере
Процедура НастройкаДиаграммыГанта( ДиаграммаГанта )
	ДиаграммаГанта.Очистить();
	ДиаграммаГанта.ОтображатьЗаголовок 				= Ложь;
	ДиаграммаГанта.АвтоОпределениеПолногоИнтервала 	= Ложь;
	
	ДиаграммаГанта.УстановитьПолныйИнтервал(ПериодОтчета.ДатаНачала, ПериодОтчета.ДатаОкончания);

	//
	ДиаграммаГанта.ЕдиницаПериодическогоВарианта 	= ТипЕдиницыШкалыВремени.Месяц;
	ДиаграммаГанта.КратностьПериодическогоВарианта	= 1;
	
	// две шкалы времени - день и месяц
	Если ДиаграммаГанта.ОбластьПостроения.ШкалаВремени.Элементы.Количество() = 1 Тогда
		ШкалаМесяц 				= ДиаграммаГанта.ОбластьПостроения.ШкалаВремени.Элементы.Добавить();
		ШкалаМесяц.Единица   	= ТипЕдиницыШкалыВремени.Месяц;
		ШкалаМесяц.Кратность 	= 1;
		ШкалаМесяц.ФорматДня	= ФорматДняШкалыВремени.ДеньМесяца;
		
		// чтобы была верхней
		ДиаграммаГанта.ОбластьПостроения.ШкалаВремени.Элементы.Сдвинуть( ШкалаМесяц, -1);
	КонецЕсли;	
	
	//
	ДиаграммаГанта.ПоддержкаМасштаба			= ПоддержкаМасштабаДиаграммыГанта.Авто;
	ДиаграммаГанта.ОтображениеИнтервала			= ОтображениеИнтервалаДиаграммыГанта.Плоский;
	ДиаграммаГанта.ОтображениеТекстаЗначения 	= ОтображениеТекстаЗначенияДиаграммыГанта.Право;
	ДиаграммаГанта.ОтображатьЛегенду			= Ложь;
	ДиаграммаГанта.ОбластьПостроения.Право		= 1;
	
	
КонецПроцедуры


&НаКлиенте
Процедура Сформировать(Команда)
	НастройкаДиаграммыГанта( ОтсутствиеДГ );
	
	СформироватьДиаграммуПоОтпускамСотрудников( ОтсутствиеДГ );
	ОтсутствиеДГ.ПоказатьУровеньТочек(0);
	ОтсутствиеДГ.Обновление 						= Истина;
	
	
КонецПроцедуры

&НаСервере
Функция ПериодОтчетаСтрокой()
	Возврат ПредставлениеПериода( ПериодОтчета.ДатаНачала, ПериодОтчета.ДатаОкончания, " ФП = Истина ");
КонецФункции

&НаСервере
Процедура  ПодготовитьДиаграммуДляПечати( ВыводимыйДокумент );
	Макет 		= РеквизитФормыВЗначение("Объект").ПолучитьМакет("ДиаграммаГанта");
	
	Область = Макет.ПолучитьОбласть( "Заголовок" );
	Область.Параметры.ПечПериод 	= ПериодОтчетаСтрокой();
	Область.Параметры.Подразделение = Подразделение;
	ВыводимыйДокумент.Вывести(Область);
	
	Область		= Макет.ПолучитьОбласть("ДиаграммаОтсутствия");//"ОбластьДиаграммы");
	ВыводимыйДокумент.Вывести( Область );
	
	ТекущаяДиаграмма 			= ВыводимыйДокумент.Рисунки[0].Объект;
	НастройкаДиаграммыГанта( ТекущаяДиаграмма );
	
	// изменяем настройкм
	//ТекущаяДиаграмма = Новый ДиаграммаГанта;
	ТекущаяДиаграмма.ОтображатьПустыеЗначения = Ложь;
	ТекущаяДиаграмма.ПоддержкаМасштаба = ПоддержкаМасштабаДиаграммыГанта.ВсеДанные;
	ТекущаяДиаграмма.Обновление = Ложь;
	
	//
	СформироватьДиаграммуПоОтпускамСотрудников( ТекущаяДиаграмма );	
	//
	ТекущаяДиаграмма.ПоказатьУровеньТочек();
	
КонецПроцедуры


&НаКлиенте
Процедура Печать(Команда)
	ВыводимыйДокумент = Новый ТабличныйДокумент;
	
	ПодготовитьДиаграммуДляПечати( ВыводимыйДокумент );
	//
	ВыводимыйДокумент.АвтоМасштаб = Истина;
	ВыводимыйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	Заголовок = "Отсутствие сотрудников " + ПериодОтчетаСтрокой();
	ВыводимыйДокумент.Показать(Заголовок);;

	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПериодОтчета()
	Если НЕ ЗначениеЗаполнено( ПериодОтчета.ДатаНачала ) Тогда
		ПериодОтчета.ДатаНачала = НачалоКвартала( ТекущаяДата());
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено( ПериодОтчета.ДатаОкончания ) Тогда 
		ПериодОтчета.ДатаОкончания = КонецКвартала(ТекущаяДата());
	КОнецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьПериодОтчета();
	НастройкаДиаграммыГанта( ОтсутствиеДГ );
КонецПроцедуры
