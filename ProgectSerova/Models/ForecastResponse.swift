import Foundation

struct ForecastResponse: Decodable {

    let list: [ForecastItem]

}

struct ForecastItem: Decodable {

    let dt: TimeInterval
    let dt_txt: String
    let main: WeatherResponse.Main
    let weather: [WeatherResponse.Weather]
    let wind: WeatherResponse.Wind
}
