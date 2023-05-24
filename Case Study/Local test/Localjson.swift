
import Foundation
struct LocalJSON{
    static let shared = LocalJSON()
    private init (){}
    func loadGames() -> MainResponse?{
        if let path = Bundle.main.url(forResource: "games", withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MainResponse.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    func loadGameDetails() -> GameDetails?{
        if let path = Bundle.main.url(forResource: "game_details", withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(GameDetails.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
