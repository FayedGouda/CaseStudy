
import UIKit

class GamesVC: UIViewController {
    
    private weak var searchBar:UISearchBar!
    private weak var games:UITableView!
    private weak var indicator:UIActivityIndicatorView!
    private weak var emptyErrorLabel:UILabel!
    
    private var viewModel:GamesViewModelProtocol!
    private var gamesCounter:Int = 0
    private var searchText:String?
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
        
        viewModel.success = { [weak self] isSuccess in
            guard isSuccess else {
                AlertView.showBasicAlert(on: self!, with: "Error", message: "Something went wrong") {
                }
                return
            }
            AlertView.showBasicAlert(on: self!, with: "Success", message: "Action compleated successfulyy") {
            }
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
        games.register(GameTableViewCell.self, forCellReuseIdentifier: GameTableViewCell.identifier)
        games.estimatedRowHeight = UITableView.automaticDimension
        games.rowHeight = UITableView.automaticDimension
        games.estimatedRowHeight = 136
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 136
//    }
//
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cellModel = viewModel.cellGame(for: indexPath)
               
        var image:UIImage?
        var title:String?
        if cellModel.isFavourite{
            image = UIImage(named: "like")
            title = "Favorited"
        }else{
            image = UIImage(named: "heart")
            title = "Favorite"
        }
        
        
        let favouriteAction = UIContextualAction(style: .normal, title: title) {
            (action, sourceView, completionHandler) in
            self.viewModel.toggleFavouriteGame(at: indexPath)
            self.games.reloadRows(at: [indexPath], with: .automatic)
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [favouriteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = true
        favouriteAction.backgroundColor = .systemGreen
        favouriteAction.image = image
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.paginationisAllowed && indexPath.row == gamesCounter - 1 && gamesCounter >= 10{
            self.viewModel.currentPageNumber += 1
            guard let searchText else { return }
            viewModel.searchGames(for: searchText)
        }
    }

}


extension GamesVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = viewModel.numberOfRows()
        if viewModel.paginationisAllowed{
            self.gamesCounter = numberOfRows
        }
        return numberOfRows
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
            viewModel.paginationisAllowed = false
            viewModel.currentPageNumber = 1
            viewModel.getGames()
        }else{
            guard searchText != "", searchText.count >= 3 else { return }
            self.searchText = searchText
            viewModel.searchGames(for: searchText)
        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.paginationisAllowed = true
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
