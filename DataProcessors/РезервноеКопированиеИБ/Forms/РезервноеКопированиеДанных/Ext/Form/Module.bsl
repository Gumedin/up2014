﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Возврат; // Отказ устанавливается в ПриОткрытии().
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		ВызватьИсключение НСтр("ru = 'Резервное копирование недоступно в веб-клиенте.'");
	КонецЕсли;
	
	Если НЕ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ВызватьИсключение НСтр("ru = 'В клиент-серверном варианте работы резервное копирование следует выполнять сторонними средствами (средствами СУБД).'");
	КонецЕсли;
	
	НастройкиРезервногоКопирования = РезервноеКопированиеИБСервер.НастройкиРезервногоКопирования();
	ПарольАдминистратораИБ = НастройкиРезервногоКопирования.ПарольАдминистратораИБ;
	
	Если Параметры.РежимРаботы = "ВыполнитьСейчас" Тогда
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаИнформацииИВыполненияРезервногоКопирования;
		Если Не ПустаяСтрока(Параметры.Пояснение) Тогда
			Элементы.ГруппаОжидание.ТекущаяСтраница = Элементы.СтраницаОжиданияВремениЗапуска;
			Элементы.НадписьВремяОжиданияРезервногоКопирования.Заголовок = Параметры.Пояснение;
		КонецЕсли;
	ИначеЕсли Параметры.РежимРаботы = "ВыполнитьПриЗавершенииРаботы" Тогда
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаИнформацииИВыполненияРезервногоКопирования;
	ИначеЕсли Параметры.РежимРаботы = "УспешноВыполнено" Тогда
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаУспешногоВыполненияКопирования;
		ИмяФайлаРезервнойКопии = Параметры.ИмяФайлаРезервнойКопии;
	ИначеЕсли Параметры.РежимРаботы = "НеВыполнено" Тогда
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаОшибокПриКопировании;
	КонецЕсли;
	
	Объект.КаталогСРезервнымиКопиями = НастройкиРезервногоКопирования.КаталогХраненияРезервныхКопий;
	Если НастройкиРезервногоКопирования.ДатаПоследнегоРезервногоКопирования = Дата(1, 1, 1) Тогда
		ТекстЗаголовка = НСтр("ru = 'Резервное копирование еще ни разу не проводилось'");
	Иначе
		ТекстЗаголовка = НСтр("ru = 'В последний раз резервное копирование проводилось: %1'");
		ДатаПоследнегоКопирования = Формат(НастройкиРезервногоКопирования.ДатаПоследнегоРезервногоКопирования, "ДЛФ=ДДВ");
		ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, ДатаПоследнегоКопирования);
	КонецЕсли;
	Элементы.НадписьДатаПроведенияПоследнегоРезервногоКопирования.Заголовок = ТекстЗаголовка;
	
	Элементы.ГруппаАвтоматическоеРезервноеКопирование.Видимость = Не НастройкиРезервногоКопирования.ВыполнятьАвтоматическоеРезервноеКопирование;
	
	// Первая часть проверки на сервере - если в информационной базе есть пользователи
	ТребуетсяВводПароля = (ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() > 0);
	
	Если ПолучитьСеансыИнформационнойБазы().Количество() > 1 Тогда
		
		Элементы.СтраницыСтатусаКопирования.ТекущаяСтраница = Элементы.СтраницаАктивныеПользователи;
		
	КонецЕсли;
	
	РучнойЗапуск = (Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаВыполненияРезервногоКопирования);
	РезервноеКопированиеИБСервер.УстановитьЗначениеНастройки("РучнойЗапускПоследнегоРезервногоКопирования", РучнойЗапуск);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Резервное копирование недоступно в клиенте под управлением ОС Linux.'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	ИнформацияОПользователе = ПараметрыРаботыКлиента.ИнформацияОПользователе;
	
	// Вторая часть проверки на клиенте - если у текущего пользователя (администратор)
	// используется стандартная аутентификация и установлен пароль
	ТребуетсяВводПароля = ТребуетсяВводПароля И ИнформацияОПользователе.АутентификацияСтандартная И ИнформацияОПользователе.ПарольУстановлен;
	
	Если ТребуетсяВводПароля Тогда
		АдминистраторИБ = ИнформацияОПользователе.Имя;
	Иначе
		Элементы.ГруппаАвторизации.Видимость = Ложь;
	КонецЕсли;
	
	ИмяФайлаЗапускаПриложенияВРежимеПредприятия = ПолучитьИмяФайлаЗапускаПриложенияВРежимеПредприятия();
		
	ПерейтиНаСтраницу(Элементы.СтраницыПомощника.ТекущаяСтраница);
	
#Если ВебКлиент Тогда
	Элементы.НадписьОбновитьВерсиюКомпоненты.Видимость = Ложь;
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ТекущаяСтраница = Элементы.СтраницыПомощника.ТекущаяСтраница;
	Если ТекущаяСтраница = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаИнформацииИВыполненияРезервногоКопирования Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Прервать подготовку к резервному копированию данных?'");
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(ЭтотОбъект,
			Отказ, ТекстПредупреждения, "ЗакрытьФормуБезусловно");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	СоединенияИБВызовСервера.РазрешитьРаботуПользователей();
	ОтключитьОбработчикОжидания("ИстечениеВремениОжидания");
	ОтключитьОбработчикОжидания("ПроверкаНаЕдинственностьПодключения");
	ОтключитьОбработчикОжидания("ЗавершитьРаботуПользователей");
	
	Если ПараметрыРезервногоКопированияИБ.ПроцессВыполняется Тогда
		ПараметрыРезервногоКопированияИБ.ПроцессВыполняется = Ложь;
		РезервноеКопированиеИБВызовСервера.УстановитьЗначениеНастройки("ПроцессВыполняется", Ложь);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура СписокПользователейНажатие(Элемент)
	
	ОткрытьФорму("Обработка.АктивныеПользователи.Форма.ФормаСпискаАктивныхПользователей", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьККаталогуАрхивовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыбранныйПуть = ПолучитьПуть(РежимДиалогаВыбораФайла.ВыборКаталога);
	Если Не ПустаяСтрока(ВыбранныйПуть) Тогда 
		Объект.КаталогСРезервнымиКопиями = ВыбранныйПуть;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаРезервнойКопииОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(ИмяФайлаРезервнойКопии);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияАвтоматическоеРезервноеКопированиеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму(РезервноеКопированиеИБКлиент.ИмяФормыНастроекРезервногоКопирования());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнениеРеквизитов() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ТекущаяСтраница;
	Если ТекущаяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаВыполненияРезервногоКопирования Тогда
		
		ОбработатьВыборРежимаИнтерактивногоКопирования();
		УстановитьПутьАрхиваСКопиями(Объект.КаталогСРезервнымиКопиями);
		
	Иначе
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрации(Команда)
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", , ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПолучитьИмяФайлаЗапускаПриложенияВРежимеПредприятия()
#Если ТонкийКлиент Тогда 
	Возврат "1cv8c.exe";
#Иначе
	Возврат "1cv8.exe";
#КонецЕсли
КонецФункции

&НаКлиенте
Процедура ПерейтиНаСтраницу(НоваяСтраница)
	
	ПодчиненныеСтраницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	Если НоваяСтраница = ПодчиненныеСтраницы.СтраницаВыполненияРезервногоКопирования Тогда
		ПерейтиНаСтраницуВыполненияРезервногоКопирования();
	ИначеЕсли НоваяСтраница = ПодчиненныеСтраницы.СтраницаИнформацииИВыполненияРезервногоКопирования Тогда
		ПерейтиНаСтраницуИнформацииИВыполненияРезервногоКопирования();
	ИначеЕсли НоваяСтраница = ПодчиненныеСтраницы.СтраницаОшибокПриКопировании 
		ИЛИ НоваяСтраница = ПодчиненныеСтраницы.СтраницаУспешногоВыполненияКопирования Тогда
		ПерейтиНаСтраницуРезультатовРезервногоКопирования();
	КонецЕсли;
		
	Если НоваяСтраница <> Неопределено Тогда
		Элементы.СтраницыПомощника.ТекущаяСтраница = НоваяСтраница;
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницуВыполненияРезервногоКопирования()
	
	Если ПолучитьДоступность() Тогда
		
		Элементы.СтраницыСтатусаКопирования.ТекущаяСтраница = Элементы.СтраницаАктивныеПользователи;
		
	КонецЕсли;
	
	Элементы.Далее.Заголовок = Нстр("ru = 'Сохранить резервную копию'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницуИнформацииИВыполненияРезервногоКопирования()
	
	ПараметрыРезервногоКопированияИБ.ПроцессВыполняется = Истина;
	РезервноеКопированиеИБВызовСервера.УстановитьЗначениеНастройки("ПроцессВыполняется", Истина);
	
	Элементы.Отмена.Доступность = Истина;
	ОбновитьКоличествоАктивныхПользователей();
	УстановитьЗаголовокКнопкиДалее(Истина);
	Элементы.Далее.Доступность = Ложь;
	
	Если Не ПроверитьЗаполнениеРеквизитов(Ложь) Тогда
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаОшибокПриКопировании;
		Возврат;
	КонецЕсли;
	
	Если Не ПроверитьДоступКИБ() Тогда
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаОшибокПриКопировании;
		Возврат;
	КонецЕсли;
	
	УстановитьБлокировкуСоединений = Истина;
	Если РезервноеКопированиеИБВызовСервера.КоличествоАктивныхПользователей() = 1 Тогда
		
		СоединенияИБВызовСервера.УстановитьБлокировкуСоединений(Нстр("ru = 'Для выполнения резервного копирования.'"), "РезервноеКопирование");
		СоединенияИБКлиент.УстановитьПризнакРаботаПользователейЗавершается(УстановитьБлокировкуСоединений);
		СоединенияИБКлиент.ЗавершитьРаботуЭтогоСеанса(Ложь);
		
		НачатьРезервноеКопирование();
		
	Иначе
		
		ОчиститьСообщения();
		
		НазванияСоединенийИБ = "";
		Если НЕ АктивныТолькоКлиентскиеПриложения(НазванияСоединенийИБ) Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Имеются активные сеансы работы с программой, которые не могут быть завершены принудительно.
				|%1'"), 
			НазванияСоединенийИБ);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
		СоединенияИБВызовСервера.УстановитьБлокировкуСоединений(Нстр("ru = 'Для выполнения резервного копирования.'"), "РезервноеКопирование");
		СоединенияИБКлиент.УстановитьОбработчикиОжиданияЗавершенияРаботыПользователей(УстановитьБлокировкуСоединений);
		УстановитьОбработчикОжиданияНачалаРезервногоКопирования();
		УстановитьОбработчикОжиданияИстеченияТаймаутаРезервногоКопирования();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницуРезультатовРезервногоКопирования()
	
	Элементы.Далее.Видимость= Ложь;
	Элементы.Отмена.Заголовок = НСтр("ru = 'Закрыть'");
	Элементы.Отмена.КнопкаПоУмолчанию = Истина;
	ПараметрыРезервногоКопирования = НастройкиРезервногоКопирования();
	РезервноеКопированиеИБКлиент.ЗаполнитьЗначенияГлобальныхПеременных(ПараметрыРезервногоКопирования);
	УстановитьРезультатРезервногоКопирования();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьРезультатРезервногоКопирования()
	
	РезервноеКопированиеИБСервер.УстановитьРезультатРезервногоКопирования();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция АктивныТолькоКлиентскиеПриложения(ИменаАктивныхСеансов)
	
	Результат = Истина;
	НазванияСоединенийИБ = "";
	НомерТекущегоСеанса = НомерСеансаИнформационнойБазы();
	Для каждого Сеанс Из ПолучитьСеансыИнформационнойБазы() Цикл
		Если Сеанс.НомерСеанса = НомерТекущегоСеанса Тогда
			Продолжить;
		КонецЕсли;
		Если Сеанс.ИмяПриложения <> "1CV8" И Сеанс.ИмяПриложения <> "1CV8C" И
			Сеанс.ИмяПриложения <> "WebClient" Тогда
			ИменаАктивныхСеансов = ИменаАктивныхСеансов + Символы.ПС + "• " + Сеанс;
			Результат = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ПроверитьДоступКИБ()
	
	Результат = Истина;
	
	// В базовых версиях проверку подключения не осуществляем;
	// при некорректном вводе имени и пароля обновление завершится неуспешно.
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации Тогда
		Возврат Результат;
	КонецЕсли; 
	
	ПараметрыПодключения = ПолучитьПараметрыАутентификацииАдминистратораОбновления();
	
	Попытка
		
		ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель(Ложь);
		ComConnector = Новый COMОбъект(СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИмяCOMСоединителя);
		СтрокаСоединенияИнформационнойБазы = ПараметрыПодключения.СтрокаСоединенияИнформационнойБазы + ПараметрыПодключения.СтрокаПодключения;
		Соединение = ComConnector.Connect(СтрокаСоединенияИнформационнойБазы);
		
	Исключение
		
		Результат = Ложь;
		Инфо = ИнформацияОбОшибке();
		ОбнаруженнаяОшибкаПодключения = КраткоеПредставлениеОшибки(Инфо);
		
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(РезервноеКопированиеИБКлиент.СобытиеЖурналаРегистрации(),
			"Ошибка",  ОбнаруженнаяОшибкаПодключения, , Истина);
		
	КонецПопытки;
	
	Если Результат Тогда
		
		УстановитьПараметрыРезервногоКопирования();
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьПараметрыРезервногоКопирования()
	
	ПараметрыРезервногоКопирования = РезервноеКопированиеИБСервер.НастройкиРезервногоКопирования();
	
	ПараметрыРезервногоКопирования.Вставить("АдминистраторИБ", АдминистраторИБ);
	ПараметрыРезервногоКопирования.Вставить("ПарольАдминистратораИБ", ?(ТребуетсяВводПароля, ПарольАдминистратораИБ, ""));
	
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкиРезервногоКопирования()
	
	Возврат РезервноеКопированиеИБСервер.НастройкиРезервногоКопирования();
	
КонецФункции

&НаКлиенте
Функция ПроверитьЗаполнениеРеквизитов(ВыдаватьОшибку = Истина)
	
	РеквизитыЗаполнены = Истина;
	
	Если ПустаяСтрока(Объект.КаталогСРезервнымиКопиями) Тогда
		
		ТекстСообщения = Нстр("ru = 'Не выбран каталог для резервной копии.'");
		ЗафиксироватьОшибкуПроверкиРеквизитов(ТекстСообщения, "Объект.КаталогСРезервнымиКопиями", ВыдаватьОшибку);
		РеквизитыЗаполнены = Ложь;
		
	ИначеЕсли НайтиФайлы(Объект.КаталогСРезервнымиКопиями).Количество() = 0 Тогда
		
		ТекстСообщения = Нстр("ru = 'Указан несуществующий каталог.'");
		ЗафиксироватьОшибкуПроверкиРеквизитов(ТекстСообщения, "Объект.КаталогСРезервнымиКопиями", ВыдаватьОшибку);
		РеквизитыЗаполнены = Ложь;
		
	Иначе
		
		Попытка
			ТестовыйФайл = Новый ЗаписьXML;
			ТестовыйФайл.ОткрытьФайл(Объект.КаталогСРезервнымиКопиями + "/test.test1С");
			ТестовыйФайл.ЗаписатьОбъявлениеXML();
			ТестовыйФайл.Закрыть();
		Исключение
			ТекстСообщения = Нстр("ru = 'Нет доступа к каталогу с резервными копиями.'");
			ЗафиксироватьОшибкуПроверкиРеквизитов(ТекстСообщения, "Объект.КаталогСРезервнымиКопиями", ВыдаватьОшибку);
			РеквизитыЗаполнены = Ложь;
		КонецПопытки;
		
		Если РеквизитыЗаполнены Тогда
			
			Попытка
				УдалитьФайлы(Объект.КаталогСРезервнымиКопиями, "*.test1С");
			Исключение
				// Исключение не обрабатываем т.к. на этом шаге не происходит удаления файлов
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТребуетсяВводПароля И ПустаяСтрока(ПарольАдминистратораИБ) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не задан пароль администратора.'");
		ЗафиксироватьОшибкуПроверкиРеквизитов(ТекстСообщения, "ПарольАдминистратораИБ", ВыдаватьОшибку);
		РеквизитыЗаполнены = Ложь;
		
	КонецЕсли;
	
	Возврат РеквизитыЗаполнены;
	
КонецФункции

&НаКлиенте
Процедура ЗафиксироватьОшибкуПроверкиРеквизитов(ТекстОшибки, ПутьКРеквизиту, ВыдаватьОшибку)
	
	Если ВыдаватьОшибку Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, ПутьКРеквизиту);
	Иначе
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(РезервноеКопированиеИБКлиент.СобытиеЖурналаРегистрации(),
			"Ошибка", ТекстОшибки, , Истина);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик значения переключателя "Код типа резервного копирования" при нажатии на кнопку "Далее".
&НаКлиенте
Процедура ОбработатьВыборРежимаИнтерактивногоКопирования()
	
	НоваяСтраницаПомощника = Неопределено;
	
	Если НЕ ПроверитьДоступКИБ() Тогда
		Элементы.СтраницыСтатусаКопирования.ТекущаяСтраница = Элементы.СтраницыСтатусаКопирования.ПодчиненныеЭлементы.СтраницаОшибкаПодключения;
		Возврат;
	КонецЕсли;
	
	НоваяСтраницаПомощника = Элементы.СтраницыПомощника.ПодчиненныеЭлементы.СтраницаИнформацииИВыполненияРезервногоКопирования;
	
	ПерейтиНаСтраницу(НоваяСтраницаПомощника);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОбработчикОжиданияИстеченияТаймаутаРезервногоКопирования()
	
	ПодключитьОбработчикОжидания("ИстечениеВремениОжидания", 300, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИстечениеВремениОжидания()
	
	ОтключитьОбработчикОжидания("ПроверкаНаЕдинственностьПодключения");
	ТекстВопроса = НСтр("ru = 'Не удалось отключить всех пользователей от базы. Провести резервное копирование? (возможны ошибки при архивации)'");
	ТекстПояснения = НСтр("ru = 'Не удалось отключить пользователя.'");
	ОписаниеОповещения = Новый ОписаниеОповещения("ИстечениеВремениОжиданияЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Нет, ТекстПояснения, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ИстечениеВремениОжиданияЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		НачатьРезервноеКопирование();
	Иначе
		ОчиститьСообщения();
		ОтменитьПодготовку();
КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПодготовку()
	
	ИменаАктивныхСеансов = "";
	НомерТекущегоСеанса = НомерСеансаИнформационнойБазы();
	Для Каждого Сеанс Из ПолучитьСеансыИнформационнойБазы() Цикл
		Если Сеанс.НомерСеанса <> НомерТекущегоСеанса Тогда
			ИменаАктивныхСеансов = ИменаАктивныхСеансов + "• " + Сеанс + Символы.ПС;
		КонецЕсли;
	КонецЦикла;
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(ИменаАктивныхСеансов);
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	НСтр("ru = 'Не удалось принудительно отключить сеансы:
	|%1.
	|Подготовка к резервному копированию отменена. Информационная база разблокирована.'"), ИменаАктивныхСеансов);
	
	Элементы.НадписьНеУдалось.Заголовок = ТекстСообщения;
	Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.СтраницаОшибокПриКопировании;
	Элементы.ПерейтиВЖурналРегистрации1.Видимость = Ложь;
	Элементы.Далее.Видимость = Ложь;
	Элементы.Отмена.Заголовок = НСтр("ru = 'Закрыть'");
	Элементы.Отмена.КнопкаПоУмолчанию = Истина;
	
	СоединенияИБ.РазрешитьРаботуПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОбработчикОжиданияНачалаРезервногоКопирования()
	
	ПодключитьОбработчикОжидания("ПроверкаНаЕдинственностьПодключения", 30);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаНаЕдинственностьПодключения()
	
	КоличествоПользователей = РезервноеКопированиеИБВызовСервера.КоличествоАктивныхПользователей();
	Элементы.КоличествоАктивныхПользователей.Заголовок = Строка(КоличествоПользователей);
	Если КоличествоПользователей = 1 Тогда
		НачатьРезервноеКопирование();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокКнопкиДалее(ЭтоКнопкаДалее)
	
	Элементы.Далее.Заголовок = ?(ЭтоКнопкаДалее, НСтр("ru = 'Далее >'"), НСтр("ru = 'Готово'"));
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПуть(РежимДиалога)
	
	Режим = РежимДиалога;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	Если Режим = РежимДиалогаВыбораФайла.ВыборКаталога Тогда
		ДиалогОткрытияФайла.Заголовок= НСтр("ru = 'Выберите каталог'");
	Иначе
		ДиалогОткрытияФайла.Заголовок= НСтр("ru = 'Выберите файл'");
	КонецЕсли;	
		
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		Если РежимДиалога = РежимДиалогаВыбораФайла.ВыборКаталога тогда
			Возврат ДиалогОткрытияФайла.Каталог;
		Иначе
			Возврат ДиалогОткрытияФайла.ПолноеИмяФайла;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьКоличествоАктивныхПользователей()
	
	Элементы.КоличествоАктивныхПользователей.Заголовок = РезервноеКопированиеИБВызовСервера.КоличествоАктивныхПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьРезервноеКопирование()
	
	ИмяГлавногоФайлаСкрипта = СформироватьФайлыСкриптаОбновления();
	
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(РезервноеКопированиеИБКлиент.СобытиеЖурналаРегистрации(),
		"Информация",  НСтр("ru = 'Выполняется резервное копирование информационной базы:'") + " " + ИмяГлавногоФайлаСкрипта);
		
	Если Параметры.РежимРаботы = "ВыполнитьПриЗавершенииРаботы" Тогда
		РезервноеКопированиеИБКлиент.УдалитьРезервныеКопииПоНастройке();
	КонецЕсли;
		
	Закрыть();
	ПропуститьПредупреждениеПередЗавершениемРаботыСистемы = Истина;
	
	ЗавершитьРаботуСистемы(Ложь);
	ЗапуститьПриложение("""" + ИмяГлавногоФайлаСкрипта + """",	РезервноеКопированиеИБКлиент.ПолучитьКаталогФайла(ИмяГлавногоФайлаСкрипта));
	
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы на сервере и изменения настроек резервного копирования.

&НаСервереБезКонтекста
Процедура УстановитьПутьАрхиваСКопиями(Путь)
	
	НастройкиПути = РезервноеКопированиеИБСервер.НастройкиРезервногоКопирования();
	НастройкиПути.КаталогХраненияРезервныхКопий = Путь;
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(НастройкиПути);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДоступность()
	
	Возврат ПолучитьСеансыИнформационнойБазы().Количество() > 1;
	
КонецФункции

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции подготовки резервного копирования

&НаКлиенте
Функция СформироватьФайлыСкриптаОбновления() 
	
	ПараметрыРезервногоКопирования = РезервноеКопированиеИБКлиент.КлиентскиеПараметрыРезервногоКопирования();
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	СоздатьКаталог(ПараметрыРезервногоКопирования.КаталогВременныхФайловОбновления);
	
	// Структура параметров необходима для их определения на клиенте и передачи на сервер
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИмяФайлаПрограммы"			, ПараметрыРезервногоКопирования.ИмяФайлаПрограммы);
	СтруктураПараметров.Вставить("СобытиеЖурналаРегистрации"	, ПараметрыРезервногоКопирования.СобытиеЖурналаРегистрации);
	СтруктураПараметров.Вставить("ИмяCOMСоединителя"			, ПараметрыРаботыКлиента.ИмяCOMСоединителя);
	СтруктураПараметров.Вставить("ЭтоБазоваяВерсияКонфигурации"	, ПараметрыРаботыКлиента.ЭтоБазоваяВерсияКонфигурации);
	СтруктураПараметров.Вставить("ИнформационнаяБазаФайловая"	, ПараметрыРаботыКлиента.ИнформационнаяБазаФайловая);
	СтруктураПараметров.Вставить("ПараметрыСкрипта"				, ПолучитьПараметрыАутентификацииАдминистратораОбновления());
	
	ИменаМакетов = "ДопФайлРезервногоКопирования";
	ИменаМакетов = ИменаМакетов + ",ЗаставкаРезервногоКопирования";
	ТекстыМакетов = ПолучитьТекстыМакетов(ИменаМакетов, СтруктураПараметров, СообщенияДляЖурналаРегистрации);
	
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов[0]);
	
	ИмяФайлаСкрипта = ПараметрыРезервногоКопирования.КаталогВременныхФайловОбновления + "main.js";
	ФайлСкрипта.Записать(ИмяФайлаСкрипта, КодировкаТекста.UTF16);
	
	// Вспомогательный файл: helpers.js
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов[1]);
	ФайлСкрипта.Записать(ПараметрыРезервногоКопирования.КаталогВременныхФайловОбновления + "helpers.js", КодировкаТекста.UTF16);
	
	ИмяГлавногоФайлаСкрипта = Неопределено;
	// Вспомогательный файл: splash.png
	БиблиотекаКартинок.ЗаставкаВнешнейОперации.Записать(ПараметрыРезервногоКопирования.КаталогВременныхФайловОбновления + "splash.png");
	// Вспомогательный файл: splash.ico
	БиблиотекаКартинок.ЗначокЗаставкиВнешнейОперации.Записать(ПараметрыРезервногоКопирования.КаталогВременныхФайловОбновления + "splash.ico");
	// Вспомогательный файл: progress.gif
	БиблиотекаКартинок.ДлительнаяОперация48.Записать(ПараметрыРезервногоКопирования.КаталогВременныхФайловОбновления + "progress.gif");
	// Главный файл заставки: splash.hta
	ИмяГлавногоФайлаСкрипта = ПараметрыРезервногоКопирования.КаталогВременныхФайловОбновления + "splash.hta";
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов[2]);
	ФайлСкрипта.Записать(ИмяГлавногоФайлаСкрипта, КодировкаТекста.UTF16);
	
	Возврат ИмяГлавногоФайлаСкрипта;	
	
КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыАутентификацииАдминистратораОбновления() 
	
	Результат = Новый Структура("ИмяПользователя,
	|ПарольПользователя,
	|СтрокаПодключения,
	|ПараметрыАутентификации,
	|СтрокаСоединенияИнформационнойБазы",
	Неопределено, "", "", "", "", "");
	
	ТекущиеСоединения = ПолучитьСтрокуСоединенияИИнформациюОСоединениях(СообщенияДляЖурналаРегистрации);
	Результат.СтрокаСоединенияИнформационнойБазы = ТекущиеСоединения.СтрокаСоединенияИнформационнойБазы;
	// Диагностика случая, когда ролевой безопасности в системе не предусмотрено.
	// Т.е. ситуация, когда любой пользователь «может» в системе все.
	//Если НЕ ТекущиеСоединения.ЕстьАктивныеПользователи Тогда
	//	Возврат Результат;
	//КонецЕсли;
	
	Пользователь = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформацияОПользователе.Имя;
	
	Результат.ИмяПользователя			= Пользователь;
	Результат.ПарольПользователя		= ПарольАдминистратораИБ;
	Результат.СтрокаПодключения			= "Usr=""" + Пользователь + """;Pwd=""" + ПарольАдминистратораИБ + """;";
	Результат.ПараметрыАутентификации	= "/N""" + Пользователь + """ /P""" + ПарольАдминистратораИБ + """ /WA-";
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьТекстыМакетов(ИменаМакетов, СтруктураПараметров, СообщенияДляЖурналаРегистрации)
	
	// запись накопленных событий ЖР
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
		
	Результат = Новый Массив();
	Результат.Добавить(ПолучитьТекстСкрипта(СтруктураПараметров));
	
	ИменаМакетовМассив = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаМакетов);
	
	Для каждого ИмяМакета ИЗ ИменаМакетовМассив Цикл
		Результат.Добавить(Обработки.РезервноеКопированиеИБ.ПолучитьМакет(ИмяМакета).ПолучитьТекст());
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьТекстСкрипта(СтруктураПараметров)
	
	// Файл обновления конфигурации: main.js
	ШаблонСкрипта = Обработки.РезервноеКопированиеИБ.ПолучитьМакет("МакетФайлаРезервногоКопирования");
	
	Скрипт = ШаблонСкрипта.ПолучитьОбласть("ОбластьПараметров");
	Скрипт.УдалитьСтроку(1);
	Скрипт.УдалитьСтроку(Скрипт.КоличествоСтрок());
	
	Текст = ШаблонСкрипта.ПолучитьОбласть("ОбластьРезервногоКопирования");
	Текст.УдалитьСтроку(1);
	Текст.УдалитьСтроку(Текст.КоличествоСтрок());
	
	Возврат ВставитьПараметрыСкрипта(Скрипт.ПолучитьТекст(), СтруктураПараметров) + Текст.ПолучитьТекст();
	
КонецФункции

&НаСервере
Функция ВставитьПараметрыСкрипта(Знач Текст, Знач СтруктураПараметров)
	
	Результат = Текст;
	ИменаФайловОбновления = "";
	ИменаФайловОбновления = "[" + "" + "]";
	
	СтрокаСоединенияИнформационнойБазы = СтруктураПараметров.ПараметрыСкрипта.СтрокаСоединенияИнформационнойБазы +
	СтруктураПараметров.ПараметрыСкрипта.СтрокаПодключения; 
	
	ИмяИсполняемогоФайлаПрограммы = КаталогПрограммы() + СтруктураПараметров.ИмяФайлаПрограммы;
	
	// Определение пути к информационной базе.
	ПризнакФайловогоРежима = Неопределено;
	ПутьКИнформационнойБазе = СоединенияИБКлиентСервер.ПутьКИнформационнойБазе(ПризнакФайловогоРежима, 0);
	ИмяФайлаЗапускаПриложенияВРежимеПредприятия = КаталогПрограммы() + ИмяФайлаЗапускаПриложенияВРежимеПредприятия;
	
	ПараметрПутиКИнформационнойБазе = ?(ПризнакФайловогоРежима, "/F", "/S") + ПутьКИнформационнойБазе; 
	СтрокаПутиКИнформационнойБазе	= ?(ПризнакФайловогоРежима, ПутьКИнформационнойБазе, "");
	
	Результат = СтрЗаменить(Результат, "[ИменаФайловОбновления]"				, ИменаФайловОбновления);
	Результат = СтрЗаменить(Результат, "[ИмяИсполняемогоФайлаПрограммы]"		, ПодготовитьТекст(ИмяИсполняемогоФайлаПрограммы));
	Результат = СтрЗаменить(Результат, "[ИмяФайлаЗапускаПриложенияВРежимеПредприятия]", ПодготовитьТекст(ИмяФайлаЗапускаПриложенияВРежимеПредприятия));
	Результат = СтрЗаменить(Результат, "[ПараметрПутиКИнформационнойБазе]"		, ПодготовитьТекст(ПараметрПутиКИнформационнойБазе));
	Результат = СтрЗаменить(Результат, "[СтрокаПутиКФайлуИнформационнойБазы]"	, ПодготовитьТекст(ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(СтрЗаменить(СтрокаПутиКИнформационнойБазе, """", "")) +
	"1Cv8.1CD"));
	Результат = СтрЗаменить(Результат, "[СтрокаСоединенияИнформационнойБазы]"	, ПодготовитьТекст(СтрокаСоединенияИнформационнойБазы));
	Результат = СтрЗаменить(Результат, "[ПараметрыАутентификацииПользователя]"	, ПодготовитьТекст(СтруктураПараметров.ПараметрыСкрипта.ПараметрыАутентификации));
	Результат = СтрЗаменить(Результат, "[СобытиеЖурналаРегистрации]"			, ПодготовитьТекст(СтруктураПараметров.СобытиеЖурналаРегистрации));
	Результат = СтрЗаменить(Результат, "[АдресЭлектроннойПочты]", 
	"");
	Результат = СтрЗаменить(Результат, "[ИмяАдминистратораОбновления]"			, ПодготовитьТекст(ИмяПользователя()));
	Результат = СтрЗаменить(Результат, "[СоздаватьРезервнуюКопию]"				,"true");
	СтрокаКаталога = ПроверитьКаталогНаУказаниеКорневогоЭлемента(Объект.КаталогСРезервнымиКопиями);
	
	Результат = СтрЗаменить(Результат, "[КаталогРезервнойКопии]"				,ПодготовитьТекст(СтрокаКаталога+"\backup"+СтрокаКаталогаИзДаты()));
	Результат = СтрЗаменить(Результат, "[ВосстанавливатьИнформационнуюБазу]"	, "false");
	Результат = СтрЗаменить(Результат, "[БлокироватьСоединенияИБ]"				, ?(СтруктураПараметров.ИнформационнаяБазаФайловая, "false", "true"));
	Результат = СтрЗаменить(Результат, "[ИмяCOMСоединителя]"					, ПодготовитьТекст(СтруктураПараметров.ИмяCOMСоединителя));
	Результат = СтрЗаменить(Результат, "[ИспользоватьCOMСоединитель]"			, ?(СтруктураПараметров.ЭтоБазоваяВерсияКонфигурации, "false", "true"));
	Результат = СтрЗаменить(Результат, "[ВыполнитьПриЗавершенииРаботы]"			, ?(Параметры.РежимРаботы = "ВыполнитьПриЗавершенииРаботы", "true", "false"));
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПроверитьКаталогНаУказаниеКорневогоЭлемента(СтрокаКаталога)
	
	Если Прав(СтрокаКаталога, 2) = ":\" Тогда
		Возврат Лев(СтрокаКаталога, СтрДлина(СтрокаКаталога) - 1) ;
	Иначе
		Возврат СтрокаКаталога;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция СтрокаКаталогаИзДаты()
	
	СтрокаВозврата = "";
	ДатаСейчас = ТекущаяДатаСеанса();
	СтрокаВозврата = Формат(ДатаСейчас, "ДФ = гггг_ММ_дд_ЧЧ_мм_сс");
	Возврат СтрокаВозврата;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПодготовитьТекст(Знач Текст)
	
	Возврат "'" + СтрЗаменить(Текст, "\", "\\") + "'";
	
КонецФункции

&НаСервере
Функция ПолучитьСтрокуСоединенияИИнформациюОСоединениях(СообщенияДляЖурналаРегистрации)
	
	// запись накопленных событий ЖР
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	Результат = ПолучитьИнформациюОНаличииСоединений();
	Результат.Вставить("СтрокаСоединенияИнформационнойБазы", 
		СоединенияИБКлиентСервер.ПолучитьСтрокуСоединенияИнформационнойБазы(0));
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИнформациюОНаличииСоединений(СообщенияДляЖурналаРегистрации = Неопределено)
	
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Структура("НаличиеАктивныхСоединений, НаличиеCOMСоединений, НаличиеСоединенияКонфигуратором, ЕстьАктивныеПользователи",
								Ложь,
								Ложь,
								Ложь,
								Ложь);
	
	Если ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() > 0 Тогда 
		Результат.ЕстьАктивныеПользователи = Истина;
	КонецЕсли;
	
	МассивСеансов = ПолучитьСеансыИнформационнойБазы();
	Если МассивСеансов.Количество() = 1 Тогда 
		Возврат Результат;
	КонецЕсли;
	
	Результат.НаличиеАктивныхСоединений = Истина;
	
	Для Каждого Сеанс Из МассивСеансов Цикл
		Если ЭтоCOMСоединение(Сеанс) Тогда 
			 Результат.НаличиеCOMСоединений = Истина;
		ИначеЕсли ЭтоСеансКонфигуратором(Сеанс) Тогда 
			Результат.НаличиеСоединенияКонфигуратором = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоСеансКонфигуратором(СеансИнформационнойБазы)
	
	Возврат ВРег(СеансИнформационнойБазы.ИмяПриложения) = ВРег("Designer");
	
КонецФункции 

&НаСервереБезКонтекста
Функция ЭтоCOMСоединение(СеансИнформационнойБазы)
	
	Возврат ВРег(СеансИнформационнойБазы.ИмяПриложения) = ВРег("COMConnection");
	
КонецФункции 

&НаКлиенте
Процедура НадписьОбновитьВерсиюКомпонентыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель();
КонецПроцедуры

#КонецОбласти
