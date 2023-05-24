import XCTest
@testable import Case_Study

import Foundation

class MockGameAPIService:GamesAPIServiceProtocol{
    
    var complitionClosure:((Result<MainResponse, Error>) -> Void)!
    var complitionFavouriteGamesClosure:((Result<[GameProtocol], Error>) -> Void)!
    var complitionGameDetailsClosure:((Result<GameDetails, Error>) -> Void)!
    
    var isFetchGamesServiceGetCalled = false
    var isFetchFavouriteGamesServiceGetCalled = false
    var isSearchForAGameServiceGetCalled = false
    var isGameDetailsServiceGetCalled = false
    
    func getGames(params: JSON?, completion: @escaping (Result<MainResponse, Error>) -> Void) {
        isFetchGamesServiceGetCalled = true
        complitionClosure = completion
    }
    
    func search(params: JSON?, completion: @escaping (Result<MainResponse, Error>) -> Void) {
        isFetchGamesServiceGetCalled = true
        print(isFetchGamesServiceGetCalled)
        complitionClosure = completion
    }
    
    func favourites(completion: @escaping (Result<[GameProtocol], Error>) -> Void) {
        isFetchFavouriteGamesServiceGetCalled = true
        complitionFavouriteGamesClosure = completion
    }
    
    func details(id: Int, completion: @escaping (Result<GameDetails, Error>) -> Void) {
        isGameDetailsServiceGetCalled = true
        complitionGameDetailsClosure = completion
    }
    
    
    func mockSuccess()->MainResponse{
        let response = LocalJSON.shared.loadGames()
        if let complitionClosure{
            complitionClosure(.success(response!))
        }
        
        if let complitionFavouriteGamesClosure{
            if let games = response!.games{
                complitionFavouriteGamesClosure(.success(games))
            }
        }
        return response!
    }
    
    func mockGameDetailsSuccess()->GameDetails{
        let response = LocalJSON.shared.loadGameDetails()
        
        if let complitionGameDetailsClosure{
            complitionGameDetailsClosure(.success(response!))
        }
        
        return response!
    }
    
    func mockSuccessWithEmptyList(){
        let jsonText = """
        {
            "results": [ ]
        }
        """
        let jsonData = jsonText.data(using: .utf8)!
        let response = try! JSONDecoder().decode(MainResponse.self, from: jsonData)
        if let complitionClosure{
            complitionClosure(.success(response))
        }
        
        if let complitionFavouriteGamesClosure{
            if let games = response.games{
                complitionFavouriteGamesClosure(.success(games))
            }
        }
    }

    
    func mockFail(with error:Error){
        if let complitionClosure{
            complitionClosure(.failure(error))
        }
        
        if let complitionFavouriteGamesClosure{
            complitionFavouriteGamesClosure(.failure(error))
        }
        
        if let complitionGameDetailsClosure{
            complitionGameDetailsClosure(.failure(error))
        }
    }
}
