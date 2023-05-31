

import UIKit

class FavouriteVC: UIViewController {
    
    private weak var favourites:UITableView!
    private weak var emptyErrorLabel:UILabel!
    private weak var indicator:UIActivityIndicatorView!
    
    private var viewModel:GamesViewModelProtocol!
    
    private var deleteAccountHelper:DeleteHelper!
    
    private var swipedCellIndexPath:IndexPath?
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavouriteGames()
    }
    
    private func bindData(){
        viewModel.loading = { [weak self ] isLoading in
            self?.indicator.showIndicator(isLoading)
            self?.favourites.isHidden = isLoading
        }
        
        viewModel.reloadData = { [weak self] in
            self?.title! += "(\(self!.viewModel!.numberOfRows()))"
            self?.favourites.reloadData()
        }
        
        viewModel.empty = { [weak self ] isEmpty in
            self?.title = "Favourites"
            self?.emptyErrorLabel.isHidden = !isEmpty
            self?.emptyErrorLabel.text = "There is no favourites found."
            self?.favourites.isHidden = isEmpty
        }
    }
    
    private func setUpConfigurations(){
        
        title = "Favourites"
        view.backgroundColor = .white

        favourites.delegate = self
        favourites.dataSource = self
        favourites.bounces = false
        favourites.register(GameTableViewCell.self, forCellReuseIdentifier: GameTableViewCell.identifier)
        
        deleteAccountHelper = DeleteHelper(self)
        deleteAccountHelper.delegate = self
    }
    
    private func setUpConstraints(){
        
        //MARK: - games
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        self.favourites = tableView
        
        //MARK: - indicator
        indicator = addIndicatorToViewController()
        
        //MARK: - Error Label
        
        let lbl = UILabel(frame: .zero)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lbl)
        
        lbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        lbl.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.555).isActive = true
        lbl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        lbl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 20)
        self.emptyErrorLabel = lbl
    }
    
    
}

extension FavouriteVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if (editingStyle == .delete) {
            self.swipedCellIndexPath = indexPath
            self.deleteAccountHelper.showAlert()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
}


extension FavouriteVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier) as! GameTableViewCell
        
        let cellModel = self.viewModel.cellGame(for: indexPath)
        cell.injectCell(with: cellModel)
        return cell
    }
}

extension FavouriteVC:ActivityIndicatorProtocol { }

extension FavouriteVC:AlertSheetHelperDelegate{
    func didTapRemove() {
        guard let swipedCellIndexPath else { return }
        viewModel.toggleFavouriteGame(at: swipedCellIndexPath)
        viewModel.getFavouriteGames()
    }
}
