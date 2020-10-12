import Foundation

struct UserSettings {
    @UserDefault(key: UserDefaultsKeys.shouldShowSplashScreen, initialValue: false)
    var showSplashScreen: Bool
    @UserDefault(key: UserDefaultsKeys.applicationTextSize, initialValue: 0)
    var applicationTextSize: Int
    @UserDefault(key: UserDefaultsKeys.debugConsoleConstraintsWarnings, initialValue: false)
    var showConstraintsWarnings: Bool
}
