﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДГОТОВКИ ПЕЧАТНЫХ ФОРМ

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст ошибки)
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя области в которой был выведен объект)
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СогласиеНаОбработкуПерсональныхДанных") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
						КоллекцияПечатныхФорм,
						"СогласиеНаОбработкуПерсональныхДанных", "Согласие на обработку персональных данных",
						ПечатьСогласияНаОбработкуПДн(ПараметрыПечати.ДанныеПечатиСогласия, ОбъектыПечати), ,
						"Обработка.СогласиеНаОбработкуПерсональныхДанных.ПФ_MXL_СогласиеНаОбработкуПерсональныхДанных");
	КонецЕсли;

КонецПроцедуры

// Процедура печати согласия на обработку персональных данных
//
Функция ПечатьСогласияНаОбработкуПДн(Субъекты, ОбъектыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_СогласиеНаОбработкуПерсональныхДанных";
	
	ИмяМакета = "СогласиеНаОбработкуПерсональныхДанных";
	
	ПолеВписывания = СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("_", 50);
	
	ОбластиМакета = Новый Структура;
	ОбластиМакета.Вставить("Заголовок");
	ОбластиМакета.Вставить("НомерДата");
	ОбластиМакета.Вставить("Преамбула");
	ОбластиМакета.Вставить("П1_ЦелиОбработкиПДн");
	ОбластиМакета.Вставить("П2_СоставПДн");
	ОбластиМакета.Вставить("П3_ПравоПолученияИнформации");
	ОбластиМакета.Вставить("П4_СрокДействия");
	ОбластиМакета.Вставить("П5_ДействияСПДн");
	ОбластиМакета.Вставить("П6_ПравоОтзыва");
	ОбластиМакета.Вставить("РеквизитыОператора");
	ОбластиМакета.Вставить("РеквизитыСубъекта");
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.СогласиеНаОбработкуПерсональныхДанных.ПФ_MXL_СогласиеНаОбработкуПерсональныхДанных");

	// Общие данные одинаковые для любого субъекта
	ОбщиеДанные = Субъекты[0];
	
	// Заполнение общих для всех субъектов областей согласия
	Для Каждого КлючИЗначение Из ОбластиМакета Цикл
		ИмяОбласти = КлючИЗначение.Ключ;
		ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
		Если ИмяОбласти = "НомерДата" Тогда
			ОбластьМакета.Параметры.ДатаСогласия = ОбщиеДанные.ДатаСогласия;
		ИначеЕсли ИмяОбласти = "Преамбула" Тогда
			ОбластьМакета.Параметры.Организация = ?(ЗначениеЗаполнено(ОбщиеДанные.Организация), ОбщиеДанные.Организация, ПолеВписывания);
			ОбластьМакета.Параметры.ОтветственныйЗаОбработкуПерсональныхДанных = ?(ЗначениеЗаполнено(ОбщиеДанные.ОтветственныйЗаОбработкуПерсональныхДанных), ОбщиеДанные.ОтветственныйЗаОбработкуПерсональныхДанных, ПолеВписывания);
		ИначеЕсли ИмяОбласти = "РеквизитыОператора" Тогда
			ОбластьМакета.Параметры.Заполнить(ОбщиеДанные);
		КонецЕсли;
		ОбластиМакета.Вставить(ИмяОбласти, ОбластьМакета);
	КонецЦикла;
	
	// Вывод согласий субъектов
	ПервыйДокумент = Истина;
	Для Каждого Субъект Из Субъекты Цикл
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();	
		КонецЕсли;
		ПервыйДокумент = Ложь;
		ТабличныйДокумент.Вывести(ПечатьСогласияНаОбработкуПДнСубъекта(Субъект, ОбластиМакета, ПолеВписывания));
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьСогласияНаОбработкуПДнСубъекта(Субъект, ОбластиМакета, ПолеВписывания)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Для Каждого КлючИЗначение Из ОбластиМакета Цикл
		ИмяОбласти = КлючИЗначение.Ключ;
		ОбластьМакета = КлючИЗначение.Значение;
		Если ИмяОбласти = "Преамбула" Тогда 
			ОбластьМакета.Параметры.ФИО = ?(ЗначениеЗаполнено(Субъект.ФИО), Субъект.ФИО, ПолеВписывания);
		ИначеЕсли ИмяОбласти = "РеквизитыСубъекта" Тогда
			ОбластьМакета.Параметры.Заполнить(Субъект);
		КонецЕсли;
		ТабличныйДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с макетами офисных документов.

Функция ПолучитьДанныеПечати(Знач Субъекты, Знач МассивИменМакетов) Экспорт
	
	ДанныеПоВсемОбъектам = Новый Соответствие;
	
	Для Каждого Субъект Из Субъекты Цикл
		ДанныеОбъектаПоМакетам = Новый Соответствие;
		Для Каждого ИмяМакета Из МассивИменМакетов Цикл
			ДанныеОбъектаПоМакетам.Вставить(ИмяМакета, Субъект);
		КонецЦикла;
		ДанныеПоВсемОбъектам.Вставить(Строка(Субъект.ФИО) + Строка(Субъект.Адрес) + Строка(Субъект.ПаспортныеДанные), ДанныеОбъектаПоМакетам);
	КонецЦикла;
	
	ОписаниеОбластей = Новый Соответствие;
	ДвоичныеДанныеМакетов = Новый Соответствие;
	ТипыМакетов = Новый Соответствие;
	
	Для Каждого ИмяМакета Из МассивИменМакетов Цикл
		Если ИмяМакета = "СогласиеНаОбработкуПерсональныхДанных(MSWord)" Тогда
			ДвоичныеДанныеМакетов.Вставить(ИмяМакета, УправлениеПечатью.МакетПечатнойФормы("Обработка.СогласиеНаОбработкуПерсональныхДанных.ПФ_DOC_СогласиеНаОбработкуПерсональныхДанных"));
			ТипыМакетов.Вставить(ИмяМакета, "DOC");
		ИначеЕсли ИмяМакета = "СогласиеНаОбработкуПерсональныхДанных(ODT)" Тогда
			ДвоичныеДанныеМакетов.Вставить(ИмяМакета, УправлениеПечатью.МакетПечатнойФормы("Обработка.СогласиеНаОбработкуПерсональныхДанных.ПФ_ODT_СогласиеНаОбработкуПерсональныхДанных"));
			ТипыМакетов.Вставить(ИмяМакета, "ODT");
		КонецЕсли;
		ОписаниеОбластей.Вставить(ИмяМакета, ПолучитьОписаниеОбластейМакетаОфисногоДокумента());
	КонецЦикла;
	
	Возврат Новый Структура("Данные, Макеты",
		ДанныеПоВсемОбъектам,
		Новый Структура("ОписаниеОбластей, ТипыМакетов, ДвоичныеДанныеМакетов",
			ОписаниеОбластей,
			ТипыМакетов,
			ДвоичныеДанныеМакетов));
	
КонецФункции

Функция ПолучитьОписаниеОбластейМакетаОфисногоДокумента()
	
	ОписаниеОбластей = Новый Структура;
	
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "Заголовок",			"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "НомерДата",			"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "Преамбула",			"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "ОсновнойТекст",		"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "РеквизитыОператора",	"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "РеквизитыСубъекта",	"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "Подпись",				"Общая");
	
	Возврат ОписаниеОбластей;
	
КонецФункции

#КонецЕсли