﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Обработчики событий подсистемы ВариантыОтчетов.

// Содержит настройки размещения вариантов отчетов в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации()
//
// Описание:
//   В данной процедуре необходимо указать каким именно образом предопределенные варианты отчетов
//   будут регистрироваться в программе и показываться в панели отчетов.
//
// Вспомогательные методы:
//   НастройкиОтчета   = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.<ИмяОтчета>);
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//
//   Данные функции получают соответственно настройки отчета и настройки варианта отчета следующей структуры:
//       * Включен - Булево -
//           Если Ложь, то вариант отчета не регистрируется в подсистеме.
//           Используется для удаления технических и контекстных вариантов отчетов из всех интерфейсов.
//           Эти варианты отчета по прежнему можно открывать в форме отчета программно при помощи
//           параметров открытия (см. справку по "Расширение управляемой формы для отчета.КлючВарианта").
//       * ВидимостьПоУмолчанию - Булево -
//           Если Ложь, то вариант отчета по умолчанию скрыт в панели отчетов.
//           Пользователь может "включить" его в режиме настройки панели отчетов
//           или открыть через форму "Все отчеты".
//       * Описание - Строка - Дополнительная информация по варианту отчета.
//           В панели отчетов выводится в качестве подсказки.
//           Должно расшифровывать для пользователя содержимое варианта отчета
//           и не должно дублировать наименование варианта отчета.
//       * Размещение - Соответствие - Настройки размещения варианта отчета в разделах.
//           ** Ключ     - ОбъектМетаданных: Подсистема - Подсистема, в которой размещается отчет или вариант отчета
//           ** Значение - Строка - Необязательный. Настройки размещения в подсистеме.
//               ""        - Выводить отчет в своей группе обычным шрифтом.
//               "Важный"  - Выводить отчет в своей группе жирным шрифтом.
//               "СмТакже" - Выводить отчет в группе "См. также".
//       * ФункциональныеОпции - Массив из Строка -
//            Имена функциональных опций варианта отчета.
//
// Например:
//
//  (1) Добавить в подсистему вариант отчета.
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "ИмяВарианта1");
//	Вариант.Размещение.Вставить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
//  (2) Отключить вариант отчета.
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "ИмяВарианта1");
//	Вариант.Включен = Ложь;
//
//  (3) Отключить все варианты отчета, кроме требуемого.
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	Отчет.Включен = Ложь;
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта");
//	Вариант.Включен = Истина;
//
//  (4) Результат исполнения 4.1 и 4.2 будет одинаковым:
//  (4.1)
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта1");
//	Вариант.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта2");
//	Вариант.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта3");
//	Вариант.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
//  (4.2)
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	Отчет.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//	ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта1");
//	ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта2");
//	ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта3");
//	Отчет.Размещение.Вставить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
// Важно:
//   Отчет выступает в качестве контейнера вариантов.
//     Изменяя настройки отчета можно сразу изменять настройки всех его вариантов.
//     Однако, если явно получить настройки варианта отчета, то они станут самостоятельными,
//     т.е. более не будут наследовать изменения настроек от отчета. См. примеры 3 и 4.
//   
//   Начальная настройка размещения отчетов по подсистемам зачитывается из метаданных,
//     ее дублирование в коде не требуется.
//   
//   Функциональные опции вариантов объединяются с функциональными опциями отчетов по следующим правилам:
//     (ФункциональнаяОпция1Отчета ИЛИ ФункциональнаяОпция2Отчета) И (ФункциональнаяОпция3Варианта ИЛИ ФункциональнаяОпция4Варианта).
//   Функциональные опции отчетов не зачитываются из метаданных,
//     они применяются на этапе использования подсистемы пользователем.
//   Через ОписаниеОтчета можно добавлять функциональные опции, которые будут соединяться по указанным выше правилам,
//     но надо помнить, что эти функциональные опции будут действовать только для предопределенных вариантов этого отчета.
//   Для пользовательских вариантов отчета действуют только функциональные опции отчета
//     - они отключаются только с отключением всего отчета.
//
Процедура НастроитьВариантыОтчета(Настройки) Экспорт
	
	Свойства = ДатыЗапретаИзмененияПовтИсп.СвойстваРазделов();
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	
	Отчет = МодульВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ДатыЗапретаЗагрузки);
	Отчет.Включен = Ложь;
	
	Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
		УстановитьВариант = "ДатыЗапретаЗагрузкиПоРазделамОбъектамДляПользователей";
		Описание =
			НСтр("ru = 'Выводит даты запрета загрузки для пользователей,
			           |сгруппированные по разделам с объектами.'");
		
	ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
		УстановитьВариант = "ДатыЗапретаЗагрузкиПоРазделамДляПользователей";
		Описание =
			НСтр("ru = 'Выводит даты запрета загрузки для пользователей,
			           |сгруппированные по разделам.'");
	Иначе
		УстановитьВариант = "ДатыЗапретаЗагрузкиПоОбъектамДляПользователей";
		Описание =
			НСтр("ru = 'Выводит даты запрета загрузки для пользователей,
			           |сгруппированные по объектам.'");
	КонецЕсли;
	Вариант = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, УстановитьВариант);
	Вариант.Включен = Истина;
	Вариант.Описание = Описание;
	
	Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
		УстановитьВариант = "ДатыЗапретаЗагрузкиПоПользователям";
		Описание =
			НСтр("ru = 'Выводит даты запрета загрузки для разделов с объектами,
			           |сгруппированные по пользователям.'");
		
	ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
		УстановитьВариант = "ДатыЗапретаЗагрузкиПоПользователямБезОбъектов";
		Описание =
			НСтр("ru = 'Выводит даты запрета загрузки для разделов,
			           |сгруппированные по пользователям.'");
	Иначе
		УстановитьВариант = "ДатыЗапретаЗагрузкиПоПользователямБезРазделов";
		Описание =
			НСтр("ru = 'Выводит даты запрета загрузки для объектов,
			           |сгруппированные по пользователям.'");
	КонецЕсли;
	Вариант = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, УстановитьВариант);
	Вариант.Включен = Истина;
	Вариант.Описание = Описание;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
