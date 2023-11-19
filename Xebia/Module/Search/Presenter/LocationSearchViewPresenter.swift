//
//  LocationSearchViewPresenter.swift
//  Xebia
//
//  Created by Muhammad Farooq on 14/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import Foundation


public protocol LocationSearchView: class {
    func reloadView()
    func showErrorView(_ error: String)
    func hideErrorView()
    func activityIndicatorAnimatingView(animating: Bool)
}

class LocationSearchViewPresenter {
    
    private weak var view: LocationSearchView?
    
    private let client = OpenweatherAPIClient()
    private let searchClient = SearchCityAPIClient()
    
    var weatherList: [WeatherViewModel] = [WeatherViewModel]()
    
    var paramList = [String]()
    private var stateCurrentWeather = StateView.loading
    private var currentCount = 0
    private var totalCount = 0
    
    public init(view: LocationSearchView?) {
        self.view = view
    }
    
    func getWeatherAtIndex(index: Int) -> WeatherViewModel {
        return weatherList[index]
    }
    
    func locationCount() -> Int {
        return weatherList.count
    }
    
    func fetchWeather() {
        
        var weather = WeatherViewModel()
        stateCurrentWeather = StateView.loading
        
        weatherList.removeAll()
        
        for param in paramList {
            self.view?.activityIndicatorAnimatingView(animating: true)
            self.view?.hideErrorView()
            
            client.getCurrentWeather(at: param) { [weak self] currentWeather, error in
                if let currentWeather = currentWeather {
                    weather.currentWeather = currentWeather
                    weather.todayWeather = currentWeather.getForecastWeather()
                    weather.currentDescription = currentWeather.description()
                    
                    self?.weatherList.append(weather)
                    
                    self?.stateCurrentWeather = .success
                } else {
                    self?.stateCurrentWeather = .failed
                }
                
                self?.updateStateView()
            }
        }
    }
    
    func updateStateView() {
        if weatherList.count > 0 {
            if stateCurrentWeather == .success {
                self.view?.activityIndicatorAnimatingView(animating: false)
                self.view?.reloadView()
            }
            
            if stateCurrentWeather == .failed {
                self.view?.activityIndicatorAnimatingView(animating: false)
                self.view?.showErrorView("weather data not avaialable")
            }
        } else {
            self.view?.activityIndicatorAnimatingView(animating: false)
            self.view?.showErrorView("weather data not avaialable")
        }
    }
    
    func searchCity(text: String?) {
    
        paramList.removeAll()
        
        guard let locations =  text?.components(separatedBy:",") else {
            return
        }
        
        totalCount = locations.count
        currentCount = 0
        
        if (locations.count > Constants.MAX_LOC) {
            debugPrint("maximum 7 locations")
        } else if (locations.count < Constants.MIN_LOC) {
            debugPrint("minimum 3 locations")
        } else {
            for loc in locations {
                searchClient.getCity(at: loc) { [weak self] city, error in
                    if let city = city {
                        self?.paramList.append(city)
                    }
                    
                    if let c = self?.currentCount{
                        self?.currentCount = c + 1
                    }
                    
                    self?.updateFetchWeather()
                }
            }
        }
    }
    
    func updateFetchWeather() {
        if (totalCount == currentCount) {
            fetchWeather()
        }
    }
}
