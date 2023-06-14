//
//  GradientManager.swift
//  Weather
//
//  Created by Petro Golishevskiy on 12.05.2023.
//

import Foundation
import UIKit

class GradientManager {
    
    // MARK: - Properties
    private let gradientMaker = GradientMaker()
    private let dataManager = DateManager()
    
    
    func makeGradient(view: UIView) {
        if dataManager.getCurrentHour() > 7 && dataManager.getCurrentHour() < 20 {
            self.gradientMaker.applyGradient(view: view, gradientType: .blueToYellow)
        } else {
            self.gradientMaker.applyGradient(view: view, gradientType: .purpleToPink)
        }
    }
}

