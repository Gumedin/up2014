﻿Процедура ПередЗаписью(Отказ)
	
	Если НЕ ЭтоГруппа Тогда
		
		Если ПометкаУдаления Тогда
			Статус = Перечисления.ТелеграмСтатусыИспользования.Выключен;
		КонецЕсли;
		
		Если ВидВходящегоОбновления = Перечисления.ТелеграмВидыВходящихОбновлений.Сообщение Тогда
			Если ВходящийТекст.Количество() = 0 Тогда
				Сообщить("Не задан входящий текст");
				Отказ = Истина;
			Иначе
				ВходящийТекстАвто = "";
				Для Каждого ТекСтрока Из ВходящийТекст Цикл
					Если ВходящийТекстАвто <> "" Тогда
						ВходящийТекстАвто = ВходящийТекстАвто + "; ";
					КонецЕсли;
					ВходящийТекстАвто = ВходящийТекстАвто + ТекСтрока.ВидСравнения + " " + ТекСтрока.Значение;
				КонецЦикла;
			КонецЕсли;
		ИначеЕсли ВидВходящегоОбновления = Перечисления.ТелеграмВидыВходящихОбновлений.ОтветКонтекстнойКлавиатуры Тогда
			Если ВходящиеДанные.Количество() = 0 Тогда
				Сообщить("Не заданы входящие данные");
				//Отказ = Истина;
			Иначе
				ВходящийТекстАвто = "";
				Для Каждого ТекСтрока Из ВходящиеДанные Цикл
					Если ВходящийТекстАвто <> "" Тогда
						ВходящийТекстАвто = ВходящийТекстАвто + "; ";
					КонецЕсли;
					ВходящийТекстАвто = ВходящийТекстАвто + ТекСтрока.ВидСравнения + " " + ТекСтрока.Значение;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		НаборыУсловийАвто = НаборыУсловий.Количество();
		ОбработкиАвто = ЭтотОбъект.Обработки.Количество();
		
	КонецЕсли;
	
КонецПроцедуры