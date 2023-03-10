//
//  WeatherData.swift
//  Clima
//
//  Created by Julie Lu on 10/3/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    //Struct confirms to decoder protocol - it means that the weather data turns into a type that can decode itself from an external representation.
    let name: String
    let main: Main
    let weather: [Weather]
    // Use square brackets since it's an array
}

struct Main: Decodable {
    let temp: Double
    // These names must be the exact same as the JSON file
    
}

struct Weather: Decodable {
    let description: String
}
