//
//  SearchCity.swift
//  Xebia
//
//  Created by Muhammad Farooq on 14/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import Foundation

import MapKit

class SearchCityAPIClient {
    typealias SearchCityCompletionHandler = (String?, Error?) -> Void
    
    func getCity(at param: String, completionHandler completion: @escaping SearchCityCompletionHandler) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = param
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            if error != nil {
                completion(nil, error)
            } else {
                
                guard let response = response else {
                    return completion(nil, error)
                }
                
                for location in response.mapItems {
                    let lat = String(location.placemark.coordinate.latitude)
                    let lon = String(location.placemark.coordinate.longitude)
                    completion("&lat=\(lat)&lon=\(lon)", error)
                }
            }
        }
    }
}



