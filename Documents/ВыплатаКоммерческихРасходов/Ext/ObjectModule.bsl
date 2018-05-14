﻿Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ИсполнительДокумента 	= ПараметрыСеанса.ТекущийПользователь;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	// регистр ВыплатыКоммерческихРасходов Расход
	Движения.ВыплатыКоммерческихРасходов.Записывать = Истина;
	Для Каждого ТекСтрокаВыплатыКР Из ВыплатыКР Цикл
		Движение = Движения.ВыплатыКоммерческихРасходов.Добавить();
		Движение.ВидДвижения 	= ВидДвиженияНакопления.Расход;
		Движение.Период		 	= Дата;
		Движение.КлиентМенеджер = ТекСтрокаВыплатыКР.КлиентМенеджер;
		Движение.ВидТЗ 			= ТекСтрокаВыплатыКР.ВидТЗ;
		Движение.Сумма 			= ТекСтрокаВыплатыКР.Сумма;
	КонецЦикла;

КонецПроцедуры

