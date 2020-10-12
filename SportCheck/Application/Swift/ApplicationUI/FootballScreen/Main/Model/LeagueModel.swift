struct FootballLeagueModel: Codable {
    var results: Int?
    var leagues: [LeagueModel]?
}

struct LeagueModel: Codable {
    let league_id:      Int
    let name:           String 
    let type:           String
    let country:        String
    let country_code:   String?
    let season:         Int
    let season_start:   String
    let season_end:     String
    let logo:           String
    let flag:           String?
    let standings:      Int
    let is_current:     Int
    let coverage:       CoverageModel
}

struct CoverageModel: Codable {
    let standings:   Bool
    let fixtures:    FixturesModel
    let players:     Bool
    let topScorers:  Bool
    let predictions: Bool
    let odds:        Bool
}

struct FixturesModel: Codable {
    let events:             Bool
    let lineups:            Bool
    let statistics:         Bool
    let players_statistics: Bool
}
