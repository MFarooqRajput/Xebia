//
//  Helper.swift
//  Xebia
//
//  Created by Muhammad Farooq on 14/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import Foundation

class Helper {
    static func weatherConditionImage(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "thunderstorm"
            
        case 301...500 :
            return "lightrain"
            
        case 501...600 :
            return "shower"
            
        case 601...700 :
            return "snow"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "thunderstorm"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy"
            
        case 900...903, 905...1000  :
            return "thunderstorm"
            
        case 903 :
            return "snow"
            
        case 904 :
            return "sunny"
            
        default :
            return "nebula"
        }
    }
    
    static func weatherDirection(degree: Int) -> String {
        let val = ((Double(degree) / 22.5) + 0.5).rounded()
        let arr = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        return arr[(Int(val) % 16)]
    }
}
