//
//  WeatherLocationViewModel.swift
//  Weather
//
//  Created by Petro Golishevskiy on 13.06.2023.
//

import Foundation
import CoreLocation

class WeatherLocationViewModel {
    
    // MARK: - Property
    private let api = WeatherAPI.shared
    private let dateManager = DateManager()
    var onUpdate: (() -> Void)?
    var weather: CurrentWeather? {
        didSet {
            onUpdate?()
        }
    }
    
    func getWeatherForLocation(lon: CLLocationDegrees, lat: CLLocationDegrees) {
        guard let url = "https://api.openweathermap.org/data/2.5/weather".asURL() else {
            print("❌ function \(#function) can't make url")
            return
        }
        api.performRequest(url: url,
                           queryParams: ["lon"  : lon,
                                         "lat"  : lat,
                                         "appid": "1c68f23403f917358bfdf46f21f13047",
                                         "units": "metric",
                                         "lang" : "uk"],
                           responseType: CurrentWeather.self) { res, err in
            if err != nil {
                print(err?.localizedDescription)
                print("❌ function \(#function)")
            } else  {
                self.weather = res
            }
        }
    }
}
