
import Foundation
/// Api functions for working with games
protocol GamesAPIServiceProtocol{
    func getGames(params: JSON?, completion: @escaping(Result<MainResponse, Error>) -> Void)
    func search(params: JSON?, completion: @escaping(Result<MainResponse, Error>) -> Void)
    func favourites(completion: @escaping(Result<[GameProtocol], Error>) -> Void)
    func details(id: Int, completion: @escaping(Result<GameDetails, Error>) -> Void)
}

/// Instance of NetworkManger with target GamesNetworking, confirming to GamesAPIServiceProtocol protocol
class GamesAPIService:NetworkManger<GamesNetworking>, GamesAPIServiceProtocol{
   
    /// Get list of games
    /// - Parameters:
    ///   - params: request paramters
    ///   - completion: completion call back with result of success or failure
    func getGames(params: JSON?, completion: @escaping(Result<MainResponse, Error>) -> Void){
        request(for: .getGames, parameters: params) { result in
            completion(result)
        }
    }
    
    /// Search for a given game name
    /// - Parameters:
    ///   - params: request paramters
    ///   - completion: completion call back with result of success or failure
    func search(params: JSON?, completion: @escaping(Result<MainResponse, Error>) -> Void){
        request(for: .search, parameters: params) { result in
            completion(result)
        }
    }
    
    /// Get list of favourite games:From local not API call
    /// - Parameters:
    ///   - params: request paramters
    ///   - completion: completion call back with result of success or failure
    func favourites(completion: @escaping(Result<[GameProtocol], Error>) -> Void){
        
        let favourites = LocalFavourites.shared.getFavourites()
        completion(.success(favourites))
    }
    
    
    /// Details for a given id of a game
    /// - Parameters:
    ///   - id: the id of target game
    ///   - completion: completion call back with result of success or failure
    func details(id: Int, completion: @escaping(Result<GameDetails, Error>) -> Void){
        request(for: .details(id: id)) { result in
            completion(result)
        }
    }
}
