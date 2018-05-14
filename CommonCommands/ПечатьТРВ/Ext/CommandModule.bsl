﻿&НаСервере
Функция СтруктураПараметровПоТабелю( ПараметрКоманды )
	СтрП = Новый Структура;
	СтрП.Вставить("ПериодРегистрации", 	ПараметрКоманды.ПериодРегистрации);
	СтрП.Вставить("ФизическоеЛицо", 	ПараметрКоманды.ФизическоеЛицо);
	
	Возврат СтрП;
	
КонецФункции

&НаКлиенте
Функция ВывестиОтчетСПериодом(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыОповещения = Новый  Структура;
	
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить( ПараметрКоманды );
	ПараметрыОповещения.Вставить("МассивОбъектов", 				МассивОбъектов);
	ПараметрыОповещения.Вставить("ПараметрыВыполненияКоманды",  ПараметрыВыполненияКоманды);
	
	Если 		ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.ТабельУчетаРабочегоВремени") Тогда
		СтрПар = СтруктураПараметровПоТабелю( ПараметрКоманды );
		Период = Новый СтандартныйПериод;
		Период.ДатаНачала 		= НачалоМесяца( СтрПар.ПериодРегистрации );
		Период.ДатаОкончания 	= КонецМесяца( СтрПар.ПериодРегистрации );
		
		ПараметрыОповещения.Вставить("ФизическоеЛицо",  СтрПар.ФизическоеЛицо);
		ПараметрыОповещения.Вставить("ТипПараметра", 1 );
		ПараметрыОповещения.Вставить("ЗаголовокФормы", "Табель РВ за " + ПредставлениеПериода(Период.ДатаНачала, Период.ДатаОкончания ) + 
									  ". "+ СтрПар.ФизическоеЛицо ); 
		
		ВывестиОтчет( Период, ПараметрыОповещения );
		
	Иначе
		// для физического лица
		Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
			ПараметрыОповещения.Вставить("ТипПараметра", 1 );
			ПараметрыОповещения.Вставить("ФизическоеЛицо",  ПараметрКоманды );
		Иначе
			ПараметрыОповещения.Вставить("ТипПараметра", 2 );
			ПараметрыОповещения.Вставить("ФизическоеЛицо",  "" );
		КонецЕсли;
		ПараметрыОповещения.Вставить("Основание",  ПараметрКоманды );
		ПараметрыОповещения.Вставить("ЗаголовокФормы", "Табель работ по " + ПараметрКоманды ); 
		
		// 		
		Диалог = Новый ДиалогРедактированияСтандартногоПериода;
		Диалог.Период.Вариант = ВариантСтандартногоПериода.ПрошлыйМесяц;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВывестиОтчет", ЭтотОбъект, ПараметрыОповещения );
		Диалог.Показать(ОписаниеОповещения);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВывестиОтчет( Период, ПараметрыОповещения )
	Если Период = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Период", 			Период );
	ДополнительныеПараметры.Вставить("ТипПараметра", 	ПараметрыОповещения.ТипПараметра );
	ДополнительныеПараметры.Вставить("ФизическоеЛицо", 	ПараметрыОповещения.ФизическоеЛицо );
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ДополнительныеПараметры", ДополнительныеПараметры );
	ПараметрыПечати.Вставить("ЗаголовокФормы", 			ПараметрыОповещения.ЗаголовокФормы );
	
	
	//Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены( ПараметрыОповещения.МассивОбъектов, ПараметрыОповещения.ПараметрыВыполненияКоманды.Источник) Тогда
	//УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ТабельУчетаРабочегоВремени", "ТабельРВ", 
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Отчет.ПечатьТабеляРабочегоВремени", "ТабельРВ", 
			ПараметрыОповещения.МассивОбъектов, ПараметрыОповещения.ПараметрыВыполненияКоманды.Источник, ПараметрыПечати);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ВывестиОтчетСПериодом(ПараметрКоманды, ПараметрыВыполненияКоманды);
	
КонецПроцедуры
