
import Foundation

// MARK: - MainResponse
/// Main response of request response
struct MainResponse: Codable {
    let games: [Game]?
    
    /// Mapping to keys in request response
    enum CodingKeys: String, CodingKey {
        case games = "results"
    }
}

// MARK: - Game
struct Game: GameProtocol {
    
    var isFavourite: Bool? = false
    
    var description: String?
    
    var id: Int?
    
    var imageURL: String?
        
    let name: String?
    
    let metacritic: Int?
    
    var genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "background_image"
        case metacritic
        case genres
        case id, description, isFavourite
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
        metacritic = try values.decodeIfPresent(Int.self, forKey: .metacritic)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        isFavourite = try values.decodeIfPresent(Bool.self, forKey: .isFavourite)
        genres = try values.decodeIfPresent([Genre].self, forKey: .genres)
        
    }
}

// MARK: - Genre
struct Genre: Codable {
    let name: String?
}
// MARK: - GameProtocol
/// Base protocol for properties required for a game
protocol GameProtocol: Codable{
    
    var id:Int? { get }
    
    var name:String? { get }
    
    var imageURL:String? { get }
    
    var metacritic:Int? { get }
    
    var description:String? { get set }
    
    var genres: [Genre]? { get set }
    
    var isFavourite:Bool? { get set }
        
}

extension GameProtocol{
    var isFavourite:Bool?{
        return false
    }

}
