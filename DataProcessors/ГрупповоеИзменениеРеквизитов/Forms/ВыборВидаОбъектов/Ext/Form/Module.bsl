﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КоллекцииОбъектовМетаданных = Новый Массив;
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.Справочники);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.Документы);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.БизнесПроцессы);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.Задачи);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.ПланыВидовРасчета);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.ПланыВидовХарактеристик);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.ПланыСчетов);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.ПланыОбмена);
	
	ПрефиксУдаляемыхОбъектов = "Удалить";
	Для Каждого КоллекцияОбъектовМетаданных Из КоллекцииОбъектовМетаданных Цикл
		Для Каждого ОбъектМетаданных Из КоллекцияОбъектовМетаданных Цикл
			Если Не Параметры.ПоказыватьСкрытые Тогда
				Если НРег(Лев(ОбъектМетаданных.Имя, СтрДлина(ПрефиксУдаляемыхОбъектов))) = НРег(ПрефиксУдаляемыхОбъектов)
					Или ЭтоСлужебныйОбъект(ОбъектМетаданных) Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			Если ПравоДоступа("Изменение", ОбъектМетаданных) Тогда
				ДоступныеОбъектыДляИзменения.Добавить(ОбъектМетаданных.ПолноеИмя(), ОбъектМетаданных.Синоним);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	ДоступныеОбъектыДляИзменения.СортироватьПоПредставлению();
	
	Если Не ПустаяСтрока(Параметры.ТекущийОбъект) Тогда
		Элементы.ДоступныеОбъектыДляИзменения.ТекущаяСтрока = ДоступныеОбъектыДляИзменения.НайтиПоЗначению(Параметры.ТекущийОбъект).ПолучитьИдентификатор();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеОбъектыДляИзмененияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Закрыть(Элементы.ДоступныеОбъектыДляИзменения.ТекущиеДанные.Значение);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ТекущиеДанные = Элементы.ДоступныеОбъектыДляИзменения.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Закрыть(ТекущиеДанные.Значение);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЭтоСлужебныйОбъект(ОбъектМетаданных)
	
	МенеджерОбъекта = МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
	
	Попытка
		Редактируемые = МенеджерОбъекта.РеквизитыРедактируемыеВГрупповойОбработке();
		Если Редактируемые.Количество() = 0 Тогда
			Возврат Истина;
		КонецЕсли;
	Исключение
		Редактируемые = Новый Массив;
	КонецПопытки;
	
	Попытка
		НеРедактируемые = МенеджерОбъекта.РеквизитыНеРедактируемыеВГрупповойОбработке();
		Если НеРедактируемые.Найти("*") <> Неопределено Тогда
			Возврат Истина;
		КонецЕсли;
	Исключение
		НеРедактируемые = Новый Массив;
	КонецПопытки;
	
	Возврат Ложь;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции из базовой функциональности для обеспечения автономности

&НаСервереБезКонтекста
Функция МенеджерОбъектаПоПолномуИмени(ПолноеИмя)
	Перем КлассОМ, ИмяОМ, Менеджер;
	
	ЧастиИмени = РазложитьСтрокуВМассивПодстрок(ПолноеИмя, ".");
	
	Если ЧастиИмени.Количество() = 2 Тогда
		КлассОМ = ЧастиИмени[0];
		ИмяОМ  = ЧастиИмени[1];
	КонецЕсли;
	
	Если      ВРег(КлассОМ) = "ПЛАНОБМЕНА" Тогда
		Менеджер = ПланыОбмена;
		
	ИначеЕсли ВРег(КлассОМ) = "СПРАВОЧНИК" Тогда
		Менеджер = Справочники;
		
	ИначеЕсли ВРег(КлассОМ) = "ДОКУМЕНТ" Тогда
		Менеджер = Документы;
		
	ИначеЕсли ВРег(КлассОМ) = "ЖУРНАЛДОКУМЕНТОВ" Тогда
		Менеджер = ЖурналыДокументов;
		
	ИначеЕсли ВРег(КлассОМ) = "ПЕРЕЧИСЛЕНИЕ" Тогда
		Менеджер = Перечисления;
		
	ИначеЕсли ВРег(КлассОМ) = "ОТЧЕТ" Тогда
		Менеджер = Отчеты;
		
	ИначеЕсли ВРег(КлассОМ) = "ОБРАБОТКА" Тогда
		Менеджер = Обработки;
		
	ИначеЕсли ВРег(КлассОМ) = "ПЛАНВИДОВХАРАКТЕРИСТИК" Тогда
		Менеджер = ПланыВидовХарактеристик;
		
	ИначеЕсли ВРег(КлассОМ) = "ПЛАНСЧЕТОВ" Тогда
		Менеджер = ПланыСчетов;
		
	ИначеЕсли ВРег(КлассОМ) = "ПЛАНВИДОВРАСЧЕТА" Тогда
		Менеджер = ПланыВидовРасчета;
		
	ИначеЕсли ВРег(КлассОМ) = "РЕГИСТРСВЕДЕНИЙ" Тогда
		Менеджер = РегистрыСведений;
		
	ИначеЕсли ВРег(КлассОМ) = "РЕГИСТРНАКОПЛЕНИЯ" Тогда
		Менеджер = РегистрыНакопления;
		
	ИначеЕсли ВРег(КлассОМ) = "РЕГИСТРБУХГАЛТЕРИИ" Тогда
		Менеджер = РегистрыБухгалтерии;
		
	ИначеЕсли ВРег(КлассОМ) = "РЕГИСТРРАСЧЕТА" Тогда
		Если ЧастиИмени.Количество() = 2 Тогда
			// Регистр расчета
			Менеджер = РегистрыРасчета;
		Иначе
			КлассПодчиненногоОМ = ЧастиИмени[2];
			ИмяПодчиненногоОМ = ЧастиИмени[3];
			Если ВРег(КлассПодчиненногоОМ) = "ПЕРЕРАСЧЕТ" Тогда
				// Перерасчет
				Менеджер = РегистрыРасчета[ИмяОМ].Перерасчеты;
			Иначе
				ВызватьИсключение ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Неизвестный тип объекта метаданных ""%1""'"), ПолноеИмя);
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ВРег(КлассОМ) = "БИЗНЕСПРОЦЕСС" Тогда
		Менеджер = БизнесПроцессы;
		
	ИначеЕсли ВРег(КлассОМ) = "ЗАДАЧА" Тогда
		Менеджер = Задачи;
		
	ИначеЕсли ВРег(КлассОМ) = "КОНСТАНТА" Тогда
		Менеджер = Константы;
		
	ИначеЕсли ВРег(КлассОМ) = "ПОСЛЕДОВАТЕЛЬНОСТЬ" Тогда
		Менеджер = Последовательности;
	КонецЕсли;
	
	Если Менеджер <> Неопределено Тогда
		Попытка
			Возврат Менеджер[ИмяОМ];
		Исключение
			Менеджер = Неопределено;
		КонецПопытки;
	КонецЕсли;
	
	ВызватьИсключение ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Неизвестный тип объекта метаданных ""%1""'"), ПолноеИмя);
	
КонецФункции

// Разбивает строку на несколько строк по разделителю. Разделитель может иметь любую длину.
//
// Параметры:
//  Строка                 - Строка - текст с разделителями;
//  Разделитель            - Строка - разделитель строк текста, минимум 1 символ;
//  ПропускатьПустыеСтроки - Булево - признак необходимости включения в результат пустых строк.
//    Если параметр не задан, то функция работает в режиме совместимости со своей предыдущей версией:
//     - для разделителя-пробела пустые строки не включаются в результат, для остальных разделителей пустые строки
//       включаются в результат.
//     - если параметр Строка не содержит значащих символов или не содержит ни одного символа (пустая строка), то в
//       случае разделителя-пробела результатом функции будет массив, содержащий одно значение "" (пустая строка), а
//       при других разделителях результатом функции будет пустой массив.
//
//
// Возвращаемое значение:
//  Массив - массив строк.
//
// Примеры:
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",") - возвратит массив из 5 элементов, три из которых  - пустые строки;
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",", Истина) - возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок(" один   два  ", " ") - возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок("") - возвратит пустой массив;
//  РазложитьСтрокуВМассивПодстрок("",,Ложь) - возвратит массив с одним элементом "" (пустой строкой);
//  РазложитьСтрокуВМассивПодстрок("", " ") - возвратит массив с одним элементом "" (пустой строкой);
//
&НаКлиентеНаСервереБезКонтекста
Функция РазложитьСтрокуВМассивПодстрок(Знач Строка, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено)
	
	Результат = Новый Массив;
	
	// для обеспечения обратной совместимости
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Строка) Тогда 
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	//
	
	Позиция = Найти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Результат.Добавить(Подстрока);
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = Найти(Строка, Разделитель);
	КонецЦикла;
	
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
		Результат.Добавить(Строка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 

// Подставляет параметры в строку. Максимально возможное число параметров - 9.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров начинается с единицы.
//
// Параметры:
//  СтрокаПодстановки  - Строка - шаблон строки с параметрами (вхождениями вида "%ИмяПараметра");
//  Параметр<n>        - Строка - подставляемый параметр.
//
// Возвращаемое значение:
//  Строка   - текстовая строка с подставленными параметрами.
//
// Пример:
//  ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), "Вася", "Зоопарк") = "Вася пошел в Зоопарк".
//
&НаКлиентеНаСервереБезКонтекста
Функция ПодставитьПараметрыВСтроку(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено)
	
	ИспользоватьАльтернативныйАлгоритм = 
		Найти(Параметр1, "%")
		Или Найти(Параметр2, "%")
		Или Найти(Параметр3, "%")
		Или Найти(Параметр4, "%")
		Или Найти(Параметр5, "%")
		Или Найти(Параметр6, "%")
		Или Найти(Параметр7, "%")
		Или Найти(Параметр8, "%")
		Или Найти(Параметр9, "%");
		
	Если ИспользоватьАльтернативныйАлгоритм Тогда
		СтрокаПодстановки = ПодставитьПараметрыВСтрокуАльтернативныйАлгоритм(СтрокаПодстановки, Параметр1,
			Параметр2, Параметр3, Параметр4, Параметр5, Параметр6, Параметр7, Параметр8, Параметр9);
	Иначе
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%1", Параметр1);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%2", Параметр2);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%3", Параметр3);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%4", Параметр4);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%5", Параметр5);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%6", Параметр6);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%7", Параметр7);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%8", Параметр8);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%9", Параметр9);
	КонецЕсли;
	
	Возврат СтрокаПодстановки;
КонецФункции

// Вставляет параметры в строку, учитывая, что в параметрах могут использоваться подстановочные слова %1, %2 и т.д.
&НаКлиентеНаСервереБезКонтекста
Функция ПодставитьПараметрыВСтрокуАльтернативныйАлгоритм(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено)
	
	Результат = "";
	Позиция = Найти(СтрокаПодстановки, "%");
	Пока Позиция > 0 Цикл 
		Результат = Результат + Лев(СтрокаПодстановки, Позиция - 1);
		СимволПослеПроцента = Сред(СтрокаПодстановки, Позиция + 1, 1);
		ПодставляемыйПараметр = "";
		Если СимволПослеПроцента = "1" Тогда
			ПодставляемыйПараметр =  Параметр1;
		ИначеЕсли СимволПослеПроцента = "2" Тогда
			ПодставляемыйПараметр =  Параметр2;
		ИначеЕсли СимволПослеПроцента = "3" Тогда
			ПодставляемыйПараметр =  Параметр3;
		ИначеЕсли СимволПослеПроцента = "4" Тогда
			ПодставляемыйПараметр =  Параметр4;
		ИначеЕсли СимволПослеПроцента = "5" Тогда
			ПодставляемыйПараметр =  Параметр5;
		ИначеЕсли СимволПослеПроцента = "6" Тогда
			ПодставляемыйПараметр =  Параметр6;
		ИначеЕсли СимволПослеПроцента = "7" Тогда
			ПодставляемыйПараметр =  Параметр7
		ИначеЕсли СимволПослеПроцента = "8" Тогда
			ПодставляемыйПараметр =  Параметр8;
		ИначеЕсли СимволПослеПроцента = "9" Тогда
			ПодставляемыйПараметр =  Параметр9;
		КонецЕсли;
		Если ПодставляемыйПараметр = "" Тогда
			Результат = Результат + "%";
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 1);
		Иначе
			Результат = Результат + ПодставляемыйПараметр;
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 2);
		КонецЕсли;
		Позиция = Найти(СтрокаПодстановки, "%");
	КонецЦикла;
	Результат = Результат + СтрокаПодстановки;
	
	Возврат Результат;
КонецФункции

#КонецОбласти
