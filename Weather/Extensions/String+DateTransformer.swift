//
//  String+DateTransformer.swift
//  Weather
//
//  Created by Petro Golishevskiy on 11.05.2023.
//

import Foundation

extension String {
    
    func transformToDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        
        dateFormatter.dateFormat = "dd MMMM"
        let transformedDate = dateFormatter.string(from: date)
        
        return transformedDate
    }
}
