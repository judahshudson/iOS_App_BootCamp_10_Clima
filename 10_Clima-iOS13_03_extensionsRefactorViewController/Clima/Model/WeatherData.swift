//
//  WeatherData.swift
//  Clima
//
//  Created by Judah Hudson on 2/16/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

// Codable: Decodable + Encodable (read from and send to JSON)
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id : Int
}
