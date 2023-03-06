//
//  WeatherData.swift
//  Clima
//
//  Created by Beniamin on 29/08/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData : Decodable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main: Decodable {
    let temp : Double
    let humidity : Int
}

struct Weather : Decodable {
    let id : Int
}
