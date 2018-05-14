﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает XDTO-тип, описывающий разрешения типа, соответствующего элементу кэша.
//
// Возвращаемое значение - ТипОбъектаXDTO.
//
Функция ТипXDTOПредставленияРазрешений() Экспорт
	
	Возврат ФабрикаXDTO.Тип(РаботаВБезопасномРежимеСлужебный.ПакетXDTOПредставленийРазрешений(), "FileSystemAccess");
	
КонецФункции

// Формирует набор записей текущего регистра кэша из XDTO-представлений разрешения.
//
// Параметры:
//  ВнешнийМодуль - ЛюбаяСсылка,
//  Владелец - ЛюбаяСсылка,
//  XDTOПредставления - Массив(ОбъектXDTO).
//
// Возвращаемое значение - РегистрСведенийНаборЗаписей.
//
Функция НаборЗаписейИзXDTOПредставления(Знач XDTOПредставления, Знач ВнешнийМодуль, Знач Владелец, Знач ДляУдаления) Экспорт
	
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.ВнешнийМодуль.Установить(ВнешнийМодуль);
	Набор.Отбор.Владелец.Установить(Владелец);
	
	Если ДляУдаления Тогда
		
		Возврат Набор;
		
	Иначе
		
		Таблица = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ТаблицаРазрешений(СоздатьНаборЗаписей().Метаданные(), Истина);
		
		Для Каждого XDTOПредставление Из XDTOПредставления Цикл
			
			Ключ = Новый Структура("ВнешнийМодуль,Владелец,Адрес", ВнешнийМодуль, Владелец, XDTOПредставление.Path);
			СтрокиПоКлючу = Таблица.НайтиСтроки(Ключ);
			
			Если СтрокиПоКлючу.Количество() = 0 Тогда
				Строка = Таблица.Добавить();
				Строка.ВнешнийМодуль = ВнешнийМодуль;
				Строка.Владелец = Владелец;
				Строка.Адрес = XDTOПредставление.Path;
				Строка.РазрешеноЧтениеДанных = XDTOПредставление.AllowedRead;
				Строка.РазрешенаЗаписьДанных = XDTOПредставление.AllowedWrite;
			ИначеЕсли СтрокиПоКлючу.Количество() = 1 Тогда
				Строка = СтрокиПоКлючу[0];
				Если XDTOПредставление.AllowedRead И Не Строка.РазрешеноЧтениеДанных Тогда
					Строка.РазрешеноЧтениеДанных = Истина;
				КонецЕсли;
				Если XDTOПредставление.AllowedWrite И Не Строка.РазрешенаЗаписьДанных Тогда
					Строка.РазрешенаЗаписьДанных = Истина;
				КонецЕсли;
			Иначе
			КонецЕсли;
			
		КонецЦикла;
		
		Набор.Загрузить(Таблица);
		Возврат Набор;
		
	КонецЕсли;
	
КонецФункции

// Заполняет описание профиля безопасности (в нотации программного интерфейса общего модуля
//  АдминистрированиеКластераКлиентСервер) по менеджеру записи текущего элемента кэша.
//
// Параметры:
//  Менеджер - РегистрСведенийМенеджерЗаписи,
//  Профиль - Структура.
//
Процедура ЗаполнитьСвойстваПрофиляБезопасностиВНотацииИнтерфейсаАдминистрирования(Знач Менеджер, Профиль) Экспорт
	
	Если СтандартныеВиртуальныеКаталоги().Получить(Менеджер.Адрес) <> Неопределено Тогда
		
		ВиртуальныйКаталог = АдминистрированиеКластераКлиентСервер.СвойстваВиртуальногоКаталога();
		ВиртуальныйКаталог.ЛогическийURL = Менеджер.Адрес;
		ВиртуальныйКаталог.ФизическийURL = СтандартныеВиртуальныеКаталоги().Получить(Менеджер.Адрес);
		ВиртуальныйКаталог.ЧтениеДанных = Менеджер.РазрешеноЧтениеДанных;
		ВиртуальныйКаталог.ЗаписьДанных = Менеджер.РазрешенаЗаписьДанных;
		Профиль.ВиртуальныеКаталоги.Добавить(ВиртуальныйКаталог);
		
	Иначе
		
		ВиртуальныйКаталог = АдминистрированиеКластераКлиентСервер.СвойстваВиртуальногоКаталога();
		ВиртуальныйКаталог.ЛогическийURL = Менеджер.Адрес;
		ВиртуальныйКаталог.ФизическийURL = Менеджер.Адрес;
		ВиртуальныйКаталог.ЧтениеДанных = Менеджер.РазрешеноЧтениеДанных;
		ВиртуальныйКаталог.ЗаписьДанных = Менеджер.РазрешенаЗаписьДанных;
		Профиль.ВиртуальныеКаталоги.Добавить(ВиртуальныйКаталог);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает текст запроса для получения текущего среза разрешений по данному
//  элементу кэша.
//
// Параметры:
//  СвернутьВладельцев - Булево - флаг необходимости сворачивания результата запроса
//    по владельцам.
//
// Возвращаемое значение - Строка, текст запроса.
//
Функция ЗапросТекущегоСреза(Знач СвернутьВладельцев = Истина) Экспорт
	
	Результат = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	            |	РазрешенныеКаталогиФайловойСистемы.Адрес,
	            |	РазрешенныеКаталогиФайловойСистемы.РазрешеноЧтениеДанных,
	            |	РазрешенныеКаталогиФайловойСистемы.РазрешенаЗаписьДанных,
	            |	РазрешенныеКаталогиФайловойСистемы.Владелец КАК Владелец,
	            |	РазрешенныеКаталогиФайловойСистемы.ВнешнийМодуль
	            |ИЗ
	            |	РегистрСведений.РазрешенныеКаталогиФайловойСистемы КАК РазрешенныеКаталогиФайловойСистемы";
	
	Если СвернутьВладельцев Тогда
		Результат = СтрЗаменить(Результат, "РазрешенныеКаталогиФайловойСистемы.Владелец КАК Владелец,", "");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает текст запроса для получения дельты измения разрешений по данному
//  элементу кэша.
//
// Возвращаемое значение - Строка, текст запроса.
//
Функция ЗапросПолученияДельты() Экспорт
	
	Возврат
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_До.Адрес,
		|	ВТ_До.РазрешеноЧтениеДанных,
		|	ВТ_До.РазрешенаЗаписьДанных,
		|	ВТ_До.ВнешнийМодуль
		|ИЗ
		|	ВТ_До КАК ВТ_До
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_После КАК ВТ_После
		|		ПО ВТ_До.ВнешнийМодуль = ВТ_После.ВнешнийМодуль
		|			И ВТ_До.Адрес = ВТ_После.Адрес
		|ГДЕ
		|	ВТ_После.Адрес ЕСТЬ NULL 
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_После.Адрес,
		|	ВТ_После.РазрешеноЧтениеДанных,
		|	ВТ_После.РазрешенаЗаписьДанных,
		|	ВТ_После.ВнешнийМодуль
		|ИЗ
		|	ВТ_После КАК ВТ_После
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_До КАК ВТ_До
		|		ПО ВТ_После.ВнешнийМодуль = ВТ_До.ВнешнийМодуль
		|			И ВТ_После.Адрес = ВТ_До.Адрес
		|ГДЕ
		|	ВТ_До.Адрес ЕСТЬ NULL ";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтандартныеВиртуальныеКаталоги()
	
	Результат = Новый Соответствие();
	
	Результат.Вставить("/temp", "%t/%i/%s/%p");
	Результат.Вставить("/bin", "%e");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли