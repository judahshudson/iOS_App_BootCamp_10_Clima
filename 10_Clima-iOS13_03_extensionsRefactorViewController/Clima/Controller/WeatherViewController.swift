/*
 01)
 Using extensions to refactor the view controller
 
 -move all text field related functions
 from WeatherViewController
 to extension at bottom
 
 02)
 get current location using GPS
 */

import UIKit
//***get current location using GPS***
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    //***location using GPS***
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        //***location using GPS***
        locationManager.delegate = self
        
        //***location using GPS***
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    //***location using GPS***
    //click button -> sets weather to current location
    @IBAction func LocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//EXTENSIONS

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    //delegate functions
    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        //dismiss keyboard after search
        searchTextField.endEditing(true)    }
    
    //when push go on keyboard -> enters city search
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //if user typed something -> yes end editing
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "type something"
            return false
        }
    }
    
    //text field tells view controller: "user stopped editing"
    //works for top search button, and keyboard go key
    func textFieldDidEndEditing(_ textField: UITextField) {
        //get city user typed -> check weather
        if let city = searchTextField.text {
            weatherManager.fetchWeather(city)
        }
        
        //clear city text after search
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    //display our search results
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
           //self.temperatureLabel.text = weather.temperatureString //handler running in background, this task will apear frozen while waiting. Need something to set it to while we're waiting for networking etc
           DispatchQueue.main.async {
               self.temperatureLabel.text = weather.temperatureString
               self.conditionImageView.image = UIImage(systemName: weather.conditionName)
               self.cityLabel.text = weather.cityname
           }
       }
       
       func didFailWithError(error: Error) {
           print(error)
       }
}

//MARK: - CLLocationManagerDelegate
//***location using GPS***
//use latitude & longitude coordinates to fetch weather from our API (openweathermap.org), for city search as well as current location
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            //stop, so can request again (locationPressed button), to return to weather at my current location
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
