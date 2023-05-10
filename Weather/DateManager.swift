//
//  DateManager.swift
//  Weather
//
//  Created by Petro Golishevskiy on 10.05.2023.
//

import Foundation


struct DateManager {
    
    func getDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        return dateFormatter.string(from: currentDate)
    }
}
