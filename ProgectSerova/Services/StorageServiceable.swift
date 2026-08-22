import Foundation

protocol StorageServiceable {
    func getSearchHistory() -> [String]
    func addToHistory(_ city: String)
    func clearHistory()
    func deleteFromHistory(at index: Int)
    func getLastCity() -> String
    func saveLastCity(_ city: String)
    func getUnits() -> String
    func isDarkTheme() -> Bool
    func saveUnits(_ units: String)
    func saveTheme(_ isDark: Bool)
    func getWindUnits() -> String
    func saveWindUnits(_ units: String)
}
