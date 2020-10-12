import Foundation

@propertyWrapper
struct UserDefault<T> {
    var key: String
    var initialValue: T
    var wrappedValue: T {
        set { UserDefaults.standard.set(newValue, forKey: key) }
        get { UserDefaults.standard.object(forKey: key) as? T ?? initialValue }
    }
}
