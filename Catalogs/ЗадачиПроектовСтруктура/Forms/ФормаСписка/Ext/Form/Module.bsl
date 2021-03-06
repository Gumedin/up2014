﻿ &НаСервере
 Процедура ОбновитьСписокИнцидентов( Задача )
	 Инциденты.Параметры.УстановитьЗначениеПараметра( "Владелец", Задача );
 
КонецПроцедуры   

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ТекДанные = Элементы.Список.ТекущиеДанные;
	ОбновитьСписокИнцидентов( ?(ТекДанные = Неопределено, Неопределено, ТекДанные.Ссылка));
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.Список.Отображение					= ОтображениеТаблицы.Дерево;
	Элементы.Список.ОтображатьКорень			= Ложь;
	Элементы.Список.НачальноеОтображениеДерева	= НачальноеОтображениеДерева.РаскрыватьВсеУровни;
КонецПроцедуры

&НаКлиенте
Функция ЗначениеОтбораСписка( НазваниеОтбора )
	ПолеОтбора = Новый ПолеКомпоновкиДанных(НазваниеОтбора);
	ЭлементыОтбора = Список.Отбор.Элементы;
	Для Каждого ЭлОтб ИЗ ЭлементыОтбора Цикл
		Если ЭлОтб.Использование Тогда
			Если ЭлОтб.ЛевоеЗначение = ПолеОтбора Тогда
				Возврат ЭлОтб.ПравоеЗначение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

&НаСервереБезКонтекста
Процедура ПересчитатьКодыСДРЗадачиПроекта( ЗадачаПроекта, Знач Родитель = Неопределено, КодСДРРодителя = "" )
	//
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗадачиПроектовСтруктура.Ссылка,
		|	ЗадачиПроектовСтруктура.КодСДР
		|ИЗ
		|	Справочник.ЗадачиПроектовСтруктура КАК ЗадачиПроектовСтруктура
		|ГДЕ
		|	ЗадачиПроектовСтруктура.Владелец = &Владелец
		|	И ЗадачиПроектовСтруктура.Родитель = &Родитель
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗадачиПроектовСтруктура.КодСДР";
	
	Запрос.УстановитьПараметр("Владелец", ЗадачаПроекта );
	Родитель = ?(Родитель=Неопределено, Справочники.ЗадачиПроектовСтруктура.ПустаяСсылка(), Родитель );
	Запрос.УстановитьПараметр("Родитель", Родитель);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	НомСДР = 1;
	Для Каждого Работа ИЗ РезультатЗапроса Цикл
		СпрОб 			= Работа.Ссылка.ПолучитьОбъект();
		СпрОб.КодСДР	= КодСДРРодителя  + НомСДР;
		НомСДР 			= НомСДР + 1;
		Попытка 
			СпрОб.Записать();
			// для подчиненных элементов
			ПересчитатьКодыСДРЗадачиПроекта( ЗадачаПроекта, Работа.Ссылка, СпрОб.КодСДР + ".");
			
		Исключение
			Текст = ОписаниеОшибки();
		КонецПопытки;
	
	КонецЦикла;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодтвержденияПересчетаСДР( РезультатВопроса, ДопПарам ) Экспорт
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда Возврат; КонецЕсли;
	ПересчитатьКодыСДРЗадачиПроекта( ДопПарам );
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура РасчитатьСДР(Команда)
	ЗадачаПроекта = ЗначениеОтбораСписка( "Владелец" );
	Если ЗначениеЗаполнено( ЗадачаПроекта ) Тогда
		ОпОпов = Новый ОписаниеОповещения("ПослеПодтвержденияПересчетаСДР",ЭтаФорма, ЗадачаПроекта ); 
		ПоказатьВопрос(ОпОпов, "Пересчитать коды СДР по задаче проекта"+Символы.ПС+ЗадачаПроекта,РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
КонецПроцедуры

