import Foundation

final class StorageService: StorageServiceable {
    
    static let shared = StorageService()
    private init() {}
    
    private let historyKey = "searchHistory"
    private let lastCityKey = "lastCity"
    private let unitsKey = "units"
    private let themeKey = "theme"
    private let windUnitsKey = "windUnits"
    
    func saveUnits(_ units: String) {
        UserDefaults.standard.set(units, forKey: unitsKey)
    }
    
    func getUnits() -> String {
        UserDefaults.standard.string(forKey: unitsKey) ?? "metric"
    }
    
    func saveTheme(_ dark: Bool) {
        UserDefaults.standard.set(dark, forKey: themeKey)
    }
    
    func isDarkTheme() -> Bool {
        UserDefaults.standard.bool(forKey: themeKey)
    }
    
    func saveWindUnits(_ units: String) {
        UserDefaults.standard.set(units, forKey: windUnitsKey)
    }
    
    func getWindUnits() -> String {
        UserDefaults.standard.string(forKey: windUnitsKey) ?? "ms"
    }
    
    func getSearchHistory() -> [String] {
        UserDefaults.standard.stringArray(forKey: historyKey) ?? []
    }
    
    func addToHistory(_ city: String) {
        var history = getSearchHistory()
        if let index = history.firstIndex(of: city) {
            history.remove(at: index)
        }
        history.insert(city, at: 0)
        if history.count > 10 { history.removeLast() }
        UserDefaults.standard.set(history, forKey: historyKey)
    }
    
    func clearHistory() {
        UserDefaults.standard.removeObject(forKey: historyKey)
    }
    
    func deleteFromHistory(at index: Int) {
        var history = getSearchHistory()
        guard index < history.count else { return }
        history.remove(at: index)
        UserDefaults.standard.set(history, forKey: historyKey)
    }
    
    func getLastCity() -> String {
        UserDefaults.standard.string(forKey: lastCityKey) ?? "Minsk"
    }
    
    func saveLastCity(_ city: String) {
        UserDefaults.standard.set(city, forKey: lastCityKey)
        addToHistory(city)
    }
}
