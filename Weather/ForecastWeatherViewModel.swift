//
//  ForecastWeatherViewModel.swift
//  Weather
//
//  Created by Petro Golishevskiy on 11.05.2023.
//

import Foundation
import CoreLocation

class ForecastWeatherViewModel {
    
    // MARK: - Property
    private let api = WeatherAPI.shared
    private let dateManager = DateManager()
    var onUpdate: (() -> Void)?
    var listForecasts: [Forecast4Days] = [Forecast4Days]() {
        didSet {
            onUpdate?()
        }
    }
    
    // MARK: - Functions
    func getForecastWeatherForCity(lon: CLLocationDegrees, lat: CLLocationDegrees) {
        guard let url = "https://api.openweathermap.org/data/2.5/forecast".asURL() else {
            print("❌ function \(#function) can't make url")
            return
        }
        api.performRequest(url: url,
                           queryParams: ["lon"  : lon,
                                         "lat"  : lat,
                                         "appid": "1c68f23403f917358bfdf46f21f13047",
                                         "units": "metric",
                                         "lang" : "uk"],
                           responseType: ForecastWeather.self) { res, err in
            guard let list = res?.list else { print("✏️The list is nil"); return}
            self.listForecasts = self.prepareData(array:self.createTwoArrays(list: list))
        }
    }
    
    private func createTwoArrays(list: [List]) -> [List] {
        var resList = [List]()
        
        for item in list {
            if item.dtTxt.contains("12:00:00") || item.dtTxt.contains("00:00:00") {
                if item.dtTxt.contains(dateManager.getCurrentDate()) {
                    continue
                }
                resList.append(item)
            }
        }
        return resList
    }
    
    private func prepareData(array: [List]) -> [Forecast4Days] {
        var forecastArray: [Forecast4Days] = []
        
        for i in stride(from: 0, to: array.count, by: 2) {
            let element1 = array[i]
            
            // Перевіряємо, чи індекс i+1 знаходиться в межах масиву
            if i+1 < array.count {
                let element2 = array[i+1]
                let forecast = createForecast(pair: [element1, element2])
                forecastArray.append(forecast)
            }
        }
        
        return forecastArray
    }
    
    private func createForecast(pair: [List]) -> Forecast4Days {
        var date: String = ""
        var icon: String = ""
        var tempNight: Int = 0
        var tempDay: Int = 0
        
        for item in pair {
            if item.sys.pod.rawValue == "d" {
                date = dateManager.formatDate(timestamp: TimeInterval(item.dt))
                icon = item.weather.first!.icon
                tempDay = Int(item.main.tempMax)
            }
            
            if item.sys.pod.rawValue == "n" {
                tempNight = Int(item.main.tempMax)
            }
        }
        return Forecast4Days(date: date, icon: icon, tempNight: tempNight, tempDay: tempDay)
    }
}


struct Forecast4Days {
    let date: String
    let icon: String
    let tempNight: Int
    let tempDay: Int
}
