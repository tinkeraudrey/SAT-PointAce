import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = createTabBarController()
        window?.makeKeyAndVisible()
    }
    
    func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let firstViewController = ViewController1()
        let secondViewController = ViewController2()
        let thirdViewController = ViewController3()
        
        firstViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "star"), selectedImage: nil)
        secondViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus"), selectedImage: nil)
        thirdViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "exclamationmark"), selectedImage: nil)
        
        tabBarController.viewControllers = [firstViewController, secondViewController, thirdViewController]
        
        return tabBarController
    }
}
