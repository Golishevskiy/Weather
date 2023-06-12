//
//  ViewController.swift
//  Weather
//
//  Created by Petro Golishevskiy on 10.05.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - Properties
    private let api = WeatherAPI()
    private let gradient = GradientManager()
    private let weatherForCityViewModel = WeatherViewModel()
    private let forecastViewModel = ForecastWeatherViewModel()
    private let currentWeatherViewModel = WeatherLocationViewModel()
    private let locationManager = CLLocationManager()
    
    // MARK: - Outlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        gradient.makeGradient(view: self.view)
        //weatherForCityViewModel.getWeatherForCityToDay()
        forecastViewModel.getForecastWeatherForCity()
        updateUI()
    }
    
    // MARK: - Location functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            print("Latitude: \(latitude), Longitude: \(longitude)")
            currentWeatherViewModel.getWeatherWithCurrentLocation(lon: longitude, lat: latitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
            // Виконати додаткові дії для обробки відмови в доступі до локації
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        // Виконати додаткові дії для обробки помилки
    }
    
    // MARK: - Setup UI
//    private func setupUI() {
//        guard let weather       = weatherForCityViewModel.cityWeather else { return }
//        cityNameLabel.text      = weather.name
//        weatherLabel.text       = weather.weather.first?.description.capitalized
//        temperatureLabel.text   = Int(weather.main.temp).description + "°"
//        datelabel.text          = DateManager().getDate()
//        guard let icon          = weather.weather.first?.icon else { return }
//        weatherImageView.image  = ImageManager.getImage(for: icon)
//        //setupBackground()
//    }
    
    
    private func setupUI() {
        guard let weather       = currentWeatherViewModel.weather else { return }
        cityNameLabel.text      = weather.name
        weatherLabel.text       = weather.weather.first?.description.capitalized
        temperatureLabel.text   = Int(weather.main.temp).description + "°"
        datelabel.text          = DateManager().getDate()
        guard let icon          = weather.weather.first?.icon else { return }
        weatherImageView.image  = ImageManager.getImage(for: icon)
        //setupBackground()
    }
    
    private func updateUI() {
        forecastViewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        weatherForCityViewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.setupUI()
            }
        }
        
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
        //        guard let icon = forecast.icon else { print("✏️ icon is nil"); return UITableViewCell() }
        
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

extension ViewController: CLLocationManagerDelegate {
    
}


