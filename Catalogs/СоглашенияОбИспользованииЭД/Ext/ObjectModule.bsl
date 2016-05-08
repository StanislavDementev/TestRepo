﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ПометкаУдаления Тогда
		ПроверяемыеРеквизиты.Очистить();
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоИнтеркампани
		И (СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезОператораЭДОТакском
			ИЛИ СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезСервис1СЭДО
			ИЛИ СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезЭлектроннуюПочту
			ИЛИ СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезКаталог
			ИЛИ СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезFTP) Тогда
		
		Если Не ЗначениеЗаполнено(Контрагент) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Поле", "Заполнение", "Контрагент"),
				ЭтотОбъект,
				"Контрагент",
				,
				Отказ);
		КонецЕсли;
		
		ПроверитьНастройкиПрямогоОбмена = Ложь;
		
		Если РасширенныйРежимНастройкиСоглашения Тогда
			
			МассивСтрокЭлектронныхДокументов = ИсходящиеДокументы.НайтиСтроки(Новый Структура("Формировать", Истина));
			Для каждого СтрокаТаблицы Из МассивСтрокЭлектронныхДокументов Цикл
				
				Префикс = "ИсходящиеДокументы[" + Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
				
				Если Не ЗначениеЗаполнено(СтрокаТаблицы.ПрофильНастроекЭДО) Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Колонка", "ЗАПОЛНЕНИЕ", "Профиль настроек ЭДО",
						СтрокаТаблицы.НомерСтроки, "Электронные документы"),
						ЭтотОбъект,
						Префикс + "ПрофильНастроекЭДО",
						,
						Отказ);
				КонецЕсли;
				Если ЭлектронныеДокументыСлужебныйВызовСервера.ЭтоПрямойОбмен(СтрокаТаблицы.СпособОбменаЭД)
					И Не ЗначениеЗаполнено(СтрокаТаблицы.ИдентификаторКонтрагента) Тогда
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Колонка", "ЗАПОЛНЕНИЕ", "Идентификатор контрагента",
						СтрокаТаблицы.НомерСтроки, "Электронные документы"),
						ЭтотОбъект,
						Префикс + "ИдентификаторКонтрагента",
						,
						Отказ);
				КонецЕсли;
				
				Если СтрокаТаблицы.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезКаталог Тогда
					ПроверитьНастройкиПрямогоОбмена = Истина;
					
					ПроверяемыеРеквизиты.Добавить("КаталогВходящихДокументов");
					ПроверяемыеРеквизиты.Добавить("КаталогИсходящихДокументов");
				ИначеЕсли СтрокаТаблицы.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезЭлектроннуюПочту Тогда
					ПроверитьНастройкиПрямогоОбмена = Истина;
					
					ПроверяемыеРеквизиты.Добавить("ЭлектроннаяПочтаКонтрагента");
				ИначеЕсли СтрокаТаблицы.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезFTP Тогда
					ПроверитьНастройкиПрямогоОбмена = Истина;
					
					ПроверяемыеРеквизиты.Добавить("КаталогВходящихДокументовFTP");
					ПроверяемыеРеквизиты.Добавить("КаталогИсходящихДокументовFTP");
				КонецЕсли;
			КонецЦикла;
			
		Иначе
			
			Если ЭлектронныеДокументыСлужебныйВызовСервера.ЭтоПрямойОбмен(СпособОбменаЭД)
				И Не ЗначениеЗаполнено(ИдентификаторКонтрагента) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Поле", "Заполнение", "Идентификатор контрагента"),
					ЭтотОбъект,
					"ИдентификаторКонтрагента",
					,
					Отказ);
			КонецЕсли;
			
			Если СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезКаталог Тогда
				ПроверяемыеРеквизиты.Добавить("КаталогВходящихДокументов");
				ПроверяемыеРеквизиты.Добавить("КаталогИсходящихДокументов");
			ИначеЕсли СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезЭлектроннуюПочту Тогда
				
				ПроверяемыеРеквизиты.Добавить("ЭлектроннаяПочтаКонтрагента");
			ИначеЕсли СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезFTP Тогда
				
				ПроверяемыеРеквизиты.Добавить("КаталогВходящихДокументовFTP");
				ПроверяемыеРеквизиты.Добавить("КаталогИсходящихДокументовFTP");
			КонецЕсли;
		КонецЕсли;
		
		Если СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезЭлектроннуюПочту
			ИЛИ СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезКаталог
			ИЛИ СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезFTP 
			ИЛИ ПроверитьНастройкиПрямогоОбмена Тогда
			
			МассивСтрокФайловОбмена = ФорматыФайловОбмена.НайтиСтроки(Новый Структура("Использовать, ФорматФайла",
				Истина, ПредопределенноеЗначение("Перечисление.ФорматыФайловОбменаЭД.XML")));
			
			Если МассивСтрокФайловОбмена.Количество() = 0 Тогда
				ТекстСообщения = НСтр("ru='Формат исходящего документа ""ДокументХML(*.xml)"" обязателен к использованию.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ,
					"ФорматыФайловОбмена", "Объект", Отказ);
			КонецЕсли;
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	ПроверяемыеРеквизиты.Очистить();
	Если ЭтоИнтеркампани И СтатусСоглашения = Перечисления.СтатусыСоглашенийЭД.Действует Тогда
		
		Если НЕ ЗначениеЗаполнено(Организация) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Поле", "Заполнение", "Организация-отправитель"),
				ЭтотОбъект,
				"Организация",
				,
				Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ИдентификаторОрганизации) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Поле", "Заполнение", "Идентификатор отправителя"),
				ЭтотОбъект,
				"ИдентификаторОрганизации",
				,
				Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Поле", "Заполнение", "Организация-получатель"),
				ЭтотОбъект,
				"Контрагент",
				,
				Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ИдентификаторКонтрагента) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Поле", "Заполнение", "Идентификатор получателя"),
				ЭтотОбъект,
				"ИдентификаторКонтрагента",
				,
				Отказ);
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	ПроверяемыеРеквизиты.Добавить("Наименование");
	Если СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезВебРесурсБанка
		И СтатусСоглашения = Перечисления.СтатусыСоглашенийЭД.Действует Тогда
		
		
		Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Поле", "Заполнение", "Банк"),
				ЭтотОбъект,
				"Контрагент",
				,
				Отказ);
		КонецЕсли;
		
		Если ПрограммаБанка = Перечисления.ПрограммыБанка.СбербанкОнлайн Тогда
			Если НЕ ЗначениеЗаполнено(ИдентификаторОрганизации) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Поле", "Заполнение", "Идентификатор организации"),
						ЭтотОбъект,
						"ИдентификаторОрганизации",
						,
						Отказ);
			КонецЕсли;
		ИначеЕсли ПрограммаБанка = Перечисления.ПрограммыБанка.ОбменЧерезДопОбработку Тогда
			Если НЕ ЗначениеЗаполнено(ДополнительнаяОбработка) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Поле", "Заполнение", "Дополнительная обработка"),
					ЭтотОбъект,
					"ДополнительнаяОбработка",
					,
					Отказ);
			КонецЕсли;
		Иначе
			Если НЕ ЗначениеЗаполнено(АдресСервера) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Поле", "Заполнение", "Адрес сервера банка"),
					ЭтотОбъект,
					"АдресСервера",
					,
					Отказ);
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(РесурсИсходящихДокументов) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Поле", "Заполнение", "Ресурс для отправки"),
					ЭтотОбъект,
					"РесурсИсходящихДокументов",
					,
					Отказ);
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(РесурсВходящихДокументов) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Поле", "Заполнение", "Ресурс для получения"),
					ЭтотОбъект,
					"РесурсВходящихДокументов",
					,
					Отказ);
			КонецЕсли;
		КонецЕсли;
		
		Если ПрограммаБанка = Перечисления.ПрограммыБанка.ОбменЧерезДопОбработку ИЛИ ИспользуетсяКриптография Тогда
			Если СертификатыПодписейОрганизации.Количество() = 0 Тогда
				ТекстСообщения = ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Список",
				                                                                         "Заполнение",
				                                                                         ,
				                                                                         ,
				                                                                         "Подписи платежных поручений");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,
				                                                  ЭтотОбъект,
				                                                  "СертификатыПодписейОрганизации",
				                                                  ,
				                                                  Отказ);
			КонецЕсли;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не НастройкаЭДОУникальна() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Только для внутреннего использования
Функция НастройкаЭДОУникальна() Экспорт
	
	Если ПометкаУдаления Тогда
		Возврат Истина;
	КонецЕсли;
	
	ТекущаяНастройкаУникальна = Истина;
	
	// Проверка на уникальное использование настройки по реквизитам: Организация, Контрагент, ДоговорКонтрагента.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущаяНастройка",   ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("Организация",        ЭтотОбъект.Организация);
	Запрос.УстановитьПараметр("Контрагент",         ЭтотОбъект.Контрагент);
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ЭтотОбъект.ДоговорКонтрагента);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НастройкиЭДО.Контрагент КАК Контрагент,
	|	НастройкиЭДО.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	НастройкиЭДО.Организация КАК Организация
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК НастройкиЭДО
	|ГДЕ
	|	НЕ НастройкиЭДО.ПометкаУдаления
	|	И НастройкиЭДО.Организация = &Организация
	|	И НастройкиЭДО.Контрагент = &Контрагент
	|	И НастройкиЭДО.ДоговорКонтрагента = &ДоговорКонтрагента
	|	И НастройкиЭДО.Ссылка <> &ТекущаяНастройка";
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		ТекущаяНастройкаУникальна = Ложь;
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ШаблонСообщения = НСтр("ru = 'В информационной базе уже существует настройка ЭДО между контрагентом %1 и организацией %2'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Выборка.Контрагент,
				Выборка.Организация);
			Если ЗначениеЗаполнено(Выборка.ДоговорКонтрагента) Тогда
				ТекстСообщения = ТекстСообщения + НСтр("ru = ' по договору'") + " " + Выборка.ДоговорКонтрагента;
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТекущаяНастройкаУникальна;
	
КонецФункции

#КонецЕсли