﻿
Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	МесяцПосещений = НачалоМесяцаПосещений();
	Если Дата < МесяцПосещений Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Дата посещения "+Формат( Дата, "ЧДЦ=; ДЛФ=DD") + " находится в закрытом периоде " + Формат(МесяцПосещений,"ДЛФ=DD");
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	// 
	Если Отработано Тогда
		Если ТипЗнч( ПредметПосещения ) = Тип("ДокументСсылка.ПланРабот")
		или	 ТипЗнч( ПредметПосещения ) = Тип("ДокументСсылка.ПланРаботТиражный") Тогда
			Если ПредметПосещения.ТребуетсяПодтверждение Тогда
				Если НЕ ЗначениеЗаполнено( ФайлКартинки ) Тогда
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = "Требуется подтверждение для " + ПредметПосещения;
					Сообщение.Сообщить();
					Отказ = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

