import UIKit

extension UITextView {
    func setTextViewDirectionToMatchUserInterface() {
        let layoutDirection = LayoutTools.getCurrentLayoutDirection(for: self)
		if layoutDirection == .leftToRight {
			self.makeTextWritingDirectionLeftToRight(self)
		} else {
			self.makeTextWritingDirectionRightToLeft(self)
		}
    }
    
    var numberOfLines: Int {
        return Int(contentSize.height / (font?.lineHeight ?? 16))
    }
}
