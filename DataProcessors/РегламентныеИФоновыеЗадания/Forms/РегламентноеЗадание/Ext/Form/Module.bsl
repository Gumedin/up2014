﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа.
		                             |
		                             |Изменение свойств регламентного задания
		                             |выполняется только администраторами.'");
	КонецЕсли;
	
	Действие = Параметры.Действие;
	
	Если Найти(", Добавить, Скопировать, Изменить,", ", " + Действие + ",") = 0 Тогда
		
		ВызватьИсключение НСтр("ru = 'Неверные параметры открытия формы ""Регламентное задание"".'");
	КонецЕсли;
	
	Если Действие = "Добавить" Тогда
		
		Расписание = Новый РасписаниеРегламентногоЗадания;
		
		Для каждого РегламентноеЗаданиеМетаданные ИЗ Метаданные.РегламентныеЗадания Цикл
			ОписанияМетаданныхРегламентныхЗаданий.Добавить(
				РегламентноеЗаданиеМетаданные.Имя
					+ Символы.ПС
					+ РегламентноеЗаданиеМетаданные.Синоним
					+ Символы.ПС
					+ РегламентноеЗаданиеМетаданные.ИмяМетода,
				?(ПустаяСтрока(РегламентноеЗаданиеМетаданные.Синоним),
				  РегламентноеЗаданиеМетаданные.Имя,
				  РегламентноеЗаданиеМетаданные.Синоним) );
		КонецЦикла;
	Иначе
		Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(Параметры.Идентификатор);
		ЗаполнитьЗначенияСвойств(
			ЭтотОбъект,
			Задание,
			"Ключ,
			|Предопределенное,
			|Использование,
			|Наименование,
			|ИмяПользователя,
			|ИнтервалПовтораПриАварийномЗавершении,
			|КоличествоПовторовПриАварийномЗавершении");
		
		Идентификатор = Строка(Задание.УникальныйИдентификатор);
		Если Задание.Метаданные = Неопределено Тогда
			ИмяМетаданных        = НСтр("ru = '<нет метаданных>'");
			СинонимМетаданных    = НСтр("ru = '<нет метаданных>'");
			ИмяМетодаМетаданных  = НСтр("ru = '<нет метаданных>'");
		Иначе
			ИмяМетаданных        = Задание.Метаданные.Имя;
			СинонимМетаданных    = Задание.Метаданные.Синоним;
			ИмяМетодаМетаданных  = Задание.Метаданные.ИмяМетода;
		КонецЕсли;
		Расписание = Задание.Расписание;
		
		СообщенияПользователюИОписаниеИнформацииОбОшибке = РегламентныеЗаданияСлужебный
			.СообщенияИОписанияОшибокРегламентногоЗадания(Задание);
	КонецЕсли;
	
	Если Действие <> "Изменить" Тогда
		Идентификатор = НСтр("ru = '<будет создан при записи>'");
		Использование = Ложь;
		
		Наименование = ?(
			Действие = "Добавить",
			"",
			РегламентныеЗаданияСлужебный.ПредставлениеРегламентногоЗадания(Задание));
	КонецЕсли;
	
	// Заполнение списка выбора имени пользователя.
	МассивПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();
	
	Для каждого Пользователь Из МассивПользователей Цикл
		Элементы.ИмяПользователя.СписокВыбора.Добавить(Пользователь.Имя);
	КонецЦикла;
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Действие = "Добавить" Тогда
		ПодключитьОбработчикОжидания("ВыборШаблонаНовогоРегламентногоЗадания", 0.1, Истина);
	Иначе
		ОбновитьЗаголовокФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьРегламентноеЗадание();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ЗаписатьИЗакрытьЗавершение();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеВыполнить()

	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	Диалог.Показать(Новый ОписаниеОповещения("ОткрытьРасписаниеЗавершение", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьИЗакрытьЗавершение(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЗаписатьРегламентноеЗадание();
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборШаблонаНовогоРегламентногоЗадания()
	
	// Выбор шаблона регламентного задания (метаданные).
	ОписанияМетаданныхРегламентныхЗаданий.ПоказатьВыборЭлемента(
		Новый ОписаниеОповещения("ВыборШаблонаНовогоРегламентногоЗаданияЗавершение", ЭтотОбъект),
		НСтр("ru = 'Выберите шаблон регламентного задания'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборШаблонаНовогоРегламентногоЗаданияЗавершение(ЭлементСписка, Неопределен) Экспорт
	
	Если ЭлементСписка = Неопределено Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
	
	ИмяМетаданных       = СтрПолучитьСтроку(ЭлементСписка.Значение, 1);
	СинонимМетаданных   = СтрПолучитьСтроку(ЭлементСписка.Значение, 2);
	ИмяМетодаМетаданных = СтрПолучитьСтроку(ЭлементСписка.Значение, 3);
	Наименование        = ЭлементСписка.Представление;
	
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеЗавершение(НовоеРасписание, Неопределен) Экспорт

	Если НовоеРасписание <> Неопределено Тогда
		Расписание = НовоеРасписание;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьРегламентноеЗадание()
	
	Если НЕ ЗначениеЗаполнено(ИмяМетаданных) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийИдентификатор = ?(Действие = "Изменить", Идентификатор, Неопределено);
	
	ЗаписатьРегламентноеЗаданиеНаСервере();
	ОбновитьЗаголовокФормы();
	
	Оповестить("Запись_РегламентныеЗадания", ТекущийИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьРегламентноеЗаданиеНаСервере()
	
	Если Действие = "Изменить" Тогда
		Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(Идентификатор);
	Иначе
		Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(
			Метаданные.РегламентныеЗадания[ИмяМетаданных]);
		
		Идентификатор = Строка(Задание.УникальныйИдентификатор);
		Действие = "Изменить";
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(
		Задание,
		ЭтотОбъект,
		"Ключ, 
		|Наименование,
		|Использование,
		|ИмяПользователя,
		|ИнтервалПовтораПриАварийномЗавершении,
		|КоличествоПовторовПриАварийномЗавершении");
	
	Задание.Расписание = Расписание;
	Задание.Записать();
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовокФормы()
	
	Если НЕ ПустаяСтрока(Наименование) Тогда
		Представление = Наименование;
		
	ИначеЕсли НЕ ПустаяСтрока(СинонимМетаданных) Тогда
		Представление = СинонимМетаданных;
	Иначе
		Представление = ИмяМетаданных;
	КонецЕсли;
	
	Если Действие = "Изменить" Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 (Регламентное задание)'"), Представление);
	Иначе
		Заголовок = НСтр("ru = 'Регламентное задание (создание)'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
