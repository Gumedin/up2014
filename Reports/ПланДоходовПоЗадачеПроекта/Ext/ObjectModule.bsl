﻿
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
	ВнешниеНаборыДанных.Вставить("ТаблицаДоходов", РаспределениеДоходовПоЗадачеПроекта( ЗадачаПроекта ));
	
	
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
