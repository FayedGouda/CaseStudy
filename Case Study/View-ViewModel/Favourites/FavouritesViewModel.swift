
import Foundation

/// A view model resposible for favourite games, it confirms to GamesViewModelProtocol
class FavouritesViewModel:GamesViewModelProtocol{
    
    var gamesSearchResult = [GameProtocol]()
    
    var currentPageNumber: Int = 1
    
    var paginationisAllowed: Bool = false
    
    var reloadData: () -> Void = {}
    
    var loading: (Bool) -> Void = {_ in }
    
    var success: (Bool) -> Void = {_ in }
    
    var error: (Error) -> Void = {_ in }
    
    var empty: (Bool) -> Void = {_ in }
    
    weak var coordinator: GamesCoordinatorProtocol?
    
    internal var apiService: GamesAPIServiceProtocol
    
    var games = [GameProtocol]()
    
    required init(apiService: GamesAPIServiceProtocol) {
        self.apiService = apiService
        self.getFavouriteGames()
    }
}
