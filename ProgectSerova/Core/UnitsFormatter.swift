import Foundation

enum UnitsFormatter {
    
    static func temperature(_ value: Double) -> String {
        let units = StorageService.shared.getUnits()
        let intValue = Int(value.rounded())
        return units == "imperial" ? "\(intValue)°F" : "\(intValue)°"
    }
    
    static func windSpeed(_ value: Double) -> String {
        let apiUnits = StorageService.shared.getUnits()
        let windPref = StorageService.shared.getWindUnits()
        
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
