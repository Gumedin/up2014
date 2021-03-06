﻿&НаСервере
Функция ПолучитьАттестации( ФизЛицо )
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АттестацияСотрудниковАттестуемые.Ссылка.ДатаНачала,
		|	АттестацияСотрудниковАттестуемые.Ссылка.ДатаОкончания,
		|	АттестацияСотрудниковАттестуемые.Решение,
		|	АттестацияСотрудниковАттестуемые.ДолжностьПослеАттестации,
		|	АттестацияСотрудниковАттестуемые.РезультатТестирования,
		|	АттестацияСотрудниковАттестуемые.РезультатПрактическогоЗадания,
		|	АттестацияСотрудниковАттестуемые.РезультатГолосования,
		|	АттестацияСотрудниковАттестуемые.ОбязательнаяПереаттестация,
		|	АттестацияСотрудниковАттестуемые.ДатаПереаттестации
		|ИЗ
		|	Документ.АттестацияСотрудников.Аттестуемые КАК АттестацияСотрудниковАттестуемые
		|ГДЕ
		|	АттестацияСотрудниковАттестуемые.ФизическоеЛицо = &ФизическоеЛицо
		|	И АттестацияСотрудниковАттестуемые.Ссылка.Проведен";
	
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизЛицо);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат РезультатЗапроса;
	
КонецФункции
	
&НаСервере
Функция ПолучитьСертификатыФизЛица( ФизЛицо )
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СертификатыФизЛиц.ВидСертификата,
		|	СертификатыФизЛиц.НомерСертификата,
		|	СертификатыФизЛиц.Действительный,
		|	СертификатыФизЛиц.ДатаНачала КАК ДатаНачала,
		|	СертификатыФизЛиц.ДатаОкончания,
		|	СертификатыФизЛиц.ДатаВыбытия
		|ИЗ
		|	РегистрСведений.СертификатыФизЛиц КАК СертификатыФизЛиц
		|ГДЕ
		|	СертификатыФизЛиц.ФизическоеЛицо = &ФизическоеЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачала";
	
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизЛицо);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат РезультатЗапроса;
КонецФункции

&НаСервере
Функция ПолучитьОбучения( ФизЛицо )
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбучениеСотрудниковУчащиеся.Ссылка.Курс.Наименование,
		|	ОбучениеСотрудниковУчащиеся.Ссылка.ДатаНачала КАК ДатаНачала,
		|	ОбучениеСотрудниковУчащиеся.Ссылка.ДатаОкончания,
		|	ОбучениеСотрудниковУчащиеся.Сумма,
		|	ОбучениеСотрудниковУчащиеся.Комментарий,
		|	ОбучениеСотрудниковУчащиеся.Ссылка.Организация,
		|	ОбучениеСотрудниковУчащиеся.Ссылка.Курс.Контрагент КАК Контрагент
		|ИЗ
		|	Документ.ОбучениеСотрудников.Учащиеся КАК ОбучениеСотрудниковУчащиеся
		|ГДЕ
		|	ОбучениеСотрудниковУчащиеся.ФизическоеЛицо = &ФизическоеЛицо
		|	И ОбучениеСотрудниковУчащиеся.Ссылка.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачала";
	
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизЛицо);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат РезультатЗапроса;
	
	
КонецФункции

&НаСервере
Процедура СформироватьНаСервере( ТабДок, ФизЛицо )
	//ТабДок = Новый ТабличныйДокумент;
	Макет = РеквизитФормыВЗначение("Отчет").ПолучитьМакет("Макет");
	
	ОблШ	= Макет.ПолучитьОбласть("Шапка");
	ОблШ.Параметры.ФизЛицо = ФизЛицо;
	ТабДок.Вывести( ОблШ );
	
	
	тзСертификаты = ПолучитьСертификатыФизЛица( ФизЛицо );
	Если тзСертификаты.Количество() > 0 Тогда
		ОблШС = Макет.ПолучитьОбласть("ШапкаСертификаты");
		ТабДок.Вывести( ОблШС );
		Для Каждого Сертификат ИЗ тзСертификаты Цикл
			ОблС = Макет.ПолучитьОбласть("Сертификат");
			ЗаполнитьЗначенияСвойств( ОблС.Параметры, Сертификат );
			ТабДок.Вывести( ОблС );
		КонецЦикла;
	КонецЕсли;
	
	тзОбучения = ПолучитьОбучения( ФизЛицо );
	Если тзОбучения.Количество() > 0 Тогда
		ОблШО = Макет.ПолучитьОбласть("ШапкаОбучение");
		ТабДок.Вывести( ОблШО );
		Для Каждого Обучение ИЗ тзОбучения Цикл
			ОблО = Макет.ПолучитьОбласть("Обучение");
			ЗаполнитьЗначенияСвойств( ОблО.Параметры, Обучение );
			ТабДок.Вывести( ОблО );
		КонецЦикла;
	КонецЕсли;
	
	тзАттестации = ПолучитьАттестации( ФизЛицо );
	Если тзАттестации.Количество() > 0 Тогда
		ОблША = Макет.ПолучитьОбласть("ШапкаАттестации");
		ТабДок.Вывести( ОблША);
		Для Каждого Аттестация ИЗ тзАттестации Цикл
			ОблА = Макет.ПолучитьОбласть("Аттестация");
			ЗаполнитьЗначенияСвойств( ОблА.Параметры, Аттестация );
			ОблА.Параметры.ПериодАттестации = "С " + Формат( Аттестация.ДатаНачала,  "ДЛФ=D") + " по " + Формат( Аттестация.ДатаОкончания,  "ДЛФ=D");
			
			ТабДок.Вывести( ОблА );
		КонецЦикла;
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	ТабДок = Новый ТабличныйДокумент;
	СформироватьНаСервере( ТабДок, ФизическоеЛицо );
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабДок.Показать("Карточка сотрудника " + ФизическоеЛицо );
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ФизическоеЛицо = Параметры.ФизическоеЛицо;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Сформировать("");
	ЭтаФорма.Закрыть();
КонецПроцедуры
