//
//  ViewController.swift
//  Weather
//
//  Created by Petro Golishevskiy on 10.05.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let api = WeatherAPI()
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GradientManager.applyGradient(view: self.view, gradientType: .blueToYellow)
        
        api.performRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/weather")!,
                           queryParams: ["q"    : "Kyiv",
                                         "appid": "1c68f23403f917358bfdf46f21f13047",
                                         "units": "metric"],
                           responseType: CityWeather.self) { result, err in
            if let error = err {
                print(error)
            }
            
            if let result = result {
                DispatchQueue.main.async {
                    self.setupUI(result: result)
                    
                }
            }
        }
    }
    
    private func setupUI(result: CityWeather) {
        cityNameLabel.text      = result.name
        weatherLabel.text       = result.weather.first?.main
        guard let icon          = result.weather.first?.icon else { return }
        weatherImageView.image  = ImageManager.getImage(for: icon)
        temperatureLabel.text   = Int(result.main.temp).description + "°"
        datelabel.text          = DateManager().getDate()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "example"
        return cell
    }
    
    
}


