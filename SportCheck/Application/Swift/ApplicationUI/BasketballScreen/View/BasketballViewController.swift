import UIKit

class BasketballViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCommonUI()
        setupUI()
    }
    
    fileprivate func setupCommonUI() {
        title = "Basketball"
    }
    
    fileprivate func setupUI() {
        configureNavigationItem()
    }
    
    private func configureNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBarButtonAction))
    }
    
    @objc private func searchBarButtonAction() {
        
    }
}
