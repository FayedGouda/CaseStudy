import XCTest
@testable import Case_Study
import Foundation

class MockCoordinator:GamesCoordinatorProtocol{
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    func start() {
        //
    }
    
    var game:GameProtocol!
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func gameDetails(for game: GameProtocol) {
        self.game = game
    }
}
