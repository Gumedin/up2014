﻿
&НаКлиенте
Процедура РасходыЗадачаПроектаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		//
	ПараметрыПР = Новый Структура;
	Если ЗадачиВсехПодразделений Тогда
		ПараметрыПР.Вставить("Подразделение", ПредопределенноеЗначение("Справочник.Подразделения.ПустаяСсылка" ));
	Иначе
		ПараметрыПР.Вставить("Подразделение", Объект.Подразделение );
	КонецЕсли;
	ПараметрыПР.Вставить("РежимВыбора", 	Истина);
	
	
	ОткрытьФорму( "Справочник.ЗадачиПроектов.Форма.ФормаВыбораПоПодразделению", ПараметрыПР, Элемент );
	СтандартнаяОбработка = Ложь;
	

КонецПроцедуры

&НаКлиенте
Процедура ПересчетСуммыДокумента()
	Объект.СуммаДокумента = Объект.Расходы.Итог("Сумма");
КонецПроцедуры


&НаКлиенте
Процедура РасходыПриИзменении(Элемент)
	ПересчетСуммыДокумента();
КонецПроцедуры

&НаСервереБезКонтекста
Функция  ПодразделениеФизЛица(ФизическоеЛицо, Дата)
	тз = УП_КадрыСервер.СотрудникиФизЛица( ФизическоеЛицо, НачалоМесяца( Дата ));
	Если тз.Количество() = 0 Тогда
		Возврат Неопределено
	Иначе
		Возврат тз[0].Подразделение;
	КонецЕсли;
КонецФункции


&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	Объект.Подразделение = ПодразделениеФизЛица( Объект.ФизическоеЛицо, Объект.ПериодРегистрации );
КонецПроцедуры


&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	Объект.ПериодРегистрации = НачалоМесяца( Объект.ПериодРегистрации );
КонецПроцедуры

