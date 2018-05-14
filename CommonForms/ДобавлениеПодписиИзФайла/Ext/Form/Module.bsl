﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодписиПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
		Возврат;
	КонецЕсли;
		
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла = Элементы.Подписи.ТекущиеДанные.ПутьКФайлу;
	Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файлы'");
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		Элементы.Подписи.ТекущиеДанные.ПутьКФайлу = ДиалогОткрытияФайла.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	// проверяем что все заполнено
	ОчиститьСообщения();
	
	МассивВозврата = Новый Массив;
	ЕстьОшибкиЗаполнения = Ложь;
	
	Если Подписи.Количество() = 0 Тогда
		ТекстОшибки = НСтр("ru = 'Не указано ни одного файла подписи'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Подписи");
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из Подписи Цикл
		
		Если ПустаяСтрока(Строка.ПутьКФайлу) Тогда
			ТекстОшибки = НСтр("ru = 'Не заполнен путь к файлу подписи'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Подписи");
			ЕстьОшибкиЗаполнения = Истина;
		КонецЕсли;
		
		Запись = Новый Структура("ПутьКФайлу, Комментарий",
						Строка.ПутьКФайлу,
						Строка.Комментарий);
			
		МассивВозврата.Добавить(Запись);
	КонецЦикла;
	
	Если НЕ ЕстьОшибкиЗаполнения Тогда
		Закрыть(МассивВозврата);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодписиПутьКФайлу.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подписи.ПутьКФайлу");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

КонецПроцедуры

#КонецОбласти
