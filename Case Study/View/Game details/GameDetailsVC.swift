
import UIKit
/// A view controller which is reponsable for show game details
class GameDetailsVC: UIViewController {
    
    @IBOutlet private weak var picture: UIImageView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var details: UILabel!
    @IBOutlet private weak var emptyErrorLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    private weak var toggleFavouriteButton:UIBarButtonItem!
    private weak var indicator:UIActivityIndicatorView!

    var viewModel:GameDetailsViewModel!
    
    override func loadView() {
        super.loadView()
        indicator = addIndicatorToViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        bindData()
    }
    
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
    }
    
    /// Set image using remote url
    /// - Parameter imageUrl: Image URL
    private func setImage(for imageUrl:String?){
        guard let imageUrl else { return }
        picture.downloadImage(from: imageUrl)
    }
    
    private func setUpViews(){
        var favouriteButtonTitle:String = ""
        if viewModel.isFavourite{
            favouriteButtonTitle = "Favorited"
        }else{
            favouriteButtonTitle = "Favorite"
        }
        let favouriteButton = UIBarButtonItem(title: favouriteButtonTitle, style: .plain, target: self, action: #selector(toggleFavourite))
        self.toggleFavouriteButton = favouriteButton
        self.navigationItem.setRightBarButton(favouriteButton, animated: false)
    }
    
    
    @IBAction private func didTapVisitReddit(_ sender: Any) {
        viewModel.didTapOpenReddit()
    }
    
    @IBAction private func didTapVisitWebsite(_ sender: Any) {
        viewModel.didTapOpenWebsite()
    }
    
    @objc private func toggleFavourite(){
        viewModel.toggleFavourite()
    }
}

extension GameDetailsVC:ActivityIndicatorProtocol { }
