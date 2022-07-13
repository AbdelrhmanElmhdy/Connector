import UIKit

struct LayoutTools {
    
    static func getCurrentLayoutDirection(for view: UIView) -> UIUserInterfaceLayoutDirection {
        let attribute = view.semanticContentAttribute
        let layoutDirection = UIView.userInterfaceLayoutDirection(for: attribute)
        return layoutDirection
    }
    
}
