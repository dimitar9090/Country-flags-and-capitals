//
//  CapitalData.swift
//  Country flags and capitals
//
//  Created by Dimitar Angelov on 9.05.24.
//

import Foundation

let countriesAndCapitals: [String: String] = [
    "САЩ": "Вашингтон",
    "България": "София",
    "Гърция": "Атина",
    "Турция": "Анкара",
    "Румъния": "Букурещ",
    "Северна Македония": "Скопие",
    "Сърбия": "Белград",
    "Албания": "Тирана",
    "Хърватия": "Заграб",
    "Унгария": "Будапеща",
    "Черна Гора": "Подгорица",
    "Австрия": "Виена",
    "Словения": "Любляна",
    "Словакия": "Братислава",
    "Оландски острови": "Мариехатън",
    "Андора": "Андора ла Вела",
    "Беларус": "Минск",
    "Белгия": "Брюксел",
    "Босна и Херцеговина": "Съраево",
    "Чехия": "Прага",
    "Дания": "Копенхаген",
    "Естония": "Талин",
    "Фарьорски острови": "Торсхавн",
    "Финландия": "Хелзинки",
    "Франция": "Париж",
    "Германия": "Берлин",
    "Гибралтар": "Гибралтар",
    "Гернси": "Сейнт Питър Порт",
    "Исландия": "Рейкявик",
    "Ирландия": "Дъблин",
    "Остров Ман": "Дъглас",
    "Италия": "Рим",
    "Джърси": "Сейнт Хелиър",
    "Косово": "Прищина",
    "Латвия": "Рига",
    "Лихтенщайн": "Вадуц",
    "Литва": "Вилнюс",
    "Люксембург": "Люксенбург",
    "Малта": "Валета",
    "Молдова": "Кишинев",
    "Монако": "Монако",
    "Нидерландия": "Амстердам",
    "Норвегия": "Осло",
    "Полша": "Варшава",
    "Португалия": "Лисабон",
    "Русия": "Москва",
    "Сан Марино": "Сан Марино",
    "Испания": "Мадрид",
    "Швеция": "Стокхолм",
    "Швейцария": "Берн",
    "Украйна": "Киев",
    "Великобритания": "Лондон",
    "Ватикана": "Ватикана",
    "Антигуа и Барбуда": "Сейнт Джонс",
    "Бахамски острови": "Насау",
    "Барбадос": "Бриджтаун",
    "Белиз": "Белиз",
    "Канада": "Отава",
    "Коста Рика": "Сан Хосе",
    "Куба": "Хавана",
    "Доминика": "Розо",
    "Доминиканска република": "Санто Доминго",
    "Салвадор": "Сан Салвадор",
    "Гренада": "Сейнт Джорджес",
    "Гватемала": "Гватемала",
    "Хаити": "Порт О Пренс",
    "Хондурас": "Тегусигалпа",
    "Ямайка": "Кингстън",
    "Мексико": "Мексико Сити",
    "Никарагуа": "Манагуа",
    "Панама": "Панама",
    "Сейнт Китс и Невис": "Басетер",
    "Сейнт Лусия": "Кастрийс",
    "Сейнт Винсънт и Гренадини": "Кингстаун",
    "Тринидад и Тобаго": "Порт оф Спейн",
    "Аржентина": "Буенос Айрес",
    "Боливия": "Сукре",
    "Бразилия": "Бразилия",
    "Чили": "Сантяго",
    "Колумбия": "Богота",
    "Еквадор": "Кито",
    "Гвиана": "Джорджтаун",
    "Парагвай": "Асунсион",
    "Перу": "Лима",
    "Суринам": "Парамарибо",
    "Уругвай": "Монтевидео",
    "Венецуела": "Каракас", 
    "Афганистан": "Кабул",
    "Армения": "Ереван",
    "Азербайджан": "Баку",
    "Бахрейн": "Манама",
    "Бангладеш": "Дака",
    "Бутан": "Тхимпху",
    "Бруней": "Бандар Сери Бегаван",
    "Камбоджа": "Пном Пен",
    "Китай": "Пекин",
    "Кипър": "Никозия",
    "Грузия": "Тбилиси",
    "Индия": "Ню Делхи",
    "Индонезия": "Джакарта",
    "Иран": "Техеран",
    "Ирак": "Багдад",
    "Израел": "Йерусалим",
    "Япония": "Токио",
    "Йордания": "Аман",
    "Казахстан": "Нур-Султан (Астана)",
    "Кувейт": "Кувейт",
    "Киргизстан": "Бишкек",
    "Лаос": "Виентиан",
    "Ливан": "Бейрут",
    "Малайзия": "Куала Лумпур",
    "Малдиви": "Мале",
    "Монголия": "Улан Батор",
    "Мианмар": "Нейпидо",
    "Непал": "Катманду",
    "Северна Корея": "Пхеньон",
    "Оман": "Мускат",
    "Пакистан": "Исламабад",
    "Палестина": "Източен Йерусалим",
    "Филипини": "Манила",
    "Катар": "Доха",
    "Саудитска Арабия": "Рияд",
    "Сингапур": "Сингапур",
    "Южна Корея": "Сеул",
    "Шри Ланка": "Шри Джаяварденепура Коте",
    "Сирия": "Дамаск",
    "Тайван": "Тайбей",
    "Таджикистан": "Душанбе",
    "Тайланд": "Бангкок",
    "Туркменистан": "Ашгабат",
    "Обединени арабски емирства": "Абу Даби",
    "Узбекистан": "Ташкент",
    "Виетнам": "Ханой",
    "Йемен": "Сана"]
