import UIKit
import Combine

extension EditableTextView {
	
	var numberOfLines: Int {
		return Int(contentSize.height / (font?.lineHeight ?? 16))
	}
	
	var textPublisher: AnyPublisher<String?, Never> {
		return NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: self)
			.map { ($0.object as? EditableTextView)?.inputText }
			.eraseToAnyPublisher()
	}
	
	func setTextViewDirectionToMatchUserInterface() {
		let layoutDirection = LayoutTools.getCurrentLayoutDirection(for: self)
		if layoutDirection == .leftToRight {
			self.makeTextWritingDirectionLeftToRight(self)
		} else {
			self.makeTextWritingDirectionRightToLeft(self)
		}
	}
	
	func createBidirectionalBinding<Root>(with publisher: Published<String>.Publisher,
																				keyPath: ReferenceWritableKeyPath<Root, String>,
																				for object: Root,
																				storeIn subscriptions: inout Set<AnyCancellable>) {
		
		self.textPublisher
			.removeDuplicates()
			.sink(receiveValue: { object[keyPath: keyPath] = $0 ?? "" })
			.store(in: &subscriptions)
		
		publisher
			.receive(on: DispatchQueue.main)
			.removeDuplicates()
			.sink (receiveValue: { self.inputText = $0 })
			.store(in: &subscriptions)
	}
}
