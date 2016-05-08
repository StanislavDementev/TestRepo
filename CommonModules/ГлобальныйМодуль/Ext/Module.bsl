﻿#Если ТолстыйКлиентОбычноеПриложение Тогда
///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ ОЖИДАНИЯ

// Завершение работы только при условии удачной установки монопольного режима работы
// Вызывается, только при запуске системы от имени администратора с параметром запуска "ЗавершитьРаботуПользователей"
//
Процедура ЗавершитьРаботуПользователей() Экспорт

	Сеансы = ПолучитьСеансыИнформационнойБазы();
	
	Если Сеансы.Количество() = 1 Тогда
		// Отключены все пользователи, кроме текущего сеанса
		// В последнюю очередь завершается сеанс, запущенный с параметром "ЗавершитьРаботуПользователей".
		// Такой порядок отключений необходим для обновления конфигурации с помощью пакетного файла
		
		ЗавершитьРаботуСистемы(Ложь);
		
		Возврат;
	КонецЕсли; 
	
	// Получим текущее значение параметров блокировки
	ТекущийРежим = ПолучитьБлокировкуУстановкиСоединений();
	БлокировкаУстановлена = ТекущийРежим.Установлена;
	ВремяНачалаБлокировки = ТекущийРежим.Начало;
	ИнтервалОтключения    = - УправлениеСоединениямиИБ.ИнтервалОжиданияЗавершенияРаботыПользователей();
	ТекущийМомент = ТекущаяДата();
	
	Если БлокировкаУстановлена И
		(НЕ ЗначениеЗаполнено(ВремяНачалаБлокировки) 
			ИЛИ ВремяНачалаБлокировки - ТекущийМомент <= ИнтервалОтключения) Тогда
			
		// после начала блокировки сеансы всех пользователей должны быть отключены	
		// если этого не произошло пробуем принудительно прервать соединения
		ОтключитьОбработчикОжидания("ЗавершитьРаботуПользователей");
		
		// Невозможно принудительно отсоединить подключения в файловом режиме работы
		Если ОпределитьЭтаИнформационнаяБазаФайловая() Тогда
			УправлениеСоединениямиИБ.РазрешитьРаботуПользователей();
			Сообщение = УправлениеСоединениямиИБ.ПолучитьНазванияСоединенийИБ("Не удалось завершить работу пользователей:");
			ЗаписьЖурналаРегистрации("Завершение работы пользователей", УровеньЖурналаРегистрации.Предупреждение, , , Сообщение);
			ЗавершитьРаботуСистемы(Ложь);
			Возврат;	
		КонецЕсли;	
		
		ПараметрыАдминистрированияИБ = УправлениеСоединениямиИБ.ПолучитьПараметрыАдминистрированияИБ();
		ПараметрыЗапуска = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(ПараметрЗапуска,";");
		Если ПараметрыЗапуска.Количество() > 1 Тогда
			ПараметрыАдминистрированияИБ.ИмяАдминистратораИБ = Врег(ПараметрыЗапуска[1]);
		КонецЕсли;
		Если ПараметрыЗапуска.Количество() > 2 Тогда
			ПараметрыАдминистрированияИБ.ПарольАдминистратораИБ = Врег(ПараметрыЗапуска[2]);
		КонецЕсли;
		
		Результат = УправлениеСоединениямиИБ.ОтключитьСоединенияИБ(ПараметрыАдминистрированияИБ);
		Если Результат Тогда
			Сообщить("Завершение работы пользователей выполнено успешно.", СтатусСообщения.Информация);
			ЗавершитьРаботуСистемы(Ложь);
		Иначе
			Сообщение = УправлениеСоединениямиИБ.ПолучитьНазванияСоединенийИБ("Не удалось завершить работу пользователей:");
			Сообщить(Сообщение, СтатусСообщения.Внимание);
			ЗаписьЖурналаРегистрации("Завершение работы пользователей", УровеньЖурналаРегистрации.Предупреждение, , , Сообщение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура перезапуска сеанса работы с программой
Процедура ПерезапуститьСеансРаботыСПрограммой() Экспорт
	глЗапрашиватьПодтверждениеПриЗакрытии = Ложь;
	
	ЗавершитьРаботуСистемы(Истина, Истина);
КонецПроцедуры
	
// Проверяет в конфигурации ИБ наличие изменений появившихся после старта сеанса
//
Процедура ОбработчикОжиданияПроверкиДинамическогоИзмененияИБ() Экспорт

	// Если в конфигурации после старта текущего сеанса что-то изменилось
	Если КонфигурацияБазыДанныхИзмененаДинамически() Тогда


		// Завершим проверку обновления
		ЗавершитьПроверкуДинамическогоОбновленияИБ();

		// Спросим пользователя о его желании перезапустить сеанс
		ТекстВопроса = "В конфигурацию ИБ внесены изменения." + Символы.ПС +
						"Для работы с ними рекомендуется перезапустить программу." + Символы.ПС +
						"Перезапустить?";
		РезультатВопроса = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);

		// Если пользователь не хочет перезапускать сеанс
		Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
			// Запустим проверку обновления опять
			НачатьПроверкуДинамическогоОбновленияИБ();
			Возврат;
		КонецЕсли;

	
		// Попробуем перезапустить
		ПерезапуститьСеансРаботыСПрограммой();

	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОВЕРКА ДИНАМИЧЕСКОГО ОБНОВЛЕНИЯ
//

// Начинает проверку динамического обновления конфигурации ИБ
//
Процедура НачатьПроверкуДинамическогоОбновленияИБ()Экспорт
	
	// проверка дин. обновления конфигурации каждые 20 мин.
	ПодключитьОбработчикОжидания("ОбработчикОжиданияПроверкиДинамическогоИзмененияИБ", 20 * 60);

КонецПроцедуры

// Завершает проверку динамического обновления конфигурации ИБ
//
Процедура ЗавершитьПроверкуДинамическогоОбновленияИБ()Экспорт

	// Отключим соответствующий обработчик ожидания
	ОтключитьОбработчикОжидания("ОбработчикОжиданияПроверкиДинамическогоИзмененияИБ");

КонецПроцедуры

#КонецЕсли

// Возвращает Истина, если информационная база - файловая.
//
// Параметры:
//    СтрокаСоединенияСБД - Строка - строка соединения. Если параметр не задан, 
//                                   то используется текущая информационная база.
//
Функция ОпределитьЭтаИнформационнаяБазаФайловая(СтрокаСоединенияСБД = "") Экспорт
			
	СтрокаСоединенияСБД = ?(ПустаяСтрока(СтрокаСоединенияСБД), СтрокаСоединенияИнформационнойБазы(), СтрокаСоединенияСБД);
	
	// в зависимости от того файловый это вариант БД или нет немного по-разному путь в БД формируется
	ПозицияПоиска = Найти(Врег(СтрокаСоединенияСБД), "FILE=");
	
	Возврат ПозицияПоиска = 1;	
	
КонецФункции



#Если Сервер И НЕ Клиент И НЕ ВнешнееСоединение Тогда

Функция глЗначениеПеременной(Имя) Экспорт
	
	Кэш = ПараметрыСеанса.ОбщиеЗначения.Получить();
	КэшИзменен = Ложь;
	ПолученноеЗначение = ОбщегоНазначения.ПолучитьЗначениеПеременной(Имя, Кэш, КэшИзменен);
	
	Если КэшИзменен Тогда
		ПараметрыСеанса.ОбщиеЗначения = Новый ХранилищеЗначения(Кэш);
	КонецЕсли;
	
	Возврат ПолученноеЗначение;
	
КонецФункции

// Процедура установки значения экспортных переменных модуля приложения
//
// Параметры
//  Имя - строка, содержит имя переменной целиком
// 	Значение - значение переменной
//
Процедура глЗначениеПеременнойУстановить(Имя, Значение, ОбновлятьВоВсехКэшах = Ложь) Экспорт
	
	Кэш = ПараметрыСеанса.ОбщиеЗначения.Получить();	
	ОбщегоНазначения.УстановитьЗначениеПеременной(Имя, Кэш, Значение);
	ПараметрыСеанса.ОбщиеЗначения = Новый ХранилищеЗначения(Кэш);	
	
КонецПроцедуры


#КонецЕсли
