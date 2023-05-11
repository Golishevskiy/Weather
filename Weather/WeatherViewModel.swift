//
//  ForecastWeatherViewModel.swift
//  Weather
//
//  Created by Petro Golishevskiy on 11.05.2023.
//

import Foundation

class WeatherViewModel {
    
    // MARK: - Property
    var api = WeatherAPI.shared
    var onUpdate: (() -> Void)?
    var cityWeather: CityWeather? {
        didSet {
            onUpdate?()
        }
    }
    
    // MARK: - Functions
    func getWeatherForCityToDay() {
        guard let url = "https://api.openweathermap.org/data/2.5/weather".asURL() else {
            print("❌ function \(#function) can't make url")
            return
        }
        api.performRequest(url: url,
                           queryParams: ["q"    : "Kyiv",
                                         "appid": "1c68f23403f917358bfdf46f21f13047",
                                         "units": "metric"],
                           responseType: CityWeather.self) { [weak self] result, err in
            if let error = err {
                print(error)
            }
            
            if let result = result {
                self?.cityWeather = result
            }
        }
    }
}
