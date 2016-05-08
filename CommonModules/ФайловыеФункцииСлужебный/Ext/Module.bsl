﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Файловые функции".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Объявляет служебные события подсистемы ФайловыеФункции:
//
// Серверные события:
//   ПриДобавленииФайловВТомаПриРазмещении,
//   ПриУдаленииРегистрацииИзменений,
//   ПриОпределенииТекстаЗапросаДляИзвлеченияТекста,
//   ПриОпределенииКоличестваВерсийСНеизвлеченнымТекстом,
//   ПриЗаписиИзвлеченногоТекста,
//   ПриОпределенииКоличестваФайловВТомах,
//   ПриОпределенииНаличияХранимыхФайлов,
//   ПриПолученииХранимыхФайлов,
//   ПриОпределенииНавигационнойСсылкиФайла,
//   ПриОпределенииИмениФайлаСПутемКДвоичнымДанным,
//   ПриОпределенииДвоичныхДанныхФайлаИПодписи,
//
// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия) Экспорт
	
	// СЕРВЕРНЫЕ СОБЫТИЯ.
	
	// Добавляет файл на том при "Разместить файлы начального образа"
	//
	// Синтаксис:
	// Процедура ПриДобавленииФайловВТомаПриРазмещении(СоответствиеПутейФайлов, ХранитьФайлыВТомахНаДиске, ПрисоединяемыеФайлы) Экспорт
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.ФайловыеФункции\ПриДобавленииФайловВТомаПриРазмещении");
	
	// Удаляет регистрацию изменений после "Разместить файлы начального образа"
	//
	// Синтаксис:
	// Процедура ПриУдаленииРегистрацииИзменений(ПланОбменаСсылка, ПрисоединяемыеФайлы) Экспорт
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.ФайловыеФункции\ПриУдаленииРегистрацииИзменений");
	
	// Возвращает текст запроса для извлечения текста
	//
	// Синтаксис:
	// Процедура ПриОпределенииТекстаЗапросаДляИзвлеченияТекста(ТекстЗапроса, ПолучитьВсеФайлы = Ложь) Экспорт
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.ФайловыеФункции\ПриОпределенииТекстаЗапросаДляИзвлеченияТекста");
	
	// Возвращает число файлов с неизвлеченным текстом
	//
	// Синтаксис:
	// Процедура ПриОпределенииКоличестваВерсийСНеизвлеченнымТекстом(ЧислоВерсий) Экспорт
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.ФайловыеФункции\ПриОпределенииКоличестваВерсийСНеизвлеченнымТекстом");
	
	// Записывает извлеченный текст
	//
	// Синтаксис:
	// Процедура ЗаписатьИзвлеченныйТекст(ФайлОбъект) Экспорт
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.ФайловыеФункции\ПриЗаписиИзвлеченногоТекста");
	
	// Возвращает в параметре КоличествоФайловВТомах количество файлов в томах.
	//
	// Синтаксис:
	// Процедура ПриОпределенииКоличестваФайловВТомах(КоличествоФайловВТомах) Экспорт
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.ФайловыеФункции\ПриОпределенииКоличестваФайловВТомах");
	
	// Возвращает Истина в параметре ЕстьХранимыеФайлы, если есть хранимые файлы к объекту ВнешнийОбъект.
	//
	// Синтаксис:
	// Процедура ПриОпределенииНаличияХранимыхФайлов(ВнешнийОбъект, ЕстьХранимыеФайлы) Экспорт
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.ФайловыеФункции\ПриОпределенииНаличияХранимыхФайлов");
	
	// Возвращает в параметре ХранимыеФайлы массив хранимых файлов к объекту ВнешнийОбъект.
	//
	// Синтаксис:
	// Процедура ПриПолученииХранимыхФайлов(ВнешнийОбъект, ХранимыеФайлы) Экспорт
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.ФайловыеФункции\ПриПолученииХранимыхФайлов");
	
	// Возвращает навигационную ссылку на файл (на реквизит или во временное хранилище)
	//
	// Синтаксис:
	// Процедура ПриОпределенииНавигационнойСсылкиФайла(ФайлСсылка, УникальныйИдентификатор, НавигационнаяСсылка) Экспорт
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.ФайловыеФункции\ПриОпределенииНавигационнойСсылкиФайла");
	
	// Получает полный путь к файлу на диске
	//
	// Синтаксис:
	// Процедура ПриОпределенииИмениФайлаСПутемКДвоичнымДанным(ФайлСсылка, ПутьКФайлу) Экспорт
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.ФайловыеФункции\ПриОпределенииИмениФайлаСПутемКДвоичнымДанным");
	
	// Возвращает структуру с двоичными данными файла и подписи.
	//
	// Синтаксис:
	// Процедура ПриОпределенииДвоичныхДанныхФайлаИПодписи(ДанныеСтроки, ДанныеФайлаИПодписи) Экспорт
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.ФайловыеФункции\ПриОпределенииДвоичныхДанныхФайлаИПодписи");
	
КонецПроцедуры

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
			"ФайловыеФункцииСлужебный");
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
		СерверныеОбработчики[
			"СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий\ПриОпределенииИспользованияРегламентныхЗаданий"].Добавить(
				"ФайловыеФункцииСлужебный");
	КонецЕсли;
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистем"].Добавить(
			"ФайловыеФункцииСлужебный");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Стандартный программный интерфейс

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации. 
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ДобавитьПараметрыРаботыКлиента(Параметры) Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиРаботыСФайлами = ФайловыеФункцииСлужебныйПовтИсп.НастройкиРаботыСФайлами();
	
	Параметры.Вставить("ПерсональныеНастройкиРаботыСФайлами", Новый ФиксированнаяСтруктура(
		НастройкиРаботыСФайлами.ПерсональныеНастройки));
	
	Параметры.Вставить("ОбщиеНастройкиРаботыСФайлами", Новый ФиксированнаяСтруктура(
		НастройкиРаботыСФайлами.ОбщиеНастройки));
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Поддержка обмена файлами

// Служебная функции. Используется для удаления файла на сервере
// 
Процедура УдалитьФайлыНаСервере(ПрежнийПутьНаТоме) Экспорт
	
	// Удаляем файл.
	ФайлВременный = Новый Файл(ПрежнийПутьНаТоме);
	Если ФайлВременный.Существует() Тогда
		
		Попытка
			ФайлВременный.УстановитьТолькоЧтение(Ложь);
			УдалитьФайлы(ПрежнийПутьНаТоме);
		Исключение
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Файлы.Удаление файлов в томе при обмене'"),
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				ИнформацияОбОшибке());
		КонецПопытки;
		
	КонецЕсли;
	
	// Удаляем каталог файла, если после удаления файла каталог стал пустым.
	Попытка
		МассивФайловВКаталоге = НайтиФайлы(ФайлВременный.Путь, "*.*");
		Если МассивФайловВКаталоге.Количество() = 0 Тогда
			УдалитьФайлы(ФайлВременный.Путь);
		КонецЕсли;
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Файлы.Удаление файлов в томе при обмене'"),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ИнформацияОбОшибке() );
	КонецПопытки;
	
КонецПроцедуры

// Возвращает тип хранения файлов с учетом наличия томов.
// Если томов хранения файлов нет, тогда хранение в ИБ.
//
// Возвращаемое значение:
//  ПеречисленияСсылка.ТипыХраненияФайлов.
//
Функция ТипХраненияФайлов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ХранитьФайлыВТомахНаДиске = Константы.ХранитьФайлыВТомахНаДиске.Получить();
	
	Если ХранитьФайлыВТомахНаДиске Тогда
		
		Если ФайловыеФункции.ЕстьТомаХраненияФайлов() Тогда
			Возврат Перечисления.ТипыХраненияФайлов.ВТомахНаДиске;
		Иначе
			Возврат Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе;
		КонецЕсли;
		
	Иначе
		Возврат Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе;
	КонецЕсли;

КонецФункции

// Возвращает полный путь тома - в зависимости от ОС
Функция ПолныйПутьТома(СсылкаНаТом) Экспорт
	
	ТипПлатформыСервера = ОбщегоНазначенияПовтИсп.ТипПлатформыСервера();
	
	Если ТипПлатформыСервера = ТипПлатформы.Windows_x86
	 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
		
		Возврат СсылкаНаТом.ПолныйПутьWindows;
	Иначе
		Возврат СсылкаНаТом.ПолныйПутьLinux;
	КонецЕсли;
	
КонецФункции

// Добавляет файл в один из томов (где есть свободное место).
Процедура ДобавитьНаДиск(
		ДвоичныеДанные,
		ПутьКФайлуВТоме,
		СсылкаНаТом,
		ВремяИзмененияУниверсальное,
		НомерВерсии,
		ИмяБезРасширения,
		Расширение,
		РазмерФайла = 0,
		Зашифрован = Ложь,
		ДатаДляРазмещенияВТоме = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СсылкаНаТом = Справочники.ТомаХраненияФайлов.ПустаяСсылка();
	
	КраткоеОписаниеВсехОшибок   = ""; // Ошибки со всех томов.
	ПодробноеОписаниеВсехОшибок = ""; // Для журнала регистрации.
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТомаХраненияФайлов.Ссылка
		|ИЗ
		|	Справочник.ТомаХраненияФайлов КАК ТомаХраненияФайлов
		|ГДЕ
		|	ТомаХраненияФайлов.ПометкаУдаления = &ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТомаХраненияФайлов.ПорядокЗаполнения";

	Запрос.УстановитьПараметр("ПометкаУдаления", Ложь);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		ВызватьИсключение(НСтр("ru = 'Нет ни одного тома для размещения файла.'"));
	КонецЕсли;
	
	Пока Выборка.Следующий() Цикл
		
		СсылкаНаТом = Выборка.Ссылка;
		
		ПутьКТому = ПолныйПутьТома(СсылкаНаТом);
		// Добавляем слэш в конце, если его нет.
		ПутьКТому = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
			ПутьКТому, ОбщегоНазначенияПовтИсп.ТипПлатформыСервера());
		
		// Имя файла для хранения на диске формировать следующим образом
		// - имя файла.номер версии.расширение файла.
		Если ПустаяСтрока(НомерВерсии) Тогда
			ИмяФайла = ИмяБезРасширения + "." + Расширение;
		Иначе
			ИмяФайла = ИмяБезРасширения + "." + НомерВерсии + "." + Расширение;
		КонецЕсли;
		
		Если Зашифрован Тогда
			ИмяФайла = ИмяФайла + "." + "p7m";
		КонецЕсли;
		
		Попытка
			
			// Если МаксимальныйРазмер = 0 - нет ограничения на размер файлов на томе.
			Если СсылкаНаТом.МаксимальныйРазмер <> 0 Тогда
				
				ТекущийРазмерВБайтах = 0;
				
				ПриОпределенииРазмераФайловНаТоме(СсылкаНаТом.Ссылка, ТекущийРазмерВБайтах);
				
				НовыйРазмерВБайтах = ТекущийРазмерВБайтах + РазмерФайла;
				НовыйРазмер = НовыйРазмерВБайтах / (1024 * 1024);
				
				Если НовыйРазмер > СсылкаНаТом.МаксимальныйРазмер Тогда
					
					ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Превышен максимальный размер тома (%1 Мб).'"),
						СсылкаНаТом.МаксимальныйРазмер);
				КонецЕсли;
			КонецЕсли;
			
			Дата = ТекущаяДатаСеанса();
			Если ДатаДляРазмещенияВТоме <> Неопределено Тогда
				Дата = ДатаДляРазмещенияВТоме;
			КонецЕсли;
			
			ПутьДня = Формат(Дата, "ДФ=ггггММдд") + ОбщегоНазначенияКлиентСервер.РазделительПути();
			ПутьКТому = ПутьКТому + ПутьДня;
			
			ИмяФайлаСПутем = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьУникальноеИмяСПутем(ПутьКТому, ИмяФайла, ОбщегоНазначенияПовтИсп.ТипПлатформыСервера());
			ПолноеИмяФайлаСПутем = ПутьКТому + ИмяФайлаСПутем;
			
			Если ТипЗнч(ДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
				ДвоичныеДанные.Записать(ПолноеИмяФайлаСПутем);
			ИначеЕсли ТипЗнч(ДвоичныеДанные) = Тип("Строка") Тогда // считаем, что иначе это путь к файлу на диске
				КопироватьФайл(ДвоичныеДанные, ПолноеИмяФайлаСПутем);
			Иначе
				СтрокаИсключения = НСтр("ru = 'Неверный тип данных для добавления на том'");
				ВызватьИсключение(СтрокаИсключения);
			КонецЕсли;
			
			// Установка времени изменения файла таким, как оно стоит в текущей версии.
			ФайлНаДиске = Новый Файл(ПолноеИмяФайлаСПутем);
			ФайлНаДиске.УстановитьУниверсальноеВремяИзменения(ВремяИзмененияУниверсальное);
			ФайлНаДиске.УстановитьТолькоЧтение(Истина);
			
			ПутьКФайлуВТоме = ПутьДня + ИмяФайлаСПутем;
			Возврат; // закончили - выйдем из процедуры
			
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			
			Если ПодробноеОписаниеВсехОшибок <> "" Тогда
				ПодробноеОписаниеВсехОшибок = ПодробноеОписаниеВсехОшибок + Символы.ПС + Символы.ПС;
				КраткоеОписаниеВсехОшибок   = КраткоеОписаниеВсехОшибок   + Символы.ПС + Символы.ПС;
			КонецЕсли;
			
			ШаблонОписанияОшибки =
				НСтр("ru = 'Ошибка при добавлении файла ""%1""
				           |в том ""%2"" (%3):
				           |""%4"".'");
			
			ПодробноеОписаниеВсехОшибок = ПодробноеОписаниеВсехОшибок
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонОписанияОшибки,
					ИмяФайла,
					Строка(СсылкаНаТом),
					ПутьКТому,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			
			КраткоеОписаниеВсехОшибок = КраткоеОписаниеВсехОшибок
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонОписанияОшибки,
					ИмяФайла,
					Строка(СсылкаНаТом),
					ПутьКТому,
					КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
			
			// надо переходить к следующему тому
			Продолжить;
		КонецПопытки;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	// запись в журнал регистрации для администратора
	// здесь выдадим ошибки со всех томов
	ШаблонСообщенияОбОшибке =
		НСтр("ru = 'Не удалось добавить файл ни в один из томов.
		           |Список ошибок:
		           |
		           |%1'");
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Файлы.Добавление файла'"),
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщенияОбОшибке,
			ПодробноеОписаниеВсехОшибок));
	
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		СтрокаИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщенияОбОшибке,
			КраткоеОписаниеВсехОшибок);
	Иначе
		// Сообщение обычному пользователю.
		СтрокаИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось добавить файл:
			           |""%1.%2"".
			           |
			           |Обратитесь к администратору.'"),
			ИмяБезРасширения, Расширение);
	КонецЕсли;
	
	ВызватьИсключение СтрокаИсключения;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЭЦП для файлов

// Проверяет подписи в строках коллекции.
//
// Параметры:
//  КоллекцияСтрок - Массив, ДанныеФормыКоллекция или аналогичный тип
//                   с элементами содержащими свойства:
//                     Объект       - Файл или присоединенный файл,
//                     Статус       - Строка,
//                     Неверна      - Булево
//                     АдресПодписи - Строка - адрес подписи
//                                    во временном хранилище.
//
Процедура ПроверитьПодписиВСтрокахКоллекции(КоллекцияСтрок) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПровайдерЭЦП           = Константы.ПровайдерЭЦП.Получить();
	ПутьМодуляКриптографии = ЭлектроннаяЦифроваяПодписьПовтИсп.ПутьМодуляКриптографии();
	ТипПровайдераЭЦП       = Константы.ТипПровайдераЭЦП.Получить();
	АлгоритмПодписи        = Константы.АлгоритмПодписи.Получить();
	АлгоритмХеширования    = Константы.АлгоритмХеширования.Получить();
	АлгоритмШифрования     = Константы.АлгоритмШифрования.Получить();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	МенеджерКриптографии = Новый МенеджерКриптографии(
		ПровайдерЭЦП, ПутьМодуляКриптографии, ТипПровайдераЭЦП);
	
	МенеджерКриптографии.АлгоритмПодписи     = АлгоритмПодписи;
	МенеджерКриптографии.АлгоритмХеширования = АлгоритмХеширования;
	МенеджерКриптографии.АлгоритмШифрования  = АлгоритмШифрования;
	
	Для Каждого Строка Из КоллекцияСтрок Цикл
		
		Если Строка.Объект <> Неопределено
		   И НЕ Строка.Объект.Пустая() Тогда
			
			ПроверитьОднуПодписьНаСервере(Строка, МенеджерКриптографии);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочие функции

// Возвращает Истина, если текст из файлов извлекается на сервере, а не на клиенте.
//
// Возвращаемое значение:
//  Булево. Ложь - если текст не извлекается на сервере,
//                 т.е. может и должен быть извлечен на клиенте.
//
Функция ИзвлекатьТекстыФайловНаСервере() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы.ИзвлекатьТекстыФайловНаСервере.Получить();
	
КонецФункции

// Возвращает Истина, если сервер работает под Windows
Функция ЭтоПлатформаWindows() Экспорт
	
	ТипПлатформыСервера = ОбщегоНазначенияПовтИсп.ТипПлатформыСервера();
	
	Если ТипПлатформыСервера = ТипПлатформы.Windows_x86
	 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции


// Получает строку из временного хранилища (передача с клиента на сервер,
// делается через временное хранилище)
//
Функция ПолучитьСтрокуИзВременногоХранилища(АдресВременногоХранилищаТекста) Экспорт
	
	Если ПустаяСтрока(АдресВременногоХранилищаТекста) Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ПолучитьИзВременногоХранилища(АдресВременногоХранилищаТекста).Записать(ИмяВременногоФайла);
	
	ТекстовыйФайл = Новый ЧтениеТекста(ИмяВременногоФайла, КодировкаТекста.UTF8);
	Текст = ТекстовыйФайл.Прочитать();
	ТекстовыйФайл.Закрыть();
	УдалитьФайлы(ИмяВременногоФайла);
	
	Возврат Текст;
	
КонецФункции

// Служебная функция используется для помещения двоичных данных файла в томе
// в хранилище значения
//
Функция ПоместитьДвоичныеДанныеВХранилище(Том, ПутьКФайлу, УникальныйИдентификатор) Экспорт
	
	ПолныйПуть = ПолныйПутьТома(Том) + ПутьКФайлу;
	УникальныйИдентификатор = УникальныйИдентификатор;
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ПолныйПуть);
	Возврат Новый ХранилищеЗначения(ДвоичныеДанные);
	
КонецФункции

// Служебная функция используется при создании начального образа
// Выполняется всегда на сервере
//
Процедура СкопироватьФайлПриСозданииНачальногоОбраза(ПолныйПуть, НовыйПутьФайла) Экспорт
	
	Попытка
		// если файл в томе - скопируем его во временный каталог (при создании начального образа)
		КопироватьФайл(ПолныйПуть, НовыйПутьФайла);
		ФайлВременный = Новый Файл(НовыйПутьФайла);
		ФайлВременный.УстановитьТолькоЧтение(Ложь);
	Исключение
		// не регистрируется, возможно файл не найден
	КонецПопытки;
	
КонецПроцедуры


// Записывает на сервер результат извлечения текста - извлеченный текст и СтатусИзвлеченияТекста
Процедура ЗаписатьРезультатИзвлеченияТекста(ФайлИлиВерсияСсылка,
                                            РезультатИзвлечения,
                                            АдресВременногоХранилищаТекста) Экспорт
	
	ФайлИлиВерсияОбъект = ФайлИлиВерсияСсылка.ПолучитьОбъект();
	ФайлИлиВерсияОбъект.Заблокировать();
	
	Если ПустаяСтрока(АдресВременногоХранилищаТекста) Тогда
		Текст = "";
	Иначе
		Текст = ПолучитьСтрокуИзВременногоХранилища(АдресВременногоХранилищаТекста);
		ФайлИлиВерсияОбъект.ТекстХранилище = Новый ХранилищеЗначения(Текст);
		УдалитьИзВременногоХранилища(АдресВременногоХранилищаТекста);
	КонецЕсли;
	
	Если РезультатИзвлечения = "НеИзвлечен" Тогда
		ФайлИлиВерсияОбъект.СтатусИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.НеИзвлечен;
	ИначеЕсли РезультатИзвлечения = "Извлечен" Тогда
		ФайлИлиВерсияОбъект.СтатусИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.Извлечен;
	ИначеЕсли РезультатИзвлечения = "ИзвлечьНеУдалось" Тогда
		ФайлИлиВерсияОбъект.СтатусИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.ИзвлечьНеУдалось;
	КонецЕсли;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ФайловыеФункции\ПриЗаписиИзвлеченногоТекста");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриЗаписиИзвлеченногоТекста(ФайлИлиВерсияОбъект);
	КонецЦикла;
	
КонецПроцедуры


// Возвращает Истина, если есть хранимые файлы к объекту ВнешнийОбъект.
Функция ЕстьХранимыеФайлы(ВнешнийОбъект) Экспорт
	
	Результат = Ложь;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ФайловыеФункции\ПриОпределенииНаличияХранимыхФайлов");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриОпределенииНаличияХранимыхФайлов(ВнешнийОбъект, Результат);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает хранимые файлы к объекту ВнешнийОбъект
//
Функция ПолучитьХранимыеФайлы(ВнешнийОбъект) Экспорт
	
	МассивДанных = Новый Массив;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ФайловыеФункции\ПриПолученииХранимыхФайлов");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриПолученииХранимыхФайлов(ВнешнийОбъект, МассивДанных);
	КонецЦикла;
	
	Возврат МассивДанных;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий подсистем БСП

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	
КонецПроцедуры	

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации.
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистем(Параметры) Экспорт
	
	ДобавитьПараметрыРаботыКлиента(Параметры);
	
КонецПроцедуры

// Перенести константы СписокЗапрещенныхРасширений и СписокРасширенийФайловOpenDocument
Процедура ПеренестиКонстантыРасширений() Экспорт
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

Процедура ПроверитьОднуПодписьНаСервере(ДанныеСтроки, МенеджерКриптографии)
	
	СтруктураВозврата = Неопределено;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ФайловыеФункции\ПриОпределенииДвоичныхДанныхФайлаИПодписи");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриОпределенииДвоичныхДанныхФайлаИПодписи(ДанныеСтроки, СтруктураВозврата);
	КонецЦикла;
	
	ДвоичныеДанныеФайла   = СтруктураВозврата.ДвоичныеДанные;
	ДвоичныеДанныеПодписи = СтруктураВозврата.ДвоичныеДанныеПодписи;
	
	Попытка
		ЭлектроннаяЦифроваяПодпись.ПроверитьПодпись(
			МенеджерКриптографии, ДвоичныеДанныеФайла, ДвоичныеДанныеПодписи);
		
		ДанныеСтроки.Статус  = НСтр("ru = 'Верна'");
		ДанныеСтроки.Неверна = Ложь;
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		ДанныеСтроки.Статус  = НСтр("ru = 'Неверна'");
		ДанныеСтроки.Неверна = Истина;
		
		Если ИнформацияОбОшибке.Причина <> Неопределено Тогда
			ДанныеСтроки.Статус = ДанныеСтроки.Статус + ". " + ИнформацияОбОшибке.Причина.Описание;
		КонецЕсли;
		
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в другие подсистемы

// Дополняет структуру, содержащую общие и персональные настройки по работе с файлами.
Процедура ПриДобавленииНастроекРаботыСФайлами(ОбщиеНастройки, ПерсональныеНастройки) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("РаботаСФайламиСлужебныйВызовСервера");
		Модуль.ДобавитьНастройкиРаботыСФайлами(ОбщиеНастройки, ПерсональныеНастройки);
	КонецЕсли;
	
КонецПроцедуры

// Вычисляет объём файлов тома в байтах, результат возвращается в параметр РазмерФайлов.
Процедура ПриОпределенииРазмераФайловНаТоме(СсылкаТома, РазмерФайлов) Экспорт
	
	РазмерФайлов = 0;
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("РаботаСФайламиСлужебныйВызовСервера");
		РазмерФайлов = РазмерФайлов + Модуль.ПодсчитатьРазмерФайловНаТоме(СсылкаТома);
	КонецЕсли;
	
КонецПроцедуры
