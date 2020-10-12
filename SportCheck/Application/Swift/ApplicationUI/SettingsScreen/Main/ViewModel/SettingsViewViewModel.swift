import Foundation

class SettingsViewViewModel {
    
    private var userSettings = UserSettings()
    
    var showConstraintsWarnings: Bool {
        didSet {
            userSettings.showConstraintsWarnings = showConstraintsWarnings
        }
    }
    
    var showSplashScreen: Bool {
        didSet {
            userSettings.showSplashScreen = showSplashScreen
            NotificationCenter.default.post(Notification(name: Notification.Name.textSizeDidChanged))
        }
    }
    
    var applicationCommonTextSize: Int {
        didSet {
            userSettings.applicationTextSize = applicationCommonTextSize
        }
    }
    
    init() {
        
        showConstraintsWarnings = userSettings.showConstraintsWarnings
        showSplashScreen = userSettings.showSplashScreen
        applicationCommonTextSize = userSettings.applicationTextSize
    }
}
