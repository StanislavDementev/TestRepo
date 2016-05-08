﻿Перем глСерверТО;
Перем мКлиентOnline;

Перем глОбщиеЗначения Экспорт;

Перем глЗапрашиватьПодтверждениеПриЗакрытии Экспорт;
Перем АдресРесурсовОбозревателя Экспорт; // В переменной содержится значение 
										 // адреса ресурса данной конфигурации
Перем ФормаОповещенияЗадачОткрыта Экспорт;

// СтандартныеПодсистемы

// СтандартныеПодсистемы.БазоваяФункциональность
// СписокЗначений для накапливания пакета сообщений в журнал регистрации, 
// формируемых в клиентской бизнес-логике.
Перем СообщенияДляЖурналаРегистрации Экспорт; 
// Признак того, что в данном сеансе не нужно повторно предлагать установку
Перем ПредлагатьУстановкуРасширенияРаботыСФайлами Экспорт;
// Признак того, что в данном сеансе не нужно запрашивать стандартное подтверждение при выходе
Перем ПропуститьПредупреждениеПередЗавершениемРаботыСистемы Экспорт;
// Структура параметров для клиентской логики по завершению работы в программе.
Перем ПараметрыРаботыКлиентаПриЗавершении Экспорт;
// Признак того, что при запуске в сеансе администратора нужно вывести форму описаний изменений.
Перем ВывестиОписаниеИзмененийДляАдминистратора Экспорт;
// Структура, содержащая в себе время начала и окончания обновления программы.
Перем ПараметрыРаботыКлиентаПриОбновлении Экспорт;
// Конец СтандартныеПодсистемы.БазоваяФункциональность

// СтандартныеПодсистемы.ФайловыеФункции
// Признак того, что в данном сеансе не нужно повторно делать проверку доступа к каталогу на диске
Перем ПроверкаДоступаКРабочемуКаталогуВыполнена Экспорт;
// Конец СтандартныеПодсистемы.ФайловыеФункции

// Конец СтандартныеПодсистемы

// ЭлектронныеДокументы
Перем глWSОпределениеСбербанк Экспорт;
Перем глКриптоДЛЛСбербанк Экспорт;
Перем глПинКодСбербанк Экспорт;
Перем глНомерКонтейнераСбербанк Экспорт;
Перем глТекущееСоглашениеСбербанк Экспорт;
Перем глУстановленКаналСоСбербанком Экспорт;
Перем глВыполненаАвторизацияСбербанк Экспорт;
Перем ПараметрыПодсистемыОбменСБанками Экспорт;
Перем СоответствиеСертификатаИПароля Экспорт;

// функция вызова формы редактирования настройки файла обновления конфигурации
Процедура ОткрытьФормуРедактированияНастройкиФайлаОбновления() Экспорт
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.Константы.НастройкаФайлаОбновленияКонфигурации) Тогда
		
		Предупреждение("Нет прав на чтение данных константы ""Настройка файла обновления конфигурации""", 30, "Настройка файла обновления конфигурации");		
		Возврат;
		
	КонецЕсли;

	ФормаРедактирования = ПолучитьОбщуюФорму("НастройкаФайлаОбновленияКонфигурации");
	ФормаРедактирования.СтруктураПараметров = ПроцедурыОбменаДанными.ПолучитьНастройкиДляФайлаОбновленияКонфигурации(); 
	ФормаРедактирования.Открыть();
	
КонецПроцедуры

// Процедура осуществляет проверку на необходимость обмена данными с заданным интервалом
Процедура ПроверкаОбменаДанными() Экспорт

	Если глЗначениеПеременной("глОбработкаАвтоОбменДанными") = Неопределено Тогда
		Возврат;
	КонецЕсли;		
	
	ОтключитьОбработчикОжидания("ПроверкаОбменаДанными");
	
	// проводим обмен данными
	глЗначениеПеременной("глОбработкаАвтоОбменДанными").ПровестиОбменДанными(); 
		
	ПодключитьОбработчикОжидания("ПроверкаОбменаДанными", глЗначениеПеременной("глКоличествоСекундОпросаОбмена"));

КонецПроцедуры

Процедура ПередНачаломРаботыСистемы(Отказ)	
	
	УправлениеПользователями.ПроверитьВозможностьРаботыПользователя(Отказ);	
	
	Если Не Отказ Тогда
		// СтандартныеПодсистемы
		СтандартныеПодсистемыКлиент.ДействияПередНачаломРаботыСистемы(Отказ);
		// Конец СтандартныеПодсистемы
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ДействияПриНачалеРаботыСистемы(,Ложь);
	// Конец СтандартныеПодсистемы
	
	ЗаголовокСистемы = Константы.ЗаголовокСистемы.Получить();
	Если НЕ Пустаястрока(ЗаголовокСистемы) Тогда
		УстановитьЗаголовокСистемы(ЗаголовокСистемы);
	КонецЕсли; 
	
	ФормаОповещенияЗадачОткрыта = Ложь;
	
	мТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;

	ПервыйЗапуск = (Константы.НомерВерсииКонфигурации.Получить() = "");

	Если ОбновлениеИнформационнойБазы.ОбновитьИнформационнуюБазу() Тогда
		Возврат;
	КонецЕсли;
	
	// отработка параметров запуска системы
	Если ОбработатьПараметрыЗапуска(ПараметрЗапуска) Тогда
		Возврат;
	КонецЕсли;
	
	// Выполнить проверку разницы времени с сервером приложения
	Если НЕ ПроверкаРазницыВремениКлиент.ВыполнитьПроверку() Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеСоединениямиИБКлиент.УстановитьКонтрольРежимаЗавершенияРаботыПользователей();
	
	СформироватьОтчеты();
	
	ПроверитьПодключениеОбработчикаОжидания();
	
	// Проверка заполнения констант валют учетов
	Если НЕ ЗначениеЗаполнено(глЗначениеПеременной("ВалютаРегламентированногоУчета")) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не заполнена константа валюты регламентированного учета!");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(глЗначениеПеременной("ВалютаУправленческогоУчета")) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не заполнена константа валюты управленческого учета!");

	КонецЕсли;
	
	// Открытие встроенного почтового клиента при запуске системы, если это задано в настройках
	Если УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(мТекущийПользователь, "АвтооткрытиеЭлектроннойПочтыПриЗапускеПрограммы") = Истина
	   И Константы.ИспользованиеВстроенногоПочтовогоКлиента.Получить() 
	   И (Не ПервыйЗапуск) Тогда
		Обработки.МенеджерКонтактов.ПолучитьФорму().Открыть();
	КонецЕсли;

	// Проверка наличия комплекта обновления обработок обслуживания торгового оборудования
	ПроверятьООПриЗапуске = ВосстановитьЗначение("ПроверкаНаличияОбновленияОбработокОбслуживанияПриЗапуске");
	ПроверятьООПриЗапуске = ?(ПроверятьООПриЗапуске = Неопределено, Ложь, ПроверятьООПриЗапуске);

	Если ПроверятьООПриЗапуске
	    И (Не ПервыйЗапуск) Тогда
		АдресИПараметрыСервера = Новый Структура;
		АдресИПараметрыСервера.Вставить("АдресОбработок", ПолучитьСерверТО().ПолучитьАдресОбновленияОбработокОбслуживания());

		Если РаботаСТорговымОборудованием.ПроверитьДоступностьНовыхОбработок(АдресИПараметрыСервера, Истина) Тогда
			Ответ = Вопрос("Доступны новые обработки обслуживания торгового оборудования.
			|Открыть форму проверки и обновления обработок обслуживания?", РежимДиалогаВопрос.ДаНет);
			Если Ответ = КодВозвратаДиалога.Да Тогда
				РаботаСТорговымОборудованием.ОткрытьОбновлениеОбработокОбслуживания(АдресИПараметрыСервера);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	ВключенИнтерфейсКассира = Ложь;
	
	ЗапускИнтерфейсаКассира(мТекущийПользователь, ВключенИнтерфейсКассира);
	
	ЭтоФайловаяИБ = ОпределитьЭтаИнформационнаяБазаФайловая();
		
	Если ЭтоФайловаяИБ Тогда
					
		ПользовательДляВыполненияРеглЗаданий = Константы.ПользовательДляВыполненияРегламентныхЗаданийВФайловомВарианте.Получить();
		
		Если мТекущийПользователь = ПользовательДляВыполненияРеглЗаданий Тогда
			
			// с интервалом секунд вызываем процедуру работы с регламентными заданиями
			ПоддержкаРегламентныхЗаданиеДляФайловойВерсии();
			
			ПодключитьОбработчикОжидания("ПоддержкаРегламентныхЗаданиеДляФайловойВерсии", глЗначениеПеременной("глКоличествоСекундОпросаОбмена"));
			
		КонецЕсли;
		
	КонецЕсли;
	
	// автообмен данными
	Если глЗначениеПеременной("глОбработкаАвтоОбменДанными") <> Неопределено Тогда
		
		// подключим обработчик обменов данными
		ПодключитьОбработчикОжидания("ПроверкаОбменаДанными", глЗначениеПеременной("глКоличествоСекундОпросаОбмена"));
			
	КонецЕсли;
	
	//Если интерфейс кассира включен - панель не нужна.
	Если НЕ ВключенИнтерфейсКассира Тогда
		ОткрытьПанельФункций = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(мТекущийПользователь, "ОткрыватьПриЗапускеПанельФункций");

		Если ОткрытьПанельФункций 
		 Или ПервыйЗапуск Тогда
			ФормаПанели = Обработки.ПанельФункций.ПолучитьФорму();
			ФормаПанели.ПервыйЗапуск = ПервыйЗапуск;
			ФормаПанели.Открыть();
		КонецЕсли;

	КонецЕсли;
	
	// Открытие Быстрого освоения
	ПоказыватьБыстроеОсвоение = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(мТекущийПользователь, "ПоказыватьБыстроеОсвоениеПриНачалеРаботыСистемы");
	Если ПоказыватьБыстроеОсвоение 
	   И (Не ПервыйЗапуск) Тогда
		Обработки.БыстроеОсвоение.ПолучитьФорму().Открыть();
	КонецЕсли;
	
	// Открытие списка задач
	ПоказыватьСписокЗадач = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(мТекущийПользователь, "ПоказыватьСписокЗадачПриЗапуске");
	Если ПоказыватьСписокЗадач
	   И (Не ПервыйЗапуск) Тогда
		РаботаСДиалогами.ОткрытьЗадачиТекущегоПользователя();
	КонецЕсли;
	
	Если УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(мТекущийПользователь, "АвтооткрытиеФормыРабочегоМестаМенеджераПоПродажамПриЗапускеПрограммы") = Истина 
	   И (Не ПервыйЗапуск) Тогда
		Обработки.РабочееМестоМенеджераПоПродажам.ПолучитьФорму().Открыть();
	КонецЕсли;
	
	ПоказыватьФормуДополнительнойИнформации = ВосстановитьЗначение("ПоказСтартовойФормыДополнительнойИнформации");
	ПоказыватьФормуДополнительнойИнформации = ?(ПоказыватьФормуДополнительнойИнформации = Неопределено, Истина, ПоказыватьФормуДополнительнойИнформации);
	Если ПоказыватьФормуДополнительнойИнформации 
	   И (Не ПервыйЗапуск) Тогда
		Форма = Обработки.ДополнительнаяИнформация.ПолучитьФорму("ФормаРабочийСтол");
		Форма.Открыть();
	КонецЕсли;	
	
	// Начнем проверку динамического обновления конфигурации
	НачатьПроверкуДинамическогоОбновленияИБ();

	Если УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(мТекущийПользователь, "ЗагружатьАктуальныеКурсыВалютПриЗапускеСистемы") = Истина 
	   И (Не ПервыйЗапуск) Тогда
		ОбработкаЗагрузкиКурсовВалют = Обработки.КурсыВалютРБК.Создать();
		ОбработкаЗагрузкиКурсовВалют.НачДата = ТекущаяДата();
		ОбработкаЗагрузкиКурсовВалют.КонДата = ТекущаяДата();
		ОбработкаЗагрузкиКурсовВалют.ЗаполнитьВалюты(Истина);
		ОбработкаЗагрузкиКурсовВалют.ЗагрузитьКурсыСРБК();
	КонецЕсли;

	Если ПолучитьСерверТО().ПолучитьСписокУстройств(
	   Перечисления.ВидыТорговогоОборудования.ККМOnLine).Количество() > 0 Тогда
		мКлиентOnline = Обработки.ТОКлиентККМOnline.Создать();
		мКлиентOnline.НачатьРаботу();
	КонецЕсли;

	// Открытие формы помощника обновления конфигурации
	Если РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
		ОбработкаОбновлениеКонфигурации = Обработки.ОбновлениеКонфигурации.Создать();
		ОбработкаОбновлениеКонфигурации.ПроверитьНаличиеОбновлений();
	КонецЕсли;
	
КонецПроцедуры // ПриНачалеРаботыСистемы()

Процедура ПередЗавершениемРаботыСистемы(Отказ)
	
	Если глЗапрашиватьПодтверждениеПриЗакрытии <> Ложь Тогда
		ЗапрашиватьПотверждение = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),
	    													  "ЗапрашиватьПодтверждениеПриЗакрытии");
		Если ЗапрашиватьПотверждение Тогда
			Ответ = Вопрос("Завершить работу с программой?", РежимДиалогаВопрос.ДаНет);
			Отказ = (Ответ = КодВозвратаДиалога.Нет);
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		// отдельно получаем настройки для которых нужно выполнить обмен при выходе из программы
		ПроцедурыОбменаДанными.ВыполнитьОбменПриЗавершенииРаботыПрограммы(глЗначениеПеременной("глОбработкаАвтоОбменДанными"));
			
	КонецЕсли;

КонецПроцедуры

// процедура служит для поддержки работы регламентных заданий в файловой версии
Процедура ПоддержкаРегламентныхЗаданиеДляФайловойВерсии() Экспорт
	
	ВыполнитьОбработкуЗаданий();
	
КонецПроцедуры

Процедура ПриЗавершенииРаботыСистемы()

	// Показ финальной дополнительной информации
	Форма = Обработки.ДополнительнаяИнформация.Создать();
	Форма.ВыполнитьДействие();
	//

КонецПроцедуры

// Процедура выполняет запуск отчетов, у которых установлен
// признак "Формировать при входе в систему"
//
Процедура СформироватьОтчеты()

	ВыбраннаяНастройка = ВосстановитьЗначение( "ОбработкаРапортРуководителю_Настройки");
	Если Не ВыбраннаяНастройка = Неопределено Тогда

		Параметры = Неопределено;
		Если ВыбраннаяНастройка.Свойство("_ДанныеФормы", Параметры) Тогда
			АвтоЗапуск = Неопределено;
			Параметры.Свойство("ФормироватьПриСтартеСистемы", АвтоЗапуск);
			Если Не АвтоЗапуск = Неопределено И АвтоЗапуск Тогда
				НовыйОтчет = Отчеты.РапортРуководителю.Создать();
				НовыйОтчетФорма = НовыйОтчет.ПолучитьФорму("ФормаГлавная");
				НовыйОтчетФорма.НачальноеЗначениеВыбора = Истина;
				НовыйОтчетФорма.Открыть();
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

// Процедура проверяет и при необходимости подключает обработчик ожидания
// на запуск процедуры ПроверитьНапоминания()
//
// Параметры:
//  Нет.
//
Процедура ПроверитьПодключениеОбработчикаОжидания() Экспорт

	ИнтервалПроверкиНапоминанийВСекундах = Константы.ИнтервалПроверкиНапоминанийВСекундах.Получить();
	
	Если глЗначениеПеременной("глТекущийПользователь") <> Неопределено
		 И ТипЗнч(глЗначениеПеременной("глТекущийПользователь")) = Тип("СправочникСсылка.Пользователи")
		 И НЕ глЗначениеПеременной("глТекущийПользователь").Пустая()
		 И ИнтервалПроверкиНапоминанийВСекундах > 0 Тогда
		 
		ПодключитьОбработчикОжидания("ПроверитьНапоминания", ИнтервалПроверкиНапоминанийВСекундах);

		УправлениеКонтактами.ПроверитьНапоминанияПользователя(глЗначениеПеременной("глТекущийПользователь"));

	Иначе

		ОтключитьОбработчикОжидания("ПроверитьНапоминания");

	КонецЕсли; 

КонецПроцедуры

// Процедура проверяет Напоминания
//
Процедура ПроверитьНапоминания() Экспорт

	УправлениеКонтактами.ПроверитьНапоминанияПользователя(глЗначениеПеременной("глТекущийПользователь"));

КонецПроцедуры

// Открывает форму текущего пользователя для изменения его настроек.
//
// Параметры:
//  Нет.
//
Процедура ОткрытьФормуТекущегоПользователя() Экспорт

	Если НЕ ЗначениеЗаполнено(глЗначениеПеременной("глТекущийПользователь")) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не задан текущий пользователь.");
	Иначе
		Форма = глЗначениеПеременной("глТекущийПользователь").ПолучитьФорму();
		Форма.Открыть();
	КонецЕсли;

КонецПроцедуры // ОткрытьФормуТекущегоПользователя()

// Функция возвращает объект для взаимодействия с торговым оборудованием.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  <ОбработкаОбъект> - Объект для взаимодействия с торговым оборудованием.
//
Функция ПолучитьСерверТО() Экспорт

	Если глСерверТО = Неопределено Тогда
		глСерверТО = Обработки.ТОСервер.Создать();
	КонецЕсли;

	Возврат глСерверТО;

КонецФункции // ПолучитьСерверТО()

// Функция возвращает значение экспортных переменных модуля приложенийа
//
// Параметры
//  Имя - строка, содержит имя переменной целиком 
//
// Возвращаемое значение:
//   значение соответствующей экспортной переменной
Функция глЗначениеПеременной(Имя) Экспорт

	Возврат ОбщегоНазначения.ПолучитьЗначениеПеременной(Имя, глОбщиеЗначения);
	
КонецФункции

// Процедура установки значения экспортных переменных модуля приложения
//
// Параметры
//  Имя - строка, содержит имя переменной целиком
// 	Значение - значение переменной
//
Процедура глЗначениеПеременнойУстановить(Имя, Значение, ОбновлятьВоВсехКэшах = Ложь) Экспорт
	
	ОбщегоНазначения.УстановитьЗначениеПеременной(Имя, глОбщиеЗначения, Значение, ОбновлятьВоВсехКэшах);
	
КонецПроцедуры

// Проверяет необходимость открытия формы "РегистрацияПродаж" документа "ЧекККМ.
//
Процедура ЗапускИнтерфейсаКассира(мТекущийПользователь, ВключенИнтерфейсКассира)
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();

	Если ПользовательИБ <> Неопределено
	   И ПользовательИБ.ОсновнойИнтерфейс <> Неопределено
	   И ПользовательИБ.ОсновнойИнтерфейс.Имя = "ИнтерфейсКассира" Тогда //Задействуем интерфейс кассира

		ВключенИнтерфейсКассира = Истина;
		Администратор = Ложь;
		Кассир = Ложь;

		Для каждого ТекИнтерфейс Из ГлавныйИнтерфейс Цикл
			ТекИнтерфейс.Переключаемый = Ложь;
			ТекИнтерфейс.Видимость     = Ложь;
		КонецЦикла;
		ИнтерфейсКассира = ГлавныйИнтерфейс.ИнтерфейсКассира;
		ИнтерфейсКассира.Переключаемый = Истина;
		ИнтерфейсКассира.Видимость     = Истина;

		Если РольДоступна("АдминистраторККМ") Тогда //Администратор

			Администратор = Истина;

		ИначеЕсли РольДоступна("ОператорККМ") Тогда //Кассир

			Кассир = Истина;

		КонецЕсли;

		Отказ = Ложь;
		Причина = "";
		КассаККМ = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(мТекущийПользователь, "ОсновнаяКассаККМ");
		Если КассаККМ = Справочники.КассыККМ.ПустаяСсылка() Тогда
			Предупреждение("Для пользователя """+ мТекущийПользователь +""" не выбрана касса по умолчанию!");
			Отказ = Истина;
			Причина = "Не выбрана касса по умолчанию";
		КонецЕсли;

		Склад = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(мТекущийПользователь, "ОсновнойСклад");
		Если Склад = Неопределено
		 Или Склад = Справочники.Склады.ПустаяСсылка() Тогда
			Предупреждение("Для пользователя """+ мТекущийПользователь +""" не выбран склад по умолчанию!");
			Отказ = Истина;
			Причина = "Не выбран склад по умолчанию";
		КонецЕсли;

		ФР = Неопределено;
		Если Не Отказ Тогда
			МассивФР = ПолучитьСерверТО().ПолучитьСписокУстройств(Перечисления.ВидыТорговогоОборудования.ФискальныйРегистратор, КассаККМ);

			Если МассивФР.Количество() <> 0
			 Или (УстановленЕНВДОрганизации(КассаККМ.Владелец)
			   И КассаККМ.ФормироватьНефискальныеЧеки) Тогда
				Если Склад.НомерСекции = 0 Тогда
					Предупреждение("У склада: """ + Склад + """не указан номер секции!");
					Отказ = Истина;
					Причина = "У склада не указан номер секции";
				КонецЕсли;
					
			Иначе
				Предупреждение("У кассы: """ + КассаККМ + """, для компьютера: """ + ПолучитьСерверТО().ПолучитьИмяКомпьютераТО() + """, фискальный регистратор не установлен!");
				Отказ = Истина;
				Причина = "У кассы не установлен ФР";
			КонецЕсли;
		КонецЕсли;

		Если Не Отказ Тогда

			ДокументЧекККМ = Документы.ЧекККМ.СоздатьДокумент();
			ДокументЧекККМ.КассаККМ = КассаККМ;
			ДокументЧекККМ.КассаККМ = КассаККМ.Владелец;
			ДокументЧекККМ.ПолучитьФорму("ФормаРегистрацииПродаж",).Открыть();

		ИначеЕсли Администратор Тогда

			Предупреждение("Зайдите с правами администратора кассы.");
			Если Причина = "ФР не подключен" 
			 Или Причина = "ТО не подключено" 
			 Или Причина = "У кассы не установлен ФР" Тогда
				ФормаПодключенияОборудования = Обработки.ТОНастройка.ПолучитьФорму();
				ФормаПодключенияОборудования.Открыть();
			КонецЕсли;
			ЗавершитьРаботуСистемы();

		ИначеЕсли Кассир Тогда

			Если Причина = "ФР не подключен" 
			 Или Причина = "ТО не подключено" 
			 Или Причина = "У кассы не установлен ФР" Тогда
				Предупреждение("Зайдите с правами администратора кассы.");
			КонецЕсли;

			ЗавершитьРаботуСистемы();

		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик внешнего событие, которое возникает при посылке
// внешним приложением сообщения, сформированного в специальном формате.
// Внешнее событие сначала обрабатывается всеми открытыми формами, имеющими
// обработчик этого события, а затем может быть обработано в процедуре модуля
// приложения с именем ОбработкаВнешнегоСобытия().
//
// Параметры:
//  Источник - <Строка>
//           - Источник внешнего события.
//
//  Событие  - <Строка>
//           - Наименование события.
//
//  Данные   - <Строка>
//           - Данные для события.
//
Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)

	Если мКлиентOnline <> Неопределено Тогда
		мКлиентOnline.ВнешнееСобытие(Источник, Событие, Данные);
	КонецЕсли;

	ПолучитьСерверТО().ЗавершитьОбработкуВнешнегоСобытия(Источник, Событие, Данные);

КонецПроцедуры // ОбработкаВнешнегоСобытия()

// Обработать параметр запуска программы.
// Реализация функции может быть расширена для обработки новых параметров.
//
// Параметры
//  ПараметрЗапуска  – Строка – параметр запуска, переданный в конфигурацию 
//								с помощью ключа командной строки /C.
//
// Возвращаемое значение:
//   Булево   – Истина, если необходимо прервать выполнение процедуры ПриНачалеРаботыСистемы.
//
Функция ОбработатьПараметрыЗапуска(Знач ПараметрЗапуска)

	// есть ли параметры запуска
	Если ПустаяСтрока(ПараметрЗапуска) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Параметр может состоять из частей, разделенных символом ";".
	// Первая часть - главное значение параметра запуска. 
	// Наличие дополнительных частей определяется логикой обработки главного параметра.
	ПараметрыЗапуска = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(ПараметрЗапуска,";");
	ЗначениеПараметраЗапуска = Врег(ПараметрыЗапуска[0]);
	
	Результат = УправлениеСоединениямиИБ.ОбработатьПараметрыЗапуска(ЗначениеПараметраЗапуска, ПараметрыЗапуска);
	Возврат Результат;

КонецФункции

// Проверка установленного у организации признака "Розничная торговля облагается ЕНВД"
//
Функция УстановленЕНВДОрганизации(Организация)

	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	УчетнаяПолитикаНалоговыйУчетСрезПоследних.РозничнаяТорговляОблагаетсяЕНВД
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаНалоговыйУчет.СрезПоследних(&Дата, Организация = &Ссылка) КАК УчетнаяПолитикаНалоговыйУчетСрезПоследних
	|");

	Запрос.УстановитьПараметр("Ссылка", Организация);
	Запрос.УстановитьПараметр("Дата"  , ТекущаяДата());

	Выборка = Запрос.Выполнить().Выбрать();
	ОрганизацияОблагаетсяЕНВД = ?(Выборка.Следующий(), Выборка.РозничнаяТорговляОблагаетсяЕНВД, Ложь);

	Возврат ОрганизацияОблагаетсяЕНВД;

КонецФункции

// Не допускается изменять значение данной переменной
Если Найти(ВРег(Метаданные.Имя), "БАЗОВАЯ") > 0 Тогда
	АдресРесурсовОбозревателя = "TradeBase";
Иначе
	АдресРесурсовОбозревателя = "Trade";
КонецЕсли;

глНомерКонтейнераСбербанк = 0;
глУстановленКаналСоСбербанком = Ложь;
