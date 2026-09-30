import Foundation

struct ForecastResponse: Decodable {
    let list: [ForecastItem]
}

struct ForecastItem: Decodable {
    let date: TimeInterval
    let dateText: String
    let main: WeatherResponse.Main
    let weather: [WeatherResponse.Weather]
    let wind: WeatherResponse.Wind
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case dateText = "dt_txt"  
        case main
        case weather
        case wind
    }
}
