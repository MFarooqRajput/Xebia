//
//  WeatherTableViewCell.swift
//  Xebia
//
//  Created by Muhammad Farooq on 14/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempratureLabel: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temperatureMaxLabel: UILabel!
    @IBOutlet weak var temperatureMinLabel: UILabel!
    @IBOutlet weak var todayConditionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(w: WeatherViewModel) {
        let current: CurrentWeather = w.currentWeather
        
        cityLabel.text = current.name
        
        var result = ""
        if let weather = current.elements.first {
            result = weather.main
        }
        
        weatherLabel.text = result
        tempratureLabel.text = "\(Int(current.mainValue.temp))°"
        
        var image = Constants.WEATHER_ICON
        if let weather = current.elements.first {
            image = weather.icon
        }
        
        icon.image = UIImage(named: image)
        temperatureMaxLabel.text =  "\(Int(current.mainValue.tempMax))°"
        temperatureMinLabel.text =  "\(Int(current.mainValue.tempMin))°"
        
        todayConditionLabel.text = w.currentDescription
        
        var windDirection = "---"
        if let degree = current.wind.deg {
            windDirection = Helper.weatherDirection(degree: degree)
        }
        
        windSpeedLabel.text = "\(Int(current.wind.speed)) \(windDirection)"
    }
}
