﻿//ирМобильный Перем ирМобильный Экспорт;
//ирМобильный Перем ирОбщий Экспорт;
//ирМобильный Перем ирСервер Экспорт;
//ирМобильный Перем ирКэш Экспорт;
//ирМобильный Перем ирПривилегированный Экспорт;

Функция ПолучитьСписокЗначенийЭлементаОтбора(ПолеОтбора) Экспорт 
	
	Если ПолеОтбора = "Уровень" Тогда
		ВозможныеЗначения = Новый СписокЗначений;
		ВозможныеЗначения.Добавить(УровеньЖурналаРегистрации.Ошибка);
		ВозможныеЗначения.Добавить(УровеньЖурналаРегистрации.Предупреждение);
		ВозможныеЗначения.Добавить(УровеньЖурналаРегистрации.Информация); 
		ВозможныеЗначения.Добавить(УровеньЖурналаРегистрации.Примечание);
	ИначеЕсли ПолеОтбора = "СтатусТранзакции" Тогда
		ВозможныеЗначения = Новый СписокЗначений;
		ВозможныеЗначения.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.Зафиксирована);
		ВозможныеЗначения.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.Отменена);
		ВозможныеЗначения.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.НеЗавершена);
		ВозможныеЗначения.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.НетТранзакции);
	ИначеЕсли Ложь
		Или ПолеОтбора = "Пользователь" 
		Или ПолеОтбора = "Компьютер" 
		Или ПолеОтбора = "ИмяПриложения" 
		Или ПолеОтбора = "Событие" 
		Или ПолеОтбора = "Метаданные" 
		Или ПолеОтбора = "РабочийСервер" 
		Или ПолеОтбора = "ОсновнойIPПорт" 
		Или ПолеОтбора = "ВспомогательныйIPПорт" 
		Или ПолеОтбора = "РазделениеДанныхСеанса" 
	Тогда
		СтруктураЗначенийОтбора = ПолучитьЗначенияОтбораЖурналаРегистрации(ПолеОтбора);
		ВозможныеЗначения = СтруктураЗначенийОтбора[ПолеОтбора];
	Иначе
		ВозможныеЗначения = Неопределено;
	КонецЕсли; 
	Если ВозможныеЗначения <> Неопределено Тогда
		Если ТипЗнч(ВозможныеЗначения) = Тип("СписокЗначений") Тогда
			СписокВыбора = ВозможныеЗначения;
		ИначеЕсли ТипЗнч(ВозможныеЗначения) = Тип("Массив") Тогда
			СписокВыбора = Новый СписокЗначений;
			СписокВыбора.ЗагрузитьЗначения(ВозможныеЗначения);
			СписокВыбора.СортироватьПоЗначению();
		ИначеЕсли ТипЗнч(ВозможныеЗначения) = Тип("Соответствие") Тогда
			СписокВыбора = Новый СписокЗначений;
			Для Каждого КлючИЗначение Из ВозможныеЗначения Цикл
				СписокВыбора.Добавить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
			КонецЦикла; 
			СписокВыбора.СортироватьПоПредставлению();
		КонецЕсли; 
	КонецЕсли;
	Возврат СписокВыбора;

КонецФункции

Функция ДобавитьЭлементОтбора(Отбор, ПолеОтбора = "Данные", Знач ЗначениеОтбора = Неопределено, ПредставлениеЗначения = Неопределено,
	Использование = Истина, ОставлятьСтарыеПометки = Истина) Экспорт
	
	СтрокаОтбора = Отбор.Найти(ПолеОтбора);
	Если СтрокаОтбора = Неопределено Тогда
		СтрокаОтбора = Отбор.Добавить();
		СтрокаОтбора.Поле = ПолеОтбора;
		СтрокаОтбора.Значение = ПолучитьСписокЗначенийЭлементаОтбора(ПолеОтбора);
		УстановитьОписаниеТиповЗначенияОтбора(СтрокаОтбора);
	КонецЕсли; 
	ирОбщий.ПрисвоитьЕслиНеРавноЛкс(СтрокаОтбора.Использование, Использование);
	СписокВыбора = СтрокаОтбора.Значение;
	Если ТипЗнч(СписокВыбора) = Тип("СписокЗначений") Тогда
		Если Не ОставлятьСтарыеПометки Тогда
			СписокВыбора.ЗаполнитьПометки(Ложь);
		КонецЕсли; 
		Если ТипЗнч(ЗначениеОтбора) <> Тип("СписокЗначений") Тогда
			лПустышка = ЗначениеОтбора;
			ЗначениеОтбора = Новый СписокЗначений;
			ЗначениеОтбора.Добавить(лПустышка, , Истина);
		КонецЕсли; 
		Для Каждого ЭлементСписка Из СписокВыбора Цикл
			ЭлементСтарогоСписка = ЗначениеОтбора.НайтиПоЗначению(ЭлементСписка.Значение);
			Если ЭлементСтарогоСписка <> Неопределено Тогда
				ЭлементСписка.Пометка = ЭлементСтарогоСписка.Пометка;
			КонецЕсли; 
		КонецЦикла;
	Иначе
		СтрокаОтбора.Значение = ЗначениеОтбора;
	КонецЕсли; 
	Возврат СтрокаОтбора;
	
КонецФункции

Функция УстановитьОписаниеТиповЗначенияОтбора(СтрокаОтбора) Экспорт
	
	ПолеОтбора = СтрокаОтбора.Поле;
	МетаРеквизит = Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты[ПолеОтбора];
	БазовоеОписаниеТипов = МетаРеквизит.Тип;
	Если Ложь
		Или ПолеОтбора = "Уровень"
		Или ПолеОтбора = "СтатусТранзакции"
		Или ПолеОтбора = "Пользователь" 
		Или ПолеОтбора = "Компьютер" 
		Или ПолеОтбора = "ИмяПриложения" 
		Или ПолеОтбора = "Событие" 
		Или ПолеОтбора = "Метаданные" 
		Или ПолеОтбора = "РабочийСервер" 
		Или ПолеОтбора = "ОсновнойIPПорт" 
		Или ПолеОтбора = "ВспомогательныйIPПорт" 
		Или ПолеОтбора = "РазделениеДанныхСеанса" 
	Тогда
		ОписаниеТипов = Новый ОписаниеТипов("СписокЗначений");
	ИначеЕсли ПолеОтбора = "Сеанс" Тогда
		ОписаниеТипов = Новый ОписаниеТипов(БазовоеОписаниеТипов, "СписокЗначений");
	Иначе
		ОписаниеТипов = БазовоеОписаниеТипов;
	КонецЕсли; 
	СтрокаОтбора.ОписаниеТипов = ОписаниеТипов;
	СтрокаОтбора.Значение = ОписаниеТипов.ПривестиЗначение(СтрокаОтбора.Значение);
	СтрокаОтбора.Представление = МетаРеквизит.Представление();
	
КонецФункции

#Если Клиент Тогда
	
Функция ОткрытьСПараметром(ПолеОтбора = "Данные", ЗначениеОтбора, ПредставлениеЗначения = Неопределено) Экспорт 
	
	Форма = ПолучитьФорму(,, ЗначениеОтбора);
	Форма.Открыть();
	Форма.Отбор.Очистить();
	Форма.НачалоПериода = НачалоДня(ТекущаяДата());
	Форма.КонецПериода = Неопределено;
	ДобавитьЭлементОтбора(Форма.Отбор, ПолеОтбора, ЗначениеОтбора, ПредставлениеЗначения);
	Ответ = Вопрос("Сразу выполнить выгрузку с текущим отбором?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		Форма.ОбновитьТаблицуЖурнала();
	КонецЕсли;
	Возврат Форма;
	
КонецФункции

Функция ОткрытьСОтбором(НачалоПериода = Неопределено, КонецПериода = Неопределено, СтруктураОтбора = Неопределено, 
	МаксимальныйРазмерВыгрузки = Неопределено) Экспорт 
	
	Форма = ПолучитьФорму(,,);
	Форма.Открыть();
	Форма.Отбор.Очистить();
	Если НачалоПериода <> Неопределено Тогда
		Форма.НачалоПериода = НачалоПериода;
	Иначе
		Форма.НачалоПериода = НачалоДня(ТекущаяДата());
	КонецЕсли; 
	Если КонецПериода <> Неопределено Тогда
		Форма.КонецПериода = КонецПериода;
	Иначе
		Форма.КонецПериода = Неопределено;
	КонецЕсли; 
	Если МаксимальныйРазмерВыгрузки <> Неопределено Тогда
		Форма.МаксимальныйРазмерВыгрузки = МаксимальныйРазмерВыгрузки;
	КонецЕсли; 
	Если СтруктураОтбора <> Неопределено Тогда
		Для Каждого КлючИЗначение Из СтруктураОтбора Цикл
			ДобавитьЭлементОтбора(Форма.Отбор, КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла; 
	КонецЕсли;
	Ответ = Вопрос("Сразу выполнить выгрузку с текущим отбором?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		Форма.ОбновитьТаблицуЖурнала();
	КонецЕсли;
	Возврат Форма;
	
КонецФункции

#КонецЕсли

//ирМобильный #Если Клиент Тогда
//ирМобильный Контейнер = Новый Структура();
//ирМобильный Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирМобильный Если Не Контейнер.Свойство("ирМобильный", ирМобильный) Тогда
//ирМобильный 	ПолноеИмяФайлаБазовогоМодуля = ВосстановитьЗначение("ирПолноеИмяФайлаОсновногоМодуля");
//ирМобильный 	ирМобильный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирМобильный КонецЕсли; 
//ирМобильный ирОбщий = ирМобильный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирМобильный ирКэш = ирМобильный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирМобильный ирСервер = ирМобильный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирМобильный ирПривилегированный = ирМобильный.ПолучитьОбщийМодульЛкс("ирПривилегированный");
//ирМобильный #КонецЕсли

