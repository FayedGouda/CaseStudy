
import UIKit

class GamesVC: UIViewController {
    
    private weak var searchBar:UISearchBar!
    private weak var games:UITableView!
    private weak var indicator:UIActivityIndicatorView!
    private weak var emptyErrorLabel:UILabel!
    
    private var viewModel:GamesViewModelProtocol!
    private var currentPageNumber = 1
    private var gamesCounter:Int = 0
    init(viewModel:GamesViewModelProtocol){
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setUpConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        setUpConfigurations()
        viewModel.getGames()
    }
    
    private func bindData(){
        
        viewModel.loading = { [weak self ] isLoading in
            self?.indicator.showIndicator(isLoading)
//            self?.games.isHidden = isLoading
        }
        
        viewModel.reloadData = { [weak self] in
            self?.games.reloadData()
        }
    }
    
    private func setUpConfigurations(){
        
        title = "Games"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        
        //MARK: - SearchBar
        searchBar.placeholder = "Search for the games"
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        
        
        games.delegate = self
        games.dataSource = self
        games.register(GameTableViewCell.cellNib(), forCellReuseIdentifier: GameTableViewCell.identifier)
    }
    
    private func setUpConstraints(){
        //MARK: - searchBar
        let search = UISearchBar(frame: .zero)
        search.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(search)
        
        NSLayoutConstraint.activate([
            search.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            search.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            search.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            search.heightAnchor.constraint(equalToConstant: 50)
        ])
        self.searchBar = search
        
        //MARK: - options
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: search.bottomAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        tableView.allowsMultipleSelection = true
        tableView.bounces = false
        self.games = tableView
        
        //MARK: - indicator
        indicator = addIndicatorToViewController()
    }
    
    
}

extension GamesVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.games[indexPath.row].isSelected = true
        viewModel.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        let favouriteAction = UIContextualAction(style: .normal, title: "Favourite") {
            (action, sourceView, completionHandler) in
            
            self.viewModel.toggleFavouriteGame(at: indexPath)
        }
        
        favouriteAction.backgroundColor = .systemGreen
        let image = UIImage(named: "heart")
        favouriteAction.image = image
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [favouriteAction])
        // Delete should not delete automatically
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == (self.gamesCounter.count - 1) && self.gamesCounter.count > 8{
//            self.currentPageNumber += 1
//
//        }
//    }

}


extension GamesVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier) as! GameTableViewCell
        let cellModel = self.viewModel.cellGame(for: indexPath)
        if cellModel.isSelected{
            cell.backgroundColor = .SelectedGameCell
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        cell.injectCell(with: cellModel)
        cell.selectionStyle = .none
        return cell
    }
}

extension GamesVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            viewModel.getGames()
        }else{
            guard  searchText != "", searchText.count >= 3 else {
                return }
            viewModel.searchGames(for: searchText)
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getGames()
    }
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


extension GamesVC:ActivityIndicatorProtocol { }
