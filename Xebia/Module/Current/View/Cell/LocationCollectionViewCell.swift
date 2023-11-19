//
//  LocationCollectionViewCell.swift
//  Weather
//
//  Created by Muhammad Farooq on 13/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempratureLabel: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temperatureMaxLabel: UILabel!
    @IBOutlet weak var temperatureMinLabel: UILabel!
    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    var hourly = [ForecastWeather]()
    
    @IBOutlet weak var dailyTableView: UITableView!
    var daily = [ForecastWeather]()
    
    @IBOutlet weak var todayConditionLabel: UILabel!
    
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var visbilityLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainContainerView.layer.cornerRadius = 8
        
        hourlyCollectionView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        dailyTableView.register(UINib(nibName: "DailyTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }

    func setupCell(w: WeatherViewModel) {
        let current: CurrentWeather = w.currentWeather
        let today: ForecastWeather = w.todayWeather
        
        //Current Header
        cityLabel.text = current.name
        
        var result = ""
        if let weather = current.elements.first {
            result = weather.main
        }
        
        weatherLabel.text = result
        tempratureLabel.text = "\(Int(current.mainValue.temp))°"
        
        //Today
        dayLabel.text = today.date.dateFromMilliseconds().dayWord()
        
        var image = Constants.WEATHER_ICON
        if let weather = today.elements.first {
            image = weather.icon
        }
        
        icon.image = UIImage(named: image)
        temperatureMaxLabel.text =  "\(Int(today.mainValue.tempMax))°"
        temperatureMinLabel.text =  "\(Int(today.mainValue.tempMin))°"
        
        //Hourly Forecast
        hourly = w.hourlyWeathers
        hourlyCollectionView.reloadData()
        
        //Daily Forecast
        daily = w.dailyWeathers
        dailyTableView.reloadData()
        
        //Detail
        todayConditionLabel.text = w.currentDescription
        
        //Current Detail
        sunRiseLabel.text = current.sys.sunrise.dateFromMilliseconds().hourMinute()
        sunSetLabel.text = current.sys.sunset.dateFromMilliseconds().hourMinute()
        
        pressureLabel.text = "\(current.mainValue.pressure) hPa"
        humidityLabel.text = "\(current.mainValue.humidity)%"
        
        
        if let v = current.visibility {
            visbilityLabel.text = "\(Float(v/1000)) Km"
        } else {
            visbilityLabel.text = "--- Km"
        }
        feelsLikeLabel.text = "\(current.mainValue.feelsLike)°"
        
        highTempLabel.text = "\(Int(current.mainValue.tempMax))°"
        lowTempLabel.text = "\(Int(current.mainValue.tempMin))°"
    }
}


// MARK: - UICollectionViewDataSource
extension LocationCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourly.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HourlyCollectionViewCell else {
            fatalError("The deque cell is not an instance of HourlyCollectionViewCell.")
        }
        
        cell.setupCell(w: hourly[indexPath.item])
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LocationCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize.init(width: 50, height:128)
    }
}

// MARK: - UITableViewDataSource
extension LocationCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daily.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? DailyTableViewCell  else {
            fatalError("The dequeued cell is not an instance of DailyTableViewCell")
        }
        
        cell.setupCell(w: daily[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LocationCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34
    }
}
    
