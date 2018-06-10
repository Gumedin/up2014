﻿
Процедура ОбработкаПроведения(Отказ, Режим)	
	//Спецификация акта
	Для Каждого ТекКоммерческоеВознаграждение Из КоммерческоеВознаграждение Цикл
		Если ТекКоммерческоеВознаграждение.Сумма = 0 Тогда Продолжить; КонецЕсли;
		
		// регистр бюджет по месяцам факт
		Движения.БюджетПоМесяцам.Записывать = Истина;
		//УП_СметаПроекта.ПодготовкаФактБюджета(сСметы, сСтатей, пСтатей, oСтатей, ТекСтрокаРаспределение.ЗадачаПроекта)
		//- повторение штатной из-за дополнительных расчетов
		СметаЗадачиПроекта = УП_СметаПроекта.ПодборСметыЗадачи(ТекКоммерческоеВознаграждение.ЗадачаПроекта);
		Если СметаЗадачиПроекта = Неопределено Тогда 
			Сообщить("Не найдена проведенная смета для задачи " +  ТекКоммерческоеВознаграждение.ЗадачаПроекта);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		сСметы 	= УП_СметаПроекта.ПолучитьСтруктуруСметыЗадачи(ТекКоммерческоеВознаграждение.ЗадачаПроекта.ГодЗадачи);
		
		//Плановую сумму Дохода и ЛО/ПП нужно сохранить для определения доли
		РасходыППЛО = 0;
		Доход = 0;
		сСтатей = Новый Соответствие;
		пСтатей = Новый Соответствие;
		oСтатей = Новый Соответствие;
		Для Каждого статьяСметы Из СметаЗадачиПроекта.Расчет Цикл
			сСтатей[статьяСметы.ИмяСтатьи] = 0;
			пСтатей[статьяСметы.ИмяСтатьи] = статьяСметы.ЗначениеПараметра / 100;
			oСтатей[статьяСметы.ИмяСтатьи] = статьяСметы.Статья;
			
			Если статьяСметы.ИмяСтатьи = Справочники.СтатьиСметы.РасходыППЛО.ИмяПредопределенныхДанных Тогда 
				РасходыППЛО = статьяСметы.Сумма;
			КонецЕсли;
			Если статьяСметы.ИмяСтатьи = Справочники.СтатьиСметы.ДоходыВс.ИмяПредопределенныхДанных Тогда 
				Доход = статьяСметы.Сумма;
			КонецЕсли;
		КонецЦикла;
		
		ВознагрПосредника = Справочники.СтатьиСметы.ВознагрПосредника.ИмяПредопределенныхДанных;
		сСтатей[ВознагрПосредника] = пСтатей[ВознагрПосредника] * ТекКоммерческоеВознаграждение.Сумма; 
		
		РасходыВознПосредника = Справочники.СтатьиСметы.РасходыВознПосредника.ИмяПредопределенныхДанных;
		сСтатей[РасходыВознПосредника] = пСтатей[РасходыВознПосредника] * сСтатей[ВознагрПосредника]; 
		
		ДоходыВс = Справочники.СтатьиСметы.ДоходыВс.ИмяПредопределенныхДанных;
		сСтатей[ДоходыВс] = ТекКоммерческоеВознаграждение.Сумма - сСтатей[ВознагрПосредника] - сСтатей[РасходыВознПосредника]; 
		
		Если Доход <> 0 Тогда //Быть не должно, но всеже..
			РасходыППЛО = РасходыППЛО / Доход * сСтатей[ДоходыВс];
			ВознаграждениеКМ = Справочники.СтатьиСметы.ВознаграждениеКМ.ИмяПредопределенныхДанных;
			сСтатей[ВознаграждениеКМ] = (сСтатей[ДоходыВс] - РасходыППЛО) * пСтатей[ВознаграждениеКМ]; 
		КонецЕсли;
		
		УП_СметаПроекта.ПроведениеФактБюджета(сСметы, сСтатей, oСтатей, Движения, ТекКоммерческоеВознаграждение.ЗадачаПроекта,
			Дата, Дата);
		
		// регистр БонусыПоАктам Приход
	    Движения.БонусыПоАктам.Записывать = Истина;
		Для Каждого ТекСтрокаКоммерческоеВознаграждение Из КоммерческоеВознаграждение Цикл
			Движение = Движения.БонусыПоАктам.Добавить();
			Движение.ВидДвижения 	= ВидДвиженияНакопления.Приход;
			Движение.Период 		= Дата;
			Движение.Акт			= Ссылка;
			Движение.ЗадачаПроекта 	= ТекСтрокаКоммерческоеВознаграждение.ЗадачаПроекта;
			Движение.Сумма 			= ТекСтрокаКоммерческоеВознаграждение.СуммаВознаграждения;
		КонецЦикла;
	
		//Добавить регистр по Реализации [#129609]
		//Реализация факт
		Движения.Реализация.Записывать = Истина;
		Движение 					= Движения.Реализация.Добавить();
		Движение.Период 			= Дата;
		Движение.ЗадачаПроекта 		= ТекКоммерческоеВознаграждение.ЗадачаПроекта;
		Движение.Договор 			= Ссылка.Договор;
		Движение.Месяц 				= НачалоМесяца( Дата );
		Движение.Факт = ТекКоммерческоеВознаграждение.Сумма;
	КонецЦикла;
КонецПроцедуры