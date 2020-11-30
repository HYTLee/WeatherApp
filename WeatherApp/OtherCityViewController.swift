//
//  OtherCityViewController.swift
//  WeatherApp
//
//  Created by AP Yauheni Hramiashkevich on 11/30/20.
//

import UIKit

class OtherCityViewController: UIViewController {

    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var preasureLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var CityTextField: UITextField!
    public let baseURLString = "http://api.weatherapi.com/v1/current.json?key=dc723792c3524450b37113013202911&q="
    public var weatherData : Response?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func searchForWeather(_ sender: Any) {
        if CityTextField.text != nil {
            getDataFromWeatherAPI {
                self.humidityLabel.text = "Humiodity \(self.weatherData?.current.humidity ?? 0)%"
                self.preasureLabel.text = "Preasure \(self.weatherData?.current.pressureMB ?? 0) mm"
                self.temperatureLabel.text = "Temperature \(self.weatherData?.current.tempC ?? 0)˚C"
            }
        }
    }
    
    
    func getDataFromWeatherAPI(completed: @escaping() -> () )  {
        let url = "\(baseURLString)\(CityTextField.text ?? "Minsk")"
        print(url)
        let urlSessin = URLSession(configuration: .default)
        guard let weatherApiUrl = URL(string: url) else {return }
        let request = URLRequest(url: weatherApiUrl)
       let dataTask =  urlSessin.dataTask(with: request) { (data, response, error) in
        if error != nil {
            print(error ?? "Error is unknown")
            }
        
        if let data = data {
            do {
                let dataFromJSON = try JSONDecoder().decode(Response.self, from: data)
                self.weatherData = dataFromJSON
                DispatchQueue.main.async {
                    completed()
                }
            }
            catch {
                print(error)
            }
        }
        }
        dataTask.resume()

    }

}
