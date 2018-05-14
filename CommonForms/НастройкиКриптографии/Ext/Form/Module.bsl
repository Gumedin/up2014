﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ПоказыватьНастройкиШифрования") И Параметры.ПоказыватьНастройкиШифрования = Ложь Тогда
		Элементы.АлгоритмШифрования.Видимость = Ложь;
	КонецЕсли;
	
	ЭтоПодчиненныйУзел = ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ();
	
	Если ЭтоПодчиненныйУзел Тогда // мы в не главном узле
		Элементы.ПровайдерЭП.ТолькоПросмотр = Истина;
		Элементы.ТипПровайдераЭП.ТолькоПросмотр = Истина;
		Элементы.АлгоритмПодписи.ТолькоПросмотр = Истина;
		Элементы.АлгоритмХеширования.ТолькоПросмотр = Истина;
		Элементы.АлгоритмШифрования.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	РазделенныйРежим = ОбщегоНазначенияПовтИсп.РазделениеВключено();
	
	Если РазделенныйРежим Тогда
		Элементы.ВыполнятьПроверкуЭПНаСервере.Видимость = Ложь;
		Элементы.ПутиМодулейКриптографииСерверовLinux.Видимость = Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПутиМодулейКриптографииСерверовLinux.ИмяКомпьютера,
	|	ПутиМодулейКриптографииСерверовLinux.ПутьМодуляКриптографии,
	|	ПутиМодулейКриптографииСерверовLinux.Комментарий
	|ИЗ
	|	РегистрСведений.ПутиМодулейКриптографииСерверовLinux КАК ПутиМодулейКриптографииСерверовLinux";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Строка = ПутиМодулейКриптографииСерверовLinux.Добавить();
		
		Строка.ИмяКомпьютера = Выборка.ИмяКомпьютера;
		Строка.ПутьМодуляКриптографии = Выборка.ПутьМодуляКриптографии;
		Строка.Комментарий = Выборка.Комментарий;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПодключитьРасширениеРаботыСКриптографией() Тогда
		
		ДействияПриОткрытии();
		
	Иначе
		
		Отказ = Истина;
		Обработчик = Новый ОписаниеОповещения("ОткрытьФормуПослеУстановкиРасширения", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Для настройки ЭП необходимо установить
		|расширение работы с криптографией.'");
		ЭлектроннаяПодписьКлиент.УстановитьРасширение(Обработчик, ТекстВопроса);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если ЗначениеЗаполнено(ПровайдерЭП) И НЕ СпискиАлгоритмовУспешноЗаполнены Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не удалось подключить провайдера ЭП.
			|Укажите Провайдера и его Тип согласно инструкции фирмы-производителя криптопровайдера.'"),
			,
			"ТипПровайдераЭП");
	КонецЕсли;
	
	ИсключаемыеРеквизиты = Новый Массив;
	
	Если НЕ ЗначениеЗаполнено(ПровайдерЭП) ИЛИ ЭтоПодчиненныйУзел Тогда
		
		ИсключаемыеРеквизиты.Добавить("АлгоритмПодписи");
		ИсключаемыеРеквизиты.Добавить("АлгоритмХеширования");
		ИсключаемыеРеквизиты.Добавить("АлгоритмШифрования");
		
	ИначеЕсли НЕ Элементы.АлгоритмШифрования.Видимость Тогда
		
		ИсключаемыеРеквизиты.Добавить("АлгоритмШифрования");
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыполнятьПроверкуЭПНаСервереПриИзменении(Элемент)
	
	Элементы.ПутиМодулейКриптографииСерверовLinux.Доступность = ВыполнятьПроверкуЭПНаСервере;
	Элементы.ПутиМодулейКриптографииСерверовLinuxКоманднаяПанель.Доступность = ВыполнятьПроверкуЭПНаСервере;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПровайдераЭППриИзменении(Элемент)
	
	ЗаполнитьСпискиВыбораНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровайдерЭППриИзменении(Элемент)
	
	ЗаполнитьСпискиВыбораНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровайдерЭПОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ВыбранноеЗначение = ">>" Тогда
		СтандартнаяОбработка = Ложь;
		Обработчик = Новый ОписаниеОповещения("ПровайдерЭПОбработкаВыбораЗавершение", ЭтотОбъект);
		ПоказатьВводСтроки(Обработчик, ПровайдерЭП, НСтр("ru = 'Имя провайдера электронной подписи'"));
	Иначе
		Длина = СтрДлина(ВыбранноеЗначение);
		Для Номер = 1 По Длина Цикл
			ПозицияСлеша = Длина - Номер + 1;
			Если КодСимвола(ВыбранноеЗначение, ПозицияСлеша) = 47 Тогда // "/".
				ТипПровайдераЭП = Число(Сред(ВыбранноеЗначение, ПозицияСлеша + 1));
				ВыбранноеЗначение = Лев(ВыбранноеЗначение, ПозицияСлеша - 1);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыполнятьПроверкуЭПНаСервере И Не РазделенныйРежим Тогда
		// Запрос профиля безопасности
		РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(
			ЗапросРазрешенийБезопасности(), 
			ЭтотОбъект, 
			Новый ОписаниеОповещения("ПолученыРазрешенияБезопасности", ЭтотОбъект)
		);
		Возврат;
	КонецЕсли;
	
	ПолученыРазрешенияБезопасности(КодВозвратаДиалога.ОК, Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПолученыРазрешенияБезопасности(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	Если Результат <> КодВозвратаДиалога.ОК Тогда
		// Отказ в профилях безопасности
		Возврат;
	КонецЕсли;
	
	СохранитьПараметры();
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗапросРазрешенийБезопасности()
	
	Разрешения = Новый Массив;
	Для Каждого СтрокаПути Из ПутиМодулейКриптографииСерверовLinux Цикл
		Файл = Новый Файл(СтрокаПути.ПутьМодуляКриптографии);
		
		Разрешения.Добавить( 
			РаботаВБезопасномРежиме.РазрешениеНаИспользованиеКаталогаФайловойСистемы(Файл.Путь, Истина, Ложь,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Доступ к внешнему модулю криптографии на компьютере (%1)'"), СтрокаПути.ИмяКомпьютера
		)));
		
	КонецЦикла;
	
	ВладелецРазрешения = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Константа.ИспользоватьЭлектронныеПодписи"); 
	
	Результат = Новый Массив;
	Результат.Добавить(
		РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(Разрешения, ВладелецРазрешения, Истина)
	);
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ДействияПриОткрытии()
	
	ЗаполнитьЗначенияСвойств(
		ЭтотОбъект,
		ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки(),
		"ПровайдерЭП,
		|ТипПровайдераЭП,
		|АлгоритмПодписи,
		|АлгоритмХеширования,
		|АлгоритмШифрования,
		|ВыполнятьПроверкуЭПНаСервере");
	
	Элементы.ПутиМодулейКриптографииСерверовLinux.Доступность                = ВыполнятьПроверкуЭПНаСервере;
	Элементы.ПутиМодулейКриптографииСерверовLinuxКоманднаяПанель.Доступность = ВыполнятьПроверкуЭПНаСервере;
	
	Если ТипПровайдераЭП = 0 Тогда
		ТипПровайдераЭП = 75;
	КонецЕсли;
	
	ДобавитьМенеджераКриптографииВСписок("Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider", "", 75);
	ДобавитьМенеджераКриптографииВСписок("Signal-COM CPGOST Cryptographic Provider", "", 75);
	ДобавитьМенеджераКриптографииВСписок("Infotecs Cryptographic Service Provider", "", 2);
	ДобавитьМенеджераКриптографииВСписок("Microsoft Enhanced Cryptographic Provider v1.0", "", 1);
	ДобавитьМенеджераКриптографииВСписок("Microsoft Strong Cryptographic Provider", "", 1);
	ДобавитьМенеджераКриптографииВСписок("", "", 75);
	Элементы.ПровайдерЭП.СписокВыбора.Добавить(">>", НСтр("ru = 'Ввести вручную'"));
	
	Если Элементы.ПровайдерЭП.СписокВыбора.Количество() = 0 Тогда
		Элементы.ПровайдерЭП.КнопкаВыпадающегоСписка = Ложь;
		Элементы.ПровайдерЭП.КнопкаОчистки = Ложь;
	КонецЕсли;
	
	ЗаполнитьСпискиВыбораНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСпискиВыбораНаКлиенте()
	
	ОчиститьСообщения();
	
	Элементы.АлгоритмПодписи.СписокВыбора.Очистить();
	Элементы.АлгоритмХеширования.СписокВыбора.Очистить();
	Элементы.АлгоритмШифрования.СписокВыбора.Очистить();
	
	Если ЗначениеЗаполнено(ПровайдерЭП) Тогда
		ИнформацияМенеджера = СкомпоноватьИнформациюМенеджераКриптографии(ПровайдерЭП, Неопределено, ТипПровайдераЭП);
	Иначе
		ИнформацияМенеджера = Неопределено;
	КонецЕсли;
	
	Если ИнформацияМенеджера = Неопределено Тогда
		
		СпискиАлгоритмовУспешноЗаполнены = Ложь;
		
	Иначе
		
		СпискиАлгоритмовУспешноЗаполнены = Истина;
		
		АлгоритмПодписиНайден = Ложь;
		АлгоритмХешированияНайден = Ложь;
		АлгоритмШифрованияНайден = Ложь;
		
		Для Каждого Строка Из ИнформацияМенеджера.АлгоритмыПодписи Цикл
			Элементы.АлгоритмПодписи.СписокВыбора.Добавить(Строка);
			Если АлгоритмПодписи = Строка Тогда
				АлгоритмПодписиНайден = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Строка Из ИнформацияМенеджера.АлгоритмыХеширования Цикл
			Элементы.АлгоритмХеширования.СписокВыбора.Добавить(Строка);
			Если АлгоритмХеширования = Строка Тогда
				АлгоритмХешированияНайден = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Строка Из ИнформацияМенеджера.АлгоритмыШифрования Цикл
			Элементы.АлгоритмШифрования.СписокВыбора.Добавить(Строка);
			Если АлгоритмШифрования = Строка Тогда
				АлгоритмШифрованияНайден = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ АлгоритмПодписиНайден Тогда
			АлгоритмПодписи = "";
		КонецЕсли;
			
		Если НЕ АлгоритмХешированияНайден Тогда
			АлгоритмХеширования = "";
		КонецЕсли;
		
		Если НЕ АлгоритмШифрованияНайден Тогда
			АлгоритмШифрования = "";
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.АлгоритмПодписи.Доступность     = СпискиАлгоритмовУспешноЗаполнены;
	Элементы.АлгоритмХеширования.Доступность = СпискиАлгоритмовУспешноЗаполнены;
	Элементы.АлгоритмШифрования.Доступность  = СпискиАлгоритмовУспешноЗаполнены;
	
КонецПроцедуры

&НаКлиенте
Функция СкомпоноватьИнформациюМенеджераКриптографии(ИмяМодуляКриптографии, ПутьМодуляКриптографии, ТипМодуляКриптографии,
	СообщатьОшибки = Истина)
	
	Если ПутьМодуляКриптографии = Неопределено Тогда
		ПутьМодуляКриптографии = ЭлектроннаяПодписьКлиентСервер.ПерсональныеНастройки().ПутьМодуляКриптографии;
	КонецЕсли;
	
	ИнформацияМенеджера = Неопределено;
	
	Попытка
		
		МенеджерКриптографии = Новый МенеджерКриптографии(ИмяМодуляКриптографии, ПутьМодуляКриптографии, ТипМодуляКриптографии);
		ИнформацияМенеджера = МенеджерКриптографии.ПолучитьИнформациюМодуляКриптографии();
		
	Исключение
		
		Если СообщатьОшибки Тогда
			ПредставлениеОшибки = СокрЛП(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Если Прав(ПредставлениеОшибки, 1) <> "." Тогда
				ПредставлениеОшибки = ПредставлениеОшибки + ".";
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось подключить провайдера ЭП: %1
					|Укажите Провайдера и его Тип согласно инструкции фирмы-производителя криптопровайдера.'"),
					ПредставлениеОшибки
				),
				,
				"ТипПровайдераЭП");
		КонецЕсли;
		
	КонецПопытки;
	
	Если ИнформацияМенеджера <> Неопределено Тогда
		
		ЗначениеСпискаВыбора = ИнформацияМенеджера.Имя + "/" + ТипМодуляКриптографии;
		
		Если Элементы.ПровайдерЭП.СписокВыбора.НайтиПоЗначению(ЗначениеСпискаВыбора) = Неопределено Тогда
			Элементы.ПровайдерЭП.СписокВыбора.Добавить(ЗначениеСпискаВыбора, ИнформацияМенеджера.Имя);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ИнформацияМенеджера;
КонецФункции

&НаКлиенте
Процедура ДобавитьМенеджераКриптографииВСписок(ИмяМодуляКриптографии, ПутьМодуляКриптографии, ТипМодуляКриптографии)
	
	ИнформацияМенеджера = СкомпоноватьИнформациюМенеджераКриптографии(
		ИмяМодуляКриптографии,
		ПутьМодуляКриптографии,
		ТипМодуляКриптографии,
		Ложь);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьПараметры()
	
	Константы.ПровайдерЭП.Установить(ПровайдерЭП);
	Константы.ТипПровайдераЭП.Установить(ТипПровайдераЭП);
	Константы.АлгоритмХеширования.Установить(АлгоритмХеширования);
	Константы.АлгоритмПодписи.Установить(АлгоритмПодписи);
	Константы.АлгоритмШифрования.Установить(АлгоритмШифрования);
	Константы.ВыполнятьПроверкуЭПНаСервере.Установить(ВыполнятьПроверкуЭПНаСервере);
	
	Для Каждого Строка Из ПутиМодулейКриптографииСерверовLinux Цикл
		НаборЗаписей = РегистрыСведений.ПутиМодулейКриптографииСерверовLinux.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.ИмяКомпьютера.Установить(Строка.ИмяКомпьютера);
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.ИмяКомпьютера = Строка.ИмяКомпьютера;
		НоваяЗапись.ПутьМодуляКриптографии = Строка.ПутьМодуляКриптографии;
		НоваяЗапись.Комментарий = Строка.Комментарий;
		
		НаборЗаписей.Записать();
	КонецЦикла;
	
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Служебные обработчики асинхронных диалогов

&НаКлиенте
Процедура ОткрытьФормуПослеУстановкиРасширения(РасширениеУстановлено, ДополнительныеПараметры) Экспорт
	Если РасширениеУстановлено = Истина Тогда
		Если Не Открыта() Тогда
			Открыть();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПровайдерЭПОбработкаВыбораЗавершение(ВведеннаяСтрока, ПараметрыВыполнения) Экспорт
	Если ВведеннаяСтрока <> Неопределено Тогда
		ПровайдерЭП = ВведеннаяСтрока;
		ЗаполнитьСпискиВыбораНаКлиенте();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
