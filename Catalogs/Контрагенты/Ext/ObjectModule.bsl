﻿Перем мОснование;

// Обработчик события ПриКопировании
//
Процедура ПриКопировании(ОбъектКопирования)

	Если НЕ ЭтотОбъект.ЭтоГруппа Тогда
		ЭтотОбъект.ОсновнойДоговорКонтрагента = Неопределено;
		ЭтотОбъект.ОсновнойБанковскийСчет     = Неопределено;
		Если ОбъектКопирования.ГоловнойКонтрагент = ОбъектКопирования.Ссылка Тогда
			ЭтотОбъект.ГоловнойКонтрагент     = Неопределено;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Функция возвращает результат запроса по справочнику контрагентов с заданным головным контрагентом
//
// Параметры:
//  ГоловнойКонтрагент - заданный головной контрагент
//
// Возвращаемое значение:
//  Результат - результат работы запроса
// 
Функция ПолучитьКонтрагентовПоЗаданномуГоловномуКонтрагенту(ГоловнойКонтрагент) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ГоловнойКонтрагент", ГоловнойКонтрагент);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка КАК Контрагент,
	|	Контрагенты.ОбособленноеПодразделение КАК ОбособленноеПодразделение
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|
	|ГДЕ
	|	Контрагенты.ГоловнойКонтрагент = &ГоловнойКонтрагент
	|	И Контрагенты.ГоловнойКонтрагент <> Контрагенты.Ссылка
	|	И НЕ Контрагенты.ПометкаУдаления
	|	И НЕ Контрагенты.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	Контрагент";
	
	Результат = Запрос.Выполнить();
	
	Возврат Результат;
	
КонецФункции // ПолучитьКонтрагентовПоЗаданномуГоловномуКонтрагенту()

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Если ТипЗнч(Основание) = Тип("СправочникСсылка.Организации") Тогда
		
		Наименование           = Основание.Наименование;
		ЮрФизЛицо              = Основание.ЮрФизЛицо;
		НаименованиеПолное     = Основание.НаименованиеПолное;
		ОсновнойБанковскийСчет = Основание.ОсновнойБанковскийСчет;
		ИНН                    = Основание.ИНН;
		КПП                    = Основание.КПП;
		КодПоОКПО              = Основание.КодПоОКПО;
		мОснование             = Основание;
		
	КонецЕсли;

КонецПроцедуры // ОбработкаЗаполнения()

Процедура ПередЗаписью(Отказ)
	
	Перем мСсылкаНового;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
	// Проверим основной вид деятельности контрагента
	Если ЗначениеЗаполнено(ОсновнойВидДеятельности) И ВидыДеятельности.Найти(ОсновнойВидДеятельности, "ВидДеятельности") = Неопределено Тогда
		ОсновнойВидДеятельности = Справочники.ВидыДеятельностиКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
	НастройкаПравДоступа.ПередЗаписьюНовогоОбъектаСПравамиДоступаПользователей(ЭтотОбъект, Отказ, Родитель, мСсылкаНового);
	
	// установим головного контрагента если он не заполнен
	Если НЕ ЭтоГруппа И НЕ ЗначениеЗаполнено(ГоловнойКонтрагент) И НЕ ОбособленноеПодразделение Тогда
		Если ЭтоНовый() Тогда
			ГоловнойКонтрагент = мСсылкаНового;
		Иначе
			ГоловнойКонтрагент = Ссылка;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГоловнойКонтрагент) И ГоловнойКонтрагент <> Ссылка Тогда
		
		Если ЗначениеЗаполнено(ГоловнойКонтрагент.ГоловнойКонтрагент) И ГоловнойКонтрагент.ГоловнойКонтрагент <> ГоловнойКонтрагент Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Контрагент "+СокрЛП(ГоловнойКонтрагент)+" не может быть выбран головным, 
						|так как для него уже был назначен головной контрагент "+СокрЛП(ГоловнойКонтрагент.ГоловнойКонтрагент)+"!");
			Отказ = Истина;
			Возврат;
		Иначе
			
			// надо проверить, что если указываем головного контрагента, то этот элемент уже не был установлен
			// в качестве головного у другого контрагента.
			ВыборкаПоГоловномуКонтрагенту = ПолучитьКонтрагентовПоЗаданномуГоловномуКонтрагенту(Ссылка).Выбрать();
			Если ВыборкаПоГоловномуКонтрагенту.Количество() <> 0 Тогда
				
				СообщениеОНевозможностиЗаписи = "Контрагент "+СокрЛП(ЭтотОбъект)+" не может иметь головного контрагента!
				|Этот контрагент уже установлен головным для: ";
				Пока ВыборкаПоГоловномуКонтрагенту.Следующий() Цикл
					СообщениеОНевозможностиЗаписи = СообщениеОНевозможностиЗаписи + Символы.ПС + СокрЛП(ВыборкаПоГоловномуКонтрагенту.Контрагент);
				КонецЦикла;
				
				ОбщегоНазначения.СообщитьОбОшибке(СообщениеОНевозможностиЗаписи);
				Отказ = Истина;
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// проверим, что контрагент - физ. лицо уже не был установлен головным контрагентом для обособленных подразделений
	Если НЕ ЭтоНовый() И ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
		
		ЕстьОбособленныеПодразделения = Ложь;
		СообщениеОНевозможностиЗаписи = "Контрагент " + СокрЛП(ЭтотОбъект) + " не может быть физическим лицом!
			|Этот контрагент уже установлен головным для: ";
			
		ВыборкаПоГоловномуКонтрагенту = ПолучитьКонтрагентовПоЗаданномуГоловномуКонтрагенту(Ссылка).Выбрать();			
		Если ВыборкаПоГоловномуКонтрагенту.Количество() <> 0 Тогда
			Пока ВыборкаПоГоловномуКонтрагенту.Следующий() Цикл
				Если ВыборкаПоГоловномуКонтрагенту.ОбособленноеПодразделение Тогда
					ЕстьОбособленныеПодразделения = Истина;
					СообщениеОНевозможностиЗаписи = СообщениеОНевозможностиЗаписи + Символы.ПС + СокрЛП(ВыборкаПоГоловномуКонтрагенту.Контрагент);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;	
		
		Если ЕстьОбособленныеПодразделения Тогда
			ОбщегоНазначения.СообщитьОбОшибке(СообщениеОНевозможностиЗаписи, Отказ);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(мОснование) Тогда
		НаборЗаписей = РегистрыСведений.СобственныеКонтрагенты.СоздатьНаборЗаписей();
		ЗаписьРегистра = НаборЗаписей.Добавить();
		ЗаписьРегистра.Контрагент = Ссылка;
		ЗаписьРегистра.ВидСвязи   = Перечисления.ВидыСобственныхКонтрагентов.Организация;
		ЗаписьРегистра.Объект     = мОснование;
		НаборЗаписей.Записать(Ложь);
		мОснование = "";
	КонецЕсли;
	
	// при изменении ИНН перепишем ИНН у обособленных подразделений контрагента
	Если НЕ ЭтоНовый() И НЕ ОбособленноеПодразделение И ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда
		
		ВыборкаПоГоловномуКонтрагенту = ПолучитьКонтрагентовПоЗаданномуГоловномуКонтрагенту(Ссылка).Выбрать();
		Если ВыборкаПоГоловномуКонтрагенту.Количество() <> 0 Тогда
			
			Пока ВыборкаПоГоловномуКонтрагенту.Следующий() Цикл
				
				Если ИНН = ВыборкаПоГоловномуКонтрагенту.Контрагент.ИНН
					ИЛИ НЕ ВыборкаПоГоловномуКонтрагенту.ОбособленноеПодразделение Тогда
					Продолжить;
				КонецЕсли;
				
				КонтрагентДляИзменения = ВыборкаПоГоловномуКонтрагенту.Контрагент.ПолучитьОбъект();
				КонтрагентДляИзменения.ИНН = ИНН;
				Попытка
					КонтрагентДляИзменения.Записать();
				Исключение
					ОписаниеОшибки = "Ошибка при записи обособленных подразделений контрагента.
					|Не удалось изменить ИНН у обособленного подразделения " + КонтрагентДляИзменения.Наименование;
					ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки);
				КонецПопытки;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
