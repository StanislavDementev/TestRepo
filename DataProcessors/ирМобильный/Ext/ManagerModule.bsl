﻿
Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "Форма" Тогда
		Если Не ирКэш.ЛиМобильныйРежимЛкс() Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "Форма";
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры
