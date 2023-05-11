//
//  ViewController.swift
//  Weather
//
//  Created by Petro Golishevskiy on 10.05.2023.
//

import UIKit

class ViewController: UIViewController {
    
    
    // MARK: - Properties
    private let api = WeatherAPI()
    private let weatherForCityViewModel = WeatherViewModel()
    private let forecastViewModel = ForecastWeatherViewModel()

    
    private lazy var list: [List] = {
        guard let list = forecastViewModel.listForecasts else { return [List]() }
        return list
    }()
    
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
        
        GradientManager.applyGradient(view: self.view, gradientType: .blueToYellow)
        
        weatherForCityViewModel.getWeatherForCityToDay()
        forecastViewModel.getForecastWeatherForCity()
        
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
    }
    
    private func setupUI() {
        guard let weather = weatherForCityViewModel.cityWeather else { return }
        cityNameLabel.text      = weather.name
        weatherLabel.text       = weather.weather.first?.main
        temperatureLabel.text   = Int(weather.main.temp).description + "°"
        datelabel.text          = DateManager().getDate()
        guard let icon          = weather.weather.first?.icon else { return }
        weatherImageView.image  = ImageManager.getImage(for: icon)
        //setupBackground()
    }
    
//    private func setupBackground() {
//        if listForecast[0].sys.pod.rawValue == "n" {
//            GradientManager.applyGradient(view: self.view, gradientType: .purpleToPink)
//        } else {
//            GradientManager.applyGradient(view: self.view, gradientType: .blueToYellow)
//        }
//    }
}


// MARK: - Extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = forecastViewModel.listForecasts else { return 0 }
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ForecastTableViewCell
        guard let list = forecastViewModel.listForecasts else { return UITableViewCell() }
        guard let icon = list[indexPath.row].weather.first?.icon else { print("✏️ icon is nil"); return UITableViewCell() }
        
        cell.setup(date: DateManager().formatDate(timestamp: TimeInterval(list[indexPath.row].dt)),
                   icon: icon,
                   maxTemp: Int(list[indexPath.row].main.tempMax).description,
                   minTemp: Int(list[indexPath.row].main.tempMax).description)
        return cell
    }
}


