import Foundation

final class SettingsPresenter {
    
    weak var view: SettingsViewInput?
    private let storage: StorageServiceInput
    
    init(storage: StorageServiceInput) {
        self.storage = storage
    }
    
    func getCurrentUnits() -> String {
        storage.getUnits()
    }
    
    func isDarkTheme() -> Bool {
        storage.isDarkTheme()
    }
    
    func changeUnits(_ isMetric: Bool) {
        let units = isMetric ? "metric" : "imperial"
        storage.saveUnits(units)
    }
    
    func changeTheme(_ isDark: Bool) {
        storage.saveTheme(isDark)
        view?.updateTheme(isDark)
    }
    
    func getWindUnits() -> String {
        storage.getWindUnits()
    }
    
    func changeWindUnits(_ isKmh: Bool) {
        let units = isKmh ? "kmh" : "ms"
        storage.saveWindUnits(units)
    }
}
