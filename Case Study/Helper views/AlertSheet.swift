

import UIKit
protocol AlertSheetHelperDelegate:AnyObject{
    func didTapRemove()
}

/// Alert sheet to ask user if he is sure to remove a game from favourites.
class AlertSheetHelper{
    
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
    public static func showBasicAlert(on vc: UIViewController, with title: String, message: String, action: @escaping (() -> ())){

       let alert =  UIAlertController.init(title: title, message: message, preferredStyle: .alert)
       let okAction = UIAlertAction.init(title: "OK", style: .default) { (UIActionAlert) in
           action()
       }
       alert.addAction(okAction)
       DispatchQueue.main.async {
           vc.present(alert, animated: true, completion: nil)
       }

   }

}
