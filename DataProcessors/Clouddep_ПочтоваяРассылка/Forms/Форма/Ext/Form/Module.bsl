﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПользователиУчетныхЗаписейПриАктивизацииСтроки(Элемент)
	УстановитьОтборУчетныхЗаписей();
КонецПроцедуры

&НаКлиенте
Процедура ГруппыРассылкиСписокПриАктивизацииСтроки(Элемент)
	УстановитьОтборСоставаГруппРассылок();
	УстановитьОтборНастроекАвтозаполненияСоставаГруппыРассылки();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
//Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьОтборУчетныхЗаписей()
	
	ТекущиеДанныеСтроки = Элементы.ПользователиУчетныхЗаписей.ТекущиеДанные;
	Если ТекущиеДанныеСтроки=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанныеСтроки.Пользователь="<<Все учетные записи>>" Тогда
		УчетныеЗаписи.Параметры.УстановитьЗначениеПараметра("ПоВсемПользователям", Истина);
		УчетныеЗаписи.Параметры.УстановитьЗначениеПараметра("Пользователь", Неопределено);
	Иначе
		УчетныеЗаписи.Параметры.УстановитьЗначениеПараметра("ПоВсемПользователям", Ложь);
		УчетныеЗаписи.Параметры.УстановитьЗначениеПараметра("Пользователь", ТекущиеДанныеСтроки.Пользователь);
	КонецЕсли;

КонецПроцедуры // УстановитьОтборУчетныхЗаписей()

&НаКлиенте
Процедура УстановитьОтборСоставаГруппРассылок()
	
	ГруппаРассылкиСсылка = Элементы.ГруппыРассылкиСписок.ТекущаяСтрока;
	Если ГруппаРассылкиСсылка=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементыОтбора = СоставГруппыРассылки.Отбор.Элементы;
	ЭлементыОтбора.Очистить();
	ЭлементОтбора_ГруппаРассылки = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора_ГруппаРассылки.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГруппаРассылки");
	ЭлементОтбора_ГруппаРассылки.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора_ГруппаРассылки.ПравоеЗначение = ГруппаРассылкиСсылка;
	ЭлементОтбора_ГруппаРассылки.Использование = Истина;
КонецПроцедуры // УстановитьОтборСоставаГруппРассылок()()

&НаКлиенте
Процедура УстановитьОтборНастроекАвтозаполненияСоставаГруппыРассылки()
	ГруппаРассылкиСсылка = Элементы.ГруппыРассылкиСписок.ТекущаяСтрока;
	Если ГруппаРассылкиСсылка=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементыОтбора = НастройкиАвтозаполненияСоставаГруппРассылки.Отбор.Элементы;
	ЭлементыОтбора.Очистить();
	ЭлементОтбора_ГруппаРассылки = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора_ГруппаРассылки.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГруппаПочтовойРассылки");
	ЭлементОтбора_ГруппаРассылки.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора_ГруппаРассылки.ПравоеЗначение = ГруппаРассылкиСсылка;
	ЭлементОтбора_ГруппаРассылки.Использование = Истина;
КонецПроцедуры

&НаСервере
Процедура ПоказатьКонтактыПоТекущейНастройкеНаСервере()
	//Элементы.НастройкиАвтозаполненияСоставаГруппРассылки.ТекущаяСтрока
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьКонтактыПоТекущейНастройке(Команда)
	
	КлючиЗаписейРегистраНастроек = Элементы.НастройкиАвтозаполненияСоставаГруппРассылки.ВыделенныеСтроки;
	
	Если КлючиЗаписейРегистраНастроек.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	АдресКлючейЗаписейРегистра = ПоместитьВоВременноеХранилище(КлючиЗаписейРегистраНастроек);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресКлючейЗаписейРегистра", АдресКлючейЗаписейРегистра);
	ОткрытьФорму("РегистрСведений.Clouddep_НастройкиАвтозаполненияСоставаГруппыПочтовойРассылки.Форма.ФормаПодбораПользователейПоАлгоритму", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиАвтозаполненияСоставаГруппРассылкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ГруппаРассылки = Элементы.ГруппыРассылкиСписок.ТекущаяСтрока;
	Если ГруппаРассылки=Неопределено Тогда
		Предупреждение("Не выбрана группа рассылки!");
		Возврат;
	КонецЕсли;
	
	
	ВариантыОбъектов = Новый СписокЗначений;
	ЭлементПоУмолчанию = ВариантыОбъектов.Добавить("Контрагенты", "Контрагенты");
	ВариантыОбъектов.Добавить("КонтактныеЛица", "Контактные лица");
	ВыбранныйВариант = ВариантыОбъектов.ВыбратьЭлемент("Выберите вид контакта", ЭлементПоУмолчанию);
	
	Если ВыбранныйВариант=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеВарианта = ВыбранныйВариант.Значение;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ОбъектНастройки", ЗначениеВарианта);
	ЗначенияЗаполнения.Вставить("ГруппаРассылки", ГруппаРассылки);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("РегистрСведений.Clouddep_НастройкиАвтозаполненияСоставаГруппыПочтовойРассылки.ФормаЗаписи", ПараметрыФормы);
	
КонецПроцедуры
	
#КонецОбласти

