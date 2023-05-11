//
//  ForecastWeatherViewModel.swift
//  Weather
//
//  Created by Petro Golishevskiy on 11.05.2023.
//

import Foundation


class ForecastWeatherViewModel {
    
    // MARK: - Property
    var api = WeatherAPI.shared
    var onUpdate: (() -> Void)?
    var listForecasts: [List]? {
        didSet {
            onUpdate?()
        }
    }
    
    // MARK: - Functions
    func getForecastWeatherForCity() {
        guard let url = "https://api.openweathermap.org/data/2.5/forecast".asURL() else {
            print("❌ function \(#function) can't make url")
            return
        }
        api.performRequest(url: url,
                           queryParams: ["q"    : "Kyiv",
                                         "appid": "1c68f23403f917358bfdf46f21f13047",
                                         "units": "metric",
                                         "lang" : "uk"],
                           responseType: ForecastWeather.self) { res, err in
            guard let list = res?.list else { print("✏️The list is nil"); return}
            self.listForecasts = list
        }
    }
}
