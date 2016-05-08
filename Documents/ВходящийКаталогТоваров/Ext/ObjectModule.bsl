﻿
Функция ПроверитьУникальностьШтрихКода(ШтрихКод) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	*
	               |ИЗ
	               |	РегистрСведений.Штрихкоды КАК Штрихкоды
				   |ГДЕ
				   |Штрихкоды.Штрихкод = &ШтрихКод ";
				   
	Запрос.УстановитьПараметр("ШтрихКод", ШтрихКод);
	ТаблицаДанных = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ЗагрузитьЭлементХМЛ(ОбъектXML, ИмяУзла, Параметры) Экспорт
	
	Перем СтрокаТовара;
	
	Параметры.Свойство("СтрокаТовара", СтрокаТовара);
	
	Если ИмяУзла = "КаталогТоваров" Тогда
		
	ИначеЕсли ИмяУзла = "НомерИсходногоДокумента" Тогда
		ИсходныйДокумент = ЭлектронныеДокументы.ПолучитьСсылкуНаДокументПоДаннымИзXML(ОбъектXML, Документы.ИсходящийЗапросКаталога.ПустаяСсылка(), Параметры);
	ИначеЕсли ИмяУзла = "ДлительностьОжиданияОтвета" Тогда
		ДлительностьОжиданияОтвета = ЭлектронныеДокументы.ПолучитьДлительностьЭлемента(ОбъектXML);
	ИначеЕсли ИмяУзла = "ЭтоПолныйКаталог" Тогда
		ЭтоПолныйКаталог = ЭлектронныеДокументы.ПолучитьБулевоЭлемента(ОбъектXML);
	ИначеЕсли ИмяУзла = "Товар" Тогда
			
		СтрокаТовара = Товары.Добавить();
		Параметры.Вставить("СтрокаТовара",СтрокаТовара);
			
	ИначеЕсли ИмяУзла = "ИдТовараПоставщика" Тогда
		
		СтрокаТовара.ИдТовараПоставщика = ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML);
		
	ИначеЕсли ИмяУзла = "ИдТовараКлиента" Тогда
		
		ЭлектронныеДокументы.ЗаполнитьНоменклатуруИХарактеристикуПоИдентификатору(СтрокаТовара, ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML), Параметры);
		
	ИначеЕсли ИмяУзла = "Наименование" Тогда
			
		СтрокаТовара.НаименованиеНоменклатурыКонтрагента = ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML);
			
	ИначеЕсли ИмяУзла = "ОКЕИ" Тогда
			
		СтрокаТовара.ОКЕИ = Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду(ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML));
		Если ЗначениеЗаполнено(СтрокаТовара.Номенклатура) Тогда
			СтрокаТовара.ЕдиницаИзмерения = ЭлектронныеДокументы.ПолучитьЕдиницуИзмеренияНоменклатурыПоКлассификатору(СтрокаТовара.Номенклатура, СтрокаТовара.ОКЕИ);
		КонецЕсли;
		
	ИначеЕсли ИмяУзла = "ШтриховойКод" Тогда
		
		СтрокаШтрихКода = ШтрихКодыНоменклатуры.Добавить();
		СтрокаШтрихКода.СтрокаТаблицыТовары  = СтрокаТовара.НомерСтроки;
		СтрокаШтрихКода.ШтрихКодКонтрагента = ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML);
		
		Если НЕ ЗначениеЗаполнено(СтрокаТовара.Номенклатура) Тогда
			
			ТаблицаШтрихКодов = ПроверитьУникальностьШтрихКода(Сред(СтрокаШтрихКода.ШтрихКодКонтрагента, 2));
			Если ТаблицаШтрихКодов.Количество() <> 0 Тогда
				
				СтрокаТовара.Номенклатура = ТаблицаШтрихКодов[0].Владелец;	
				СтрокаТовара.ХарактеристикаНоменклатуры = ТаблицаШтрихКодов[0].ХарактеристикаНоменклатуры;
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли   ИмяУзла = "ОКП"
			или ИмяУзла = "ИСО3166"
			или ИмяУзла = "ОКВЭД"
			или ИмяУзла = "КлассификаторТовара"
			или ИмяУзла = "ТорговаяМарка"
			или ИмяУзла = "Производитель"
			или ИмяУзла = "ВесНетто"
			или ИмяУзла = "ВесБрутто"
			или ИмяУзла = "ВысотаСлояТовара"
			или ИмяУзла = "ВысотаТовара"
			или ИмяУзла = "ШиринаТовара"
			или ИмяУзла = "ГлубинаТовара"
			или ИмяУзла = "ОбъемТовара"
			или ИмяУзла = "МинКоличествоДляЗаказа"
			или ИмяУзла = "КоличествоВСлоеНаЕвропалете"
			или ИмяУзла = "ТемператураХранения"
			или ИмяУзла = "Кратность"
			или ИмяУзла = "КоличествоЕдиницОбъектаВерхнегоУровня"
			или ИмяУзла = "Примечание" Тогда
			
		Свойство = СвойстваНоменклатуры.Добавить();
		Свойство.СтрокаТаблицыТовары  = СтрокаТовара.НомерСтроки;
		Свойство.НаименованиеСвойства = ИмяУзла;
		Свойство.ЗначениеСвойства     = ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML);
		
	ИначеЕсли ИмяУзла = "СрокХранения" Тогда
		
		Свойство = СвойстваНоменклатуры.Добавить();
		Свойство.СтрокаТаблицыТовары  = СтрокаТовара.НомерСтроки;
		Свойство.НаименованиеСвойства = ИмяУзла;
		Свойство.ЗначениеСвойства     = Формат(ЭлектронныеДокументы.ПолучитьДлительностьЭлемента(ОбъектXML), "ЧГ=");
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция СуществуетИсходящийДокумент(СсылкаНаОтветныйДокумент = Неопределено) Экспорт
	
	СсылкаНаОтветныйДокумент = ЭлектронныеДокументы.НайтиПервыйОтветныйДокумент(Ссылка, "ИсходящийТоварКРаботе");
	
	Возврат ЗначениеЗаполнено(СсылкаНаОтветныйДокумент);
	
КонецФункции // () 

Процедура ПринятьКРаботе(Отказ, Сообщение, ДокументТоварКРаботе = Неопределено) Экспорт
	
	СсылкаНаИсходныйДокумент = Неопределено;
	Если СуществуетИсходящийДокумент(СсылкаНаИсходныйДокумент) Тогда
		
		Сообщение = Сообщение + Символы.ПС + "- На основании данного документа создан исходящий документ: """ + СсылкаНаИсходныйДокумент + "
		|Необходимо удалить исходящий документ и повторить операцию.";
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	СтрокиТовара = Товары.НайтиСтроки(Новый Структура("Пометка", Истина));
	
	Для каждого СтрокаДанных Из СтрокиТовара Цикл
		
		Если Не СтрокаДанных.ЕдиницаИзмерения.ЕдиницаПоКлассификатору = СтрокаДанных.ОКЕИ Тогда
			Сообщение = Сообщение + Символы.ПС + "- Строка: " + СтрокаДанных.НомерСтроки + ". Единица измерения """ + СтрокаДанных.ЕдиницаИзмерения + """ не соответствует классификатору контрагента """ + СтрокаДанных.ОКЕИ + """!";
			Отказ = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Для каждого СтрокаДанных Из СтрокиТовара Цикл
			
		Если Не ЗначениеЗаполнено(СтрокаДанных.ХарактеристикаНоменклатуры) Тогда
			ЭлектронныеДокументы.СоздатьИдентификаторыЭлОбмена(СтрокаДанных.Номенклатура);
		Иначе
			ЭлектронныеДокументы.СоздатьИдентификаторыЭлОбмена(СтрокаДанных.ХарактеристикаНоменклатуры);
		КонецЕсли;
			
		МенеджерЗаписи = РегистрыСведений.НоменклатураКонтрагентов.СоздатьМенеджерЗаписи();
			
		МенеджерЗаписи.Контрагент                          = Контрагент;
		МенеджерЗаписи.Номенклатура                        = СтрокаДанных.Номенклатура;
		МенеджерЗаписи.ХарактеристикаНоменклатуры          = СтрокаДанных.ХарактеристикаНоменклатуры;
		МенеджерЗаписи.КодНоменклатурыКонтрагента          = СтрокаДанных.ИдТовараПоставщика;
		МенеджерЗаписи.НаименованиеНоменклатурыКонтрагента = СтрокаДанных.НаименованиеНоменклатурыКонтрагента;
			
		МенеджерЗаписи.ЕдиницаНоменклатурыКонтрагента      = СтрокаДанных.ОКЕИ;
			
		ШтрихКодыНоменклатурыКонтрагента = ШтрихКодыНоменклатуры.НайтиСтроки(Новый Структура("СтрокаТаблицыТовары", СтрокаДанных.НомерСтроки));
		Для каждого СтрокаШтрихКода Из ШтрихКодыНоменклатурыКонтрагента Цикл
			МенеджерЗаписи.ШтрихКодНоменклатурыКонтрагента  = Сред(СтрокаШтрихКода.ШтрихКодКонтрагента, 2);
			Прервать;
		КонецЦикла;
			
		Попытка
			МенеджерЗаписи.Записать();
		Исключение
			Сообщение = Сообщение + Символы.ПС + "- " + ОписаниеОшибки();
			Отказ = Истина;
			ОтменитьТранзакцию();
			Возврат;
		КонецПопытки; 
		
	КонецЦикла;
	
	Обработан = Истина;
	
	Попытка
		Записать();
	Исключение
		Сообщение = Сообщение + Символы.ПС + "- " + ОписаниеОшибки();
		Отказ = Истина;
		ОтменитьТранзакцию();
		Возврат;
	КонецПопытки;
	
	ДокументТоварКРаботе = Документы.ИсходящийТоварКРаботе.СоздатьДокумент();
	ДокументТоварКРаботе.Заполнить(ссылка);

	Попытка
		ДокументТоварКРаботе.Записать();
	Исключение
		Сообщение = Сообщение + Символы.ПС + "- " + ОписаниеОшибки();
		Отказ = Истина;
		ОтменитьТранзакцию();
		Возврат;
	КонецПопытки;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры // () 
