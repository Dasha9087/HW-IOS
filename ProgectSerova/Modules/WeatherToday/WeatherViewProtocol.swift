import Foundation

protocol WeatherViewProtocol: AnyObject {
    func renderWeather(_ viewModel: WeatherViewModel)
    func renderHourlyForecast(_ items: [ForecastItem])
    func renderDailyForecast(_ items: [ForecastItem])
    func showError(_ message: String)
    func showLoading(_ isLoading: Bool)
}
