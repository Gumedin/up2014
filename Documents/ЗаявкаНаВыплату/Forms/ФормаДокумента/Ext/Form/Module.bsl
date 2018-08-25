﻿// статьи для ввбора и ручного ввода бюджета расходов
//Изменено по задаче #132943 21.08.2018 ГумединАГ
&НаСервереБезКонтекста
Функция мКлМен(Год)
	Возврат МассивКлиентМенджеров(Год)
КонецФункции

&НаСервере
Функция ДоступныеПроекты( КлиентМенеджер );
	// только по клиент менеджеру
	Если НЕ ЗначениеЗаполнено( КлиентМенеджер ) Тогда
		Возврат Неопределено;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВознаграждениеПосредникаОстатки.Проект,
		|	ВознаграждениеПосредникаОстатки.СуммаОстаток
		|ИЗ
		|	РегистрНакопления.ВознаграждениеПосредника.Остатки(, Проект.МенеджерПроекта = &КлиентМенеджер) КАК ВознаграждениеПосредникаОстатки
		|ГДЕ
		|	ВознаграждениеПосредникаОстатки.СуммаОстаток > 0";
		
	Запрос.УстановитьПараметр("КлиентМенеджер", КлиентМенеджер);
	Результат = Запрос.Выполнить().Выгрузить();

	м = Результат.ВыгрузитьКолонку("Проект");
	Возврат м;
КонецФункции

&НаСервере
Функция ДоступныеПосредники( Проект )
	Если НЕ ЗначениеЗаполнено( Проект ) Тогда
		Возврат Неопределено;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВознаграждениеПосредникаОстатки.Посредник,
		|	ВознаграждениеПосредникаОстатки.СуммаОстаток
		|ИЗ
		|	РегистрНакопления.ВознаграждениеПосредника.Остатки(, Проект = &Проект) КАК ВознаграждениеПосредникаОстатки
		|ГДЕ
		|	ВознаграждениеПосредникаОстатки.СуммаОстаток > 0";
		
	Запрос.УстановитьПараметр("Проект", Проект);
	Результат = Запрос.Выполнить().Выгрузить();

	м = Результат.ВыгрузитьКолонку("Посредник");
	Возврат м;
КонецФункции

&НаКлиенте
Процедура КлиентМенеджерНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// клиент менеджеры
	//Изменено по задаче #132943 21.08.2018 ГумединАГ
	Год = Формат(Дата(Объект.Дата),"ДФ=гггг");
	мКМ = мКлМен(Год);
	Если мКМ = Неопределено Тогда
	ИначеЕсли мКМ.Количество()  <>   0 Тогда
		ЭтаФорма.Элементы.КлиентМенеджер.РежимВыбораИзСписка=Истина;
		ЭтаФорма.Элементы.КлиентМенеджер.СписокВыбора.ЗагрузитьЗначения( мКМ );
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроектНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	мДоступныхПроектов = ДоступныеПроекты( Объект.КлиентМенеджер );
	Если мДоступныхПроектов <>  Неопределено Тогда
		ЭтаФорма.Элементы.Проект.РежимВыбораИзСписка	=	Истина;
		ЭтаФорма.Элементы.Проект.СписокВыбора.ЗагрузитьЗначения( мДоступныхПроектов );
	Иначе
		// сбрасываем проект
		Объект.Проект 			= "";
		СтандартнаяОбработка 	= Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПосредникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УстановитьПереченьПосредников();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОстатокВознаграждения( Проект, Посредник )
	Возврат УП_СметаПроекта.ПолучитьОстатокВознагражденияПоПроекту( Проект, Посредник );
КонецФункции

&НаКлиенте
Процедура УстановитьПереченьПосредников()
	мДоступныхПосредников = ДоступныеПосредники( Объект.Проект );
	Если мДоступныхПосредников <> Неопределено Тогда
		ЭтаФорма.Элементы.Посредник.РежимВыбораИзСписка	=	Истина;
		ЭтаФорма.Элементы.Посредник.СписокВыбора.ЗагрузитьЗначения( мДоступныхПосредников );
	Иначе
		// сбрасываем проект
		Объект.Посредник 		= "";
		СтандартнаяОбработка 	= Ложь;
	КонецЕсли;
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьОстатокВознаграждения()
	ОстатокВознаграждения = ПолучитьОстатокВознаграждения( Объект.Проект, Объект.Посредник );
КонецПроцедуры

&НаКлиенте
Процедура ПроектПриИзменении(Элемент)
	УстановитьПереченьПосредников();
	УстановитьОстатокВознаграждения();
	СформироватьПодтверждение(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПосредникПриИзменении(Элемент)
	УстановитьОстатокВознаграждения();
	СформироватьПодтверждение(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиПриИзменении(Элемент)
	Объект.СуммаДокумента = Объект.Задачи.Итог("КВыплате");
	УстановитьОстатокВознаграждения();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьПереченьПосредников();
	УстановитьОстатокВознаграждения();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	УстановитьОстатокВознаграждения();
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = 
	    "ВЫБРАТЬ
	    |	ВознаграждениеПосредникаОстаткиИОбороты.ЗадачаПроекта КАК ЗадачаПроекта,
	    |	ВознаграждениеПосредникаОстаткиИОбороты.СуммаКонечныйОстаток КАК КВыплате,
	    |	ВознаграждениеПосредникаОстаткиИОбороты.СуммаПриход КАК Приход,
	    |	ВознаграждениеПосредникаОстаткиИОбороты.СуммаРасход КАК Расход
	    |ИЗ
	    |	РегистрНакопления.ВознаграждениеПосредника.ОстаткиИОбороты КАК ВознаграждениеПосредникаОстаткиИОбороты
	    |ГДЕ
	    |	ВознаграждениеПосредникаОстаткиИОбороты.Проект = &Проект
	    |	И ВознаграждениеПосредникаОстаткиИОбороты.Посредник = &Посредник";
	
	Запрос.УстановитьПараметр("Проект", Объект.Проект);
	Запрос.УстановитьПараметр("Посредник", Объект.Посредник);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Объект.Задачи.Очистить();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Задача = Объект.Задачи.Добавить();
		Задача.Задача = ВыборкаДетальныеЗаписи.ЗадачаПроекта;
		Задача.Приход = ВыборкаДетальныеЗаписи.Приход;
		Задача.КВыплате = ВыборкаДетальныеЗаписи.КВыплате;
		Задача.Расход = ВыборкаДетальныеЗаписи.Расход;
	КонецЦикла;
	
	Объект.СуммаДокумента = Объект.Задачи.Итог("КВыплате");
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПодтверждение(Команда)
	Если Объект.Проведен Тогда
        Оповещение = Новый ОписаниеОповещения(
                    "СформироватьНаКлиенте",
                    ЭтотОбъект);
        ПоказатьВопрос(Оповещение, "Докумен будет распроведен и перезаписан. Продолжить?", РежимДиалогаВопрос.ДаНет);
	Иначе
		СформироватьНаКлиенте(КодВозвратаДиалога.Да,);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНаКлиенте(Результат, Параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если Объект.Проведен Тогда
			ПараметрыЗаписи = Новый Структура;
			ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.ОтменаПроведения);
			Записать(ПараметрыЗаписи);
		КонецЕсли;
		
		СформироватьНаСервере();
		УстановитьОстатокВознаграждения();
	КонецЕсли;   
КонецПроцедуры

