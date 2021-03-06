﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекущийТип = Перечисления.ТипОтбораДоговора.Все;
	ДатаС = НачалоГода(ТекущаяДата());
	ДатаПо = КонецГода(ТекущаяДата());
	
	ТекущийГодПриИзмененииСервер();
	
	Если НЕ СКД_ВсеМенеджеры() Тогда 
		ГруппаОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора( Список.Отбор.Элементы,
			"Менеджеры проектов", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли );
		
		ТекущийКлиентМенеджер = ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо;
		мПользователей = СКД_ДоступныеФЛ(ТекущийКлиентМенеджер);
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаОтбора, "Проект.Куратор", ВидСравненияКомпоновкиДанных.ВСписке, мПользователей);
			
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаОтбора, "Проект.МенеджерПроекта", ВидСравненияКомпоновкиДанных.ВСписке, мПользователей);
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаОтбора, "Проект.ДиректорПроекта", ВидСравненияКомпоновкиДанных.ВСписке, мПользователей);			
	КонецЕсли;
	
	//Добавлено по задаче #133697 от 18.10.2018 ГумединАГ	
	Если ЕстьВОбластиПараметр(ЭтотОбъект, "Проект") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ДоговорПроекты.Ссылка КАК Ссылка
			|ИЗ
			|	Документ.Договор.Проекты КАК ДоговорПроекты
			|ГДЕ
			|	ДоговорПроекты.Проект = &Проект
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	Договор.Ссылка
			|ИЗ
			|	Документ.Договор КАК Договор
			|ГДЕ
			|	Договор.Проект = &Проект";
		
		Запрос.УстановитьПараметр("Проект", ЭтотОбъект.Параметры.Проект);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		МассивПроектов = Новый Массив;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			МассивПроектов.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	    ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.ВСписке;
	    ЭлементОтбора.Использование    = Истина;
	    ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	    ЭлементОтбора.ПравоеЗначение   = МассивПроектов;
	КонецЕсли;
	//////////////////////////////////////////////////////
КонецПроцедуры

//Добавлено по задаче #133697 от 18.10.2018 ГумединАГ	
//Проверка на существование параметра, для избежания ошибок при открытии списка документов не из проекта
Функция ЕстьВОбластиПараметр(Область, ИмяПараметра)
    уникИД = новый УникальныйИдентификатор;
    СтруктураПараметров = Новый Структура(ИмяПараметра, уникИД);
    ЗаполнитьЗначенияСвойств(СтруктураПараметров, Область.Параметры);
    Если уникИД <> СтруктураПараметров[ИмяПараметра] Тогда
        Возврат Истина;    
    иначе
        Возврат Ложь;
    КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ТекущийТипПриИзменении(Элемент)
	ТекущийТипПриИзмененииСервер();
КонецПроцедуры

&НаСервере
Процедура ТекущийТипПриИзмененииСервер()
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора( 
		Список.Отбор,
		"Фиктивный",
		ТекущийТип = Перечисления.ТипОтбораДоговора.Фиктивные,
		ВидСравненияКомпоновкиДанных.Равно,,ТекущийТип <> Перечисления.ТипОтбораДоговора.Все);
КонецПроцедуры

&НаКлиенте
Процедура ТекущийГодПриИзменении(Элемент)
	ТекущийГодПриИзмененииСервер();
КонецПроцедуры

&НаСервере
Процедура ТекущийГодПриИзмененииСервер()
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ДатаС", ДатаС, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ДатаПо", ДатаПо, Истина);
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ТекущийТипПриИзмененииСервер();
	ТекущийГодПриИзмененииСервер();                           
КонецПроцедуры