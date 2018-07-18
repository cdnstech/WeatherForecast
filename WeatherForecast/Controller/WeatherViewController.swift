//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Sayooj Krishnan  on 12/07/18.
//  Copyright © 2018 Sayooj Krishnan . All rights reserved.
//
import Alamofire
import SwiftyJSON
import UIKit
import CoreLocation
private let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
private let APP_ID = "e72ca729af228beabd5d20e3b7749713"
class WeatherViewController : UIViewController , CLLocationManagerDelegate  , ChangeCity {
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    let locationManager : CLLocationManager  = CLLocationManager()
    
    let weatherModel : WeatherModel = WeatherModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let lastLocation = locations.last {
            if lastLocation.horizontalAccuracy > 0 {
                locationManager.stopUpdatingLocation()
                let lat = String(lastLocation.coordinate.latitude)
                let lon = String( lastLocation.coordinate.longitude)
                
                let params : [String : String] = ["lat" : lat, "lon" : lon, "appid" : APP_ID]
                getWeatherData(params: params)
            }
        }
    }
    
    func getWeatherData(params : [String: String]){
        Alamofire.request(WEATHER_URL, method: .get, parameters:params).responseJSON{
            response in
            if response.result.isSuccess {
                
                let weatherJSON : JSON = JSON(response.result.value!)
                
                self.parseWeatherData(json: weatherJSON)
                self.updateUI()
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    func parseWeatherData(json : JSON){
        
        let tempResult = json["main"]["temp"].doubleValue
        
        weatherModel.temperature = Int(tempResult - 273.15)
        
        weatherModel.city = json["name"].stringValue
        
        weatherModel.condition = json["weather"][0]["id"].intValue
        
        weatherModel.weatherIconName = weatherModel.updateWeatherIcon(condition: weatherModel.condition)
   
    }
    
    func updateUI(){
        cityLabel.text = weatherModel.city
        temperatureLabel.text = "\(weatherModel.temperature)°"
        temperatureImage.image = UIImage(named: weatherModel.weatherIconName)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavailable"
    }
    
    @IBAction func didPressSwitch(_ sender: UIButton) {
        performSegue(withIdentifier: "cityVC", sender: self)
        
    }
    
    func withPickedCity(name: String) {
        let params : [String : String] = ["q" : name, "appid" : APP_ID]
        getWeatherData(params: params)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cityVC" {
            
            if  let vc = segue.destination as? SelectCityViewController {
                vc.delegate = self
                
            }
        }
    }
    
}

