﻿#Область СлужебныеПроцедурыИФункции

// Для внутреннего использования.
Функция СформироватьСписокПолучателейРассылки(Знач Параметры) Экспорт
	ПараметрыЖурнала = Новый Структура("ИмяСобытия, Метаданные, Данные, МассивОшибок, БылиОшибки");
	ПараметрыЖурнала.ИмяСобытия   = НСтр("ru = 'Рассылка отчетов. Формирование списка получателей'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	ПараметрыЖурнала.МассивОшибок = Новый Массив;
	ПараметрыЖурнала.БылиОшибки   = Ложь;
	ПараметрыЖурнала.Данные       = Параметры.Ссылка;
	ПараметрыЖурнала.Метаданные   = Метаданные.Справочники.РассылкиОтчетов;
	
	РезультатВыполнения = Новый Структура("Получатели, БылиКритичныеОшибки, Текст, Подробно");
	РезультатВыполнения.Получатели = РассылкаОтчетов.СформироватьСписокПолучателейРассылки(ПараметрыЖурнала, Параметры);
	РезультатВыполнения.БылиКритичныеОшибки = РезультатВыполнения.Получатели.Количество() = 0;
	
	Если РезультатВыполнения.БылиКритичныеОшибки Тогда
		РезультатВыполнения.Текст = НСтр("ru = 'Не удалось сформировать список получателей'");
		РезультатВыполнения.Подробно = РассылкаОтчетовКлиентСервер.СтрокаСообщенийПользователю(ПараметрыЖурнала.МассивОшибок, Ложь);
	КонецЕсли;
	
	Возврат РезультатВыполнения;
КонецФункции

// Запускает фоновое задание.
Функция ЗапуститьФоновоеЗадание(Знач ПараметрыМетода, Знач УникальныйИдентификатор) Экспорт
	ИмяМетода = "РассылкаОтчетов.ВыполнитьРассылкиВФоновомЗадании";
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Рассылки отчетов: Выполнение рассылок в фоне'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыМетода, НастройкиЗапуска);
КонецФункции

#КонецОбласти
