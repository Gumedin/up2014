﻿
Функция GetPlan( ГодБюджета, КодСтатьи, НачалоПериода, КоличествоМесяцев, ТипДохода  )
	
	JSON_Данные = УП_БДР.ПолучитьПланПоСтатьеJSON(ГодБюджета, КодСтатьи, НачалоПериода, КоличествоМесяцев, ТипДохода );
	
	Возврат JSON_Данные;
КонецФункции

Функция GetFact(ГодБюджета, КодСтатьи, НачалоПериода, КоличествоМесяцев, ТипДохода )
	JSON_Данные = УП_БДР.ПолучитьФактПоСтатьеJSON(ГодБюджета, КодСтатьи, НачалоПериода, КоличествоМесяцев, ТипДохода );
	
	Возврат JSON_Данные;
	// Вставить содержимое обработчика.
КонецФункции
