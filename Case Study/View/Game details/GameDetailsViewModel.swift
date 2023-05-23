
import Foundation

/// This view model is responsible for getting game details, render data to its view controller
class GameDetailsViewModel{
    
    var reloadData: () -> Void = {}
    
    var loading: (Bool) -> Void = {_ in }
    
    var success: (Bool) -> Void = {_ in }
    
    var error: (Error) -> Void = {_ in }
    
    var empty: (Bool) -> Void = {_ in }
    
    private var redditURL:String?
    
    private var websiteURL:String?
    
    var loadGameDetails:(GameDetails)->Void = { _ in }
    
    private var game:GameProtocol
    private var apiService:GamesAPIServiceProtocol
    
    init(game: GameProtocol, apiService:GamesAPIServiceProtocol) {
        self.game = game
        self.apiService = apiService
        getGameDetails()
    }
    
    /// Get game details for current game
    private func getGameDetails(){
        guard let id = game.id else { return }
        loading(true)
        apiService.details(id:id) { [weak self] result in
            self?.loading(false)
            switch result{
            case .success(let details):
                self?.redditURL = details.redditURL
                self?.websiteURL = details.website
                self?.loadGameDetails(details)
            case .failure(let error):
                self?.error(error)
            }
        }
    }
    
    /// Open game reddit url in Safari browser
    func didTapOpenReddit(){
        guard let redditURL else { return }
        ExternalShareHelper.shared.openExternalLink(to: redditURL)
    }
    /// Open game website url in Safari browser
    func didTapOpenWebsite(){
        guard let websiteURL else { return }
        ExternalShareHelper.shared.openExternalLink(to: websiteURL)
    }
    /// Toggle current game to favourites, if it is favoured, remove it from favourite games and vice versa
    func toggleFavourite(){
        LocalFavourites.shared.toggleFavourite(for: self.game as! Game) { [weak self] result in
            switch result{
            case .success(let success):
                guard success else {
                    return
                }
                self?.success(true)
            case .failure(let error):
                self?.error(error)
            }
        }
    }
}

extension GameDetailsViewModel{
    var isFavourite:Bool{
//        guard let isFav = game.isFavourite else { return false }
        return LocalFavourites.shared.search(for: game as! Game).0
    }
}
