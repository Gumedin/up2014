﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ТекущиеПараметрыЗаписи;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ПорядокЗаполнения = НайтиМаксимальныйПорядок() + 1;
	Иначе
		Элементы.ПолныйПутьLinux.ОтображениеПредупрежденияПриРедактировании
			= ОтображениеПредупрежденияПриРедактировании.Отображать;
		
		Элементы.ПолныйПутьWindows.ОтображениеПредупрежденияПриРедактировании
			= ОтображениеПредупрежденияПриРедактировании.Отображать;
		
		ТекущийРазмерВБайтах = РаботаСФайламиСлужебныйВызовСервера.ПодсчитатьРазмерФайловНаТоме(
			Объект.Ссылка);
			
		ТекущийРазмер = ТекущийРазмерВБайтах / (1024 * 1024);
		Если ТекущийРазмер = 0 И ТекущийРазмерВБайтах <> 0 Тогда
			ТекущийРазмер = 1;
		КонецЕсли;
	КонецЕсли;
	
	СистемнаяИнфо = Новый СистемнаяИнформация;
	ТипПлатформыСервера = СистемнаяИнфо.ТипПлатформы;
	Если ТипПлатформыСервера = ТипПлатформы.Windows_x86
	 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
		
		Элементы.ПолныйПутьWindows.АвтоОтметкаНезаполненного = Истина;
	Иначе
		Элементы.ПолныйПутьLinux.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьОповещение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ПараметрыЗаписи.Свойство("ВнешниеРесурсыРазрешены") Тогда
		Отказ = Истина;
		ТекущиеПараметрыЗаписи = ПараметрыЗаписи;
		ПодключитьОбработчикОжидания("РазрешитьВнешнийРесурсНачало", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(СсылкаНового) И ТекущийОбъект.ЭтоНовый() Тогда
		ТекущийОбъект.УстановитьСсылкуНового(СсылкаНового);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("ЗаписатьИЗакрыть") Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	
	Если ПроверкаЗаполненияУжеВыполнена Тогда
		ПроверкаЗаполненияУжеВыполнена = Ложь;
		ТекущийОбъект.ДополнительныеСвойства.Вставить("ПропуститьОсновнуюПроверкуЗаполнения");
	Иначе
		ТекущийОбъект.ДополнительныеСвойства.Вставить("ПропуститьПроверкуДоступаКПапке");
	КонецЕсли;
	
	ПроверяемыеРеквизиты.Очистить();
	
	Если Не ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолныйПутьWindowsПриИзменении(Элемент)
	
	// Удаляем лишние пробелы и добавляем слэш в конце, если его нет.
	Если Не ПустаяСтрока(Объект.ПолныйПутьWindows) Тогда
		
		Если СтрНачинаетсяС(Объект.ПолныйПутьWindows, " ") Или СтрЗаканчиваетсяНа(Объект.ПолныйПутьWindows, " ") Тогда
			Объект.ПолныйПутьWindows = СокрЛП(Объект.ПолныйПутьWindows);
		КонецЕсли;
		
		Если Не СтрЗаканчиваетсяНа(Объект.ПолныйПутьWindows, "\") Тогда
			Объект.ПолныйПутьWindows = Объект.ПолныйПутьWindows + "\";
		КонецЕсли;
		
		Если СтрЗаканчиваетсяНа(Объект.ПолныйПутьWindows, "\\") Тогда
			Объект.ПолныйПутьWindows = Лев(Объект.ПолныйПутьWindows, СтрДлина(Объект.ПолныйПутьWindows) - 1);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолныйПутьLinuxПриИзменении(Элемент)
	
	// Удаляем лишние пробелы и добавляем слэш в конце, если его нет.
	Если Не ПустаяСтрока(Объект.ПолныйПутьLinux) Тогда
		
		Если СтрНачинаетсяС(Объект.ПолныйПутьLinux, " ") Или СтрЗаканчиваетсяНа(Объект.ПолныйПутьLinux, " ") Тогда
			Объект.ПолныйПутьLinux = СокрЛП(Объект.ПолныйПутьLinux);
		КонецЕсли;
		
		Если Не СтрЗаканчиваетсяНа(Объект.ПолныйПутьLinux, "/") Тогда
			Объект.ПолныйПутьLinux = Объект.ПолныйПутьLinux + "/";
		КонецЕсли;
		
		Если СтрЗаканчиваетсяНа(Объект.ПолныйПутьLinux, "//") Тогда
			Объект.ПолныйПутьLinux = Лев(Объект.ПолныйПутьLinux, СтрДлина(Объект.ПолныйПутьLinux) - 1);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Записать(Новый Структура("ЗаписатьИЗакрыть"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЦелостностьТома(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
			ТекстВопроса = НСтр("ru = 'Для выполнения проверки целостности требуется записать сведения о томе.
					|Записать?'");
			Оповещение = Новый ОписаниеОповещения("ТребуетсяЗаписатьФормуДляПроверкиЦелостностиТома", ЭтотОбъект);
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыполнитьПроверкуЦелостностиТома();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЛишниеФайлы(Команда)
	ПараметрыОткрытия = Новый Структура("ТомХраненияФайлов", Объект.Ссылка);
	ОткрытьФорму("Справочник.ТомаХраненияФайлов.Форма.УдалениеЛишнихФайловИзТома", ПараметрыОткрытия, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ТребуетсяЗаписатьФормуДляПроверкиЦелостностиТома(Записать, ДополнительныеПараметры) Экспорт
	
	Если Записать = КодВозвратаДиалога.Да Тогда
		ЗаписатьНаСервере();
		ВыполнитьПроверкуЦелостностиТома();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПроверкуЦелостностиТома()
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыОтчета.Вставить("Отбор", Новый Структура("Том", Объект.Ссылка));
	
	ОткрытьФорму("Отчет.ПроверкаЦелостностиТома.ФормаОбъекта", ПараметрыОтчета);

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьОповещение(Результат, Контекст) Экспорт
	
	Записать(Новый Структура("ЗаписатьИЗакрыть"));
	
КонецПроцедуры

// Находит максимальный порядок среди томов.
&НаСервере
Функция НайтиМаксимальныйПорядок()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МАКСИМУМ(Тома.ПорядокЗаполнения) КАК МаксимальныйНомер
	|ИЗ
	|	Справочник.ТомаХраненияФайлов КАК Тома";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если Выборка.МаксимальныйНомер = Null Тогда
			Возврат 0;
		Иначе
			Возврат Число(Выборка.МаксимальныйНомер);
		КонецЕсли;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции

&НаКлиенте
Процедура РазрешитьВнешнийРесурсНачало()
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		ЗапросыВнешнихРесурсов = Новый Массив;
		Если Не ПроверитьЗаполнениеНаСервере(ЗапросыВнешнихРесурсов) Тогда
			Возврат;
		КонецЕсли;
		
		ОповещениеОЗакрытии = Новый ОписаниеОповещения(
			"РазрешитьВнешнийРесурсЗавершение", ЭтотОбъект, ТекущиеПараметрыЗаписи);
		МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
		МодульРаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(ЗапросыВнешнихРесурсов, ЭтотОбъект, ОповещениеОЗакрытии);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьЗаполнениеНаСервере(ЗапросыВнешнихРесурсов)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПроверкаЗаполненияУжеВыполнена = Истина;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СсылкаНаОбъект = Объект.Ссылка;
	Иначе
		Если Не ЗначениеЗаполнено(СсылкаНового) Тогда
			СсылкаНового = Справочники.ТомаХраненияФайлов.ПолучитьСсылку();
		КонецЕсли;
		СсылкаНаОбъект = СсылкаНового;
	КонецЕсли;
	
	ЗапросыВнешнихРесурсов.Добавить(
		Справочники.ТомаХраненияФайлов.ЗапросНаИспользованиеВнешнихРесурсовДляТома(
			СсылкаНаОбъект, Объект.ПолныйПутьWindows, Объект.ПолныйПутьLinux));
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура РазрешитьВнешнийРесурсЗавершение(Результат, ПараметрыЗаписи) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ПараметрыЗаписи.Вставить("ВнешниеРесурсыРазрешены");
		Записать(ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	Записать();
КонецПроцедуры

#КонецОбласти
