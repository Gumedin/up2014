﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Ссылка = Параметры.Ссылка;
	
	Если ВерсионированиеОбъектов.НомерПоследнейВерсии(Ссылка) = 0 Тогда
		Элементы.ОсновнаяСтраница.ТекущаяСтраница = Элементы.ВерсииДляСравненияОтсутствуют;
		Элементы.НетВерсий.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	       НСтр("ru = 'Предыдущие версии отсутствуют: ""%1"".'"),
	       Строка(Ссылка));
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(СформироватьТаблицуВерсий(Ссылка), "СписокВерсий");
	
	ПереходНаВерсиюРазрешен = Пользователи.ЭтоПолноправныйПользователь();
	Элементы.ПерейтиНаВерсию.Видимость = ПереходНаВерсиюРазрешен;
	Элементы.СписокВерсийПерейтиНаВерсию.Видимость = ПереходНаВерсиюРазрешен;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВерсийПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокВерсий

&НаКлиенте
Процедура СписокВерсийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьОтчетПоВерсииОбъекта();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьВерсиюОбъекта(Команда)
	
	ОткрытьОтчетПоВерсииОбъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаВерсию(Команда)
	
	ВыполнитьПереходНаВыбраннуюВерсию();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчетПоИзменениям(Команда)
	
	ВыделенныеСтроки = Элементы.СписокВерсий.ВыделенныеСтроки;
	СравниваемыеВерсии = СформироватьСписокВыбранныхВерсий(ВыделенныеСтроки);
	
	Если СравниваемыеВерсии.Количество() < 2 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для формирования отчета по изменениям необходимо выбрать хотя бы две версии.'"));
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуОтчета(СравниваемыеВерсии);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция СформироватьТаблицуВерсий(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	                |	НомерВерсии КАК НомерВерсии,
	                |	АвторВерсии КАК АвторВерсии,
	                |	ДатаВерсии  КАК ДатаВерсии,
	                |	Комментарий КАК Комментарий
	                | ИЗ
	                |	РегистрСведений.ВерсииОбъектов
	                |ГДЕ
	                |	Объект=&Ссылка
	                |УПОРЯДОЧИТЬ ПО НомерВерсии Убыв";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Если ВерсионированиеОбъектов.ЕстьПравоНаЧтениеВерсийОбъектов() Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПереходНаВыбраннуюВерсию(ОтменятьПроведение = Ложь)
	
	Если Элементы.СписокВерсий.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ПерейтиНаВерсиюСервер(Ссылка, Элементы.СписокВерсий.ТекущиеДанные.НомерВерсии, ОтменятьПроведение);
	
	Если Результат = "ОшибкаВосстановления" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияОбОшибке);
	ИначеЕсли Результат = "ОшибкаПроведения" Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Переход на версию не был выполнен по причине:
				|%1
				|Перейти на выбранную версию с отменой проведения?'"),
			ТекстСообщенияОбОшибке);
			
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПереходНаВыбраннуюВерсиюВопросЗадан", ЭтотОбъект);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("Перейти", НСтр("ru = 'Перейти'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	Иначе //Результат = "ВосстановлениеВыполнено"
		ОповеститьОбИзменении(Ссылка);
		Если ВладелецФормы <> Неопределено Тогда
			Попытка
				ВладелецФормы.Прочитать();
			Исключение
				// ничего не делаем, если у формы нет метода Прочитать()
			КонецПопытки;
		КонецЕсли;
		ПоказатьПредупреждение(, НСтр("ru = 'Переход к старой версий выполнен успешно.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПереходНаВыбраннуюВерсиюВопросЗадан(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса <> "Перейти" Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьПереходНаВыбраннуюВерсию(Истина);
КонецПроцедуры

&НаСервере
Функция ПерейтиНаВерсиюСервер(Ссылка, НомерВерсии, ОтменаПроведения = Ложь)
	
	Информация = ВерсионированиеОбъектов.СведенияОВерсииОбъекта(Ссылка, НомерВерсии);
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Информация.ВерсияОбъекта);
	
	ТекстСообщенияОбОшибке = "";
	Объект = ВерсионированиеОбъектов.ВосстановитьОбъектПоXML(АдресВоВременномХранилище, ТекстСообщенияОбОшибке);
	
	Если Не ПустаяСтрока(ТекстСообщенияОбОшибке) Тогда
		Возврат "ОшибкаВосстановления";
	КонецЕсли;
	
	Объект.ДополнительныеСвойства.Вставить("ВерсионированиеОбъектовКомментарийКВерсии",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выполнен переход к версии №%1 от %2'"),
			Строка(НомерВерсии),
			Формат(Информация.ДатаВерсии, "ДЛФ=DT")) );
			
	РежимЗаписи = РежимЗаписиДокумента.Запись;
	Если ОбщегоНазначения.ЭтоДокумент(Объект.Метаданные()) Тогда
		Если Объект.Проведен И Не ОтменаПроведения Тогда
			РежимЗаписи = РежимЗаписиДокумента.Проведение;
		Иначе
			РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения;
		КонецЕсли;
		
		Попытка
			Объект.Записать(РежимЗаписи);
		Исключение
			ТекстСообщенияОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			Возврат "ОшибкаПроведения"
		КонецПопытки;
	Иначе
		Попытка
			Объект.Записать();
		Исключение
			ТекстСообщенияОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			Возврат "ОшибкаВосстановления"
		КонецПопытки;
	КонецЕсли;
	
	
	ЗначениеВРеквизитФормы(СформироватьТаблицуВерсий(Ссылка), "СписокВерсий");
	
	Возврат "ВосстановлениеВыполнено";
	
КонецФункции

&НаКлиенте
Процедура ОткрытьОтчетПоВерсииОбъекта()
	
	СравниваемыеВерсии = Новый Массив;
	СравниваемыеВерсии.Добавить(Элементы.СписокВерсий.ТекущиеДанные.НомерВерсии);
	ОткрытьФормуОтчета(СравниваемыеВерсии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(СравниваемыеВерсии)
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Ссылка", Ссылка);
	ПараметрыОтчета.Вставить("СравниваемыеВерсии", СравниваемыеВерсии);
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ОтчетПоВерсиямОбъекта",
		ПараметрыОтчета,
		ЭтотОбъект,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Функция СформироватьСписокВыбранныхВерсий(ВыделенныеСтроки)
	
	СравниваемыеВерсии = Новый СписокЗначений;
	
	Для Каждого НомерВыделеннойСтроки Из ВыделенныеСтроки Цикл
		СравниваемыеВерсии.Добавить(Элементы.СписокВерсий.ДанныеСтроки(НомерВыделеннойСтроки).НомерВерсии);
	КонецЦикла;
	
	СравниваемыеВерсии.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	
	Возврат СравниваемыеВерсии.ВыгрузитьЗначения();
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступность()
	Элементы.ОткрытьВерсиюОбъекта.Доступность = Элементы.СписокВерсий.ВыделенныеСтроки.Количество() > 0;
	Элементы.ОтчетПоИзменениям.Доступность = Элементы.СписокВерсий.ВыделенныеСтроки.Количество() > 1;
	Элементы.ПерейтиНаВерсию.Доступность = Элементы.СписокВерсий.ВыделенныеСтроки.Количество() = 1;
	Элементы.СписокВерсийПерейтиНаВерсию.Доступность = Элементы.ПерейтиНаВерсию.Доступность;
КонецПроцедуры

#КонецОбласти
