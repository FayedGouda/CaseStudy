
import Foundation

/// Base Interface to help working with game, get, favourites and so onn
protocol GamesViewModelProtocol:AnyObject{
    
    /// coordinator to mange navigation between different views
    var coordinator:GamesCoordinatorProtocol? { get }
    
    /// instance of a type confirming to GamesAPIServiceProtocol protocol
    var apiService:GamesAPIServiceProtocol { get }
    
    var games:[GameProtocol] { get set }
    
    /// Call back closure to tell the view contrller to reload its data
    var reloadData:()->Void { get set }
    
    /// Call back closure to tell the view contrller if its viewModel is doing work like api calls.
    var loading:(Bool)->Void { get set }
    
    /// Call back closure to tell the view contrller if its viewModel is doing work like api calls.
    var success:(Bool)->Void { get set }
    
    /// Call back closure to tell the view contrller if some error occured
    var error:(Error)->Void { get set }
    
    /// Call back closure to tell the view contrller if no data provided
    var empty:(Bool)->Void { get set }
    
    /// Inject confirming type with instance of a type confirming to GamesAPIServiceProtocol protocol
    /// - Parameter apiService: instance of a type confirming to GamesAPIServiceProtocol protocol
    init(apiService: GamesAPIServiceProtocol)
    
    /// Number of games
    /// - Returns: counter of our games
    func numberOfRows()->Int
    
    /// Return cell model
    /// - Parameter indexPath: of a cell for current game
    /// - Returns: a game  for a cell
    func cellGame(for indexPath:IndexPath)->GameProtocol
    
    /// If use select a cell
    /// - Parameter indexPath: index of cell he did select
    func didSelectRow(at indexPath:IndexPath)
    
    func getGames()
    
    /// Search for a game with a name
    /// - Parameter text: Game name string
    func searchGames(for text:String)
    
    /// Toggle game to favourites
    /// - Parameter indexPath: index of the game to toggle
    func toggleFavouriteGame(at indexPath:IndexPath)
}


extension GamesViewModelProtocol{
    
    func numberOfRows()->Int{
        return self.games.count
    }
    
    func cellGame(for indexPath:IndexPath)->GameProtocol{
        return self.games[indexPath.row]
    }
    
    func didSelectRow(at indexPath:IndexPath){
        coordinator?.gameDetails(for: self.games[indexPath.row])
    }
    
    func searchGames(for text:String){
        loading(true)
        let params:JSON = ["page_size":10, "page":1, "key":Config.API_Key, "search":text]
        apiService.search(params: params) { [weak self] result in
            self?.loading(false)
            switch result{
            case .success(let games):
                guard let reuslts = games.games, reuslts.count > 0 else {
                    self?.empty(true)
                    return
                }
                self?.games = reuslts
                self?.reloadData()
            case .failure(let error):
                self?.error(error)
            }
        }
    }
    func getGames(){
        loading(true)
        let params:JSON = ["page_size":10, "page":1, "key":Config.API_Key]
        apiService.getGames(params: params) { [weak self] result in
            self?.loading(false)
            switch result{
            case .success(let games):
                guard let reuslts = games.games, reuslts.count > 0 else {
                    self?.empty(true)
                    return
                }
                self?.games = reuslts
                self?.reloadData()
            case .failure(let error):
                self?.error(error)
            }
        }
    }
    
    func toggleFavouriteGame(at indexPath:IndexPath){
        let game = games[indexPath.row]
        LocalFavourites.shared.toggleFavourite(for: game as! Game) { [weak self] result in
            switch result{
            case .success(let success):
                guard success else {
                    return
                }
                self?.success(true)
            case .failure(let error):
                self?.error(error)
            }
        }
    }
    
    func getFavouriteGames(){
        loading(true)
        apiService.favourites { [weak self] result in
            self?.loading(false)
            switch result{
            case .success(let games):
                guard games.count > 0 else {
                    self?.empty(true)
                    return
                }
                self?.games = games
                self?.reloadData()
            case .failure(let error):
                self?.error(error)
            }
        }
    }
    
}

class GamesViewModel:GamesViewModelProtocol{
    
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
    }
}
