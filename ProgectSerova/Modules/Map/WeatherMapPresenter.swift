import Foundation
import CoreLocation

protocol WeatherMapViewInput: AnyObject {
    func showLoading()
    func update(with viewModel: WeatherViewModel)
    func showError(message: String)
}

final class WeatherMapPresenter {
    
    weak var view: WeatherMapViewInput?
    
    private let weatherService: WeatherService
    private let locationService: LocationService
    
    init(weatherService: WeatherService, locationService: LocationService) {
        self.weatherService = weatherService
        self.locationService = locationService
    }
    
    func handleMapTap(coordinate: CLLocationCoordinate2D) {
        view?.showLoading()
        
        locationService.getCityName(from: coordinate) { [weak self] cityName in
            guard let self = self else { return }
            
            self.weatherService.fetchCurrentWeather(lat: coordinate.latitude, lon: coordinate.longitude) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let weather):
                        var viewModel = WeatherViewModel(from: weather)
                        viewModel.city = cityName
                        
                        self.view?.update(with: viewModel)
                        
                    case .failure(let error):
                        print("Weather error: \(error.localizedDescription)")
                        self.view?.showError(message: "Не удалось загрузить данные")
                    }
                }
            }
        }
    }
}
