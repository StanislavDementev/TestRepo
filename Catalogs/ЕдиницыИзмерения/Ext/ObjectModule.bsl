﻿
// Обработчик события ПередЗаписью .
//
Процедура ПередЗаписью(Отказ)

	Если НЕ ОбменДанными.Загрузка
	   И ТипЗнч(Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		Если Владелец.ЕдиницаХраненияОстатков = Ссылка Тогда

			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ТекущийЭлемент", ЭтотОбъект.Ссылка);

			Запрос.Текст =
			"ВЫБРАТЬ
			|	ЕдиницыИзмерения.Ссылка КАК Элемент,
			|	ЕдиницыИзмерения.Коэффициент КАК Коэффициент
			|ИЗ
			|	Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения
			|
			|ГДЕ
			|	ЕдиницыИзмерения.Ссылка = &ТекущийЭлемент";

			Выборка = Запрос.Выполнить().Выбрать();

			Если Выборка.Следующий() Тогда
				Если Выборка.Коэффициент <> Коэффициент Тогда
					Если ПолныеПрава.Номенклатура_СуществуютСсылки(Владелец, Неопределено) Тогда
						ОбщегоНазначения.СообщитьОбОшибке("Единица """ + СокрЛП(Наименование) + """ является единицей хранения остатков для """ + 
						                 СокрЛП(Владелец) + """ и уже участвует в товародвижении. Изменить коэффициент уже нельзя!", Отказ);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;

		КонецЕсли;
	КонецЕсли;

	Если Не ОбменДанными.Загрузка
	   И Не Отказ
	   И Коэффициент = 0 Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Для "+СокрЛП(Владелец)+" у единицы измерения "+СокрЛП(Ссылка)+" не задан коэффициент! Он будет установлен равным 1.");
		Коэффициент = 1;
	КонецЕсли;

КонецПроцедуры // ПередЗаписью()
