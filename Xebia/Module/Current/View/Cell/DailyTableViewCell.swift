//
//  DailyTableViewCell.swift
//  Weather
//
//  Created by Muhammad Farooq on 13/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temperatureMaxLabel: UILabel!
    @IBOutlet weak var temperatureMinLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(w: ForecastWeather) {
        dayLabel.text = w.date.dateFromMilliseconds().dayWord()
        
        var image = Constants.WEATHER_ICON
        if let weather = w.elements.first {
            image = weather.icon
        }
        
        icon.image = UIImage(named: image)
        temperatureMaxLabel.text =  "\(Int(w.mainValue.tempMax))°"
        temperatureMinLabel.text =  "\(Int(w.mainValue.tempMin))°"
    }
    
}
