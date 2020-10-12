import Foundation

enum APIType: String {
    case Basketball = "api-basketball.p.rapidapi.com/v2"
    case Football = "api-football-v1.p.rapidapi.com/v2"
}

enum APIPathes {
    enum FootballPathes: String {
        case Seasons = "/seasons"
        case Leagues = "/leagues/season/"
        case Matches = ""
    }
    
    enum BasketballPathes: String {
        case Seasons = ""
        case Leagues = "leaguesPath"
        case Matches = "matchesPath"
    }
}

protocol EndpointType {
    var hyperTextProtocolIsSecure: Bool { get }
    var apiType: APIType { get }
    var requestPurpose: RequestPurpose { get }
    var protocolString: String { get }
    var baseStringURL: String { get }
    var requestPath: String { get }
    var seasonYear: Int? { get }
    
    func getEndpointURL() -> URL?
}

struct Endpoint: EndpointType {
    
    var hyperTextProtocolIsSecure: Bool
    
    var apiType: APIType
    
    var requestPurpose: RequestPurpose
    
    var seasonYear: Int?
    
    var protocolString: String {
        if hyperTextProtocolIsSecure {
            return "https://"
        } else {
            return "http://"
        }
    }
    
    var baseStringURL: String {
        return protocolString + apiType.rawValue
    }
    
    var requestPath: String {
        switch apiType {
        case .Basketball:
            switch requestPurpose {
            case .Seasons:
                return APIPathes.BasketballPathes.Seasons.rawValue
            case .Leagues:
                return APIPathes.BasketballPathes.Leagues.rawValue
            case .Matches:
                return APIPathes.BasketballPathes.Matches.rawValue
            }
        case .Football:
            switch requestPurpose {
            case .Seasons:
                return APIPathes.FootballPathes.Seasons.rawValue
            case .Leagues:
                return APIPathes.FootballPathes.Leagues.rawValue
            case .Matches:
                return APIPathes.FootballPathes.Matches.rawValue
            }
        }
    }
    
    func getEndpointURL() -> URL? {
        
        if let season = seasonYear {
            return URL(string: baseStringURL + requestPath + String(season))
        }
        
        return URL(string: baseStringURL + requestPath)
    }
}
