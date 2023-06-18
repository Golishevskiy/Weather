//
//  ImageManager.swift
//  Weather
//
//  Created by Petro Golishevskiy on 10.05.2023.
//

import Foundation
import UIKit

struct ImageManager {
    static func getImage(for icon: String) -> UIImage? {
        var imageName: String
        
        switch icon {
        case "01d": imageName = "sun"
        case "02d": imageName = "cloudy+sun"
        case "03d": imageName = "cloud"
        case "04d": imageName = "doubleCloud"
        case "09d": imageName = "rainy"
        case "10d": imageName = "rain+cloud"
        case "11d": imageName = "storm"
        case "13d": imageName = "snowy"
        case "50d": imageName = "foog"
        case "04n": imageName = "cloud+moon"
        default:
            imageName = "sun"
            print("🆘 there is no image named - \(icon)")
        }
        
        return UIImage(named: imageName)
    }
}
