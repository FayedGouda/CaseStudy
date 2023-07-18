
import Foundation

class GamesViewModel:GamesViewModelProtocol{
    
    var gamesSearchResult = [GameProtocol]()
    
    var reloadData: () -> Void = {}
    
    var loading: (Bool) -> Void = {_ in }
    
    var success: (Bool) -> Void = {_ in }
    
    var error: (Error) -> Void = {_ in }
    
    var empty: (Bool) -> Void = {_ in }
    
    var paginationisAllowed:Bool = false
    
    var currentPageNumber:Int = 1
    
    weak var coordinator: GamesCoordinatorProtocol?
    
    internal var apiService: GamesAPIServiceProtocol
    
    var games = [GameProtocol]()
    
    required init(apiService: GamesAPIServiceProtocol) {
        self.apiService = apiService
    }
}
