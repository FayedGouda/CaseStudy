
import UIKit
class GameTableViewCell:UITableViewCell{
    
    private weak var picture:UIImageView!
    private weak var name:UILabel!
    private weak var numberOfMetacritic:UILabel!
    private weak var geners:UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpConstraints(){
        
        let containerView = UIView(frame: .zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ])
        
        
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(image)
        image.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            image.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            image.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            image.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.354)
        ])
        self.picture = image
        
        let stackView = UIStackView(frame: .zero)
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 15
//        stackView.alignment = .fill
        let nameLabel = UILabel()
        self.name = nameLabel
        
        let numberOfMetacritic = UILabel()
        self.numberOfMetacritic = numberOfMetacritic
        
        let geners = UILabel()
        self.geners = geners
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(numberOfMetacritic)
        stackView.addArrangedSubview(geners)
        
    }
    
    private func setUpViews(){
        name.font = .boldSystemFont(ofSize: 20)
        name.numberOfLines = 2
        
        geners.numberOfLines = 4
        picture.contentMode = .scaleAspectFit
    }
    
    /// Inject cell with a game model
    /// - Parameter model: Game model of type confirming to GameProtocol protocol
    func injectCell(with model:GameProtocol){
        self.name.text = model.name
        createAttributedString(for: model.metacritic)
        if let imageURL = model.imageURL{
            self.picture.downloadImage(from: imageURL)
        }
        
        if let genres = model.genres, genres.count > 0{
            let genresList = genres.compactMap {
                return $0.name
            }
            let desc = genresList.joined(separator: ", ")
            self.geners.text = desc
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
