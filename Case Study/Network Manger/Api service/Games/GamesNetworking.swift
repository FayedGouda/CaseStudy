
import Foundation

/// Target for games apis calls
enum GamesNetworking{
    case getGames
    case search
    case favourites
    case details(id:Int)
}

//Provide default values
extension GamesNetworking:TargetType{
    var baseUrl: String {
        get {
            return Config.baseUrl
        }
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    var endPoint: String {
        switch self {
        case .getGames:
            return "/api/games"
        case .search:
            return "/api/games"
        case .favourites:
            return ""
        case .details(let id):
            return "/api/games/\(id)?key=\(Config.API_Key)"
        }
    }
}
