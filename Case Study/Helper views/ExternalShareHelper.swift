
import UIKit
/// Help open URLs in Safari browser
struct ExternalShareHelper{
    
    /// Shared instance
    static let shared = ExternalShareHelper()
    /// private init to prevent instantiating our class from outside, applying Singletone approach
    private init(){}
    
    /// Open given URL externally
    /// - Parameter url: Target URL
    func openExternalLink(to url:String){
        guard let appURL = NSURL(string:url) else{return}
        if UIApplication.shared.canOpenURL(appURL as URL) {
            UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
        }
    }
}
