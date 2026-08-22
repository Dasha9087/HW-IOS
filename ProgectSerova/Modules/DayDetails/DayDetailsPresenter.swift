import Foundation

final class DayDetailsPresenter {
    
    weak var view: DayDetailsViewProtocol?
    private let city: String
    
    init(city: String) {
        self.city = city
    }
    
    func loadDetails(for item: ForecastItem) {
        let viewModel = DayDetailsViewModel(from: item, city: city)
        view?.renderDetails(viewModel)
    }
}
