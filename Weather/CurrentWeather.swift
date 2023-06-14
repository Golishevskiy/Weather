//
//  CurrentWeather.swift
//  Weather
//
//  Created by Petro Golishevskiy on 12.06.2023.
//

import Foundation

// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    let coord: Coordination
    let weather: [WeatherForLocation]
    let base: String
    let main: MainInfo
    let visibility: Int
    let dt: Int
    let sys: SysInfo
    let timezone, id: Int
    let name: String
    let cod: Int
}


// MARK: - Coord
struct Coordination: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct MainInfo: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct SysInfo: Codable {
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct WeatherForLocation: Codable {
    let id: Int
    let main, description, icon: String
}


