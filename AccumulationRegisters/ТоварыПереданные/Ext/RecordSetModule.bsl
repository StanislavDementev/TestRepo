﻿Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

Перем мИмяДокумента;
Перем мДокМетаданные;
Перем мТабЧастьМетаданные;
Перем мСтатусПередачи;
Перем мСтруктураШапкиДокумента;
Перем мИмяТабличнойЧасти;
Перем мИмяТаблицы;
Перем мОтказ;
Перем мЗаголовок;

// Выполняет приход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьПриход() Экспорт

	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Приход);

КонецПроцедуры // ВыполнитьПриход()

// Выполняет расход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьРасход() Экспорт

	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Расход);

КонецПроцедуры // ВыполнитьРасход()

// Выполняет движения по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьДвижения() Экспорт

	Загрузить(мТаблицаДвижений);

КонецПроцедуры // ВыполнитьДвижения()

// Процедура контролирует остаток по данному регистру по переданному документу
// и его табличной части. В случае недостатка товаров выставляется флаг отказа и 
// выдается сообщение.
//
// Параметры:
//  ДокументОбъект          - объект проводимого документа, 
//  ИмяТабличнойЧасти       - строка, имя табличной части, которая проводится по регистру, 
//  СтруктураШапкиДокумента - структура, содержащая значения "через точку" ссылочных реквизитов по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура КонтрольОстатков(ДокументОбъект, ИмяТабличнойЧасти, СтруктураШапкиДокумента, СтатусПередачи, Отказ, Заголовок) Экспорт

	мДокМетаданные  = ДокументОбъект.Метаданные();
	мИмяДокумента   = мДокМетаданные.Имя;
	мСтатусПередачи = СтатусПередачи;
	мИмяТабличнойЧасти       = СокрЛП(ИмяТабличнойЧасти);
	мСтруктураШапкиДокумента = СтруктураШапкиДокумента;
	мТабЧастьМетаданные      = мДокМетаданные.ТабличныеЧасти[мИмяТабличнойЧасти].Реквизиты;
	мОтказ	        = Отказ;
	мЗаголовок      = Заголовок;
	мИмяТаблицы     = мИмяДокумента + "." + мИмяТабличнойЧасти;
	
	Если мИмяДокумента = "ВозвратТоваровОтПокупателя" Тогда
		КонтрольОстатков_ВозвратТоваровОтПокупателя(ДокументОбъект);
	Иначе
		КонтрольОстатков_ЗаказВШапке(ДокументОбъект);
	КонецЕсли;
	
	Отказ     = мОтказ;
	Заголовок = мЗаголовок;
	
КонецПроцедуры // КонтрольОстатков()

// Процедура контролирует остаток по данному регистру по переданному документу
// и его табличной части. В случае недостатка товаров выставляется флаг отказа и 
// выдается сообщение.
//
// При контроле предполагается что сделка (заказ) расположены в шапке документа.
//
// Параметры:
//  ДокументОбъект          - объект проводимого документа. 
//
Процедура КонтрольОстатков_ЗаказВШапке(ДокументОбъект)
	
	ЕстьСерия            = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("СерияНоменклатуры", мДокМетаданные, мИмяТабличнойЧасти);
	ЕстьХарактеристика   = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("ХарактеристикаНоменклатуры", мДокМетаданные, мИмяТабличнойЧасти);
	ЕстьКоэффициент      = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("Коэффициент", мДокМетаданные, мИмяТабличнойЧасти);
	ЕстьСуммаВключаетНДС = ОбщегоНазначения.ЕстьРеквизитДокумента("СуммаВключаетНДС", мДокМетаданные);

	Если ОбщегоНазначения.ЕстьРеквизитДокумента("Заказ", мДокМетаданные) Тогда
		ИмяЗаказа = "Заказ";
	ИначеЕсли ОбщегоНазначения.ЕстьРеквизитДокумента("Сделка", мДокМетаданные) Тогда
		ИмяЗаказа = "Сделка";
	Иначе
		ИмяЗаказа = "";
	КонецЕсли;

	// Для документ "Переоценка товаров, отданных на комиссию" должен контролировать реквизит "Сумма старая",
	// остальные документы - "Сумма".
	ИмяСуммы    = ?(ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("СуммаСтарая", мДокМетаданные, мИмяТабличнойЧасти), "Док.СуммаСтарая", ?(ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("СуммаПередачи", мДокМетаданные, мИмяТабличнойЧасти), "Док.СуммаПередачи","Док.Сумма"));
	
	Если мИмяТабличнойЧасти = "Товары" Тогда
		Если ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("СуммаСтарая", мДокМетаданные, мИмяТабличнойЧасти) Тогда
			ИмяСуммыНДС = "";
		ИначеЕсли ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("СуммаПередачи", мДокМетаданные, мИмяТабличнойЧасти) Тогда
			ИмяСуммыНДС = "Док.СуммаНДСПередачи";
		ИначеЕсли ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("СуммаНДС", мДокМетаданные, мИмяТабличнойЧасти) Тогда
			ИмяСуммыНДС = "Док.СуммаНДС";
		Иначе
			ИмяСуммыНДС = "";
		КонецЕсли;
			
		ИмяСуммы    = ?(ЕстьСуммаВключаетНДС И Не мСтруктураШапкиДокумента.СуммаВключаетНДС И Не ПустаяСтрока(ИмяСуммыНДС), "(" + ИмяСуммы + "+" + ИмяСуммыНДС + ")", ИмяСуммы);
	КонецЕсли;

	ИмяСуммы    = ИмяСуммы + " * &КратностьВзаиморасчетов * &КурсДокумента / &КурсВзаиморасчетов / &КратностьДокумента";

	// Текст вложенного запроса, ограничивающего номенклатуру при получении остатков
	ТекстЗапросаСписокНоменклатуры = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура 
	|ИЗ
	|	Документ." + мИмяТаблицы +"
	|ГДЕ Ссылка = &ДокументСсылка";


	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",     мСтруктураШапкиДокумента.Ссылка);
	Запрос.УстановитьПараметр("ДоговорКонтрагента", мСтруктураШапкиДокумента.ДоговорКонтрагента); 

	Если НЕ ЗначениеЗаполнено(мСтруктураШапкиДокумента[ИмяЗаказа]) Тогда
		Запрос.УстановитьПараметр("Сделка", Неопределено); 
	Иначе
		Запрос.УстановитьПараметр("Сделка", мСтруктураШапкиДокумента[ИмяЗаказа]); 
	КонецЕсли;

	Запрос.УстановитьПараметр("СтатусПередачи",      мСтатусПередачи);

	Запрос.УстановитьПараметр("КурсДокумента",           ЗаполнениеДокументов.КурсДокумента(ДокументОбъект, глЗначениеПеременной("ВалютаРегламентированногоУчета")));
	Запрос.УстановитьПараметр("КратностьДокумента",      ЗаполнениеДокументов.КратностьДокумента(ДокументОбъект, глЗначениеПеременной("ВалютаРегламентированногоУчета")));
	Запрос.УстановитьПараметр("КурсВзаиморасчетов",      мСтруктураШапкиДокумента.КурсВзаиморасчетов);
	Запрос.УстановитьПараметр("КратностьВзаиморасчетов", мСтруктураШапкиДокумента.КратностьВзаиморасчетов);

	Запрос.Текст = "
	|ВЫБРАТЬ // Запрос, контролирующий остатки на складах
	|	Док.Номенклатура.Представление                         КАК НоменклатураПредставление,
	|	Док.Номенклатура.ЕдиницаХраненияОстатков.Представление КАК ЕдиницаХраненияОстатковПредставление,"
	+ ?(ЕстьХарактеристика, "
	|	Док.ХарактеристикаНоменклатуры           КАК ХарактеристикаНоменклатуры,"
	,"")
	+ ?(ЕстьСерия, "
	|	Док.СерияНоменклатуры                    КАК СерияНоменклатуры,"
	,"")
	+ ?(ЕстьКоэффициент, "
	|	ВЫРАЗИТЬ(СУММА(Док.Количество * Док.Коэффициент /Док.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК Число(15,3)) КАК ДокументКоличество,", "
	|	СУММА(Док.Количество)                                  		КАК ДокументКоличество,") + "
	|	ЕСТЬNULL(МАКСИМУМ(Остатки.КоличествоОстаток), 0)       		КАК ОстатокКоличество,
	|	СУММА(ВЫРАЗИТЬ(" + ИмяСуммы + " КАК Число(15,2)))      		КАК ДокументСумма, 
	|	ЕСТЬNULL(МАКСИМУМ(Остатки.СуммаВзаиморасчетовОстаток), 0)	КАК ОстатокСумма
	|ИЗ 
	|	Документ." + мИмяТаблицы + " КАК Док
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ТоварыПереданные.Остатки(,
	|		Номенклатура В (" + ТекстЗапросаСписокНоменклатуры + ")
	|	И ДоговорКонтрагента = &ДоговорКонтрагента
	|   И Сделка                = &Сделка
	|	И СтатусПередачи        = &СтатусПередачи
	|	) КАК Остатки
	|ПО 
	|	Док.Номенклатура                = Остатки.Номенклатура"
	+ ?(ЕстьХарактеристика, "
	| И Док.ХарактеристикаНоменклатуры  = Остатки.ХарактеристикаНоменклатуры"
	,"")
	+ ?(ЕстьСерия, "
	| И Док.СерияНоменклатуры  = Остатки.СерияНоменклатуры"
	,"") + "
	|
	|ГДЕ
	|	Док.Ссылка  =  &ДокументСсылка
	|
	|СГРУППИРОВАТЬ ПО
	|
	|	Док.Номенклатура"
	+ ?(ЕстьХарактеристика, "
	|	, Док.ХарактеристикаНоменклатуры "
	,"")
	+ ?(ЕстьСерия, "
	|	, Док.СерияНоменклатуры "
	,"") + "
	|	
	|ИМЕЮЩИЕ ЕСТЬNULL(МАКСИМУМ(Остатки.КоличествоОстаток), 0) < СУММА(Док.Количество)
	| ИЛИ  ЕСТЬNULL(МАКСИМУМ(Остатки.СуммаВзаиморасчетовОстаток), 0) < СУММА(" + ИмяСуммы + ")
	|	
	|ДЛЯ ИЗМЕНЕНИЯ РегистрНакопления.ТоварыПереданные.Остатки // Блокирующие чтение таблицы остатков регистра для разрешения коллизий многопользовательской работы
	|";

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		//КоличествоОстаток = ?(Выборка.ОстатокКоличество = NULL, 0, Выборка.ОстатокКоличество);

		Если Выборка.ОстатокКоличество < Выборка.ДокументКоличество Тогда

			СтрокаСообщения = "Остатка " + 
			УправлениеЗапасами.ПредставлениеНоменклатуры(Выборка.НоменклатураПредставление, 
			                          ?(ЕстьХарактеристика, Выборка.ХарактеристикаНоменклатуры, ""), ?(ЕстьСерия, Выборка.СерияНоменклатуры, "")) +
			" переданного по договору """ + СокрЛП(мСтруктураШапкиДокумента.ДоговорКонтрагента) + ?(НЕ ЗначениеЗаполнено(мСтруктураШапкиДокумента[ИмяЗаказа]), "",
			" и по заказу " + СокрЛП(мСтруктураШапкиДокумента[ИмяЗаказа])) +
			""" недостаточно.";

			УправлениеЗапасами.ОшибкаНетОстатка(СтрокаСообщения, Выборка.ОстатокКоличество, Выборка.ДокументКоличество,
			Выборка.ЕдиницаХраненияОстатковПредставление, мОтказ, мЗаголовок);

		КонецЕсли;

		//СуммаОстаток = ?(Выборка.ОстатокСумма = NULL, 0, Выборка.ОстатокСумма);
		
		Если Выборка.ОстатокСумма < Выборка.ДокументСумма Тогда

			СтрокаСообщения = "Остатка суммы взаиморасчетов по товару " + 
			УправлениеЗапасами.ПредставлениеНоменклатуры(Выборка.НоменклатураПредставление, 
			                          ?(ЕстьХарактеристика, Выборка.ХарактеристикаНоменклатуры, ""), ?(ЕстьСерия, Выборка.СерияНоменклатуры, "")) +
			" переданному по договору """ + СокрЛП(мСтруктураШапкиДокумента.ДоговорКонтрагента) + ?(НЕ ЗначениеЗаполнено(мСтруктураШапкиДокумента[ИмяЗаказа]), "",
			" и по заказу " + СокрЛП(мСтруктураШапкиДокумента[ИмяЗаказа])) +
			""" недостаточно.";

			УправлениеЗапасами.ОшибкаНетОстатка(СтрокаСообщения, Выборка.ОстатокСумма, Выборка.ДокументСумма, 
			мСтруктураШапкиДокумента.ВалютаВзаиморасчетов, мОтказ, мЗаголовок);

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // КонтрольОстатков()

// Процедура контролирует остаток по данному регистру по переданному документу
// и его табличной части. В случае недостатка товаров выставляется флаг отказа и 
// выдается сообщение.
//
// При контроле предполагается что сделка (заказ) расположены в табличной части документа.
// Параметры:
//  ДокументОбъект          - объект проводимого документа. 
//
Процедура КонтрольОстатков_ВозвратТоваровОтПокупателя(ДокументОбъект)
	
	ЕстьСерия            = мТабЧастьМетаданные.Найти("СерияНоменклатуры")          <> Неопределено;
	ЕстьХарактеристика   = мТабЧастьМетаданные.Найти("ХарактеристикаНоменклатуры") <> Неопределено;
	ЕстьКоэффициент      = мТабЧастьМетаданные.Найти("Коэффициент")                <> Неопределено;
	ЕстьСуммаВключаетНДС = мДокМетаданные.Реквизиты.Найти("СуммаВключаетНДС")      <> Неопределено;

	Если ОбщегоНазначения.ЕстьРеквизитДокумента("Заказ", мДокМетаданные) Тогда
		ИмяЗаказа = "Заказ";
	ИначеЕсли ОбщегоНазначения.ЕстьРеквизитДокумента("Сделка", мДокМетаданные) Тогда
		ИмяЗаказа = "Сделка";
	Иначе
		ИмяЗаказа = "";
	КонецЕсли;

	// Для документ "Переоценка товаров, отданных на комиссию" должен контролировать реквизит "Сумма старая",
	// остальные документы - "Сумма".
	ИмяСуммы = "Док.Сумма";
	
	Если мИмяТабличнойЧасти = "Товары" Тогда
	
		Если ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("СуммаСтарая", мДокМетаданные, мИмяТабличнойЧасти) Тогда
			ИмяСуммыНДС = "";
		ИначеЕсли ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("СуммаПередачи", мДокМетаданные, мИмяТабличнойЧасти) Тогда
			ИмяСуммыНДС = "Док.СуммаНДСПередачи";
		ИначеЕсли ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("СуммаНДС", мДокМетаданные, мИмяТабличнойЧасти) Тогда
			ИмяСуммыНДС = "Док.СуммаНДС";
		Иначе
			ИмяСуммыНДС = "";
		КонецЕсли;
			
		ИмяСуммы    = ?(ЕстьСуммаВключаетНДС И Не мСтруктураШапкиДокумента.СуммаВключаетНДС И Не ПустаяСтрока(ИмяСуммыНДС), "(" + ИмяСуммы + "+" + ИмяСуммыНДС + ")", ИмяСуммы);
		
	КонецЕсли;

	ИмяСуммы = ИмяСуммы + " * &КратностьВзаиморасчетов * &КурсДокумента / &КурсВзаиморасчетов / &КратностьДокумента";

	// Текст вложенного запроса, ограничивающего номенклатуру при получении остатков
	ТекстЗапросаСписокНоменклатуры = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура 
	|ИЗ
	|	Документ." + мИмяТаблицы +"
	|ГДЕ Ссылка = &ДокументСсылка";

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",     мСтруктураШапкиДокумента.Ссылка);
	Запрос.УстановитьПараметр("ДоговорКонтрагента", мСтруктураШапкиДокумента.ДоговорКонтрагента); 

	Запрос.УстановитьПараметр("СтатусПередачи",      мСтатусПередачи);

	Запрос.УстановитьПараметр("КурсДокумента",           ЗаполнениеДокументов.КурсДокумента(ДокументОбъект, глЗначениеПеременной("ВалютаРегламентированногоУчета")));
	Запрос.УстановитьПараметр("КратностьДокумента",      ЗаполнениеДокументов.КратностьДокумента(ДокументОбъект, глЗначениеПеременной("ВалютаРегламентированногоУчета")));
	Запрос.УстановитьПараметр("КурсВзаиморасчетов",      мСтруктураШапкиДокумента.КурсВзаиморасчетов);
	Запрос.УстановитьПараметр("КратностьВзаиморасчетов", мСтруктураШапкиДокумента.КратностьВзаиморасчетов);
	Запрос.УстановитьПараметр("Сделка",                  мСтруктураШапкиДокумента.Сделка);
	
	ПустыеЗаказы = ОбщегоНазначения.МассивПустыхЗначений(мТабЧастьМетаданные.ЗаказПокупателя.Тип);
	Запрос.УстановитьПараметр("ПустыеЗаказы", ПустыеЗаказы);

	ТекстЗапроса = "
		|ВЫБРАТЬ // Запрос, контролирующий остатки на складах
		|	Док.Номенклатура.Представление                         КАК НоменклатураПредставление,
		|	Док.Номенклатура.ЕдиницаХраненияОстатков.Представление КАК ЕдиницаХраненияОстатковПредставление,
		|	//СТРОКАЗАКАЗА 
		|	//СТРОКАПРЕДСТАВЛЕНИЯЗАКАЗА 
		|	%ПОЛЕ_Док_Характеристика%    КАК ХарактеристикаНоменклатуры,
		|	%ПОЛЕ_Док_СерияНоменклатуры% КАК СерияНоменклатуры,
		|	%ПОЛЕ_Док_Количество%        КАК ДокументКоличество,
		|	ЕСТЬNULL(МАКСИМУМ(Остатки.КоличествоОстаток), 0)       		КАК ОстатокКоличество,
		|	СУММА(ВЫРАЗИТЬ(" + ИмяСуммы + " КАК Число(15,2)))      		КАК ДокументСумма, 
		|	ЕСТЬNULL(МАКСИМУМ(Остатки.СуммаВзаиморасчетовОстаток), 0)	КАК ОстатокСумма
		|ИЗ 
		|	Документ." + мИмяТаблицы + " КАК Док
		|
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрНакопления.ТоварыПереданные.Остатки(,
		|		Номенклатура В (%ВыборкаПоНоменклатуре%)
		|		И ДоговорКонтрагента = &ДоговорКонтрагента
		|		И СтатусПередачи     = &СтатусПередачи) КАК Остатки
		|ПО 
		|	Док.Номенклатура = Остатки.Номенклатура
		|   //СОЕДИНЕНИЕ_Заказ_Остатки
		|   //СОЕДИНЕНИЕ_Характеристика_Остатки
		|   //СОЕДИНЕНИЕ_Серия_Остатки
		|
		|ГДЕ
		|	Док.Ссылка = &ДокументСсылка
		|
		|СГРУППИРОВАТЬ ПО
		|	Док.Номенклатура,
		|	%ПОЛЕ_Док_Заказ%
		|	%ПОЛЕ_Док_Характеристика%,
		|	%ПОЛЕ_Док_СерияНоменклатуры%
		|	
		|//ИМЕЮЩИЕ ЕСТЬNULL(МАКСИМУМ(Остатки.КоличествоОстаток), 0) < СУММА(Док.Количество)
		|// ИЛИ  ЕСТЬNULL(МАКСИМУМ(Остатки.СуммаВзаиморасчетовОстаток), 0) < СУММА(" + ИмяСуммы + ")
		|	
		|ДЛЯ ИЗМЕНЕНИЯ РегистрНакопления.ТоварыПереданные.Остатки // Блокирующие чтение таблицы остатков регистра для разрешения коллизий многопользовательской работы
		|";
		
	// Преобразуем текст запроса
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ВыборкаПоНоменклатуре%",  ТекстЗапросаСписокНоменклатуры);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ПОЛЕ_Док_Количество%",    ?(ЕстьКоэффициент,
						"ВЫРАЗИТЬ(СУММА(Док.Количество * Док.Коэффициент /Док.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК Число(15,3))",
						"СУММА(Док.Количество)"));
						
	Если ЕстьХарактеристика Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ПОЛЕ_Док_Характеристика%",           "Док.ХарактеристикаНоменклатуры");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//СОЕДИНЕНИЕ_Характеристика_Остатки", "И Док.ХарактеристикаНоменклатуры = Остатки.ХарактеристикаНоменклатуры");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ПОЛЕ_Док_Характеристика%",           "Неопределено");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//СОЕДИНЕНИЕ_Характеристика_Остатки", "");
	КонецЕсли;
	Если ЕстьСерия Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ПОЛЕ_Док_СерияНоменклатуры%", "Док.СерияНоменклатуры");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//СОЕДИНЕНИЕ_Серия_Остатки",   "И Док.СерияНоменклатуры = Остатки.СерияНоменклатуры");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ПОЛЕ_Док_СерияНоменклатуры%", "Неопределено");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//СОЕДИНЕНИЕ_Серия_Остатки",   "");
	КонецЕсли;
	
	Если мСтруктураШапкиДокумента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//СОЕДИНЕНИЕ_Заказ_Остатки", " И ВЫБОР КОГДА Док.ЗаказПокупателя = ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка) ТОГДА Неопределено ИНАЧЕ Док.ЗаказПокупателя КОНЕЦ = Остатки.Сделка");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//СТРОКАЗАКАЗА"," Док.ЗаказПокупателя КАК Заказ,");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//СТРОКАПРЕДСТАВЛЕНИЯЗАКАЗА", "ПРЕДСТАВЛЕНИЕ(Док.ЗаказПокупателя) КАК ЗаказПредставление,");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ПОЛЕ_Док_Заказ%", " Док.ЗаказПокупателя,");
	ИначеЕсли мСтруктураШапкиДокумента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//СОЕДИНЕНИЕ_Заказ_Остатки",
			"И   (&Сделка = Остатки.Сделка)");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//СТРОКАЗАКАЗА",
		"&Сделка                                      КАК Заказ,");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//СТРОКАПРЕДСТАВЛЕНИЯЗАКАЗА",
		"ПРЕДСТАВЛЕНИЕ(&Сделка)                       КАК ЗаказПредставление,");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ПОЛЕ_Док_Заказ%", "Док.Ссылка.Сделка,");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//СОЕДИНЕНИЕ_Заказ_Остатки",
			"И   (Док.ЗаказПокупателя = Остатки.Сделка
			|ИЛИ (Док.ЗаказПокупателя В (&ПустыеЗаказы) И Остатки.Сделка = Неопределено))");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//СТРОКАЗАКАЗА",
		"Док.ЗаказПокупателя                                    КАК Заказ,");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//СТРОКАПРЕДСТАВЛЕНИЯЗАКАЗА",
		"ПРЕДСТАВЛЕНИЕ(Док.ЗаказПокупателя)                     КАК ЗаказПредставление,");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ПОЛЕ_Док_Заказ%", "Док.ЗаказПокупателя,");
	КонецЕсли;

	// Выполнение запроса
	Запрос.Текст = ТекстЗапроса;
		
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		//КоличествоОстаток = ?(Выборка.ОстатокКоличество = NULL, 0, Выборка.ОстатокКоличество);

		Если Выборка.ОстатокКоличество < Выборка.ДокументКоличество Тогда

			СтрокаСообщения = "Остатка " + 
			УправлениеЗапасами.ПредставлениеНоменклатуры(Выборка.НоменклатураПредставление, 
			                          ?(ЕстьХарактеристика, Выборка.ХарактеристикаНоменклатуры, ""), ?(ЕстьСерия, Выборка.СерияНоменклатуры, "")) +
			" переданного по договору """ + СокрЛП(мСтруктураШапкиДокумента.ДоговорКонтрагента) + ?(НЕ ЗначениеЗаполнено(Выборка.Заказ), "",
			" и по заказу " + Выборка.ЗаказПредставление) +
			""" недостаточно.";

			УправлениеЗапасами.ОшибкаНетОстатка(СтрокаСообщения, Выборка.ОстатокКоличество, Выборка.ДокументКоличество,
			Выборка.ЕдиницаХраненияОстатковПредставление, мОтказ, мЗаголовок);

		КонецЕсли;

		//СуммаОстаток = ?(Выборка.ОстатокСумма = NULL, 0, Выборка.ОстатокСумма);
		
		Если Выборка.ОстатокСумма < Выборка.ДокументСумма Тогда

			СтрокаСообщения = "Остатка суммы взаиморасчетов по товару " + 
			УправлениеЗапасами.ПредставлениеНоменклатуры(Выборка.НоменклатураПредставление, 
			                          ?(ЕстьХарактеристика, Выборка.ХарактеристикаНоменклатуры, ""), ?(ЕстьСерия, Выборка.СерияНоменклатуры, "")) +
			" переданному по договору """ + СокрЛП(мСтруктураШапкиДокумента.ДоговорКонтрагента) + ?(НЕ ЗначениеЗаполнено(Выборка.Заказ), "",
			" и по заказу " + Выборка.ЗаказПредставление) +
			""" недостаточно.";

			УправлениеЗапасами.ОшибкаНетОстатка(СтрокаСообщения, Выборка.ОстатокСумма, Выборка.ДокументСумма, 
			мСтруктураШапкиДокумента.ВалютаВзаиморасчетов, мОтказ, мЗаголовок);

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // КонтрольОстатков()

// Процедура контролирует лимиты возвратной тары, передаваемой покупателю по переданному документу
// и его табличной части. В случае превышения лимита выставляется флаг отказа и 
// выдается сообщение.
//
// Параметры:
//  ДокументОбъект    - объект проводимого документа, 
//  СтруктураШапкиДокумента - структура, содержащая значения "через точку" ссылочных реквизитов по шапке документа,
//  Отказ             - флаг отказа в проведении,
//  Заголовок         - строка, заголовок сообщения об ошибке проведения.
//
Процедура КонтрольЛимитовВозвратнойТары(ДокументОбъект, СтруктураШапкиДокумента, Отказ, Заголовок) Экспорт

	ИмяТабличнойЧасти  = "ВозвратнаяТара";
	ИмяДокумента       = ДокументОбъект.Метаданные().Имя;
	ИмяТаблицы         = ИмяДокумента + "." + СокрЛП(ИмяТабличнойЧасти);

	// Текст вложенного запроса, ограничивающего номенклатуру при получении остатков
	ТекстЗапросаСписокНоменклатуры = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура 
	|ИЗ
	|	Документ." + ИмяТаблицы +"
	|ГДЕ Ссылка = &ДокументСсылка";


	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",          СтруктураШапкиДокумента.Ссылка);
	Запрос.УстановитьПараметр("Дата",                    СтруктураШапкиДокумента.Дата);
	Запрос.УстановитьПараметр("ДоговорКонтрагента",   СтруктураШапкиДокумента.ДоговорКонтрагента); 
	
	Запрос.УстановитьПараметр("СтатусПередачи",          Перечисления.СтатусыПолученияПередачиТоваров.ВозвратнаяТара);

	Запрос.Текст = "
	|ВЫБРАТЬ // Запрос, контролирующий остатки на складах
	|	Док.Номенклатура.Представление                         КАК НоменклатураПредставление,
	|	Док.Номенклатура.ЕдиницаХраненияОстатков.Представление КАК ЕдиницаХраненияОстатковПредставление,
	|	СУММА(Док.Количество) КАК ДокументКоличество, 
	|	ЕСТЬNULL(МАКСИМУМ(Остатки.КоличествоОстаток), 0) 	   КАК ОстатокКоличество,
	|	МИНИМУМ(Лимиты.ЛимитПокупателю)                        КАК Лимит
	|   
	|ИЗ 
	|	Документ." + ИмяТаблицы + " КАК Док
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ТоварыПереданные.Остатки(,
	|		Номенклатура В (" + ТекстЗапросаСписокНоменклатуры + ")
	|	И ДоговорКонтрагента = &ДоговорКонтрагента
	|	И СтатусПередачи        = &СтатусПередачи
	|	) КАК Остатки
	|ПО 
	|	Док.Номенклатура                = Остатки.Номенклатура
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ЛимитыВозвратнойТары.СрезПоследних(,
	|		Номенклатура В (" + ТекстЗапросаСписокНоменклатуры + ")
	|	И ДоговорКонтрагента = &ДоговорКонтрагента
	|	) КАК Лимиты
	|ПО 
	|	Док.Номенклатура                = Лимиты.Номенклатура
	|
	|ГДЕ
	|	Док.Ссылка  =  &ДокументСсылка
	|	И НЕ Лимиты.ЛимитПокупателю ЕСТЬ NULL
	|	И Лимиты.ЛимитПокупателю > 0
	|
	|СГРУППИРОВАТЬ ПО
	|
	|	Док.Номенклатура
	|
	|ИМЕЮЩИЕ ЕСТЬNULL(МАКСИМУМ(Остатки.КоличествоОстаток), 0) + СУММА(Док.Количество) > МИНИМУМ(Лимиты.ЛимитПокупателю)
	|
	|ДЛЯ ИЗМЕНЕНИЯ РегистрНакопления.ТоварыПереданные.Остатки // Блокирующие чтение таблицы остатков регистра для разрешения коллизий многопользовательской работы
	|";

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		СтрокаСообщения = "По " + 
		УправлениеЗапасами.ПредставлениеНоменклатуры(Выборка.НоменклатураПредставление, "", "") +
		" по договору """ + СокрЛП(СтруктураШапкиДокумента.ДоговорКонтрагента) + """ превышен лимит возвратной тары.";

		ОбщегоНазначения.СообщитьОбОшибке(СтрокаСообщения + Символы.ПС + Символы.Таб +
						   "Лимит " + (Выборка.Лимит) + " " + Выборка.ЕдиницаХраненияОстатковПредставление +
						   "; Передано ранее " + Выборка.ОстатокКоличество + " " + Выборка.ЕдиницаХраненияОстатковПредставление +
						   "; Требуется передать " + Выборка.ДокументКоличество + " " + Выборка.ЕдиницаХраненияОстатковПредставление, Отказ);

	КонецЦикла;

КонецПроцедуры // КонтрольЛимитовВозвратнойТары()

