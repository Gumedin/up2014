﻿#Область СлужебныеПроцедурыИФункции

// Отправляет SMS через Билайн.
//
// Параметры:
//  НомераПолучателей - Массив - номера получателей в формате +7ХХХХХХХХХХ;
//  Текст 			  - Строка - текст сообщения, длиной не более 480 символов;
//  ИмяОтправителя 	  - Строка - имя отправителя, которое будет отображаться вместо номера входящего SMS;
//  Логин			  - Строка - логин пользователя услуги отправки sms;
//  Пароль			  - Строка - пароль пользователя услуги отправки sms.
//
// Возвращаемое значение:
//  Структура: ОтправленныеСообщения - Массив структур: НомерОтправителя.
//                                                  ИдентификаторСообщения.
//             ОписаниеОшибки        - Строка - пользовательское представление ошибки, если пустая строка,
//                                          то ошибки нет.
Функция ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя, Логин, Пароль) Экспорт
	
	Результат = Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Новый Массив, "");
	
	// Подготовка строки получателей.
	СтрокаПолучателей = МассивПолучателейСтрокой(НомераПолучателей);
	
	// Проверка на заполнение обязательных параметров.
	Если ПустаяСтрока(СтрокаПолучателей) Или ПустаяСтрока(Текст) Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Неверные параметры сообщения'");
		Возврат Результат;
	КонецЕсли;
	
	// Подготовка параметров запроса.
	ПараметрыЗапроса = Новый Соответствие;
	ПараметрыЗапроса.Вставить("user", Логин);
	ПараметрыЗапроса.Вставить("pass", Пароль);
	ПараметрыЗапроса.Вставить("gzip", "none");
	ПараметрыЗапроса.Вставить("action", "post_sms");
	ПараметрыЗапроса.Вставить("message", Текст);
	ПараметрыЗапроса.Вставить("target", СтрокаПолучателей);
	ПараметрыЗапроса.Вставить("sender", ИмяОтправителя);
	
	// Отправка запроса.
	Ответ = ВыполнитьЗапрос(ПараметрыЗапроса);
	Если Ответ = Неопределено Тогда
		Результат.ОписаниеОшибки = Результат.ОписаниеОшибки + НСтр("ru = 'Соединение не установлено'");
		Возврат Результат;
	КонецЕсли;		
	
	// Обработка результата запроса (получение идентификаторов сообщений).
	СтруктураОтвета = Новый ЧтениеXML;
	СтруктураОтвета.УстановитьСтроку(Ответ);
	ОписаниеОшибки = "";
	Пока СтруктураОтвета.Прочитать() Цикл 
		Если СтруктураОтвета.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Если СтруктураОтвета.Имя = "sms" Тогда 
				ИдентификаторСообщения = "";
				НомерПолучателя = "";
				Пока СтруктураОтвета.ПрочитатьАтрибут() Цикл 
					Если СтруктураОтвета.Имя = "id" Тогда 
						ИдентификаторСообщения = СтруктураОтвета.Значение;
					ИначеЕсли СтруктураОтвета.Имя = "phone" Тогда
						НомерПолучателя = СтруктураОтвета.Значение;
					КонецЕсли;
				КонецЦикла;
				Если Не ПустаяСтрока(НомерПолучателя) Тогда
					ОтправленноеСообщение = Новый Структура("НомерПолучателя,ИдентификаторСообщения",
														 НомерПолучателя,ИдентификаторСообщения);
					Результат.ОтправленныеСообщения.Добавить(ОтправленноеСообщение);
				КонецЕсли;
			ИначеЕсли СтруктураОтвета.Имя = "error" Тогда
				СтруктураОтвета.Прочитать();
				ОписаниеОшибки = ОписаниеОшибки + СтруктураОтвета.Значение + Символы.ПС;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	СтруктураОтвета.Закрыть();
	
	Результат.ОписаниеОшибки = СокрП(ОписаниеОшибки);
	Возврат Результат;
	
КонецФункции

// Возвращает текстовое представление статуса доставки сообщения.
//
// Параметры:
//  ИдентификаторСообщения - Строка - идентификатор, присвоенный sms при отправке;
//  НастройкиОтправкиSMS   - Структура - см. ОтправкаSMSПовтИсп.НастройкиОтправкиSMS;
//
// Возвращаемое значение:
//  Строка - статус доставки. См. описание функции ОтправкаSMS.СтатусДоставки.
Функция СтатусДоставки(ИдентификаторСообщения, НастройкиОтправкиSMS) Экспорт
	Логин = НастройкиОтправкиSMS.Логин;
	Пароль = НастройкиОтправкиSMS.Пароль;

	// Подготовка параметров запроса.
	ПараметрыЗапроса = Новый Соответствие;
	ПараметрыЗапроса.Вставить("user", Логин);
	ПараметрыЗапроса.Вставить("pass", Пароль);
	ПараметрыЗапроса.Вставить("gzip", "none");
	ПараметрыЗапроса.Вставить("action", "status");
	ПараметрыЗапроса.Вставить("sms_id", ИдентификаторСообщения);
	
	// Отправка запроса.
	Ответ = ВыполнитьЗапрос(ПараметрыЗапроса);
	Если Ответ = Неопределено Тогда
		Возврат "Ошибка";
	КонецЕсли;
	
	// Обработка результата запроса.
	SMSSTS_CODE = "";
	ТекущийSMS_ID = "";
	СтруктураОтвета = Новый ЧтениеXML;
	СтруктураОтвета.УстановитьСтроку(Ответ);
	Пока СтруктураОтвета.Прочитать() Цикл 
		Если СтруктураОтвета.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Если СтруктураОтвета.Имя = "MESSAGE" Тогда 
				Пока СтруктураОтвета.ПрочитатьАтрибут() Цикл 
					Если СтруктураОтвета.Имя = "SMS_ID" Тогда 
						ТекущийSMS_ID = СтруктураОтвета.Значение;
					КонецЕсли;
				КонецЦикла;
			ИначеЕсли СтруктураОтвета.Имя = "SMSSTC_CODE" И ИдентификаторСообщения = ТекущийSMS_ID Тогда
				СтруктураОтвета.Прочитать();
				SMSSTS_CODE = СтруктураОтвета.Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	СтруктураОтвета.Закрыть();
	
	Возврат СтатусДоставкиSMS(SMSSTS_CODE); 
	
КонецФункции

Функция СтатусДоставкиSMS(СтатусСтрокой)
	СоответствиеСтатусов = Новый Соответствие;
	СоответствиеСтатусов.Вставить("", "НеОтправлялось");
	СоответствиеСтатусов.Вставить("queued", "НеОтправлялось");
	СоответствиеСтатусов.Вставить("wait", "Отправляется");
	СоответствиеСтатусов.Вставить("accepted", "Отправлено");
	СоответствиеСтатусов.Вставить("delivered", "Доставлено");
	СоответствиеСтатусов.Вставить("failed", "НеДоставлено");
	
	Результат = СоответствиеСтатусов[НРег(СтатусСтрокой)];
	Возврат ?(Результат = Неопределено, "Ошибка", Результат);
КонецФункции

Функция ВыполнитьЗапрос(ПараметрыЗапроса)
	
	HTTPЗапрос = ОтправкаSMS.ПодготовитьHTTPЗапрос("/sendsms/", ПараметрыЗапроса);
	HTTPОтвет = Неопределено;
	
	Попытка
		Соединение = Новый HTTPСоединение("beeline.amega-inform.ru", , , , ПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси("http"), 60);
		HTTPОтвет = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Если HTTPОтвет <> Неопределено Тогда
		Возврат HTTPОтвет.ПолучитьТелоКакСтроку();
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция МассивПолучателейСтрокой(Массив)
	Результат = "";
	Для Каждого Элемент Из Массив Цикл
		Номер = ФорматироватьНомер(Элемент);
		Если НЕ ПустаяСтрока(Номер) Тогда 
			Если Не ПустаяСтрока(Результат) Тогда
				Результат = Результат + ",";
			КонецЕсли;
			Результат = Результат + Номер;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ФорматироватьНомер(Номер)
	Результат = "";
	ДопустимыеСимволы = "+1234567890";
	Для Позиция = 1 По СтрДлина(Номер) Цикл
		Символ = Сред(Номер,Позиция,1);
		Если СтрНайти(ДопустимыеСимволы, Символ) > 0 Тогда
			Результат = Результат + Символ;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;	
КонецФункции

// Возвращает список разрешений для отправки SMS с использованием всех доступных провайдеров.
//
// Возвращаемое значение:
//  Массив.
//
Функция Разрешения() Экспорт
	
	Протокол = "HTTP";
	Адрес = "beeline.amega-inform.ru";
	Порт = Неопределено;
	Описание = НСтр("ru = 'Отправка SMS через Билайн.'");
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Разрешения = Новый Массив;
	Разрешения.Добавить(
		МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(Протокол, Адрес, Порт, Описание));
	
	Возврат Разрешения;
КонецФункции

Процедура ЗаполнитьОписаниеУслуги(ОписаниеУслуги) Экспорт
	ОписаниеУслуги.АдресВИнтернете = "http://b2b.beeline.ru/msk/sb/mobile/services/index.wbp?id=3a15308a-7b14-4f8e-acda-0841dd6c750e";
КонецПроцедуры

#КонецОбласти
