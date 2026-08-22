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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        if let date = DateFormatter().date(from: item.dt_txt) {
            self.date = dateFormatter.string(from: date)
        } else {
            self.date = item.dt_txt
        }
        
        sunrise = "06:30"
        sunset = "20:45"
        pressure = "\(item.main.pressure) мм рт. ст."
        humidity = "\(item.main.humidity)%"
        visibility = "10 км"
        windSpeed = UnitsFormatter.windSpeed(item.wind.speed)
        feelsLike = UnitsFormatter.temperature(item.main.feels_like)
        
        hourlyTemps = [18, 19, 21, 23, 22, 20, 18, 17]
        hourlyTimes = ["09:00", "12:00", "15:00", "18:00", "21:00", "00:00", "03:00", "06:00"]
    }
}
