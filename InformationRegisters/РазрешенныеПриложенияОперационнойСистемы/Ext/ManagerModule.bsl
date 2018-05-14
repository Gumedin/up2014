﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает XDTO-тип, описывающий разрешения типа, соответствующего элементу кэша.
//
// Возвращаемое значение - ТипОбъектаXDTO.
//
Функция ТипXDTOПредставленияРазрешений() Экспорт
	
	Возврат ФабрикаXDTO.Тип(РаботаВБезопасномРежимеСлужебный.ПакетXDTOПредставленийРазрешений(), "RunApplication");
	
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
			
			Ключ = Новый Структура("ВнешнийМодуль,Владелец,ШаблонСтрокиЗапуска", ВнешнийМодуль, Владелец, XDTOПредставление.CommandMask);
			Если Таблица.НайтиСтроки(Ключ).Количество() = 0 Тогда
				
				Строка = Таблица.Добавить();
				Строка.ВнешнийМодуль = ВнешнийМодуль;
				Строка.Владелец = Владелец;
				Строка.ШаблонСтрокиЗапуска = XDTOПредставление.CommandMask;
				
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
	
	ПриложениеОС = АдминистрированиеКластераКлиентСервер.СвойстваПриложенияОС();
	ПриложениеОС.Имя = Менеджер.ШаблонСтрокиЗапуска;
	ПриложениеОС.ШаблонСтрокиЗапуска = Менеджер.ШаблонСтрокиЗапуска;
	Профиль.ПриложенияОС.Добавить(ПриложениеОС);
	
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
	            |	РазрешенныеПриложенияОперационнойСистемы.ШаблонСтрокиЗапуска,
	            |	РазрешенныеПриложенияОперационнойСистемы.Владелец КАК Владелец,
	            |	РазрешенныеПриложенияОперационнойСистемы.ВнешнийМодуль
	            |ИЗ
	            |	РегистрСведений.РазрешенныеПриложенияОперационнойСистемы КАК РазрешенныеПриложенияОперационнойСистемы";
	
	Если СвернутьВладельцев Тогда
		Результат = СтрЗаменить(Результат, "РазрешенныеПриложенияОперационнойСистемы.Владелец КАК Владелец,", "");
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
		|	ВТ_До.ШаблонСтрокиЗапуска,
		|	ВТ_До.ВнешнийМодуль
		|ИЗ
		|	ВТ_До КАК ВТ_До
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_После КАК ВТ_После
		|		ПО ВТ_До.ВнешнийМодуль = ВТ_После.ВнешнийМодуль
		|			И ВТ_До.ШаблонСтрокиЗапуска = ВТ_После.ШаблонСтрокиЗапуска
		|ГДЕ
		|	ВТ_После.ШаблонСтрокиЗапуска ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_После.ШаблонСтрокиЗапуска,
		|	ВТ_После.ВнешнийМодуль
		|ИЗ
		|	ВТ_После КАК ВТ_После
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_До КАК ВТ_До
		|		ПО ВТ_После.ВнешнийМодуль = ВТ_До.ВнешнийМодуль
		|			И ВТ_После.ШаблонСтрокиЗапуска = ВТ_До.ШаблонСтрокиЗапуска
		|ГДЕ
		|	ВТ_До.ШаблонСтрокиЗапуска ЕСТЬ NULL";
	
КонецФункции

#КонецОбласти

#КонецЕсли