
import UIKit

extension UITableViewCell{
    /// identifier for UITableViewCell with the same Self name
    public static var identifier:String{
        return "\(Self.self)"
    }
    
    /// Get your cell.xib 
    /// - Returns:
   public static func cellNib()->UINib{
        return UINib(nibName: "\(Self.self)", bundle: nil)
    }
}
