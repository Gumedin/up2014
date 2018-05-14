﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Процедуры и функции проверки корректности заполнения регламентированных данных
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет соответствие ИНН требованиям.
//
// Параметры:
//  ИНН          	- Строка - Проверяемый индивидуальный номер налогоплательщика.
//  ЭтоЮрЛицо   	- Булево - признак, является ли владелец ИНН юридическим лицом.
//  ТекстСообщения 	- Строка - Текст сообщения о найденных ошибках.
//
// Возвращаемое значение:
//  Истина       - ИНН соответствует требованиям;
//  Ложь         - ИНН не соответствует требованиям.
//
Функция ИННСоответствуетТребованиям(Знач ИНН, ЭтоЮрЛицо, ТекстСообщения) Экспорт

	СоответствуетТребованиям = Истина;
	ТекстСообщения = "";

	ИНН      = СокрЛП(ИНН);
	ДлинаИНН = СтрДлина(ИНН);

	Если ЭтоЮрЛицо = Неопределено Тогда
	   	ТекстСообщения = ТекстСообщения + НСтр("ru = 'Не определен тип владельца ИНН.'");
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ИНН) Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'ИНН должен состоять только из цифр.'");
	КонецЕсли;

	Если  ЭтоЮрЛицо  И ДлинаИНН <> 10 Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
		               + НСтр("ru = 'ИНН юридического лица должен состоять из 10 цифр.'");
	ИначеЕсли НЕ ЭтоЮрЛицо  И ДлинаИНН <> 12 Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
		               + НСтр("ru = 'ИНН физического лица должен состоять из 12 цифр.'");
	КонецЕсли;

	Если СоответствуетТребованиям Тогда

		Если ЭтоЮрЛицо Тогда

			КонтрольнаяСумма = 0;

			Для Н = 1 По 9 Цикл

				Если Н = 1 Тогда
					Множитель = 2;
				ИначеЕсли Н = 2 Тогда
					Множитель = 4;
				ИначеЕсли Н = 3 Тогда
					Множитель = 10;
				ИначеЕсли Н = 4 Тогда
					Множитель = 3;
				ИначеЕсли Н = 5 Тогда
					Множитель = 5;
				ИначеЕсли Н = 6 Тогда
					Множитель = 9;
				ИначеЕсли Н = 7 Тогда
					Множитель = 4;
				ИначеЕсли Н = 8 Тогда
					Множитель = 6;
				ИначеЕсли Н = 9 Тогда
					Множитель = 8;
				КонецЕсли;

				Цифра = Число(Сред(ИНН, Н, 1));
				КонтрольнаяСумма = КонтрольнаяСумма + Цифра * Множитель;

			КонецЦикла;
			
			КонтрольныйРазряд = (КонтрольнаяСумма %11) %10;

			Если КонтрольныйРазряд <> Число(Сред(ИНН, 10, 1)) Тогда
				СоответствуетТребованиям = Ложь;
				ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
				               + НСтр("ru = 'Контрольное число для ИНН не совпадает с рассчитанным.'");
			КонецЕсли;

		Иначе

			КонтрольнаяСумма11 = 0;
			КонтрольнаяСумма12 = 0;

			Для Н=1 По 11 Цикл

				// Расчет множителя для 11-го и 12-го разрядов
				Если Н = 1 Тогда
					Множитель11 = 7;
					Множитель12 = 3;
				ИначеЕсли Н = 2 Тогда
					Множитель11 = 2;
					Множитель12 = 7;
				ИначеЕсли Н = 3 Тогда
					Множитель11 = 4;
					Множитель12 = 2;
				ИначеЕсли Н = 4 Тогда
					Множитель11 = 10;
					Множитель12 = 4;
				ИначеЕсли Н = 5 Тогда
					Множитель11 = 3;
					Множитель12 = 10;
				ИначеЕсли Н = 6 Тогда
					Множитель11 = 5;
					Множитель12 = 3;
				ИначеЕсли Н = 7 Тогда
					Множитель11 = 9;
					Множитель12 = 5;
				ИначеЕсли Н = 8 Тогда
					Множитель11 = 4;
					Множитель12 = 9;
				ИначеЕсли Н = 9 Тогда
					Множитель11 = 6;
					Множитель12 = 4;
				ИначеЕсли Н = 10 Тогда
					Множитель11 = 8;
					Множитель12 = 6;
				ИначеЕсли Н = 11 Тогда
					Множитель11 = 0;
					Множитель12 = 8;
				КонецЕсли;

				Цифра = Число(Сред(ИНН, Н, 1));
				КонтрольнаяСумма11 = КонтрольнаяСумма11 + Цифра * Множитель11;
				КонтрольнаяСумма12 = КонтрольнаяСумма12 + Цифра * Множитель12;

			КонецЦикла;

			КонтрольныйРазряд11 = (КонтрольнаяСумма11 %11) %10;
			КонтрольныйРазряд12 = (КонтрольнаяСумма12 %11) %10;

			Если КонтрольныйРазряд11 <> Число(Сред(ИНН,11,1)) ИЛИ КонтрольныйРазряд12 <> Число(Сред(ИНН,12,1)) Тогда
				СоответствуетТребованиям = Ложь;
				ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
				               + НСтр("ru = 'Контрольное число для ИНН не совпадает с рассчитанным.'");
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Возврат СоответствуетТребованиям;

КонецФункции 

// Проверяет соответствие КПП требованиям.
//
// Параметры:
//  КПП          - Строка - Проверяемый код причины постановки на учет.
//  ТекстСообщения - Строка - Текст сообщения о найденных ошибках.
//
// Возвращаемое значение:
//  Истина       - КПП соответствует требованиям;
//  Ложь         - КПП не соответствует требованиям.
//
Функция КППСоответствуетТребованиям(Знач КПП, ТекстСообщения) Экспорт

	СоответствуетТребованиям = Истина;
	ТекстСообщения           = "";

	КПП      = СокрЛП(КПП);
	ДлинаКПП = СтрДлина(КПП);

	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(КПП) Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'КПП должен состоять только из цифр.'");
	КонецЕсли;

	Если ДлинаКПП <> 9 Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "") +
			НСтр("ru = 'КПП должен состоять из 9 цифр.'");
	КонецЕсли;

	Возврат СоответствуетТребованиям;

КонецФункции 

// Проверяет соответствие ОГРН требованиям.
//
// Параметры:
//  ОГРН         	- Строка - Проверяемый основной государственный регистрационный номер.
//  ЭтоЮрЛицо   	- Булево - признак, является ли владелец ОГРН юридическим лицом.
//  ТекстСообщения 	- Строка - Текст сообщения о найденных ошибках.
//
// Возвращаемое значение:
//  Истина       - ОГРН соответствует требованиям;
//  Ложь         - ОГРН не соответствует требованиям.
//
Функция ОГРНСоответствуетТребованиям(Знач ОГРН, ЭтоЮрЛицо, ТекстСообщения) Экспорт

	СоответствуетТребованиям = Истина;
	ТекстСообщения = "";

	ОГРН = СокрЛП(ОГРН);
	ДлинаОГРН = СтрДлина(ОГРН);
	
	Если ЭтоЮрЛицо = Неопределено Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Не определен тип владельца ОГРН.'");
		Возврат Ложь;
	КонецЕсли;

	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ОГРН) Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'ОГРН должен состоять только из цифр.'")
	КонецЕсли;

	Если ЭтоЮрЛицо И ДлинаОГРН <> 13 Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
		               + НСтр("ru = 'ОГРН юридического лица должен состоять из 13 цифр.'");
	ИначеЕсли НЕ ЭтоЮрЛицо И ДлинаОГРН <> 15 Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
		               + НСтр("ru = 'ОГРН физического лица должен состоять из 15 цифр.'");
	КонецЕсли;

	Если СоответствуетТребованиям Тогда

		Если ЭтоЮрЛицо Тогда

			КонтрольныйРазряд = Прав(Формат(Число(Лев(ОГРН, 12)) % 11, "ЧН=0; ЧГ=0"), 1);

			Если КонтрольныйРазряд <> Прав(ОГРН, 1) Тогда
				СоответствуетТребованиям = Ложь;
				ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
				               + НСтр("ru = 'Контрольное число для ОГРН не совпадает с рассчитанным.'");
			КонецЕсли;

		Иначе

			КонтрольныйРазряд = Прав(Формат(Число(Лев(ОГРН, 14)) % 13, "ЧН=0; ЧГ=0"), 1);

			Если КонтрольныйРазряд <> Прав(ОГРН, 1) Тогда
				СоответствуетТребованиям = Ложь;
				ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
				               + НСтр("ru = 'Контрольное число для ОГРН не совпадает с рассчитанным.'");
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Возврат СоответствуетТребованиям;

КонецФункции 

// Проверяет соответствие кода ОКПО требованиям стандартов.
//
// Параметры:
//  ПроверяемыйКод         - Строка - проверяемый код ОКПО;
//  ЭтоЮрЛицо              - Булево - признак, является ли владелец кода ОКПО юридическим лицом;
//  ТекстСообщения         - Строка - текст сообщения о найденных ошибках в проверяемом коде ОКПО;
//  ОтбрасыватьВедущиеНули - Булево - (не используется) признак необходимости проверки кода физического лица без ведущих нулей.
//
// Возвращаемое значение:
//  Булево.
//
Функция КодПоОКПОСоответствуетТребованиям(Знач ПроверяемыйКод, ЭтоЮрЛицо, ТекстСообщения = "", ОтбрасыватьВедущиеНули = Ложь) Экспорт
	
	ПроверяемыйКод = СокрЛП(ПроверяемыйКод);
	ТекстСообщения = "";
	ДлинаКода = СтрДлина(ПроверяемыйКод);

	Если ЭтоЮрЛицо = Неопределено Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Не определен тип владельца кода ОКПО.'");
		Возврат Ложь;
	КонецЕсли;
	
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ПроверяемыйКод) Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Код ОКПО должен состоять только из цифр.'") + Символы.ПС;
	КонецЕсли;

	Если ЭтоЮрЛицо И ДлинаКода <> 8 Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Код ОКПО юридического лица должен состоять из 8 цифр.'") + Символы.ПС;
	ИначеЕсли Не ЭтоЮрЛицо И ДлинаКода <> 10 Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Код ОКПО физического лица должен состоять из 10 цифр.'") + Символы.ПС;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстСообщения) Тогда
		ТекстСообщения = СокрЛП(ТекстСообщения);
		Возврат Ложь;
	КонецЕсли;
	
	Если Не КодКлассификатораВерный(ПроверяемыйКод) Тогда
		ТекстСообщения = НСтр("ru = 'Контрольное число для кода по ОКПО не совпадает с рассчитанным.'");
		Возврат Ложь
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции 

// Проверяет номер страхового свидетельства на соответствие требованиям ПФР.
//
// Параметры:
//		СтраховойНомер - страховой номер ПФР. Строка должна быть ведена по шаблону "999-999-999 99".
//		ТекстСообщения - текст сообщения об ошибке ввода страхового номера
//
Функция СтраховойНомерПФРСоответствуетТребованиям(Знач СтраховойНомер, ТекстСообщения) Экспорт
	
	ТекстСообщения = "";
	
	Результат = Истина;
	
	СтрокаЦифр = СтрЗаменить(СтраховойНомер, "-", "");
	СтрокаЦифр = СтрЗаменить(СтрокаЦифр, " ", "");
	
	Если ПустаяСтрока(СтрокаЦифр) Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Страховой номер не заполнен'");
		Возврат Ложь;
	КонецЕсли;
	
	Если СтрДлина(СтрокаЦифр) < 11 Тогда
		ТекстСообщения  =  ТекстСообщения + НСтр("ru = 'Страховой номер задан неполностью'");
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаЦифр) Тогда
		Результат = Ложь;
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Страховой номер должен состоять только из цифр.'");
	КонецЕсли;
	
	КонтрольноеЧисло = Число(Прав(СтрокаЦифр, 2));
	
	Если Число(Лев(СтрокаЦифр, 9)) > 1001998 Тогда
		Всего = 0;
		Для Сч = 1 По 9 Цикл
			Всего = Всего + Число(Сред(СтрокаЦифр, 10 - Сч, 1)) * Сч;
		КонецЦикла;
		Остаток = Всего % 101;
		Остаток = ?(Остаток = 100, 0, Остаток);
		Если Остаток <> КонтрольноеЧисло Тогда
			ТекстСообщения = ТекстСообщения + НСтр("ru = 'Контрольное число для страхового номера не совпадает с рассчитанным.'");
			Результат = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверка контрольного ключа в номере лицевого счета (9-й разряд номера счета),
// алгоритм установлен документом:
// "ПОРЯДОК РАСЧЕТА КОНТРОЛЬНОГО КЛЮЧА В НОМЕРЕ ЛИЦЕВОГО СЧЕТА"
// (утв. ЦБ РФ 08.09.1997 N 515).
//
// Параметры:
//  НомерСчета - строка - номер банковского счета
//  БИК - строка, БИК банка в котором открыт счет
//  ЭтоБанк - Булево, Истина - Банк, Ложь - РКЦ.
//
// Возвращаемое значение:
//  Булево
//  Истина - контрольный ключ верен
//  Ложь - контрольный ключ не верен
//
Функция КонтрольныйКлючЛицевогоСчетаСоответствуетТребованиям(НомерСчета, БИК, ЭтоБанк = Истина)Экспорт
	
	НомерСчетаСтрока = СокрЛП(НомерСчета);
	
	// При наличии алфавитного значения в 6-ом разряде лицевого 
	// счета (в случае использования клиринговой валюты) данный символ 
	// заменяется на соответствующую цифру:
	Разряд6 = Сред(НомерСчетаСтрока, 6, 1); 
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Разряд6) Тогда
		АлфавитныеЗначения6гоРазряда = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("А,В,С,Е,Н,К,М,Р,Т,Х");
		Цифра = АлфавитныеЗначения6гоРазряда.Найти(Разряд6);	
		Если Цифра = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		Разряд6 = Строка(Цифра);
	КонецЕсли;
	
	// Для расчета контрольного ключа используется совокупность двух 
	// реквизитов - условного номера РКЦ (если лицевой счет открыт в РКЦ) 
	// или кредитной организации (если лицевой счет открыт в кредитной 
	// организации) и номера лицевого счета.
	Если ЭтоБанк Тогда
		УсловныйНомерКО = Прав(БИК, 3);
	Иначе
		УсловныйНомерКО = "0" + Сред(БИК, 5, 2 );
	КонецЕсли;
	
	НомерСчетаСтрока = УсловныйНомерКО + Лев(НомерСчетаСтрока,5) + Разряд6 + Сред(НомерСчетаСтрока, 7);
	
	Если СтрДлина(НомерСчетаСтрока) <> 23 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(НомерСчетаСтрока) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВесовыеКоэффициенты = "71371371371371371371371";
	КонтрольнаяСумма = 0;
	Для Разряд = 1 По 23 Цикл
		Произведение = Число(Сред(НомерСчетаСтрока, Разряд, 1)) * Число(Сред(ВесовыеКоэффициенты, Разряд, 1));
		МладшийРазряд = Число(Прав(Строка(Произведение), 1));
		КонтрольнаяСумма = КонтрольнаяСумма + МладшийРазряд;
	КонецЦикла;
	
	// При получении суммы, кратной 10 (младший разряд равен 0), значение 
	// контрольного ключа считается верным.
	
	Возврат Прав(Строка(КонтрольнаяСумма), 1) = "0";
	
КонецФункции

// Проверяет правильность кода по контрольному числу (последняя цифра в коде).
//
// ПР 50.1.024-2005 «Основные положения и порядок проведения работ по разработке, ведению и применению общероссийских
// классификаторов», приложение В.
//
// Контрольное число рассчитывается следующим образом:
// 1. Разрядам кода в общероссийском классификаторе, начиная со старшего разряда, присваивается набор весов,
// соответствующий натуральному ряду чисел от 1 до 10. Если разрядность кода больше 10, то набор весов повторяется.
// 2. Каждая цифра кода умножается на вес разряда и вычисляется сумма полученных произведений.
// 3. Контрольное число для кода представляет собой остаток от деления полученной суммы на модуль «11».
// 4. Контрольное число должно иметь один разряд, значение которого находится в пределах от 0 до 9.
// Если получается остаток, равный 10, то для обеспечения одноразрядного контрольного числа необходимо провести
// повторный расчет, применяя вторую последовательность весов, сдвинутую на два разряда влево (3, 4, 5,…). Если в
// случае повторного расчета остаток от деления вновь сохраняется равным 10, то значение контрольного числа
// проставляется равным «0».
//
// Параметры:
//  ПроверяемыйКод - Строка - код для проверки.
//
// Возвращаемое значение:
//  Булево.
//
Функция КодКлассификатораВерный(ПроверяемыйКод)
	
	СуммаПроизведений = 0;
	Для Позиция = 1 По СтрДлина(ПроверяемыйКод)-1 Цикл
		Цифра = Число(Сред(ПроверяемыйКод, Позиция, 1));
		Вес = (Позиция - 1) % 10 + 1;
		СуммаПроизведений = СуммаПроизведений + Цифра * Вес;
	КонецЦикла;

	КонтрольнаяЦифра = СуммаПроизведений % 11;
	Если КонтрольнаяЦифра = 10 Тогда
		СуммаПроизведений = 0;
		Для Позиция = 1 По СтрДлина(ПроверяемыйКод)-1 Цикл
			Цифра = Число(Сред(ПроверяемыйКод, Позиция, 1));
			Вес = (Позиция + 1) % 10 + 1;
			СуммаПроизведений = СуммаПроизведений + Цифра * Вес;
		КонецЦикла;
		КонтрольнаяЦифра = СуммаПроизведений % 11;
	КонецЕсли;
	
	КонтрольнаяЦифра = КонтрольнаяЦифра % 10;
	
	Возврат Строка(КонтрольнаяЦифра) = Прав(ПроверяемыйКод, 1);

КонецФункции
	
#КонецОбласти
