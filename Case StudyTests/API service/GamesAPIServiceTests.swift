
import XCTest
@testable import Case_Study

class GamesAPIServiceTests: XCTestCase {
    private var mockAPIService:MockGameAPIService!
    private var gamesViewModel:GamesViewModelProtocol!
    private var gameDetailsViewModel:GameDetailsViewModel!
    private var testingError:Error?
    private var testingIsEmpty:Bool?
    private var testingMockedGameDetails:GameDetails?

    override func setUp() {
        super.setUp()
        mockAPIService = MockGameAPIService()
        gamesViewModel = GamesViewModel(apiService: mockAPIService)
        let response = mockAPIService.mockSuccess()
        if let games = response.games{
            gameDetailsViewModel = GameDetailsViewModel(game: games[0], apiService: mockAPIService)
        }
        bindMockedData()
    }
    
    private func bindMockedData(){
        
        gamesViewModel.error = { [weak self] error in
            self?.testingError = error
        }
        
        gamesViewModel.empty = { [weak self] isEmpty in
            self?.testingIsEmpty = isEmpty
        }
        
        gameDetailsViewModel.error = { [weak self] error in
            self?.testingError = error
        }
        
        gameDetailsViewModel.loadGameDetails = { [weak self] game in
            self?.testingMockedGameDetails = game
            
        }
    }

    override func tearDown() {
        gamesViewModel = nil
        mockAPIService = nil
        super.tearDown()
    }

    //MARK: - Fetching games
    func test_fetch_games_service_is_called(){
        gamesViewModel.getGames()
        XCTAssert(mockAPIService!.isFetchGamesServiceGetCalled)
    }

    
    func test_fetch_games_service_is_success(){
        
        gamesViewModel.getGames()
        let mockedResult = mockAPIService.mockSuccess()
        let favourites = gamesViewModel.games
        if let id = favourites[0].id{
            XCTAssertEqual(id, 3498)}
        if let mockedGames = mockedResult.games{
            XCTAssertEqual(favourites[0].name, mockedGames[0].name)
            XCTAssertEqual(favourites[0].metacritic, mockedGames[0].metacritic)
        }
    }
    
    func test_fetch_games_service_is_empty_list(){
        
        gamesViewModel.getGames()
        mockAPIService.mockSuccessWithEmptyList()
        let favourites = gamesViewModel.games
        XCTAssertEqual(self.testingIsEmpty, true)
        XCTAssertEqual(favourites.count, 0)
    }
    
    func test_fetch_games_service_is_fail(){
        let genratedError = NetworkError.InternalServerError
        gamesViewModel.getGames()
        mockAPIService.mockFail(with: genratedError)
        XCTAssertEqual(genratedError.localizedDescription, self.testingError?.localizedDescription)
    }
    
    //MARK: - Favourite games
    func test_fetch_favourite_games_service_is_called(){
        gamesViewModel.getFavouriteGames()
        XCTAssert(mockAPIService!.isFetchFavouriteGamesServiceGetCalled)
    }

    
    func test_fetch_favourite_games_service_is_success(){
        
        gamesViewModel.getFavouriteGames()
        let mockedResult = mockAPIService.mockSuccess()
        let favourites = gamesViewModel.games
        if let id = favourites[0].id{
            XCTAssertEqual(id, 3498)
        }
        if let mockedGames = mockedResult.games{
            XCTAssertEqual(favourites[0].name, mockedGames[0].name)
            XCTAssertEqual(favourites[0].metacritic, mockedGames[0].metacritic)
        }
    }
    
    func test_fetch_favourite_games_service_is_empty_list(){
        
        gamesViewModel.getFavouriteGames()
        mockAPIService.mockSuccessWithEmptyList()
        let favourites = gamesViewModel.games
        XCTAssertEqual(self.testingIsEmpty, true)
        XCTAssertEqual(favourites.count, 0)
    }
    
    func test_fetch_favourite_games_service_is_fail(){
        let genratedError = NetworkError.InternalServerError
        gamesViewModel.getFavouriteGames()
        mockAPIService.mockFail(with: genratedError)
        XCTAssertEqual(genratedError.localizedDescription, testingError?.localizedDescription)

    }
    
    func test_search_for_a_game_service_is_success(){
        
        gamesViewModel.searchGames(for: "Theft")
        let mockedResult = mockAPIService.mockSuccess()
        let searchResult = gamesViewModel.gamesSearchResult
        if let id = searchResult[0].id{
            XCTAssertEqual(id, 3498)}
        if let mockedGames = mockedResult.games{
            XCTAssertEqual(searchResult[0].name, mockedGames[0].name)
            XCTAssertEqual(searchResult[0].metacritic, mockedGames[0].metacritic)
        }
    }
    
    func test_search_for_a_game_service_is_empty_list(){
        
        gamesViewModel.searchGames(for: "Theft")
        mockAPIService.mockSuccessWithEmptyList()
        let searchResult = gamesViewModel.gamesSearchResult
        XCTAssertEqual(self.testingIsEmpty, true)
        XCTAssertEqual(searchResult.count, 0)
    }
    
    func test_search_for_a_game_service_is_fail(){
        let genratedError = NetworkError.InternalServerError
        gamesViewModel.searchGames(for: "Theft")
        mockAPIService.mockFail(with: genratedError)
        XCTAssertEqual(genratedError.localizedDescription, testingError?.localizedDescription)
    }
    
    //MARK: - Game Details
    func test_game_details_service_is_called(){
        gameDetailsViewModel.getGameDetails()
        XCTAssert(mockAPIService!.isGameDetailsServiceGetCalled)
    }

    
    func test_sgame_details_service_is_success(){
        gameDetailsViewModel.getGameDetails()
        let mockedResult = mockAPIService.mockGameDetailsSuccess()
        XCTAssertEqual(self.testingMockedGameDetails?.name, mockedResult.name)
        XCTAssertEqual(self.testingMockedGameDetails?.id, 3498)
    }
    
    func test_game_details_service_is_fail(){
        let genratedError = NetworkError.InternalServerError
        gameDetailsViewModel.getGameDetails()
        mockAPIService.mockFail(with: genratedError)
        XCTAssertEqual(genratedError.localizedDescription, testingError?.localizedDescription)
    }
    
    //MARK: - Game Details
}
