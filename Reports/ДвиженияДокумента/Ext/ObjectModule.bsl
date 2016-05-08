﻿
Перем ТонкаяСплошнаяЛиния;
Перем ТолстаяСплошнаяЛиния;

// функция определяет вид регистра по метаданным
Функция ОпределитьВидРегистра(МетаданныеРегистра)
	
	Если Метаданные.РегистрыНакопления.Индекс(МетаданныеРегистра) >= 0 Тогда
		Возврат "Накопления";
		
	ИначеЕсли Метаданные.РегистрыСведений.Индекс(МетаданныеРегистра) >= 0 Тогда
		Возврат "Сведений";	
		
	ИначеЕсли Метаданные.РегистрыБухгалтерии.Индекс(МетаданныеРегистра) >= 0 Тогда
		Возврат "Бухгалтерии";
		
	ИначеЕсли Метаданные.РегистрыРасчета.Индекс(МетаданныеРегистра)>=0 Тогда
		Возврат "Расчета";
		
	Иначе
		Возврат "";
			
	КонецЕсли;
    	
КонецФункции

#Если Клиент Тогда
	
// функция определяет можно ли получить отчет по документу или нет
Функция ОпределитьВозможностьПолученияОтчета()
	
	Если Документ.Пустая() Тогда
		Предупреждение("Запишите и проведите документ, по которому Вы формируете отчет");
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции
	
Процедура СформироватьОтчет(ДокументРезультат) Экспорт

	ВозможностьПостроения = ОпределитьВозможностьПолученияОтчета();
	Если Не ВозможностьПостроения Тогда
		Возврат;
	КонецЕсли;

	ДокументРезультат.Очистить();
	Макет = ПолучитьМакет("Макет");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("ГлавныйЗаголовок");
	ОбластьЗаголовок.Параметры.Документ = Строка(Документ);
	ДокументРезультат.Вывести(ОбластьЗаголовок);

	ДвиженияДокумента = Документ.Метаданные().Движения;
	КоличествоРегистров = ДвиженияДокумента.Количество();
	
	Если КоличествоРегистров = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НомерРегистра = -1;
	
	// определяем таблицу регистров по которым есть движения
	ТаблицаДвижений = ПолныеПрава.ОпределитьНаличиеДвиженийПоРегистратору(Документ);
	
	Для Каждого СтрокаТаблицыДвижений Из ТаблицаДвижений Цикл
		
		СтрокаТаблицыДвижений.Имя = Врег(СокрЛП(СтрокаТаблицыДвижений.Имя));
		
	КонецЦикла;
	
	Для Каждого СвойстваОбъекта Из ДвиженияДокумента Цикл
		
		// найден ли регистр в таблице или нет
		СтрокаВТаблицеРегистров = ТаблицаДвижений.Найти(Врег(СвойстваОбъекта.ПолноеИмя()), "Имя");
		
		Если СтрокаВТаблицеРегистров = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ПравоДоступа("Чтение", СвойстваОбъекта) Тогда
			Продолжить;
		КонецЕсли;
		
		НомерРегистра = НомерРегистра + 1;
		
		Построитель = Новый ПостроительОтчета;
		СтруктураПредставлениеПолей = Новый Структура;
		МассивПолей = Новый Массив();
		Состояние("Обрабатывается регистр (" + Цел(НомерРегистра/КоличествоРегистров * 100) + "%): " + СвойстваОбъекта.Синоним);
		
		ВидРегистра = ОпределитьВидРегистра(СвойстваОбъекта);
		
		ВыводитьРасходПриход = Ложь;
		Если (ВидРегистра = "Сведений") 
			ИЛИ (ВидРегистра = "Накопления") Тогда
							
			// некоторые регистры не анализируем а просто пропускаем
			Если ВидРегистра+"."+СвойстваОбъекта.Имя = "Сведений.СписанныеТовары"
			 ИЛИ ВидРегистра+"."+СвойстваОбъекта.Имя = "Сведений.СписанныеМатериалыИзЭксплуатации"
			 ИЛИ ВидРегистра+"."+СвойстваОбъекта.Имя = "Сведений.РаспределениеЗатратПоПеределам"
			 ИЛИ ВидРегистра+"."+СвойстваОбъекта.Имя = "Сведений.РаспределениеЗатратПоПеределамОрганизаций"
			 ИЛИ ВидРегистра+"."+СвойстваОбъекта.Имя = "Сведений.РаспределениеПродукцииПоПеределам"
			 ИЛИ ВидРегистра+"."+СвойстваОбъекта.Имя = "Сведений.РаспределениеПродукцииПоПеределамОрганизаций"
			 ИЛИ ВидРегистра+"."+СвойстваОбъекта.Имя = "Сведений.РасчетБазыРаспределенияКосвенныхЗатрат"
			 ИЛИ ВидРегистра+"."+СвойстваОбъекта.Имя = "Сведений.РасчетКосвенныхЗатрат"
			 ИЛИ ВидРегистра+"."+СвойстваОбъекта.Имя = "Сведений.РасчетКоэффициентовРаспределенияНалоговыйУчет"
			 ИЛИ ВидРегистра+"."+СвойстваОбъекта.Имя = "Сведений.РасчетПрямыхЗатрат"
			 Тогда
				Продолжить;
			КонецЕсли;
			
			//вид движения для регистра накопления
			СтрокаПриходРасход = "";
			Если (ВидРегистра = "Накопления")
				И (СвойстваОбъекта.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки) Тогда
				
				СтрокаПриходРасход = ", ВидДвижения";
				СтруктураПредставлениеПолей.Вставить("ВидДвижения", "Вид движения");
				ВыводитьРасходПриход = Истина;
			КонецЕсли;
			
			ТекстРесурсы = СформироватьСписокПолей(СвойстваОбъекта.Ресурсы, СтруктураПредставлениеПолей);
			ТекстИзмерения = СформироватьСписокПолей(СвойстваОбъекта.Измерения, СтруктураПредставлениеПолей);
			ТекстРеквизиты = СформироватьСписокПолей(СвойстваОбъекта.Реквизиты, СтруктураПредставлениеПолей);
									
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, Ширина", СтрокаПриходРасход, 10));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, ИмяКолонки, Ширина", ТекстИзмерения, "Измерения", 40));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, ИмяКолонки, Ширина", ТекстРесурсы, "Ресурсы", 30));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, ИмяКолонки, Ширина", ТекстРеквизиты, "Реквизиты", 20));
			
			ОбработатьВыводДанныхПоМассиву(МассивПолей, СтруктураПредставлениеПолей, Построитель, 
				"Регистр" + ВидРегистра + "." + СвойстваОбъекта.Имя, ВыводитьВВидеТаблицы);
	
		ИначеЕсли ВидРегистра = "Бухгалтерии" Тогда
			
			КорреспонденцияОбъекта = СвойстваОбъекта.Корреспонденция;
			
			ТекстРесурсы = "";
			ТекстИзмерения = "";
			
			ТекстРесурсыДт = "";
			ТекстРесурсыКт = "";
			
			Для Каждого Ресурс из СвойстваОбъекта.Ресурсы Цикл
				
				Если Ресурс.Балансовый Или Не КорреспонденцияОбъекта Тогда
					ТекстРесурсы = ТекстРесурсы + ", "+ Ресурс.Имя;
					СтруктураПредставлениеПолей.Вставить(Ресурс.Имя, Ресурс.Синоним);
				Иначе
					ТекстРесурсыДт = ТекстРесурсыДт + ", "+ Ресурс.Имя +"Дт";
					СтруктураПредставлениеПолей.Вставить(Ресурс.Имя + "Дт", Ресурс.Синоним + " Дт");
					
					ТекстРесурсыКт = ТекстРесурсыКт + ", "+ Ресурс.Имя +"Кт";
					СтруктураПредставлениеПолей.Вставить(Ресурс.Имя + "Кт", Ресурс.Синоним + " Кт");
				КонецЕсли;
				
			КонецЦикла;

			ТекстСубконто = "";
			ТекстВидСубконто = "";
			ТекстСубконтоДт = "";
			ТекстВидСубконтоДт = "";
			ТекстСубконтоКт = "";
			ТекстВидСубконтоКт = "";
			
			Для Инд = 1 по Свойстваобъекта.ПланСчетов.МаксКоличествоСубконто Цикл
				
				Если КорреспонденцияОбъекта Тогда
					ТекстСубконтоДт = ТекстСубконтоДт + ", СубконтоДт" + Инд;
					СтруктураПредставлениеПолей.Вставить("СубконтоДт" + Инд, "Субконто Дт " + Инд);
					
					ТекстСубконтоКт = ТекстСубконтоКт + ", СубконтоКт" + Инд;
					СтруктураПредставлениеПолей.Вставить("СубконтоКт" + Инд, "Субконто Кт " + Инд);
				Иначе
					ТекстСубконто = ТекстСубконто + ", Субконто" + Инд;
					СтруктураПредставлениеПолей.Вставить("Субконто" + Инд, "Субконто " + Инд);
				КонецЕсли;
				
			КонецЦикла;

			Если КорреспонденцияОбъекта Тогда
				ТекстИзмеренияДт = ", СчетДт";
				СтруктураПредставлениеПолей.Вставить("СчетДт", "Счет Дт");
				ТекстИзмеренияКт = ", СчетКт";
				СтруктураПредставлениеПолей.Вставить("СчетКт", "Счет Кт");
			Иначе
				ТекстИзмеренияДт = "";
				ТекстИзмеренияКт = "";
				ТекстИзмерения = ", Счет";
				СтруктураПредставлениеПолей.Вставить("Счет", "Счет");
			КонецЕсли;
			
			Для Каждого Измерение из СвойстваОбъекта.Измерения Цикл
				
				Если Измерение.Балансовый Или Не КорреспонденцияОбъекта Тогда
					ТекстИзмерения = ТекстИзмерения + ", " + Измерение.Имя;
					СтруктураПредставлениеПолей.Вставить(Измерение.Имя, Измерение.Синоним);
				Иначе
					ТекстИзмеренияДт = ТекстИзмеренияДт + ", " + Измерение.Имя + "Дт";
					СтруктураПредставлениеПолей.Вставить(Измерение.Имя + "Дт", Измерение.Синоним + " Дт");
					
					ТекстИзмеренияКт = ТекстИзмеренияКт + ", " + Измерение.Имя + "Кт";
					СтруктураПредставлениеПолей.Вставить(Измерение.Имя + "Кт", Измерение.Синоним + " Кт");
				КонецЕсли;
				
			КонецЦикла;
			
			ТекстРеквизиты = СформироватьСписокПолей(СвойстваОбъекта.Реквизиты, СтруктураПредставлениеПолей);
			
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, Ширина", ТекстИзмерения, 24));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, Ширина", ТекстВидСубконто, 16));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, Ширина", ТекстСубконто, 19));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, Ширина", ТекстИзмеренияДт, 9));
				
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, Ширина", ТекстВидСубконтоДт, 16));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, Ширина", ТекстСубконтоДт, 19));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, Ширина", ТекстРесурсыДт, 15));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, Ширина", ТекстИзмеренияКт, 9));
				
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, Ширина", ТекстВидСубконтоКт, 16));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, Ширина", ТекстСубконтоКт, 19));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, Ширина", ТекстРесурсыКт, 15));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, Ширина", ТекстРесурсы, 15));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, Ширина", ТекстРеквизиты, 15));
			
			СписокПолейВыбора = СформироватьСписокПолейЗапросаПоМассивуДанных(МассивПолей);
					
			Построитель.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ " + СписокПолейВыбора + "
			|{ВЫБРАТЬ " + СписокПолейВыбора + "}
			|ИЗ РегистрБухгалтерии."+СвойстваОбъекта.Имя +".ДвиженияССубконто(,,Регистратор = &ДокументОтчета)
			|ГДЕ (РегистрБухгалтерии."+СвойстваОбъекта.Имя +".ДвиженияССубконто.Регистратор = &ДокументОтчета)";
			
			Построитель.Параметры.Вставить("ДокументОтчета", Документ);
			
			
			
			
			Если ВыводитьВВидеТаблицы Тогда
				
					ОбработатьВыводДанныхПоМассиву(МассивПолей, СтруктураПредставлениеПолей, Построитель, 
						"Регистр" + ВидРегистра + "." + СвойстваОбъекта.Имя, ВыводитьВВидеТаблицы);
			Иначе
				Попытка
					// возможно есть свой макет вывода данных
					МакетНастройки = ПолучитьМакет("МакетНастройкиРегистраРегистрБухгалтерии" + СвойстваОбъекта.Имя);
					Построитель.МакетШапкиТаблицы = МакетНастройки.ПолучитьОбласть("ШапкаТаблицы");
					Построитель.МакетДетальныхЗаписей = МакетНастройки.ПолучитьОбласть("Строка");
				Исключение
					
					ОбработатьВыводДанныхПоМассиву(МассивПолей, СтруктураПредставлениеПолей, Построитель, 
						"Регистр" + ВидРегистра + "." + СвойстваОбъекта.Имя, ВыводитьВВидеТаблицы);
					
				КонецПопытки;
			КонецЕсли;
			
		ИначеЕсли ВидРегистра = "Расчета" Тогда
			
			СпецифическиеДанныеРегистраРасчета = ", ВидРасчета, ПериодРегистрации, Сторно";
			СтруктураПредставлениеПолей.Вставить("ВидРасчета", "Вид расчета");
			СтруктураПредставлениеПолей.Вставить("ПериодРегистрации", "Период регистрации");
			
			Если СвойстваОбъекта.БазовыйПериод Тогда
				СпецифическиеДанныеРегистраРасчета = СпецифическиеДанныеРегистраРасчета + ", БазовыйПериодНачало, БазовыйПериодКонец";
				СтруктураПредставлениеПолей.Вставить("БазовыйПериодНачало", "Начало базового периода");
				СтруктураПредставлениеПолей.Вставить("БазовыйПериодКонец", "Конец базового периода");
			КонецЕсли;
			
			Если СвойстваОбъекта.ПериодДействия Тогда
				СпецифическиеДанныеРегистраРасчета = СпецифическиеДанныеРегистраРасчета + ", ПериодДействияНачало, ПериодДействияКонец";
				СтруктураПредставлениеПолей.Вставить("ПериодДействияНачало", "Начало периода действия");
				СтруктураПредставлениеПолей.Вставить("ПериодДействияКонец", "Конец периода действия");
			КонецЕсли;
			
			ТекстРесурсы = СформироватьСписокПолей(СвойстваОбъекта.Ресурсы, СтруктураПредставлениеПолей);
			ТекстИзмерения = СформироватьСписокПолей(СвойстваОбъекта.Измерения, СтруктураПредставлениеПолей);
			ТекстРеквизиты = СформироватьСписокПолей(СвойстваОбъекта.Реквизиты, СтруктураПредставлениеПолей);
			
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, ИмяКолонки, Ширина", СпецифическиеДанныеРегистраРасчета, "Данные расчета", 30));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, ИмяКолонки, Ширина", ТекстИзмерения, "Измерения", 40));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, ИмяКолонки, Ширина", ТекстРесурсы, "Ресурсы", 30));
			ДобавитьструктуруДанныхВМассивПолей(МассивПолей, Новый Структура("СписокПолей, ИмяКолонки, Ширина", ТекстРеквизиты, "Реквизиты", 20));
				
			ОбработатьВыводДанныхПоМассиву(МассивПолей, СтруктураПредставлениеПолей, Построитель, 
				"Регистр" + ВидРегистра + "." + СвойстваОбъекта.Имя, ВыводитьВВидеТаблицы);
			
		Иначе
			// неизвестный вид регистра
			Продолжить;
		КонецЕсли;
		
		Если Построитель.ПолучитьЗапрос().Выполнить().Пустой() Тогда
			// а данных то и нет
			Продолжить;
		КонецЕсли;
		
		Построитель.ВыводитьПодвалОтчета = Истина;
		Построитель.ВыводитьОбщиеИтоги = Ложь;
		Построитель.ВыводитьПодвалТаблицы = Ложь;
		Построитель.ВыводитьЗаголовокОтчета = Ложь;

		Макет = ПолучитьМакет("Макет");
		ОбластьЗаголовок = Макет.ПолучитьОбласть("ЗаголовокОтчета");
				
		ОбластьЗаголовок.Параметры.ИмяРегистра = СвойстваОбъекта.Синоним;
		ОбластьЗаголовок.Параметры.ВидРегистра = НРег(ВидРегистра);
		ДокументРезультат.Вывести(ОбластьЗаголовок);
		
		ДокументРезультат.НачатьГруппуСтрок();
		
		Если ВыводитьРасходПриход Тогда
			НомерВыводимойСтроки = ДокументРезультат.ВысотаТаблицы;	
		КонецЕсли;
		
		// вывод данных в табличный документ
		Построитель.Вывести(ДокументРезультат);
		
		// раскрашиваем приход расход в разные цвета
		Если ВыводитьРасходПриход Тогда
			НомерТекущейСтроки = ДокументРезультат.ВысотаТаблицы;
			
			Для Номерстроки = НомерВыводимойСтроки + 2 По НомерТекущейСтроки - 1 Цикл
				
				// вид движения находится во второй колонке всегда
				ОбластьВывода = ДокументРезультат.Область(Номерстроки, 2);
				ТекстСтрокиЯчейки = ОбластьВывода.Текст;
				
				Если ТекстСтрокиЯчейки = "Расход" Тогда
					ОбластьВывода.ЦветТекста = ЦветаСтиля.ЦветОтрицательногоЧисла;	
				ИначеЕсли ТекстСтрокиЯчейки = "Приход" Тогда
					ОбластьВывода.ЦветТекста = WebЦвета.Зеленый;
				КонецЕсли;
				
			КонецЦикла;
				
		КонецЕсли;
		
		ДокументРезультат.ЗакончитьГруппуСтрок();
		
	КонецЦикла;
	
	ДокументРезультат.ОтображатьГруппировки = Истина;
	ДокументРезультат.ОтображатьЗаголовки = Ложь;
	ДокументРезультат.ОтображатьСетку = Ложь;
	ДокументРезультат.ТолькоПросмотр = Истина;
	ДокументРезультат.Автомасштаб = Истина;
	Состояние("");

КонецПроцедуры

// процедура добавляет структуру данных в массив полей
Процедура ДобавитьструктуруДанныхВМассивПолей(МассивПолей, СтруктураДанных)
	
	// пустой список полей нас не интересует
	Если Не ПустаяСтрока(СтруктураДанных.СписокПолей) Тогда
		МассивПолей.Добавить(СтруктураДанных);		
	КонецЕсли;
	
КонецПроцедуры

// функция формирует строку списка полей через запятую по ресурсу метаданных
Функция СформироватьСписокПолей(МетаданныеРесурса, СтруктураПредставлениеПолей)
	
	СписокПолей = "";
	
	Для Каждого Ресурс Из МетаданныеРесурса Цикл
		СписокПолей = СписокПолей + ", "+ Ресурс.Имя;
		СтруктураПредставлениеПолей.Вставить(Ресурс.Имя, Ресурс.Синоним);
	КонецЦикла;
	
	Возврат СписокПолей;
	
КонецФункции

// функция формирует список полей запроса по массиву данных
Функция СформироватьСписокПолейЗапросаПоМассивуДанных(МассивПолей)
	
	СтрокаСпискаПолей = "";
	Для Каждого ЭлементМассива Из МассивПолей Цикл
		СтрокаСпискаПолей = СтрокаСпискаПолей + ЭлементМассива.СписокПолей; 
	КонецЦикла;
	
	Если Не ПустаяСтрока(СтрокаСпискаПолей) Тогда
		СтрокаСпискаПолей = Сред(СтрокаСпискаПолей, 2);
	КонецЕсли;
	
	Возврат СтрокаСпискаПолей;
	
КонецФункции

// процедура выводит данные по массиву структур
Процедура ОбработатьВыводДанныхПоМассиву(МассивПолей, СтруктураПредставлениеПолей,
			Построитель, Знач ИмяРегистра, Знач ВыводитьВВидеТаблицы = Ложь)
			
	Если МассивПолей.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
			
	// посмотрим установлен ли текс запроса построителю, если нет, то сами сформируем его текст
	Если ПустаяСтрока(Построитель.Текст) Тогда
		
		СтрокаСпискаПолей = СформироватьСписокПолейЗапросаПоМассивуДанных(МассивПолей);
		
		Построитель.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ " + СтрокаСпискаПолей +"
			|{ВЫБРАТЬ " + СтрокаСпискаПолей +"}
			|ИЗ " + ИмяРегистра + " КАК Рег
			|ГДЕ Рег.Регистратор = &ДокументОтчета";
			
		Построитель.Параметры.Вставить("ДокументОтчета", Документ);	
        	
	КонецЕсли;
			
	УправлениеОтчетами.ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, Построитель);
	МакетДетальныхЗаписей = Построитель.Макет.ПолучитьОбласть("Детали");
	МакетШапки = Построитель.Макет.ПолучитьОбласть("ШапкаТаблицы");		
			
	ВысотаМакета = 0;	
	КоличествоСтрокДобавленияЗаголовка = 0;
	Для Каждого ЭлементМассива Из МассивПолей Цикл
		
		ЭлементМассива.Вставить("НомерКолонки", 0);
		
		Если Не ПустаяСтрока(ЭлементМассива.СписокПолей) Тогда
			
			ЭлементМассива.Вставить("КоличествоСтрок", 1);
			
			СтрокаИмениКолонки = "";
			Если НЕ ЭлементМассива.Свойство("ИмяКолонки", СтрокаИмениКолонки) Тогда
				СтрокаИмениКолонки = "";
			Иначе
				КоличествоСтрокДобавленияЗаголовка = 1;
			КонецЕсли;
			
			ПодготовитьПоляДетальнойЗаписи(ЭлементМассива.СписокПолей, МакетДетальныхЗаписей, МакетШапки, ЭлементМассива.НомерКолонки, 
				ЭлементМассива.КоличествоСтрок, СтрокаИмениКолонки, ВыводитьВВидеТаблицы);
						
			ВысотаМакета = Макс(ВысотаМакета, ЭлементМассива.КоличествоСтрок);
		
		КонецЕсли;
	        		
	КонецЦикла;
	
	ПодготовитьМакетыДляВывода(МакетДетальныхЗаписей, МакетШапки, ВысотаМакета, КоличествоСтрокДобавленияЗаголовка);
	
	Если НЕ ВыводитьВВидеТаблицы Тогда
		
		НомерТекущейКолонки = 2;
		Для Каждого ЭлементМассива Из МассивПолей Цикл
			
			Если ЭлементМассива.НомерКолонки > 0 Тогда
				
				// каждую область отдельно обводим
				ОбвестиОбластиВыводаДанных(МакетДетальныхЗаписей, МакетШапки, ВысотаМакета, ЭлементМассива.Ширина, НомерТекущейКолонки);
				НомерТекущейКолонки = НомерТекущейКолонки + 1;
				
			КонецЕсли;	
	    		
		КонецЦикла;
		
	Иначе
		// таблицу выводим
		ОбщееКоличествоПолейВывода = Построитель.ДоступныеПоля.Количество();
		ТекущаяШирина = -1;
		ТекущийНомерВМассиве = -1;
		Для НомерТекущейКолонки = 0 По ОбщееКоличествоПолейВывода - 1 Цикл
			// по номеру определяем ширину поля
			Если ТекущийНомерВМассиве <= МассивПолей.Количество() - 2 Тогда
				
				НомерСледующейКолонки = МассивПолей[ТекущийНомерВМассиве + 1].НомерКолонки - 2;
				Если НомерСледующейКолонки <= НомерТекущейКолонки Тогда
					ТекущийНомерВМассиве = ТекущийНомерВМассиве + 1;
					ТекущаяШирина = МассивПолей[ТекущийНомерВМассиве].Ширина;
					
					СтрокаИмениКолонки = "";
					Если МассивПолей[ТекущийНомерВМассиве].Свойство("ИмяКолонки", СтрокаИмениКолонки) Тогда
						
						//Надо это сделать для всех колонок от текущей до следующей группы
						Если ТекущийНомерВМассиве <= МассивПолей.Количество() - 2 Тогда
							НомерПоследнейКолонки = МассивПолей[ТекущийНомерВМассиве + 1].НомерКолонки - 2;
						Иначе
							НомерПоследнейКолонки = ОбщееКоличествоПолейВывода; 
						КонецЕсли;
						
						Для НомерВременнойКолонки = НомерТекущейКолонки По НомерПоследнейКолонки - 1 Цикл
							ДобавитьКолонкеЗаголовок(МакетШапки, НомерВременнойКолонки + 2, СтрокаИмениКолонки);
						КонецЦикла;
						
						Область = МакетШапки.Область(1, НомерТекущейКолонки + 2, 1, НомерПоследнейКолонки + 1);
						Область.Объединить();
												
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
			ОбвестиОбластиВыводаДанных(МакетДетальныхЗаписей, МакетШапки, ВысотаМакета, ТекущаяШирина, НомерТекущейКолонки + 2);	
		КонецЦикла;
		
	КонецЕсли;
	
	ОбластьДетальныхЗаписей = МакетДетальныхЗаписей.ПолучитьОбласть("Детали");
	ОбластьШапки = МакетШапки.ПолучитьОбласть("ШапкаТаблицы");
	
	Построитель.МакетДетальныхЗаписей = ОбластьДетальныхЗаписей;
	Построитель.МакетШапкиТаблицы = ОбластьШапки;
    	
КонецПроцедуры

Процедура ПодготовитьМакетыДляВывода(МакетДетальныхЗаписей, МакетШапки, ВысотаМакета, Знач НомерДобавления = 0)
	
	МакетДетальныхЗаписей.Область("Детали").Имя = "";
	МакетДетальныхЗаписей.Область(1, , ВысотаМакета,).Имя = "Детали";
	МакетДетальныхЗаписей.Область(1, , ВысотаМакета,).ШиринаКолонки = 20;
	МакетДетальныхЗаписей.Область(1,1, ВысотаМакета,1).ШиринаКолонки = 2;
			
	МакетШапки.Область("ШапкаТаблицы").Имя = "";
	МакетШапки.Область(1, , ВысотаМакета + НомерДобавления,).Имя = "ШапкаТаблицы";
	МакетШапки.Область(1, , ВысотаМакета + НомерДобавления,).ШиринаКолонки = 20;
	МакетШапки.Область(1, 1,ВысотаМакета + НомерДобавления, 1).ШиринаКолонки = 2;
	
КонецПроцедуры

// подготовка для вывода данных в области
Процедура ОбвестиОбластиВыводаДанных(МакетДетальныхЗаписей, МакетШапки, Знач ВысотаМакета, Знач ШиринаКолонки, Знач НомерКолонки)
	
	ОбластьДетальнойЗаписи = МакетДетальныхЗаписей.Область(1, НомерКолонки, ВысотаМакета, НомерКолонки);
	ОбластьШапки = МакетШапки.Область(1, НомерКолонки,ВысотаМакета + 1, НомерКолонки); 
	
	ОбластьДетальнойЗаписи.ШиринаКолонки = ШиринаКолонки;
	ОбластьДетальнойЗаписи.Обвести(ТонкаяСплошнаяЛиния, ТонкаяСплошнаяЛиния, ТонкаяСплошнаяЛиния, ТонкаяСплошнаяЛиния);
	
	ОбластьШапки.ШиринаКолонки = ШиринаКолонки;
	ОбластьШапки.Обвести(ТолстаяСплошнаяЛиния, ТолстаяСплошнаяЛиния, ТолстаяСплошнаяЛиния, ТолстаяСплошнаяЛиния);
		
КонецПроцедуры

// процедура добавляет колонке заголовок
Процедура ДобавитьКолонкеЗаголовок(МакетШапки, Знач НомерСтолбца, Знач СтрокаЗаголовка)
	
	МакетШапки.ВставитьОбласть(МакетШапки.Область(МакетШапки.Область("ШапкаТаблицы").Верх, НомерСтолбца), 
							   МакетШапки.Область(МакетШапки.Область("ШапкаТаблицы").Верх, НомерСтолбца), ТипСмещенияТабличногоДокумента.ПоВертикали, Ложь);
												   
	МакетШапки.ВставитьОбласть(МакетШапки.Область(МакетШапки.Область("ШапкаТаблицы").Верх, НомерСтолбца), 
							   МакетШапки.Область(МакетШапки.Область("ШапкаТаблицы").Верх + 1, НомерСтолбца), ТипСмещенияТабличногоДокумента.БезСмещения, Ложь);
												   
	СтрокаЗаголовкаШапки = МакетШапки.Область(МакетШапки.Область("ШапкаТаблицы").Верх, НомерСтолбца);						   
	СтрокаЗаголовкаШапки.Текст = СтрокаЗаголовка;
	СтрокаЗаголовкаШапки.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
	
КонецПроцедуры


Процедура ПодготовитьПоляДетальнойЗаписи(СтрПолейДетальнойЗаписи, МакетДетальныхЗаписей, МакетШапки, НомерКолонкиКудаВсеСкладываем, 
										НомерСтроки, Знач СтрокаЗаголовка = "", Знач ВыводитьВВидеТаблицы = Ложь)
										
	Если НЕ ВыводитьВВидеТаблицы Тогда									
		НомерКолонкиКудаВсеСкладываем = 0;
				
		НомерСтолбца = 2;
		НомерСтрокиШапки = НомерСтроки;
		
		ИмяПараметра = МакетДетальныхЗаписей.Область(МакетДетальныхзаписей.Область("Детали").Верх, НомерСтолбца).Параметр;
		
		Пока ЗначениеЗаполнено(ИмяПараметра) Цикл
			
			Если Найти(СтрПолейДетальнойЗаписи + ",", " " + ИмяПараметра + ",") > 0 Тогда
				
				Если НомерКолонкиКудаВсеСкладываем = 0 Тогда
					
					НомерКолонкиКудаВсеСкладываем = НомерСтолбца;
					// записываем заголовок группы полей
					Если Не ПустаяСтрока(СтрокаЗаголовка) Тогда
						
						ДобавитьКолонкеЗаголовок(МакетШапки, НомерСтолбца, СтрокаЗаголовка);
						НомерСтрокиШапки = НомерСтрокиШапки + 1; 
						
					КонецЕсли;
				Иначе
					
					МакетДетальныхЗаписей.ВставитьОбласть(МакетДетальныхЗаписей.Область(МакетДетальныхзаписей.Область("Детали").Верх, НомерСтолбца), 
								МакетДетальныхЗаписей.Область(МакетДетальныхзаписей.Область("Детали").Верх + НомерСтроки, НомерКолонкиКудаВсеСкладываем), ТипСмещенияТабличногоДокумента.ПоВертикали, Ложь);
								
					МакетШапки.ВставитьОбласть(МакетШапки.Область(МакетШапки.Область("ШапкаТаблицы").Верх, НомерСтолбца), 
								МакетШапки.Область(МакетШапки.Область("ШапкаТаблицы").Верх + НомерСтрокиШапки, НомерКолонкиКудаВсеСкладываем), ТипСмещенияТабличногоДокумента.ПоВертикали, Ложь);
					
					НомерСтроки = НомерСтроки + 1;
					НомерСтрокиШапки = НомерСтрокиШапки + 1;

					Для Инд = МакетДетальныхЗаписей.Область("Детали").Верх по МакетДетальныхЗаписей.Область("Детали").Низ + 8 Цикл
						// грохаем не нужные области
						МакетДетальныхЗаписей.УдалитьОбласть(МакетДетальныхЗаписей.Область(Инд, НомерСтолбца), ТипСмещенияТабличногоДокумента.ПоГоризонтали);
						МакетШапки.УдалитьОбласть(МакетШапки.Область(Инд, НомерСтолбца), ТипСмещенияТабличногоДокумента.ПоГоризонтали);
					КонецЦикла;
					
					// столбец грохнули, надо в том же столбце данные смотреть...
					НомерСтолбца = НомерСтолбца - 1;
					
				КонецЕсли;
				
			КонецЕсли;
			
			НомерСтолбца = НомерСтолбца + 1;
			ИмяПараметра = МакетДетальныхЗаписей.Область(МакетДетальныхзаписей.Область("Детали").Верх, НомерСтолбца).Параметр;
			
		КонецЦикла;
		
	Иначе
		// вывод в виде таблицы
		НомерСтолбца = 2;
			
		ИмяПараметра = МакетДетальныхЗаписей.Область(МакетДетальныхзаписей.Область("Детали").Верх, НомерСтолбца).Параметр;
		
		Пока ЗначениеЗаполнено(ИмяПараметра) Цикл
			
			Если Найти(СтрПолейДетальнойЗаписи + ",", " " + ИмяПараметра + ",") > 0 Тогда
				
				Если НомерКолонкиКудаВсеСкладываем = 0 Тогда
					НомерКолонкиКудаВсеСкладываем = НомерСтолбца;
				КонецЕсли;
								
			КонецЕсли;
			
			НомерСтолбца = НомерСтолбца + 1;
			ИмяПараметра = МакетДетальныхЗаписей.Область(МакетДетальныхзаписей.Область("Детали").Верх, НомерСтолбца).Параметр;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры


ТонкаяСплошнаяЛиния = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
ТолстаяСплошнаяЛиния = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2);

#КонецЕсли