//
//  WeatherMananger.swift
//  Clima
//
//  Created by Beniamin on 26/08/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather : WeatherModel)
    func didFailWithError(error : Error)
}



struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=7bec5d0bda5ae4ec546517d7ddaba1f0&units=metric"
    
    var delegate : WeatherManagerDelegate?
    func fetchWeather(_ cityName : String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performTask(urlString)
    }
    
    func fetchWeather(latitude : CLLocationDegrees, longitude : CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performTask(urlString)
    }
    
    func performTask(_ urlString : String) {
        // 1. Create URL
        if let url = URL(string: urlString) {
            // 2. Create a url session
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(weather : weather)
                    }
                }
            }
            
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData : Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
    
            let id = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            let name = decodedData.name
            
            let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temperature )
            return weatherModel
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
