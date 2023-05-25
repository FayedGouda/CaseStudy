
import Foundation
import XCTest
@testable import Case_Study

class GamesVCTests: XCTestCase {
    
    private var viewModel:MockGamesViewModel!
    private var mockAPIService:MockGameAPIService!
    private var mockCoordinator:MockCoordinator!
    private var tableView:UITableView!
    private var viewController:GamesVC!
    private let indexPath = IndexPath(row: 0, section: 0)
    override func setUp() {
        super.setUp()
        mockAPIService = MockGameAPIService()
        viewModel = MockGamesViewModel(apiService: mockAPIService)
        mockCoordinator = MockCoordinator(UINavigationController())
        viewModel.coordinator = mockCoordinator
        
        viewController = GamesVC(viewModel: viewModel)
        self.tableView = UITableView()
        tableView.register(GameTableViewCell.cellNib(), forCellReuseIdentifier: GameTableViewCell.identifier)
    }
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    //MARK: - didSelectRowAt
    func test_did_select_row_at_indexPath(){
        viewModel.getGames()
        _ = mockAPIService.mockSuccess()
        _ = viewController.tableView(tableView, cellForRowAt: indexPath) as! GameTableViewCell
        viewController.tableView(tableView, didSelectRowAt: indexPath)
        let selectedModel = viewModel.games[indexPath.row]
        XCTAssertEqual(selectedModel.isSelected, true)
        XCTAssertEqual(selectedModel.id, mockCoordinator.game?.id)
    }
}
