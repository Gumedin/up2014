﻿Процедура ИтогиЗакупкиППЛО( ЗаявкаНаВыплату, СуммаПлан, СуммаОплачено )
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(ЗакупкаППЛОТовар.СуммаПравоОбл) КАК СуммаПравоОбл,
		|	0 КАК СуммаОплачено
		|ИЗ
		|	Документ.ЗакупкаППЛО.Товар КАК ЗакупкаППЛОТовар
		|ГДЕ
		|	ЗакупкаППЛОТовар.Ссылка = &ЗакупкаППЛО
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	0,
		|	СУММА(ЗаявкаНаОплатуПоставщику.СуммаДокумента)
		|ИЗ
		|	Документ.ЗаявкаНаОплатуПоставщику КАК ЗаявкаНаОплатуПоставщику
		|ГДЕ
		|	ЗаявкаНаОплатуПоставщику.Ссылка <> &Ссылка
		|	И ЗаявкаНаОплатуПоставщику.Проведен
		|	И ЗаявкаНаОплатуПоставщику.ЗакупкаППЛО = &ЗакупкаППЛО";

		
	ЗакупкаППЛО = ЗаявкаНаВыплату.ЗакупкаППЛО;
	Запрос.УстановитьПараметр("ЗакупкаППЛО", ЗакупкаППЛО);
	Запрос.УстановитьПараметр("Ссылка", 	 ЗаявкаНаВыплату);

	Результат 		= Запрос.Выполнить().Выгрузить();
	СуммаПлан		= ЗакупкаППЛО.СуммаДопОтВендора;
	СуммаОплачено 	= 0;
	Если Результат.Количество() <> 0 Тогда
		СуммаПлан 		= Результат.Итог( "СуммаПравоОбл" ) - СуммаПлан;
		СуммаОплачено 	= Результат.Итог( "СуммаОплачено" );
	КонецЕсли;
	
КонецПроцедуры


Функция ПолучитьПланПоЗакупкеППЛО( ЗаявкаНаВыплату ) Экспорт   
	Перем СуммаПлан, СуммаОплачено;
	ИтогиЗакупкиППЛО( ЗаявкаНаВыплату, СуммаПлан, СуммаОплачено );
	Возврат СуммаПлан;
КонецФункции


Функция ПолучитьОстатокПоЗакупкеППЛО( ЗаявкаНаВыплату ) Экспорт
	Перем СуммаПлан, СуммаОплачено;
	ИтогиЗакупкиППЛО( ЗаявкаНаВыплату, СуммаПлан, СуммаОплачено );
	Возврат СуммаПлан - СуммаОплачено;
КонецФункции
