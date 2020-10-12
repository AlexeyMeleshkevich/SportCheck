import UIKit

class BaseNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupNavigationBarAppearance()
    }
    
    private func setupNavigationBarAppearance() {
        navigationBar.prefersLargeTitles = true
        navigationBar.isTranslucent = false
        navigationBar.isOpaque = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.black
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.yellow]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.yellow]

        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
