﻿////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
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
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

// Возвращает доступные табличные части для заполнения
//
// Возвращаемое значение:
//   Список значений с именами табличных частей
//
Функция ПолучитьТабличныеЧастиДляЗаполнения() Экспорт

	ТабличныеЧасти = Новый СписокЗначений;
	
	Возврат ТабличныеЧасти;

КонецФункции // ПолучитьТабличныеЧастиДляЗаполнения()


#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()


// Копирует значения движения в строку сторно нового движения
// для измерений и реквизитов. Ресурсы инвертируются
//
Процедура ЗаполнитьДвижениеСторно(Движение, Строка, МетаданныеОбъект)

	ЗаполнитьЗначенияСвойств(Движение, Строка,,"Период,Регистратор,ВидДвижения");
	
	// вид движения
	Если МетаданныеОбъект.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
		Движение.ВидДвижения = Строка.ВидДвижения;
	КонецЕсли;
	
	// ресурсы
	Для Каждого МДОбъект из МетаданныеОбъект.Ресурсы Цикл
		Движение[МДОбъект.Имя] = - Строка[МДОбъект.Имя];
	КонецЦикла;

КонецПроцедуры // ЗаполнитьДвижениеСторно

// Процедура выполянет сторнирование документа
//
Процедура СторнированиеДокумента(СторнируемыйДокумент, ДействиеНеВыполнено, СторнироватьРегистры = истина, СторнироватьПроводки = истина) 
	
	Если НЕ ЗначениеЗаполнено(СторнируемыйДокумент) Тогда
		Сообщить("Не выбран сторнируемый документ.");
		ДействиеНеВыполнено = Истина;
		Возврат;
	КонецЕсли;
	
	МетаданныеДокумент	= СторнируемыйДокумент.Метаданные();
	МетаданныеДвиженияКорректировкаЗаписейРегистров = ЭтотОбъект.Метаданные().Движения;

	Для Каждого МетаданныеРегистр Из МетаданныеДокумент.Движения Цикл

		// если документ "Корректировка записей регистров" не может иметь таких движений,
		// то это не сторнируемый регистр
		Если НЕ МетаданныеДвиженияКорректировкаЗаписейРегистров.Содержит(МетаданныеРегистр) Тогда
			Продолжить;
		КонецЕсли;
		
		НаборДвижений = Движения[МетаданныеРегистр.Имя];
		
		Если СторнироватьРегистры И Метаданные.РегистрыНакопления.Содержит(МетаданныеРегистр) Тогда
		   
			СторнируемыйНаборЗаписей = РегистрыНакопления[МетаданныеРегистр.Имя].СоздатьНаборЗаписей();
			
		Иначе
			Продолжить;
		КонецЕсли;
		
		СторнируемыйНаборЗаписей.Отбор.Регистратор.Значение = СторнируемыйДокумент;
		СторнируемыйНаборЗаписей.Прочитать();
		
		Для Каждого ДвижениеСторнируемое Из СторнируемыйНаборЗаписей Цикл

			ДвижениеСторно = НаборДвижений.Добавить();
			
			// реквизиты
			ЗаполнитьДвижениеСторно(ДвижениеСторно, ДвижениеСторнируемое, МетаданныеРегистр);

			ДвижениеСторно.Период = Дата;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура запускает выполнение действий, указанных в табличной части "Выполняемые действия"
//
Процедура ВыполнитьДействияДокумента() Экспорт

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(СтруктураШапкиДокумента);

	// проверка заполнения ТЧ "Выполняемые действия"
	ЕстьОшибки = Ложь;
	СтруктураОбязательныхПолей = Новый Структура("Действие");
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ЗаполнениеДвижений", СтруктураОбязательныхПолей, ЕстьОшибки, Заголовок);
	Если ЕстьОшибки Тогда
		Сообщить("Указанные в табличной части действия не выполнены");
		Возврат;
	КонецЕсли;
	
	// очистка существующих движений
	ОчищатьДвижения = Ложь;
	Для каждого Набор Из Движения Цикл
		
		Если Набор.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		#Если Клиент Тогда		
			
		Если НЕ ОчищатьДвижения Тогда
			
			Ответ = Вопрос("Существующие движения регистров и проводки будут очищены. Продолжить?",РежимДиалогаВопрос.ДаНет);
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				Возврат;
			КонецЕсли;
			
			ОчищатьДвижения = Истина;
		КонецЕсли;
		
		#КонецЕсли
		
		Набор.Очистить();
		
	КонецЦикла;
	Если ТаблицаРегистровНакопления.Количество() > 0 Тогда
		ТаблицаРегистровНакопления.Очистить();
	КонецЕсли;
	Если ТаблицаРегистровСведений.Количество() > 0 Тогда
		ТаблицаРегистровСведений.Очистить();
	КонецЕсли;
	
	// выполнение действий указанных в ТЧ "Выполняемые действия" документа
	Для каждого СтрокаТЧ из ЗаполнениеДвижений Цикл
		
		ДействиеНеВыполнено = Ложь;
		Если ТипЗнч(СтрокаТЧ.Действие) = Тип("Строка") Тогда
			
			Если СтрокаТЧ.Действие = "Сторно движений документа" Тогда
				СторнированиеДокумента(СтрокаТЧ.Документ,ДействиеНеВыполнено);
				Если ДействиеНеВыполнено Тогда
					Сообщить("Действие в строке "+СтрокаТЧ.НомерСтроки+" не выполнено!",СтатусСообщения.Важное);
				КонецЕсли;
			Иначе
				Сообщить("Неправильное наименование базового действия, строка № "+СтрокаТЧ.НомерСтроки+" не обработана.");
			КонецЕсли;
			
		Иначе
			
			#Если Клиент Тогда
				
			ИмяФайла = КаталогВременныхФайлов()+"PrnForm.tmp";
			ОбъектВнешнейФормы = СтрокаТЧ.Действие.ПолучитьОбъект();
			
			Если ОбъектВнешнейФормы = Неопределено Тогда
				Сообщить("Строка "+СтрокаТЧ.НомерСтроки+". Ошибка получения внешней обработки действия. Возможно обработка была удалена", СтатусСообщения.Важное);
				Возврат;
			КонецЕсли;
			
			ДвоичныеДанные = ОбъектВнешнейФормы.ХранилищеВнешнейОбработки.Получить();
			ДвоичныеДанные.Записать(ИмяФайла);
			Попытка
				Обработка = ВнешниеОбработки.Создать(ИмяФайла);
			Исключение
				Сообщить("Строка "+СтрокаТЧ.НомерСтроки+". Ошибка исполнения внешней обработки действия."+Символы.ПС+ОписаниеОшибки(), СтатусСообщения.Важное);
				Возврат;
			КонецПопытки;
			
			Попытка
				Обработка.Инициализировать(СтрокаТЧ.Документ, ЭтотОбъект,ДействиеНеВыполнено);
				Если ДействиеНеВыполнено Тогда
					Сообщить("Действие в строке "+СтрокаТЧ.НомерСтроки+" не выполнено!",СтатусСообщения.Важное);
				КонецЕсли;
			Исключение
				ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, "Действие в строке "+СтрокаТЧ.НомерСтроки+" не выполнено!");
			КонецПопытки;
			
			#КонецЕсли
			
		КонецЕсли;
	КонецЦикла;
	
	//обновить настройки
	Для каждого Набор Из Движения Цикл
		Если Набор.Количество() > 0 Тогда
			МетаданныеРегистр = Набор.Метаданные();
			
			Если Метаданные.РегистрыНакопления.Содержит(МетаданныеРегистр) Тогда
				НоваяСтрока = ТаблицаРегистровНакопления.Добавить();
				НоваяСтрока.Имя = МетаданныеРегистр.Имя;
				НоваяСтрока.Представление = МетаданныеРегистр.Синоним;
			ИначеЕсли Метаданные.РегистрыСведений.Содержит(МетаданныеРегистр) Тогда
				НоваяСтрока = ТаблицаРегистровСведений.Добавить();
				НоваяСтрока.Имя = МетаданныеРегистр.Имя;
				НоваяСтрока.Представление = МетаданныеРегистр.Синоним;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Процедура устанавливает/снимает признак активности движений документа
//
Процедура УстановитьАктивностьДвижений(ФлагАктивности)
	
	Для Каждого Движение Из Движения Цикл   
		Движение.Прочитать();
		Для Каждого Строка Из Движение Цикл
			Строка.Активность = ФлагАктивности;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры // УстановитьАктивностьДвижений()

Процедура ПриКопировании(ОбъектКопирования)

	Для каждого Набор Из ОбъектКопирования.Движения Цикл
		
		Набор.Прочитать();
		Если Набор.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НаборТекущегоОбъекта = Движения[Набор.Метаданные().Имя];
		
		Для каждого ЗаписьНабора Из Набор Цикл
		
			НоваяЗапись = НаборТекущегоОбъекта.Добавить();
			НоваяЗапись.Активность  = ЗаписьНабора.Активность;
			Если Лев(ТипЗНЧ(НаборТекущегоОбъекта),18) = "Регистр накопления" Тогда
				Если НаборТекущегоОбъекта.Метаданные().ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
					НоваяЗапись.ВидДвижения = ЗаписьНабора.ВидДвижения;
				КонецЕсли;
			КонецЕсли;
			НоваяЗапись.Период      = ТекущаяДата();
			
			Для каждого Измерение Из Набор.Метаданные().Измерения Цикл
				НоваяЗапись[Измерение.Имя] = ЗаписьНабора[Измерение.Имя];
			КонецЦикла; 
			Для каждого Ресурс Из Набор.Метаданные().Ресурсы Цикл
				НоваяЗапись[Ресурс.Имя] = ЗаписьНабора[Ресурс.Имя];
			КонецЦикла; 
			Для каждого Реквизит Из Набор.Метаданные().Реквизиты Цикл
				НоваяЗапись[Реквизит.Имя] = ЗаписьНабора[Реквизит.Имя];
			КонецЦикла; 
		
		КонецЦикла; 
		
	КонецЦикла; 
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	Если Ссылка <> Неопределено И Ссылка.ПометкаУдаления <> ПометкаУдаления Тогда
		УстановитьАктивностьДвижений(НЕ ПометкаУдаления);
	ИначеЕсли ПометкаУдаления Тогда
		//запись помеченного на удаление документа с активными записями
		УстановитьАктивностьДвижений(Ложь);		
	КонецЕсли;

КонецПроцедуры


