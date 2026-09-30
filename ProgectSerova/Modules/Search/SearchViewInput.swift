import Foundation

protocol SearchViewInput: AnyObject {
    func display(items: [String], isHistory: Bool)
    func closeSearch()
}


