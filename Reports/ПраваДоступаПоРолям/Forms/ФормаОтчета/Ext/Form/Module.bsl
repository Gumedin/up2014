﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСписокРолей()
	
	РолиПользователей = Новый СписокЗначений;
	РолиПользователей.Добавить( Метаданные.Роли.ФинансовыйДиректор);
	РолиПользователей.Добавить( Метаданные.Роли.ФинансовыйМенеджер );
	РолиПользователей.Добавить( Метаданные.Роли.КадровыйМенеджер );
	РолиПользователей.Добавить( Метаданные.Роли.КоммерческийДиректор);
	РолиПользователей.Добавить( Метаданные.Роли.КлиентМенеджер );
	РолиПользователей.Добавить( Метаданные.Роли.Логистик );
	РолиПользователей.Добавить( Метаданные.Роли.НачальникПодразделения );
	РолиПользователей.Добавить( Метаданные.Роли.РуководительПроизводства );
	РолиПользователей.Добавить( Метаданные.Роли.ПроектМенеджер );
	РолиПользователей.Добавить( Метаданные.Роли.ПроектМенеджерТП );
	РолиПользователей.Добавить( Метаданные.Роли.Сотрудник );
	Возврат РолиПользователей;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПредопределенныйДоступКДокументу( ИмяДоступа, КодДоступа, мДоступ )
	сПД = Новый Структура;
	сПД.Вставить("ИмяДоступа", ИмяДоступа );
	сПД.Вставить("КодДоступа", КодДоступа );
	Доступ 			= Новый Массив;
	Для Каждого Право ИЗ мДоступ Цикл
		Доступ.Добавить( Право );
	КонецЦикла;
	сПД.Вставить("Доступ", Доступ );
	Возврат сПД;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаполнитьСписокТиповыхДоступовКДокументам()
	мДоступов = Новый Массив;
	// 1
	м = Новый Массив;
	//Доступ = ПредопределенныйДоступКДокументу( "Нет","N", м);
	Доступ = ПредопределенныйДоступКДокументу( "Нет","", м);
	мДоступов.Добавить( Доступ );
	
	// 2
	м.Добавить("Чтение");
	м.Добавить("Просмотр");
	м.Добавить("ВводПоСтроке");
	
	Доступ = ПредопределенныйДоступКДокументу( "Чтение","R", м );
	мДоступов.Добавить( Доступ );
	
	// 3
	м.Добавить("Добавление");
	м.Добавить("Изменение");
	м.Добавить("ИнтерактивноеДобавление");
	м.Добавить("Редактирование");
	м.Добавить("ИнтерактивнаяПометкаУдаления");
	м.Добавить("ИнтерактивноеСнятиеПометкиУдаления");
	
	Доступ = ПредопределенныйДоступКДокументу( "Испр.","U1", м );
	мДоступов.Добавить( Доступ );
	
	// 4
	м.Добавить("Проведение");
	м.Добавить("ИнтерактивноеПроведение");
	м.Добавить("ИнтерактивноеПроведениеНеОперативное");
	
	Доступ = ПредопределенныйДоступКДокументу( "Испр.", "U2", м );
	мДоступов.Добавить( Доступ );
	
	// 5
	м.Добавить("ОтменаПроведения");
	м.Добавить("ИнтерактивнаяОтменаПроведения");
	
	Доступ = ПредопределенныйДоступКДокументу( "Запись", "W1", м );
	мДоступов.Добавить( Доступ );
	
	// 6	
	м.Добавить("ИнтерактивноеИзменениеПроведенных");
	// запись с отменой проведения
	Доступ = ПредопределенныйДоступКДокументу( "Запись+", "W2", м );
	мДоступов.Добавить( Доступ );
	
	// 7 полные
	м.Добавить("Удаление");
	м.Добавить("ИнтерактивноеУдалениеПомеченных");
	
	Доступ = ПредопределенныйДоступКДокументу( "Полные", "F", м );
	мДоступов.Добавить( Доступ );
	
	Возврат мДоступов;
КонецФункции

&НаСервереБезКонтекста
Функция ЗаполнитьСписокТиповыхДоступовКСправочникам()
	мДоступов = Новый Массив;
	// 1
	м = Новый Массив;
	//Доступ = ПредопределенныйДоступКДокументу( "Нет","N", м);
	Доступ = ПредопределенныйДоступКДокументу( "Нет","", м);
	мДоступов.Добавить( Доступ );
	
	// 2
	м.Добавить("Чтение");
	м.Добавить("Просмотр");
	м.Добавить("ВводПоСтроке");
	
	Доступ = ПредопределенныйДоступКДокументу( "Чтение","R", м );
	мДоступов.Добавить( Доступ );
	
	// 2+
	// 2016 06 06 
	м.Добавить("Изменение");
	м.Добавить("Редактирование");
	
	Доступ = ПредопределенныйДоступКДокументу( "Чтение","R+", м );
	мДоступов.Добавить( Доступ );
	
	
	// 3
	м.Добавить("Добавление");
	//м.Добавить("Изменение");
	м.Добавить("ИнтерактивноеДобавление");
	//м.Добавить("Редактирование");
	м.Добавить("ИнтерактивнаяПометкаУдаления");
	м.Добавить("ИнтерактивноеСнятиеПометкиУдаления");
	
	Доступ = ПредопределенныйДоступКДокументу( "Испр.","W", м );
	мДоступов.Добавить( Доступ );
	
	// 4
	м.Добавить("Удаление");
	м.Добавить("ИнтерактивноеУдалениеПомеченных");
	
	Доступ = ПредопределенныйДоступКДокументу( "Полные", "F", м );
	мДоступов.Добавить( Доступ );
	
	Возврат мДоступов;
КонецФункции


&НаСервереБезКонтекста
Функция ОписаниеДоступаКДокументу()
	
	мПравоДоступа = Новый Массив;
	мПравоДоступа.Добавить("Чтение");										// 1
	мПравоДоступа.Добавить("Добавление");                                   // 2
	мПравоДоступа.Добавить("Изменение");                                    // 3
	мПравоДоступа.Добавить("Удаление");                                     // 4
	мПравоДоступа.Добавить("Проведение");                                   // 5
	мПравоДоступа.Добавить("ОтменаПроведения");                             // 6
	мПравоДоступа.Добавить("Просмотр");                                     // 7
	мПравоДоступа.Добавить("ИнтерактивноеДобавление");                      // 8
	мПравоДоступа.Добавить("Редактирование");                               // 9
	мПравоДоступа.Добавить("ИнтерактивноеУдаление");                        //10
	мПравоДоступа.Добавить("ИнтерактивнаяПометкаУдаления");                 //11
	мПравоДоступа.Добавить("ИнтерактивноеСнятиеПометкиУдаления");           //12
	мПравоДоступа.Добавить("ИнтерактивноеУдалениеПомеченных");              //13
	мПравоДоступа.Добавить("ИнтерактивноеПроведение");                      //14
	мПравоДоступа.Добавить("ИнтерактивноеПроведениеНеОперативное");         //15
	мПравоДоступа.Добавить("ИнтерактивнаяОтменаПроведения");         		//16
	мПравоДоступа.Добавить("ИнтерактивноеИзменениеПроведенных");         	//17
	мПравоДоступа.Добавить("ВводПоСтроке");         						//18
	
	Возврат мПравоДоступа;	
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеДоступаКСправочнику()
	
	мПравоДоступа = Новый Массив;
	мПравоДоступа.Добавить("Чтение");										// 1
	мПравоДоступа.Добавить("Добавление");                                   // 2
	мПравоДоступа.Добавить("Изменение");                                    // 3
	мПравоДоступа.Добавить("Удаление");                                     // 4
	мПравоДоступа.Добавить("Просмотр");                                     // 7
	мПравоДоступа.Добавить("ИнтерактивноеДобавление");                      // 8
	мПравоДоступа.Добавить("Редактирование");                               // 9
	мПравоДоступа.Добавить("ИнтерактивноеУдаление");                        //10
	мПравоДоступа.Добавить("ИнтерактивнаяПометкаУдаления");                 //11
	мПравоДоступа.Добавить("ИнтерактивноеСнятиеПометкиУдаления");           //12
	мПравоДоступа.Добавить("ИнтерактивноеУдалениеПомеченных");              //13
	мПравоДоступа.Добавить("ВводПоСтроке");         						//18
	
	Возврат мПравоДоступа;	
КонецФункции


&НаСервереБезКонтекста
Функция ДоступыСовпадают( Доступ1, Доступ2 )
	Если Доступ1.Количество() =0 И Доступ2.Количество() = 0 	Тогда 	Возврат Истина; КонецЕсли;
	Если Доступ1.Количество() <> Доступ2.Количество() 		Тогда	Возврат Ложь;	КонецЕсли;
	
	Для Каждого Право ИЗ Доступ1 Цикл
		Если Доступ2.Найти( Право ) = Неопределено Тогда Возврат Ложь; КонецЕсли;
	КонецЦикла;
	Возврат Истина;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТиповойДоступ( ОбъектМетаданных, Роль, Доступы, ТиповыеДоступы  )
	// получаем текущий доступ
	ТекущийДоступ = Новый Массив;
	Для Каждого Право ИЗ Доступы Цикл
		Если ПравоДоступа( Право, ОбъектМетаданных, Роль ) Тогда
			ТекущийДоступ.Добавить( Право );
		КонецЕсли;
	КонецЦикла;
	
	// сравниваем с типовыми доступами
	Для Каждого ТиповойДоступ ИЗ ТиповыеДоступы Цикл
		Если ДоступыСовпадают( ТекущийДоступ, ТиповойДоступ.Доступ ) Тогда
			Возврат ТиповойДоступ.КодДоступа;
		КонецЕсли;
	КонецЦикла;
	
	Возврат "неизв.";
	
КонецФункции


&НаСервере
Процедура ЗаполнитьТаблДокумент( ВидОбъектов )
	сПарам = Новый Структура;
	Если 		ВидОбъектов = "Документы" Тогда
		сПарам.Вставить("Заголовок1", 				"Права доступа к документам"); 
		сПарам.Вставить("ОписаниеДоступа",  		ОписаниеДоступаКДокументу());
		сПарам.Вставить("ТиповыеДоступы",			ЗаполнитьСписокТиповыхДоступовКДокументам());
		сПарам.Вставить("Заголовок2", 				"Права на документы по пользовательским ролям на " + Формат(ТекущаяДата(),"ДЛФ=DDT" ));
		сПарам.Вставить("ВидМетаданных",  			"Документы");
			
	ИначеЕсли 	ВидОбъектов = "Справочники" Тогда
		сПарам.Вставить("Заголовок1", "Права доступа к справочникам"); 
		сПарам.Вставить("ОписаниеДоступа",  		ОписаниеДоступаКСправочнику());
		сПарам.Вставить("ТиповыеДоступы",			ЗаполнитьСписокТиповыхДоступовКСправочникам());
		сПарам.Вставить("Заголовок2", 				"Права на справочники по пользовательским ролям на " + Формат(ТекущаяДата(),"ДЛФ=DDT" ));
		сПарам.Вставить("ВидМетаданных",  			"Справочники");
		
		
	Иначе
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблДокументСПараметрами( сПарам );
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблДокументСПараметрами( сПарам )
	ТаблДокумент.Очистить();
	
	Макет = РеквизитФормыВЗначение("Отчет").ПолучитьМакет("ДоступКОбъектамМетаданных");
	ОблШапка = Макет.ПолучитьОбласть("ШапкаТиповыхДоступов|Начало");
	//ОблШапка.Параметры.Заголовок = "Права доступа к документам";
	ОблШапка.Параметры.Заголовок  = сПарам.Заголовок1;
	ТаблДокумент.Вывести(ОблШапка);
	
	мТД = сПарам.ТиповыеДоступы; 
	Для Каждого ТД ИЗ мТД Цикл
		ОблШапкаТД = Макет.ПолучитьОбласть("ШапкаТиповыхДоступов|Доступ");
		ОблШапкаТД.Параметры.ИмяДоступа = ТД.ИмяДоступа + Символы.ПС + ТД.КодДоступа;
		ТаблДокумент.Присоединить(ОблШапкаТД);
	КонецЦикла;
	
	мДоступы 		= сПарам.ОписаниеДоступа; 
	//мТиповыеДоступы = сПарам.ТиповыеДоступы; 
	мТиповыеДоступы = сПарам.ТиповыеДоступы; 
	
	Для Н = 1 ПО мДоступы.Количество() Цикл
		ОблСтрокаН = Макет.ПолучитьОбласть("СтрокаТиповогоДоступа|Начало");
		ОблСтрокаН.Параметры.НомерТД 	= Н;
		ИмяТД	= мДоступы[Н-1];
		ОблСтрокаН.Параметры.ИмяТД 		= ИмяТД;
		
		ТаблДокумент.Вывести(ОблСтрокаН);
		Для Каждого ТД ИЗ мТД Цикл
			ОблСтрокаТД = Макет.ПолучитьОбласть("СтрокаТиповогоДоступа|Доступ");
			ОблСтрокаТД.Параметры.Доступ = ?(ТД.Доступ.Найти(ИмяТД)<> Неопределено, "+","");
			ТаблДокумент.Присоединить(ОблСтрокаТД);
		КонецЦикла;
		
	КонецЦикла;
	
	// таблица доступов по ролям
	ОблШапка = Макет.ПолучитьОбласть("ШапкаДоступаКДокументам|Начало");
	//ОблШапка.Параметры.Заголовок = "Права на документы по пользовательским ролям на " + Формат(ТекущаяДата(),"ДЛФ=DDT" );
	ОблШапка.Параметры.Заголовок 	= сПарам.Заголовок2; //"Права на документы по пользовательским ролям на " + Формат(ТекущаяДата(),"ДЛФ=DDT" );
	ОблШапка.Параметры.ВидОбъекта 	= сПарам.ВидМетаданных;
	ТаблДокумент.Вывести(ОблШапка);
	
	мРоли = ЗаполнитьСписокРолей();
	Для Каждого ТекРоль ИЗ мРоли Цикл
		ОблСтрокаТД = Макет.ПолучитьОбласть("ШапкаДоступаКДокументам|Доступ");
		ОблСтрокаТД.Параметры.ИмяДоступа = ТекРоль.Значение.Синоним;
		ТаблДокумент.Присоединить(ОблСтрокаТД);
	КонецЦикла;
	
	
	Н = 1;
	Для Каждого ОбъектМетаданных ИЗ Метаданные[сПарам.ВидМетаданных] Цикл
		// есть не нулевой доступ
		Если ЕстьДоступПоРолям( ОбъектМетаданных, мРоли, мТиповыеДоступы, мДоступы ) Тогда
			ОблШапка = Макет.ПолучитьОбласть("СтрокаДоступаКДокументам|Начало");
			ОблШапка.Параметры.НомерД 		= Н;
			ОблШапка.Параметры.ИмяОбъекта 	= ОбъектМетаданных;
			ТаблДокумент.Вывести(ОблШапка);
			//
			Для Каждого ТекРоль ИЗ мРоли Цикл
				ОблСтрокаТД = Макет.ПолучитьОбласть("СтрокаДоступаКДокументам|Доступ");
				ОблСтрокаТД.Параметры.ТиповойДоступ = ПолучитьТиповойДоступ(ОбъектМетаданных,  ТекРоль.Значение, мДоступы, мТиповыеДоступы);
				ТаблДокумент.Присоединить(ОблСтрокаТД);
			КонецЦикла;
			
			Н = Н + 1;
		КонецЕсли;
	КонецЦикла;
	
	
	
	ТаблДокумент.АвтоМасштаб = Истина;
	ТаблДокумент.ОриентацияСтраницы=ОриентацияСтраницы.Портрет;
КонецПроцедуры


Функция ЕстьДоступПоРолям( ОбъектМетаданных, мРоли, ТиповыеДоступы, Доступы )
	Для Каждого ТекРоль ИЗ мРоли Цикл
		Если ЗначениеЗаполнено( ПолучитьТиповойДоступ( ОбъектМетаданных, ТекРоль.Значение, Доступы, ТиповыеДоступы  )) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура ДоступКДокументам(Команда)
	ЗаполнитьТаблДокумент( "Документы" );
КонецПроцедуры

&НаКлиенте
Процедура ДоступКСправочникам(Команда)
	ЗаполнитьТаблДокумент( "Справочники" );
КонецПроцедуры
