﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("ЗадачаПроекта", ПараметрКоманды));
	ОткрытьФорму("Документ.РасходПоЗадачеПроизводство.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, 
				ПараметрыВыполненияКоманды.Уникальность, 
				ПараметрыВыполненияКоманды.Окно, 
				ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
