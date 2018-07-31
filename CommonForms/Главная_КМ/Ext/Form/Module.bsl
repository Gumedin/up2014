﻿&НаСервере
Процедура ДобавитьТекстHTML(ТекстHTML, Элемент);
    // Ссылку будем формировать хитро:
    // Предполагаем что символ "-" не входит в имена объектов метаданных, 
    // учавствующих в формировании html
    // Тогда ссылка будет иметь следующий вид: 
    // Номенклатура-d341d377-b3b1-11dc-a100-0011d85708ff
    // Передавать нашу ссылку будем через атрибут id
    СсылкаНаЭлемент = Элемент.Метаданные().Имя+"-"
    +Элемент.Ссылка.УникальныйИдентификатор();
    ТекстHTML.ДобавитьСтроку("<A id=""" + СсылкаНаЭлемент + """ href= """ 
    + Элемент + """ >"+Элемент+"</A><BR>");
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Код_HTML_страниц.ИсходныйКодСтраницы КАК ИсходныйКодСтраницы,
		|	Код_HTML_страниц.КодСтраницы КАК КодСтраницы
		|ИЗ
		|	РегистрСведений.Код_HTML_страниц КАК Код_HTML_страниц
		|ГДЕ
		|	Код_HTML_страниц.КодСтраницы = &КодСтраницы";
	
	Запрос.УстановитьПараметр("КодСтраницы", "Главная_КМ");
	РезультатЗапроса = Запрос.Выполнить();                                                  
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выгрузить();
	
	Если ВыборкаДетальныеЗаписи.Количество() = 0 Тогда
		страница = "<HTML><BODY>Новая страница</BODY></HTML>";
	Иначе
		страница = ВыборкаДетальныеЗаписи.Получить(0).ИсходныйКодСтраницы;
	КонецЕсли;
	
	РедакторHTMLДокумента = страница;	
	
	ОбновитьСтраницу();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтраницу()
	HTMLДокумента = А_Аналитика.ОбработкаВыражений(РедакторHTMLДокумента);       
КонецПроцедуры                                                                                 

&НаСервере
Функция НайтиСсылку(Элемент)                 
    Врем = Элемент;
    Пока Врем <> Неопределено Цикл
        Если НРег(Врем.tagName) = "a" Тогда
            Возврат Врем;
        КонецЕсли;
        Врем = Врем.parentElement;
    КонецЦикла;
    Возврат Неопределено;
КонецФункции    // НайтиСсылку(Элемент)

&НаСервере
Функция ОбъектПоСсылке(СсылкаНаЭлемент)
	Объект = Неопределено;
    Разделитель = Найти(СсылкаНаЭлемент,"-");
    Если Разделитель > 0 Тогда
        // Получаем тип элемента
        ТипЭлемента = Лев(СсылкаНаЭлемент,Разделитель-1);
        // Получаем УникальныйИдентификатор
        ГУИД = Сред(СсылкаНаЭлемент,Разделитель+1);
        Объект = Справочники[ТипЭлемента].ПолучитьСсылку(
     		Новый УникальныйИдентификатор(ГУИД));
	КонецЕсли;
	
	Возврат Объект;	
КонецФункции

&НаКлиенте
Процедура ПолеHTMLДокументаПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	Объект = ОбъектПоСсылке(ДанныеСобытия.Element.id);
	ПоказатьЗначение(,Объект);
	
	// Не отработали нажатие
	ДанныеСобытия.Event.returnValue = Ложь;	
КонецПроцедуры

&НаКлиенте
Процедура Вперед(Команда)
	Элементы.ПолеHTMLДокумента.Вперед();
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	Элементы.ПолеHTMLДокумента.Назад();
КонецПроцедуры

&НаСервере
Процедура ЗаписатьВРегистр(КодСтраницы, ИсходныйКод)
	МенеджерЗаписи = РегистрыСведений.Код_HTML_страниц.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.КодСтраницы = КодСтраницы;
	МенеджерЗаписи.ИсходныйКодСтраницы = ИсходныйКод;
	МенеджерЗаписи.Записать();                            
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьВРегистр("Главная_КМ", РедакторHTMLДокумента);
	ОбновитьСтраницу()
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьСтраницу();
КонецПроцедуры
