//
//  WeattherViewPresenter.swift
//  Weather
//
//  Created by Muhammad Farooq on 13/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import Foundation

public protocol WeattherView: class {
    func reloadView()
    func showErrorView(_ error: String)
    func hideErrorView()
    func activityIndicatorAnimatingView(animating: Bool)
    func updateBackgroundImageView(_ image: String)
}

class WeattherViewPresenter {
    
    private weak var view: WeattherView?
    private let client = OpenweatherAPIClient()
    var weather = WeatherViewModel()
    private var stateCurrentWeather = StateView.loading
    private var stateForecastWeather = StateView.loading
    
    var param = ""
    
    public init(view: WeattherView?) {
        self.view = view
    }
    
    func getWeather() -> WeatherViewModel {
        return weather
    }
    
    func fetchWeather() {
        
        self.view?.activityIndicatorAnimatingView(animating: true)
        self.view?.hideErrorView()
        
        client.getCurrentWeather(at: param) { [weak self] currentWeather, error in
            if let currentWeather = currentWeather {
                self?.weather.currentWeather = currentWeather
                self?.weather.todayWeather = currentWeather.getForecastWeather()
                self?.weather.currentDescription = currentWeather.description()
                self?.stateCurrentWeather = .success
            } else {
                self?.stateCurrentWeather = .failed
            }
            updateStateView()
        }

        client.getForecastWeather(at: param) { [weak self] forecastWeatherResponse, error in
            if let forecastWeatherResponse = forecastWeatherResponse {
                self?.weather.hourlyWeathers = forecastWeatherResponse.list
                self?.weather.dailyWeathers = forecastWeatherResponse.dailyList
                self?.stateForecastWeather = .success
            } else {
                self?.stateForecastWeather = .failed
            }
            updateStateView()
        }
        
        
        func updateStateView() {
            if stateCurrentWeather == .success, stateForecastWeather == .success {
                self.view?.activityIndicatorAnimatingView(animating: false)
                self.view?.reloadView()
                updateBackgroundImage()
            }
            
            if stateCurrentWeather == .failed, stateForecastWeather == .failed {
                self.view?.activityIndicatorAnimatingView(animating: false)
                self.view?.showErrorView("weather data not avaialable")
            }
        }
    }
    
    func updateBackgroundImage() {
        let today: ForecastWeather = weather.todayWeather
        var image = Constants.WEATHER_CONDITION_IMAGE
        if let weather = today.elements.first {
            image = Helper.weatherConditionImage(condition: weather.id)
        }
        self.view?.updateBackgroundImageView(image)
    }
}
