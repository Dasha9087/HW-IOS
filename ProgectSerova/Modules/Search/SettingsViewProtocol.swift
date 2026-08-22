import Foundation

protocol SettingsViewProtocol: AnyObject {
    func updateUnits(_ units: String)
    func updateTheme(_ isDark: Bool)
}
