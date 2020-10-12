import Foundation

protocol FootballTableViewCellViewModelType {
    
}

class FootballLeaguesTableViewCellViewModel: FootballTableViewCellViewModelType {
    
    var cellData: LeagueTableViewCellDataModel!
    
    var leagueName: String!
    var leagueImageURL: String!
    var leagueIsActive: Bool!
    var leagueCountry: String!
    var leagueStartDate: String!
    var leagueEndDate: String!
    
    init(league: LeagueModel) {
        self.cellData = createCellDataModelFrom(league)
        
        self.leagueName = cellData.leagueName
        self.leagueImageURL = cellData.leagueImageURL
        self.leagueIsActive = cellData.leagueIsActive
        self.leagueCountry = cellData.leagueCountry
        self.leagueStartDate = cellData.leagueStartDate
        self.leagueEndDate = cellData.leagueEndDate
    }
    
    public func getImage(compelition: @escaping (Data?) -> Void) {
        NetworkingManager.shared.downloadImage(by: leagueImageURL) { (data) in
            guard let data = data else { compelition(self.getErrorImage()); return }
            compelition(data)
        }
    }
    
    public func removeImageDataTask() {
        NetworkingManager.shared.cancelImageDataTask(for: leagueImageURL)
    }
    
    private func getErrorImage() -> Data? {
        let urlOptional = Bundle.main.url(forResource: "noImage", withExtension: ".jpg")
        guard let urlUnwrapped = urlOptional else { return nil }
        
        do {
            let data = try Data(contentsOf: urlUnwrapped)
            
            return data
        } catch {
            return nil
        }
    }
    
    private func createCellDataModelFrom(_ league: LeagueModel) -> LeagueTableViewCellDataModel {
        let cellDataModel = LeagueTableViewCellDataModel(leagueName: league.name, leagueImageURL: league.logo, leagueIsActive: DateComparer.isActive(league.season_start, league.season_end) ?? false, leagueCountry: league.country, leagueStartDate: league.season_start, leagueEndDate: league.season_end)
        
        return cellDataModel
    }
}
