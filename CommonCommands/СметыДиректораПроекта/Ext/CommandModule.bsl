﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура();// "ПроектМенеджер", ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо);
	ПараметрыФормы.Вставить("ДиректорПроекта", Истина );
	ОткрытьФорму("Документ.Смета.Форма.ФормаСпискаКлиентМенджера", 
	ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
