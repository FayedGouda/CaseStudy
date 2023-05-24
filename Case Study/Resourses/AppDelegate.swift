
import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    /// Instance of TabCoordinator to be the root of the app.
    var appCoordinator:TabCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        showMainAppView()
        return true
    }
    
    /// Navigate the app to our TabCoordinator
    private func showMainAppView(){
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let navigationController: UINavigationController = .init()
       
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        appCoordinator = TabCoordinator.init(navigationController)
        appCoordinator?.start()
    }
}
