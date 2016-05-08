﻿
Процедура ЗаполнитьXML(ОбъектXML, Отказ, Сообщение, ДобавлятьАтрибутПроверки = Ложь, ДополнятьИсходящееСообщениеПриложеннымиФайлами = Ложь) Экспорт
	
	ПрефиксИмен = "";
	ПространствоИменСОДИ    = "urn:moo-sodi.ru:commerceml_sodi";
	
	ОбъектXML.ЗаписатьНачалоЭлемента("Извещение", ПространствоИменСОДИ);
	ОбъектXML.ЗаписатьСоответствиеПространстваИмен(ПрефиксИмен, ПространствоИменСОДИ);
	ОбъектXML.ЗаписатьСоответствиеПространстваИмен("xsi", "http://www.w3.org/2001/XMLSchema-instance");
	Если ДобавлятьАтрибутПроверки Тогда
		ОбъектXML.ЗаписатьАтрибут("xsi:schemaLocation","urn:moo-sodi.ru:commerceml_sodi cml-report-3.0sodi.xsd");
	КонецЕсли;
	
	ДеревоТэгов  = ЭлектронныеДокументы.ИнициализироватьДеревоТэгов(ЭтотОбъект, Отказ, Сообщение);
	СтрокиДерева = ДеревоТэгов.Строки;
	
	ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиДерева, "НомерИсходногоДокумента", ИсходныйДокумент.НомерВходящегоДокумента, "ДокументИД");
	ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиДерева, "СтатусОбработкиДокумента", СтатусОбработки);
		
	Для каждого СтрокаТаблицыТовары Из Товары Цикл
		
		СтрокиТовара = ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиДерева, "СтатусОбработкиТовара").Строки;
		ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ИдТовара"  , СтрокаТаблицыТовары.ИдТовара , "ТоварИД");
				
		Если ЗначениеЗаполнено(СтрокаТаблицыТовары.Примечание) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "Примечание", СтрокаТаблицыТовары.Примечание);
		КонецЕсли;		
		
	КонецЦикла;	
	
	ЭлектронныеДокументы.ЗаписатьТэгиВXMLДокумент(ОбъектXML, ДеревоТэгов.Строки, ПрефиксИмен);
	ОбъектXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

Функция SOAPAction() Экспорт
	
	Возврат "disposition_report";
	
КонецФункции // ()

Функция СуществуетИсходящийДокумент(СсылкаНаОтветныйДокумент = Неопределено) Экспорт
	
	Возврат Ложь;
	
КонецФункции // () 