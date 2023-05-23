
import UIKit

/// Add UIActivityIndicatorView to your UIViewController
public protocol ActivityIndicatorProtocol where Self:UIViewController {
    func addIndicatorToViewController()->UIActivityIndicatorView
}

public extension ActivityIndicatorProtocol{
    /// Add UIActivityIndicatorView to your UIViewController horizentaly and vertically centered
    /// - Returns: Instance of UIActivityIndicatorView to use in your UIViewController
    func addIndicatorToViewController()->UIActivityIndicatorView{
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        indicator.color = .systemBlue
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            indicator.heightAnchor.constraint(equalTo: indicator.widthAnchor, multiplier: 1),
            indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        return indicator
    }
}

extension UIActivityIndicatorView{
    /// Show,  startAnimating or hide, stopAnimating the indicator when needed
    /// - Parameter status: Bool value that indicates indicator state(animating, stopAnimating)
    func showIndicator(_ status:Bool){
        self.isHidden = !status
        if status {
            self.startAnimating()
        }else{
            self.stopAnimating()
        }
    }
}
