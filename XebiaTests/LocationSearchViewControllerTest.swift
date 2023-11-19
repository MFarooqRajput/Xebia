//
//  LocationSearchViewControllerTest.swift
//  XebiaTests
//
//  Created by Muhammad Farooq on 15/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import XCTest

@testable import Xebia
class LocationSearchViewControllerTest: XCTestCase {

    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    var wvm = WeatherViewModel()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func prepareController(presenter: LocationSearchViewPresenter? = nil) -> LocationSearchViewController? {
        let controller = storyboard.instantiateViewController(withIdentifier: "LocationSearchViewController") as? LocationSearchViewController
        if let pres = presenter {
            controller?.presenter = pres
        }
        _ = controller?.view
        return controller
    }
    
    
    func testGetWeatherAtIndex() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        // Act
        let weather = ctr.presenter.getWeatherAtIndex(index: 1)
        
        // Assert
        XCTAssertEqual(weather.currentWeather.name, "Inner City")
        XCTAssertEqual(weather.currentWeather.timezone, 7200)
        XCTAssertEqual(weather.currentWeather.base, "stations")
        XCTAssertEqual(weather.currentWeather.mainValue.tempMax, 11.11)
        XCTAssertNil(weather.todayWeather.wind.deg)
    }
    
    func testLocationCount() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        // Act
        let count = ctr.presenter.locationCount()
        
        // Assert
        XCTAssertEqual(count, 3)
    }
    
    func testWeatherTableViewCell() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        let index = IndexPath(item: 1, section: 0)
        guard  let cell = ctr.tableView(ctr.weatherTableView, cellForRowAt: index)  as? WeatherTableViewCell else {
            XCTAssert(false, "Cell is not instance of WeatherTableViewCell")
            return
        }
        
        // Act
        cell.setupCell(w: ctr.presenter.getWeatherAtIndex(index: index.row))
        
        // Assert
        XCTAssertEqual(cell.cityLabel.text, "Inner City")
        XCTAssertEqual(cell.weatherLabel.text, "Clouds")
        XCTAssertEqual(cell.tempratureLabel.text, "10°")
        XCTAssertEqual(cell.temperatureMaxLabel.text, "11°")
        XCTAssertEqual(cell.temperatureMinLabel.text, "10°")
        XCTAssertEqual(cell.todayConditionLabel.text, "Today: Few clouds currently. It\'s 10.9°.")
        XCTAssertEqual(cell.windSpeedLabel.text, "7 WNW")
    }
    
    func prefill(ctr: LocationSearchViewController) {
        ctr.presenter.paramList = ["&lat=25.2674058&lon=55.2926806", "&lat=55.675757&lon=12.5690233", "&lat=52.5176319&lon=13.4096574"]
        ctr.presenter.weatherList = [Xebia.WeatherViewModel(stateView: Xebia.StateView.loading, currentWeather: Xebia.CurrentWeather(timezone: 14400, id: 290845, name: "Ash Shindaghah", coordinate: Xebia.Coordinate(lon: 55.29, lat: 25.27), elements: [Xebia.WeatherElement(id: 802, main: "Clouds", weatherDescription: "scattered clouds", icon: "03n")], base: "stations", mainValue: Xebia.CurrentWeatherMainValue(temp: 30.42, feelsLike: 33.24, tempMin: 29.44, tempMax: 31.0, pressure: 1005, humidity: 58), visibility: Optional(10000), wind: Xebia.WeatherWind(speed: 2.1, deg: Optional(30)), clouds: Xebia.WeatherClouds(all: 30), date: 1589575054, sys: Xebia.CurrentWeatherSys(type: 1, id: 7537, country: "AE", sunrise: 1589592815, sunset: 1589641023), code: 200), todayWeather: Xebia.ForecastWeather(date: 1589575054, mainValue: Xebia.ForecastWeatherMainValue(temp: 0.0, feelsLike: 0.0, tempMin: 29.44, tempMax: 31.0, pressure: 0, seaLevel: 0, grndLevel: 0, humidity: 0, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 802, main: "Clouds", weatherDescription: "scattered clouds", icon: "03n")], clouds: Xebia.WeatherClouds(all: 0), wind: Xebia.WeatherWind(speed: 0.0, deg: nil)), hourlyWeathers: [], dailyWeathers: [], currentDescription: "Today: Scattered clouds currently. It\'s 30.42°."), Xebia.WeatherViewModel(stateView: Xebia.StateView.loading, currentWeather: Xebia.CurrentWeather(timezone: 7200, id: 6949461, name: "Inner City", coordinate: Xebia.Coordinate(lon: 12.57, lat: 55.68), elements: [Xebia.WeatherElement(id: 801, main: "Clouds", weatherDescription: "few clouds", icon: "02n")], base: "stations", mainValue: Xebia.CurrentWeatherMainValue(temp: 10.9, feelsLike: 3.96, tempMin: 10.56, tempMax: 11.11, pressure: 1014, humidity: 57), visibility: Optional(10000), wind: Xebia.WeatherWind(speed: 7.7, deg: Optional(270)), clouds: Xebia.WeatherClouds(all: 18), date: 1589575021, sys: Xebia.CurrentWeatherSys(type: 1, id: 1575, country: "DK", sunrise: 1589511478, sunset: 1589570062), code: 200), todayWeather: Xebia.ForecastWeather(date: 1589575021, mainValue: Xebia.ForecastWeatherMainValue(temp: 0.0, feelsLike: 0.0, tempMin: 10.56, tempMax: 11.11, pressure: 0, seaLevel: 0, grndLevel: 0, humidity: 0, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 801, main: "Clouds", weatherDescription: "few clouds", icon: "02n")], clouds: Xebia.WeatherClouds(all: 0), wind: Xebia.WeatherWind(speed: 0.0, deg: nil)), hourlyWeathers: [], dailyWeathers: [], currentDescription: "Today: Few clouds currently. It\'s 10.9°."), Xebia.WeatherViewModel(stateView: Xebia.StateView.loading, currentWeather: Xebia.CurrentWeather(timezone: 7200, id: 6545310, name: "Mitte", coordinate: Xebia.Coordinate(lon: 13.41, lat: 52.52), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04n")], base: "stations", mainValue: Xebia.CurrentWeatherMainValue(temp: 11.1, feelsLike: 6.71, tempMin: 10.0, tempMax: 12.22, pressure: 1019, humidity: 57), visibility: Optional(10000), wind: Xebia.WeatherWind(speed: 4.1, deg: Optional(280)), clouds: Xebia.WeatherClouds(all: 89), date: 1589575017, sys: Xebia.CurrentWeatherSys(type: 1, id: 1275, country: "DE", sunrise: 1589512187, sunset: 1589568950), code: 200), todayWeather: Xebia.ForecastWeather(date: 1589575017, mainValue: Xebia.ForecastWeatherMainValue(temp: 0.0, feelsLike: 0.0, tempMin: 10.0, tempMax: 12.22, pressure: 0, seaLevel: 0, grndLevel: 0, humidity: 0, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04n")], clouds: Xebia.WeatherClouds(all: 0), wind: Xebia.WeatherWind(speed: 0.0, deg: nil)), hourlyWeathers: [], dailyWeathers: [], currentDescription: "Today: Overcast clouds currently. It\'s 11.1°.")]
    }
}
