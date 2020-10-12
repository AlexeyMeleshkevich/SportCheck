import UIKit
import RxSwift

class RootTabBarController: UITabBarController {
    
    let footballViewController = FootballViewController()
    let basketballViewController = BasketballViewController()
    let settingsViewController = SettingsViewController()
    
    let appearance = UITabBarAppearance()
    
    let settings = UserSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
        setupTabBarAppearance()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeTextSize), name: NSNotification.Name.textSizeDidChanged, object: nil)
    }
    
    fileprivate func setupTabBarAppearance() {
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)]
        appearance.stackedItemPositioning = .automatic
        appearance.backgroundColor = UIColor.black
        tabBar.standardAppearance = appearance
        
        UITabBar.appearance().barTintColor = RGBConverter.getColorFrom(0, 0, 0)
        UITabBar.appearance().tintColor = UIColor.yellow
    }
    
    fileprivate func setupControllers() {
        let basketballNavigationController = BaseNavigationController(rootViewController: basketballViewController)
        let footballNavigationController = BaseNavigationController(rootViewController: footballViewController)
        let settingsNavigationController = BaseNavigationController(rootViewController: settingsViewController)
        
        guard let basketballIcon = UIImage(named: "basketballIcon") else { fatalError() }
        guard let footballIcon = UIImage(named: "footballIcon") else { fatalError() }
        
        basketballNavigationController.tabBarItem.image = basketballIcon.withRenderingMode(.alwaysOriginal)
        footballNavigationController.tabBarItem.image = footballIcon.withRenderingMode(.alwaysOriginal)
        settingsNavigationController.tabBarItem.image = UIImage(systemName: "gear")
        
        basketballNavigationController.tabBarItem.selectedImage = UIImage(named: "basketballSelectedIcon")
        footballNavigationController.tabBarItem.selectedImage = UIImage(named: "footballSelectedIcon")
        
        basketballNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 18, left: 15, bottom: 13, right: 15)
        footballNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 18, left: 15, bottom: 13, right: 15)
        
        basketballNavigationController.tabBarItem.title = "Basketball"
        footballNavigationController.tabBarItem.title = "Football"
        settingsNavigationController.tabBarItem.title = "Settings"
        
        setViewControllers([footballNavigationController, basketballNavigationController, settingsNavigationController], animated: true)
    }
    
    @objc func changeTextSize() {
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(9 + settings.applicationTextSize), weight: .regular)]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(9 + settings.applicationTextSize), weight: .bold)]
    }
}
