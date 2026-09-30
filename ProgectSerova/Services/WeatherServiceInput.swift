import Foundation

protocol WeatherServiceInput {
    
    func fetchCurrentWeather(
        city: String,
        completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void
    )
    
    func fetchForecast(
        city: String,
        completion: @escaping (Result<ForecastResponse, NetworkError>) -> Void
    )
    
    func fetchCurrentWeather(
        lat: Double,
        lon: Double,
        completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void
    )
    
}
