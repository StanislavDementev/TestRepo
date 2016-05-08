﻿Перем мУдалятьДвижения;

// Хранит структуру, содержащую параметры для определения договора, доступного в данном документе:
//    список допустимых видов договоров;
//    список допустимых способов ведения взаиморасчетов.
Перем мСтруктураПараметровДляПолученияДоговора Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

// Функция формирует табличный документ с печатной формой накладной,
// разработанной методистами
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьДокумента()

	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ВыводитьКоды    = Истина;
		Колонка         = "Артикул";
		ТекстКодАртикул = "Артикул";
	ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
		ВыводитьКоды    = Истина;
		Колонка         = "Код";
		ТекстКодАртикул = "Код";
	Иначе
		ВыводитьКоды    = Ложь;
		Колонка         = "";
		ТекстКодАртикул = "Код";
	КонецЕсли;

	Если ВыводитьКоды Тогда
		ОбластьШапки  = "ШапкаСКодом";
		ОбластьСтроки = "СтрокаСКодом";
	Иначе
		ОбластьШапки  = "ШапкаТаблицы";
		ОбластьСтроки = "Строка";
	Конецесли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	Организация,
	|	Организация КАК Поставщик,
	|	Контрагент КАК Получатель,
	|	ВозвратнаяТара.(
	|		НомерСтроки,
	|		Номенклатура,
	|		Номенклатура."+ ТекстКодАртикул + " КАК КодАртикул,
	|		Номенклатура.НаименованиеПолное КАК Товар,
	|		Номенклатура.ЕдиницаХраненияОстатков.Представление  КАК ЕдиницаИзмерения,
	|		Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК Коэффициент,
	|		Лимит
	|	)
	|ИЗ
	|	Документ.ИзменениеЛимитовВозвратнойТары КАК ИзменениеЛимитовВозвратнойТары
	|
	|ГДЕ
	|	ИзменениеЛимитовВозвратнойТары.Ссылка = &ТекущийДокумент
	|УПОРЯДОЧИТЬ ПО
	|	ВозвратнаяТара.НомерСтроки";
	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИзменениеЛимитовВозвратнойТары_ИзменениеЛимитовТары";
	Макет = ПолучитьМакет("ИзменениеЛимитовТары");
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, "Изменение лимитов возвратной тары");
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ОбластьМакета.Параметры.ПредставлениеПоставщика = ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата), "ПолноеНаименование,");
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ОбластьМакета.Параметры.ПредставлениеПолучателя = ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Получатель, Шапка.Дата), "ПолноеНаименование,");
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть(ОбластьШапки);
	ОбластьМакета.Параметры.ТекстЗаголовкаЛимита = ?(ВидОперации = Перечисления.ВидыОперацийИзменениеЛимитовВозвратнойТары.ЛимитПокупателю, "Лимит покупателю", "Лимит поставщика");
	Если ВыводитьКоды Тогда
		ОбластьМакета.Параметры.Колонка = Колонка;
	КонецЕсли;

	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть(ОбластьСтроки);

	ВыборкаСтрокТовары = Шапка.ВозвратнаяТара.Выбрать();
	Пока ВыборкаСтрокТовары.Следующий() Цикл

		Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
			Сообщить("В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.", СтатусСообщения.Важное);
			Продолжить;
		КонецЕсли;

		ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);

		Если ВыводитьКоды Тогда
			ОбластьМакета.Параметры.КодАртикул = ВыборкаСтрокТовары.КодАртикул;
		КонецЕсли;

		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;

	ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ТабДокумент.Вывести(ОбластьМакета);

	Возврат ТабДокумент;

КонецФункции // ПечатьДокумента()

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ИмяМакета = "ИзменениеЛимитовТары" Тогда
		// Получить экземпляр документа на печать
		ТабДокумент = ПечатьДокумента();
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()));

КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("ИзменениеЛимитовТары","Изменение лимитов тары");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

// Процедура выполняет заполнение возватной тары.
//
Процедура ЗаполнитьВозвратнуюТару() Экспорт

	Запрос = Новый Запрос;

	Если ВидОперации = Перечисления.ВидыОперацийИзменениеЛимитовВозвратнойТары.ЛимитПокупателю Тогда
		ИмяЛимита = "ЛимитПокупателю";
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийИзменениеЛимитовВозвратнойТары.ЛимитПоставщика Тогда
		ИмяЛимита = "ЛимитПоставщика";
	КонецЕсли;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);

	Запрос.Текст =
    "ВЫБРАТЬ
    |	Лимиты.ДоговорКонтрагента,
    |	Лимиты.Номенклатура,
    |	Лимиты."+ИмяЛимита+" КАК Лимит
    |ИЗ
    |	РегистрСведений.ЛимитыВозвратнойТары.СрезПоследних(,
	|                                     ДоговорКонтрагента = &ДоговорКонтрагента
	|                                                     ) КАК Лимиты
	|";

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		СтрокаВозвратнойТары = ВозвратнаяТара.Добавить();

		СтрокаВозвратнойТары.Номенклатура = Выборка.Номенклатура;
		СтрокаВозвратнойТары.Лимит        = Выборка.Лимит;

	КонецЦикла;

КонецПроцедуры // ЗаполнитьТовары()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("ВидОперации, Организация, Контрагент, ДоговорКонтрагента");

	// Вызовем общую процедуру для проверки проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

	//Организация в документе должна совпадать с организацией, указанной в договоре взаиморасчетов.
	УправлениеВзаиморасчетами.ПроверитьСоответствиеОрганизацииДоговоруВзаиморасчетов(Организация, ДоговорКонтрагента, СтруктураШапкиДокумента.ДоговорОрганизация, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - структура, содержащая реквизиты шапки документа и результаты запроса по шапке
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиВозвратнаяТара(ТаблицаПоТаре, СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Номенклатура");

	// Вызовем общую процедуру для проверки проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ВозвратнаяТара", СтруктураОбязательныхПолей, Отказ, Заголовок);

	// Здесь услуг быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетУслуг(ЭтотОбъект, "ВозвратнаяТара", ТаблицаПоТаре, Отказ, Заголовок);

	// Здесь наборов-пакетов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетНаборов(ЭтотОбъект, "ВозвратнаяТара", ТаблицаПоТаре, Отказ, Заголовок);
	
	// Здесь наборов-комплектов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетКомплектов(ЭтотОбъект, "ВозвратнаяТара", ТаблицаПоТаре, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

 // Выполняет движения по регистрам 
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоВозвратнойТаре, Отказ, Заголовок)
	
	НаборДвижений   = Движения.ЛимитыВозвратнойТары;
	ТаблицаДвижений = НаборДвижений.ВыгрузитьКолонки();
	
	Если ВидОперации = Перечисления.ВидыОперацийИзменениеЛимитовВозвратнойТары.ЛимитПокупателю Тогда
		ТаблицаПоВозвратнойТаре.Колонки.Лимит.Имя = "ЛимитПокупателю";
	Иначе
		ТаблицаПоВозвратнойТаре.Колонки.Лимит.Имя = "ЛимитПоставщика";
	КонецЕсли;

	// Заполним таблицу движений.
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоВозвратнойТаре, ТаблицаДвижений);
	ТаблицаДвижений.ЗаполнитьЗначения(ДоговорКонтрагента,   "ДоговорКонтрагента");
	
	НаборДвижений.мПериод          = Дата;
	НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

	Если Не Отказ Тогда
		Движения.ЛимитыВозвратнойТары.ВыполнитьДвижения();
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегистрам

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)

	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначения.СформироватьДеревоПолейЗапросаПоШапке();
	ОбщегоНазначения.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "Организация" , "ДоговорОрганизация");
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, "");

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);

	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("Номенклатура", "Номенклатура");
	СтруктураПолей.Вставить("Услуга"      , "Номенклатура.Услуга");
	СтруктураПолей.Вставить("Лимит"       , "Лимит");
	СтруктураПолей.Вставить("Набор"       , "Номенклатура.Набор");
	СтруктураПолей.Вставить("Комплект"    , "Номенклатура.Комплект");

	РезультатЗапросаПоВозвратнойТаре = ОбщегоНазначения.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ВозвратнаяТара", СтруктураПолей);
	ТаблицаПоТаре                    = РезультатЗапросаПоВозвратнойТаре.Выгрузить();

	ПроверитьЗаполнениеТабличнойЧастиВозвратнаяТара(ТаблицаПоТаре, СтруктураШапкиДокумента, Отказ, Заголовок);

	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоТаре, Отказ, Заголовок);
	КонецЕсли;


КонецПроцедуры	// ОбработкаПроведения


// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	мУдалятьДвижения = НЕ ЭтоНовый();

КонецПроцедуры // ПередЗаписью()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);

КонецПроцедуры

