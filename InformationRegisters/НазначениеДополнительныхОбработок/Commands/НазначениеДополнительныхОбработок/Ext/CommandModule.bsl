﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Отбор = Новый Структура("ОбъектНазначения", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор, РежимОткрытияИзФормы", Отбор, Истина);
	ОткрытьФорму("РегистрСведений.НазначениеДополнительныхОбработок.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
