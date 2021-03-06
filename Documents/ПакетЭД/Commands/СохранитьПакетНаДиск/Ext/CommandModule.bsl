﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПрисоединенныйФайлПакетаЭД = ПолучитьДанныеПрисоединенногоФайлаПакетаНаСервере(ПараметрКоманды);
	
	ДанныеФайла = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьДанныеФайла(ПрисоединенныйФайлПакетаЭД,
		ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор);
	
	ДанныеФайлаДляСохранения = Новый Структура;
	ДанныеФайлаДляСохранения.Вставить("Расширение", ДанныеФайла.Расширение);
	ДанныеФайлаДляСохранения.Вставить("ПолноеНаименование", ДанныеФайла.Наименование);
	ДанныеФайлаДляСохранения.Вставить("АдресХранилища", ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
	
	ЭлектронныеДокументыКлиент.СохранитьКак(ДанныеФайлаДляСохранения);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеПрисоединенногоФайлаПакетаНаСервере(ПакетЭД)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЭДПрисоединенныеФайлы.Ссылка
	|ИЗ
	|	Справочник.ЭДПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
	|ГДЕ
	|	ЭДПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла";
	
	Запрос.УстановитьПараметр("ВладелецФайла", ПакетЭД);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	РезультатЗапроса.Следующий();
	
	Возврат РезультатЗапроса.Ссылка;
	
КонецФункции
