﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("Документ.Договор.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Договор", ПараметрКоманды));
	ОткрытьФорму("Документ.Оплата.Форма.ОплатаПоДоговору", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, 
				ПараметрыВыполненияКоманды.Уникальность, 
				ПараметрыВыполненияКоманды.Окно, 
				ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
