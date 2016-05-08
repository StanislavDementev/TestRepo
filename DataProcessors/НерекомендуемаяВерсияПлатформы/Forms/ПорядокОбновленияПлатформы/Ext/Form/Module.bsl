﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	БазаФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	Если БазаФайловая Тогда
		МакетПорядокОбновления = Обработки.НерекомендуемаяВерсияПлатформы.ПолучитьМакет("ПорядокОбновленияДляФайловойБазы");
	Иначе
		МакетПорядокОбновления = Обработки.НерекомендуемаяВерсияПлатформы.ПолучитьМакет("ПорядокОбновленияДляКлиентСервернойБазы");
	КонецЕсли;
	
	ПорядокОбновленияПрограммы = МакетПорядокОбновления.ПолучитьТекст();
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокОбновленияПрограммыПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Статус = ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	СтандартнаяОбработка = Ложь;
	Если Статус = "Подключено" Тогда
		Если ДанныеСобытия.Href <> Неопределено Тогда
			ЗапуститьПриложение(ДанныеСобытия.Href);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
