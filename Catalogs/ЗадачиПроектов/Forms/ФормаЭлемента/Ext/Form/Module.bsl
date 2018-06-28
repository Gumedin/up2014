﻿

&НаКлиенте
Процедура Группа1ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница.Имя = "ДиаграммаГанта" Тогда
		СформироватьДиаграммуГанта( Объект.Ссылка );
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЦепочкуРабот( ЗадачаПроекта )
	Возврат УП_РаботыСервер.ПолучитьЦепочкуРабот( ЗадачаПроекта );
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВехи( ЗадачаПроекта )
	Возврат УП_РаботыСервер.ПолучитьВехи(ЗадачаПроекта);
КонецФункции

&НаСервереБезКонтекста
Функция МассивНеРабочихДней( НачалоПолногоИнтервала, КонецПолногоИнтервала )
	Возврат УП_РаботыСервер.МассивНеРабочихДней( НачалоПолногоИнтервала, КонецПолногоИнтервала );
КонецФункции

&НаКлиенте
Процедура СформироватьДиаграммуГанта( ЗадачаПроекта )
	Если ЗадачаПроекта.Пустая() Тогда
		ПоказатьПредупреждение(, "Укажите задачу проекта!", 10);
		Возврат;
	КонецЕсли;
	
	// дерево работ
	Цепочка = ПолучитьЦепочкуРабот( ЗадачаПроекта );
	// вехи 
	Вехи	= ПолучитьВехи(ЗадачаПроекта);

	
	СхемаРабот.Очистить();
	СхемаРабот.ОтображатьЗаголовок				= Ложь;
	СхемаРабот.АвтоОпределениеПолногоИнтервала 	= Истина;
	СхемаРабот.ЕдиницаПериодическогоВарианта 	= ТипЕдиницыШкалыВремени.День;
	СхемаРабот.ОтображениеИнтервала  			= ОтображениеИнтервалаДиаграммыГанта.Плоский;
	СхемаРабот.ОтображениеТекстаЗначения		= ОтображениеТекстаЗначенияДиаграммыГанта.Право;
	
	//
	СхемаРабот.ОтображатьЛегенду=Ложь;
	
	// одна серия
	Серия = СхемаРабот.Серии.Добавить();
	СформироватьДиаграммуПоСтруктуреЗадач( СхемаРабот, Серия, Цепочка, Вехи );
	
	СхемаРабот.ПоказатьУровеньТочек(0);
	СхемаРабот.Обновление = Истина;
		
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДиаграммуПоСтруктуреЗадач( СхемаРабот, Серия, Цепочка, Вехи )
	Перем СуммарныеТочки;
	
	ПредыдущийИнтервал = Неопределено;
	Для Н = 0 ПО Цепочка.Количество()-1 Цикл
		Звено = Цепочка[Н];
		Звено.Свойство("Суммарные", СуммарныеТочки );
		ЕстьСуммарныеТочки = (СуммарныеТочки.Количество() <> 0);
		
		Если  ЕстьСуммарныеТочки Тогда
			// иерархия в порядке сверху вниз
			РодительСуммарнойТочки = Неопределено;
			Для Каждого ЗначениеТочки из СуммарныеТочки Цикл  // массив
				
				СуммарнаяТочка 	= НайтиТочкуДиаграммыПоЗначению( СхемаРабот, ЗначениеТочки, РодительСуммарнойТочки );
				// для следующей точки
				РодительСуммарнойТочки = СуммарнаяТочка.Значение;
				
				ЗначениеСТ 		= СхемаРабот.ПолучитьЗначение( СуммарнаяТочка, Серия );
				Если ЗначениеСТ.Количество() = 0 Тогда  
					ИнтервалСТ = ДобавитьИнтервал( ЗначениеСТ, Дата(2999,1,1), Дата(1,1,1), WebЦвета.СинеСерый);
					
				Иначе
					Для Каждого ИнтервалСТ ИЗ ЗначениеСТ Цикл
						Прервать;
					КонецЦикла;
				КонецЕсли;
				
				ИнтервалСТ.Начало 	= МИН( ИнтервалСТ.Начало, НачалоДня(Звено.РаннийСтарт));
				ИнтервалСТ.Конец 	= МАКС( ИнтервалСТ.Конец, КонецДня(Звено.РаннийФиниш));
				
			КонецЦикла;
		КонецЕсли;			
		
			
		Если Н = 0 Тогда
			РодительТочки 	=?(ЕстьСуммарныеТочки, СуммарнаяТочка.Значение, Неопределено);
		Иначе
			РодительТочки 	=?(ЕстьСуммарныеТочки, СуммарнаяТочка.Значение, Цепочка[Н-1].Работа);
		КонецЕсли;
		Точка 			= СхемаРабот.УстановитьТочку( Звено.Работа, РодительТочки );
		
		//
		ЗначениеДГ  		= СхемаРабот.ПолучитьЗначение( Точка, Серия );
		ЗначениеДГ.Текст	= Звено.НазваниеИнтервала;
		Если Звено.ПроцентВыполнения <> 0 Тогда
		// разбиваем на два интервала
			ДатаВыполнения = ПолучитьДатуВыполнения( Звено );
			// выполнено
			ИнтервалН 		= ДобавитьИнтервал( ЗначениеДГ, НачалоДня(Звено.РаннийСтарт), КонецДня(ДатаВыполнения), WebЦвета.Коричневый);
			ИнтервалОст		= ИнтервалН;
			
			Если ДатаВыполнения <> Звено.РаннийФиниш Тогда
			// остаток  работ
				НачалоОстаткаРабот 	= НачалоДня(ДатаВыполнения) + 24 * 60 * 60;
				ИнтервалОст 		= ДобавитьИнтервал( ЗначениеДГ, НачалоОстаткаРабот, КонецДня(Звено.РаннийФиниш), WebЦвета.ПесочноКоричневый);
			КонецЕсли;
			
		Иначе
			ИнтервалН 		= ДобавитьИнтервал( ЗначениеДГ, НачалоДня(Звено.РаннийСтарт), КонецДня(Звено.РаннийФиниш), WebЦвета.ПесочноКоричневый);
			ИнтервалОст		= ИнтервалН;
		КонецЕсли;
		
		
		Если Н <> 0 Тогда
			Связь = ПредыдущийИнтервал.Добавить( ИнтервалН );
		КонецЕсли;
		
		ПредыдущийИнтервал = ИнтервалОст;
			
	КонецЦикла;
	
	// отрисовываем вехи
	//СхемаРабот.ОбластьПостроения.ШкалаВремени.Элементы.Вставить(
	Если СхемаРабот.ОбластьПостроения.ШкалаВремени.Элементы.Количество() < 2 Тогда
		ЭлМеток = СхемаРабот.ОбластьПостроения.ШкалаВремени.Элементы.Добавить();
		ЭлМеток.Единица = ТипЕдиницыШкалыВремени.День;
		ЭлМеток.ОтображатьПериодическиеМетки=Ложь;
		Для Каждого Веха из Вехи Цикл
			Метка = ЭлМеток.Метки.Добавить( Веха.Дата );
			Метка.Текст = Веха.Наименование;
			Метка.ЦветТекста = ?(Веха.Закрыта, WebЦвета.Черный, WebЦвета.Красный );
			Метка.ЦветЛинии  = Метка.ЦветТекста;
		КонецЦикла;
	КонецЕсли;
	
	// отрисовываем выходные дни
	СхемаРабот.ИнтервалыФона.Очистить();
	ДниСхемыРабот = МассивНеРабочихДней( СхемаРабот.НачалоПолногоИнтервала,  СхемаРабот.КонецПолногоИнтервала);
	Для Каждого День ИЗ ДниСхемыРабот Цикл
		Выходной = СхемаРабот.ИнтервалыФона.Добавить(НачалоДня(День), КонецДня(День));
		Выходной.Цвет = WebЦвета.СветлоСерый;
		
	КонецЦикла;
		
	
КонецПроцедуры

&НаКлиенте
Функция ДобавитьИнтервал( ЗначениеДГ, Начало, Конец, Цвет )
	Интервал = ЗначениеДГ.Добавить();
	Интервал.Начало = Начало;
	Интервал.Конец  = Конец;
	Интервал.Цвет   = Цвет;
	Возврат Интервал;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДатуВыполнения( Звено )
	ВыполненоДней  = Окр( Звено.ПроцентВыполнения / 100 * Звено.Продолжительность, 0); 
	ДатаВыполнения = УП_РаботыСервер.НоваяРабочаяДата( Звено.РаннийСтарт, ВыполненоДней-1);
	Возврат МИН( ДатаВыполнения, Звено.РаннийФиниш) ;
КонецФункции

&НаКлиенте
Функция НайтиТочкуДиаграммыПоЗначению( СхемаРабот, ЗначениеТочки, ЗначениеРодителя  )
	Для Каждого Точка ИЗ СхемаРабот.Точки Цикл
		Если Точка.Значение = ЗначениеТочки Тогда
			Возврат Точка;
		КонецЕсли;
	КонецЦикла;
	Точка = СхемаРабот.УстановитьТочку( ЗначениеТочки, ЗначениеРодителя );
	Возврат Точка
	
КонецФункции
&НаСервере
Функция НаименованиеЗадачи( ТиповаяЗадача, Проект )
	
	//Добавлено по задаче #131409 28.06.2018 Гумедин А.Г.
	//Добавляем префикс к имени задачи с кодом проекта
	ПолноеНаименование = СокрЛП(Объект.Владелец.Код) + ", " + СокрЛП(ТиповаяЗадача) + ", " + СокрЛП( Проект.Контрагент);
	
	Возврат ПолноеНаименование;
КонецФункции

&НаКлиенте
Процедура СформироватьНаименованиеЗадачи(Команда)
	Объект.Наименование = НаименованиеЗадачи( Объект.ТиповаяЗадача, Объект.Владелец );	
КонецПроцедуры

&НаСервереБезКонтекста
Функция  РуководительПодразделения( Подразделение )
	сР = УП_КадрыСервер.РуководительПодразделения( Подразделение, ТекущаяДата());	
	Возврат сР.Руководитель;
КонецФункции

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	Объект.ПроектМенеджер = РуководительПодразделения( Объект.Подразделение );
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзMSProject(Команда)
	Если НЕ ЕстьПраваНаЗагрузку( Объект.Ссылка ) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ЗадачаПроекта", Объект.Ссылка );
	
	ОткрытьФорму("Обработка.ИмпортПроектаИзMicrosoftProject.Форма", ПараметрыФормы, ЭтаФорма);
		
КонецПроцедуры

&НаСервере
Функция ОбновитьОбъектФормы( Параметр )
	
	ЗначениеВРеквизитФормы( Параметр.ПолучитьОбъект(), "Объект");
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Изменение_ЗадачиПроекта" Тогда
		Если Параметр = Объект.Ссылка Тогда
			ОбновитьОбъектФормы( Параметр );
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДоступностьКнопок();
КонецПроцедуры

&НаКлиенте
Процедура ДоступностьКнопок()
	//Элементы.ФормаЗагрузитьЗадачиИзMSProject.Видимость = ЕстьПраваНаЗагрузку( Объект.Ссылка );
КонецПроцедуры


//  загружать из Project можно только при соблюдении списка требований
//
&НаСервереБезКонтекста
Функция ЕстьПраваНаЗагрузку( ЗадачаПроекта )
	// если есть документы ТРВ или ТЗП, в которых указана ссылка на работу задачи проекта
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ТабельРаботПоЗадачеПроектаРабочееВремя.Ссылка
		|ИЗ
		|	Документ.ТабельРаботПоЗадачеПроекта.РабочееВремя КАК ТабельРаботПоЗадачеПроектаРабочееВремя
		|ГДЕ
		|	ТабельРаботПоЗадачеПроектаРабочееВремя.Задача.Владелец = &ЗадачаПроекта
		|	И ТабельРаботПоЗадачеПроектаРабочееВремя.Ссылка.Проведен
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ТабельУчетаРабочегоВремениРабочееВремя.Задача
		|ИЗ
		|	Документ.ТабельУчетаРабочегоВремени.РабочееВремя КАК ТабельУчетаРабочегоВремениРабочееВремя
		|ГДЕ
		|	ТабельУчетаРабочегоВремениРабочееВремя.Ссылка.Проведен
		|	И ТабельУчетаРабочегоВремениРабочееВремя.Задача.Владелец = &ЗадачаПроекта";
	
	Запрос.УстановитьПараметр("ЗадачаПроекта", ЗадачаПроекта);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат Ложь;
	КонецЦикла;

	
	// 
	Если РольДоступна(  Метаданные.Роли.ПолныеПрава ) Тогда
		Возврат Истина;
	КонецЕсли;
	//
	Если НЕ ЗначениеЗаполнено( ЗадачаПроекта ) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// только свое
	Возврат (ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо = ЗадачаПроекта.ПроектМенеджер );
	
	//мПользователей = СКД_ДоступныеФЛ( ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо );
	//Если мПользователей.Найти( ЗадачаПроекта.ПроектМенеджер ) <> Неопределено Тогда
	//	Возврат Истина;
	//КонецЕсли;
	
	Возврат Ложь;
	
	
КонецФункции

&НаСервере
Процедура ПересчетСтруктуры_НаСервере( ЗадачаПроекта )
	Если ЗначениеЗаполнено( ЗадачаПроекта ) Тогда
		ПериодРабот = УП_РаботыСервер.РасчитатьСрокиРабот( ЗадачаПроекта );
		Объект.НачалоРабот 		= ПериодРабот.ДатаНачала;
		Объект.ОкончаниеРабот 	= ПериодРабот.ДатаОкончания;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПересчетСтруктуры(Команда)
	ПересчетСтруктуры_НаСервере( Объект.Ссылка );
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДолжностьФизЛица(ФизическоеЛицо, Подразделение)
	Возврат УП_КадрыСервер.ПроизводственнаяДолжностьФизЛица(  ФизическоеЛицо, Подразделение );
КонецФункции

&НаСервереБезКонтекста
Функция СтавкаПоДолжности( Должность )
	Возврат Должность.ТарифнаяСтавка;
КонецФункции

&НаКлиенте
Процедура ИсполнителиФизическоеЛицоПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Исполнители.ТекущиеДанные;
	ТекущиеДанные.Должность =  ДолжностьФизЛица(ТекущиеДанные.ФизическоеЛицо, Объект.Подразделение);
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиДолжностьПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Исполнители.ТекущиеДанные;
	ТекущиеДанные.ТарифнаяСтавка =  СтавкаПоДолжности( ТекущиеДанные.Должность );
	// Вставить содержимое обработчика.
КонецПроцедуры



#Область формированиеГрафикаПлатежей

&НаКлиенте
Процедура ЭтапыГрафикаОплатыПриИзменении(Элемент)
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыДатаПлатежаПриИзменении(Элемент)
	ТекДанные = Элементы.ЭтапыГрафикаОплаты.ТекущиеДанные;
	ТекДанные.ДатаПлатежа = НачалоМесяца( ТекДанные.ДатаПлатежа );
КонецПроцедуры


&НаКлиенте
Процедура ЭтапыГрафикаОплатыСуммаПлатежаПриИзменении(Элемент)
	ТекДанные = Элементы.ЭтапыГрафикаОплаты.ТекущиеДанные;
	ТекДанные.ПроцентПлатежа = ТекДанные.СуммаПлатежа / Объект.Сумма * 100;
КонецПроцедуры


&НаКлиенте
Процедура ЭтапыГрафикаОплатыПроцентПлатежаПриИзменении(Элемент)
	ТекДанные = Элементы.ЭтапыГрафикаОплаты.ТекущиеДанные;
	ТекДанные.СуммаПлатежа = ТекДанные.ПроцентПлатежа * Объект.Сумма / 100;
КонецПроцедуры


// если есть колонки с фиксированными суммами, их не пересчитываем 
// если этапов нет, то добавляем один, на последний месяц платежа
&НаСервере
Процедура ПересчитатьЭтапыГрафикаПлатежа()
	ПоследнийМесяц 	= ПоследнийМесяцРаботПоЗадаче( Объект.Ссылка );
	СуммаПоЗадаче	= Объект.Сумма;
	
	СпрЗадачПроекта	= РеквизитФормыВЗначение("Объект");
	Этапы 	= СпрЗадачПроекта.ЭтапыГрафикаОплаты.Выгрузить(); 
	//Если Этапы.Количество() = 0 Тогда 
	//	Если СуммаПоЗадаче <> 0 Тогда
	//		СтрЭГО = СпрЗадачПроекта.ЭтапыГрафикаОплаты.Добавить();		
	//		СтрЭГО.ДатаПлатежа 		= ПоследнийМесяц;
	//		СтрЭГО.СуммаПлатежа		= СуммаПоЗадаче;
	//		СтрЭГО.ПроцентПлатежа	= 100;
	//	КонецЕсли;
	//КонецЕсли;
	
	Недостача =  СуммаПоЗадаче - Этапы.Итог("СуммаПлатежа");
	Если Недостача > 0 Тогда 
		СтрЭГО = Этапы.Добавить();		
		СтрЭГО.ДатаПлатежа 		= ПоследнийМесяц;
		СтрЭГО.СуммаПлатежа		= Недостача;
		//СтрЭГО.ПроцентПлатежа	= 100;
	КонецЕсли;
	
	
	
	//Иначе
	// есть колонки			
		ФиксЭтапы	= Этапы.СкопироватьКолонки();
		НеФиксЭтапы = Этапы.СкопироватьКолонки();
		СуммаФикс 	= 0;
		Для Каждого Этап ИЗ Этапы Цикл
			Если Этап.Фиксировано Тогда
				СтрФЭ		= ФиксЭтапы.Добавить();
				ЗаполнитьЗначенияСвойств( СтрФЭ, Этап );
			Иначе
				СтрНеФЭ 	= НеФиксЭтапы.Добавить();
				ЗаполнитьЗначенияСвойств( СтрНеФЭ, Этап );
			КонецЕсли;
		КонецЦикла;
		СуммаФикс 	= ФиксЭтапы.Итог("СуммаПлатежа");
		
		Если СуммаФикс < СуммаПоЗадаче Тогда
			МассивКоэфф = НеФиксЭтапы.ВыгрузитьКолонку("СуммаПлатежа");
			мСумма 		= РаспределитьПропорционально( СуммаПоЗадаче - СуммаФикс, 	МассивКоэфф);
			
			Для Каждого СтрЭГО ИЗ НеФиксЭтапы Цикл
				Индекс					= НеФиксЭтапы.Индекс(СтрЭГО);
				СтрЭГО.СуммаПлатежа 	= мСумма[Индекс];
				
				// добавляем к фиксированным платежам
				СтрФик = ФиксЭтапы.Добавить();
				ЗаполнитьЗначенияСвойств(СтрФик, СтрЭГО );
			КонецЦикла;
		КонецЕсли;
		
		// после формирования полного списка этапов расчитываем процент
		МассивКоэфф = ФиксЭтапы.ВыгрузитьКолонку("СуммаПлатежа");
		мПроц 		= РаспределитьПропорционально( 100,	МассивКоэфф);
		Для Каждого СтрЭГО ИЗ ФиксЭтапы Цикл
			Индекс					= ФиксЭтапы.Индекс(СтрЭГО);
			СтрЭГО.ПроцентПлатежа	= мПроц[Индекс];
		КонецЦикла;
		СпрЗадачПроекта.ЭтапыГрафикаОплаты.Загрузить( ФиксЭтапы ); 
		
	//КонецЕсли;
	СпрЗадачПроекта.ЭтапыГрафикаОплаты.Сортировать( "ДатаПлатежа");
	
	ЗначениеВРеквизитФормы( СпрЗадачПроекта, "Объект");
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьГрафикПлатежа(Команда)
	//Если Объект.ЭтапыГрафикаОплаты.Количество() = 0 Тогда
	//	Возврат;
	//КонецЕсли;
	//Если Объект.ЭтапыГрафикаОплаты.Количество() = 1 Тогда
	//	СтрЭГО = Объект.ЭтапыГрафикаОплаты[0];
	//	СтрЭГО.СуммаПлатежа 	= Объект.Сумма;
	//	СтрЭГО.ПроцентПлатежа 	= 100;
	//	Возврат;
	//КонецЕсли;
	
	ПересчитатьЭтапыГрафикаПлатежа();
		
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	ПересчитатьГрафикПлатежа("");
КонецПроцедуры

&НаСервере
Процедура СкорректироватьПоДоговорамНаСервере()
	ГрафикПоДоговорам = ГрафикОплатыЗадачиДоговорам( Объект.Ссылка );
	Если ГрафикПоДоговорам.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрДог ИЗ ГрафикПоДоговорам Цикл
		Отбор 	= Новый Структура("ДатаПлатежа", СтрДог.ДатаПлатежа );
		мСтроки = Объект.ЭтапыГрафикаОплаты.НайтиСтроки( Отбор );
		Если мСтроки.Количество() = 0 Тогда
			СтрГО = Объект.ЭтапыГрафикаОплаты.Добавить();
		Иначе
			СтрГО = мСтроки[0];
		КонецЕсли;
		ЗаполнитьЗначенияСвойств( СтрГО, СтрДог );
		СтрГО.Фиксировано = Истина;
	КонецЦикла;
	
	ПересчитатьЭтапыГрафикаПлатежа();
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьПоДоговорам(Команда)
	СкорректироватьПоДоговорамНаСервере();
КонецПроцедуры

&НаСервереБезКонтекста
Функция СуммаЗадачиПоСмете_НаСервере( ЗадачаПроекта )
	Возврат СуммаПоСметеЗадачиПроекта( ЗадачаПроекта, Справочники.СтатьиСметы.ДохФинансовые );
КонецФункции

&НаКлиенте
Процедура СуммаЗадачиПоСмете(Команда)
	Объект.Сумма = СуммаЗадачиПоСмете_НаСервере( Объект.Ссылка );
	//ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

#Область Флажки

&НаКлиенте
Процедура УстановитьФлажки(Колонка, Значение , Оплата)
	Если Оплата Тогда
		Для Каждого Стр ИЗ Объект.ЭтапыГрафикаОплаты Цикл
			Стр[Колонка] = Значение;
		КонецЦикла;
	Иначе	
		Для Каждого Стр ИЗ Объект.ЭтапыГрафикаРеализации Цикл
			Стр[Колонка] = Значение;
		КонецЦикла;
	КонецЕсли;
	
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажкиФиксировано(Команда)
	УстановитьФлажки("Фиксировано", Истина , Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажкиФиксировано(Команда)
	УстановитьФлажки("Фиксировано", Ложь , Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажкиГарантировано(Команда)
	УстановитьФлажки("Гарантировано", Ложь , Истина);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажкиГарантировано(Команда)
	УстановитьФлажки("Гарантировано", Истина , Истина);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьГодЗадачи( Проект, НачалоРабот )
	Если ЗначениеЗаполнено( НачалоРабот ) Тогда
		Возврат Год( НачалоРабот );
	КонецЕсли;
	Возврат Проект.ГодПроекта;
КонецФункции

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	Объект.ГодЗадачи = ПолучитьГодЗадачи( Объект.Владелец, Объект.НачалоРабот );
КонецПроцедуры

&НаКлиенте
Процедура НачалоРаботПриИзменении(Элемент)
	Объект.ГодЗадачи = ПолучитьГодЗадачи( Объект.Владелец, Объект.НачалоРабот );
КонецПроцедуры

&НаСервере
Функция ПроверкаКорректностиЗадачи()
	Отказ = Ложь;
	ГодЗадачи = Объект.ГодЗадачи;
	ГодНачала = Число(Формат(Объект.НачалоРабот,"ДФ=гггг"));
	ГодОкончания = Число(Формат(Объект.ОкончаниеРабот,"ДФ=гггг"));
		
	Если НЕ ГодЗадачи = ГодНачала Тогда 
		Сообщить("Год начала работ не соотвествует году задачи");
		Отказ = Истина;
	ИначеЕсли НЕ  ГодЗадачи = ГодОкончания Тогда
		Сообщить("Год окончания работ не соотвествует году задачи");
		Отказ = Истина;
	КонецЕсли;

	План = Объект.ЭтапыГрафикаРеализации.Итог("СуммаПлан");
	Если План <> Объект.Сумма Тогда 
		Сообщить("Сумма задачи не распределена в графике реализации.");
		Отказ = Истина;
	КонецЕсли;
	
	План = СуммаПоСметеЗадачиПроекта(Объект.Ссылка, Справочники.СтатьиСметы.ДохФинансовые);
	Если План <> 0 И План <> Объект.Сумма Тогда 
		Сообщить("Сумма задачи не равна смете.");  
		Отказ = Истина;
	КонецЕсли;
	
	Возврат Отказ;
КонецФункции

//Добавлено по задаче  #129161 18.04.2018 Гумединым А.Г.
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	// Вставить содержимое обработчика.	
	Отказ = ПроверкаКорректностиЗадачи();
КонецПроцедуры
//Добавлено по задаче #129069 Гумединым А.Г. 18.05.2018
//Обновлено по задаче #129646 Гумединым А.Г. 25.05.2018
&НаСервере
Процедура ПересчитатьГрафикРеализацииНаСервере() Экспорт  
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ОплатаРасшифровкаПлатежа.Сумма) КАК Сумма,
		|	Оплата.Акт.Дата ДатаАкта,
		|	Оплата.Дата ДатаПлатежа
		|ИЗ
		|	Документ.Оплата.РасшифровкаПлатежа КАК ОплатаРасшифровкаПлатежа
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Оплата КАК Оплата
		|		ПО ОплатаРасшифровкаПлатежа.Ссылка = Оплата.Ссылка
		|ГДЕ
		|	ОплатаРасшифровкаПлатежа.ЗадачаПроекта = &ЗадачаПроекта
		|
		|СГРУППИРОВАТЬ ПО
		|	Оплата.Акт.Дата,
		|	Оплата.Дата";
	
	Запрос.УстановитьПараметр("ЗадачаПроекта", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Структура = Новый Соответствие;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		//Обновлено по задаче #129646 Гумединым А.Г. 28.05.2018
		Если НЕ ПустаяСтрока(ВыборкаДетальныеЗаписи.ДатаАкта) Тогда 
			Дата = НачалоМесяца(ВыборкаДетальныеЗаписи.ДатаАкта);
		Иначе 
			Дата = НачалоМесяца(ВыборкаДетальныеЗаписи.ДатаПлатежа);
		КонецЕсли;	
		
		Если ПустаяСтрока(Структура[Дата]) Тогда
			Структура.Вставить(Дата, ВыборкаДетальныеЗаписи.Сумма);
		Иначе
			 Структура[Дата] =  Структура[Дата] + ВыборкаДетальныеЗаписи.Сумма;
		КонецЕсли;
		//////////////////////////////////////////////////////////// 
	КонецЦикла;	
	
	Объект.ЭтапыГрафикаРеализации.Очистить();
	ГрафикРеализации = ГрафикРеализацииЗадачиДоговорам( Объект.Ссылка );
	Для Каждого Стр ИЗ ГрафикРеализации Цикл
		СтрЭГО = Объект.ЭтапыГрафикаРеализации.Добавить();		
		СтрЭГО.ДатаРеализации = Стр.ДатаРеализации;
		СтрЭГО.СуммаПлан = Стр.СуммаПлан;
		СтрЭГО.СуммаФакт = Стр.СуммаФакт;
		СтрЭГО.ВидПлана = Стр.ВидПлана;
		//Добевлено по задаче #129646 Гумединым А.Г. 28.05.2018
		СтрЭГО.СуммаОплата = Структура[Стр.ДатаРеализации];
		Структура.Удалить(Стр.ДатаРеализации);
		////////////////////////////////////////////////////////
	КонецЦикла;
	
	//Добевлено по задаче #129646 Гумединым А.Г. 28.05.2018
	Для Каждого Стр ИЗ Структура Цикл
		СтрЭГО = Объект.ЭтапыГрафикаРеализации.Добавить();
		СтрЭГО.ДатаРеализации = Стр.Ключ;
		СтрЭГО.СуммаПлан = 0;
		СтрЭГО.СуммаФакт = 0;
		СтрЭГО.ВидПлана = Перечисления.ВидыПланаБюджета.Обеспечено;
		СтрЭГО.СуммаОплата = Стр.Значение;
	КонецЦикла;
	////////////////////////////////////////////////////////	
	
	Прогноз =  Объект.Сумма - ГрафикРеализации.Итог("СуммаПлан");
	Если Прогноз <> 0 Тогда 
		ПоследнийМесяц 	= НачалоМесяца(Объект.ОкончаниеРабот);
		СтрЭГО = Объект.ЭтапыГрафикаРеализации.Добавить();		
		СтрЭГО.ДатаРеализации = ПоследнийМесяц;
		СтрЭГО.СуммаПлан = Прогноз;
		СтрЭГО.СуммаФакт = 0;
		СтрЭГО.ВидПлана = Перечисления.ВидыПланаБюджета.Прогноз;
	КонецЕсли;
	
	//Добавлено 01.06.2018 по задаче #129786 Гумедин А.Г.        
	//Если Объект.Сумма = 0 И Объект.ИсточникФинансирования = Справочники.ИсточникФинансирования.НайтиПоНаименованию("Инвестиционный фонд") Тогда
	//	ПоследнийМесяц 	= НачалоМесяца(Объект.ОкончаниеРабот);
	//	СтрЭГО = Объект.ЭтапыГрафикаРеализации.Добавить();		
	//	СтрЭГО.ДатаРеализации = ПоследнийМесяц;
	//	СтрЭГО.СуммаПлан = 0;
	//	СтрЭГО.СуммаФакт = 0;
	//	СтрЭГО.ВидПлана = Перечисления.ВидыПланаБюджета.Прогноз;	
	//КонецЕсли
	/////////////////////////////////////////////////////////////
	
	//Добавлено 27.06.2018 по задаче #131382 Гумедин А.Г	
	Если Объект.ЭтапыГрафикаРеализации.Количество() = 0 Тогда
		ПоследнийМесяц 	= НачалоМесяца(Объект.ОкончаниеРабот);
		СтрЭГО = Объект.ЭтапыГрафикаРеализации.Добавить();		
		СтрЭГО.ДатаРеализации = ПоследнийМесяц;
		СтрЭГО.СуммаПлан = 0;
		СтрЭГО.СуммаФакт = 0;
		СтрЭГО.ВидПлана = Перечисления.ВидыПланаБюджета.Прогноз;	
	КонецЕсли
	///////////////////////////////////////////////////////////


КонецПроцедуры

//Добавлено по задаче #129069 Гумединым А.Г. 18.05.2018
&НаКлиенте
Процедура ПересчитатьГрафикРеализации(Команда)
	ПересчитатьГрафикРеализацииНаСервере();
КонецПроцедуры

//Добавлено 18.05.2018 Гумединым А.Г. по задаче #129069
&НаКлиенте
Процедура УстановитьФлажкиГарантированоОтгр(Команда)
	УстановитьФлажки("Гарантировано", Истина , Ложь);
КонецПроцедуры

//Добавлено 18.05.2018 Гумединым А.Г. по задаче #129069
&НаКлиенте
Процедура УстановитьФлажкиФиксированоОтгр(Команда)
	УстановитьФлажки("Фиксировано", Истина , Ложь);
КонецПроцедуры

//Добавлено 18.05.2018 Гумединым А.Г. по задаче #129069
&НаКлиенте
Процедура СнятьФлажкиГарантированоОтгр(Команда)
	УстановитьФлажки("Гарантировано", Ложь , Ложь);
КонецПроцедуры

//Добавлено 18.05.2018 Гумединым А.Г. по задаче #129069
&НаКлиенте
Процедура СнятьФлажкиФиксированоОтгр(Команда)
	УстановитьФлажки("Фиксировано", Ложь , Ложь);
КонецПроцедуры

//Добавлено 18.05.2018 Гумединым А.Г. по задаче #129069
&НаКлиенте
Процедура ЭтапыГрафикаРеализацииПроцентРеализацииПриИзменении(Элемент)
	ТекДанные = Элементы.ЭтапыГрафикаРеализации.ТекущиеДанные;
	ТекДанные.СуммаРеализации = ТекДанные.ПроцентРеализации * Объект.Сумма / 100;	
КонецПроцедуры

//Добавлено 18.05.2018 Гумединым А.Г. по задаче #129069
&НаКлиенте
Процедура ЭтапыГрафикаРеализацииСуммаРеализацииПриИзменении(Элемент)
	ТекДанные = Элементы.ЭтапыГрафикаРеализации.ТекущиеДанные;
	ТекДанные.ПроцентРеализации = ТекДанные.СуммаРеализации / Объект.Сумма * 100;	
КонецПроцедуры

//Добавлено 18.05.2018 Гумединым А.Г. по задаче #129069
&НаКлиенте
Процедура ЭтапыГрафикаРеализацииДатаРеализацииПриИзменении(Элемент)
	ТекДанные = Элементы.ЭтапыГрафикаРеализации.ТекущиеДанные;
	ТекДанные.ДатаРеализации = НачалоМесяца( ТекДанные.ДатаРеализации );
КонецПроцедуры

//Добавлено 18.05.2018 Гумединым А.Г. по задаче #129069
&НаСервере
Процедура ЗаполнитьГрафикиРеализацииПоДоговорамНаСервере()	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДоговорЭтапыГрафикаРеализации.ДатаРеализации КАК ДатаРеализации,
		|	СУММА(ДоговорЭтапыГрафикаРеализации.СуммаРеализации) КАК СуммаРеализации,
		|	СУММА(ДоговорЭтапыГрафикаРеализации.ПроцентРеализации) КАК ПроцентРеализации
		//|	ДоговорЭтапыГрафикаРеализации.Комментарий КАК Комментарий
		|ИЗ
		|	Документ.Договор.ЭтапыГрафикаРеализации КАК ДоговорЭтапыГрафикаРеализации
		|ГДЕ
		|	ДоговорЭтапыГрафикаРеализации.ЗадачаПроекта = &ЗадачаПроекта
		|
		|СГРУППИРОВАТЬ ПО
		|	ДоговорЭтапыГрафикаРеализации.ДатаРеализации";
		//|	ДоговорЭтапыГрафикаРеализации.Комментарий";
	
	Запрос.УстановитьПараметр("ЗадачаПроекта", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Строка = Объект.ЭтапыГрафикаРеализацииПоДоговорам.Добавить();
		Строка.ДатаРеализации = ВыборкаДетальныеЗаписи.ДатаРеализации;
		Строка.СуммаРеализации = ВыборкаДетальныеЗаписи.СуммаРеализации;
		Строка.ПроцентРеализации = ВыборкаДетальныеЗаписи.ПроцентРеализации;
		//Строка.Комментарий = ВыборкаДетальныеЗаписи.Комментарий;
	КонецЦикла;
КонецПроцедуры

//Добавлено 18.05.2018 Гумединым А.Г. по задаче #129069
&НаКлиенте
Процедура ЗаполнитьГрафикиРеализацииПоДоговорам(Команда)
	ЗаполнитьГрафикиРеализацииПоДоговорамНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПроверитьСтатусНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСтатус(Команда)
	ПроверитьСтатусНаСервере();
КонецПроцедуры

#КонецОбласти

#КонецОбласти

