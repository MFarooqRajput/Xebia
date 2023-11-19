//
//  OpenweatherAPIClient.swift
//  Weather
//
//  Created by Muhammad Farooq on 13/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import Foundation

class OpenweatherAPIClient {
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, Error?) -> Void
    typealias ForecastWeatherCompletionHandler = (ForecastWeatherResponse?, Error?) -> Void

    private let apiKey = "60b92c7c6653dc1bae7449f08d01f635"
    private let apiBaseUrl = "https://api.openweathermap.org/data/"
    private let apiVersion = "2.5"
    private let apiUnits = "metric"
    
    private let decoder = JSONDecoder()
    private let session: URLSession

    private enum SuffixURL: String {
        case forecastWeather = "forecast"
        case currentWeather = "weather"
    }
        
    private func baseUrl(_ suffixURL: SuffixURL, param: String) -> URL {
        return URL(string: "\(self.apiBaseUrl)\(self.apiVersion)/\(suffixURL.rawValue)?APPID=\(self.apiKey)&units=\(self.apiUnits)\(param)")!
    }
        
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
        
    private func getBaseRequest<T: Codable>(at param: String,
                                            suffixURL: SuffixURL,
                                            completionHandler completion:  @escaping (_ object: T?,_ error: Error?) -> ()) {
        let url = baseUrl(suffixURL, param: param)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(nil, ResponseError.requestFailed)
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        do {
                            let weather = try self.decoder.decode(T.self, from: data)
                            completion(weather, nil)
                        } catch let error {
                            completion(nil, error)
                        }
                    } else {
                        completion(nil, ResponseError.invalidData)
                    }
                } else if let error = error {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
    func getCurrentWeather(at param: String, completionHandler completion: @escaping CurrentWeatherCompletionHandler) {
        getBaseRequest(at: param, suffixURL: .currentWeather) { (weather: CurrentWeather?, error) in
            completion(weather, error)
        }
    }
    
    func getForecastWeather(at param: String, completionHandler completion: @escaping ForecastWeatherCompletionHandler) {
        getBaseRequest(at: param, suffixURL: .forecastWeather) { (weather: ForecastWeatherResponse?, error) in
            completion(weather, error)
        }
    }
}
