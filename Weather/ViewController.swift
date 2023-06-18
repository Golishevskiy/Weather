//
//  ViewController.swift
//  Weather
//
//  Created by Petro Golishevskiy on 10.05.2023.
//

import UIKit
import CoreLocation
import Network

class ViewController: UIViewController, CLLocationManagerDelegate, NetworkStatusObserver {
    
    // MARK: - Properties
    private let api                     = WeatherAPI()
    private let gradient                = GradientManager()
    private let forecastViewModel       = ForecastWeatherViewModel()
    private let currentWeatherViewModel = WeatherLocationViewModel()
    private let locationManager         = LocationManager()
    private let dataManager             = DateManager()
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunsetImageView: UIImageView!
    @IBOutlet weak var sunriseImageView: UIImageView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestLocation()
        NetworkManager.shared.addObserver(self)
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        gradient.makeGradient(view: self.view)
    }
    
    deinit {
        NetworkManager.shared.removeObserver(self)
    }
    
    private func bind() {
        forecastViewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        currentWeatherViewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.setupUI()
                self?.appearAllViews()
            }
        }
    }
    
    func networkStatusDidChange(_ isConnected: Bool) {
        print("internet connection did change - \(isConnected)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            if isConnected {
                
            } else {
                
            }
        }
    }
    
    // MARK: - Setup UI
    private func appearAllViews() {
        cityNameLabel.isHidden      = false
        weatherLabel.isHidden       = false
        dateLabel.isHidden          = false
        weatherImageView.isHidden   = false
        temperatureLabel.isHidden   = false
        tableView.isHidden          = false
        sunriseLabel.isHidden       = false
        sunsetLabel.isHidden        = false
        sunsetImageView.isHidden    = false
        sunriseImageView.isHidden   = false
    }
    
    private func setupUI() {
        guard let weather       = currentWeatherViewModel.weather else { print("UI can't setup"); return }
        cityNameLabel.text      = weather.name
        weatherLabel.text       = weather.weather.first?.description.capitalized
        temperatureLabel.text   = Int(weather.main.temp).description + "°"
        dateLabel.text          = DateManager().getDate()
        sunriseLabel.text       = dataManager.formatTimeToHHMM(timestamp: Double(weather.sys.sunrise))
        sunsetLabel.text        = dataManager.formatTimeToHHMM(timestamp: Double(weather.sys.sunset))
        guard let icon          = weather.weather.first?.icon else { return }
        weatherImageView.image  = ImageManager.getImage(for: icon)
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
        currentWeatherViewModel.getWeatherForLocation(lon: longitude, lat: latitude)
        forecastViewModel.getForecastWeatherForCity(lon: longitude, lat: latitude)
    }
    
    func didFailWithError(error: Error) {
        showLocationAlert()
    }
}

extension ViewController {
    func showLocationAlert() {
        let alert = UIAlertController(title: "Увага", message: "Ми не отримали вашу локацію, отже погодні дані не загружені", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alert.addAction(okAction)
        
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showNoConnectionAlert() {
        let alert = UIAlertController(title: "Немає підключення до мережі", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


