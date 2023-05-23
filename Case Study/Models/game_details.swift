
import Foundation
// MARK: - GameDetails
///  Properties for game details
struct GameDetails: Codable {
    let id: Int?
    let name, description: String?
    let website: String?
    let redditURL: String?
    let imageURL:String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, website
        case description = "description_raw"
        case redditURL = "reddit_url"
        case imageURL = "background_image"
    }
}
