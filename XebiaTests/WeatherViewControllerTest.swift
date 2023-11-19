//
//  WeatherViewControllerTest.swift
//  XebiaTests
//
//  Created by Muhammad Farooq on 15/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import XCTest

@testable import Xebia
class MovieListViewControllerTest: XCTestCase {

    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    var wvm = WeatherViewModel()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func prepareController(presenter: WeattherViewPresenter? = nil) -> WeatherViewController? {
        let controller = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController
        if let pres = presenter {
            controller?.presenter = pres
        }
        _ = controller?.view
        return controller
    }
    
    
    func testGetWeather() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        // Act
        let weather = ctr.presenter.getWeather()
        
        // Assert
        XCTAssertEqual(weather.currentWeather.name, "Shuzenji")
        XCTAssertEqual(weather.currentWeather.timezone, 32400)
        XCTAssertEqual(weather.currentWeather.base, "stations")
        XCTAssertEqual(weather.currentWeather.mainValue.tempMax, 18.89)
    }
    
    
    func testUpdateBackgroundImage() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        // Act
        ctr.presenter.updateBackgroundImage()
        
        // Assert
        XCTAssertEqual(ctr.backgroundImageView.image, UIImage(named: "lightrain"))
    }
    
    func testLocationCollectionViewCell() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        let index = IndexPath(item: 1, section: 0)
        
        guard let cell = ctr.collectionView(ctr.locationCollectionView, cellForItemAt: index) as? LocationCollectionViewCell else {
            fatalError("The deque cell is not an instance of LocationCollectionViewCell.")
        }
        
        // Act
        cell.setupCell(w: ctr.presenter.getWeather())
        
        // Assert
        XCTAssertEqual(cell.cityLabel.text, "Shuzenji")
        XCTAssertEqual(cell.weatherLabel.text, "Rain")
        XCTAssertEqual(cell.tempratureLabel.text, "16°")
        
        XCTAssertEqual(cell.dayLabel.text, "Saturday")
        XCTAssertEqual(cell.temperatureMaxLabel.text, "18°")
        XCTAssertEqual(cell.temperatureMinLabel.text, "15°")
        
        XCTAssertEqual(cell.todayConditionLabel.text, "Today: Light rain currently. It\'s 16.75°.")
        
        XCTAssertEqual(cell.sunRiseLabel.text, "23.39")
        XCTAssertEqual(cell.sunSetLabel.text, "13.41")
        XCTAssertEqual(cell.pressureLabel.text, "1014 hPa")
        XCTAssertEqual(cell.humidityLabel.text, "3%")
        XCTAssertEqual(cell.visbilityLabel.text, "--- Km")
        XCTAssertEqual(cell.feelsLikeLabel.text, "11.43°")
        XCTAssertEqual(cell.highTempLabel.text, "18°")
        XCTAssertEqual(cell.lowTempLabel.text, "15°")
        
    }
    
    func testLocationCollectionViewCellHourly() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        let index = IndexPath(item: 0, section: 0)
        
        guard let cell = ctr.collectionView(ctr.locationCollectionView, cellForItemAt: index) as? LocationCollectionViewCell else {
            fatalError("The deque cell is not an instance of LocationCollectionViewCell.")
        }
        
        // Act
        cell.setupCell(w: ctr.presenter.getWeather())
        
        guard let hourlycell = cell.hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: index) as? HourlyCollectionViewCell else {
            fatalError("The deque cell is not an instance of HourlyCollectionViewCell.")
        }
        
        hourlycell.setupCell(w: cell.hourly[index.row])
        
        // Assert
        XCTAssertEqual(hourlycell.hourLabel.text, "01")
        XCTAssertEqual(hourlycell.humidityLabel.text, "41%")
        XCTAssertEqual(hourlycell.temperatureLabel.text, "16°")
    }
    
    func testLocationCollectionViewCellDaily() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        let index = IndexPath(item: 0, section: 0)
        
        guard let cell = ctr.collectionView(ctr.locationCollectionView, cellForItemAt: index) as? LocationCollectionViewCell else {
            fatalError("The deque cell is not an instance of LocationCollectionViewCell.")
        }
        
        // Act
        cell.setupCell(w: ctr.presenter.getWeather())
        
        guard let dailycell = cell.dailyTableView.dequeueReusableCell(withIdentifier: "Cell", for: index) as? DailyTableViewCell else {
            fatalError("The deque cell is not an instance of DailyTableViewCell.")
        }
        
        dailycell.setupCell(w: cell.daily[index.row])
        
        // Assert
        XCTAssertEqual(dailycell.dayLabel.text, "Sunday")
        XCTAssertEqual(dailycell.temperatureMaxLabel.text, "16°")
        XCTAssertEqual(dailycell.temperatureMinLabel.text, "16°")
    }
    
    func prefill(ctr: WeatherViewController) {
        
        let wvm = Xebia.WeatherViewModel(stateView: Xebia.StateView.loading, currentWeather: Xebia.CurrentWeather(timezone: 32400, id: 1851632, name: "Shuzenji", coordinate: Xebia.Coordinate(lon: 139.0, lat: 35.0), elements: [Xebia.WeatherElement(id: 500, main: "Rain", weatherDescription: "light rain", icon: "10d")], base: "stations", mainValue: Xebia.CurrentWeatherMainValue(temp: 16.75, feelsLike: 11.43, tempMin: 15.0, tempMax: 18.89, pressure: 1014, humidity: 3), visibility: nil, wind: Xebia.WeatherWind(speed: 2.15, deg: Optional(242)), clouds: Xebia.WeatherClouds(all: 100), date: 1589573082, sys: Xebia.CurrentWeatherSys(type: 3, id: 2019346, country: "JP", sunrise: 1589571591, sunset: 1589622065), code: 200), todayWeather: Xebia.ForecastWeather(date: 1589573082, mainValue: Xebia.ForecastWeatherMainValue(temp: 0.0, feelsLike: 0.0, tempMin: 15.0, tempMax: 18.89, pressure: 0, seaLevel: 0, grndLevel: 0, humidity: 0, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 500, main: "Rain", weatherDescription: "light rain", icon: "10d")], clouds: Xebia.WeatherClouds(all: 0), wind: Xebia.WeatherWind(speed: 0.0, deg: nil)), hourlyWeathers: [Xebia.ForecastWeather(date: 1589576400, mainValue: Xebia.ForecastWeatherMainValue(temp: 16.75, feelsLike: 13.58, tempMin: 16.75, tempMax: 16.75, pressure: 1015, seaLevel: 1017, grndLevel: 988, humidity: 41, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 2.49, deg: Optional(235))), Xebia.ForecastWeather(date: 1589587200, mainValue: Xebia.ForecastWeatherMainValue(temp: 16.59, feelsLike: 14.73, tempMin: 16.54, tempMax: 16.59, pressure: 1015, seaLevel: 1015, grndLevel: 986, humidity: 65, tempKf: 0.05), elements: [Xebia.WeatherElement(id: 500, main: "Rain", weatherDescription: "light rain", icon: "10d")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 2.71, deg: Optional(239))), Xebia.ForecastWeather(date: 1589598000, mainValue: Xebia.ForecastWeatherMainValue(temp: 15.2, feelsLike: 14.53, tempMin: 15.09, tempMax: 15.2, pressure: 1013, seaLevel: 1013, grndLevel: 985, humidity: 79, tempKf: 0.11), elements: [Xebia.WeatherElement(id: 500, main: "Rain", weatherDescription: "light rain", icon: "10d")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 1.66, deg: Optional(254))), Xebia.ForecastWeather(date: 1589608800, mainValue: Xebia.ForecastWeatherMainValue(temp: 14.75, feelsLike: 15.16, tempMin: 14.73, tempMax: 14.75, pressure: 1010, seaLevel: 1010, grndLevel: 981, humidity: 91, tempKf: 0.02), elements: [Xebia.WeatherElement(id: 501, main: "Rain", weatherDescription: "moderate rain", icon: "10d")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 0.89, deg: Optional(318))), Xebia.ForecastWeather(date: 1589619600, mainValue: Xebia.ForecastWeatherMainValue(temp: 14.59, feelsLike: 14.41, tempMin: 14.59, tempMax: 14.59, pressure: 1007, seaLevel: 1007, grndLevel: 979, humidity: 93, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 501, main: "Rain", weatherDescription: "moderate rain", icon: "10d")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 1.81, deg: Optional(34))), Xebia.ForecastWeather(date: 1589630400, mainValue: Xebia.ForecastWeatherMainValue(temp: 15.09, feelsLike: 14.72, tempMin: 15.09, tempMax: 15.09, pressure: 1005, seaLevel: 1005, grndLevel: 977, humidity: 93, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 501, main: "Rain", weatherDescription: "moderate rain", icon: "10n")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 2.32, deg: Optional(55))), Xebia.ForecastWeather(date: 1589641200, mainValue: Xebia.ForecastWeatherMainValue(temp: 15.74, feelsLike: 16.3, tempMin: 15.74, tempMax: 15.74, pressure: 1004, seaLevel: 1004, grndLevel: 976, humidity: 91, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04n")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 1.14, deg: Optional(76))), Xebia.ForecastWeather(date: 1589652000, mainValue: Xebia.ForecastWeatherMainValue(temp: 15.99, feelsLike: 16.84, tempMin: 15.99, tempMax: 15.99, pressure: 1004, seaLevel: 1004, grndLevel: 976, humidity: 90, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04n")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 0.76, deg: Optional(227))), Xebia.ForecastWeather(date: 1589662800, mainValue: Xebia.ForecastWeatherMainValue(temp: 16.79, feelsLike: 17.74, tempMin: 16.79, tempMax: 16.79, pressure: 1005, seaLevel: 1005, grndLevel: 977, humidity: 88, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 97), wind: Xebia.WeatherWind(speed: 0.84, deg: Optional(127))), Xebia.ForecastWeather(date: 1589673600, mainValue: Xebia.ForecastWeatherMainValue(temp: 21.09, feelsLike: 22.04, tempMin: 21.09, tempMax: 21.09, pressure: 1005, seaLevel: 1005, grndLevel: 977, humidity: 73, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 99), wind: Xebia.WeatherWind(speed: 1.51, deg: Optional(141))), Xebia.ForecastWeather(date: 1589684400, mainValue: Xebia.ForecastWeatherMainValue(temp: 22.19, feelsLike: 23.18, tempMin: 22.19, tempMax: 22.19, pressure: 1004, seaLevel: 1004, grndLevel: 976, humidity: 66, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 95), wind: Xebia.WeatherWind(speed: 1.17, deg: Optional(54))), Xebia.ForecastWeather(date: 1589695200, mainValue: Xebia.ForecastWeatherMainValue(temp: 23.6, feelsLike: 24.67, tempMin: 23.6, tempMax: 23.6, pressure: 1003, seaLevel: 1003, grndLevel: 976, humidity: 61, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 803, main: "Clouds", weatherDescription: "broken clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 57), wind: Xebia.WeatherWind(speed: 1.11, deg: Optional(40))), Xebia.ForecastWeather(date: 1589706000, mainValue: Xebia.ForecastWeatherMainValue(temp: 20.36, feelsLike: 22.34, tempMin: 20.36, tempMax: 20.36, pressure: 1004, seaLevel: 1004, grndLevel: 977, humidity: 80, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 0.45, deg: Optional(47))), Xebia.ForecastWeather(date: 1589716800, mainValue: Xebia.ForecastWeatherMainValue(temp: 18.09, feelsLike: 19.5, tempMin: 18.09, tempMax: 18.09, pressure: 1006, seaLevel: 1006, grndLevel: 979, humidity: 83, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04n")], clouds: Xebia.WeatherClouds(all: 86), wind: Xebia.WeatherWind(speed: 0.38, deg: Optional(297))), Xebia.ForecastWeather(date: 1589727600, mainValue: Xebia.ForecastWeatherMainValue(temp: 17.29, feelsLike: 18.64, tempMin: 17.29, tempMax: 17.29, pressure: 1007, seaLevel: 1007, grndLevel: 979, humidity: 87, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 803, main: "Clouds", weatherDescription: "broken clouds", icon: "04n")], clouds: Xebia.WeatherClouds(all: 62), wind: Xebia.WeatherWind(speed: 0.43, deg: Optional(87))), Xebia.ForecastWeather(date: 1589738400, mainValue: Xebia.ForecastWeatherMainValue(temp: 16.79, feelsLike: 17.5, tempMin: 16.79, tempMax: 16.79, pressure: 1007, seaLevel: 1007, grndLevel: 979, humidity: 88, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 803, main: "Clouds", weatherDescription: "broken clouds", icon: "04n")], clouds: Xebia.WeatherClouds(all: 81), wind: Xebia.WeatherWind(speed: 1.18, deg: Optional(76))), Xebia.ForecastWeather(date: 1589749200, mainValue: Xebia.ForecastWeatherMainValue(temp: 17.09, feelsLike: 17.67, tempMin: 17.09, tempMax: 17.09, pressure: 1008, seaLevel: 1008, grndLevel: 980, humidity: 88, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 803, main: "Clouds", weatherDescription: "broken clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 82), wind: Xebia.WeatherWind(speed: 1.52, deg: Optional(74))), Xebia.ForecastWeather(date: 1589760000, mainValue: Xebia.ForecastWeatherMainValue(temp: 20.09, feelsLike: 20.07, tempMin: 20.09, tempMax: 20.09, pressure: 1008, seaLevel: 1008, grndLevel: 981, humidity: 75, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 91), wind: Xebia.WeatherWind(speed: 2.61, deg: Optional(77))), Xebia.ForecastWeather(date: 1589770800, mainValue: Xebia.ForecastWeatherMainValue(temp: 22.69, feelsLike: 22.42, tempMin: 22.69, tempMax: 22.69, pressure: 1008, seaLevel: 1008, grndLevel: 981, humidity: 64, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 92), wind: Xebia.WeatherWind(speed: 2.97, deg: Optional(89))), Xebia.ForecastWeather(date: 1589781600, mainValue: Xebia.ForecastWeatherMainValue(temp: 23.39, feelsLike: 24.18, tempMin: 23.39, tempMax: 23.39, pressure: 1007, seaLevel: 1007, grndLevel: 980, humidity: 67, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 88), wind: Xebia.WeatherWind(speed: 2.21, deg: Optional(130))), Xebia.ForecastWeather(date: 1589792400, mainValue: Xebia.ForecastWeatherMainValue(temp: 20.35, feelsLike: 21.64, tempMin: 20.35, tempMax: 20.35, pressure: 1007, seaLevel: 1007, grndLevel: 980, humidity: 81, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 500, main: "Rain", weatherDescription: "light rain", icon: "10d")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 1.55, deg: Optional(223))), Xebia.ForecastWeather(date: 1589803200, mainValue: Xebia.ForecastWeatherMainValue(temp: 17.95, feelsLike: 19.61, tempMin: 17.95, tempMax: 17.95, pressure: 1006, seaLevel: 1006, grndLevel: 978, humidity: 92, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 501, main: "Rain", weatherDescription: "moderate rain", icon: "10n")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 0.81, deg: Optional(61))), Xebia.ForecastWeather(date: 1589814000, mainValue: Xebia.ForecastWeatherMainValue(temp: 17.39, feelsLike: 18.1, tempMin: 17.39, tempMax: 17.39, pressure: 1002, seaLevel: 1002, grndLevel: 974, humidity: 93, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 502, main: "Rain", weatherDescription: "heavy intensity rain", icon: "10n")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 1.96, deg: Optional(42))), Xebia.ForecastWeather(date: 1589824800, mainValue: Xebia.ForecastWeatherMainValue(temp: 18.51, feelsLike: 19.16, tempMin: 18.51, tempMax: 18.51, pressure: 999, seaLevel: 999, grndLevel: 972, humidity: 93, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 502, main: "Rain", weatherDescription: "heavy intensity rain", icon: "10n")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 2.68, deg: Optional(251))), Xebia.ForecastWeather(date: 1589835600, mainValue: Xebia.ForecastWeatherMainValue(temp: 18.69, feelsLike: 21.18, tempMin: 18.69, tempMax: 18.69, pressure: 997, seaLevel: 997, grndLevel: 970, humidity: 95, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 502, main: "Rain", weatherDescription: "heavy intensity rain", icon: "10d")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 0.36, deg: Optional(337))), Xebia.ForecastWeather(date: 1589846400, mainValue: Xebia.ForecastWeatherMainValue(temp: 17.89, feelsLike: 18.61, tempMin: 17.89, tempMax: 17.89, pressure: 996, seaLevel: 996, grndLevel: 969, humidity: 93, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 502, main: "Rain", weatherDescription: "heavy intensity rain", icon: "10d")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 2.22, deg: Optional(132))), Xebia.ForecastWeather(date: 1589857200, mainValue: Xebia.ForecastWeatherMainValue(temp: 21.99, feelsLike: 23.85, tempMin: 21.99, tempMax: 21.99, pressure: 997, seaLevel: 997, grndLevel: 970, humidity: 77, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 500, main: "Rain", weatherDescription: "light rain", icon: "10d")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 1.2, deg: Optional(123))), Xebia.ForecastWeather(date: 1589868000, mainValue: Xebia.ForecastWeatherMainValue(temp: 21.29, feelsLike: 21.28, tempMin: 21.29, tempMax: 21.29, pressure: 999, seaLevel: 999, grndLevel: 972, humidity: 77, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 98), wind: Xebia.WeatherWind(speed: 3.46, deg: Optional(118))), Xebia.ForecastWeather(date: 1589878800, mainValue: Xebia.ForecastWeatherMainValue(temp: 18.79, feelsLike: 17.46, tempMin: 18.79, tempMax: 18.79, pressure: 1002, seaLevel: 1002, grndLevel: 974, humidity: 81, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 803, main: "Clouds", weatherDescription: "broken clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 84), wind: Xebia.WeatherWind(speed: 4.44, deg: Optional(96))), Xebia.ForecastWeather(date: 1589889600, mainValue: Xebia.ForecastWeatherMainValue(temp: 16.25, feelsLike: 13.34, tempMin: 16.25, tempMax: 16.25, pressure: 1005, seaLevel: 1005, grndLevel: 978, humidity: 81, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04n")], clouds: Xebia.WeatherClouds(all: 91), wind: Xebia.WeatherWind(speed: 5.48, deg: Optional(86))), Xebia.ForecastWeather(date: 1589900400, mainValue: Xebia.ForecastWeatherMainValue(temp: 15.75, feelsLike: 13.03, tempMin: 15.75, tempMax: 15.75, pressure: 1006, seaLevel: 1006, grndLevel: 978, humidity: 78, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04n")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 4.73, deg: Optional(65))), Xebia.ForecastWeather(date: 1589911200, mainValue: Xebia.ForecastWeatherMainValue(temp: 15.22, feelsLike: 12.91, tempMin: 15.22, tempMax: 15.22, pressure: 1007, seaLevel: 1007, grndLevel: 979, humidity: 82, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04n")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 4.26, deg: Optional(66))), Xebia.ForecastWeather(date: 1589922000, mainValue: Xebia.ForecastWeatherMainValue(temp: 14.49, feelsLike: 12.91, tempMin: 14.49, tempMax: 14.49, pressure: 1008, seaLevel: 1008, grndLevel: 980, humidity: 87, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 3.29, deg: Optional(67))), Xebia.ForecastWeather(date: 1589932800, mainValue: Xebia.ForecastWeatherMainValue(temp: 15.62, feelsLike: 14.29, tempMin: 15.62, tempMax: 15.62, pressure: 1009, seaLevel: 1009, grndLevel: 981, humidity: 83, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 500, main: "Rain", weatherDescription: "light rain", icon: "10d")], clouds: Xebia.WeatherClouds(all: 99), wind: Xebia.WeatherWind(speed: 3.11, deg: Optional(65))), Xebia.ForecastWeather(date: 1589943600, mainValue: Xebia.ForecastWeatherMainValue(temp: 18.59, feelsLike: 17.89, tempMin: 18.59, tempMax: 18.59, pressure: 1008, seaLevel: 1008, grndLevel: 981, humidity: 70, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 93), wind: Xebia.WeatherWind(speed: 2.34, deg: Optional(75))), Xebia.ForecastWeather(date: 1589954400, mainValue: Xebia.ForecastWeatherMainValue(temp: 19.29, feelsLike: 19.69, tempMin: 19.29, tempMax: 19.29, pressure: 1007, seaLevel: 1007, grndLevel: 980, humidity: 68, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 500, main: "Rain", weatherDescription: "light rain", icon: "10d")], clouds: Xebia.WeatherClouds(all: 92), wind: Xebia.WeatherWind(speed: 0.87, deg: Optional(101))), Xebia.ForecastWeather(date: 1589965200, mainValue: Xebia.ForecastWeatherMainValue(temp: 17.78, feelsLike: 18.26, tempMin: 17.78, tempMax: 17.78, pressure: 1007, seaLevel: 1007, grndLevel: 979, humidity: 77, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 500, main: "Rain", weatherDescription: "light rain", icon: "10d")], clouds: Xebia.WeatherClouds(all: 99), wind: Xebia.WeatherWind(speed: 0.97, deg: Optional(146))), Xebia.ForecastWeather(date: 1589976000, mainValue: Xebia.ForecastWeatherMainValue(temp: 15.72, feelsLike: 15.43, tempMin: 15.72, tempMax: 15.72, pressure: 1008, seaLevel: 1008, grndLevel: 980, humidity: 78, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04n")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 1.26, deg: Optional(221))), Xebia.ForecastWeather(date: 1589986800, mainValue: Xebia.ForecastWeatherMainValue(temp: 15.09, feelsLike: 14.53, tempMin: 15.09, tempMax: 15.09, pressure: 1007, seaLevel: 1007, grndLevel: 979, humidity: 81, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04n")], clouds: Xebia.WeatherClouds(all: 96), wind: Xebia.WeatherWind(speed: 1.62, deg: Optional(228))), Xebia.ForecastWeather(date: 1589997600, mainValue: Xebia.ForecastWeatherMainValue(temp: 14.42, feelsLike: 14.03, tempMin: 14.42, tempMax: 14.42, pressure: 1006, seaLevel: 1006, grndLevel: 978, humidity: 84, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04n")], clouds: Xebia.WeatherClouds(all: 96), wind: Xebia.WeatherWind(speed: 1.33, deg: Optional(231)))], dailyWeathers: [Xebia.ForecastWeather(date: 1589662800, mainValue: Xebia.ForecastWeatherMainValue(temp: 16.79, feelsLike: 17.74, tempMin: 16.79, tempMax: 16.79, pressure: 1005, seaLevel: 1005, grndLevel: 977, humidity: 88, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 97), wind: Xebia.WeatherWind(speed: 0.84, deg: Optional(127))), Xebia.ForecastWeather(date: 1589749200, mainValue: Xebia.ForecastWeatherMainValue(temp: 17.09, feelsLike: 17.67, tempMin: 17.09, tempMax: 17.09, pressure: 1008, seaLevel: 1008, grndLevel: 980, humidity: 88, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 803, main: "Clouds", weatherDescription: "broken clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 82), wind: Xebia.WeatherWind(speed: 1.52, deg: Optional(74))), Xebia.ForecastWeather(date: 1589835600, mainValue: Xebia.ForecastWeatherMainValue(temp: 18.69, feelsLike: 21.18, tempMin: 18.69, tempMax: 18.69, pressure: 997, seaLevel: 997, grndLevel: 970, humidity: 95, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 502, main: "Rain", weatherDescription: "heavy intensity rain", icon: "10d")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 0.36, deg: Optional(337))), Xebia.ForecastWeather(date: 1589922000, mainValue: Xebia.ForecastWeatherMainValue(temp: 14.49, feelsLike: 12.91, tempMin: 14.49, tempMax: 14.49, pressure: 1008, seaLevel: 1008, grndLevel: 980, humidity: 87, tempKf: 0.0), elements: [Xebia.WeatherElement(id: 804, main: "Clouds", weatherDescription: "overcast clouds", icon: "04d")], clouds: Xebia.WeatherClouds(all: 100), wind: Xebia.WeatherWind(speed: 3.29, deg: Optional(67)))], currentDescription: "Today: Light rain currently. It\'s 16.75°.")
        
        
        ctr.presenter.weather = wvm
    }
}

