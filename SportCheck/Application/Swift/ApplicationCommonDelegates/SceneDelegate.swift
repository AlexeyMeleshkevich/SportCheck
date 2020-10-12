import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var splashScreenWindow: UIWindow?
    let userSettings = UserSettings()
    
    var currentWindowScene: UIWindowScene?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let rootController = RootTabBarController()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.currentWindowScene = windowScene
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = rootController
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        if userSettings.showSplashScreen {
            showSplashScreen()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    private func showSplashScreen() {
        guard let windowScene = currentWindowScene else { return }
        splashScreenWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
        let splashScreenViewController = SplashScreenViewController()
        
        splashScreenWindow?.windowScene = windowScene
        splashScreenWindow?.windowLevel = .normal + 1
        splashScreenWindow?.rootViewController = splashScreenViewController
        splashScreenWindow?.backgroundColor = UIColor.clear
        splashScreenWindow?.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideSplashScreen), name: Notification.Name.canHideSplashScreen, object: nil)
    }
    
    @objc private func hideSplashScreen() {
        splashScreenWindow = nil
    }
}

