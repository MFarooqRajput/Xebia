//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Muhammad Farooq on 13/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import Foundation

struct WeatherViewModel {
    var stateView: StateView = StateView.loading
    var currentWeather = CurrentWeather.emptyInit()
    var todayWeather = ForecastWeather.emptyInit()
    var hourlyWeathers: [ForecastWeather] = []
    var dailyWeathers: [ForecastWeather] = []
    var currentDescription = ""
}
