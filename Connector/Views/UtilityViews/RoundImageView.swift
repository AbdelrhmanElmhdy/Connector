import UIKit

class RoundImageView: UIImageView {

    override var bounds: CGRect {
        didSet {
            layer.cornerRadius = bounds.height / 2
            clipsToBounds = true
        }
    }

}
