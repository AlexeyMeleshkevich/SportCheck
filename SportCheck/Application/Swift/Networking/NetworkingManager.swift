import Foundation

public typealias HTTPHeaders = [String: String]

enum RequestPurpose {
    case Seasons
    case Leagues
    case Matches
}

enum RequestResult {
    case success
    case failure(String)
}

enum NetworkResponseStatusString: String {
    case success
    case authentificationError = "Wrong authentification"
    case badRequest = "Bad request"
    case outdated = "Requested URL is outdated"
    case failed = "Network request failed"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "Couldn't decode data from response"
}

class NetworkingManager {
    
    static let shared = NetworkingManager()
    private init() { }
    
    enum DataTasksKeys: String {
        case FootballLeagues   = "Football.Leagues.DataTask"
        case BasketballLeagues = "Basketball.Leagues.DataTask"
        case FootballMatches   = "Football.Matches.DataTask"
        case BasketballMatches = "Basketball.Matches.DataTask"
        case FootballSeasons   = "Football.Seasons.DataTask"
        case BasketballSeasons = "Basketball.Seasons.DataTask"
        
        func getKey() -> String {
            return self.rawValue
        }
    }
    
    private var dataTasks: [String: URLSessionDataTask?] = [:]
    private var imagesDataTasks: [String: URLSessionDataTask?] = [:]
    
    private let footballApiHeaders: HTTPHeaders = [
        "x-rapidapi-host": "api-football-v1.p.rapidapi.com",
        "x-rapidapi-key": "d3f4042bc4msh3e8baa6aaf0e778p15af52jsn260491400f82"
    ]
    private let basketballApiHeaders: HTTPHeaders = [
        "x-rapidapi-host": "api-basketball-v1.p.rapidapi.com",
        "x-rapidapi-key": "REPLACE ME"
    ]
    
    public func fetch<T: Codable>(for model: T, season: Int?, from api: APIType, _ purpose: RequestPurpose, compelition: @escaping (APIShell<T>?, Error?) -> Void) {
        let endpoint = Endpoint(hyperTextProtocolIsSecure: true, apiType: api, requestPurpose: purpose, seasonYear: season)
        guard let requestURL = endpoint.getEndpointURL() else { return }
        
        let requestModel = RequestModel(url: requestURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0, httpMethod: "GET", headers: getHeadersFor(api))
        
        let urlRequest = NSMutableURLRequest(createRequestFrom: requestModel) as URLRequest
        
        guard let taskKey = generateTaskKey(api, purpose) else { return }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            
            guard error == nil
                else {
                    self?.dataTasks.removeValue(forKey: taskKey);
                    compelition(nil, error)
                    return }
            guard let unwrappedResponse = response as? HTTPURLResponse
                else {
                    self?.dataTasks.removeValue(forKey: taskKey);
                    compelition(nil, error)
                    return }
            guard let unwrappedData = data
                else {
                    self?.dataTasks.removeValue(forKey: taskKey);
                    compelition(nil, error)
                    return }
            
            guard let responseStatus = self?.handleResponse(unwrappedResponse) else { self?.dataTasks.removeValue(forKey: taskKey); return }
            
            switch responseStatus {
            case .success:
                let dataProvider = JSONDataDecoderProvider()
                
                let dataDecodedByModel = dataProvider.decode(data: unwrappedData, by: model)
                
                do {
                    _ = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments)
                } catch {
                    
                }
                
                
                compelition(dataDecodedByModel, nil)
            default:
                break
            }
        }
        
        dataTasks.updateValue(task, forKey: taskKey)
        task.resume()
    }
    
    public func downloadImage(by urlString: String, compelition: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { self.imagesDataTasks.removeValue(forKey: urlString); return }
            compelition(data)
            self.imagesDataTasks.removeValue(forKey: urlString)
        }
        
        imagesDataTasks.updateValue(task, forKey: urlString)
        task.resume()
    }
    
    public func cancelImageDataTask(for url: String) {
        guard let task = imagesDataTasks[url] else { return }
        task?.cancel()
        imagesDataTasks.removeValue(forKey: url)
    }
    
    public func cancelDataTask(from api: APIType, purpose: RequestPurpose) {
        guard let taskKey = generateTaskKey(api, purpose) else { return }
        guard let task = dataTasks[taskKey] else { return }
        task?.cancel()
    }
    
    public func resumeDataTask(from api: APIType, purpose: RequestPurpose) {
        guard let taskKey = generateTaskKey(api, purpose) else { return }
        guard let task = dataTasks[taskKey] else { return }
        task?.resume()
    }
    
    private func generateTaskKey(_ api: APIType, _ purpose: RequestPurpose) -> String? {
        var taskKeyTypeOptional: DataTasksKeys?
        
        switch api {
        case .Basketball:
            switch purpose {
            case .Leagues:
                taskKeyTypeOptional = .BasketballLeagues
            case .Matches:
                taskKeyTypeOptional = .BasketballMatches
            case .Seasons:
                taskKeyTypeOptional = .BasketballSeasons
            }
        case .Football:
            switch purpose {
            case .Leagues:
                taskKeyTypeOptional = .FootballLeagues
            case .Matches:
                taskKeyTypeOptional = .FootballMatches
            case .Seasons:
                taskKeyTypeOptional = .FootballSeasons
            }
        }
        
        guard let taskKeyTypeUnwrapped = taskKeyTypeOptional else { return nil }
        return taskKeyTypeUnwrapped.getKey()
    }
    
    private func handleResponse(_ response: HTTPURLResponse) -> RequestResult {
        switch response.statusCode {
        case 200...299:
            return .success
        case 401...500:
            return .failure(NetworkResponseStatusString.authentificationError.rawValue)
        case 501...599:
            return .failure(NetworkResponseStatusString.badRequest.rawValue)
        case 600:
            return .failure(NetworkResponseStatusString.outdated.rawValue)
        default:
            return .failure(NetworkResponseStatusString.failed.rawValue)
        }
    }
    
    private func getHeadersFor(_ api: APIType) -> HTTPHeaders {
        if api == .Football {
            return footballApiHeaders
        } else {
            return basketballApiHeaders
        }
    }
}

