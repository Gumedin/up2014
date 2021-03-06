﻿//Добавлено 03.10.2018 по задаче #133466 ГумединАГ
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Год = 2018;
	Если ВвестиЧисло(Год, "Введите год нового проекта", 4, 0) Тогда
		ВыделенныеСтроки = ПараметрыВыполненияКоманды.Источник.Элементы.Список.ВыделенныеСтроки;
    	СкопироватьПроектыНаСервере(Год, ВыделенныеСтроки);
	КонецЕсли;
КонецПроцедуры

//Добавлено 03.10.2018 по задаче #133466 ГумединАГ
&НаСервере
Процедура СкопироватьПроектыНаСервере(Год, ВыделенныеСтроки)
	//Массив проектов и их копий
	СоответствиеПроектов = Новый Соответствие; //Требуется, что бы не потерять связь между проектом и копией
	МассивПроектов = Новый Массив; //Треьуется, что бы быстро отобрать все требуеющиеся задачи
	
	Для Каждого Элем Из ВыделенныеСтроки Цикл 
		ТекПроект = Элем.Ссылка;
		НовыйПроект = ТекПроект.Скопировать();
		НовыйПроект.ГодПроекта = Год;
		НовыйПроект.Наименование = ТекПроект.Наименование + " Копия";
		НовыйПроект.Записать();
		
		СоответствиеПроектов.Вставить(Элем, НовыйПроект);
		МассивПроектов.Добавить(Элем);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗадачиПроектов.Ссылка КАК ЗадачаПроекта
		|ИЗ
		|	Справочник.ЗадачиПроектов КАК ЗадачиПроектов
		|ГДЕ
		|	ЗадачиПроектов.Владелец В(&Проекты)
		|	И ЗадачиПроектов.ПометкаУдаления = &ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Проекты", МассивПроектов);
	Запрос.УстановитьПараметр("ПометкаУдаления", Ложь);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	//Копируем так же все задачи
	ТекущаяЗадача = "";
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл					
			СкопироватьЗадачуПроектовНаСервере(
				СоответствиеПроектов.Получить(ВыборкаДетальныеЗаписи.ЗадачаПроекта.Владелец), 	//Новый проект
				ВыборкаДетальныеЗаписи.ЗадачаПроекта);
	КонецЦикла;

КонецПроцедуры

//Добавлено 03.10.2018 по задаче #133466 ГумединАГ
//Копируем так же все задачи
&НаСервере
Процедура СкопироватьЗадачуПроектовНаСервере(НовыйПроект, ЗадачаПроекта)
	
	НоваяЗадача = ЗадачаПроекта.Скопировать();
	НоваяЗадача.Наименование = НоваяЗадача.Наименование + " Копия";
	НоваяЗадача.Владелец = НовыйПроект.Ссылка;
	НоваяЗадача.ОбменДанными.Загрузка = Истина;
	НоваяЗадача.Записать();
	
	СоздатьСметуЗадачиНаСервере(НоваяЗадача);
	
КонецПроцедуры

//Добавлено 03.10.2018 по задаче #133466 ГумединАГ
//Копируем так же все сметы задачи
&НаСервере
Процедура СоздатьСметуЗадачиНаСервере(ЗадачаПроекта)
	
		СметаЗадачи = Документы.СметаЗадачиПроекта;
		НоваяСмета = СметаЗадачи.СоздатьДокумент();
		НоваяСмета.Дата = ТекущаяДата();
		НоваяСмета.ЗадачаПроекта = ЗадачаПроекта.Ссылка;
		НоваяСмета.Записать();
					
КонецПроцедуры

