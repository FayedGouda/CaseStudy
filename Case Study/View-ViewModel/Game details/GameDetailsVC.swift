
import UIKit
/// A view controller which is reponsable for show game details
class GameDetailsVC: UIViewController {
    
    private weak var picture: UIImageView!
    private weak var name: UILabel!
    private weak var details: UILabel!
    weak var scrollView: UIScrollView!
    weak var indicator:UIActivityIndicatorView!
    private weak var toggleFavouriteButton:UIBarButtonItem!
    
    var viewModel:GameDetailsViewModel!
    private var favouriteState:FavouriteState = .notFavourite
    
    init(viewModel:GameDetailsViewModel){
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
        view.backgroundColor = .white
        setUpViews()
        bindData()
        viewModel.getGameDetails()
    }
    
    /// Handeling favourite states of current game (if it favouried, enable unfavourite and vice versa)
    private enum FavouriteState:String{
        case isFavourite = "Favorited"
        case notFavourite = "Favorite"
        
        /// Toggling self rawValue to enable or disable toggleFavouriteButton
        /// - Returns: Title for toggleFavouriteButton
        mutating func toggleFavouriteButton()->String{
            switch self{
            case .isFavourite:
                self = .notFavourite
            case .notFavourite:
                self = .isFavourite
            }
            return rawValue
        }
    }
    
    /// Bind this UIViewController to its ViewModel
    private func bindData(){
        
        viewModel.loading = { [unowned self ] isLoading in
            self.indicator.showIndicator(isLoading)
            self.scrollView.isHidden = isLoading
        }
        
        viewModel.loadGameDetails = {
            [weak self] details in
            self?.name.text = details.name
            self?.details.text = details.description
            self?.setImage(for: details.imageURL)
        }
        
        viewModel.success = { [unowned self ] isSuccess in
            guard isSuccess else { return }
            let title = self.favouriteState.toggleFavouriteButton()
            self.toggleFavouriteButton.title = title
            self.toggleFavouriteButton.isEnabled = true
        }
    }
    
    private func setUpConstraints(){
        
        //MARK: - Scroll view
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        let margins = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: margins.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -8)
        ])
        self.scrollView = scrollView
        
        //MARK: - Container stack view
        let stackView = UIStackView(frame: .zero)
        stackView .axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        //MARK: - Image view
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        stackView.addArrangedSubview(imageView)
        self.picture = imageView
        
        //MARK: - Name label
        let labelName = UILabel(frame: .zero)
        imageView.addSubview(labelName)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelName.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.25),
            labelName.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            labelName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            labelName.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
        ])
        labelName.textAlignment = .center
        labelName.textColor = .white
        labelName.font = .boldSystemFont(ofSize: 30)
        self.name = labelName

        //MARK: - Game Description
        let lbl = UILabel(frame: .zero)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Game Description"
        stackView.addArrangedSubview(lbl)

        //MARK: -Game Description
        let detialsLabel = UILabel(frame: .zero)
        detialsLabel.numberOfLines = 4
        detialsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(detialsLabel)
        self.details = detialsLabel

        //MARK: - Visit Reddit label
        let redditURLLabel = UILabel(frame: .zero)
        redditURLLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(redditURLLabel)
        redditURLLabel.isUserInteractionEnabled = true
        redditURLLabel.text = "Visit Reddit"
        redditURLLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapVisitReddit)))

        //MARK: - Visit Website label
        let webSiteURLLabel = UILabel(frame: .zero)
        webSiteURLLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(webSiteURLLabel)
        webSiteURLLabel.isUserInteractionEnabled = true
        webSiteURLLabel.text = "Visit Website"
        webSiteURLLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapVisitWebsite)))

        self.indicator = addIndicatorToViewController()
        
    }
    
    
    
    /// Set image using remote url
    /// - Parameter imageUrl: Image URL
    private func setImage(for imageUrl:String?){
        guard let imageUrl else { return }
        picture.downloadImage(from: imageUrl)
    }
    
    /// Set up some views
    private func setUpViews(){
        if viewModel.isFavourite{
            
            favouriteState = .isFavourite
        }else{
            favouriteState = .notFavourite
        }
        let favouriteButton = UIBarButtonItem(title: favouriteState.rawValue, style: .plain, target: self, action: #selector(toggleFavourite))
        self.toggleFavouriteButton = favouriteButton
        self.navigationItem.setRightBarButton(favouriteButton, animated: false)
    }
    
    
    /// When user taps Visit Reddit label
    /// - Parameter sender: UITapGestureRecognizer
    @objc private func didTapVisitReddit() {
        viewModel.didTapOpenReddit()
    }
    
    /// When user taps Visit Website label
    /// - Parameter sender: UITapGestureRecognizer
    @objc private func didTapVisitWebsite() {
        viewModel.didTapOpenWebsite()
    }
    
    /// If the game is in your favourites, the allow user to remove it from his favourites and vice versa
    @objc private func toggleFavourite(){
        toggleFavouriteButton.isEnabled = false
        viewModel.toggleFavourite()
    }
}

extension GameDetailsVC:ActivityIndicatorProtocol{ }
