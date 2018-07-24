﻿&НаСервере
Функция БюджетПоЗадачеПроекта( ЗадачиПроекта )   Экспорт
	//Бюджет по задаче [#129530]	
	//Формируем бюджет план/факт по задаче
	
	тзБюджет = Новый ТаблицаЗначений;
	тзБюджет.Колонки.Добавить("ЗадачаПроекта");
	тзБюджет.Колонки.Добавить("КодСтатьи");
	тзБюджет.Колонки.Добавить("Статья");
	тзБюджет.Колонки.Добавить("Месяц");
	тзБюджет.Колонки.Добавить("ТипСуммы");
	тзБюджет.Колонки.Добавить("ВидПлана");
	тзБюджет.Колонки.Добавить("СуммаПоСтатье");
	тзБюджет.Колонки.Добавить("Источник");
	
	Если ЗадачиПроекта = Неопределено Тогда 
		Сообщить("Не заданы задачи");
		Возврат тзБюджет;
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	БюджетПоМесяцам.ЗадачаПроекта КАК ЗадачаПроекта,
	               |	БюджетПоМесяцам.ЗадачаПроекта.ГодЗадачи КАК ГодЗадачаПроекта,
	               |	СтруктураСметыСтруктура.Статья КАК Статья,
	               |	БюджетПоМесяцам.Месяц КАК Месяц,
	               |	БюджетПоМесяцам.ТипСуммы КАК ТипСуммы,
	               |	БюджетПоМесяцам.ВидПлана КАК ВидПлана,
	               |	БюджетПоМесяцам.Сумма КАК СуммаПоСтатье,
	               |	БюджетПоМесяцам.Регистратор
	               |ИЗ
	               |	РегистрСведений.СтруктураСметыПоГодам КАК СтруктураСметыПоГодам
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураСметы.Структура КАК СтруктураСметыСтруктура
	               |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.БюджетПоМесяцам КАК БюджетПоМесяцам
	               |			ПО (БюджетПоМесяцам.СтатьяСметы = СтруктураСметыСтруктура.Статья)
	               |		ПО (ГОД(СтруктураСметыПоГодам.Период) = БюджетПоМесяцам.ЗадачаПроекта.ГодЗадачи)
	               |			И СтруктураСметыПоГодам.СтруктураСметы = СтруктураСметыСтруктура.Ссылка
	               |ГДЕ
	               |	БюджетПоМесяцам.ТипСуммы <> &ТипСуммы
	               |	И БюджетПоМесяцам.ЗадачаПроекта В(&ЗадачиПроекта)";
	
	Запрос.УстановитьПараметр("ЗадачиПроекта", ЗадачиПроекта);
	Запрос.УстановитьПараметр("ТипСуммы", Перечисления.ТипСуммыБюджета.ПервичныйДокумент);
	
	тзРезультат = Запрос.Выполнить().Выгрузить();
	
	//тзРезультат.Свернуть("ГодЗадачаПроекта, ЗадачаПроекта, Статья, Месяц, ТипСуммы, ВидПлана", "СуммаПоСтатье");
	
	тзПоГодам = тзРезультат.Скопировать();
	тзПоГодам.Свернуть("ГодЗадачаПроекта");
	
	тзПоПериодам = тзРезультат.Скопировать();
	тзПоПериодам.Свернуть("ГодЗадачаПроекта, ЗадачаПроекта, Месяц, ТипСуммы, ВидПлана");
	
	//По годам, т.к. может быть разная структура смет
	Для Каждого итераторГод Из тзПоГодам Цикл
		//сСметы - структура сметы
		сСметы 	= УП_СметаПроекта.ПолучитьСтруктуруСметыЗадачи( итераторГод.ГодЗадачаПроекта );
		
		Для Каждого итераторПериод Из тзПоПериодам Цикл
			Если итераторПериод.Месяц <> Null Тогда
				Для Каждого СтрСметы ИЗ сСметы Цикл
					Отбор = Новый Структура();
					Отбор.Вставить("ГодЗадачаПроекта",итераторГод.ГодЗадачаПроекта);
					Отбор.Вставить("ЗадачаПроекта", итераторПериод.ЗадачаПроекта);
					Отбор.Вставить("Месяц", итераторПериод.Месяц);
					Отбор.Вставить("ТипСуммы", итераторПериод.ТипСуммы);
					Отбор.Вставить("ВидПлана", итераторПериод.ВидПлана);
					Отбор.Вставить("Статья", СтрСметы.Значение.Статья);
					
					рез = тзРезультат.НайтиСтроки(Отбор);
					Если рез.Количество() > 0 Тогда 
						Для Каждого стр Из рез Цикл
							бюджет = тзБюджет.Добавить();
							бюджет.ЗадачаПроекта = итераторПериод.ЗадачаПроекта;
							бюджет.КодСтатьи = СтрСметы.Значение.КодСтатьи;
							бюджет.Статья = СтрСметы.Значение.Статья;
							бюджет.Месяц = итераторПериод.Месяц;
							бюджет.ТипСуммы = итераторПериод.ТипСуммы;
							бюджет.ВидПлана = итераторПериод.ВидПлана;
							бюджет.СуммаПоСтатье = стр.СуммаПоСтатье;
							бюджет.Источник = стр.Регистратор;
						КонецЦикла;
					Иначе
							бюджет = тзБюджет.Добавить();
							бюджет.ЗадачаПроекта = итераторПериод.ЗадачаПроекта;
							бюджет.КодСтатьи = СтрСметы.Значение.КодСтатьи;
							бюджет.Статья = СтрСметы.Значение.Статья;
							бюджет.Месяц = итераторПериод.Месяц;
							бюджет.ТипСуммы = итераторПериод.ТипСуммы;
							бюджет.ВидПлана = итераторПериод.ВидПлана;
							бюджет.СуммаПоСтатье = 0;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат тзБюджет;
КонецФункции

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//
	НастройкиСКД		= КомпоновщикНастроек.ПолучитьНастройки();
	
	//Получение самой СКД из макета
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	//
	
	
	//Макет компоновки
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,НастройкиСКД, ДанныеРасшифровки );
	
	// параметры из СКД
	ЗадачаПроекта	= МакетКомпоновки.ЗначенияПараметров.ЗадачаПроекта.Значение;
	
	//Связь между таблицей значений и именами в СКД
	ВнешниеНаборыДанных = Новый Структура;
//	ВнешниеНаборыДанных.Вставить("ТаблицаДоходов", РаспределениеДоходовПоЗадачеПроекта( ЗадачаПроекта ));
	ВнешниеНаборыДанных.Вставить("Бюджет", БюджетПоЗадачеПроекта( ЗадачаПроекта ));
	
	
	//Компоновка данных
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,ВнешниеНаборыДанных,ДанныеРасшифровки);

	//Вывод результата
	ДокументРезультат.Очистить(); 
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	//ДокументРезультат.Показать();

	//ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.АвтоМасштаб=Истина;
	ДокументРезультат.ОриентацияСтраницы=ОриентацияСтраницы.Ландшафт;
	
КонецПроцедуры