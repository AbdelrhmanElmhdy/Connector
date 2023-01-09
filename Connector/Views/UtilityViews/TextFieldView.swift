//
//  TextFieldView.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import UIKit

class TextFieldView: UIView {
	
	private let errorLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 11)
		label.textAlignment = .center
		label.textColor = .red
		label.text = " "
		label.textAlignment = .natural
		
		return label
	}()
	
	private let iconImageView = UIImageView()
	
	let textField = UITextField()
	
	var errorMessage: String {
		get { errorLabel.text ?? "" }
		set {
			guard !newValue.isEmpty else {
				errorLabel.text = " "
				return
			}
			errorLabel.text = newValue
		}
	}
	
	private lazy var textFieldContainerHStack: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [iconImageView, textField])
		stackView.axis = .horizontal
		stackView.distribution = .fill
		stackView.alignment = .center
		
		let horizontalMargin: CGFloat = 15
		let verticalMargin: CGFloat = 8
		
		stackView.layoutMargins = UIEdgeInsets(top: verticalMargin,
																					 left: horizontalMargin,
																					 bottom: verticalMargin,
																					 right: horizontalMargin)
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.spacing = horizontalMargin
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	
	private lazy var rootStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [errorLabel, textFieldContainerHStack])
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.alignment = .fill
		
		stackView.spacing = 3
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	
	let name: String
	
	override var backgroundColor: UIColor? {
		get {
			return textFieldContainerHStack.backgroundColor
		}
		set {
			// Apply the change only on the textFieldContainer view and keep TextFieldView's background color clear.
			guard newValue != .clear else { return }
			textFieldContainerHStack.backgroundColor = newValue
			self.backgroundColor = .clear
		}
	}
	
	var cornerRadius: CGFloat {
		get {
			return textFieldContainerHStack.layer.cornerRadius
		}
		set {
			textFieldContainerHStack.layer.cornerRadius = newValue
		}
	}
	
	var value: String {
		get {
			return textField.text ?? ""
		}
		set {
			textField.text = newValue
		}
	}
	
	init(name: String, icon: UIImage?) {
		self.name = name
		self.iconImageView.image = icon
		
		super.init(frame: .zero)
		
		textField.accessibilityIdentifier = name
		
		setupInputAccessoryView()
		setupSubviews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupInputAccessoryView() {
		let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
		
		let flexibleSpace = UIBarButtonItem(systemItem: .flexibleSpace)
		let done = UIBarButtonItem(title: .ui.done, style: .done, target: self, action: #selector(didPressDone))
		
		bar.items = [flexibleSpace, done]
		textField.inputAccessoryView = bar
	}
	
	private func setupSubviews() {
		setupRootStackView()
		setupIconImageView()
		setupTextField()
	}
	
	private func setupRootStackView() {
		addSubview(rootStackView)
		
		NSLayoutConstraint.activate([
			rootStackView.topAnchor.constraint(equalTo: topAnchor),
			rootStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			rootStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			rootStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
	
	private func setupIconImageView() {
		iconImageView.contentMode = .scaleAspectFit
		
		NSLayoutConstraint.activate([
			iconImageView.heightAnchor.constraint(equalTo: textFieldContainerHStack.heightAnchor, multiplier: 0.7),
			iconImageView.widthAnchor.constraint(equalToConstant: 30),
		])
	}
	
	private func setupTextField() {
		textField.placeholder = name
		setTextFieldDirection()
		textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
		textField.addTarget(self, action: #selector(hideErrorMessage), for: .allEditingEvents)
	}
	
	func setTextFieldDirection() {
		let layoutDirection = LayoutTools.getCurrentLayoutDirection(for: self)
		if layoutDirection == .rightToLeft {
			textField.textAlignment = .right
		}
	}
	
	@objc func hideErrorMessage() {
		errorLabel.text = " "
	}
	
	@objc private func didPressDone() {
		textField.resignFirstResponder()
	}
	
}
