
import Foundation
/// Protocol defining functions for working with games
protocol GamesAPIServiceProtocol{
    /// Get list of games
    /// - Parameters:
    ///   - params: request paramters
    ///   - completion: completion call back with result of success with a list of games  or failure
    func getGames(params: JSON?, completion: @escaping(Result<MainResponse, Error>) -> Void)
    
    /// Search for a given game name
    /// - Parameters:
    ///   - params: request paramters
    ///   - completion: completion call back with result of success with a list of matched games or failure
    func search(params: JSON?, completion: @escaping(Result<MainResponse, Error>) -> Void)
    
    /// Get list of favourite games:From local not API call
    /// - Parameters:
    ///   - params: request paramters
    ///   - completion: completion call back with result of success with a list of favourite games or failure
    func favourites(completion: @escaping(Result<[GameProtocol], Error>) -> Void)
    
    /// Details for a given id of a game
    /// - Parameters:
    ///   - id: the id of target game
    ///   - completion: completion call back with result of success with game details or failure
    func details(id: Int, completion: @escaping(Result<GameDetails, Error>) -> Void)
}

/// Instance of NetworkManger with target GamesNetworking, confirming to GamesAPIServiceProtocol protocol
class GamesAPIService:NetworkManger<GamesNetworking>, GamesAPIServiceProtocol{
   
    func getGames(params: JSON?, completion: @escaping(Result<MainResponse, Error>) -> Void){
        completion(.success(LocalJSON.shared.loadGames()!))
//        request(for: .getGames, parameters: params) { result in
//            completion(result)
//        }
    }
    
    func search(params: JSON?, completion: @escaping(Result<MainResponse, Error>) -> Void){
        request(for: .search, parameters: params) { result in
            completion(result)
        }
    }

    func favourites(completion: @escaping(Result<[GameProtocol], Error>) -> Void){
        let favourites = LocalFavourites.shared.getFavourites()
        completion(.success(favourites))
    }
    
    func details(id: Int, completion: @escaping(Result<GameDetails, Error>) -> Void){
        request(for: .details(id: id)) { result in
            completion(result)
        }
    }
}
