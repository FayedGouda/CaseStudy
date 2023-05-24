
import UIKit
/// A view controller which is reponsable for show game details
class GameDetailsVC: UIViewController {
    
    @IBOutlet private weak var picture: UIImageView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var details: UILabel!
    @IBOutlet private weak var emptyErrorLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    private weak var toggleFavouriteButton:UIBarButtonItem!
    
    var viewModel:GameDetailsViewModel!
    private var favouriteState:FavouriteState = .notFavourite
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        bindData()
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
        
        viewModel.loading = { [weak self ] isLoading in
            self?.indicator.showIndicator(isLoading)
            self?.scrollView.isHidden = isLoading
        }
        
        viewModel.error = { [weak self ] error in
            self?.emptyErrorLabel.isHidden = false
            self?.emptyErrorLabel.text = error.localizedDescription
            self?.scrollView.isHidden = true
        }
        
        viewModel.loadGameDetails = {
            [weak self] details in
            self?.name.text = details.name
            self?.details.text = details.description
            self?.setImage(for: details.imageURL)
        }
        
        viewModel.success = { [weak self ] isSuccess in
            guard isSuccess else { return }
            let title = self?.favouriteState.toggleFavouriteButton()
            self?.toggleFavouriteButton.title = title
            self?.toggleFavouriteButton.isEnabled = true
        }
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
    @IBAction private func didTapVisitReddit(_ sender: Any) {
        viewModel.didTapOpenReddit()
    }
    
    /// When user taps Visit Website label
    /// - Parameter sender: UITapGestureRecognizer
    @IBAction private func didTapVisitWebsite(_ sender: Any) {
        viewModel.didTapOpenWebsite()
    }
    
    /// If the game is in your favourites, the allow user to remove it from his favourites and vice versa
    @objc private func toggleFavourite(){
        toggleFavouriteButton.isEnabled = false
        viewModel.toggleFavourite()
    }
}
