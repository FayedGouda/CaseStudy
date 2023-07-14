
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
    
    var isSelected: Bool = false
    
    var isFavourite: Bool = false
    
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
        case id
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
        metacritic = try values.decodeIfPresent(Int.self, forKey: .metacritic)
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
        
    var genres: [Genre]? { get set }
    
    var isFavourite:Bool { get set }
    
    var isSelected:Bool { get set }
            
}
