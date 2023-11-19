//
//  HourlyCollectionViewCell.swift
//  Weather
//
//  Created by Muhammad Farooq on 13/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(w: ForecastWeather) {
        hourLabel.text = w.date.dateFromMilliseconds().hour()
        humidityLabel.text =  "\(w.mainValue.humidity)%"
        
        var image = Constants.WEATHER_ICON
        if let weather = w.elements.first {
            image = weather.icon
        }
        
        icon.image = UIImage(named: image)
        temperatureLabel.text =  "\(Int(w.mainValue.temp))°"
    }
}
