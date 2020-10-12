import UIKit
import KRProgressHUD
import RxSwift
import RxCocoa

class FootballViewController: UIViewController {
    
    private var viewModel: FootballViewViewModelType!
    
    // MARK: UI components
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let containerBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private let picker = UIPickerView()
    private let searchBar = UISearchBar()
    
    // MARK: Reactive objects
    
    private var searchSuite: (PublishSubject<Bool>, Bool) = (PublishSubject(), true)
    private var pickerSuite: (PublishSubject<Bool>, Bool) = (PublishSubject(), true)
    
    private let disposeBag = DisposeBag()
    
    // MARK: Utils for UI
    
    enum BarStyle {
        case large
        case collapsed
    }
    
    private var observer: NSKeyValueObservation?
    
    private var currentBarStyle: BarStyle = .large
    
    private var searchBarHeightAnchor: NSLayoutConstraint!
    
    private let pickerAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KRProgressHUD.showOn(self).show()
        setupCommonUI()
        setupUI()
        
        viewModel = FootballViewViewModel()
        
        configureSubscribes()
        
        self.observer = self.navigationController?.navigationBar.observe(\.bounds, options: [.new], changeHandler: { (navigationBar, changes) in
            if let height = changes.newValue?.height {
                if height > 44.0 {
                    self.currentBarStyle = .large
                } else {
                    self.currentBarStyle = .collapsed
                }
            }
        })
    }
    
    // MARK: Configuring screen UI
    
    fileprivate func setupCommonUI() {
        title = "Football"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        addSubviews()
        
        configureTableView()
        configureNavigationItem()
        configureSearchBar()
        configurePickerContainer()
    }
    
    private func addSubviews() {
        let subviewsArray = [tableView, searchBar, containerBlurView]
        
        for subview in subviewsArray {
            view.addSubview(subview)
        }
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.isHidden = false
        tableView.rowHeight = 150
        
        let cellNib = UINib(nibName: "FootballLeaguesTableViewCellView", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CellsIdentifiers.TableViewCells.FootballLeaguesTableViewCell.rawValue)
        
        setTableViewConstraints()
    }
    
    private func configureNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBarButtonAction))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "\(Date().currentYear)", style: .plain, target: self, action: #selector(seasonBarButtonAction))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "GeezaPro", size: 15)!], for: .normal)
    }
    
    private func configureSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.barStyle = .default
        searchBar.placeholder = "Enter league name here"
        searchBar.isTranslucent = false
        searchBar.searchTextField.delegate = self
        searchBar.barTintColor = UIColor.white
        searchBar.backgroundColor = UIColor.white
        searchBar.tintColor = UIColor.black
        
        setSearchBarContraints()
    }
    
    private func configurePickerContainer() {
        containerBlurView.frame = CGRect(x: view.minXFrame, y: view.maxYFrame, width: view.frame.width, height: 280)
        let toolbar = getToolbalForDatePicker()
        
        picker.rx.itemSelected.asObservable().subscribe(onNext: { [weak self] item in
            guard let viewModel = self?.viewModel else { return }
            
            viewModel.currentSeasonPublisher.onNext(viewModel.avaliableSeasonsData[item.row])
        }).disposed(by: disposeBag)
        
        containerBlurView.contentView.addSubview(picker)
        containerBlurView.contentView.addSubview(toolbar)
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: containerBlurView.contentView.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: containerBlurView.contentView.trailingAnchor),
            picker.topAnchor.constraint(equalTo: containerBlurView.contentView.topAnchor),
            picker.bottomAnchor.constraint(equalTo: containerBlurView.contentView.bottomAnchor),
            toolbar.trailingAnchor.constraint(equalTo: containerBlurView.contentView.trailingAnchor),
            toolbar.leadingAnchor.constraint(equalTo: containerBlurView.contentView.leadingAnchor),
            toolbar.topAnchor.constraint(equalTo: containerBlurView.contentView.topAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func getToolbalForDatePicker() -> UIToolbar {
        let toolbar = UIToolbar()
        
        toolbar.layer.backgroundColor = UIColor.black.cgColor
        toolbar.barTintColor = UIColor.black
        toolbar.tintColor = UIColor.yellow
        
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(seasonBarButtonAction))
        ]
        
        return toolbar
    }
    
    // MARK: - Constraints
    
    private func setTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setSearchBarContraints() {
        searchBarHeightAnchor = searchBar.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarHeightAnchor
        ])
    }
    
    // MARK: Reactive subscribes
    
    fileprivate func configureSubscribes() {
        // data subscribes
        viewModel.leaguesPublisher.observeOn(MainScheduler.instance).bind(to: tableView.rx.items(cellIdentifier: CellsIdentifiers.TableViewCells.FootballLeaguesTableViewCell.rawValue)) { [weak self] row, league, cellFromFactory in
            if cellFromFactory is FootballLeaguesTableViewCellView {
                guard let rxLeagueCell = cellFromFactory as? FootballLeaguesTableViewCellView else { return }
                
                rxLeagueCell.viewModel = FootballLeaguesTableViewCellViewModel(league: league)
                
                KRProgressHUD.dismiss()
                self?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            }
        }.disposed(by: disposeBag)
        
        viewModel.currentSeasonPublisher.subscribe { [weak self] (nextEvent) in
            self?.navigationItem.leftBarButtonItem?.title = "\(nextEvent.element ?? Date().currentYear)"
        }.disposed(by: disposeBag)
        
        viewModel.avaliableSeasonsPublisher.observeOn(MainScheduler.instance).bind(to: picker.rx.itemAttributedTitles) { _, item in
            return NSAttributedString(string: "\(item)",
                                      attributes: [
                                        NSAttributedString.Key.foregroundColor: UIColor.black,
                                        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
                                    ])
        }
        .disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .subscribe { [unowned self] (nextEvent) in
                guard let string = nextEvent.element else { return }
                dprint(string)
                
                self.viewModel.leaguesPublisher.onNext(self.viewModel.leaguesData.filter { $0.name.hasPrefix(string) })
        }.disposed(by: disposeBag)
        
        // UI subscribes
        searchSuite.0.subscribe({ (event) in
            UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                guard let active = event.element else { return }
                
                if active {
                    self.searchBarHeightAnchor.constant = 50
                    self.view.becomeFirstResponder()
                } else {
                    self.searchBarHeightAnchor.constant = 0
                    self.view.endEditing(true)
                }
                self.view.layoutIfNeeded()
            }) { (_) in
                return
            }
        }).disposed(by: disposeBag)
        
        pickerSuite.0.observeOn(MainScheduler.instance).subscribe { (event) in
            guard let active = event.element else { return }
            
            if active {
                self.pickerAnimator.addAnimations {
                    self.containerBlurView.frame = CGRect(x: self.view.minXFrame, y: self.view.maxYFrame - 350, width: self.view.frame.width, height: 350)
                }
                
                self.pickerAnimator.startAnimation()
            } else {
                self.pickerAnimator.addAnimations {
                    self.containerBlurView.frame = CGRect(x: self.view.minXFrame, y: self.view.maxYFrame, width: self.view.frame.width, height: 350)
                }
                
                self.pickerAnimator.startAnimation()
            }
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe { [weak self] (indexPath) in
            let leagueMatchesController = LeagueMatchesViewController()
            self?.navigationController?.pushViewController(leagueMatchesController, animated: true)
            guard let barStyle = self?.currentBarStyle else { return }
            if barStyle == .collapsed {
                leagueMatchesController.navigationItem.largeTitleDisplayMode = .never
            } else {
                leagueMatchesController.navigationItem.largeTitleDisplayMode = .always
            }
        }.disposed(by: disposeBag)
        
    }
    
    // MARK: - Objective-C methods
    
    @objc private func searchBarButtonAction() {
        searchSuite.0.onNext(searchSuite.1)
        searchSuite.1.toggle()
    }
    
    @objc private func seasonBarButtonAction() {
        pickerSuite.0.onNext(pickerSuite.1)
        pickerSuite.1.toggle()
    }
    
    // MARK: Touches methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.location(in: containerBlurView).y > 0 {
                containerBlurView.frame = CGRect(x: self.view.minXFrame, y: touch.location(in: view).y, width: self.view.frame.width, height: 350)
                
            }
            
            if view.maxYFrame - touch.location(in: view).y < 400 {
                containerBlurView.frame = CGRect(x: self.view.minXFrame, y: touch.location(in: view).y, width: self.view.frame.width, height: 350)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if view.maxYFrame - touch.location(in: view).y < 250 {
                pickerSuite.0.onNext(pickerSuite.1)
                pickerSuite.1.toggle()
            } else {
                self.pickerAnimator.addAnimations {
                    self.containerBlurView.frame = CGRect(x: self.view.minXFrame, y: self.view.maxYFrame - 350, width: self.view.frame.width, height: 350)
                }
                self.pickerAnimator.startAnimation()
            }
        }
    }
}

extension FootballViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        searchSuite.0.onNext(searchSuite.1)
        searchSuite.1.toggle()
        return false
    }
}
