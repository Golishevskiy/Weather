//
//  ForecastWeather.swift
//  Weather
//
//  Created by Petro Golishevskiy on 11.05.2023.
//

import Foundation

// MARK: - ForecastWeather
struct ForecastWeather: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: CityInfo
}

// MARK: - City
struct CityInfo: Codable {
    let id: Int
    let name: String
    let coord: Coordinates
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let lat, lon: Double
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let main: MainClass
    let weather: [Weather30Days]
    let clouds: Clouds30Days
    let wind: Wind30Days
    let visibility: Int
    let pop: Double
    let sys: System
    let dtTxt: String
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain
    }
}

// MARK: - Clouds
struct Clouds30Days: Codable {
    let all: Int
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct System: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct Weather30Days: Codable {
    let id: Int
    let main: MainEnum
    let description: Description
    let icon: String
}

enum Description: String, Codable {
    case кількаХмар = "кілька хмар"
    case легкийДощ = "легкий дощ"
    case рваніХмари = "рвані хмари"
    case уривчастіХмари = "уривчасті хмари"
    case хмарно = "хмарно"
    case чистеНебо = "чисте небо"
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Wind
struct Wind30Days: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
