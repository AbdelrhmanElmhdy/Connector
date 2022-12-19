import UIKit

extension UIStackView {
    
	func removeAllArrangedSubviews() {
		arrangedSubviews.forEach { subview in
			self.removeArrangedSubview(subview)
			NSLayoutConstraint.deactivate(subview.constraints)
            subview.removeFromSuperview()
		}
	}
    
    func insertDividers(withColor dividerColor: UIColor = .systemGray3, thickness: CGFloat = 1, multiplier: CGFloat = 0.5) {
        let originalSubviews = arrangedSubviews
        
        for subview in originalSubviews {
            if subview == originalSubviews.last { break }
            
            let divider = UIView()
            divider.backgroundColor = dividerColor
            self.insertSubview(divider, belowSubview: subview)
            
            if self.axis == .horizontal {
                divider.widthAnchor.constraint(equalToConstant: thickness).isActive = true
                divider.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: multiplier).isActive = true
            } else {
                divider.heightAnchor.constraint(equalToConstant: thickness).isActive = true
                divider.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: multiplier).isActive = true
            }
        }
    }
    
}
