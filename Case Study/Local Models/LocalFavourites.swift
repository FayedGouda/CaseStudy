
import Foundation

/// Mange favourite games localy
class LocalFavourites{
    
    /// Shared instance
    static let shared = LocalFavourites()
    
    /// Key of favourites list in UserDefaults
    private let favouriteGamesKey = "LocalFavourites"
    
    /// A list of favourites
    private var favourites:[Game] = []
    
    private var userDefault = UserDefaults.standard
    
    /// private init to prevent instantiating our class from outside, applying Singletone approach
    private init(){
        userDefault.synchronize()
        self.favourites = self.getFavouriteGamesFromUserDefaults()
    }
    
    
    /// - Returns: List of favourites
    public func getFavourites()->[Game]{
        return self.favourites
    }
    
    /// toggle game favourite
    /// - Parameter game: Game to be toggled (add to favourites, remove from favourites)
    func toggleFavourite(for game:Game, completion: @escaping(Result<Bool, Error>) -> Void){
        let isFound = self.search(for: game)
        if isFound.0 == true, let index = isFound.1{
            favourites.remove(at: index)
            self.saveFavouritesToUserLocalDefaults(favourites) { result in
                completion(result)
            }
        }else{
            var newGame = game
            newGame.isFavourite = true
            favourites.append(newGame)
            self.saveFavouritesToUserLocalDefaults(favourites) { result in
                completion(result)
            }
        }
    }
    
    /// Search for a given game in favourites list
    /// - Parameter game: A game to search for
    /// - Returns: Tuple of( Bool , Int) , Bool: indicate if a game was found or not, Int: index of founded game or nil if no matches
    func search(for game:Game)->(Bool, Int?){
        if let indexOf = favourites.firstIndex(where: {
            return game.id == $0.id
        }){
            return (true, indexOf)
        }else{
            return (false, nil)
        }
    }
    
    /// Save a list of favourites localy to user defaults
    /// - Parameter games: List of favourite games to be saved
    private func saveFavouritesToUserLocalDefaults(_ games:[Game], completion: @escaping(Result<Bool, Error>) -> Void){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(games) {
            userDefault.set(encoded, forKey: favouriteGamesKey)
            completion(.success(true))
        }else{
            completion(.failure(CustomError.userDefaultError("Could not save")))
        }
    }
    
    /// Read lis of favourites from user defaults
    /// - Returns: List of favourite games, or an empty list if no game was favouried
    private func getFavouriteGamesFromUserDefaults()->[Game]{
        guard let favourites = userDefault.object(forKey: favouriteGamesKey) as? Data else { return [] }
        let decoder = JSONDecoder()
        guard let favourites = try? decoder.decode([Game].self, from: favourites) else { return [] }
        return favourites
    }
}
