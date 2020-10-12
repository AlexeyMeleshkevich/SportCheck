import UIKit
import RxSwift
import RxCocoa

class SettingSteppingView: UIView {
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.alignment = .center
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.spacing = 10
       
        return stack
    }()
    
    public let settingLabel: UILabel = {
        let label = UILabel()
    
        label.text = "Classic"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        return label
    }()
    
    public let settingStepper: UIStepper = {
        let stepper = UIStepper()
        
        stepper.maximumValue = 5
        stepper.minimumValue = 0
        
        return stepper
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setSetting(name: String, initialValue: Int) {
        settingLabel.text = name
        settingLabel.text! += " \(initialValue)"
    }
    
    fileprivate func setupView() {
        pinSubviewAnchors(add: true, subview: stackView)
        
        stackView.addArrangedSubview(settingLabel)
        stackView.addArrangedSubview(settingStepper)
    }
}
