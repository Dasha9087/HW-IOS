import Foundation

struct DayDetailsViewModel {
    let date: String
    let city: String
    let sunrise: String
    let sunset: String
    let pressure: String
    let humidity: String
    let visibility: String
    let windSpeed: String
    let feelsLike: String
    let hourlyTemps: [Int]
    let hourlyTimes: [String]
    
    init(from item: ForecastItem, city: String) {
        self.city = city
        
        let formatter = UnitsFormatter(storageService: StorageService.shared)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        if let date = DateFormatter().date(from: item.dateText) {
            self.date = dateFormatter.string(from: date)
        } else {
            self.date = item.dateText
        }
        
        self.sunrise = "06:30"
        self.sunset = "20:45"
        self.pressure = "\(item.main.pressure) мм рт. ст."
        self.humidity = "\(item.main.humidity)%"
        self.visibility = "10 км"
        
        self.windSpeed = formatter.windSpeed(item.wind.speed)
        self.feelsLike = formatter.temperature(item.main.feels_like)
        
        self.hourlyTemps = [18, 19, 21, 23, 22, 20, 18, 17]
        self.hourlyTimes = ["09:00", "12:00", "15:00", "18:00", "21:00", "00:00", "03:00", "06:00"]
    }

}
