﻿Процедура ОбновитьПредопределенныеВидыКонтактнойИнформации() Экспорт
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат;
	КонецЕсли;
	
    // Справочник "Физический лица"
	Объект = Справочники.ВидыКонтактнойИнформации.СправочникФизическиеЛица.ПолучитьОбъект();
	Объект.Используется = Истина;
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
						
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
						Перечисления.ТипыКонтактнойИнформации.Телефон);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.МобильныйТелефонФизическогоЛица;
	ПараметрыВида.Используется = Истина;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 1;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
						Перечисления.ТипыКонтактнойИнформации.Телефон);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.РабочийТелефонФизическогоЛица;
	ПараметрыВида.Используется = Истина;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 2;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
						Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.EmailФизическогоЛица;
	ПараметрыВида.Используется = Истина;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 3;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
						Перечисления.ТипыКонтактнойИнформации.Другое);
	ПараметрыВида.Вид                               = Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияКонтрагента;
	ПараметрыВида.Используется = Истина;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.Порядок                           = 4;
	ПараметрыВида.РазрешитьВводНесколькихЗначений   = Ложь;
	ПараметрыВида.ЗапретитьРедактированиеПользователем = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
КонецПроцедуры