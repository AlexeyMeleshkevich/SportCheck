import Foundation
import RxSwift

protocol FootballViewViewModelType {
    var leaguesPublisher: PublishSubject<[LeagueModel]> { get set }
    var currentSeasonPublisher: PublishSubject<Int> { get set }
    var avaliableSeasonsPublisher: PublishSubject<[Int]>  { get set }
    var avaliableSeasonsData: [Int] { get set }
    var leaguesData: Array<LeagueModel> { get set }
    
    func getFootballLeagues(for season: Int)
    func generateViewModelForLeaguesCell(row: Int) -> FootballLeaguesTableViewCellViewModel?
}

enum FootballTableViewCellType {
    case Leagues
    case Matches
}

class FootballViewViewModel: FootballViewViewModelType {
    
    // Reactive objects
    
    var leaguesPublisher: PublishSubject<[LeagueModel]> = PublishSubject<[LeagueModel]>()
    
    var currentSeasonPublisher: PublishSubject<Int> = PublishSubject<Int>()
    
    var avaliableSeasonsPublisher: PublishSubject<[Int]> = PublishSubject<[Int]>()
    
    var avaliableSeasonsData: Array<Int> = []
    
    var leaguesData: Array<LeagueModel> = []
    
    private let disposeBag = DisposeBag()
    
    init() {
        _ = currentSeasonPublisher.subscribe({ [weak self] (event) in
            
            guard let value = event.element else { return }
            
            self?.getFootballLeagues(for: value)
            }).disposed(by: disposeBag)
        
        currentSeasonPublisher.onNext(Date().currentYear)
        
        NetworkingManager.shared.fetch(for: SeasonsModel(), season: nil, from: .Football, .Seasons) { [weak self] (seasonsData, error) in
            
            guard let data = seasonsData?.api.seasons else { return }
            
            self?.avaliableSeasonsData = data
            self?.avaliableSeasonsPublisher.onNext(data)
        }
    }
    
    func getFootballLeagues(for season: Int) {
        NetworkingManager.shared.fetch(for: FootballLeagueModel(), season: season, from: .Football, .Leagues) { [weak self] (footballData, error) in
            guard let apiData = footballData?.api else { return }
            guard let leagues = apiData.leagues else { return }
            for league in leagues {
                print(league.league_id)
            }
            self?.leaguesData = leagues
            self?.leaguesPublisher.onNext(leagues)
        }
    }
    
    func generateViewModelForLeaguesCell(row: Int) -> FootballLeaguesTableViewCellViewModel? {
        _ = leaguesPublisher.map { (leagues) in
            return FootballLeaguesTableViewCellViewModel(league: leagues[row])
        }
        
        return nil
    }
}
