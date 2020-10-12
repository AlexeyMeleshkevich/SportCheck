import UIKit

class FootballLeaguesTableViewCellView: UITableViewCell {
    
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueIsActiveIndicator: UIView!
    @IBOutlet weak var leagueCountrylabel: UILabel!
    @IBOutlet weak var leagueStartDateLabel: UILabel!
    @IBOutlet weak var leagueEndDateLabel: UILabel!
    
    public var viewModel: FootballLeaguesTableViewCellViewModel! {
        didSet {
            bind()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel.removeImageDataTask()
        leagueImageView.image = nil
    }
    
    public func bind() {
        leagueCountrylabel.text = viewModel.leagueCountry
        leagueStartDateLabel.text = viewModel.leagueStartDate
        leagueEndDateLabel.text = viewModel.leagueEndDate
        leagueNameLabel.text = viewModel.leagueName
        
        if viewModel.leagueIsActive {
            leagueIsActiveIndicator.backgroundColor = UIColor.systemGreen
        } else {
            leagueIsActiveIndicator.backgroundColor = UIColor.systemYellow
        }
        
        if let image = ImagesCacher.shared.checkCache(for: viewModel.leagueImageURL) {
            leagueImageView.image = image
        } else {
            viewModel.getImage { (data) in
                DispatchQueue.main.async { [weak self] in
                    guard let imageData = data else { self?.leagueImageView.image = nil; return }
                    let uiImage = UIImage(data: imageData)
                    self?.leagueImageView.image = uiImage
                    guard let key = self?.viewModel.leagueImageURL else { return }
                    uiImage?.cache(by: key)
                }
            }
        }
    }
}
