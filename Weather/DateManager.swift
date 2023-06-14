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
    
    func getCurrentHour() -> Int {
        let currentTime = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentTime)
        return hour
    }
    
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    
    func formatDate(timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    func formatTimeToHH(timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let formattedTime = dateFormatter.string(from: date)
        return formattedTime
    }
    
    func formatTimeToHH_MM(timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH : MM"
        let formattedTime = dateFormatter.string(from: date)
        return formattedTime
    }
}
