

import UIKit
protocol AlertSheetHelperDelegate:AnyObject{
    func didTapRemove()
}

/// Alert sheet to ask user if he is sure to remove a game from favourites.
class DeleteHelper{
    
    /// UIViewController where our alert sheet will be shown
    private var viewController:UIViewController!
    /// instance of UIAlertController
    private var alertSheet:UIAlertController!
    /// delegate of our UIAlertController to tell what user did chose
    weak var delegate:AlertSheetHelperDelegate?
        
    init(_ viewController:UIViewController){
        self.intializeAlert()
        self.viewController = viewController
    }
    
    /// Show alert sheet to use
    func showAlert(){
        viewController.present(alertSheet, animated: true, completion: nil)
    }
    
    /// intializing the alert sheet
    func intializeAlert() {
        alertSheet = UIAlertController(title: "Remove from favourites", message: "Are you sure to remove from favourites?", preferredStyle: .alert)

        alertSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: {
            action in
            self.delegate?.didTapRemove()
        }))
     
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
}

struct AlertView {
    public static func showAlertBox(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        return alert
    }
}

extension UIViewController{
    public func showMessage(title:String = "Information", message:String){
        AlertView.showAlertBox(title: title, message: message).present(self, animated: true) {}
    }
}
