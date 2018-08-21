﻿#Область СлужебныйПрограммныйИнтерфейс

// Из переданных имен файлов выделяются имена файлов данных и имена файлов их подписей.
// Сопоставление происходит по правилам формирования имени подписи и расширения файла подписи (p7s).
// Например:
//  Имя файла данных:  "example.txt"
//  имя файла подписи: "example-Ivanov Petr.p7s"
//  имя файла подписи: "example-Ivanov Petr (1).p7s".
//
// Параметры:
//  ИменаФайлов - Массив - имена файлов типа Строка.
//
// Возвращаемое значение:
//  Соответствие - содержит:
//   * Ключ     - Строка - имя файла.
//   * Значение - Массив - имена файлов подписей типа Строка.
// 
Функция ИменаФайловПодписейИменФайловДанных(ИменаФайлов) Экспорт
	
	ПерсональныеНастройки = ЭлектроннаяПодписьКлиентСервер.ПерсональныеНастройки();
	РасширениеДляФайловПодписи = ПерсональныеНастройки.РасширениеДляФайловПодписи;
	
	Результат = Новый Соответствие;
	
	// Разделяем файлы по расширению.
	ИменаФайловДанных = Новый Массив;
	ИменаФайловПодписей = Новый Массив;
	
	Для Каждого ИмяФайла Из ИменаФайлов Цикл
		Если СтрЗаканчиваетсяНа(ИмяФайла, РасширениеДляФайловПодписи) Тогда
			ИменаФайловПодписей.Добавить(ИмяФайла);
		Иначе
			ИменаФайловДанных.Добавить(ИмяФайла);
		КонецЕсли;
	КонецЦикла;
	
	// Отсортируем имена файлов данных по убыванию числа символов в строке.
	
	Для ИндексА = 1 По ИменаФайловДанных.Количество() Цикл
		ИндексМАКС = ИндексА; // Считаем что текущий файл имеет самое большое число символов.
		Для ИндексБ = ИндексА+1 По ИменаФайловДанных.Количество() Цикл
			Если СтрДлина(ИменаФайловДанных[ИндексМАКС-1]) > СтрДлина(ИменаФайловДанных[ИндексБ-1]) Тогда
				ИндексМАКС = ИндексБ;
			КонецЕсли;
		КонецЦикла;
		своп = ИменаФайловДанных[ИндексА-1];
		ИменаФайловДанных[ИндексА-1] = ИменаФайловДанных[ИндексМАКС-1];
		ИменаФайловДанных[ИндексМАКС-1] = своп;
	КонецЦикла;
	
	// Поиск соответствий имен файлов.
	Для Каждого ИмяФайлаДанных Из ИменаФайловДанных Цикл
		Результат.Вставить(ИмяФайлаДанных, НайтиИменаФайловПодписей(ИмяФайлаДанных, ИменаФайловПодписей));
	КонецЦикла;
	
	// Оставшиеся файлы подписей не распознаны как подписи относящиеся к какому то файлу.
	Для Каждого ИмяФайлаПодписи Из ИменаФайловПодписей Цикл
		Результат.Вставить(ИмяФайлаПодписи, Новый Массив);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Формирует имя файла подписи по шаблону.
//
Функция ИмяФайлаПодписи(ИмяБезРасширения, КомуВыданСертификат, РасширениеДляФайловПодписи = Неопределено, ТребуетсяРазделитель = Истина) Экспорт
	
	Если НЕ ЗначениеЗаполнено(РасширениеДляФайловПодписи) Тогда
		РасширениеДляФайловПодписи = ЭлектроннаяПодписьКлиентСервер.ПерсональныеНастройки().РасширениеДляФайловПодписи;
	КонецЕсли;
	
	Разделитель = ?(ТребуетсяРазделитель, " - ", " ");
	
	ИмяФайлаПодписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1%2%3.%4",
		ИмяБезРасширения, Разделитель, КомуВыданСертификат, РасширениеДляФайловПодписи);
		
	Возврат ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайлаПодписи);
	
КонецФункции

// Формирует имя файла сертификата по шаблону.
//
Функция ИмяФайлаСертификата(ИмяБезРасширения, КомуВыданСертификат, РасширениеДляФайловСертификата, ТребуетсяРазделитель = Истина) Экспорт
	
	Разделитель = ?(ТребуетсяРазделитель, " - ", " ");
	
	ИмяФайлаСертификата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1%2%3.%4",
		ИмяБезРасширения, Разделитель, КомуВыданСертификат, РасширениеДляФайловСертификата);
		
	Возврат ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайлаСертификата);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеПрограммыПоИмениКриптопровайдера(ИмяКриптопровайдера) Экспорт
	
	ОписанияПрограмм = ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().ОписанияПрограмм;
	
	ПрограммаНайдена = Ложь;
	Для Каждого ОписаниеПрограммы Из ОписанияПрограмм Цикл
		Если ОписаниеПрограммы.ИмяПрограммы = ИмяКриптопровайдера Тогда
			ПрограммаНайдена = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПрограммаНайдена Тогда
		Возврат ОписаниеПрограммы;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Только для внутреннего использования.
Функция МенеджерКриптографииОписанияПрограмм(Программа, Ошибки) Экспорт
	
	ОписанияПрограмм = ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().ОписанияПрограмм;
	
	Если Программа <> Неопределено Тогда
		ПрограммаНеНайдена = Истина;
		Для каждого ОписаниеПрограммы Из ОписанияПрограмм Цикл
			Если ОписаниеПрограммы.Ссылка = Программа Тогда
				ПрограммаНеНайдена = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ПрограммаНеНайдена Тогда
			МенеджерКриптографииДобавитьОшибку(Ошибки, Программа,
				НСтр("ru = 'Не предусмотрена для использования.'"), Истина);
			Возврат Неопределено;
		КонецЕсли;
		ОписанияПрограмм = Новый Массив;
		ОписанияПрограмм.Добавить(ОписаниеПрограммы);
	КонецЕсли;
	
	Возврат ОписанияПрограмм;
	
КонецФункции

// Только для внутреннего использования.
Функция МенеджерКриптографииСвойстваПрограммы(ОписаниеПрограммы, ЭтоLinux, Ошибки, ЭтоСервер,
			ПутиКПрограммамНаСерверахLinux = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ОписаниеПрограммы.ИмяПрограммы) Тогда
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка,
			НСтр("ru = 'Не указано имя программы.'"), Истина);
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОписаниеПрограммы.ТипПрограммы) Тогда
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка,
			НСтр("ru = 'Не указан тип программы.'"), Истина);
		Возврат Неопределено;
	КонецЕсли;
	
	СвойстваПрограммы = Новый Структура("ИмяПрограммы, ПутьКПрограмме, ТипПрограммы");
	
	Если ЭтоLinux Тогда
		Если ПутиКПрограммамНаСерверахLinux = Неопределено Тогда
			ПерсональныеНастройки = ЭлектроннаяПодписьКлиентСервер.ПерсональныеНастройки();
			ПутьКПрограмме = ПерсональныеНастройки.ПутиКПрограммамЭлектроннойПодписиИШифрования.Получить(
				ОписаниеПрограммы.Ссылка);
		Иначе
			ПутьКПрограмме = ПутиКПрограммамНаСерверахLinux.Получить(ОписаниеПрограммы.Ссылка);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПутьКПрограмме) Тогда
			МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка,
				НСтр("ru = 'Не предусмотрена для использования.'"), ЭтоСервер, , , Истина);
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		ПутьКПрограмме = "";
	КонецЕсли;
	
	СвойстваПрограммы = Новый Структура;
	СвойстваПрограммы.Вставить("ИмяПрограммы",   ОписаниеПрограммы.ИмяПрограммы);
	СвойстваПрограммы.Вставить("ПутьКПрограмме", ПутьКПрограмме);
	СвойстваПрограммы.Вставить("ТипПрограммы",   ОписаниеПрограммы.ТипПрограммы);
	
	Возврат СвойстваПрограммы;
	
КонецФункции

// Только для внутреннего использования.
Функция МенеджерКриптографииАлгоритмыУстановлены(ОписаниеПрограммы, Менеджер, Ошибки) Экспорт
	
	АлгоритмПодписи = Строка(ОписаниеПрограммы.АлгоритмПодписи);
	Попытка
		Менеджер.АлгоритмПодписи = АлгоритмПодписи;
	Исключение
		Менеджер = Неопределено;
		// Платформа использует обобщенное сообщение "Неизвестный алгоритм криптографии". Требуется более конкретное.
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выбран неизвестный алгоритм подписи ""%1"".'"), АлгоритмПодписи), Истина);
		Возврат Ложь;
	КонецПопытки;
	
	АлгоритмХеширования = Строка(ОписаниеПрограммы.АлгоритмХеширования);
	Попытка
		Менеджер.АлгоритмХеширования = АлгоритмХеширования;
	Исключение
		Менеджер = Неопределено;
		// Платформа использует обобщенное сообщение "Неизвестный алгоритм криптографии". Требуется более конкретное.
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выбран неизвестный алгоритм хеширования ""%1"".'"), АлгоритмХеширования), Истина);
		Возврат Ложь;
	КонецПопытки;
	
	АлгоритмШифрования = Строка(ОписаниеПрограммы.АлгоритмШифрования);
	Попытка
		Менеджер.АлгоритмШифрования = АлгоритмШифрования;
	Исключение
		Менеджер = Неопределено;
		// Платформа использует обобщенное сообщение "Неизвестный алгоритм криптографии". Требуется более конкретное.
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выбран неизвестный алгоритм шифрования ""%1"".'"), АлгоритмШифрования), Истина);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

// Только для внутреннего использования.
Процедура МенеджерКриптографииПрограммаНеНайдена(ОписаниеПрограммы, Ошибки, ЭтоСервер) Экспорт
	
	МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка,
		НСтр("ru = 'Программа не найдена на компьютере.'"), ЭтоСервер, Истина);
	
КонецПроцедуры

// Только для внутреннего использования.
Функция МенеджерКриптографииИмяПрограммыСовпадает(ОписаниеПрограммы, ИмяПрограммыПолученное, Ошибки, ЭтоСервер) Экспорт
	
	Если ИмяПрограммыПолученное <> ОписаниеПрограммы.ИмяПрограммы Тогда
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Получена другая программа с именем ""%1"".'"), ИмяПрограммыПолученное), ЭтоСервер, Истина);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Только для внутреннего использования.
Процедура МенеджерКриптографииДобавитьОшибку(Ошибки, Программа, Описание,
			КАдминистратору, Инструкция = Ложь, ИзИсключения = Ложь, НеУказанПуть = Ложь) Экспорт
	
	СвойстваОшибки = Новый Структура;
	СвойстваОшибки.Вставить("Программа",         Программа);
	СвойстваОшибки.Вставить("Описание",          Описание);
	СвойстваОшибки.Вставить("КАдминистратору",   КАдминистратору);
	СвойстваОшибки.Вставить("Инструкция",        Инструкция);
	СвойстваОшибки.Вставить("ИзИсключения",      ИзИсключения);
	СвойстваОшибки.Вставить("НеУказанПуть",      НеУказанПуть);
	СвойстваОшибки.Вставить("НастройкаПрограмм", Истина);
	
	Ошибки.Добавить(СвойстваОшибки);
	
КонецПроцедуры

// Только для внутреннего использования.
Функция РежимыПроверкиСертификата(ИгнорироватьВремяДействия = Ложь) Экспорт
	
	МассивРежимовПроверки = Новый Массив;
	МассивРежимовПроверки.Добавить(РежимПроверкиСертификатаКриптографии.РазрешитьТестовыеСертификаты);
	
	Если ИгнорироватьВремяДействия Тогда
		МассивРежимовПроверки.Добавить(РежимПроверкиСертификатаКриптографии.ИгнорироватьВремяДействия);
	КонецЕсли;
	
	Возврат МассивРежимовПроверки;
	
КонецФункции

// Только для внутреннего использования.
Функция СертификатПросрочен(Сертификат, НаДату) Экспорт
	
	Если Не ЗначениеЗаполнено(НаДату) Тогда
		Возврат "";
	КонецЕсли;
	
	ДатыСертификата = ДатыСертификата(Сертификат);
	
	Если ДатыСертификата.ДатаОкончания > НачалоДня(НаДату) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'На %1 просрочен сертификат.'"), Формат(НачалоДня(НаДату), "ДЛФ=D"));
	
КонецФункции

// Только для внутреннего использования.
Функция ДатыСертификата(Сертификат) Экспорт
	
	#Если ВебКлиент Или ТонкийКлиент Тогда
		ДобавкаВремени = ОбщегоНазначенияКлиент.ДатаСеанса() - ОбщегоНазначенияКлиент.ДатаУниверсальная();
	#Иначе
		ДобавкаВремени = ТекущаяДатаСеанса() - ТекущаяУниверсальнаяДата();
	#КонецЕсли
	
	ДатыСертификата = Новый Структура;
	ДатыСертификата.Вставить("ДатаНачала",    Сертификат.ДатаНачала    + ДобавкаВремени);
	ДатыСертификата.Вставить("ДатаОкончания", Сертификат.ДатаОкончания + ДобавкаВремени);
	
	Возврат ДатыСертификата;
	
КонецФункции

// Только для внутреннего использования.
Функция ТипХранилищаДляПоискаСертификата(ТолькоВЛичномХранилище) Экспорт
	
	Если ТипЗнч(ТолькоВЛичномХранилище) = Тип("ТипХранилищаСертификатовКриптографии") Тогда
		ТипХранилища = ТолькоВЛичномХранилище;
	ИначеЕсли ТолькоВЛичномХранилище Тогда
		ТипХранилища = ТипХранилищаСертификатовКриптографии.ПерсональныеСертификаты;
	Иначе
		ТипХранилища = Неопределено; // Хранилище, содержащее сертификаты всех доступных типов.
	КонецЕсли;
	
	Возврат ТипХранилища;
	
КонецФункции

// Только для внутреннего использования.
Процедура ДобавитьСвойстваСертификатов(Таблица, МассивСертификатов, БезОтбора, ТолькоОтпечатки = Ложь, ВОблачномСервисе = Ложь) Экспорт
	
	#Если ВебКлиент Или ТонкийКлиент Тогда
		ТекущаяДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
	#Иначе
		ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	#КонецЕсли
	
	Если ТолькоОтпечатки Тогда
		ОтпечаткиУжеДобавленныхСертификатов = Таблица;
		НаСервере = Ложь;
	Иначе
		ОтпечаткиУжеДобавленныхСертификатов = Новый Соответствие; // Для пропуска дублей.
		НаСервере = ТипЗнч(Таблица) <> Тип("Массив");
	КонецЕсли;
	
	Для Каждого ТекущийСертификат Из МассивСертификатов Цикл
		Отпечаток = Base64Строка(ТекущийСертификат.Отпечаток);
		ДатыСертификата = ДатыСертификата(ТекущийСертификат);
		
		Если ДатыСертификата.ДатаОкончания <= ТекущаяДатаСеанса Тогда
			Если Не БезОтбора Тогда
				Продолжить; // Пропуск просроченных сертификатов.
			КонецЕсли;
		КонецЕсли;
		
		Если ОтпечаткиУжеДобавленныхСертификатов.Получить(Отпечаток) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ОтпечаткиУжеДобавленныхСертификатов.Вставить(Отпечаток, Истина);
		
		Если ТолькоОтпечатки Тогда
			Продолжить;
		КонецЕсли;
		
		Если НаСервере Тогда
			Строка = Таблица.Найти(Отпечаток, "Отпечаток");
			Если Строка <> Неопределено Тогда
				Если ВОблачномСервисе Тогда
					Строка.ВОблачномСервисе = Истина;
				КонецЕсли;
				Продолжить; // Пропуск уже добавленных на клиенте.
			КонецЕсли;
		КонецЕсли;
		
		СвойстваСертификата = Новый Структура;
		СвойстваСертификата.Вставить("Отпечаток", Отпечаток);
		
		СвойстваСертификата.Вставить("Представление",
			ЭлектроннаяПодписьКлиентСервер.ПредставлениеСертификата(ТекущийСертификат));
		
		СвойстваСертификата.Вставить("КемВыдан",
			ЭлектроннаяПодписьКлиентСервер.ПредставлениеИздателя(ТекущийСертификат));
		
		Если ТипЗнч(Таблица) = Тип("Массив") Тогда
			Таблица.Добавить(СвойстваСертификата);
		Иначе
			Если ВОблачномСервисе Тогда
				СвойстваСертификата.Вставить("ВОблачномСервисе", Истина);
			ИначеЕсли НаСервере Тогда
				СвойстваСертификата.Вставить("НаСервере", Истина);
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(Таблица.Добавить(), СвойстваСертификата);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ДобавитьОтпечаткиСертификатов(Массив, МассивСертификатов) Экспорт
	
	#Если ВебКлиент Или ТонкийКлиент Тогда
		ТекущаяДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
	#Иначе
		ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	#КонецЕсли
	
	Для Каждого ТекущийСертификат Из МассивСертификатов Цикл
		Отпечаток = Base64Строка(ТекущийСертификат.Отпечаток);
		ДатыСертификата = ДатыСертификата(ТекущийСертификат);
		
		Если ДатыСертификата.ДатаОкончания <= ТекущаяДатаСеанса Тогда
			Продолжить; // Пропуск просроченных сертификатов.
		КонецЕсли;
		
		Массив.Добавить(Отпечаток);
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
Функция СвойстваПодписи(ДвоичныеДанныеПодписи, СвойстваСертификата, Комментарий, ИмяФайлаПодписи = "") Экспорт
	
	СвойстваПодписи = Новый Структура;
	СвойстваПодписи.Вставить("Подпись",             ДвоичныеДанныеПодписи);
	СвойстваПодписи.Вставить("УстановившийПодпись", ПользователиКлиентСервер.АвторизованныйПользователь());
	СвойстваПодписи.Вставить("Комментарий",         Комментарий);
	СвойстваПодписи.Вставить("ИмяФайлаПодписи",     ИмяФайлаПодписи);
	СвойстваПодписи.Вставить("ДатаПодписи",         Дата('00010101')); // Устанавливается перед записью.
	СвойстваПодписи.Вставить("ДатаПроверкиПодписи", Дата('00010101')); // Дата последней проверки подписи.
	СвойстваПодписи.Вставить("ПодписьВерна",        Ложь);             // Результат последней проверки подписи.
	// Производные свойства:
	СвойстваПодписи.Вставить("Сертификат",          СвойстваСертификата.ДвоичныеДанные);
	СвойстваПодписи.Вставить("Отпечаток",           СвойстваСертификата.Отпечаток);
	СвойстваПодписи.Вставить("КомуВыданСертификат", СвойстваСертификата.КомуВыдан);
	
	Возврат СвойстваПодписи;
	
КонецФункции

// Только для внутреннего использования.
Функция ЗаголовокОшибкиПолученияДанных(Операция) Экспорт
	
	Если Операция = "Подписание" Тогда
		Возврат НСтр("ru = 'При получении данных для подписания возникла ошибка:'");
		
	ИначеЕсли Операция = "Шифрование" Тогда
		Возврат НСтр("ru = 'При получении данных для шифрования возникла ошибка:'");
	Иначе
		Возврат НСтр("ru = 'При получении данных для расшифровки возникла ошибка:'");
	КонецЕсли;
	
КонецФункции

// Только для внутреннего использования.
Функция ПустыеДанныеПодписи(ДанныеПодписи, ОписаниеОшибки) Экспорт
	
	Если Не ЗначениеЗаполнено(ДанныеПодписи) Тогда
		ОписаниеОшибки = НСтр("ru = 'Сформирована пустая подпись.'");
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Только для внутреннего использования.
Функция ПустыеЗашифрованныеДанные(ЗашифрованныеДанные, ОписаниеОшибки) Экспорт
	
	Если Не ЗначениеЗаполнено(ЗашифрованныеДанные) Тогда
		ОписаниеОшибки = НСтр("ru = 'Сформированы пустые данные.'");
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Только для внутреннего использования.
Функция ПустыеРасшифрованныеДанные(РасшифрованныеДанные, ОписаниеОшибки) Экспорт
	
	Если Не ЗначениеЗаполнено(РасшифрованныеДанные) Тогда
		ОписаниеОшибки = НСтр("ru = 'Сформированы пустые данные.'");
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Только для внутреннего использования.
Функция ДатаПодписанияУниверсальная(БуферДвоичныхДанныхПодписи) Экспорт
	
	ДатаПодписания = Неопределено;
	
	Позиция = 0;
	Для Каждого Байт Из БуферДвоичныхДанныхПодписи Цикл
		Если Байт = 15 И ЭтоЗаголовокДаты(БуферДвоичныхДанныхПодписи, Позиция) Тогда
			ДатаСтрокой = ДатаСтрокой(БуферДвоичныхДанныхПодписи, Позиция);
			Если ЭтоЦифры(ДатаСтрокой) Тогда
				Попытка
					ДатаПодписания = Дата("20" + ДатаСтрокой); // Универсальное время.
					Прервать;
				Исключение
					ДатаПодписания = Неопределено;
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;
		Позиция = Позиция + 1;
	КонецЦикла;
	
	Возврат ДатаПодписания;
	
КонецФункции

// Находит в XML содержимое находящееся в теге.
//
// Параметры:
//  Текст                             - Строка - текст XML, в котором выполняется поиск.
//  ИмяТега                           - Строка - тег, содержимое которого необходимо найти.
//  ВключатьОткрывающийЗакрывающийТег - Булево - признак необходимости найденного тегом,
//                                               по которому выполнялся поиск, по умолчанию Ложь.
//  НомерПоПорядку                    - Число  - позиция, с которой начинается поиск, по умолчанию 1.
// 
// Возвращаемое значение:
//   Строка - строка, из которой удалены символы перевода строки и возврата каретки.
//
Функция НайтиВXML(Текст, ИмяТега, ВключатьОткрывающийЗакрывающийТег = Ложь, НомерПоПорядку = 1) Экспорт
	
	Результат = Неопределено;
	
	Начало    = "<"  + ИмяТега;
	Окончание = "</" + ИмяТега + ">";
	
	Содержимое = Сред(
		Текст,
		СтрНайти(Текст, Начало, НаправлениеПоиска.СНачала, 1, НомерПоПорядку),
		СтрНайти(Текст, Окончание, НаправлениеПоиска.СНачала, 1, НомерПоПорядку) + СтрДлина(Окончание) - СтрНайти(Текст, Начало, НаправлениеПоиска.СНачала, 1, НомерПоПорядку));
		
	Если ВключатьОткрывающийЗакрывающийТег Тогда
		
		Результат = СокрЛП(Содержимое);
		
	Иначе
		
		ОткрывающийТег = Лев(Содержимое, СтрНайти(Содержимое, ">"));
		Содержимое = СтрЗаменить(Содержимое, ОткрывающийТег, "");
		
		ЗакрывающийТег = Прав(Содержимое, СтрДлина(Содержимое) - СтрНайти(Содержимое, "<", НаправлениеПоиска.СКонца) + 1);
		Содержимое = СтрЗаменить(Содержимое, ЗакрывающийТег, "");
		
		Результат = СокрЛП(Содержимое);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Преобразует сертификат криптографии в корректно отформатированную строку в формате Base64.
//
// Параметры:
//  ДанныеСертификата - ДвоичныеДанные - данные сертификата, которые подлежат преобразованию.
// 
// Возвращаемое значение:
//  Строка - преобразованный в строку в формате Base64 сертификат.
//
Функция СертификатКриптографииBase64(ДанныеСертификата) Экспорт
	
	СтрокаBase64 = Base64Строка(ДанныеСертификата);
	
	Значение = СтрЗаменить(СтрокаBase64, Символы.ВК, "");
	Значение = СтрЗаменить(Значение, Символы.ПС, "");
	
	Возврат Значение;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

// Для функции ПолучитьСоответствиеФайловИПодписей.
Функция НайтиИменаФайловПодписей(ИмяФайлаДанных, ИменаФайловПодписей)
	
	ИменаПодписей = Новый Массив;
	
	СтруктураИмени = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайлаДанных);
	ИмяБезРасширения = СтруктураИмени.ИмяБезРасширения;
	
	Для Каждого ИмяФайлаПодписи Из ИменаФайловПодписей Цикл
		Если СтрНайти(ИмяФайлаПодписи, ИмяБезРасширения) > 0 Тогда
			ИменаПодписей.Добавить(ИмяФайлаПодписи);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ИмяФайлаПодписи Из ИменаПодписей Цикл
		ИменаФайловПодписей.Удалить(ИменаФайловПодписей.Найти(ИмяФайлаПодписи));
	КонецЦикла;
	
	Возврат ИменаПодписей;
	
КонецФункции

// Для процедуры ДатаПодписанияУниверсальная.
Функция ЭтоЦифры(Строка)
	
	Для НомерСимвола = 1 По СтрДлина(Строка) Цикл
		ТекущийСимвол = Сред(Строка, НомерСимвола, 1);
		Если ТекущийСимвол < "0" Или ТекущийСимвол > "9" Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Для процедуры ДатаПодписанияУниверсальная.
Функция ЭтоЗаголовокДаты(БуферДвоичныхДанных, Позиция)
	
	Если БуферДвоичныхДанных.Размер - Позиция < 3 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	БуферЗаголовка = БуферДвоичныхДанных.Прочитать(Позиция, 3);
	
	Если БуферЗаголовка.Размер = 3
	   И БуферЗаголовка[1] = 23
	   И БуферЗаголовка[2] = 13 Тогда
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Для процедуры ДатаПодписанияУниверсальная.
Функция ДатаСтрокой(БуферДвоичныхДанных, Позиция)
	
	ПредставлениеДаты = "";
	
	Если БуферДвоичныхДанных.Размер - (Позиция + 3) < 12 Тогда
		Возврат ПредставлениеДаты;
	КонецЕсли;
	
	БуферДаты = БуферДвоичныхДанных.Прочитать(Позиция + 3, 12);
	
	Для Каждого Байт Из БуферДаты Цикл
		ПредставлениеДаты = ПредставлениеДаты + Символ(Байт);
	КонецЦикла;
	
	Возврат ПредставлениеДаты;
	
КонецФункции

#КонецОбласти
