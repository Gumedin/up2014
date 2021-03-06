﻿Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// печать счёта на оплату
	ПодготовитьПечатнуюФорму(
		"Смета",
		НСтр("ru = 'Смета проекта'"),
		"ОбщиеМакеты.ПФ_MXL_СметаПроекта",
		МассивОбъектов,
		КоллекцияПечатныхФорм,
		ОбъектыПечати,
		ПараметрыВывода);
	
		
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Ложь;
	
	
КонецПроцедуры


Процедура ПодготовитьПечатнуюФорму(Знач ИмяМакета, ПредставлениеМакета, ПолныйПутьКМакету = "", МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, ИмяМакета );
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		ИмяМакета,
		ПредставлениеМакета,
		УП_СметаПроекта.ПечатьСметы(МассивОбъектов, ОбъектыПечати, ИмяМакета, "Смета проекта"),
		,
		ПолныйПутьКМакету);
	КонецЕсли;
	
КонецПроцедуры
