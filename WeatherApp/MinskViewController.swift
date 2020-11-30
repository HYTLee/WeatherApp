//
//  ViewController.swift
//  WeatherApp
//
//  Created by AP Yauheni Hramiashkevich on 11/26/20.
//

import UIKit

class MinskViewController: UIViewController {

    public let baseURLString = "http://api.weatherapi.com/v1/current.json?key=dc723792c3524450b37113013202911&q=Minsk"
    public var weatherData : Response?

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var preasureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var appearenceTemperatureLabel: UILabel!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBAction func refreshAction(_ sender: Any) {
        getDataFromWeatherAPI {
            self.preasureLabel.text = "\(String(self.weatherData?.current.pressureMB ?? 0)) mm"
            self.humidityLabel.text = "\(String(self.weatherData?.current.humidity ?? 0)) %"
            self.temperatureLabel.text = "\(String(self.weatherData?.current.tempC ?? 0))˚C"
            self.appearenceTemperatureLabel.text = "\(String(self.weatherData?.current.feelslikeC ?? 0))˚C"
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromWeatherAPI {
            self.preasureLabel.text = "\(String(self.weatherData?.current.pressureMB ?? 0)) mm"
            self.humidityLabel.text = "\(String(self.weatherData?.current.humidity ?? 0)) %"
            self.temperatureLabel.text = "\(String(self.weatherData?.current.tempC ?? 0))˚C"
            self.appearenceTemperatureLabel.text = "\(String(self.weatherData?.current.feelslikeC ?? 0))˚C"
            self.imageView.downloaded(from:"http:\(self.weatherData?.current.condition.icon ?? "cdn.weatherapi.com/weather/64x64/night/116.png")")
          //  print("http:\(self.weatherData?.current.condition.icon ?? "cdn.weatherapi.com/weather/64x64/night/116.png")")
        }
    }
    
    
//    func downloadImageForWeather()  -> UIImage {
 //       return
 //   }

    
    func updateUIWith(currentWeather: Response) {
        preasureLabel.text = "\(currentWeather.current.pressureMB)"
        humidityLabel.text = "\(currentWeather.current.humidity)"
        temperatureLabel.text = "\(currentWeather.current.tempC)"
        appearenceTemperatureLabel.text = "\(currentWeather.current.feelslikeC)"
    }
    
    func getDataFromWeatherAPI(completed: @escaping() -> () )  {
        let urlSessin = URLSession(configuration: .default)
        guard let weatherApiUrl = URL(string: baseURLString) else {return }
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


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
