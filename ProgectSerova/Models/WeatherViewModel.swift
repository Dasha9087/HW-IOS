import Foundation

struct WeatherViewModel {
    let city: String
    let date: String
    let temperature: String
    let feelsLike: String
    let description: String
    let icon: String
    let humidity: String
    let windSpeed: String
    let pressure: String
    let uvIndex: String
    
    init(from model: WeatherResponse) {
        city = model.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        formatter.locale = Locale(identifier: "ru_RU")
        date = formatter.string(from: Date())
        
        let humValue = model.main.humidity
        let pressVal = model.main.pressure
        
        let descText = model.weather.first?.description.capitalized ?? ""
        let conditionCode = model.weather.first?.icon ?? "01d"
        
        temperature = UnitsFormatter.temperature(model.main.temp)
        feelsLike = "Ощущается как \(UnitsFormatter.temperature(model.main.feels_like))"
        description = descText
        humidity = "\(humValue)"
        windSpeed = UnitsFormatter.windSpeed(model.wind.speed)
        pressure = "\(pressVal) мм рт.ст."
        uvIndex = "Низкий"
        
        icon = WeatherIcon.systemName(for: conditionCode)
    }
}

enum WeatherIcon {
    static func systemName(for code: String) -> String {
        switch code {
        case "01d", "01n": return "sun.max.fill"
        case "02d", "02n": return "cloud.sun.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "cloud.fill"
        case "09d", "09n", "10d", "10n": return "cloud.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
}
