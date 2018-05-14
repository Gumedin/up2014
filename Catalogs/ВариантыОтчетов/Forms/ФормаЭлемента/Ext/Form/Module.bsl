﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Перезаполнение реквизитов, связанных с предопределенным объектом после записи.
	ПрочитатьСвойстваПредопределенного(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда 
		Возврат;
	КонецЕсли;
	Если Объект.Ссылка.Пустая() Тогда
		ОшибкаОткрытия = НСтр("ru = 'Новый вариант отчета можно создать только из формы отчета'");
		Возврат;
	КонецЕсли;
	
	// Чтение свойств предопределенного;
	// Заполнение реквизитов, связанных с предопределенным объектом при открытии.
	ПрочитатьСвойстваПредопределенного(Истина);
	
	ПолныеПраваНаВарианты = ВариантыОтчетов.ПолныеПраваНаВарианты();
	
	Если Объект.ПометкаУдаления Тогда
		Элементы.ВидимостьПоУмолчанию.ТолькоПросмотр = Истина;
		Элементы.ДеревоПодсистем.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Не Объект.Пользовательский Тогда
		Элементы.Наименование.ТолькоПросмотр = Истина;
		Элементы.Доступен.ТолькоПросмотр = Истина;
		Элементы.Автор.ТолькоПросмотр = Истина;
		Элементы.Автор.АвтоОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
	ЭтоВнешний = (Объект.ТипОтчета = Перечисления.ТипыОтчетов.Внешний);
	Если ЭтоВнешний Тогда
		Элементы.ВидимостьПоУмолчанию.ТолькоПросмотр = Истина;
		Элементы.ДеревоПодсистем.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Элементы.Доступен.ТолькоПросмотр = Не ПолныеПраваНаВарианты;
	Элементы.Автор.ТолькоПросмотр = Не ПолныеПраваНаВарианты;
	Элементы.ТехническаяИнформация.Видимость = ПолныеПраваНаВарианты;
	
	// Заполнение имени отчета для команды "Просмотр"
	Если Объект.ТипОтчета = Перечисления.ТипыОтчетов.Внутренний Тогда
		ИмяОтчета = Объект.Отчет.Имя;
	ИначеЕсли Объект.ТипОтчета = Перечисления.ТипыОтчетов.Дополнительный Тогда
		ИмяОтчета = Объект.Отчет.ИмяОбъекта;
	Иначе
		ИмяОтчета = Объект.Отчет;
	КонецЕсли;
	
	ПерезаполнитьДерево();
	
	ВариантыОтчетов.ДеревоПодсистемДобавитьУсловноеОформление(ЭтотОбъект);
	
	Доступен = ?(Объект.ТолькоДляАвтора, "1", "2");
	
	ВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Не ПустаяСтрока(ОшибкаОткрытия) Тогда
		Если Объект.Ссылка.Пустая() Тогда
			Отказ = Истина;
		Иначе
			ТолькоПросмотр = Истина;
		КонецЕсли;
		
		ПоказатьПредупреждение(, ОшибкаОткрытия);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = ВариантыОтчетовКлиентСервер.ИмяСобытияИзменениеВарианта() Тогда
		ПерезаполнитьДерево();
		Элементы.ДеревоПодсистем.Развернуть(ДеревоПодсистем.ПолучитьЭлементы()[0].ПолучитьИдентификатор(), Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Запись свойств, связанных с предопределенным вариантом отчета.
	Если ТипЗнч(СвойстваПредопределенного) = Тип("ФиксированнаяСтруктура") Тогда
		Если Объект.ВидимостьПоУмолчанию <> СвойстваПредопределенного.ВидимостьПоУмолчанию Тогда
			Объект.ВидимостьПоУмолчаниюПереопределена = Истина;
		КонецЕсли;
		
		Если Не ПустаяСтрока(Объект.Описание) И НРег(СокрЛП(Объект.Описание)) = НРег(СокрЛП(СвойстваПредопределенного.Описание)) Тогда
			Объект.Описание = "";
		КонецЕсли;
	КонецЕсли;
	
	// Запись дерева подсистем.
	ВариантыОтчетов.ДеревоПодсистемЗаписать(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПараметрОповещения = Новый Структура("Ссылка, Наименование, Автор, Описание, ВидимостьПоУмолчанию");
	ЗаполнитьЗначенияСвойств(ПараметрОповещения, Объект);
	Оповестить(ВариантыОтчетовКлиентСервер.ИмяСобытияИзменениеВарианта(), ПараметрОповещения, ИмяФормы);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВариантыОтчетовКлиент.РедактироватьМногострочныйТекст(ЭтотОбъект, Элемент.ТекстРедактирования, Объект, "Описание", НСтр("ru = 'Описание'"));
КонецПроцедуры

&НаКлиенте
Процедура ДоступенПриИзменении(Элемент)
	Объект.ТолькоДляАвтора = (ЭтотОбъект.Доступен = "1");
	ВидимостьДоступность(ЭтотОбъект, "ТолькоДляАвтора");
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьПоУмолчаниюПриИзменении(Элемент)
	Объект.ВидимостьПоУмолчаниюПереопределена = Не Объект.ВидимостьПоУмолчаниюПереопределена;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПодсистем

&НаКлиенте
Процедура ДеревоПодсистемИспользованиеПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемИспользованиеПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемВажностьПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемВажностьПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ВидимостьДоступность(Форма, Изменения = "")
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если Изменения = "" Тогда
		Если Объект.КлючВарианта = "" Тогда
			ПредставлениеТипа = НСтр("ru = 'Отчет'");
		Иначе
			ПредставлениеТипа = НСтр("ru = 'Вариант отчета'");
		КонецЕсли;
		Форма.Заголовок = Объект.Наименование + " (" + ПредставлениеТипа + ")";
	КонецЕсли;
	
	Если Не Форма.ТолькоПросмотр Тогда
		Если Изменения = "" Или Изменения = "ТолькоДляАвтора" Тогда
			Если Не Форма.ЭтоВнешний И Не Объект.ПометкаУдаления Тогда
				Элементы.ВидимостьПоУмолчанию.Доступность = Не Объект.ТолькоДляАвтора;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПерезаполнитьДерево()
	ДеревоПриемник = ВариантыОтчетов.ДеревоПодсистемСформировать(ЭтотОбъект, Объект);
	ЗначениеВРеквизитФормы(ДеревоПриемник, "ДеревоПодсистем");
	Возврат Истина;
КонецФункции

&НаСервере
Процедура ПрочитатьСвойстваПредопределенного(ПервоеЧтение)
	
	Если Не ПервоеЧтение И ТипЗнч(СвойстваПредопределенного) <> Тип("ФиксированнаяСтруктура") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПервоеЧтение Тогда
		Если Объект.Пользовательский
			Или Объект.ТипОтчета <> Перечисления.ТипыОтчетов.Внутренний
			Или Не ЗначениеЗаполнено(Объект.ПредопределенныйВариант) Тогда
			Возврат;
		КонецЕсли;
		
		Запрос = Новый Запрос("ВЫБРАТЬ ВидимостьПоУмолчанию, Описание ИЗ Справочник.ПредопределенныеВариантыОтчетов ГДЕ Ссылка = &Ссылка");
		Запрос.УстановитьПараметр("Ссылка", Объект.ПредопределенныйВариант);
		РезультатЗапроса = Запрос.Выполнить().Выгрузить()[0];
		СтруктураСвойствПредопределенного = Новый Структура("ВидимостьПоУмолчанию, Описание");
		ЗаполнитьЗначенияСвойств(СтруктураСвойствПредопределенного, РезультатЗапроса);
		СвойстваПредопределенного = Новый ФиксированнаяСтруктура(СтруктураСвойствПредопределенного);
	КонецЕсли;
	
	Если Объект.ВидимостьПоУмолчаниюПереопределена = Ложь Тогда
		Объект.ВидимостьПоУмолчанию = СвойстваПредопределенного.ВидимостьПоУмолчанию;
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.Описание) Тогда
		Объект.Описание = СвойстваПредопределенного.Описание;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
