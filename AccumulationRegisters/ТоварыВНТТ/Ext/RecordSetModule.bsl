﻿Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

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
//  ДокументОбъект    - объект проводимого документа, 
//  ИмяТабличнойЧасти - строка, имя табличной части, которая проводится по регистру, 
//  СтруктураШапкиДокумента - структура, содержащая значения "через точку" ссылочных реквизитов по шапке документа,
//  Отказ             - флаг отказа в проведении,
//  Заголовок         - строка, заголовок сообщения об ошибке проведения.
//
Процедура КонтрольОстатков(ДокументОбъект, ИмяТабличнойЧасти, СтруктураШапкиДокумента, Отказ, Заголовок) Экспорт

	МетаданныеДокумента = ДокументОбъект.Метаданные();
	ИмяДокумента        = МетаданныеДокумента.Имя;
	ИмяТаблицы          = ИмяДокумента + "." + СокрЛП(ИмяТабличнойЧасти);
	ЕстьСерия           = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("СерияНоменклатуры", МетаданныеДокумента, ИмяТабличнойЧасти);
	ЕстьХарактеристика  = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("ХарактеристикаНоменклатуры", МетаданныеДокумента, ИмяТабличнойЧасти);
	ЕстьЦена            = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("Цена", МетаданныеДокумента, ИмяТабличнойЧасти);
	ЕстьСкладВТабЧасти  = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("Склад", МетаданныеДокумента, ИмяТабличнойЧасти);
	ЕстьКоэффициент     = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("Коэффициент", МетаданныеДокумента, ИмяТабличнойЧасти);
	
	Если ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("ЦенаВРозницеСтарая", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
		ИмяПоляЦены = "ЦенаВРозницеСтарая";
	ИначеЕсли ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("ЦенаВРознице", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
		ИмяПоляЦены = "ЦенаВРознице";
	ИначеЕсли ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("Цена", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
		ИмяПоляЦены = "Цена";
	Иначе
		ИмяПоляЦены = "";
	КонецЕсли;

	// Текст вложенного запроса, ограничивающего номенклатуру при получении остатков
	ТекстЗапросаСписокНоменклатуры = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура 
	|ИЗ
	|	Документ." + ИмяТаблицы +"
	|ГДЕ Ссылка = &ДокументСсылка";
	
	//Текст запроса для получения розничной цены
	Если НЕ ЗначениеЗаполнено(ИмяПоляЦены) Тогда
		ТекстЗапросаРознЦена = "";
	ИначеЕсли ЕстьКоэффициент Тогда
		ТекстЗапросаРознЦена = "Док."+ИмяПоляЦены+" * Док.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / Док.Коэффициент  КАК "+ИмяПоляЦены+", ";
	Иначе
		ТекстЗапросаРознЦена = "Док."+ИмяПоляЦены+", ";
	КонецЕсли;
	
	//Текст вложенного запроса для выборки полей документа
	ТекстЗапросаРеквизитыДокумента = "(
	|ВЫБРАТЬ
	|Док.Ссылка,
	|Док.Номенклатура, "+
	?(ЕстьКоэффициент, "Док.Коэффициент, ","")+
	?(ЕстьХарактеристика, "Док.ХарактеристикаНоменклатуры, ","")+
	?(ЕстьСерия, "Док.СерияНоменклатуры, ","")+
	ТекстЗапросаРознЦена+
    ?(ЕстьСкладВТабЧасти, "Док.Склад, ","")+"
    |Док.Количество
	|ИЗ Документ."+ИмяТаблицы+" КАК Док
	|ГДЕ 
	|	Док.Ссылка  =  &ДокументСсылка 
	|	И Не Док.Номенклатура.Услуга" // остатки по услугам контролировать не надо.
	+ ?(ЕстьСкладВТабЧасти, "
	|	И Док.Склад.ВидСклада = &НТТ"
	, "") + "
	|) КАК Док";


	Запрос = Новый Запрос;

	// Для перемещения надо проверять по складу "Склад-отправитель", а для остальных документов - просто "Склад"
	ТекСклад = СтруктураШапкиДокумента.Склад;
	
	Если ЕстьСкладВТабЧасти Тогда
		ЗапросСклады = новый Запрос;
		ЗапросСклады.Текст = "Выбрать различные Склад ИЗ Документ."+ИмяТаблицы+"
		|ГДЕ Ссылка=&ДокументСсылка";
		ЗапросСклады.УстановитьПараметр("ДокументСсылка",СтруктураШапкиДокумента.Ссылка);
		СписокСкладов = ЗапросСклады.Выполнить().Выгрузить().ВыгрузитьКолонку("Склад");
	Иначе
		СписокСкладов = новый СписокЗначений;
		СписокСкладов.Добавить(СтруктураШапкиДокумента.Склад);
	КонецЕсли;
	
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", СтруктураШапкиДокумента.Ссылка);
	Запрос.УстановитьПараметр("Склад", текСклад); 
	Запрос.УстановитьПараметр("СписокСкладов", СписокСкладов);
	Запрос.УстановитьПараметр("НТТ", Перечисления.ВидыСкладов.НТТ); 
	Если ИмяТабличнойЧасти = "ВозвратнаяТара" Тогда
		Запрос.УстановитьПараметр("ТоварТара", Перечисления.ТоварТара.Тара);
		ИмяПоляЦены = "";
	Иначе
		Запрос.УстановитьПараметр("ТоварТара", Перечисления.ТоварТара.Товар);
	КонецЕсли;

	Запрос.Текст = "
	|ВЫБРАТЬ // Запрос, контролирующий остатки на складах
	|	Док.Номенклатура.Представление                         КАК НоменклатураПредставление,
	|	Док.Номенклатура.ЕдиницаХраненияОстатков.Представление КАК ЕдиницаХраненияОстатковПредставление,"
	+ ?(ЕстьХарактеристика, "
	|	Док.ХарактеристикаНоменклатуры				           КАК ХарактеристикаНоменклатуры,"
	,"")
	+ ?(ЕстьСерия, "
	|	Док.СерияНоменклатуры			                       КАК СерияНоменклатуры,"
	,"")
	+ ?(ЗначениеЗаполнено(ИмяПоляЦены), "
	|   Док." + ИмяПоляЦены + "                                КАК ЦенаВРознице, "
	,"
	|   0                                                      КАК ЦенаВРознице,")
	+ ?(Не ЕстьСкладВТабЧасти, "
	|   &Склад                                                 КАК Склад, ", "
	|   Док.Склад,")
	+ ?(ЕстьКоэффициент, "
	|	ВЫРАЗИТЬ(СУММА(Док.Количество * Док.Коэффициент /Док.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК Число(15,3)) КАК ДокументКоличество,", "
	|	СУММА(Док.Количество)                                  КАК ДокументКоличество,") + "
	|	ЕСТЬNULL(МАКСИМУМ(Остатки.КоличествоОстаток), 0)       КАК ОстатокКоличество
	|ИЗ "+ТекстЗапросаРеквизитыДокумента+"
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ТоварыВНТТ.Остатки(,
	|		Номенклатура В (" + ТекстЗапросаСписокНоменклатуры + ") 
	|	И Склад в (&СписокСкладов) 
	|	И ТоварТара = &ТоварТара
	|	) КАК Остатки
	|ПО 
	|	Док.Номенклатура                = Остатки.Номенклатура"
	+ ?(ЕстьХарактеристика, "
	| И Док.ХарактеристикаНоменклатуры  = Остатки.ХарактеристикаНоменклатуры"
	,"")
	+ ?(ЕстьСерия, "
	| И Док.СерияНоменклатуры           = Остатки.СерияНоменклатуры"
	,"")
	+ ?(ЗначениеЗаполнено(ИмяПоляЦены), "
	| И Док." + ИмяПоляЦены + "         = Остатки.ЦенаВРознице"
	,"")
	+ ?(ЕстьСкладВТабЧасти, "
	| И Док.Склад                       = Остатки.Склад "
	, "") + "
	|СГРУППИРОВАТЬ ПО
	|
	|	Док.Номенклатура"
	+ ?(ЕстьХарактеристика, ",
	|	Док.ХарактеристикаНоменклатуры"
	,"")
	+ ?(ЕстьСерия, ",
	|	Док.СерияНоменклатуры"
	,"")
	+ ?(ЗначениеЗаполнено(ИмяПоляЦены), "
	|  , Док." + ИмяПоляЦены 
	,"") 
	+ ?(ЕстьСкладВТабЧасти, ",
	|   Док.Склад", "") + "
	
	|
	|ИМЕЮЩИЕ ЕСТЬNULL(МАКСИМУМ(Остатки.КоличествоОстаток), 0) < " + ?(ЕстьКоэффициент, "ВЫРАЗИТЬ(СУММА(Док.Количество * Док.Коэффициент /Док.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК Число(15,3))", "СУММА(Док.Количество)") + "
	|ДЛЯ ИЗМЕНЕНИЯ РегистрНакопления.ТоварыВНТТ.Остатки // Блокирующие чтение таблицы остатков регистра для разрешения коллизий многопользовательской работы
	|";

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаСообщения = "Остатка " + 
		УправлениеЗапасами.ПредставлениеНоменклатуры(Выборка.НоменклатураПредставление, 
								  ?(ЕстьХарактеристика, Выборка.ХарактеристикаНоменклатуры, ""),
								  ?(ЕстьСерия, Выборка.СерияНоменклатуры,"")) +
		" на складе """ + СокрЛП(Выборка.Склад) + """ по цене " + Выборка.ЦенаВРознице + 
		" недостаточно.";

		УправлениеЗапасами.ОшибкаНетОстатка(СтрокаСообщения, Выборка.ОстатокКоличество, Выборка.ДокументКоличество,
		Выборка.ЕдиницаХраненияОстатковПредставление, Отказ, Заголовок);

	КонецЦикла;

КонецПроцедуры // КонтрольОстатков()

