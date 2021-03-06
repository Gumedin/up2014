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
	ГодПроекта		= МакетКомпоновки.ЗначенияПараметров.ГодПроекта.Значение;
	ГодЗадач		= МакетКомпоновки.ЗначенияПараметров.ГодЗадач.Значение;
	//КлиентМенеджер	= МакетКомпоновки.ЗначенияПараметров.КлиентМенеджер.Значение;
	СтатусыПроектов	= МакетКомпоновки.ЗначенияПараметров.СтатусыПроектов.Значение;
	ВключатьОбеспеченоПрошлымиПериодами = МакетКомпоновки.ЗначенияПараметров.ВключатьОбеспеченоПрошлымиПериодами.Значение;
	
	//Связь между таблицей значений и именами в СКД
	ВнешниеНаборыДанных = Новый Структура;
	ТаблицаДоходов		= РаспределениеДоходовПоПроектам( ГодПроекта, ГодЗадач, СтатусыПроектов, ВключатьОбеспеченоПрошлымиПериодами );
	Если ТаблицаДоходов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ВнешниеНаборыДанных.Вставить("ТаблицаДоходов", ТаблицаДоходов);
	
	
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
