
import UIKit

class FavouritesCoordinator:GamesCoordinatorProtocol{
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    func start() {
        let viewModel = FavouritesViewModel(apiService: GamesAPIService())
        viewModel.coordinator = self
        let favouritesVC = FavouriteVC(viewModel: viewModel)
        navigationController.pushViewController(favouritesVC, animated: true)
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem.title = "Favourites"
        navigationController.tabBarItem.image = UIImage(named: "favourites")
    }
}
