
import Foundation

class FavouritesViewModel:GamesViewModelProtocol{
    
    var reloadData: () -> Void = {}
    
    var loading: (Bool) -> Void = {_ in }
    
    var success: (Bool) -> Void = {_ in }
    
    var error: (Error) -> Void = {_ in }
    
    var empty: (Bool) -> Void = {_ in }
    
    var coordinator: GamesCoordinatorProtocol?
    
    internal var apiService: GamesAPIServiceProtocol
    
    var games = [GameProtocol]()
    
    required init(apiService: GamesAPIServiceProtocol) {
        self.apiService = apiService
        self.getFavouriteGames()
    }
    

    
}
