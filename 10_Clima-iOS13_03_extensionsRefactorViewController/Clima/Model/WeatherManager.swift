//
//  WeatherManager.swift
//  Clima
//
//  Created by Judah Hudson on 2/15/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

// declare protocol in same file as class that will will use protocol
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=4e27cc04067f8df02059003a35c10579&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(_ cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        //trigger it
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in //anonymous function
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        //send weather back to WeatherViewController -> display in app
                        /*
                        //single use way (struct only for this app)
                        let weatherVC = WeatherViewController()
                        weatherVC.didUpdateWeather(weather)
                        */
                        //use delegates -> can use WeatherManager struct for future/other projects
                        //self = WeatherManager
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = (decodedData.weather[0].id)
            
            let weather = WeatherModel(conditionId: id, cityname: name, temperature: temp)
            //so can use above in performRequest
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil  //WeatherModel must be optional, so we can return nil
        }
    }
    
    

}
