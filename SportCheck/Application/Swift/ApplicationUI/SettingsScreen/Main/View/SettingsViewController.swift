import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {
    
    let viewModel = SettingsViewViewModel()
    
    private let settingsListView = ListView()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCommonUI()
        setUI()
    }
    
    fileprivate func setCommonUI() {
        title = "Settings"
    }
    
    fileprivate func setUI() {
        setupListView()
        
        configureListViews()
    }
    
    private func configureListViews() {
        let splashScreenSettingView = SettingsViewsFactory.produceView(with: .toggler) as! SettingTogglingView
        let fontSizeSettingView = SettingsViewsFactory.produceView(with: .stepper) as! SettingSteppingView
        let constraintsSettingView = SettingsViewsFactory.produceView(with: .toggler) as! SettingTogglingView
        
        settingsListView.addCell(view: splashScreenSettingView)
        settingsListView.addCell(view: constraintsSettingView)
        settingsListView.addCell(view: fontSizeSettingView)
        
        splashScreenSettingView.setSetting(name: "Show launchscreen", initialValue: viewModel.showSplashScreen)
        fontSizeSettingView.setSetting(name: "Text size", initialValue: viewModel.applicationCommonTextSize)
        constraintsSettingView.setSetting(name: "Show constraints warnings", initialValue: viewModel.showConstraintsWarnings)
        
        splashScreenSettingView.settingSwitcher.rx.controlEvent([.valueChanged]).subscribe { [weak self] (_) in
            let tempValue = splashScreenSettingView.settingSwitcher.isOn
            
            self?.viewModel.showSplashScreen = tempValue
        }.disposed(by: disposeBag)
        
        constraintsSettingView.settingSwitcher.rx.controlEvent([.valueChanged]).subscribe { [weak self] (_) in
            let tempValue = constraintsSettingView.settingSwitcher.isOn
            
            self?.viewModel.showConstraintsWarnings = tempValue
        }.disposed(by: disposeBag)
        
        fontSizeSettingView.settingStepper.rx.controlEvent([.valueChanged]).subscribe { [weak self] (_) in
            let tempValue = fontSizeSettingView.settingStepper.value
            fontSizeSettingView.settingLabel.text = "Text size \(Int(tempValue))"
            
            self?.viewModel.applicationCommonTextSize = Int(tempValue)
        }.disposed(by: disposeBag)
    }
    
    private func setupListView() {
        let listViewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        settingsListView.frame = listViewFrame
        
        let contentWidth = settingsListView.bounds.width
        let contentHeight = settingsListView.bounds.height - 100
        settingsListView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        view.addSubview(settingsListView)
        
        settingsListView.showsVerticalScrollIndicator = false
        
        settingsListView.translatesAutoresizingMaskIntoConstraints = false
        
        view.pinSubviewAnchors(add: true, subview: settingsListView)
    }
}

enum SettingViewAccessoryView {
    case toggler
    case stepper
}

fileprivate struct SettingsViewsFactory {
    static func produceView(with accessory: SettingViewAccessoryView) -> UIView {
        switch accessory {
        case .stepper:
            return SettingSteppingView()
        case .toggler:
            return SettingTogglingView()
        }
    }
}
