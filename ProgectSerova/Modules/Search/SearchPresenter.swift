import Foundation
import MapKit

final class SearchPresenter: NSObject {
    
    weak var view: SearchViewProtocol?
    private let storage: StorageServiceable
    
    private let completer = MKLocalSearchCompleter()
    
    init(storage: StorageServiceable) {
        self.storage = storage
        super.init()
        
        completer.delegate = self
        completer.resultTypes = .address
    }
    
    func loadState(with text: String?) {
        if let text = text, !text.isEmpty {
            completer.queryFragment = text
        } else {
            completer.cancel()
            let history = storage.getSearchHistory()
            view?.display(items: history, isHistory: true)
        }
    }
    
    func selectCity(_ city: String) {
        let cleanCity = cleanCityName(city)
        storage.saveLastCity(cleanCity)
        view?.closeSearch()
    }
    
    func clearHistory() {
        storage.clearHistory()
        loadState(with: nil)
    }
    
    func deleteItem(at index: Int) {
        storage.deleteFromHistory(at: index)
        loadState(with: nil)
    }
    
    func searchCity(_ text: String) {
        guard !text.isEmpty else { return }
        let cleanCity = cleanCityName(text)
        storage.saveLastCity(cleanCity)
        view?.closeSearch()
    }
    
    private func cleanCityName(_ name: String) -> String {
        return name.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespaces) ?? name
    }
}

extension SearchPresenter: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        var uniqueCities: [String] = []
        
        for result in completer.results {
            let cleanTitle = cleanCityName(result.title)
            
            if !uniqueCities.contains(cleanTitle) && !cleanTitle.isEmpty && Int(cleanTitle) == nil {
                uniqueCities.append(cleanTitle)
            }
        }
        
        view?.display(items: uniqueCities, isHistory: false)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        view?.display(items: [], isHistory: false)
    }
}
