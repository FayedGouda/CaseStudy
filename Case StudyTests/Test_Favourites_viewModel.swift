////
////  Test_Favourites_viewModel.swift
////  Case StudyTests
////
////  Created by ProjectEgy on 23/05/2023.
////
//
//import Foundation
//
//import XCTest
//@testable import Case_Study
//
//class GamesAPIServiceTests: XCTestCase {
//    private var mockAPIService:MockGameAPIService!
//    private var gamesViewModel:GamesViewModelProtocol!
//    
//
//    override func setUp() {
//        super.setUp()
//        mockAPIService = MockGameAPIService()
//        gamesViewModel = GamesViewModel(apiService: mockAPIService)
//    }
//
//    override func tearDown() {
//        gamesViewModel = nil
//        mockAPIService = nil
//        super.tearDown()
//    }
//
//    
//    func test_get_games_service_is_called(){
//        gamesViewModel.getGames()
//        XCTAssert(mockAPIService!.isFetchGamesCalled)
//    }
//    
//    func test_game_details_service_is_called(){
////        gamesViewModel.
//        XCTAssert(mockAPIService!.isFetchGamesCalled)
//    }
//    
//    func test_get_games_service_is_success(){
////        gamesViewModel.getGames()
//        
////        XCTAssertEqual(mockAPIService.isFetchGamesCalled, 1)
//    }
//
//}
