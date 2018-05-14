&НаКлиенте
Функция ПолучитьКодХТМЛ() 
   КодХТМЛ = " 
   |<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd""> 
   |<html xmlns=""http://www.w3.org/1999/xhtml""> 
   |<head> 
   |    <title>Примеры.Геокодирование.</title> 
   |    <meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" /> 
   |    <script src=""http://api-maps.yandex.ru/1.1/index.xml?key=ANpUFEkBAAAAf7jmJwMAHGZHrcKNDsbEqEVjEUtCmufxQMwAAAAAAAAAAAAvVrubVT4btztbduoIgTLAeFILaQ=="" type=""text/javascript""></script> 
   |    <script type=""text/javascript""> 
   |        var map, geoResult; 
   // Создание обработчика для события window.onLoad 
   |        YMaps.jQuery(function () { 
   // Создание экземпляра карты и его привязка к созданному контейнеру 
   |            map = new YMaps.Map(YMaps.jQuery(""#YMapsID"")[0]); 
   // Установка для карты ее центра и масштаба 
   |            map.setCenter(new YMaps.GeoPoint(37.64, 55.76), 10); 
   // Добавление элементов управления 
   |            var toolBar = new YMaps.ToolBar(); 
   |          map.addControl(toolBar); 
   |           map.addControl(new YMaps.Zoom()); 
   |          map.addControl(new YMaps.TypeControl()); 
   |          map.enableScrollZoom(); 
   |        }); 
   // Функция для отображения результата геокодирования 
   // Параметр value - адрес объекта для поиска 
   |       function showAddress (value) { 
   // Запуск процесса геокодирования 
   |           var geocoder = new YMaps.Geocoder(value, {results: 1, boundedBy: map.getBounds()}); 
   // Создание обработчика для успешного завершения геокодирования 
   |           YMaps.Events.observe(geocoder, geocoder.Events.Load, function () { 
   // Если объект был найден, то добавляем его на карту 
   // и центрируем карту по области обзора найденного объекта 
   |               if (this.length()) { 
   |                   geoResult = this.get(0); 
   |                  map.addOverlay(geoResult); 
   |                 map.setBounds(geoResult.getBounds()); 
   |}else { 
   |                 alert(""Ничего не найдено"") 
   |            } 
   |        }); 
   // Процесс геокодирования завершен неудачно 
   |       YMaps.Events.observe(geocoder, geocoder.Events.Fault, function (geocoder, error) { 
   |          alert(""Произошла ошибка: "" + error); 
   |     }) 
   |} 
   //Тут функция, которая формируется динамически 
   |//~~Функция showA~~ 
   |</script> 
   |</head> 
   |<body //~~onload~~> 
   |  <div id=""YMapsID"" style=""width:800px;height:600px""></div> 
   |</form> 
   |</body> 
   |     
   |</html> 
   |"; 
    
   Возврат КодХТМЛ; 
КонецФункции


// по списку адресов
&НаКлиенте
Функция ПолучитьКодХТМЛ_Яндекс( спАдресов ) Экспорт 
   	НачФункции = "function showA () {"; 
    
   	ТелоФункции = ""; 
    
   	Для каждого Элемент Из спАдресов Цикл 
       	ТелоФункции = ТелоФункции + ?(ЗначениеЗаполнено(ТелоФункции), Символы.ПС, "") + "showAddress("""+ Элемент.Значение +""")";     
   	КонецЦикла; 
    
   	КонФункции = Символы.ПС + "}"; 
    
   	ФункцияShowA = НачФункции + ТелоФункции + КонФункции; 
	
	КодХТМЛ = ПолучитьКодХТМЛ(); 
   	КодХТМЛ = СтрЗаменить(КодХТМЛ,"//~~Функция showA~~",ФункцияShowA); 
   	КодХТМЛ = СтрЗаменить(КодХТМЛ,"//~~onload~~","onload = ""javascript:showA()"""); 
    
   	Возврат КодХТМЛ; 
КонецФункции

