﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура();// "ПроектМенеджер", ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо);
	ОткрытьФорму("Документ.ОценкаСотрудника.Форма.ФормаСпискаОценщика",
	ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
