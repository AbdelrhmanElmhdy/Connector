//
//  TextFieldView.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import UIKit

class TextFieldView: UIView, Validatable {
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        label.textColor = .red
        label.text = " "
        label.textAlignment = .natural
        
        return label
    }()
    
    let iconImageView = UIImageView()
    
    let textField = UITextField()
    
    lazy var textFieldContainerHStack: UIStackView = {
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
    
    lazy var rootStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [errorLabel, textFieldContainerHStack])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
                
        stackView.spacing = 3
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
    let name: String
    
    /// By default mirrors the name value, which is usually a noun, unless manually set to a different value.
    var nameAsNoun: String
    
    var validators: [Validator]
    
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
        
    init(name: String, icon: UIImage?, validators: [Validatable.Validator] = []) {
        self.name = name
        self.iconImageView.image = icon
        self.validators = validators
        self.nameAsNoun = name
        
        super.init(frame: .zero)
        
        setupSubviews()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupRootStackView()
        setupIconImageView()
        setupTextField()
    }
    
    func setupRootStackView() {
        addSubview(rootStackView)
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setupIconImageView() {
        iconImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalTo: textFieldContainerHStack.heightAnchor, multiplier: 0.7),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func setupTextField() {
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
    
    func presentErrorMessage(_ errorMessage: String?) {
        errorLabel.text = errorMessage
    }
    
    @objc func hideErrorMessage() {
        errorLabel.text = " "
    }
    
}
