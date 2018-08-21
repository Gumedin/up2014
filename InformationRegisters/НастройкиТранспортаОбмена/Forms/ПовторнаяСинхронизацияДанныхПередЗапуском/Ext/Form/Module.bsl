﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УзелИнформационнойБазы = ОбменДаннымиСервер.ГлавныйУзел();
	ЭтоАвтономноеРабочееМесто = ОбменДаннымиСервер.ЭтоАвтономноеРабочееМесто();
	
	Если ЭтоАвтономноеРабочееМесто Тогда
		Элементы.СтраницыПараметрыПодключения.ТекущаяСтраница = Элементы.СтраницаАРМ;
		МодульАвтономнаяРабота = ОбщегоНазначения.ОбщийМодуль("АвтономнаяРабота");
		АдресДляВосстановленияПароляУчетнойЗаписи = МодульАвтономнаяРабота.АдресДляВосстановленияПароляУчетнойЗаписи();
		ДлительнаяОперацияРазрешена = Истина;
		
		Если ОбменДаннымиСервер.ПарольСинхронизацииДанныхЗадан(УзелИнформационнойБазы) Тогда
			Пароль = ОбменДаннымиСервер.ПарольСинхронизацииДанных(УзелИнформационнойБазы);
		КонецЕсли;
		
	КонецЕсли;
	
	НадписьИмяУзла = НСтр("ru = 'Не удалось установить обновление программы, полученное из
		|""%1"".
		|Техническую информацию см. в <a href = ""ЖурналРегистрации"">Журнале регистрации</a>.'");
	НадписьИмяУзла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НадписьИмяУзла, УзелИнформационнойБазы.Наименование);
	Элементы.ИнформационнаяНадписьИмяУзла.Заголовок = СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(НадписьИмяУзла);
	
	УстановитьОтображениеЭлементовФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнформационнаяНадписьИмяУзлаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыФормы,,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СинхронизироватьИПродолжить(Команда)
	
	ТекстПредупреждения = "";
	ЕстьОшибки = Ложь;
	ДлительнаяОперация = Ложь;
	
	ПроверитьНеобходимостьОбновления();
	
	Если СтатусОбновления = "ОбновлениеНеТребуется" Тогда
		
		СинхронизироватьИПродолжитьБезОбновленияИБ();
		
	ИначеЕсли СтатусОбновления = "ОбновлениеИнформационнойБазы" Тогда
		
		СинхронизироватьИПродолжитьСОбновлениемИБ();
		
	ИначеЕсли СтатусОбновления = "ОбновлениеКонфигурации" Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Из главного узла получены изменения, которые еще не применены.
			|Требуется открыть конфигуратор и обновить конфигурацию базы данных.'");
		
	КонецЕсли;
	
	Если Не ДлительнаяОперация Тогда
		
		СинхронизироватьИПродолжитьЗавершение();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеСинхронизироватьИПродолжить(Команда)
	
	НеСинхронизироватьИПродолжитьНаСервере();
	
	Закрыть("Продолжить");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПодключения(Команда)
	
	Отбор              = Новый Структура("Узел", УзелИнформационнойБазы);
	ЗначенияЗаполнения = Новый Структура("Узел", УзелИнформационнойБазы);
	
	ОбменДаннымиКлиент.ОткрытьФормуЗаписиРегистраСведенийПоОтбору(Отбор,
		ЗначенияЗаполнения, "НастройкиТранспортаОбмена", Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗабылиПароль(Команда)
	ОбменДаннымиКлиент.ОткрытьИнструкциюКакИзменитьПарольСинхронизацииДанных(АдресДляВосстановленияПароляУчетнойЗаписи);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Сценарий без обновления информационной базы.

&НаКлиенте
Процедура СинхронизироватьИПродолжитьБезОбновленияИБ()
	
	ЗагрузитьСообщениеОбменаДаннымиБезОбновления();
	
	Если ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
		
	Иначе
		
		СинхронизироватьИПродолжитьБезОбновленияИБЗавершение();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СинхронизироватьИПродолжитьБезОбновленияИБЗавершение()
	
	// Режим повтора требует включения в следующих случаях.
	// Случай 1. Получены метаданные с новой версией конфигурации, т.е. будет выполнено обновление ИБ.
	// Е если Отказ = Истина, тогда недопустимо продолжение, т.к. могут быть созданы дубли генерируемых данных,
	// - если Отказ = Ложь, тогда возможна ошибка при обновлении ИБ, возможно требующая повторной загрузки сообщения.
	// Случай 2. Получены метаданные с той же версией конфигурации, т.е. не будет выполнено обновление ИБ.
	// Е если Отказ = Истина, тогда возможна ошибка при продолжении запуска, например, из-за того, что
	//   не были загружены предопределенные элементы,
	// - если Отказ = Ложь, тогда продолжение возможно, т.к. выгрузку можно сделать позднее (если же
	//   выгрузка не выполняется успешно, тогда позднее можно получить и новое сообщение для загрузки).
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЕстьОшибки Тогда
		
		ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском("ЗагрузкаРазрешена", Ложь);
		
		// Если сообщение загружено успешно, тогда повторная загрузка более не требуется.
		Если Константы.ЗагрузитьСообщениеОбменаДанными.Получить() Тогда
			Константы.ЗагрузитьСообщениеОбменаДанными.Установить(Ложь);
		КонецЕсли;
		Константы.ПовторитьЗагрузкуСообщенияОбменаДаннымиПередЗапуском.Установить(Ложь);
		
		Попытка
			ВыгрузитьСообщениеПослеОбновленияИнформационнойБазы();
		Исключение
			// Если выгрузка не удалась все равно можно продолжить запуск и
			// сделать выгрузку в режиме 1С:Предприятия.
			КлючСообщенияЖурналаРегистрации = ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными();
			ЗаписьЖурналаРегистрации(КлючСообщенияЖурналаРегистрации,
				УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	ИначеЕсли КонфигурацияИзменена() Тогда
		Если НЕ Константы.ЗагрузитьСообщениеОбменаДанными.Получить() Тогда
			Константы.ЗагрузитьСообщениеОбменаДанными.Установить(Истина);
		КонецЕсли;
		ТекстПредупреждения = НСтр("ru = 'Из главного узла получены изменения, которые нужно применить.
			|Требуется открыть конфигуратор и обновить конфигурацию базы данных.'");
	Иначе
		
		Если ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
			ВключитьПовторениеЗагрузкиСообщенияОбменаДаннымиПередЗапуском();
		КонецЕсли;
		
		ТекстПредупреждения = НСтр("ru = 'Получение данных из главного узла завершилось с ошибками.
			|Подробности см. в журнале регистрации.'");
		
		ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском("ЗагрузкаРазрешена", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьСообщениеПослеОбновленияИнформационнойБазы()
	
	// После успешной загрузки и обновления ИБ режим повтора можно отключить.
	ОбменДаннымиСервер.ОтключитьПовторениеЗагрузкиСообщенияОбменаДаннымиПередЗапуском();
	
	Попытка
		Если ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюДанных") Тогда
			
			УзелИнформационнойБазы = ОбменДаннымиСервер.ГлавныйУзел();
			
			Если УзелИнформационнойБазы <> Неопределено Тогда
				
				ВыполнитьВыгрузку = Истина;
				
				НастройкиТранспорта = РегистрыСведений.НастройкиТранспортаОбмена.НастройкиТранспорта(УзелИнформационнойБазы);
				
				ВидТранспорта = НастройкиТранспорта.ВидТранспортаСообщенийОбменаПоУмолчанию;
				
				Если ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.WS
					И Не НастройкиТранспорта.WSЗапомнитьПароль Тогда
					
					ВыполнитьВыгрузку = Ложь;
					
					РегистрыСведений.ОбщиеНастройкиУзловИнформационныхБаз.УстановитьПризнакОтправкиДанных(УзелИнформационнойБазы);
					
				КонецЕсли;
				
				Если ВыполнитьВыгрузку Тогда
					
					ПараметрыАутентификации = ?(ЭтоАвтономноеРабочееМесто, Новый Структура("ИспользоватьТекущегоПользователя, Пароль", Истина, Пароль), Неопределено);
					
					// Только выгрузка.
					Отказ = Ложь;
					
					ПараметрыОбмена = ОбменДаннымиСервер.ПараметрыОбмена();
					ПараметрыОбмена.ВидТранспортаСообщенийОбмена = ВидТранспорта;
					ПараметрыОбмена.ВыполнятьЗагрузку = Ложь;
					ПараметрыОбмена.ВыполнятьВыгрузку = Истина;
					ПараметрыОбмена.ПараметрыАутентификации = ПараметрыАутентификации;
					
					ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(УзелИнформационнойБазы, ПараметрыОбмена, Отказ);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСообщениеОбменаДаннымиБезОбновления()
	
	Попытка
		ЗагрузитьСообщениеПередОбновлениемИнформационнойБазы();
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЕстьОшибки = Истина;
	КонецПопытки;
	
	УстановитьОтображениеЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСообщениеПередОбновлениемИнформационнойБазы()
	
	Если ОбменДаннымиВызовСервера.РежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
			"ПропуститьЗагрузкуСообщенияОбменаДаннымиПередЗапуском") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюДанных") Тогда
		
		Если УзелИнформационнойБазы <> Неопределено Тогда
			
			УстановитьПривилегированныйРежим(Истина);
			ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском("ЗагрузкаРазрешена", Истина);
			УстановитьПривилегированныйРежим(Ложь);
			
			// Обновление правил регистрации объектов выполняем до загрузки данных.
			ОбменДаннымиСервер.ВыполнитьОбновлениеПравилДляОбменаДанными();
			
			ВидТранспорта = РегистрыСведений.НастройкиТранспортаОбмена.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелИнформационнойБазы);
			
			ДатаНачалаОперации = ТекущаяДатаСеанса();
			
			ПараметрыАутентификации = ?(ЭтоАвтономноеРабочееМесто, Новый Структура("ИспользоватьТекущегоПользователя, Пароль", Истина, Пароль), Неопределено);
			
			// Только загрузка.
			ПараметрыОбмена = ОбменДаннымиСервер.ПараметрыОбмена();
			ПараметрыОбмена.ВидТранспортаСообщенийОбмена = ВидТранспорта;
			ПараметрыОбмена.ВыполнятьЗагрузку = Истина;
			ПараметрыОбмена.ВыполнятьВыгрузку = Ложь;
			
			ПараметрыОбмена.ДлительнаяОперацияРазрешена = ДлительнаяОперацияРазрешена;
			ПараметрыОбмена.ДлительнаяОперация          = ДлительнаяОперация;
			ПараметрыОбмена.ИдентификаторОперации       = ИдентификаторОперации;
			ПараметрыОбмена.ИдентификаторФайла          = ИдентификаторФайла;
			ПараметрыОбмена.ПараметрыАутентификации     = ПараметрыАутентификации;
			
			ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(УзелИнформационнойБазы, ПараметрыОбмена, ЕстьОшибки);
			
			ДлительнаяОперацияРазрешена = ПараметрыОбмена.ДлительнаяОперацияРазрешена;
			ДлительнаяОперация          = ПараметрыОбмена.ДлительнаяОперация;
			ИдентификаторОперации       = ПараметрыОбмена.ИдентификаторОперации;
			ИдентификаторФайла          = ПараметрыОбмена.ИдентификаторФайла;
			ПараметрыАутентификации     = ПараметрыОбмена.ПараметрыАутентификации;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сценарий с обновлением информационной базы.

&НаКлиенте
Процедура СинхронизироватьИПродолжитьСОбновлениемИБ()
	
	ЗагрузитьСообщениеОбменаДаннымиСОбновлением();
	
	Если ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
		
	Иначе
		
		СинхронизироватьИПродолжитьСОбновлениемИБЗавершение();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СинхронизироватьИПродолжитьСОбновлениемИБЗавершение()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЕстьОшибки Тогда
		
		ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском("ЗагрузкаРазрешена", Ложь);
		
		Если НЕ Константы.ЗагрузитьСообщениеОбменаДанными.Получить() Тогда
			Константы.ЗагрузитьСообщениеОбменаДанными.Установить(Истина);
		КонецЕсли;
		
		ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
			"ПропуститьЗагрузкуПриоритетныхДанныхПередЗапуском", Истина);
		
	ИначеЕсли КонфигурацияИзменена() Тогда
			
		Если НЕ Константы.ЗагрузитьСообщениеОбменаДанными.Получить() Тогда
			Константы.ЗагрузитьСообщениеОбменаДанными.Установить(Истина);
		КонецЕсли;
		ТекстПредупреждения = НСтр("ru = 'Из главного узла получены изменения, которые нужно применить.
			|Требуется открыть конфигуратор и обновить конфигурацию базы данных.'");
		
	Иначе
		
		ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском("ЗагрузкаРазрешена", Ложь);
		
		ВключитьПовторениеЗагрузкиСообщенияОбменаДаннымиПередЗапуском();
		
		ТекстПредупреждения = НСтр("ru = 'Получение данных из главного узла завершилось с ошибками.
			|Подробности см. в журнале регистрации.'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСообщениеОбменаДаннымиСОбновлением()
	
	Попытка
		ЗагрузитьПриоритетныеДанныеВПодчиненныйУзелРИБ();
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЕстьОшибки = Истина;
	КонецПопытки;
	
	УстановитьОтображениеЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПриоритетныеДанныеВПодчиненныйУзелРИБ()
	
	Если ОбменДаннымиВызовСервера.РежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
			"ПропуститьЗагрузкуСообщенияОбменаДаннымиПередЗапуском") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДаннымиВызовСервера.РежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
			"ПропуститьЗагрузкуПриоритетныхДанныхПередЗапуском") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском("ЗагрузкаРазрешена", Истина);
	УстановитьПривилегированныйРежим(Ложь);
	
	ПроверитьИспользованиеСинхронизацииДанных();
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюДанных") Тогда
		
		УзелИнформационнойБазы = ОбменДаннымиСервер.ГлавныйУзел();
		
		Если УзелИнформационнойБазы <> Неопределено Тогда
			
			ВидТранспорта = РегистрыСведений.НастройкиТранспортаОбмена.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелИнформационнойБазы);
			
			ДатаНачалаОперации = ТекущаяДатаСеанса();
			
			ПараметрыАутентификации = ?(ЭтоАвтономноеРабочееМесто, Новый Структура("ИспользоватьТекущегоПользователя, Пароль", Истина, Пароль), Неопределено);
			
			// Загрузка только параметров работы программы.
			ПараметрыОбмена = ОбменДаннымиСервер.ПараметрыОбмена();
			ПараметрыОбмена.ВидТранспортаСообщенийОбмена = ВидТранспорта;
			ПараметрыОбмена.ВыполнятьЗагрузку = Истина;
			ПараметрыОбмена.ВыполнятьВыгрузку = Ложь;
			ПараметрыОбмена.ТолькоПараметры   = Истина;
			
			ПараметрыОбмена.ДлительнаяОперацияРазрешена = ДлительнаяОперацияРазрешена;
			ПараметрыОбмена.ДлительнаяОперация          = ДлительнаяОперация;
			ПараметрыОбмена.ИдентификаторОперации       = ИдентификаторОперации;
			ПараметрыОбмена.ИдентификаторФайла          = ИдентификаторФайла;
			ПараметрыОбмена.ПараметрыАутентификации     = ПараметрыАутентификации;
			
			ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(УзелИнформационнойБазы, ПараметрыОбмена, ЕстьОшибки);
			
			ДлительнаяОперацияРазрешена = ПараметрыОбмена.ДлительнаяОперацияРазрешена;
			ДлительнаяОперация          = ПараметрыОбмена.ДлительнаяОперация;
			ИдентификаторОперации       = ПараметрыОбмена.ИдентификаторОперации;
			ИдентификаторФайла          = ПараметрыОбмена.ИдентификаторФайла;
			ПараметрыАутентификации     = ПараметрыОбмена.ПараметрыАутентификации;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сценарий без синхронизации

&НаСервере
Процедура НеСинхронизироватьИПродолжитьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
		Если Константы.ЗагрузитьСообщениеОбменаДанными.Получить() Тогда
			Константы.ЗагрузитьСообщениеОбменаДанными.Установить(Ложь);
			ОбменДаннымиСервер.ОчиститьСообщениеОбменаДаннымиИзГлавногоУзла();
		КонецЕсли;
	КонецЕсли;
	
	ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
		"ПропуститьЗагрузкуСообщенияОбменаДаннымиПередЗапуском", Истина);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Служебные процедуры и функции.

&НаСервере
Процедура ПроверитьНеобходимостьОбновления()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если КонфигурацияИзменена() Тогда
		СтатусОбновления = "ОбновлениеКонфигурации";
	ИначеЕсли ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
		СтатусОбновления = "ОбновлениеИнформационнойБазы";
	Иначе
		СтатусОбновления = "ОбновлениеНеТребуется";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьИПродолжитьЗавершение()
	
	УстановитьОтображениеЭлементовФормы();
	
	Если ПустаяСтрока(ТекстПредупреждения) Тогда
		Закрыть("Продолжить");
	Иначе
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает признак повторения загрузки при ошибке загрузки или обновления.
// Очищает хранилище сообщения обмена, полученного из главного узла РИБ.
//
&НаСервере
Процедура ВключитьПовторениеЗагрузкиСообщенияОбменаДаннымиПередЗапуском()
	
	ОбменДаннымиСервер.ОчиститьСообщениеОбменаДаннымиИзГлавногоУзла();
	
	Константы.ПовторитьЗагрузкуСообщенияОбменаДаннымиПередЗапуском.Установить(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияДлительнойОперации()
	
	ПараметрыАутентификации = ?(ЭтоАвтономноеРабочееМесто, Новый Структура("ИспользоватьТекущегоПользователя, Пароль", Истина, Пароль), Неопределено);
	
	СостояниеОперации = ОбменДаннымиВызовСервера.СостояниеДлительнойОперацииДляУзлаИнформационнойБазы(
		ИдентификаторОперации,
		УзелИнформационнойБазы,
		ПараметрыАутентификации,
		ТекстПредупреждения);
	
	Если СостояниеОперации = "Active" Тогда
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДлительнойОперации", 5, Истина);
		
	Иначе
		
		Если СостояниеОперации <> "Completed" Тогда
			
			ЕстьОшибки = Истина;
			
		КонецЕсли;
		
		ДлительнаяОперация = Ложь;
		
		ОбработатьОкончаниеДлительнойОперации();
		
		Если СтатусОбновления = "ОбновлениеНеТребуется" Тогда
			
			СинхронизироватьИПродолжитьБезОбновленияИБЗавершение();
			
		ИначеЕсли СтатусОбновления = "ОбновлениеИнформационнойБазы" Тогда
			
			СинхронизироватьИПродолжитьСОбновлениемИБЗавершение();
			
		КонецЕсли;
		
		СинхронизироватьИПродолжитьЗавершение();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьИспользованиеСинхронизацииДанных()
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюДанных") Тогда
		
		Если ОбщегоНазначения.РазделениеВключено() Тогда
			
			ИспользоватьСинхронизациюДанных = Константы.ИспользоватьСинхронизациюДанных.СоздатьМенеджерЗначения();
			ИспользоватьСинхронизациюДанных.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
			ИспользоватьСинхронизациюДанных.ОбменДанными.Загрузка = Истина;
			ИспользоватьСинхронизациюДанных.Значение = Истина;
			ИспользоватьСинхронизациюДанных.Записать();
			
		Иначе
			
			Если ОбменДаннымиСервер.ПолучитьИспользуемыеПланыОбмена().Количество() > 0 Тогда
				
				ИспользоватьСинхронизациюДанных = Константы.ИспользоватьСинхронизациюДанных.СоздатьМенеджерЗначения();
				ИспользоватьСинхронизациюДанных.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
				ИспользоватьСинхронизациюДанных.ОбменДанными.Загрузка = Истина;
				ИспользоватьСинхронизациюДанных.Значение = Истина;
				ИспользоватьСинхронизациюДанных.Записать();
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеЭлементовФормы()
	
	Если ОбменДаннымиСервер.ЗагрузитьСообщениеОбменаДанными()
		И ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
		
		Элементы.ФормаНеСинхронизироватьИПродолжить.Видимость = Ложь;
		Элементы.ИнформационнаяНадписьНеСинхронизировать.Видимость = Ложь;
	Иначе
		Элементы.ФормаНеСинхронизироватьИПродолжить.Видимость = Истина;
		Элементы.ИнформационнаяНадписьНеСинхронизировать.Видимость = Истина;
	КонецЕсли;
	
	Элементы.ПанельОсновная.ТекущаяСтраница = ?(ДлительнаяОперация, Элементы.ДлительнаяОперация, Элементы.Начало);
	Элементы.ГруппаКнопокДлительнаяОперация.Видимость = ДлительнаяОперация;
	Элементы.ГруппаКнопокОсновная.Видимость = Не ДлительнаяОперация;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОкончаниеДлительнойОперации()
	
	Если Не ЕстьОшибки Тогда
		
		ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЗавершениеДлительнойОперации(
			УзелИнформационнойБазы,
			ИдентификаторФайла,
			ДатаНачалаОперации);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЗавершениеДлительнойОперации(
															Знач УзелИнформационнойБазы,
															Знач ИдентификаторФайла,
															Знач ДатаНачалаОперации)
	
	ОбменДаннымиСервер.ПроверитьВозможностьВыполненияОбменов();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	ПараметрыАутентификации = ?(ЭтоАвтономноеРабочееМесто, Новый Структура("ИспользоватьТекущегоПользователя, Пароль", Истина, Пароль), Неопределено);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		ФайлСообщенияОбмена = ОбменДаннымиСервер.ПолучитьФайлИзХранилищаВСервисе(Новый УникальныйИдентификатор(ИдентификаторФайла),
			УзелИнформационнойБазы,, ПараметрыАутентификации);
	Исключение
		ОбменДаннымиСервер.ЗафиксироватьЗавершениеОбменаСОшибкой(УзелИнформационнойБазы,
			Перечисления.ДействияПриОбмене.ЗагрузкаДанных,
			ДатаНачалаОперации,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЕстьОшибки = Истина;
		Возврат;
	КонецПопытки;
	
	НовоеСообщение = Новый ДвоичныеДанные(ФайлСообщенияОбмена);
	ОбменДаннымиСервер.УстановитьСообщениеОбменаДаннымиИзГлавногоУзла(НовоеСообщение, УзелИнформационнойБазы);
	
	Попытка
		УдалитьФайлы(ФайлСообщенияОбмена);
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Попытка
		
		ТолькоПараметры = (СтатусОбновления = "ОбновлениеИнформационнойБазы");
		ВидТранспорта = РегистрыСведений.НастройкиТранспортаОбмена.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелИнформационнойБазы);
		
		ПараметрыОбмена = ОбменДаннымиСервер.ПараметрыОбмена();
		ПараметрыОбмена.ВидТранспортаСообщенийОбмена = ВидТранспорта;
		ПараметрыОбмена.ВыполнятьЗагрузку = Истина;
		ПараметрыОбмена.ВыполнятьВыгрузку = Ложь;
		ПараметрыОбмена.ТолькоПараметры = ТолькоПараметры;
		ПараметрыОбмена.ПараметрыАутентификации = ПараметрыАутентификации;
		
		ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(УзелИнформационнойБазы, ПараметрыОбмена, ЕстьОшибки);
		
	Исключение
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЕстьОшибки = Истина;
		
	КонецПопытки;
	
КонецПроцедуры


#КонецОбласти