﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ЗаполнитьТабличнуюЧастьПоВидамДокументов()
	
	АктуальныеЭД = ЭлектронныеДокументыПовтИсп.ПолучитьАктуальныеВидыЭД();
	
	Для Каждого ЗначениеПеречисления Из АктуальныеЭД Цикл
		Если ЗначениеПеречисления = Перечисления.ВидыЭД.Ошибка
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.Подтверждение
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ДопДанные
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ВыпискаБанка
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.Квитанция Тогда
			Продолжить;
		КонецЕсли;
		
		Если Объект.ПрограммаБанка = Перечисления.ПрограммыБанка.СбербанкОнлайн
			И НЕ (ЗначениеПеречисления = Перечисления.ВидыЭД.ПлатежноеПоручение
				  ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ЗапросВыписки
				  ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ЗапросНочнойВыписки) Тогда
				Продолжить;
		КонецЕсли;
		
		Если Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.ОбменЧерезДопОбработку")
				И НЕ ЗначениеПеречисления = Перечисления.ВидыЭД.ПлатежноеПоручение Тогда
			Продолжить;
		КонецЕсли;
		
			
		Если НЕ Объект.ПрограммаБанка = Перечисления.ПрограммыБанка.СбербанкОнлайн
			И ЗначениеПеречисления = Перечисления.ВидыЭД.ЗапросНочнойВыписки Тогда
			Продолжить;
		КонецЕсли;
		
		МассивСтрок = Объект.ВидыДокументов.НайтиСтроки(Новый Структура("ВидДокумента", ЗначениеПеречисления));
		Если МассивСтрок.Количество() = 0 Тогда
			НоваяСтрокаТЧ = Объект.ВидыДокументов.Добавить();
			НоваяСтрокаТЧ.ВидДокумента = ЗначениеПеречисления;
			НоваяСтрокаТЧ.ИспользоватьДляПодписи = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьДоступностьСоставаИсполнителей()
	
	Элементы.СоставИсполнителей.Доступность = Объект.ПроверятьСоставИсполнителей;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьВидимость()
	
	Элементы.ГруппаШапка.Доступность 				= Не Объект.Отозван;
	Элементы.ВидыДокументовИИсполнители.Доступность = Не Объект.Отозван;
	Элементы.ФормаТестСертификата.Доступность 		= Не Объект.Отозван;
	Элементы.ФормаТестСертификата.Доступность 		= Не ТолькоПросмотр;
	Элементы.ФормаКнопкаОтозван.Пометка 			= Объект.Отозван;
	Элементы.Пользователь.Доступность				= Объект.ОграничитьДоступКСертификату;
	Элементы.Пользователь.АвтоОтметкаНезаполненного = Объект.ОграничитьДоступКСертификату;
	Элементы.КнопкаПароль.Доступность				= Объект.ЗапомнитьПарольКСертификату;
	ОпределитьДоступностьСоставаИсполнителей();
	ЗаполнитьЗаголовкиГиперссылок();
	
	// Проверка сертификата на соответствие 63 ФЗ.
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если Объект.ПрограммаБанка <> Перечисления.ПрограммыБанка.ОбменЧерезДопОбработку
			И ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.2.18.108") >= 0 Тогда
		ДанныеФайлаСертификата = Объект.Ссылка.ФайлСертификата.Получить();
		НовыйСертификат = Новый СертификатКриптографии(ДанныеФайлаСертификата);
		
		// Корректно работаем только с сертификатами для подписи стандартной структуры.
		Если (НовыйСертификат.Субъект.Свойство("SN") ИЛИ НовыйСертификат.Субъект.Свойство("CN"))
			И НовыйСертификат.Субъект.Свойство("T") И НовыйСертификат.Субъект.Свойство("ST") Тогда
			
			ФИОВладельца = "";
			Если НовыйСертификат.Субъект.Свойство("SN") Тогда
				ШаблонФИОВладельца = НСтр("ru = '%1 %2'");
				ФИОВладельца = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонФИОВладельца,
				НовыйСертификат.Субъект.SN, НовыйСертификат.Субъект.GN);
			ИначеЕсли НовыйСертификат.Субъект.Свойство("CN") Тогда
				
				ФИОВладельца = НовыйСертификат.Субъект.CN;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ФИОВладельца) Тогда
				Фамилия      = "";
				Имя          = "";
				Отчество     = "";
				
				ЭлектронныеДокументы.ФамилияИнициалыФизЛица(ФИОВладельца, Фамилия, Имя, Отчество);
			КонецЕсли;
			Должность = НовыйСертификат.Субъект.T;
			
			ЗаписатьСертификат = Ложь;
			Если ЗначениеЗаполнено(Фамилия) И Объект.Фамилия <> Фамилия Тогда
				Объект.Фамилия  = Фамилия;
				ЗаписатьСертификат = Истина;
			КонецЕсли;
			Если ЗначениеЗаполнено(Имя) И Объект.Имя <> Имя Тогда
				Объект.Имя      = Имя;
				ЗаписатьСертификат = Истина;
			КонецЕсли;
			Если ЗначениеЗаполнено(Отчество) И Объект.Отчество <> Отчество Тогда
				Объект.Отчество = Отчество;
				ЗаписатьСертификат = Истина;
			КонецЕсли;
			Если ЗначениеЗаполнено(Должность) И Объект.ДолжностьПоСертификату <> Должность Тогда
				Объект.ДолжностьПоСертификату = Должность;
				ЗаписатьСертификат = Истина;
			КонецЕсли;
			
			Если ЗаписатьСертификат Тогда
				Записать();
			КонецЕсли;
			
			Элементы.Фамилия.Доступность  = Ложь;
			Элементы.Имя.Доступность      = Ложь;
			Элементы.Отчество.Доступность = Ложь;
			Элементы.ДолжностьПоСертификату.Доступность = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗаголовкиГиперссылок()
	
	Если Объект.ЗапомнитьПарольКСертификату Тогда
		ТекстГиперссылкиПароля = Нстр("ru = 'Изменить пароль.'");
	Иначе
		ТекстГиперссылкиПароля = Нстр("ru = 'Пароль не сохранен.'");
	КонецЕсли;
	
	Элементы.КнопкаПароль.Заголовок       = ТекстГиперссылкиПароля;
	
КонецПроцедуры

&НаКлиенте
Функция УстановитьПароль()
	
	ПараметрыСертификата = ЭлектронныеДокументыСлужебныйВызовСервера.РеквизитыСертификата(Объект.Ссылка);
	Соответствие = Новый Соответствие;
	Соответствие.Вставить(Объект.Ссылка, ПараметрыСертификата);
	ВидОперации = НСтр("ru = 'Сохранение пароля в сертификате'");
	ПарольУстановлен = ЭлектронныеДокументыСлужебныйКлиент.ПарольКСертификатуПолучен(Соответствие, ВидОперации, , Истина);
	Если ПарольУстановлен Тогда
		Объект.ПарольПользователя = ПараметрыСертификата.ПарольПользователя;
		Модифицированность = Истина;
	КонецЕсли;
	
	УстановитьДоступностьВидимость();
	
	Возврат ПарольУстановлен;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	Для Каждого ЭлементТаблицы Из Объект.ВидыДокументов Цикл
		ЭлементТаблицы.ИспользоватьДляПодписи = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	Для Каждого ЭлементТаблицы Из Объект.ВидыДокументов Цикл
		ЭлементТаблицы.ИспользоватьДляПодписи = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатОтозван(Команда)
	
	Объект.Отозван = НЕ Объект.Отозван;
	УстановитьДоступностьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ОграничитьДоступКСертификатуПриИзменении(Элемент)
	
	УстановитьДоступностьВидимость();
	
	Если НЕ Объект.ОграничитьДоступКСертификату И ЗначениеЗаполнено(Объект.Пользователь) Тогда
		Объект.Пользователь = Неопределено;
	ИначеЕсли Объект.ОграничитьДоступКСертификату Тогда
		ТекущийЭлемент = Элементы.Пользователь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьПароль(Команда)
	
	УстановитьПароль();
	
КонецПроцедуры

&НаКлиенте
Процедура ТестНастроекСертификата(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ТекстВопроса = НСтр("ru = 'В текущий сертификат электронной подписи внесены изменения. Продолжить выполнение теста?'");
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Выполнить", НСтр("ru = 'Сохранить и выполнить тест'"));
		СписокКнопок.Добавить("Отменить",  НСтр("ru = 'Отменить тест'"));
		Ответ = Вопрос(ТекстВопроса, СписокКнопок, , "Выполнить", НСтр("ru = 'Тест настроек сертификата'"));
		Если Ответ = "Отменить" Тогда
			Возврат;
		Иначе
			Записать();
		КонецЕсли;
	КонецЕсли;
	
	Если ЭлектронныеДокументыСлужебныйВызовСервера.ВыполнятьКриптооперацииНаСервере()
		И НЕ (Объект.ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.ОбменЧерезДопОбработку")) Тогда
			НаКлиенте = Ложь;
			НаСервере = Истина;
	Иначе
		НаКлиенте = Истина;
		НаСервере = Ложь;
	КонецЕсли;
	
	ПараметрыСертификата = ЭлектронныеДокументыСлужебныйВызовСервера.РеквизитыСертификата(Объект.Ссылка);
	
	КонтекстПроверки = Новый Структура;
	КонтекстПроверки.Вставить("НаКлиенте", НаКлиенте);
	КонтекстПроверки.Вставить("НаСервере", НаСервере);
	
	ЭлектронныеДокументыСлужебныйКлиент.ТестНастроекСертификата(Объект.Ссылка,
																ПараметрыСертификата,
																КонтекстПроверки,
																,
																,
																УникальныйИдентификатор);
	Если ПараметрыСертификата.ЗапомнитьПарольКСертификату <> Объект.ЗапомнитьПарольКСертификату Тогда
		Прочитать();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ФОРМЫ

&НаКлиенте
Процедура НазначениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Попытка
		ЭлектроннаяЦифроваяПодписьКлиент.ОткрытьСертификат(Объект.Отпечаток);
	Исключение
		Предупреждение(НСтр("ru = 'Невозможно открыть сертификат. Возможно он не установлен на локальный компьютер.'"));
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверятьСоставИсполнителейПриИзменении(Элемент)
	
	ОпределитьДоступностьСоставаИсполнителей();
	
КонецПроцедуры

&НаКлиенте
Процедура ФамилияПриИзменении(Элемент)
	
	Объект.Фамилия = СокрЛП(Объект.Фамилия);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	
	Объект.Имя = СокрЛП(Объект.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчествоПриИзменении(Элемент)
	
	Объект.Отчество = СокрЛП(Объект.Отчество);
	
КонецПроцедуры

&НаКлиенте
Процедура ДолжностьПоСертификатуПриИзменении(Элемент)
	
	Объект.ДолжностьПоСертификату = СокрЛП(Объект.ДолжностьПоСертификату);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапомнитьПарольКСертификатуПриИзменении(Элемент)

	Если НЕ Объект.ЗапомнитьПарольКСертификату Тогда
		Объект.ПарольПользователя = Неопределено;
	Иначе
		Объект.ЗапомнитьПарольКСертификату = УстановитьПароль();
	КонецЕсли;
	
	УстановитьДоступностьВидимость();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТабличнуюЧастьПоВидамДокументов();
	ОпределитьДоступностьСоставаИсполнителей();
	
	Если Объект.ПрограммаБанка = Перечисления.ПрограммыБанка.СбербанкОнлайн
			ИЛИ Объект.ПрограммаБанка = Перечисления.ПрограммыБанка.ОбменЧерезДопОбработку Тогда
		Элементы.ФормаТестСертификата.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьДоступностьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.ОграничитьДоступКСертификату И НЕ ЗначениеЗаполнено(Объект.Пользователь) Тогда
		Отказ = Истина;
		Предупреждение(НСтр("ru = 'Не указан пользователь, которому доступен сертификат!
		|Укажите пользователя, либо снимите ограничение доступа.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ОбновитьСостояниеЭД", Объект.Ссылка);
	
КонецПроцедуры
