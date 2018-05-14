﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерезаписатьВыполнить()
	
	СтруктураВозврата = Новый Структура("ПрименитьДляВсех, КодВозврата", 
		ПрименитьДляВсех, КодВозвратаДиалога.Да);
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПропуститьВыполнить()
	
	СтруктураВозврата = Новый Структура("ПрименитьДляВсех, КодВозврата", 
		ПрименитьДляВсех, КодВозвратаДиалога.Пропустить);
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьВыполнить()
	
	СтруктураВозврата = Новый Структура("ПрименитьДляВсех, КодВозврата", 
		ПрименитьДляВсех, КодВозвратаДиалога.Прервать);
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьПараметрыИспользования(СтруктураПараметров) Экспорт
	
	ТекстСообщения = СтруктураПараметров.ТекстСообщения;
	ПрименитьДляВсех = СтруктураПараметров.ПрименитьДляВсех;
	УстановитьКнопкуУмолчания(СтруктураПараметров.БазовоеДействие);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьКнопкуУмолчания(ДействиеПоУмолчанию)
	
	Если ДействиеПоУмолчанию = "" или ДействиеПоУмолчанию = КодВозвратаДиалога.Пропустить Тогда
		Элементы.Пропустить.КнопкаПоУмолчанию = Истина;
	ИначеЕсли ДействиеПоУмолчанию = КодВозвратаДиалога.Да Тогда
		Элементы.Перезаписать.КнопкаПоУмолчанию = Истина;
	ИначеЕсли ДействиеПоУмолчанию = КодВозвратаДиалога.Прервать Тогда
		Элементы.Прервать.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
