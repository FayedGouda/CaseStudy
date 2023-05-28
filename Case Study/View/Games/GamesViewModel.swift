
import Foundation

/// Base Interface to help working with game, get, favourites and so onn
protocol GamesViewModelProtocol:AnyObject{
    
    /// coordinator to mange navigation between different views
    var coordinator:GamesCoordinatorProtocol? { get }
    
    /// instance of a type confirming to GamesAPIServiceProtocol protocol
    var apiService:GamesAPIServiceProtocol { get }
    
    /// List of games
    var games:[GameProtocol] { get set }
    
    /// List of games
    var gamesSearchResult:[GameProtocol] { get set }
    
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
    
    var paginationisAllowed:Bool { get set }
    
    var currentPageNumber:Int { get set }
    
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
        if paginationisAllowed{
            return gamesSearchResult.count
        }
        return self.games.count
    }
    
    func cellGame(for indexPath:IndexPath)->GameProtocol{
        if paginationisAllowed{
            return gamesSearchResult[indexPath.row]
        }
        return self.games[indexPath.row]
    }
    
    func didSelectRow(at indexPath:IndexPath){
        if paginationisAllowed{
            coordinator?.gameDetails(for: self.gamesSearchResult[indexPath.row])
        }else{
            coordinator?.gameDetails(for: self.games[indexPath.row])
        }
    }
    
    /// Search for names matching of games, first search localy in the our loaded games, if no matches then we search online
    /// - Parameter text: text to match with
    func searchGames(for text:String){
        let offlineResult = self.offlineSearch(for: text)
        if offlineResult.count < 1  {
            self.onlineSearch(for: text)
        }else{
            self.gamesSearchResult = offlineResult
            self.reloadData()
        }

    }
    
    /// Search online for a game with a name
    /// - Parameter text: A name (or subnames) to search with
    private func onlineSearch(for text:String){
        loading(true)
        let params:JSON = ["page_size":10, "page":self.currentPageNumber, "key":Config.API_Key, "search":text]
        apiService.search(params: params) { [weak self] result in
            self?.loading(false)
            switch result{
            case .success(let games):
                guard let reuslts = games.games, reuslts.count > 0 else {
                    self?.empty(true)
                    return
                }
                self?.gamesSearchResult += reuslts
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
                guard var results = games.games, results.count > 0 else {
                    self?.empty(true)
                    return
                }
                //Here we check if fetched games are favorites or not
                //Of course its not the best soluations, this is done as favourite games are stored client-side
                //It would be easy if a game has a property isFavourite to
                for count in 0...results.count - 1{
                    results[count].isFavourite = LocalFavourites.shared.search(for: results[count]).0
                }
                self?.games = results
                self?.reloadData()
            case .failure(let error):
                self?.error(error)
            }
        }
    }
    
    /// Toggling a game to favourites list
    /// - Parameter indexPath: The index of a game to be toggled
    func toggleFavouriteGame(at indexPath:IndexPath){
        let game = games[indexPath.row]
        let isFavourites = game.isFavourite
        LocalFavourites.shared.toggleFavourite(for: game as! Game) { [weak self] result in
            switch result{
            case .success(let success):
                guard success else {
                    return
                }
                self?.games[indexPath.row].isFavourite = !isFavourites
                self?.success(true)
            case .failure(let error):
                self?.error(error)
            }
        }
    }
    
    /// Load our favourite games, for now it gets data from client-side (UserDefaults)
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
                self?.empty(false)
                self?.games = games
                self?.reloadData()
            case .failure(let error):
                self?.error(error)
            }
        }
    }
    
}

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

extension GamesViewModelProtocol {
    
    ///Search localy in the our loaded games for matching games
    /// - Parameter text: A text to match with
    /// - Returns: A list of games founded or empty list if there is no matchs
    private func offlineSearch(for text:String)->[GameProtocol]{
        var founded:[GameProtocol] = []
        for game in games{
            guard let name = game.name else { continue }
            if (name.range(of: text, options: .caseInsensitive) != nil){
                founded.append(game)
            }else{
                continue
            }
        }
        return founded
    }
}
