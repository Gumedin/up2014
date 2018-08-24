﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НастроитьДинамическийСписок();
	
	Пользователь = Пользователи.ТекущийПользователь();
	
	Список.Параметры.УстановитьЗначениеПараметра("Редактирует", Пользователь);
	
	ПоказыватьКолонкуРазмер = РаботаСФайламиСлужебныйВызовСервера.ПолучитьПоказыватьКолонкуРазмер();
	Если ПоказыватьКолонкуРазмер = Ложь Тогда
		Элементы.СписокТекущаяВерсияРазмер.Видимость = Ложь;
	КонецЕсли;
	
	ЗавершениеРаботыПрограммы = Неопределено;
	Если Параметры.Свойство("ЗавершениеРаботыПрограммы", ЗавершениеРаботыПрограммы) Тогда 
		Ответ = ЗавершениеРаботыПрограммы;
		Если Ответ = Истина Тогда
			Элементы.ПоказыватьЗанятыеФайлыПриЗавершенииРаботы.Видимость = Ответ;
			Элементы.ГруппаКоманднойПанели.Видимость                     = Ответ;
		КонецЕсли;
	КонецЕсли;
	
	ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ПоказыватьЗанятыеФайлыПриЗавершенииРаботы", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ПриЗакрытииНаСервере();
	СтандартныеПодсистемыКлиент.УстановитьПараметрКлиента(
		"КоличествоЗанятыхФайлов", КоличествоЗанятыхФайлов);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	КоличествоЗанятыхФайлов = РаботаСФайламиСлужебный.КоличествоЗанятыхФайлов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

// Обработка события Выбор у списка.
//
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(Элемент.ТекущиеДанные.Ссылка, Неопределено, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.ОткрытьФайлСОповещением(Неопределено, ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("УстановитьДоступностьКоманд", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	СтрокаТаблицы = Элементы.Список.ТекущаяСтрока;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	РаботаСФайламиКлиент.ОткрытьФормуФайла(ТекущиеДанные.Ссылка, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	Элементы.Список.Обновить();
	
	ПодключитьОбработчикОжидания("УстановитьДоступностьКоманд", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ТекущиеДанные.Ссылка, Неопределено, УникальныйИдентификатор);
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСвойстваФайла(Команда)
	
	СтрокаТаблицы = Элементы.Список.ТекущаяСтрока;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	РаботаСФайламиКлиент.ОткрытьФормуФайла(ТекущиеДанные.Ссылка, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(
		ТекущиеДанные.Ссылка, Неопределено, УникальныйИдентификатор);
	РаботаСФайламиКлиент.ОткрытьКаталогФайла(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаИРабочийКаталог(ТекущиеДанные.Ссылка);
	РаботаСФайламиСлужебныйКлиент.ОбновитьИзФайлаНаДискеСОповещением(Новый ОписаниеОповещения("ОбновитьСписокРедактируемыхФайлов", ЭтотОбъект), ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыОсвобожденияФайла = РаботаСФайламиСлужебныйКлиент.ПараметрыОсвобожденияФайла(
		Новый ОписаниеОповещения("ОбновитьСписокРедактируемыхФайлов", ЭтотОбъект), ТекущиеДанные.Ссылка);
	ПараметрыОсвобожденияФайла.ХранитьВерсии = ТекущиеДанные.ХранитьВерсии;
	ПараметрыОсвобожденияФайла.ФайлРедактируетТекущийПользователь = Истина;
	ПараметрыОсвобожденияФайла.Редактирует = ТекущиеДанные.Редактирует;
	РаботаСФайламиСлужебныйКлиент.ОсвободитьФайлСОповещением(ПараметрыОсвобожденияФайла);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиСлужебныйКлиент.СохранитьИзмененияФайлаСОповещением(
		Неопределено,
		ТекущиеДанные.Ссылка,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляСохранения(
		ТекущиеДанные.Ссылка, , УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.СохранитьКак(Неопределено, ДанныеФайла, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОбновленияФайла = РаботаСФайламиСлужебныйКлиент.ПараметрыОбновленияФайла(
		Новый ОписаниеОповещения("ОбновитьСписокРедактируемыхФайлов", ЭтотОбъект), ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	ПараметрыОбновленияФайла.ХранитьВерсии = ТекущиеДанные.ХранитьВерсии;
	ПараметрыОбновленияФайла.ФайлРедактируетТекущийПользователь = Истина;
	ПараметрыОбновленияФайла.Редактирует = ТекущиеДанные.Редактирует;
	РаботаСФайламиСлужебныйКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	МассивСтруктур = Новый Массив;
	МассивСтруктур.Добавить(ОписаниеНастройки(
		"НастройкиПрограммы",
		"ПоказыватьЗанятыеФайлыПриЗавершенииРаботы",
		ПоказыватьЗанятыеФайлыПриЗавершенииРаботы));
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур, Истина);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоступностьКоманд()
	
	Доступность = Элементы.Список.ТекущаяСтрока <> Неопределено;
	
	Элементы.ФормаЗакончитьРедактирование.Доступность = Доступность;
	Элементы.СписокКонтекстноеМенюЗакончитьРедактирование.Доступность = Доступность;
	
	Элементы.ФормаОткрытьФайл.Доступность = Доступность;
	Элементы.СписокКонтекстноеМенюОткрыть.Доступность = Доступность;
	
	Элементы.ФормаОткрытьСвойстваФайла.Доступность = Доступность;
	
	Элементы.СписокКонтекстноеМенюСохранитьИзменения.Доступность = Доступность;
	Элементы.СписокКонтекстноеМенюОткрытьКаталогФайла.Доступность = Доступность;
	Элементы.СписокКонтекстноеМенюСохранитьКак.Доступность = Доступность;
	Элементы.СписокКонтекстноеМенюОсвободить.Доступность = Доступность;
	Элементы.СписокКонтекстноеМенюОбновитьИзФайлаНаДиске.Доступность = Доступность;
	
КонецПроцедуры

&НаКлиенте
Функция ОписаниеНастройки(Объект, Настойка, Значение)
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", Объект);
	Элемент.Вставить("Настройка", Настойка);
	Элемент.Вставить("Значение", Значение);
	
	Возврат Элемент;
	
КонецФункции

&НаСервере
Процедура НастроитьДинамическийСписок()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТИПЗНАЧЕНИЯ(СведенияОФайлах.Файл) КАК ТипФайла
		|ИЗ
		|	РегистрСведений.СведенияОФайлах КАК СведенияОФайлах
		|ГДЕ
		|	СведенияОФайлах.Редактирует = &Редактирует";
	
	Запрос.УстановитьПараметр("Редактирует", Пользователи.ТекущийПользователь());
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	МассивТипов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ТипФайла");
	УстановитьПривилегированныйРежим(Ложь);
	
	ТекстЗапроса = "";
	Для Каждого ТипСправочника Из МассивТипов Цикл
		МетаданныеСправочника = Метаданные.НайтиПоТипу(ТипСправочника);
		Если Не ПравоДоступа("Изменение", МетаданныеСправочника) Тогда
			Продолжить;
		КонецЕсли;
		Если Не СтрЗаканчиваетсяНа(МетаданныеСправочника.Имя, "ВерсииПрисоединенныхФайлов") И МетаданныеСправочника.Имя <> "ВерсииФайлов" Тогда
			Если Не ПустаяСтрока(ТекстЗапроса) Тогда
				ТекстЗапроса = ТекстЗапроса + "
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|	ВЫБРАТЬ";
			Иначе
				ТекстЗапроса = ТекстЗапроса + "
				|	ВЫБРАТЬ РАЗРЕШЕННЫЕ";
			КонецЕсли;
			
			ТекстЗапроса = ТекстЗапроса + "
			|	Файлы.Редактирует,
			|	Файлы.ИндексКартинки,
			|	Файлы.Наименование,
			|	Файлы.Описание,
			|	Файлы.Ссылка,
			|	Файлы.ВладелецФайла,
			|	Файлы.ХранитьВерсии КАК ХранитьВерсии,
			|	Файлы.Размер / 1024
			|ИЗ
			|	" + МетаданныеСправочника.ПолноеИмя() + " КАК Файлы
			|ГДЕ
			|	Файлы.Редактирует = &Редактирует"
		КонецЕсли;
	КонецЦикла;
		
	Если Не ПустаяСтрока(ТекстЗапроса) Тогда
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		СвойстваСписка.ТекстЗапроса                 = ТекстЗапроса;
		СвойстваСписка.ДинамическоеСчитываниеДанных = Ложь;
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокРедактируемыхФайлов(Результат, ДополнительныеПараметры) Экспорт
	Элементы.Список.Обновить();
КонецПроцедуры

#КонецОбласти
