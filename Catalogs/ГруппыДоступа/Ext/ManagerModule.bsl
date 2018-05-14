﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("ТипПользователей");
	НеРедактируемыеРеквизиты.Добавить("Пользователь");
	НеРедактируемыеРеквизиты.Добавить("ОсновнаяГруппаДоступаПоставляемогоПрофиля");
	НеРедактируемыеРеквизиты.Добавить("ВидыДоступа.*");
	НеРедактируемыеРеквизиты.Добавить("ЗначенияДоступа.*");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Устанавливает пометку удаления группам доступа, если установлена
// пометка удаления у профиля группы доступа. Требуется, например,
// при удалении предопределенных профилей групп доступа,
// т.к. платформа не вызывает обработчики объектов при
// установке пометки удаления бывшим предопределенным
// элементам в процессе обновления конфигурации базы данных.
//
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ПометитьНаУдалениеГруппыДоступаПомеченныхПрофилей(ЕстьИзменения = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|ГДЕ
	|	ГруппыДоступа.Профиль.ПометкаУдаления
	|	И НЕ ГруппыДоступа.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ГруппаДоступаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ГруппаДоступаОбъект.ПометкаУдаления = Истина;
		ГруппаДоступаОбъект.Записать();
		ЕстьИзменения = Истина;
	КонецЦикла;
	
КонецПроцедуры

// Выполняет обновление видов доступа групп доступа указанного профиля.
//  При этом возможно не удалять виды доступа из группы доступа,
// которые удалены в профиле этой группы доступа, в случае
// когда в группе доступа назначены значения доступа по
// удаляемому виду доступа.
// 
// Параметры:
//  Профиль      - СправочникСсылка.ПрофилиГруппДоступа
//  ОбновлятьГруппыДоступаСУстаревшимиНастройками - Булево.
//
// Возвращаемое значение:
//  Булево - когда Истина, группа доступа была изменена,
//           когда Ложь никаких изменений не было выполнено.
//
Функция ОбновитьГруппыДоступаПрофиля(Профиль, ОбновлятьГруппыДоступаСУстаревшимиНастройками = Ложь) Экспорт
	
	ГруппаДоступаОбновлена = Ложь;
	
	ВидыДоступаПрофиля = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Профиль, "ВидыДоступа").Выгрузить();
	Индекс = ВидыДоступаПрофиля.Количество() - 1;
	Пока Индекс >= 0 Цикл
		Строка = ВидыДоступаПрофиля[Индекс];
		
		Отбор = Новый Структура("ВидДоступа", Строка.ВидДоступа);
		СвойстваВидаДоступа = УправлениеДоступомСлужебный.СвойстваВидаДоступа(Строка.ВидДоступа);
		
		Если СвойстваВидаДоступа = Неопределено Тогда
			ВидыДоступаПрофиля.Удалить(Строка);
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|ГДЕ
	|	(ГруппыДоступа.Профиль = &Профиль
	|			ИЛИ &Профиль = ЗНАЧЕНИЕ(Справочник.ПрофилиГруппДоступа.Администратор)
	|				И ГруппыДоступа.Ссылка = ЗНАЧЕНИЕ(Справочник.ГруппыДоступа.Администраторы))";
	
	Запрос.УстановитьПараметр("Профиль", Профиль.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		// Проверка необходимости/возможности обновления группы доступа.
		ГруппаДоступа = Выборка.Ссылка.ПолучитьОбъект();
		
		Если ГруппаДоступа.Ссылка = Справочники.ГруппыДоступа.Администраторы
		   И ГруппаДоступа.Профиль <> Справочники.ПрофилиГруппДоступа.Администратор Тогда
			// Установка профиля Администратор, если не задан.
			ГруппаДоступа.Профиль = Справочники.ПрофилиГруппДоступа.Администратор;
		КонецЕсли;
		
		// Проверка состава видов доступа.
		СоставВидовДоступаИзменен = Ложь;
		ЕстьУдаляемыеВидыДоступаСЗаданнымиЗначениямиДоступа = Ложь;
		Если ГруппаДоступа.ВидыДоступа.Количество() <> ВидыДоступаПрофиля.НайтиСтроки(Новый Структура("Предустановленный", Ложь)).Количество() Тогда
			СоставВидовДоступаИзменен = Истина;
		Иначе
			Для каждого СтрокаВидаДоступа Из ГруппаДоступа.ВидыДоступа Цикл
				Если ВидыДоступаПрофиля.НайтиСтроки(Новый Структура("ВидДоступа, Предустановленный", СтрокаВидаДоступа.ВидДоступа, Ложь)).Количество() = 0 Тогда
					СоставВидовДоступаИзменен = Истина;
					Если ГруппаДоступа.ЗначенияДоступа.Найти(СтрокаВидаДоступа.ВидДоступа, "ВидДоступа") <> Неопределено Тогда
						ЕстьУдаляемыеВидыДоступаСЗаданнымиЗначениямиДоступа = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если СоставВидовДоступаИзменен
		   И ( ОбновлятьГруппыДоступаСУстаревшимиНастройками
		       ИЛИ НЕ ЕстьУдаляемыеВидыДоступаСЗаданнымиЗначениямиДоступа ) Тогда
			// Обновление группы доступа.
			// 1. Удаление лишних видов доступа и значений доступа (если есть).
			ТекущийНомерСтроки = ГруппаДоступа.ВидыДоступа.Количество()-1;
			Пока ТекущийНомерСтроки >= 0 Цикл
				ТекущийВидДоступа = ГруппаДоступа.ВидыДоступа[ТекущийНомерСтроки].ВидДоступа;
				Если ВидыДоступаПрофиля.НайтиСтроки(Новый Структура("ВидДоступа, Предустановленный", ТекущийВидДоступа, Ложь)).Количество() = 0 Тогда
					СтрокиЗначенийВидаДоступа = ГруппаДоступа.ЗначенияДоступа.НайтиСтроки(Новый Структура("ВидДоступа", ТекущийВидДоступа));
					Для каждого СтрокаЗначения Из СтрокиЗначенийВидаДоступа Цикл
						ГруппаДоступа.ЗначенияДоступа.Удалить(СтрокаЗначения);
					КонецЦикла;
					ГруппаДоступа.ВидыДоступа.Удалить(ТекущийНомерСтроки);
				КонецЕсли;
				ТекущийНомерСтроки = ТекущийНомерСтроки - 1;
			КонецЦикла;
			// 2. Добавление новых видов доступа (если есть).
			Для каждого СтрокаВидаДоступа Из ВидыДоступаПрофиля Цикл
				Если НЕ СтрокаВидаДоступа.Предустановленный 
				   И ГруппаДоступа.ВидыДоступа.Найти(СтрокаВидаДоступа.ВидДоступа, "ВидДоступа") = Неопределено Тогда
					
					НоваяСтрока = ГруппаДоступа.ВидыДоступа.Добавить();
					НоваяСтрока.ВидДоступа   = СтрокаВидаДоступа.ВидДоступа;
					НоваяСтрока.ВсеРазрешены = СтрокаВидаДоступа.ВсеРазрешены;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ГруппаДоступа.Модифицированность() Тогда
			ЗаблокироватьДанныеДляРедактирования(ГруппаДоступа.Ссылка, ГруппаДоступа.ВерсияДанных);
			ГруппаДоступа.ДополнительныеСвойства.Вставить("НеОбновлятьРолиПользователей");
			ГруппаДоступа.Записать();
			ГруппаДоступаОбновлена = Истина;
			РазблокироватьДанныеДляРедактирования(ГруппаДоступа.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ГруппаДоступаОбновлена;
	
КонецФункции

// Возвращает ссылку на группу-родителя персональных групп доступа.
//  Если родитель не найден он будет создан.
//
// Параметры:
//  НеСоздавать  - Булево, если задан Истина, родитель не будет автоматически создан,
//                 а функция вернет Неопределено, если родитель не найден
//
// Возвращаемое значение:
//  СправочникСсылка.ГруппыДоступа
//
Функция РодительПерсональныхГруппДоступа(Знач НеСоздавать = Ложь, НаименованиеГруппыЭлементов = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаименованиеГруппыЭлементов = НСтр("ru = 'Персональные группы доступа'");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НаименованиеГруппыЭлементов", НаименованиеГруппыЭлементов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|ГДЕ
	|	ГруппыДоступа.Наименование ПОДОБНО &НаименованиеГруппыЭлементов
	|	И ГруппыДоступа.ЭтоГруппа";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ГруппаЭлементов = Выборка.Ссылка;
	ИначеЕсли НеСоздавать Тогда
		ГруппаЭлементов = Неопределено;
	Иначе
		ГруппаЭлементовОбъект = Справочники.ГруппыДоступа.СоздатьГруппу();
		ГруппаЭлементовОбъект.Наименование = НаименованиеГруппыЭлементов;
		ГруппаЭлементовОбъект.Записать();
		ГруппаЭлементов = ГруппаЭлементовОбъект.Ссылка;
	КонецЕсли;
	
	Возврат ГруппаЭлементов;
	
КонецФункции

// Только для внутреннего использования.
Процедура ВосстановитьСоставУчастниковГруппыДоступаАдминистраторы(ЭлементДанных) Экспорт
	
	Если ЭлементДанных.ИмяПредопределенныхДанных <> "Администраторы" Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементДанных.Пользователи.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИмяПредопределенныхДанных", "Администраторы");
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ГруппыДоступаПользователи.Пользователь
	|ИЗ
	|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|ГДЕ
	|	ГруппыДоступаПользователи.Ссылка.ИмяПредопределенныхДанных = &ИмяПредопределенныхДанных";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЭлементДанных.Пользователи.Найти(Выборка.Пользователь, "Пользователь") = Неопределено Тогда
			ЭлементДанных.Пользователи.Добавить().Пользователь = Выборка.Пользователь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

Процедура ЗаполнитьПрофильГруппыДоступаАдминистраторы() Экспорт
	
	Объект = Администраторы.ПолучитьОбъект();
	Объект.Профиль = Справочники.ПрофилиГруппДоступа.Администратор;
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли