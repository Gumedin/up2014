﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТабельРВ", ПараметрыВыполненияКоманды.Источник.Объект );
	//
	ОткрытьФорму("Отчет.ТабельТ13.Форма.ФормаОтчета", 
					ПараметрыФормы, 
					ПараметрыВыполненияКоманды.Источник, 
					ПараметрыВыполненияКоманды.Уникальность, 
					ПараметрыВыполненияКоманды.Окно, 
					ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

