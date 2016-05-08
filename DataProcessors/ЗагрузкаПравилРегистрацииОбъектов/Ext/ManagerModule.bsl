﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Инициализирует колонки таблицы правил регистрации объектов
//
// Параметры:
//  Нет.
// 
Функция ИнициализацияТаблицыПРО() Экспорт
	
	ПравилаРегистрацииОбъектов = Новый ТаблицаЗначений;
	
	Колонки = ПравилаРегистрацииОбъектов.Колонки;
	
	Колонки.Добавить("ОбъектНастройки");
	
	Колонки.Добавить("ОбъектМетаданныхИмя", Новый ОписаниеТипов("Строка"));
	Колонки.Добавить("ИмяПланаОбмена",      Новый ОписаниеТипов("Строка"));
	
	Колонки.Добавить("ИмяРеквизитаФлага", Новый ОписаниеТипов("Строка"));
	
	Колонки.Добавить("ТекстЗапроса",    Новый ОписаниеТипов("Строка"));
	Колонки.Добавить("СвойстваОбъекта", Новый ОписаниеТипов("Структура"));
	
	Колонки.Добавить("СвойстваОбъектаСтрокой", Новый ОписаниеТипов("Строка"));
	
	// признаки того, что правила пустые
	Колонки.Добавить("ПравилоПоСвойствамОбъектаПустое",     Новый ОписаниеТипов("Булево"));
	
	Колонки.Добавить("ОтборПоСвойствамПланаОбмена", Новый ОписаниеТипов("ДеревоЗначений"));
	Колонки.Добавить("ОтборПоСвойствамОбъекта",     Новый ОписаниеТипов("ДеревоЗначений"));
	
	// обработчики событий
	Колонки.Добавить("ПередОбработкой",            Новый ОписаниеТипов("Строка"));
	Колонки.Добавить("ПриОбработке",               Новый ОписаниеТипов("Строка"));
	Колонки.Добавить("ПриОбработкеДополнительный", Новый ОписаниеТипов("Строка"));
	Колонки.Добавить("ПослеОбработки",             Новый ОписаниеТипов("Строка"));
	
	Колонки.Добавить("ЕстьОбработчикПередОбработкой",            Новый ОписаниеТипов("Булево"));
	Колонки.Добавить("ЕстьОбработчикПриОбработке",               Новый ОписаниеТипов("Булево"));
	Колонки.Добавить("ЕстьОбработчикПриОбработкеДополнительный", Новый ОписаниеТипов("Булево"));
	Колонки.Добавить("ЕстьОбработчикПослеОбработки",             Новый ОписаниеТипов("Булево"));
	
	Возврат ПравилаРегистрацииОбъектов;
	
КонецФункции

// Инициализирует колонки таблицы правил регистрации по свойствам
//
// Параметры:
//  Нет.
// 
Функция ИнициализацияТаблицыОтборПоСвойствамПланаОбмена() Экспорт
	
	ШаблонДерева = Новый ДеревоЗначений;
	
	Колонки = ШаблонДерева.Колонки;
	
	Колонки.Добавить("ЭтоГруппа",            Новый ОписаниеТипов("Булево"));
	Колонки.Добавить("БулевоЗначениеГруппы", Новый ОписаниеТипов("Строка"));
	
	Колонки.Добавить("СвойствоОбъекта",      Новый ОписаниеТипов("Строка"));
	Колонки.Добавить("ВидСравнения",         Новый ОписаниеТипов("Строка"));
	Колонки.Добавить("ЭтоСтрокаКонстанты",   Новый ОписаниеТипов("Булево"));
	Колонки.Добавить("ТипСвойстваОбъекта",   Новый ОписаниеТипов("Строка"));
	
	Колонки.Добавить("ПараметрУзла",                Новый ОписаниеТипов("Строка"));
	Колонки.Добавить("ТабличнаяЧастьПараметраУзла", Новый ОписаниеТипов("Строка"));
	
	Колонки.Добавить("ЗначениеКонстанты"); // произвольный тип
	
	Возврат ШаблонДерева;
	
КонецФункции

// Инициализирует колонки таблицы правил регистрации по свойствам
//
// Параметры:
//  Нет.
// 
Функция ИнициализацияТаблицыОтборПоСвойствамОбъекта() Экспорт
	
	ШаблонДерева = Новый ДеревоЗначений;
	
	Колонки = ШаблонДерева.Колонки;
	
	Колонки.Добавить("ЭтоГруппа",           Новый ОписаниеТипов("Булево"));
	Колонки.Добавить("ЭтоОператорИ",        Новый ОписаниеТипов("Булево"));
	
	Колонки.Добавить("СвойствоОбъекта",     Новый ОписаниеТипов("Строка"));
	Колонки.Добавить("КлючСвойстваОбъекта", Новый ОписаниеТипов("Строка"));
	Колонки.Добавить("ВидСравнения",        Новый ОписаниеТипов("Строка"));
	Колонки.Добавить("ТипСвойстваОбъекта",  Новый ОписаниеТипов("Строка"));
	Колонки.Добавить("ВидЭлементаОтбора",   Новый ОписаниеТипов("Строка"));
	
	Колонки.Добавить("ЗначениеКонстанты"); // произвольный тип
	Колонки.Добавить("ЗначениеСвойства");  // произвольный тип
	
	Возврат ШаблонДерева;
	
КонецФункции

#КонецЕсли