import Foundation

protocol SearchViewProtocol: AnyObject {
    func display(items: [String], isHistory: Bool)
    func closeSearch()
}
