import Foundation

struct WeatherResponse: Decodable {
    
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let sys: Sys
    
    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
        let humidity: Int
        let pressure: Int
    }
    
    struct Weather: Decodable {
        let description: String
        let icon: String
    }
    
    struct Wind: Decodable {
        let speed: Double
    }
    
    struct Sys: Decodable {
        let sunrise: TimeInterval
        let sunset: TimeInterval
    }
}
