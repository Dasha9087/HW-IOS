import Foundation

final class WeatherPresenter {
    
    weak var view: WeatherViewProtocol?
    private let service: WeatherServiceable
    private let storage: StorageServiceable
    
    init(service: WeatherServiceable, storage: StorageServiceable) {
        self.service = service
        self.storage = storage
    }
    
    func loadWeather(for city: String) {
        let cleanCity = city.trimmingCharacters(in: .whitespaces)
        let targetCity = cleanCity.isEmpty ? "Москва" : cleanCity
        
        view?.showLoading(true)
        
        service.fetchCurrentWeather(city: targetCity) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    let viewModel = WeatherViewModel(from: weather)
                    self?.view?.renderWeather(viewModel)
                    self?.loadForecast(for: targetCity)
                    
                case .failure(let error):
                    self?.view?.showLoading(false)
                    self?.view?.showError("Не удалось загрузить погоду.")
                }
            }
        }
    }
    
    private func loadForecast(for city: String) {
        service.fetchForecast(city: city) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.showLoading(false)
                
                switch result {
                case .success(let forecast):
                    let hourly = Array(forecast.list.prefix(24))
                    self?.view?.renderHourlyForecast(hourly)
                    
                    let daily = Self.dailyForecast(from: forecast.list)
                    self?.view?.renderDailyForecast(daily)
                    
                case .failure:
                    break
                }
            }
        }
    }
    
    private static func dailyForecast(from list: [ForecastItem]) -> [ForecastItem] {
        let calendar = Calendar.current
        var grouped: [Date: [ForecastItem]] = [:]
        
        for item in list {
            let date = Date(timeIntervalSince1970: item.dt)
            let dayStart = calendar.startOfDay(for: date)
            grouped[dayStart, default: []].append(item)
        }
        
        var result: [ForecastItem] = []
        
        for dayStart in grouped.keys.sorted() {
            guard let items = grouped[dayStart] else { continue }
            
            let picked = items[items.count / 2]
            result.append(picked)
            
            if result.count == 5 {
                break
            }
        }
        
        return result
    }
}
