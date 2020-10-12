import Foundation

struct RequestModel {
    let url: URL
    let cachePolicy: NSURLRequest.CachePolicy
    let timeoutInterval: Double
    let httpMethod: String
    let headers: HTTPHeaders
}
