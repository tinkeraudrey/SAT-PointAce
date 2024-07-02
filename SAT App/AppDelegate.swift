import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Replace ViewController1 with your initial view controller
        let navController = UINavigationController(rootViewController: ViewController1())
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}
