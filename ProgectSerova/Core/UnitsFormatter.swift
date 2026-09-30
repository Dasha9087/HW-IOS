import Foundation

final class UnitsFormatter {
    
    private let storageService: StorageService
    
    init(storageService: StorageService) {
        self.storageService = storageService
    }
    
    func temperature(_ value: Double) -> String {
        let units = storageService.getUnits()
        let intValue = Int(value.rounded())
        return units == "imperial" ? "\(intValue)°F" : "\(intValue)°"
    }
    
    func windSpeed(_ value: Double) -> String {
        let apiUnits = storageService.getUnits()
        let windPref = storageService.getWindUnits()
        
        let metersPerSecond: Double
        if apiUnits == "imperial" {
            metersPerSecond = value * 0.44704
        } else {
            metersPerSecond = value
        }
        
        if windPref == "kmh" {
            return "\(Int((metersPerSecond * 3.6).rounded())) км/ч"
        }
        return "\(Int(metersPerSecond.rounded())) м/с"
    }
}
