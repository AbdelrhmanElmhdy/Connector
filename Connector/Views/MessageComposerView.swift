//
//  MessageComposerView.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 02/08/2022.
//

import UIKit

class MessageComposerView: UIView, UITextViewDelegate {
	static let topPadding: CGFloat = 15
	static let bottomPadding: CGFloat = 50
	static let verticalPadding: CGFloat = topPadding + bottomPadding
	
	var text: String {
		get {
			inputFieldContainer.inputField.text
		}
		
		set {
			inputFieldContainer.inputField.text = newValue
		}
	}
	
	lazy var inputFieldContainer: ChatInputFieldContainer = {
		let inputField = ChatInputFieldContainer(frame: .zero)
		
		inputField.layer.borderColor = UIColor.systemGray2.cgColor
		inputField.layer.borderWidth = 1
		inputField.inputField.customDelegate = self
		
		inputField.translatesAutoresizingMaskIntoConstraints = false
		return inputField
	}()
	
	init() {
		super.init(frame: .zero)
		addBlurEffect(style: .systemChromeMaterial, withCascadingColor: .systemBackground)
		setupSubviews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func setupSubviews() {
		setupInputFieldContainer()
	}
	
	func setupInputFieldContainer() {
		addSubview(inputFieldContainer)
		
		NSLayoutConstraint.activate([
			inputFieldContainer.topAnchor.constraint(equalTo: topAnchor, constant: MessageComposerView.topPadding),
			inputFieldContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -MessageComposerView.bottomPadding),
			inputFieldContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
			inputFieldContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
			inputFieldContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: ChatInputFieldContainer.minHeight),
			inputFieldContainer.heightAnchor.constraint(lessThanOrEqualToConstant: ChatInputFieldContainer.maxHeight),
		])
		
		inputFieldContainer.layer.cornerRadius = ChatInputFieldContainer.minHeight / 2
	}
	
	func textViewDidChange(_ textView: UITextView) {
		// Enable or disable scrolling based on the number of lines
		
		if inputFieldContainer.inputField.numberOfLines >= 10 {
			inputFieldContainer.inputField.isScrollEnabled = true
		} else if inputFieldContainer.inputField.isScrollEnabled {
			// Invalidate the intrinsic content size to get it recalculated after scrolling is disabled
			
			inputFieldContainer.inputField.isScrollEnabled = false
			inputFieldContainer.inputField.invalidateIntrinsicContentSize()
		}
	}
}
