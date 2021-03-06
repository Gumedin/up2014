﻿&НаСервере
Процедура ПересчетИсполненийСотрудника()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.Сотрудник.Очистить();
	
	// активные исполнения на момент увольнения
	тзИсполнения =  УП_КадрыСервер.СотрудникиФизЛица( Документ.ФизическоеЛицо, Документ.ДатаПеремещения );
	Если  тзИсполнения.Количество() <> 0 Тогда 
		Документ.Сотрудник.Загрузить(  тзИсполнения );
		Документ.Сотрудник[0].Активна = Истина;
		//
		ЗаполнитьЗначенияСвойств( Документ, Документ.Сотрудник[0] );
		
	КонецЕсли;
	
	ЗначениеВРеквизитФормы( Документ, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	ПересчетИсполненийСотрудника();
КонецПроцедуры

&НаСервере
Процедура ФизическоеЛицоПриИзмененииНаСервере()
	ПересчетИсполненийСотрудника();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПеремещенияПриИзменении(Элемент)
	ПересчетИсполненийСотрудника();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено( Объект.ДатаПеремещения ) Тогда
		Объект.ДатаПеремещения = ТекущаяДата() + 24 * 60 * 60;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПередНачаломИзменения(Элемент, Отказ)
	ТекДанные = Элементы.Сотрудник.ТекущиеДанные;
	Если ТекДанные.Активна Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
КонецПроцедуры


// разрешено изменять из Ложь в Истина
// т.е. установлено истина, во всех остальных выстанавливаем Ложь
&НаКлиенте
Процедура СотрудникАктивнаПриИзменении(Элемент)
	ТекДанные = Элементы.Сотрудник.ТекущиеДанные;
	ЗаполнитьЗначенияСвойств( Объект, ТекДанные ); // !!!
	
	Для Каждого Эл ИЗ Объект.Сотрудник Цикл
		Если Эл.НомерСтроки <> ТекДанные.НомерСтроки Тогда
			Эл.Активна = Ложь;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ДолжностьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПараметрыД = Новый Структура;
	ПараметрыД.Вставить("Подразделение", 	Объект.Подразделение );
	
	ФормаВыбора 	= ПолучитьФорму( "Справочник.Должности.Форма.ФормаВыбораДляПланаРабот", ПараметрыД, Элемент );
	ФормаВыбора.Открыть();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтавкаПоДолжности( Должность )
	Возврат УП_КадрыСервер.СтавкаПоДолжности( Должность );
КонецФункции

&НаКлиенте
Процедура ДолжностьПриИзменении(Элемент)
	Объект.ТарифнаяСтавка = СтавкаПоДолжности( Объект.Должность );
КонецПроцедуры

