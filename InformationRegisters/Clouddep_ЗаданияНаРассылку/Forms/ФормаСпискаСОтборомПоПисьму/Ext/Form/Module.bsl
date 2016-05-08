﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СформироватьТаблицуПисем();
	СформироватьТаблицуЗаданий(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.СписокПоказатьВсе.Пометка = Истина;
	
	СделатьАктивнымПоследнееПисьмо();
	
	Элементы.Список.ОтборСтрок = Новый ФиксированнаяСтруктура("Показывать", Истина);
	ПодключитьОбработчикОжидания("УстановитьОтборПоПисьмуКлиент", 0.4, Истина);
КонецПроцедуры

&НаСервере
Процедура СформироватьТаблицуПисем()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаданияНаРассылку.Письмо,
		|	СУММА(1) КАК Всего,
		|	СУММА(ВЫБОР
		|			КОГДА ЗаданияНаРассылку.СтатусОтправки <> ЗНАЧЕНИЕ(Перечисление.СтатусыОтправкиВЗаданииНаРассылку.ВОбработке)
		|					И ЗаданияНаРассылку.СтатусОтправки <> ЗНАЧЕНИЕ(Перечисление.СтатусыОтправкиВЗаданииНаРассылку.Отправлен)
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ВРаботе,
		|	СУММА(ВЫБОР
		|			КОГДА ЗаданияНаРассылку.СтатусОтправки = ЗНАЧЕНИЕ(Перечисление.СтатусыОтправкиВЗаданииНаРассылку.Отправлен)
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Отправлено
		|ПОМЕСТИТЬ втИтоги
		|ИЗ
		|	РегистрСведений.ЗаданияНаРассылку КАК ЗаданияНаРассылку
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаданияНаРассылку.Письмо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СправочникПисьмаДляОтложеннойОтправки.Ссылка,
		|	СправочникПисьмаДляОтложеннойОтправки.Наименование,
		|	СправочникПисьмаДляОтложеннойОтправки.Автор,
		|	СправочникПисьмаДляОтложеннойОтправки.ДатаСоздания КАК ДатаСоздания,
		|	СправочникПисьмаДляОтложеннойОтправки.СтатусПисьма,
		|	ЕСТЬNULL(втИтоги.Всего, 0) КАК ПолучателейВсего,
		|	ЕСТЬNULL(втИтоги.ВРаботе, 0) КАК ПолучателейВРаботе,
		|	ЕСТЬNULL(втИтоги.Отправлено, 0) КАК ПолучателейОтправлено
		|ИЗ
		|	Справочник.ПисьмаДляОтложеннойОтправки КАК СправочникПисьмаДляОтложеннойОтправки
		|		ЛЕВОЕ СОЕДИНЕНИЕ втИтоги КАК втИтоги
		|		ПО (втИтоги.Письмо = СправочникПисьмаДляОтложеннойОтправки.Ссылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	СправочникПисьмаДляОтложеннойОтправки.Ссылка,
		|	СправочникПисьмаДляОтложеннойОтправки.Наименование,
		|	СправочникПисьмаДляОтложеннойОтправки.Автор,
		|	СправочникПисьмаДляОтложеннойОтправки.ДатаСоздания,
		|	СправочникПисьмаДляОтложеннойОтправки.СтатусПисьма,
		|	ЕСТЬNULL(втИтоги.Всего, 0),
		|	ЕСТЬNULL(втИтоги.ВРаботе, 0),
		|	ЕСТЬNULL(втИтоги.Отправлено, 0)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаСоздания";

	Данные = Запрос.Выполнить().Выгрузить();
	Письма.Загрузить(Данные);
КонецПроцедуры

&НаСервере
Процедура СформироватьТаблицуЗаданий(ПоПисьму=Неопределено)
	Если ПоПисьму=Неопределено Тогда
		Список.Очистить();
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПоПисьму", ПоПисьму);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РегистрСведенийЗаданияНаРассылку.Письмо,
	|	РегистрСведенийЗаданияНаРассылку.Получатель,
	|	РегистрСведенийЗаданияНаРассылку.АдресПолучателя,
	|	РегистрСведенийЗаданияНаРассылку.ДатаОтправки,
	|	РегистрСведенийЗаданияНаРассылку.СтатусОтправки,
	|	РегистрСведенийЗаданияНаРассылку.Комментарий,
	|	ИСТИНА КАК Показывать,
	|	РегистрСведенийЗаданияНаРассылку.НомерПопытки
	|ИЗ
	|	РегистрСведений.ЗаданияНаРассылку КАК РегистрСведенийЗаданияНаРассылку
	|ГДЕ
	|	РегистрСведенийЗаданияНаРассылку.Письмо = &ПоПисьму";
	Данные = Запрос.Выполнить().Выгрузить();
	Список.Загрузить(Данные);
КонецПроцедуры // ()

&НаКлиенте
Процедура ПисьмаПриАктивизацииСтроки(Элемент)
	УстановитьОтборПоПисьму();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоПисьмуКлиент()
	УстановитьОтборПоПисьму();
КонецПроцедуры // УстановитьОтборПоПисьмуКлиент()


&НаСервере
Процедура УстановитьОтборПоПисьму()
	ИдСтроки = Элементы.Письма.ТекущаяСтрока;
	Если ИдСтроки=Неопределено Тогда
		СформироватьТаблицуЗаданий(Неопределено);
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Письма.НайтиПоИдентификатору(ИдСтроки);
	СформироватьТаблицуЗаданий(ДанныеСтроки.Ссылка);
	
	Если Элементы.СписокПоказатьОтправленные.Пометка Тогда
		СтатусОтправлен = Перечисления.СтатусыОтправкиВЗаданииНаРассылку.Отправлен;
		Для каждого СтрокаСписка Из Список Цикл
			Если СтрокаСписка.СтатусОтправки=СтатусОтправлен Тогда
				СтрокаСписка.Показывать = Истина;
			ИНаче
				СтрокаСписка.Показывать = Ложь;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли Элементы.СписокНеОтправленные.Пометка Тогда
		СтатусОтправлен = Перечисления.СтатусыОтправкиВЗаданииНаРассылку.Отправлен;
		Для каждого СтрокаСписка Из Список Цикл
			Если СтрокаСписка.СтатусОтправки<>СтатусОтправлен Тогда
				СтрокаСписка.Показывать = Истина;
			ИНаче
				СтрокаСписка.Показывать = Ложь;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли Элементы.СписокПоказатьПроблемные.Пометка Тогда
		СтатусНеУдачнаяОтправка = Перечисления.СтатусыОтправкиВЗаданииНаРассылку.НеУдачнаяОтправка;
		Для каждого СтрокаСписка Из Список Цикл
			Если СтрокаСписка.СтатусОтправки=СтатусНеУдачнаяОтправка Тогда
				СтрокаСписка.Показывать = Истина;
			ИНаче
				СтрокаСписка.Показывать = Ложь;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Для каждого СтрокаСписка Из Список Цикл
			СтрокаСписка.Показывать = Истина;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СделатьАктивнымПоследнееПисьмо()
	КоличествоПисем = Письма.Количество();
	Если КоличествоПисем=0 Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторСтроки = Письма.Получить(КоличествоПисем-1).ПолучитьИдентификатор();
	Элементы.Письма.ТекущаяСтрока = ИдентификаторСтроки;
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьРассылку(Команда)
	идПисьма = Элементы.Письма.ТекущаяСтрока;
	
	Если идПисьма=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Письма.НайтиПоИдентификатору(идПисьма);
	
	Письмо = ДанныеСтроки.Ссылка;
	
	ОтменитьРассылкуСервер(Письмо);
	
	Элементы.Письма.Обновить();
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьРассылкуСервер(Письмо)
	Clouddep_ПочтовыеРассылкиСервер.ОтменитьРассылкуПоПисьму(Письмо);
КонецПроцедуры // ОтменитьРассылкуСервер()



&НаКлиенте
Процедура ПоказатьВсе(Команда)
	Элементы.СписокПоказатьВсе.Пометка = Истина;
	Элементы.СписокПоказатьОтправленные.Пометка = Ложь;
	Элементы.СписокНеОтправленные.Пометка = Ложь;
	Элементы.СписокПоказатьПроблемные.Пометка = Ложь;
	
	УстановитьОтборПоПисьму();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтправленные(Команда)
	Элементы.СписокПоказатьВсе.Пометка = Ложь;
	Элементы.СписокПоказатьОтправленные.Пометка = Истина;
	Элементы.СписокНеОтправленные.Пометка = Ложь;
	Элементы.СписокПоказатьПроблемные.Пометка = Ложь;
	
	УстановитьОтборПоПисьму();
КонецПроцедуры

&НаКлиенте
Процедура НеОтправленные(Команда)
	Элементы.СписокПоказатьВсе.Пометка = Ложь;
	Элементы.СписокПоказатьОтправленные.Пометка = Ложь;
	Элементы.СписокНеОтправленные.Пометка = Истина;
	Элементы.СписокПоказатьПроблемные.Пометка = Ложь;
	
	УстановитьОтборПоПисьму();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПроблемные(Команда)
	Элементы.СписокПоказатьВсе.Пометка = Ложь;
	Элементы.СписокПоказатьОтправленные.Пометка = Ложь;
	Элементы.СписокНеОтправленные.Пометка = Ложь;
	Элементы.СписокПоказатьПроблемные.Пометка = Истина;
	
	УстановитьОтборПоПисьму();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПисьма(Команда)
	СформироватьТаблицуПисем();
	СделатьАктивнымПоследнееПисьмо();
	
	ПодключитьОбработчикОжидания("УстановитьОтборПоПисьмуКлиент", 0.4, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	УстановитьОтборПоПисьму();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтправитьПовторноНаСервере(Письмо)
	
	Clouddep_ПочтовыеРассылкиСервер.ЗапуститьРассылкуПовторноПоПисьму(Письмо);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПовторно(Команда)
	
	идПисьма = Элементы.Письма.ТекущаяСтрока;
	
	Если идПисьма=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Письма.НайтиПоИдентификатору(идПисьма);
	
	Письмо = ДанныеСтроки.Ссылка;
	
	ОтправитьПовторноНаСервере(Письмо);
	
	Элементы.Письма.Обновить();
	Элементы.Список.Обновить();
	
КонецПроцедуры
