
import UIKit

extension UITableViewCell{
    /// identifier for UITableViewCell with the same Self name
    public static var identifier:String{
        return "\(Self.self)"
    }
}
