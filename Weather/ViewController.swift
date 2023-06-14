//
//  ViewController.swift
//  Weather
//
//  Created by Petro Golishevskiy on 10.05.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    private let api                     = WeatherAPI()
    private let gradient                = GradientManager()
//    private let weatherForCityViewModel = WeatherViewModel()
    private let forecastViewModel       = ForecastWeatherViewModel()
    private let currentWeatherViewModel = WeatherLocationViewModel()
    private let locationManager         = LocationManager()
    private let dataManager             = DateManager()
    
    // MARK: - Outlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestLocation()
        
        gradient.makeGradient(view: self.view)
        forecastViewModel.getForecastWeatherForCity()
        updateUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        guard let weather       = currentWeatherViewModel.weather else { return }
        cityNameLabel.text      = weather.name
        weatherLabel.text       = weather.weather.first?.description.capitalized
        temperatureLabel.text   = Int(weather.main.temp).description + "°"
        datelabel.text          = DateManager().getDate()
        guard let icon          = weather.weather.first?.icon else { return }
        weatherImageView.image  = ImageManager.getImage(for: icon)
        sunriseLabel.text       = dataManager.formatTimeToHH_MM(timestamp: Double(weather.sys.sunrise))
        sunsetLabel.text        = dataManager.formatTimeToHH_MM(timestamp: Double(weather.sys.sunset))
    }
    
    private func updateUI() {
        forecastViewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
//        weatherForCityViewModel.onUpdate = { [weak self] in
//            DispatchQueue.main.async {
//                self?.setupUI()
//            }
//        }
        
        currentWeatherViewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.setupUI()
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastViewModel.listForecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ForecastTableViewCell
        let forecast = forecastViewModel.listForecasts[indexPath.row]
        
        cell.setup(date: forecast.date,
                   icon: forecast.icon,
                   maxTemp: forecast.tempDay.description,
                   minTemp: forecast.tempNight.description)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: LocationManagerDelegate {
    func didUpdateLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        // Ваш код для обробки отриманої локації
        currentWeatherViewModel.getWeatherForLocation(lon: longitude, lat: latitude)
    }
    
    func didFailWithError(error: Error) {
        // Обробка помилки локації
    }
}


