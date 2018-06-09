﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ИсполнительДокумента = ПараметрыСеанса.ТекущийПользователь;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗакупкаППЛО") Тогда
		// Заполнение шапки
		ЗакупкаППЛО 	= ДанныеЗаполнения.Ссылка;
		СуммаДокумента	= ДанныеЗаполнения.Товар.Итог("СуммаПравоОбл")-ДанныеЗаполнения.СуммаДопОтВендора;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	//Структура сметы
	Движения.БюджетПоМесяцам.Записывать = Истина;
	СметаЗадачиПроекта = УП_СметаПроекта.ПодборСметыЗадачи(ЗакупкаППЛО.ЗадачаПроекта);
	Если СметаЗадачиПроекта = Неопределено Тогда 
		Сообщить("Не найдена проведенная смета для задачи " + ЗакупкаППЛО.ЗадачаПроекта);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	сСметы 	= УП_СметаПроекта.ПолучитьСтруктуруСметыЗадачи( ЗакупкаППЛО.ЗадачаПроекта.ГодЗадачи );

	сСтатей = Новый Соответствие;
	пСтатей = Новый Соответствие;
	oСтатей = Новый Соответствие;
	Для Каждого статья Из СметаЗадачиПроекта.Расчет Цикл
		сСтатей[статья.ИмяСтатьи] = 0;
		пСтатей[статья.ИмяСтатьи] = статья.ЗначениеПараметра / 100;
		oСтатей[статья.ИмяСтатьи] = статья.Статья;
	КонецЦикла;
	
	РасходыППЛО = Справочники.СтатьиСметы.РасходыППЛО.ИмяПредопределенныхДанных;
	сСтатей[РасходыППЛО] = СуммаДокумента; 
	
	//Пересчет
	УП_СметаПроекта.ПересчетСметыЗадачи( сСметы, сСтатей );
	
	//Бюджет факт
	Для Каждого статья Из СметаЗадачиПроекта.Расчет Цикл
		Если сСтатей[статья.ИмяСтатьи] <> 0 Тогда 
			Движение = Движения.БюджетПоМесяцам.Добавить();
			Движение.Период 		= Дата;
			Движение.ЗадачаПроекта 	= ЗакупкаППЛО.ЗадачаПроекта;
			Движение.СтатьяСметы 	= oСтатей[статья.ИмяСтатьи];
			Движение.ТипСуммы 		= Перечисления.ТипСуммыБюджета.Факт;  // факт
			Движение.Месяц 			= НачалоМесяца(Дата);
			Движение.Сумма          = сСтатей[статья.ИмяСтатьи];	
			Движение.РКО			= Истина;
		КонецЕсли;
	КонецЦикла;
	
	// до проведения !!!
	Остаток = Документы.ЗаявкаНаОплатуПоставщику.ПолучитьОстатокПоЗакупкеППЛО( Ссылка );
	Если Остаток < СуммаДокумента Тогда
		Сообщить("Недостаточный остаток по документу закупки " + Формат(Остаток - СуммаДокумента, "ЧЦ=15; ЧДЦ=2"));
		//Отказ = Истина;
	КонецЕсли;
	
	// регистр ОбеспеченоПоСтатье Расход
	Движения.ОбеспеченоПоСтатье.Записывать = Истина;
	Движение = Движения.ОбеспеченоПоСтатье.Добавить();
	Движение.ВидДвижения 	= ВидДвиженияНакопления.Расход;
	Движение.Период 		= Дата;
	//Движение.Проект			= ЗакупкаППЛО.ЗадачаПроекта.Владелец;
	Движение.ЗадачаПроекта	= ЗакупкаППЛО.ЗадачаПроекта;
	Движение.СтатьяСметы	= Справочники.СтатьиСметы.РасходыППЛО;
	Движение.Сумма 			= СуммаДокумента;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение 
	И НЕ РазрешеноПроводитьДокумент( Ссылка, Ссылка.ЗакупкаППЛО.ЗадачаПроекта.Владелец ) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;		

КонецПроцедуры


