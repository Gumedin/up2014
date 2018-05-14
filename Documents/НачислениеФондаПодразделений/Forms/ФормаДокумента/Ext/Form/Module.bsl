﻿
&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	Объект.ПериодРегистрации = НачалоМесяца( Объект.ПериодРегистрации );
	НачислитьНаСервере();
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура НачислитьНаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.Начисления.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ФондПодразделений.Сумма) КАК Сумма,
		|	ФондПодразделений.Регистратор.ПланРабот.ЗадачаПроекта КАК ЗадачаПроекта
		|ПОМЕСТИТЬ ВТ_БазаПоЗадачам
		|ИЗ
		|	РегистрНакопления.ФондПодразделений КАК ФондПодразделений
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(ФондПодразделений.Регистратор) = ТИП(Документ.ТабельРаботПоЗадачеПроекта)
		|	И ФондПодразделений.Подразделение = &Подразделение
		|	И ФондПодразделений.Регистратор.ПериодРегистрации = &ПериодРегистрации
		|	И ФондПодразделений.Регистратор.ПланРабот.ЗадачаПроекта.Владелец.ГодПроекта >= 2017
		|
		|СГРУППИРОВАТЬ ПО
		|	ФондПодразделений.Регистратор.ПланРабот.ЗадачаПроекта
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_БазаПоЗадачам.Сумма КАК БазаРаспределения,
		|	(ЕСТЬNULL(КоэффициентФОТПодразделенийСрезПоследних.КоэффициентПланирования, 1) - 1) * 100 КАК Процент,
		|	ВТ_БазаПоЗадачам.ЗадачаПроекта,
		|	(ЕСТЬNULL(КоэффициентФОТПодразделенийСрезПоследних.КоэффициентПланирования, 1) - 1) * ВТ_БазаПоЗадачам.Сумма КАК Сумма,
		|	ВТ_БазаПоЗадачам.ЗадачаПроекта.Владелец.Код КАК ЗадачаПроектаВладелецКод
		|ИЗ
		|	ВТ_БазаПоЗадачам КАК ВТ_БазаПоЗадачам
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КоэффициентФОТПодразделений.СрезПоследних(&ПериодРегистрации, ) КАК КоэффициентФОТПодразделенийСрезПоследних
		|		ПО ВТ_БазаПоЗадачам.ЗадачаПроекта.Подразделение = КоэффициентФОТПодразделенийСрезПоследних.Подразделение
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗадачаПроектаВладелецКод";
	
	Запрос.УстановитьПараметр("ПериодРегистрации", 	Объект.ПериодРегистрации);
	Запрос.УстановитьПараметр("Подразделение", 		Объект.Подразделение);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Документ.Начисления.Загрузить( РезультатЗапроса );
	ЗначениеВРеквизитФормы(Документ, "Объект");
	
КонецПроцедуры



//&НаСервере
//Процедура НачислитьНаСервере()
//	Документ = РеквизитФормыВЗначение("Объект");
//	Документ.Начисления.Очистить();
//	
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	СУММА(ФондПодразделений.Сумма) КАК Сумма,
//		|	ФондПодразделений.Регистратор.ПланРабот.ЗадачаПроекта КАК ЗадачаПроекта
//		|ПОМЕСТИТЬ ВТ_БазаПоЗадачам
//		|ИЗ
//		|	РегистрНакопления.ФондПодразделений КАК ФондПодразделений
//		|ГДЕ
//		|	ТИПЗНАЧЕНИЯ(ФондПодразделений.Регистратор) = ТИП(Документ.ТабельРаботПоЗадачеПроекта)
//		|	И ФондПодразделений.Подразделение = &Подразделение
//		|	И ФондПодразделений.Регистратор.ПериодРегистрации = &ПериодРегистрации
//		|
//		|СГРУППИРОВАТЬ ПО
//		|	ФондПодразделений.Регистратор.ПланРабот.ЗадачаПроекта
//		|;
//		|
//		|////////////////////////////////////////////////////////////////////////////////
//		|ВЫБРАТЬ
//		|	ВТ_БазаПоЗадачам.Сумма КАК БазаРаспределения,
//		|	(ЕСТЬNULL(КоэффициентФОТПодразделенийСрезПоследних.КоэффициентПланирования, 1) - 1) * 100 КАК Процент,
//		|	ВТ_БазаПоЗадачам.ЗадачаПроекта,
//		|	(ЕСТЬNULL(КоэффициентФОТПодразделенийСрезПоследних.КоэффициентПланирования, 1) - 1) * ВТ_БазаПоЗадачам.Сумма КАК Сумма,
//		|	ВТ_БазаПоЗадачам.ЗадачаПроекта.Владелец.Код КАК ЗадачаПроектаВладелецКод
//		|ИЗ
//		|	ВТ_БазаПоЗадачам КАК ВТ_БазаПоЗадачам
//		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КоэффициентФОТПодразделений.СрезПоследних(&ПериодРегистрации, ) КАК КоэффициентФОТПодразделенийСрезПоследних
//		|		ПО ВТ_БазаПоЗадачам.ЗадачаПроекта.Подразделение = КоэффициентФОТПодразделенийСрезПоследних.Подразделение
//		|
//		|УПОРЯДОЧИТЬ ПО
//		|	ЗадачаПроектаВладелецКод";
//	
//	Запрос.УстановитьПараметр("ПериодРегистрации", 	Объект.ПериодРегистрации);
//	Запрос.УстановитьПараметр("Подразделение", 		Объект.Подразделение);
//	
//	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
//	Документ.Начисления.Загрузить( РезультатЗапроса );
//	ЗначениеВРеквизитФормы(Документ, "Объект");
//	
//КонецПроцедуры

&НаКлиенте
Процедура Начислить(Команда)
	НачислитьНаСервере();
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	НачислитьНаСервере();
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступность();
КонецПроцедуры


&НаКлиенте
Процедура УстановитьДоступность()
	Если ЭтаФорма.ТолькоПросмотр Тогда
		ЭтаФорма.Элементы.ФормаНачислить.Доступность = Ложь;
	КонецЕсли;
		
КонецПроцедуры