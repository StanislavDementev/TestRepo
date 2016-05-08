﻿//////////////////////////////////////////////////////////////////////////////// 
// Модуль определяет "интерфейс" для обработки ОбновлениеКонфигурации, состоящий 
// из переопределяемых процедур и функций. Изменению подлежит код процедур и функций
// (реализация "интерфейса"), который разрабатывается под конкретную конфигурацию.

//////////////////////////////////////////////////////////////////////////////// 
// ФУНКЦИИ ДЛЯ ОБРАБОТКИ СОБЫТИЙ ПРОЦЕДУРЫ ОБНОВЛЕНИЯ
// 

// Проверить, что информационную базу можно обновить.
// Например, если выясняется, что обновление конфигурации не пройдет или 
// будет идти с проблемами, то пользователю выдается предупреждение, и 
// предлагается самостоятельно устранить причины, после чего 
// повторить попытку обновления.
//
// Параметры
//   ВыдаватьСообщения  – Булево – определяет, может ли функция выводить 
//                                 сообщения/диалоги или от нее требуется 
//                                 вернуть только результат проверки.
//
// Возвращаемое значение:
//   Булево   – признак готовности ИБ к проведению обновления.
//
// Пример реализации:
// 
//	Результат = ПроверитьКорректностьДанных();
//	Если НЕ Результат И ВыдаватьСообщения Тогда
//		Предупреждение("Конфигурация не может быть обновлена, так как ...");
//	КонецЕсли; 
//	Возврат Результат;
//
Функция ГотовностьКОбновлениюКонфигурации(Знач ВыдаватьСообщения) Экспорт
	Возврат Истина;	// результат по умолчанию
КонецФункции 

// Возвращает Истина, если при первом запуске системы необходимо выполнить 
// подключение к Интернету и проверить обновление.
//
// Возвращаемое значение:
//   Булево   - признак необходимости выполнения проверки обновления через
//              Интернет.
//
Функция ПроверятьОбновлениеЧерезИнтернетПриПервомЗапуске() Экспорт
	Возврат Ложь; // значение по умолчанию
КонецФункции
 
//////////////////////////////////////////////////////////////////////////////// 
// ФУНКЦИИ ДЛЯ ПРОВЕРКИ НАЛИЧИЯ И ПОЛУЧЕНИЯ ОБНОВЛЕНИЙ
// 

// Получить адрес веб-страницы с информацией о том, как получить доступ к 
// пользовательскому разделу на сайте поставщика конфигурации.
//
// Возвращаемое значение:
//   Строка   – адрес веб-страницы.
//
Функция АдресСтраницыИнформацииОПолученииДоступаКПользовательскомуСайту() Экспорт
	Возврат "http://users.v8.1c.ru/Rules.aspx";
КонецФункции 

// Получить имя файла с информацией о доступном обновлении на сайте поставщика
// конфигурации.
//
// Возвращаемое значение:
//   Строка   – имя файла.
//
Функция ИмяФайлаПроверкиНаличияОбновления() Экспорт
	Возврат "UpdInfo.txt";
КонецФункции 

// Получить короткое имя (идентификатор) конфигурации.
//
// Возвращаемое значение:
//   Строка   – короткое имя конфигурации.
//
Функция КороткоеИмяКонфигурации() Экспорт
	
#Если ТолстыйКлиентОбычноеПриложение Тогда
	Возврат АдресРесурсовОбозревателя;
#Иначе
	Возврат "";
#КонецЕсли
	
КонецФункции 

// Получить адрес веб-сервера поставщика конфигурации, на котором находится
// информация о доступных обновлениях.
//
// Возвращаемое значение:
//   Строка   – адрес веб-сервера.
//
// Пример реализации:
// 
//	Возврат "localhost";  // локальный веб-сервер для тестирования.
//
Функция АдресСервераДляПроверкиНаличияОбновления() Экспорт
	Возврат "downloads.1c.ru";
КонецФункции 

// Получить адрес страницы на веб-сервере поставщика конфигурации, на которой находится
// информация о доступных обновлениях.
//
// Возвращаемое значение:
//   Строка   – адрес веб-страницы.
//
// Пример реализации:
// 
//	Возврат "/1c.ru/buhplace/ITSREPV/V8Update/Configs/" + КороткоеИмяКонфигурации() + "/";  
//
Функция АдресРесурсовДляПроверкиНаличияОбновления() Экспорт
	Результат = "/ipp/ITSREPV/V8Update/Configs/" + КороткоеИмяКонфигурации() + "/";	
	// Определение редакции конфигурации
	ПодстрокиВерсии = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(Метаданные.Версия, ".");
	Если ПодстрокиВерсии.Количество() > 1 Тогда
		Результат = Результат + ПодстрокиВерсии[0] + ПодстрокиВерсии[1] + "/";
	КонецЕсли;
	// Определение версии платформы
	СисИнфо = Новый СистемнаяИнформация;
	ПодстрокиВерсии = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(СисИнфо.ВерсияПриложения, ".");
	Если Число(ПодстрокиВерсии[0]) >= 8 И Число(ПодстрокиВерсии[1]) >= 2 Тогда
		Результат = Результат + ПодстрокиВерсии[0] + ПодстрокиВерсии[1] + "/";
	КонецЕсли; 
	Возврат Результат;
КонецФункции

// Получить адрес сервера обновлений.
//
// Возвращаемое значение:
//   Строка   – адрес веб-сервера.
//
// Пример реализации:
// 
//	Возврат "localhost";  // локальный веб-сервер для тестирования.
//
Функция АдресСервераОбновлений() Экспорт
	
	// По умолчанию используем адрес, указанный в свойствах конфигурации.
	СерверОбновлений = СтрЗаменить(Метаданные.АдресКаталогаОбновлений, "http://", "");  
	Позиция = Найти(СерверОбновлений, "/");
	Если Позиция > 0 Тогда
		СерверОбновлений = Лев(СерверОбновлений, Позиция - 1);
	КонецЕсли;
	Возврат СерверОбновлений;

КонецФункции 

// Получить адрес каталога файлов обновления на сервере обновлений.
//
// Возвращаемое значение:
//   Строка   – адрес каталога на веб-сервере.
//
Функция АдресКаталогаШаблоновНаСервереОбновлений() Экспорт
	
	// По умолчанию используем адрес, указанный в свойствах конфигурации.
	СерверОбновлений = СтрЗаменить(Метаданные.АдресКаталогаОбновлений, "http://", "");  
	Позиция = Найти(СерверОбновлений, "/");
	Если Позиция > 0 Тогда
		КаталогШаблоновНаСервере = Сред(СерверОбновлений, Позиция, СтрДлина(СерверОбновлений));
		Если Прав(КаталогШаблоновНаСервере, 1) = "/" Тогда
			КаталогШаблоновНаСервере = Сред(КаталогШаблоновНаСервере, 1, СтрДлина(КаталогШаблоновНаСервере));
		КонецЕсли;
	Иначе
		КаталогШаблоновНаСервере = "";
	КонецЕсли;
	Возврат КаталогШаблоновНаСервере;
	
КонецФункции 

// Определить, используется ли для обновления конфигурации альтернативный 
// сервер обновлений.
//
// Возвращаемое значение:
//   Булево   – признак использования альтернативного сервера обновлений.
//
Функция ИспользоватьАльтернативныйИсточникПолученияОбновлений() Экспорт
    Возврат Ложь;
КонецФункции 

// Получить адрес альтернативного сервера обновлений.
//
// Возвращаемое значение:
//   Строка   – адрес веб-сервера.
//
Функция АльтернативныйСерверОбновлений() Экспорт
	Возврат "online.1c.ru";
КонецФункции 

// Получить адрес каталога файлов обновления на альтернативном сервере обновлений.
//
// Возвращаемое значение:
//   Строка   – адрес каталога на веб-сервере.
//
Функция АльтернативныйКаталогШаблоновНаСервереОбновлений() Экспорт
    Возврат "/upload/tmplts/";
КонецФункции 

// Определить, поставляются ли для данной конфигурации обновления на ИТС.
//
// Возвращаемое значение:
//   Булево   - признак того, что обновления поставляются на диске ИТС.
//
Функция ИспользоватьОбновлениеСДискаИТС() Экспорт
	Возврат Ложь; // значение по умолчанию 
КонецФункции 

// Определить, что используется базовая версия конфигурации.
//
// Возвращаемое значение:
//   Булево   - признак того, что конфигурация является базовой.
//
Функция ЭтоБазоваяВерсияКонфигурации() Экспорт
	Возврат Найти(ВРег(Метаданные.Имя), "БАЗОВАЯ") > 0;
КонецФункции

//////////////////////////////////////////////////////////////////////////////// 
// ФУНКЦИИ ДЛЯ РАБОТЫ С ИНТЕРНЕТОМ
// 

// Открыть веб-страницу из указанного адреса.
//
// Параметры
//  Адрес         – Строка – URL или имя файла
//                           <продолжение описания параметра>
//  Заголовок     – Строка – заголовок окна.
//  ВладелецФормы - Форма  - родительская формы.
//
// Пример реализации:
// 
//  // с использованием обработки Обозреватель
//#Если ТолстыйКлиентОбычноеПриложение Тогда
//	Обозреватель = Обработки.Обозреватель.ПолучитьФорму("Форма");
//	Обозреватель.СтартоваяСтраница = Адрес;
//	Если Заголовок <> Неопределено Тогда
//		Обозреватель.Заголовок = Заголовок;
//	КонецЕсли; 
//	Обозреватель.ВладелецФормы = ВладелецФормы;
//	Обозреватель.Открыть();
//#КонецЕсли	
//
Процедура ОткрытьВебСтраницу(Знач Адрес, Знач Заголовок = Неопределено, 
	Знач ВладелецФормы = Неопределено) Экспорт
	
#Если ТолстыйКлиентОбычноеПриложение Тогда
	ЗапуститьПриложение(Адрес);
#КонецЕсли	

КонецПроцедуры
 
//////////////////////////////////////////////////////////////////////////////// 
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ С ЭЛЕКТРОННОЙ ПОЧТОЙ
// 

// Имеются ли в конфигурации функции для отправки электронной почты. 
//
// Возвращаемое значение:
//   Булево   – признак, что в конфигурации реализована отправка эл. почты.
//
// Пример реализации:
// 
//	//Пример реализации на основе модуля УправлениеЭлектроннойПочтой.
//	ИспользованиеВстроенногоПочтовогоКлиента = Константы.ИспользованиеВстроенногоПочтовогоКлиента.Получить();
//	Возврат ИспользованиеВстроенногоПочтовогоКлиента;
//
Функция НаличиеЭлектроннойПочты() Экспорт
	
	Возврат Ложь;
	
КонецФункции	

// Отправляет письмо эл. почты (неинтерактивно). 
//
// Параметры
//  ИмяПользователя  – строка – имя пользователя-отправителя.
//  АдресНазначения  – строка – эл. почтовый адрес назначения.
//  УспешноеОбновление  – Булево – признак того, успешное или неуспешное обновление.
//
//  Если операция завершилась неуспешно, то процедура выбрасывает исключение.
//
// Пример реализации:
// 
// // Пример реализации на основе модуля УправлениеЭлектроннойПочтой.
//
//Пользователь = Справочники.Пользователи.НайтиПоКоду(ИмяПользователя);
//Если Пользователь = Справочники.Пользователи.ПустаяСсылка() Тогда
//	ВызватьИсключение "Ошибка при подготовке письма электронной почты: неизвестный пользователь " + ИмяПользователя + ".";
//КонецЕсли; 
//
//СписокДоступныхЗаписей = УправлениеЭлектроннойПочтой.ПроверитьУчетныеЗаписиДляОтправкиПисем(Пользователь);
//Если СписокДоступныхЗаписей.Количество() = 0 Тогда
//	ВызватьИсключение "Ошибка при подготовке письма электронной почты: нет доступных учетных записей.";
//КонецЕсли;
//
//СтруктураНовогоПисьма = Новый Структура;
//Если НЕ ПустаяСтрока(АдресНазначения) Тогда
//	СписокКому = Новый СписокЗначений;
//	СписокКому.Добавить(АдресНазначения, АдресНазначения);
//	СтруктураНовогоПисьма.Вставить("Кому", СписокКому);
//КонецЕсли; 
//СтруктураНовогоПисьма.Вставить("Тело"     , Текст);
//СтруктураНовогоПисьма.Вставить("ВидТекста", ?(ФорматHTML, Перечисления.ВидыТекстовЭлектронныхПисем.HTML, Перечисления.ВидыТекстовЭлектронныхПисем.Текст));
//СтруктураНовогоПисьма.Вставить("Тема"     , Тема);
//
//Письмо = УправлениеЭлектроннойПочтой.НаписатьПисьмо(
//	Пользователь, // ТекущийПользователь, 
//	СтруктураНовогоПисьма, // СтруктураНовогоПисьма = Неопределено, 
//	,// ПеренестиВложенияИзОснования = Ложь, 
//	,// Копирование = Ложь,
//	,// ТекущийЭлементХТМЛ = Ложь, 
//	,// Дополнительно = Неопределено, 
//	,// ФормаВладелец = Неопределено, 
//	,// ПодписьПодТекстом = Ложь,
//	Ложь); // ОткрыватьПисьмо = Истина
//Если Письмо = Неопределено Тогда
//	ВызватьИсключение "Ошибка при подготовке письма электронной почты.";
//КонецЕсли; 
//
//СоответствиеПисем = Новый Соответствие();
//
//СсылкаНаПисьмо = Неопределено;
//Письмо.Свойство("ПисьмоСсылка", СсылкаНаПисьмо);
//Если ЗначениеЗаполнено(СсылкаНаПисьмо) Тогда   
//	СоответствиеПисем.Вставить(СсылкаНаПисьмо); 
//КонецЕсли;
//
//ТекстОшибок = "";
//УправлениеЭлектроннойПочтой.ОтправитьПисьма(
//	СоответствиеПисем, // Письма
//	глЗначениеПеременной("глСоответствиеТекстовЭлектронныхПисем"),// СоответствиеТекстовЭлектронныхПисем
//	Пользователь, // ТекущийПользователь 
//	Ложь, // Знач ПоказыватьОкноВыполнения = Истина, 
//	ТекстОшибок); //ТекстОшибок = "");
//Если НЕ ПустаяСтрока(ТекстОшибок) Тогда
//	ВызватьИсключение "Ошибка при отправке письма электронной почты: " + ТекстОшибок;
//КонецЕсли; 
//
Процедура ОтправитьЭлектроннуюПочту(Знач ИмяПользователя, 
	Знач АдресНазначения, Знач Тема, Знач Текст, Знач ФорматHTML) Экспорт
	
	ВызватьИсключение "Отсутствует возможность отправки электронной почты.";	
	
КонецПроцедуры	

// Проверяет наличие учетной записи для отправки эл. почты 
// и при необходимости предлагает создать новую уч. запись.
//
// Параметры
//  ИмяПользователя  – строка – имя пользователя-отправителя, 
//								для которого проверяется уч. запись.
//
// Возвращаемое значение:
//   Булево   – Ложь, если операция завершилась неуспешно. Подробности ошибки 
//				записываются в журнал регистрации.
//
// Пример реализации:
//
//	// Пример реализации на основе модуля УправлениеЭлектроннойПочтой.
//	
//	Пользователь = Справочники.Пользователи.НайтиПоКоду(ИмяПользователя);
//	Если Пользователь = Справочники.Пользователи.ПустаяСсылка() Тогда
//		Возврат Ложь;
//	КонецЕсли; 
//	
//#Если ТолстыйКлиентОбычноеПриложение Тогда	
//	СписокДоступныхЗаписей = УправлениеЭлектроннойПочтой.ПроверитьУчетныеЗаписиДляОтправкиПисем(Пользователь);
//	Возврат СписокДоступныхЗаписей.Количество() > 0;
//#Иначе
//	Возврат Истина;
//#КонецЕсли
//
Функция ПроверитьУчетныеЗаписиДляОтправкиПисем(Знач ИмяПользователя) Экспорт

	Возврат Ложь; 	

КонецФункции 

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ИНТЕРАКТИВНОЙ РАБОТЫ В ФОРМЕ ПОМОЩНИКА
// 
#Если ТолстыйКлиентОбычноеПриложение Тогда
Функция ПроверитьЛегальностьПолученияОбновления(ПомощникОбновления)

	Если ПомощникОбновления.ЭтоБазоваяВерсияКонфигурации() Тогда
		Возврат Истина;
	КонецЕсли;

	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат Истина;
	КонецЕсли;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПринудительныйЗапуск", Истина);

	Результат = ОткрытьФормуМодально("Обработка.ЛегальностьПолученияОбновлений.Форма", ПараметрыФормы);
	
	Возврат Результат = Истина;

КонецФункции
#КонецЕсли

// Обработчик события перехода по страница помощника обновления.
//
// Параметры
//  ПомощникОбновления  - Обработка.ОбновлениеКонфигурации
//  ПредыдущаяСтраница  - Строка - имя страницы помощника.
//  СледующаяСтраница   - Строка - имя страницы помощника.
//  Отказ               - Булево - если записать значение Истина, то переход на 
//                                 страницу СледующаяСтраница не произойдет. 
//                                 По умолчанию, значение Ложь.
//
Процедура ПриПереходеНаСтраницуПомощника(ПомощникОбновления, ПредыдущаяСтраница, СледующаяСтраница, Отказ) Экспорт

	#Если ТолстыйКлиентОбычноеПриложение Тогда
	Если ПредыдущаяСтраница = "ФайлОбновления" И ПомощникОбновления.ИсточникОбновления = 2 
		И ПомощникОбновления.НуженФайлОбновления Тогда
		Отказ = НЕ ПроверитьЛегальностьПолученияОбновления(ПомощникОбновления);
	КонецЕсли;
	#КонецЕсли

КонецПроцедуры

// Обработчик вызывается перед завершением работы системы при обновлении конфигурации из помощника.
//
// Пример реализации:
// #Если ТолстыйКлиентОбычноеПриложение Тогда
//		  глЗапрашиватьПодтверждениеПриЗакрытии = Ложь;
// #КонецЕсли
//
Процедура ПередЗавершениемРаботыСистемы() Экспорт
	
КонецПроцедуры

