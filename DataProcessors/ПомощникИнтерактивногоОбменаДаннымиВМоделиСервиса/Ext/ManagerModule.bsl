﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Обработчик фонового задания для регистрации дополнительных данных и обмена
//
// Параметры:
//     ОбработкаВыгрузки - ОбработкаОбъект.ИнтерактивноеИзменениеВыгрузки - инициализированный объект
//     АдресХранилища    - Строка, УникальныйИдентификатор - Адрес в хранилище для получения результата
// 
Процедура ОбменПоТребованию(Знач ОбработкаВыгрузки, Знач АдресХранилища = Неопределено) Экспорт
	
	ЗарегистрироватьДанныеДополненияВыгрузки(ОбработкаВыгрузки);
	
	Сессия = ЗапуститьОбменПоТребованию(ОбработкаВыгрузки.УзелИнформационнойБазы);
	
	Если АдресХранилища <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Новый Структура("Сессия", Сессия), АдресХранилища);
	КонецЕсли;
	
КонецПроцедуры

// Регистрирует дополнительные данные по настройкам
//
// Параметры:
//     ОбработкаВыгрузки - Структура, ОбработкаОбъект.ИнтерактивноеИзменениеВыгрузки - инициализированный объект
//
Процедура ЗарегистрироватьДанныеДополненияВыгрузки(Знач ОбработкаВыгрузки)
	
	Если ТипЗнч(ОбработкаВыгрузки) = Тип("Структура") Тогда
		Обработка = Обработки.ИнтерактивноеИзменениеВыгрузки.Создать();
		ЗаполнитьЗначенияСвойств(Обработка, ОбработкаВыгрузки, , "ДополнительнаяРегистрация, ДополнительнаяРегистрацияСценарияУзла");
		ОбменДаннымиСервер.ЗаполнитьТаблицуЗначений(Обработка.ДополнительнаяРегистрация, ОбработкаВыгрузки.ДополнительнаяРегистрация);
		ОбменДаннымиСервер.ЗаполнитьТаблицуЗначений(Обработка.ДополнительнаяРегистрацияСценарияУзла, ОбработкаВыгрузки.ДополнительнаяРегистрацияСценарияУзла);
	Иначе
		Обработка = ОбработкаВыгрузки;
	КонецЕсли;
	
	Если Обработка.ВариантВыгрузки <= 0 Тогда
		// Не добавлять
		Возврат;
		
	ИначеЕсли Обработка.ВариантВыгрузки = 1 Тогда
		// За период с отбором, очищаем дополнительную
		Обработка.ДополнительнаяРегистрация.Очистить();
		
	ИначеЕсли Обработка.ВариантВыгрузки = 2 Тогда
		// Детально настроено, очищаем общее
		Обработка.КомпоновщикОтбораВсехДокументов = Неопределено;
		Обработка.ПериодОтбораВсехДокументов      = Неопределено;
		
	КонецЕсли;
	
	Обработка.ЗарегистрироватьДополнительныеИзменения();
КонецПроцедуры

// Запускает обмен по требованию
//
// Параметры:
//     УзелИнформационнойБазы - ПланОбменаСсылка - Ссылка на корреспондента
//
Функция ЗапуститьОбменПоТребованию(Знач УзелИнформационнойБазы) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияАдминистрированиеОбменаДаннымиУправлениеИнтерфейс.СообщениеПротолкнутьСинхронизацию()
		);
		
		Сессия = РегистрыСведений.СессииОбменаСообщениямиСистемы.НоваяСессия();
		
		Сообщение.Body.Zone      = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		Сообщение.Body.SessionId = Сессия;
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(Сообщение, РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса(), Истина);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииСинхронизацииДанных(),,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()) 
		);
			
		Сессия = Неопределено;
	КонецПопытки;
	
	Если Сессия<>Неопределено Тогда
		СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	КонецЕсли;
	
	Возврат Сессия;
КонецФункции

#КонецОбласти

#КонецЕсли