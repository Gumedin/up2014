﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Данные = ЗагруженныеРегионы();
	Элементы.СостояниеРегистра.Заголовок = Данные.Заголовок;
	Элементы.ПроверитьОбновление.Доступность = Данные.КоличествоЗагруженных>0;    
	Элементы.Очистить.Доступность = Элементы.ПроверитьОбновление.Доступность;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_АдресныйКлассификатор" Тогда
		Данные = ЗагруженныеРегионы();
		Элементы.СостояниеРегистра.Заголовок = Данные.Заголовок;
		Элементы.ПроверитьОбновление.Доступность = Данные.КоличествоЗагруженных>0;    
		Элементы.Очистить.Доступность = Элементы.ПроверитьОбновление.Доступность;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьАдресныйКлассификатор(Команда)
	АдресныйКлассификаторКлиент.ЗагрузитьАдресныйКлассификатор();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьАдресныйКлассификатор(Команда)
	АдресныйКлассификаторКлиент.ОчиститьКлассификатор(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьОбновлениеАдресногоКлассификатора(Команда)
	
	АдресныйКлассификаторКлиент.ОпределитьНеобходимостьОбновленияАдресныхОбъектов(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗагруженныеРегионы()
	
	Результат = Новый Структура("Заголовок, КоличествоЗагруженных",
		НСтр("ru = 'Адресный классификатор не заполнен.'"),
		АдресныйКлассификатор.ЧислоЗаполненныхАдресныхОбъектов());
	
	Если Результат.КоличествоЗагруженных>0 Тогда
		Результат.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Загружено регионов: %1.'"), 
			Результат.КоличествоЗагруженных);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти
