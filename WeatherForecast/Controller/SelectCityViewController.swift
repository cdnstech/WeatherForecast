//
//  SelectCityViewController.swift
//  WeatherForecast
//
//  Created by Sayooj Krishnan  on 18/07/18.
//  Copyright © 2018 Sayooj Krishnan . All rights reserved.
//

import UIKit
protocol  ChangeCity  {
    func withPickedCity(name : String)
}


class SelectCityViewController: UIViewController , UIPickerViewDataSource , UIPickerViewDelegate  {
    
    var delegate : ChangeCity?
    override var prefersStatusBarHidden: Bool {
        return true
    }
    let cities : [String ] = ["Calicut","Kochi","Kannur","Thrissur","Thiruvananthapuram","Mumbai" , "Chennai" , "Bangalore"]
    
    
    @IBOutlet weak var getWeatherButton: UIButton!
    @IBOutlet weak var cityPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cityPicker.delegate = self
        cityPicker.dataSource = self
        
        configureButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }

    
    @IBAction func getWeatherOfCity(_ sender: UIButton) {
        
       let pickedCityIndex =  cityPicker.selectedRow(inComponent: 0)
        
        delegate?.withPickedCity(name: cities[pickedCityIndex])
        
        self.dismiss(animated: true, completion: nil)
       
    }
    
    func configureButton(){
        getWeatherButton.layer.borderColor = UIColor(red: 1.0, green: 147 / 255.0, blue: 0, alpha: 1).cgColor
        getWeatherButton.layer.borderWidth = 2
        getWeatherButton.layer.cornerRadius = 9
        getWeatherButton.clipsToBounds = true
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let stringData = NSAttributedString(string: cities[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        return stringData
    }
    
}
