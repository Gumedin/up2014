﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура();
	Отбор = Новый Структура;
	Отбор.Вставить("ФизическоеЛицо", ПараметрКоманды );
	ПараметрыФормы.Вставить("Отбор", Отбор );
	ПараметрыФормы.Вставить("СформироватьПриОткрытии",  Истина );
	ПараметрыФормы.Вставить("КлючВарианта",  "ПоСотруднику");
	
	
	
	ОткрытьФорму("Отчет.ПосещенияСотрудников.Форма.ФормаОтчета", ПараметрыФормы, 
			ПараметрыВыполненияКоманды.Источник, 
			ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
	
