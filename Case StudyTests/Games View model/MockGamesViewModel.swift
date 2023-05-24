import XCTest
@testable import Case_Study

import Foundation
class MockGamesViewModel:GamesViewModelProtocol{
    
    weak var coordinator: GamesCoordinatorProtocol?
    
    var apiService: GamesAPIServiceProtocol
    
    var games = [GameProtocol]()
    
    var reloadData: () -> Void = {  }
    
    var loading: (Bool) -> Void = { _ in}
    
    var success: (Bool) -> Void = { _ in}
    
    var error: (Error) -> Void = { _ in}
    
    var empty: (Bool) -> Void = { _ in}
    
    required init(apiService: Case_Study.GamesAPIServiceProtocol) {
        self.apiService = apiService
    }
    var isDidSelectRowAtIndexPathGetCalled = false
}

extension MockGamesViewModel{
    func didSelectRow(at indexPath: IndexPath) {
        isDidSelectRowAtIndexPathGetCalled = true
        coordinator?.gameDetails(for: games[indexPath.row])
    }
}
