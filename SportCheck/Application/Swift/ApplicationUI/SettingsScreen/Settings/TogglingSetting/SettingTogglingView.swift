import UIKit
import RxSwift
import RxCocoa

class SettingTogglingView: UIView {
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .equalCentering
       
        return stack
    }()
    
    private let settingLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Classic"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        return label
    }()
    
    public let settingSwitcher: UISwitch = {
        let switcher = UISwitch()
        
        return switcher
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setSetting(name: String, initialValue: Bool) {
        settingLabel.text = name
        settingSwitcher.isOn = initialValue
    }
    
    fileprivate func setupView() {
        pinSubviewAnchors(add: true, subview: stackView)
        
        stackView.addArrangedSubview(settingLabel)
        stackView.addArrangedSubview(settingSwitcher)
    }
}
