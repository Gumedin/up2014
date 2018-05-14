﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Серверные процедуры и функции общего назначения:
// - Поддержка профилей безопасности
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает служебный идентификатор объектов метаданных, который используется для хранения
// разрешений, связанных с конфигурацией (а не с объектами конфигурации).
//
// Возвращаемое значение: СправочникСсылка.ИдентификаторыОбъектовМетаданных.
//
Функция СлужебныйИОМ() Экспорт
	
	Возврат Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту(
		"ПолноеИмя", Метаданные.РегистрыСведений.РежимыПодключенияВнешнихМодулей.ПолноеИмя());
	
КонецФункции

// Возвращает массив существующих в конфигурации разделителей.
//
// Возвращаемое значение: ФиксированныйМассив(Строка) - массив строк общих реквизитов, которые
//  являются разделителями.
//
Функция МассивРазделителей() Экспорт
	
	МассивРазделителей = Новый Массив;
	
	Для Каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
		Если ОбщийРеквизит.РазделениеДанных = Метаданные.СвойстваОбъектов.РазделениеДанныхОбщегоРеквизита.Разделять Тогда
			МассивРазделителей.Добавить(ОбщийРеквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(МассивРазделителей);
	
КонецФункции

#КонецОбласти