import Foundation

struct APIShell<T: Codable>: Codable {
    let api: T
}
