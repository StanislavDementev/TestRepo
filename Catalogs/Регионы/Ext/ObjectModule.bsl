﻿// флаг необходимости проверки соотвествия кода и кода региона
Перем ПроверятьСоответствиеКодаИКодаРегиона Экспорт;


// Обработчик события ПередЗаписью 
//
Процедура ПередЗаписью(Отказ)

	#Если Клиент Тогда 
	
	Если (НЕ ОбменДанными.Загрузка) и ПроверятьСоответствиеКодаИКодаРегиона Тогда
			
		// проверка правильности заполнения кода региона
		КодСтраны = Цел(КодАдресногоЭлемента / 100000000000); 
		Если КодСтраны = 643 Тогда
			КодРег = Цел((КодАдресногоЭлемента - КодСтраны * 100000000000) / 1000000000);
			
			// проверка соответствия кода и кода региона
			Если Строка(КодРег) <> КодРегиона Тогда
				
				Ответ = Вопрос("Код региона не соответствует коду адресного элемента. Установить код региона автоматически?",
								РежимДиалогаВопрос.ДаНет, , , "Проверка кода региона");
								
				Если Ответ = КодВозвратаДиалога.Да Тогда
					КодРегиона = Строка(КодРег);					
				КонецЕсли;					
				
			КонецЕсли;
			
		КонецЕсли;		
	КонецЕсли;
	
	#КонецЕсли

КонецПроцедуры

// ТЕКСТ ОСНОВНОЙ ПРОГРАММЫ
///////////////////////////////////////////////////////////////////////////////

ПроверятьСоответствиеКодаИКодаРегиона = Истина;

