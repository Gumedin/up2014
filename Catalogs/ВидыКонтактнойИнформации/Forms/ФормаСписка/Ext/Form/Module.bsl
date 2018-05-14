﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПереместитьЭлементВверх()
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(Список, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлементВниз()
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(Список, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	// Проверим, выполняется ли копирование группы
	Если Копирование И Группа Тогда
		Отказ = Истина;
		
		ПоказатьПредупреждение(, НСтр("ru='Добавление новых групп в справочнике запрещено.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
