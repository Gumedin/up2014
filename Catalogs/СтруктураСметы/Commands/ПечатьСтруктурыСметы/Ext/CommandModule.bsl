﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ГодПроекта",ПараметрыВыполненияКоманды.Источник.ТекущийЭлемент.ТекущиеДанные.Период);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Справочник.СтруктураСметы", "РасчетСтруктурыСметы", 
			ПараметрКоманды, ПараметрыВыполненияКоманды.Источник, ПараметрыПечати);
КонецПроцедуры
