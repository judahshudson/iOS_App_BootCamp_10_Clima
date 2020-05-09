/*
take some functionality out of WeatherManager
put into new data type
 WeatherModel
 -> shorter, simpler files
 ->easy to understand
 ->MVC design
 */

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityname: String
    let temperature: Double
    
    //computed property
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    
    var conditionName: String {
        switch conditionId {
        case 200...232: //thunderstorm
            return "cloud.bolt"
        case 300...321: //drizzle
            return "cloud.drizzle"
        case 500...531: //rain
            return "cloud.heavyrain"
        case 600...622: //snow
            return "cloud.snow"
        case 701...781: //atmosphere
            return "wind"
        case 800:   //clear
            return "sun.max"
        case 801...804: //clouds
            return "cloud"
        default:
            return "sun.min"
        }
    }
    

}

