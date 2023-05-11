//
//  String+AsURL.swift
//  Weather
//
//  Created by Petro Golishevskiy on 11.05.2023.
//

import Foundation

extension String {
    func asURL() -> URL? {
        return URL(string: self)
    }
}
