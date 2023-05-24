
import UIKit
//import Kingfisher
class GameTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var picture:UIImageView!
    @IBOutlet private weak var name:UILabel!
    @IBOutlet private weak var numberOfMetacritic:UILabel!
    @IBOutlet private weak var details:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.backgroundColor = .SelectedGameCell
        }else{
            self.backgroundColor = .clear
        }
    }
    
    /// Inject cell with a game model
    /// - Parameter model: Game model of type confirming to GameProtocol protocol
    func injectCell(with model:GameProtocol){
        self.name.text = model.name
        createAttributedString(for: model.metacritic)
        if let imageURL = model.imageURL{
//            self.picture.downloadImage(from: imageURL)
        }
        
        if let genres = model.genres, genres.count > 0{
            let genresList = genres.compactMap {
                return $0.name
            }
            let desc = genresList.joined(separator: ", ")
            self.details.text = desc
        }
    }
    
    /// Create attributed string of two parts, first is a title, second is the value
    /// - Parameter text: Value to be shown
    private func createAttributedString(for text:Int?){
        
        let attrs1 = [ NSAttributedString.Key.foregroundColor:UIColor.black]
        
        let attrs2 = [ NSAttributedString.Key.foregroundColor:UIColor.systemRed]
        
        let attributedString1 = NSMutableAttributedString(string:"Metacritic:", attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:" \(text ?? 0)", attributes:attrs2)
        
        attributedString1.append(attributedString2)
        self.numberOfMetacritic.attributedText = attributedString1
    }
}
