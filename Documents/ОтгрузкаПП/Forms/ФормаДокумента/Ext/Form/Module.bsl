﻿&НаСервереБезКонтекста
Функция  ПолучитьОтпускнуюЦену( Номенклатура, Дата)
	//
	Возврат ЦенаНоменклатуры( Номенклатура, Справочники.ВидыЦен.ЦенаОтпускная, Дата );
КонецФункции


&НаКлиенте
Процедура 	ПересчетСтроки( Стр )
	Стр.Сумма   = Стр.Цена * Стр.Количество;
КонецПроцедуры

&НаКлиенте
Процедура СоставНоменклатураПриИзменении(Элемент)
	Стр 		= Элементы.Состав.ТекущиеДанные;
	Стр.Цена 	= ПолучитьОтпускнуюЦену( Стр.Номенклатура,	Объект.Дата );
	ПересчетСтроки( Стр );
КонецПроцедуры

&НаКлиенте
Процедура СоставКоличествоПриИзменении(Элемент)
	Стр 		= Элементы.Состав.ТекущиеДанные;
	ПересчетСтроки( Стр );
КонецПроцедуры

&НаКлиенте
Процедура СоставЦенаПриИзменении(Элемент)
	Стр 		= Элементы.Состав.ТекущиеДанные;
	ПересчетСтроки( Стр );
КонецПроцедуры

&НаСервере
Процедура ДобавитьППКонтрагентаНаСервере()
	//
	РегНомера = Объект.Состав.Выгрузить().ВыгрузитьКолонку("РегНомер");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КонтрагентыПП.Код,
		|	КонтрагентыПП.Владелец
		|ИЗ
		|	Справочник.КонтрагентыПП КАК КонтрагентыПП
		|ГДЕ
		|	НЕ КонтрагентыПП.ПометкаУдаления
		|	И КонтрагентыПП.Код В(&РегНомера)";
	
	Запрос.УстановитьПараметр("РегНомера", РегНомера);
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "ПП с номером " + ВыборкаДетальныеЗаписи.Код + Символы.ПС + 
						  "зарегистирирован на " + ВыборкаДетальныеЗаписи.Владелец;
		Сообщение.Сообщить();
		Возврат;
	КонецЦикла;
	
	
	Для Каждого Стр ИЗ Объект.Состав Цикл
		Если НЕ ЗначениеЗаполнено( Стр.РегНомер ) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "В строке " + Стр.НомерСтроки + " не указан Рег.№";
			Сообщение.Сообщить();
			Продолжить;
		КонецЕсли;
		//
		СпрОб	 					= Справочники.КонтрагентыПП.СоздатьЭлемент();
		СпрОб.Владелец 				= Объект.Контрагент;
		СпрОб.Код					= Стр.РегНомер;
		СпрОб.НашаПоставка 			= Истина;
		СпрОб.ПрограммныйПродукт 	= Стр.Номенклатура;
		СпрОб.Количество			= Стр.Количество;
		
		Попытка
			СпрОб.Записать();
		Исключение
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не удалось записать ПП " + Стр.РегНомер + Символы.ПС +
							  ОписаниеОшибки();
			Сообщение.Сообщить();
			Возврат;
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьППКонтрагента(Команда)
	ДобавитьППКонтрагентаНаСервере();
КонецПроцедуры
