//
//  ForecastTableViewCell.swift
//  Weather
//
//  Created by Petro Golishevskiy on 11.05.2023.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    func setup(date: String, icon: String, maxTemp: String, minTemp: String) {
        iconImageView.image = ImageManager.getImage(for: icon)
        dayTempLabel.text = maxTemp
        nightTempLabel.text = minTemp
        dateLabel.text = date
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
