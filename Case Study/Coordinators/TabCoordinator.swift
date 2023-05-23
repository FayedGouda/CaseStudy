import UIKit
enum TabBarPage{
    case games
    case favourites
}


class TabCoordinator: NSObject, Coordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.tintColor = .black
        self.tabBarController = .init()
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        let pages: [TabBarPage] = [.games, .favourites]
        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages.map({ self.getTabController($0) })
        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        /// Assign page's controllers
        tabBarController.setViewControllers(tabControllers, animated: false)
        /// Let set index
        tabBarController.selectedIndex = 0
        
        
        /// In this step, we attach tabBarController to navigation controller associated with this coordanator
        navigationController.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navigationController = UINavigationController()
        
        switch page {
        case .games:
            let gamesCoordinator = GamesCoordinator(navigationController)
            gamesCoordinator.start()
            childCoordinators.append(gamesCoordinator)
        case .favourites:
            let favouritesCoordinator = FavouritesCoordinator(navigationController)
            favouritesCoordinator.start()
            childCoordinators.append(favouritesCoordinator)
        }
        return navigationController
    }
}

