//
//  Coordinate.swift
//  Weather
//
//  Created by Muhammad Farooq on 13/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import Foundation

struct Coordinate: Codable {
    let lon, lat: Double
    
    static func emptyInit() -> Coordinate {
        return Coordinate(lon: 0, lat: 0)
    }
}

struct CurrentWeather: Codable {
    let timezone, id: Int
    let name: String
    let coordinate: Coordinate
    let elements: [WeatherElement]
    let base: String
    let mainValue: CurrentWeatherMainValue
    let visibility: Int?
    let wind: WeatherWind
    let clouds: WeatherClouds
    let date: Int
    let sys: CurrentWeatherSys
    let code: Int
    
    enum CodingKeys: String, CodingKey {
        case base, visibility, wind, clouds, sys, timezone, id, name
        case elements = "weather"
        case coordinate = "coord"
        case mainValue = "main"
        case date = "dt"
        case code = "cod"
    }
    
    static func emptyInit() -> CurrentWeather {
        return CurrentWeather(
            timezone: 0,
            id: 0,
            name: "",
            coordinate: Coordinate.emptyInit(),
            elements: [],
            base: "",
            mainValue: CurrentWeatherMainValue.emptyInit(),
            visibility: 0,
            wind: WeatherWind.emptyInit(),
            clouds: WeatherClouds.emptyInit(),
            date: 0,
            sys: CurrentWeatherSys.emptyInit(),
            code: 0
        )
    }
    
    func description() -> String {
        var result = "Today: "
        if let weatherElement = elements.first {
            result += "\(weatherElement.weatherDescription.capitalizingFirstLetter()) currently. "
        }
        result += "It's \(mainValue.temp)°."
        return result
    }
    
    func getForecastWeather() -> ForecastWeather {
        var result = ForecastWeather.emptyInit()

        result.date = self.date
        result.mainValue.tempMin = self.mainValue.tempMin
        result.mainValue.tempMax = self.mainValue.tempMax

        if let weatherElement = elements.first {
            result.elements.append(weatherElement)
        }

        return result
    }
}

struct CurrentWeatherMainValue: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
    
    static func emptyInit() -> CurrentWeatherMainValue {
        return CurrentWeatherMainValue(
            temp: 0.0,
            feelsLike: 0.0,
            tempMin: 0,
            tempMax: 0,
            pressure: 0,
            humidity: 0
        )
    }
}

struct CurrentWeatherSys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
    
    static func emptyInit() -> CurrentWeatherSys {
        return CurrentWeatherSys(
            type: 0,
            id: 0,
            country: "",
            sunrise: 0,
            sunset: 0
        )
    }
}

struct ForecastWeather: Codable {
    var date: Int
    var mainValue: ForecastWeatherMainValue
    var elements: [WeatherElement]
    let clouds: WeatherClouds
    let wind: WeatherWind

    enum CodingKeys: String, CodingKey {
        case clouds, wind
        case mainValue = "main"
        case date = "dt"
        case elements = "weather"
    }
    
    static func emptyInit() -> ForecastWeather {
        return ForecastWeather(
            date: 0,
            mainValue: ForecastWeatherMainValue.emptyInit(),
            elements: [],
            clouds: WeatherClouds.emptyInit(),
            wind: WeatherWind.emptyInit()
        )
    }
}

extension ForecastWeather: Identifiable {
    var id: String { "\(date)" }
}

struct ForecastWeatherCity: Codable {
    let id: Int
    let name: String
    let coordinate: Coordinate
    let country: String
    let timezone, sunrise, sunset: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case coordinate = "coord"
        case country, timezone, sunrise, sunset
    }
    
    static func emptyInit() -> ForecastWeatherCity {
        return ForecastWeatherCity(
            id: 0,
            name: "",
            coordinate: Coordinate.emptyInit(),
            country: "",
            timezone: 0,
            sunrise: 0,
            sunset: 0
        )
    }
}

struct ForecastWeatherMainValue: Codable {
    let temp, feelsLike: Double
    var tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
    
    static func emptyInit() -> ForecastWeatherMainValue {
        return ForecastWeatherMainValue(
            temp: 0.0,
            feelsLike: 0.0,
            tempMin: 0.0,
            tempMax: 0.9,
            pressure: 0,
            seaLevel: 0,
            grndLevel: 0,
            humidity: 0,
            tempKf: 0
        )
    }
}

struct ForecastWeatherResponse: Codable {
    let code: String
    let message, count: Int
    let list: [ForecastWeather]
    let city: ForecastWeatherCity
    
    enum CodingKeys: String, CodingKey {
        case code = "cod"
        case message
        case count = "cnt"
        case list, city
    }
    
    static func emptyInit() -> ForecastWeatherResponse {
        return ForecastWeatherResponse(
            code: "",
            message: 0,
            count: 0,
            list: [],
            city: ForecastWeatherCity.emptyInit()
        )
    }
    
    var dailyList: [ForecastWeather] {
        var result: [ForecastWeather] = []
        guard var before = list.first else {
            return result
        }
        
        if before.date.dateFromMilliseconds().dayWord() != Date().dayWord() {
            result.append(before)
        }

        for weather in list {
            if weather.date.dateFromMilliseconds().dayWord() != before.date.dateFromMilliseconds().dayWord() {
                result.append(weather)
            }
            before = weather
        }

        return result
    }
}

struct WeatherClouds: Codable {
    let all: Int

    static func emptyInit() -> WeatherClouds {
        return WeatherClouds(all: 0)
    }
}

struct WeatherElement: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
    
    static func emptyInit() -> WeatherElement {
        return WeatherElement(
            id: 0,
            main: "",
            weatherDescription: "",
            icon: ""
        )
    }
}

struct WeatherWind: Codable {
    let speed: Double
    let deg: Int?
    
    static func emptyInit() -> WeatherWind {
        return WeatherWind(speed: 0.0, deg: nil)
    }
}

enum StateView {
    case loading
    case success
    case failed
}


