//
//  WeatherManager.swift
//  Clima
//
//  Created by Julie Lu on 9/3/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather (_weatherManager: WeatherManager, weather: WeatherModel)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=d5945d793d14a230ea19f481d18ce411&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //Carry out four steps of networking
        
        //Step 1: Create URL
        if let url = URL(string: urlString) {
            
            //Step 2: URL Session has been created as a default.
            let session = URLSession(configuration: .default)
                
            //Step 3: Give the session a task
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    // We want to parse the data to NOT be in a json format.
                    //let dataString = String(data: safeData, encoding: .utf8)
                    //print(dataString)
                    if let weather = self.parseJSON(weatherData: safeData) {
                        delegate?.didUpdateWeather(_weatherManager: self, weather: weather)
                    }
                    // We must add self when calling a method from its own class
                }
            }
                    
            //Step 4: Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name

            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return(weather)
        } catch {
            delegate?.didFailWithError(error: Error)
            return nil
        }
        // Takes two inputs - data you want to decode, and the data type
        
    }
    
}
