﻿
Перем мРегламентноеЗадание Экспорт;


///////////////////////////////////////////////////////////
// Методы объектов										//
/////////////////////////////////////////////////////////


Процедура ПриКопировании(ОбъектКопирования)
	
	мРегламентноеЗадание = Неопределено;
	РегламентноеЗадание = "";
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	УстановитьЗначенияПеременныхРегламентныхНастроек();
	
	Если мРегламентноеЗадание <> Неопределено Тогда
		мРегламентноеЗадание.Удалить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ВыгружатьНаСайт Тогда
		
		Если Не ЗначениеЗаполнено(АдресСайта) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Не указан WEB - сайт для обмена данными!", Отказ);
		КонецЕсли;
		
	Иначе
		
		Если Не ЗначениеЗаполнено(КаталогВыгрузки) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Не указан каталог для обмена данными!", Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьЗначенияПеременныхРегламентныхНастроек();
	
	Если ПометкаУдаления
		ИЛИ НЕ ИспользоватьРегламентныеЗадания Тогда
		
		Если мРегламентноеЗадание <> Неопределено Тогда
			мРегламентноеЗадание.Использование = Ложь;
		КонецЕсли;
		
	Иначе
		
		// если оба выключены регл задания - то включаем основное регл задание
		Если мРегламентноеЗадание = Неопределено Тогда
			
			ОбщегоНазначения.СообщитьОбОшибке("Не выбрано регламентное задание для настройки обмена.", Отказ);
			
		КонецЕсли;
		
		Если мРегламентноеЗадание <> Неопределено Тогда
			
			мРегламентноеЗадание.Использование = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если мРегламентноеЗадание <> Неопределено 
		И Не ПустаяСтрока(мРегламентноеЗадание.Ключ) Тогда
		
		КлючРегламентногоЗадания = мРегламентноеЗадание.Ключ;
		
	Иначе
		
		КлючРегламентногоЗадания = Строка(Новый УникальныйИдентификатор);
		
	КонецЕсли;
	
	УстановитьПараметрыРегламентногоЗадания(РегламентноеЗадание, мРегламентноеЗадание, КлючРегламентногоЗадания);
	
КонецПроцедуры


//Работа с каталогами

Процедура СохранитьТаблицуКаталогов(СохраненнаяТаблицаКаталогов, ТаблицаКаталогов) Экспорт
	СохраненнаяТаблицаКаталогов = Новый ХранилищеЗначения(ТаблицаКаталогов);
КонецПроцедуры	

Процедура ЗаполнитьДеревоГрупп(ДеревоГрупп, ФормаДеревоГрупп)
	
	Если ДеревоГрупп.Колонки.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Колонка Из ФормаДеревоГрупп.Колонки Цикл
		
		ДеревоГрупп.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения, Колонка.Заголовок, Колонка.Ширина);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура НастроитьДеревоГрупп(ДанныеКаталога, ФормаВладелец) Экспорт

	ДеревоГрупп = ДанныеКаталога.ДеревоГрупп;
	
	Форма = ПланыОбмена.Б_ОбменССайтом.ПолучитьФорму("НастройкаДереваГрупп", ФормаВладелец);
	Форма.Заголовок = "Настройка дерева групп для каталога """ + ДанныеКаталога.Каталог + """";
	Форма.ЗакрыватьПриЗакрытииВладельца = Истина;
	Форма.СписокГрупп = ДанныеКаталога.Группы;
	ЗаполнитьДеревоГрупп(ДеревоГрупп, Форма.ДеревоГрупп);
	Форма.ДеревоГрупп = ДеревоГрупп;
	Форма.ОткрытьМодально();

КонецПроцедуры

Процедура ДеревоГруппПроверитьСоответствиеНоменклатуры(СтрокаДанных) Экспорт
	
	СписокГрупп = СтрокаДанных.Группы;
	ДеревоГрупп = СтрокаДанных.ДеревоГрупп;
	
	Если ДеревоГрупп.Строки.Количество() = 0
		ИЛИ СписокГрупп.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СоответствиеНесоответствующейНоменклатуры = 
		ДеревоГруппПолучитьНесоответствияРекурсивно(СписокГрупп, ДеревоГрупп.Строки);
	
	Если СоответствиеНесоответствующейНоменклатуры.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = 
		"В дереве групп найдена номенклатура, не соответствующая указанному списку групп.
		|Очистить такую номенклатуру в дереве групп?";
	
	#Если Клиент Тогда
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
		
		Если НЕ Ответ = КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
	#КонецЕсли
	
	Для Каждого ЭлементСоответствия Из СоответствиеНесоответствующейНоменклатуры Цикл
		
		СтрокаДерева = ЭлементСоответствия.Ключ;
		МассивНоменклатуры = ЭлементСоответствия.Значение;
		
		МассивЭлементовУдалить = Новый Массив;
		
		Для Каждого ЭлементСписка Из СтрокаДерева.Номенклатура Цикл
			
			Если НЕ МассивНоменклатуры.Найти(ЭлементСписка.Значение) = НеОпределено Тогда
				МассивЭлементовУдалить.Добавить(ЭлементСписка);
			КонецЕсли;
			
		КонецЦикла;
		
		Для Каждого ЭлементСписка Из МассивЭлементовУдалить Цикл
			
			СтрокаДерева.Номенклатура.Удалить(ЭлементСписка);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьСтрокуТаблицыКаталогов(ДанныеСтроки, ОформлениеЯчейки) Экспорт
	
	ГруппыВыбраны = Ложь;
	
	//
	
	Если НЕ ТипЗнч(ДанныеСтроки.Группы) = Тип("СписокЗначений") Тогда
		ДанныеСтроки.Группы = Новый СписокЗначений;
	КонецЕсли;
	
	СписокГрупп = ДанныеСтроки.Группы;
	
	// удалить не группы номенклатуры
	МассивУдалить = Новый Массив;
	Для Каждого ЭлементСЗ Из СписокГрупп Цикл
		ТекГруппа = ЭлементСЗ.Значение;
		Если НЕ ЗначениеЗаполнено(ТекГруппа)
			ИЛИ ((НЕ ТекГруппа.ЭтоГруппа) И (ТипЗнч(ТекГруппа) = Тип("СправочникСсылка.Номенклатура"))) Тогда
			МассивУдалить.Добавить(ЭлементСЗ);
		КонецЕсли;
	КонецЦикла;
	Для Каждого ЭлементМУ Из МассивУдалить Цикл
		СписокГрупп.Удалить(ЭлементМУ);
	КонецЦикла;
	// удалить подчиненные элементы
	МассивУдалить = Новый Массив;
	Для Каждого ЭлементСЗ Из СписокГрупп Цикл
		ТекГруппа = ЭлементСЗ.Значение;
		Для Каждого ЭлементСЗВлож Из СписокГрупп Цикл
			Если ТекГруппа.ПринадлежитЭлементу(ЭлементСЗВлож.Значение) Тогда
				МассивУдалить.Добавить(ЭлементСЗ);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	Для Каждого ЭлементМУ Из МассивУдалить Цикл
		СписокГрупп.Удалить(ЭлементМУ);
	КонецЦикла;
	Для Каждого ЭлементСЗ Из СписокГрупп Цикл
		Если ЗначениеЗаполнено(ЭлементСЗ.Значение) Тогда
			ГруппыВыбраны = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	//
	
	Если НЕ ЗначениеЗаполнено(ДанныеСтроки.ИдКаталога) Тогда
		ДанныеСтроки.ИдКаталога = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
	//
	
	Если ГруппыВыбраны Тогда
		ОформлениеЯчейки.Шрифт = Новый Шрифт;
	Иначе	
		ОформлениеЯчейки.Текст = "<все>";
		ОформлениеЯчейки.Шрифт = Новый Шрифт(,,,Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьТаблицуКаталогов(СохраненнаяТаблицаКаталогов, ТаблицаКаталогов) Экспорт
	
	СохрТаблицаКаталогов = СохраненнаяТаблицаКаталогов.Получить();
	Если ТипЗнч(СохрТаблицаКаталогов) = Тип("ТаблицаЗначений") Тогда
		Если ТаблицаКаталогов.Колонки.Количество() = 0 Тогда
			ТаблицаКаталогов = СохрТаблицаКаталогов.Скопировать();
		Иначе
			ТаблицаКаталогов.Очистить();
			Для Каждого СтрокаСТК Из СохрТаблицаКаталогов Цикл
				НовСтрокаТК = ТаблицаКаталогов.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтрокаТК, СтрокаСТК);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция ДеревоГруппПолучитьНесоответствияРекурсивно(Знач СписокГрупп, Знач СтрокиДереваГрупп)
	
	СоответствиеНесоответствий = Новый Соответствие;
	
	Для Каждого СтрокаДерева Из СтрокиДереваГрупп Цикл
		
		МассивНесоответствий = Новый Массив;
		
		Для Каждого ЭлементСН Из СтрокаДерева.Номенклатура Цикл
			
			Номенклатура = ЭлементСН.Значение;
			
			Для Каждого ЭлементСГ Из СписокГрупп Цикл
				
				Группа = ЭлементСГ.Значение;
				
				Если ТипЗнч(Группа) = Тип("СправочникСсылка.Номенклатура") Тогда
				
					Если НЕ (Номенклатура = Группа
							ИЛИ Номенклатура.ПринадлежитЭлементу(Группа)) Тогда
						МассивНесоответствий.Добавить(Номенклатура);
						Прервать;
					КонецЕсли;
					
				Иначе
					
					Если (НЕ Номенклатура.ЭтоГруппа)
						И (НЕ Номенклатура.ЦеноваяГруппа = Группа) Тогда
						МассивНесоответствий.Добавить(Номенклатура);
						Прервать;
					КонецЕсли;
				
				КонецЕсли;
					
			КонецЦикла;
			
		КонецЦикла;
		
		Если МассивНесоответствий.Количество() > 0 Тогда
			СоответствиеНесоответствий.Вставить(СтрокаДерева, МассивНесоответствий);
		КонецЕсли;
			
		СоответствиеНесоответствийСтроки = ДеревоГруппПолучитьНесоответствияРекурсивно(СписокГрупп, СтрокаДерева.Строки);
		
		Для Каждого ЭлементСоответствия Из СоответствиеНесоответствийСтроки Цикл
			
			СоответствиеНесоответствий.Вставить(ЭлементСоответствия.Ключ, ЭлементСоответствия.Значение);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат СоответствиеНесоответствий;
	
КонецФункции

Функция ГруппыВыбраны(ТаблицаКаталогов) Экспорт
	
	ГруппыВыбраны = Ложь;
	Для Каждого СтрокаТК Из ТаблицаКаталогов Цикл
		Если ТипЗнч(СтрокаТК.Группы) = Тип("СписокЗначений") Тогда
			Для Каждого Группа Из СтрокаТК.Группы Цикл
				Если ЗначениеЗаполнено(Группа.Значение) Тогда
					ГруппыВыбраны = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ГруппыВыбраны;
	
КонецФункции

Функция СоздатьТаблицуКаталогов() Экспорт
	
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("Строка"));
	ОписаниеТиповС = Новый ОписаниеТипов(Массив); 

	Массив = Новый Массив;
	Массив.Добавить(Тип("ДеревоЗначений"));
	ОписаниеТиповДЗ = Новый ОписаниеТипов(Массив); 

	
	
	ТаблицаКаталогов = Новый ТаблицаЗначений;
	ТаблицаКаталогов.Колонки.Добавить("Каталог"		, ОписаниеТиповС);
	ТаблицаКаталогов.Колонки.Добавить("Группы");
	ТаблицаКаталогов.Колонки.Добавить("ДеревоГрупп"	, ОписаниеТиповДЗ);
	ТаблицаКаталогов.Колонки.Добавить("ИдКаталога"	, ОписаниеТиповС);
	
	НовСтрокаТК = ТаблицаКаталогов.Добавить();
	НовСтрокаТК.Каталог = "Основной каталог товаров";
	НовСтрокаТК.Группы = Новый СписокЗначений;
	НовСтрокаТК.ДеревоГрупп = Новый ДеревоЗначений;
	НовСтрокаТК.ИдКаталога = Строка(Новый УникальныйИдентификатор);
	
	Возврат ТаблицаКаталогов;
КонецФункции

///////////////////////////////////////////////////////////
// Процедуры и функции по работе регламентными задачами //
/////////////////////////////////////////////////////////

Процедура УстановитьПараметрыРегламентногоЗадания(РеквизитЗадания, ПараметрЗадания, КлючРегламентногоЗадания, Постфикс = "")
	
	Если ПараметрЗадания = Неопределено Тогда
		
		РеквизитЗадания = "";
		
	Иначе
		
		РеквизитЗадания = Строка(ПараметрЗадания.УникальныйИдентификатор);
		
		ПараметрЗадания.Наименование = Наименование + Постфикс;
		// генерируем уникальный ключ, что бы в один момент времени 2 регламентных задания не выполнялись
		Если ПустаяСтрока(ПараметрЗадания.Ключ) Тогда
			ПараметрЗадания.Ключ = КлючРегламентногоЗадания;
		КонецЕсли;
		
		Массив = Новый Массив();
		Массив.Добавить(Код);
		
		ПараметрЗадания.Параметры = Массив;
		ПараметрЗадания.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьРежимРегламетныхЗадач() Экспорт
	
	УстановитьЗначенияПеременныхРегламентныхНастроек();
	
	Если мРегламентноеЗадание = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если мРегламентноеЗадание.Использование = Истина Тогда
		
		Возврат;
		
	КонецЕсли;
	
	мРегламентноеЗадание.Использование = Ложь;
	
	мРегламентноеЗадание.Записать();
	
КонецПроцедуры

Процедура УстановитьЗначенияПеременныхРегламентныхНастроек() Экспорт
	
	Если мРегламентноеЗадание = Неопределено Тогда
		
		мРегламентноеЗадание = ПолучитьОбъектРегламентногоЗадания();
		
	КонецЕсли;
	
КонецПроцедуры

Функция НайтиРеглЗаданиеПоПараметру(УникальныйНомерЗадания)
	
	Попытка
		
		Если НЕ ПустаяСтрока(УникальныйНомерЗадания) Тогда
			
			УникальныйИдентификаторЗадания = Новый УникальныйИдентификатор(УникальныйНомерЗадания);
			ТекущееРегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(УникальныйИдентификаторЗадания);
			
		Иначе
			
			ТекущееРегламентноеЗадание = Неопределено;
			
		КонецЕсли;
		
	Исключение
		
		ТекущееРегламентноеЗадание = Неопределено;
		
	КонецПопытки;
	
	Возврат ТекущееРегламентноеЗадание;
	
КонецФункции

Функция НайтиРегламентноеЗаданиеПоНастройке() Экспорт
	
	ТекущееРегламентноеЗадание = НайтиРеглЗаданиеПоПараметру(РегламентноеЗадание);
	
	Возврат ТекущееРегламентноеЗадание;
	
КонецФункции

Функция ПолучитьОбъектРегламентногоЗадания() Экспорт
	
	Задание = НайтиРегламентноеЗаданиеПоНастройке();
	
	Возврат Задание;
	
КонецФункции

