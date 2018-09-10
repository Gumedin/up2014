﻿Процедура ОбновитьПредопределенныеВидыКонтактнойИнформации() Экспорт
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроверкиАдресаРФ = Новый Структура;
	ПараметрыПроверкиАдресаРФ.Вставить("ТолькоНациональныйАдрес", Истина);
	ПараметрыПроверкиАдресаРФ.Вставить("ПроверятьКорректность", Ложь);
	ПараметрыПроверкиАдресаРФ.Вставить("СкрыватьНеактуальныеАдреса", Ложь);
	ПараметрыПроверкиАдресаРФ.Вставить("ВключатьСтрануВПредставление", Ложь);
	
    // Справочник "Контрагенты"
	Объект = Справочники.ВидыКонтактнойИнформации.СправочникКонтрагенты.ПолучитьОбъект();
	Объект.Используется = Истина;
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
						
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
						Перечисления.ТипыКонтактнойИнформации.Адрес);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента;
	ПараметрыВида.Используется = Истина;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Ложь;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Истина;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 1;
	ПараметрыВида.РазрешитьВводНесколькихЗначений      = Ложь;
	ПараметрыВида.ЗапретитьРедактированиеПользователем = Истина;
	ЗаполнитьЗначенияСвойств(ПараметрыВида.НастройкиПроверки, ПараметрыПроверкиАдресаРФ);
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
						Перечисления.ТипыКонтактнойИнформации.Адрес);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагента;
	ПараметрыВида.Используется = Истина;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Ложь;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Истина;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 2;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	ПараметрыВида.ЗапретитьРедактированиеПользователем = Истина;
	ЗаполнитьЗначенияСвойств(ПараметрыВида.НастройкиПроверки, ПараметрыПроверкиАдресаРФ);
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
						Перечисления.ТипыКонтактнойИнформации.Адрес);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресКонтрагента;
	ПараметрыВида.Используется = Истина;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 3;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	ПараметрыВида.ЗапретитьРедактированиеПользователем = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
						Перечисления.ТипыКонтактнойИнформации.Телефон);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента;
	ПараметрыВида.Используется = Истина;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 4;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
						Перечисления.ТипыКонтактнойИнформации.Факс);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.ФаксКонтрагента;
	ПараметрыВида.Используется = Истина;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 5;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	ПараметрыВида.ЗапретитьРедактированиеПользователем = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
						Перечисления.ТипыКонтактнойИнформации.Другое);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияКонтрагента;
	ПараметрыВида.Используется = Истина;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 6;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	ПараметрыВида.ЗапретитьРедактированиеПользователем = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
КонецПроцедуры