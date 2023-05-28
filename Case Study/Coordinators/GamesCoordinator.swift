
import UIKit

protocol GamesCoordinatorProtocol:Coordinator{
    func gameDetails(for game:GameProtocol)
}

extension GamesCoordinatorProtocol{
    func gameDetails(for game:GameProtocol){
        let viewModel = GameDetailsViewModel(game: game, apiService: GamesAPIService())
        let vc = GameDetailsVC(viewModel: viewModel)
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}

class GamesCoordinator:GamesCoordinatorProtocol{
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
            
    func start() {
        let viewModel = GamesViewModel(apiService: GamesAPIService())
        viewModel.coordinator = self
        let vc = GamesVC(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem.title = "Games"
        navigationController.tabBarItem.image = UIImage(named: "games")
    }
}
