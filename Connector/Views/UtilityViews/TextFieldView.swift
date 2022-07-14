//
//  TextFieldView.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import UIKit

class TextFieldView: UIView {
    
    let textFieldContainer = UIView()
    
    let textField = UITextField()
    
    let iconImageView = UIImageView()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        label.textColor = .red
        
        return label
    }()
    
    let name: String
    
    override var backgroundColor: UIColor? {
        get {
            return textFieldContainer.backgroundColor
        }
        set {
            // Apply the change only on the textFieldContainer view and keep TextFieldView's background color clear.
            guard newValue != .clear else { return }
            textFieldContainer.backgroundColor = newValue
            self.backgroundColor = .clear
        }
    }
    
    var cornerRadius: CGFloat {
        get {
            return textFieldContainer.layer.cornerRadius
        }
        set {
            textFieldContainer.layer.cornerRadius = newValue
        }
    }
    
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    private let errorLabelHeight: CGFloat = 12
    private let iconHorizontalMargin: CGFloat = 15
    
    init(name: String, icon: UIImage?) {
        self.name = name
        self.iconImageView.image = icon
        super.init(frame: .zero)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupErrorLabel()
        setupTextFieldContainer()
        setupIconImageView()
        setupTextField()
    }
    
    func setupErrorLabel() {
        addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            errorLabel.heightAnchor.constraint(equalToConstant: errorLabelHeight),
        ])
    }
    
    func setupTextFieldContainer() {
        addSubview(textFieldContainer)
        textFieldContainer.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            textFieldContainer.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 3),
            textFieldContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            textFieldContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            textFieldContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func setupIconImageView() {
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: textFieldContainer.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: iconHorizontalMargin),
            iconImageView.heightAnchor.constraint(equalTo: textFieldContainer.heightAnchor, multiplier: 0.7),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func setupTextField() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = name
        setTextFieldDirection()
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: textFieldContainer.topAnchor),
            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: iconHorizontalMargin),
            textField.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -5),
        ])
        
        textField.addTarget(self, action: #selector(hideErrorMessage), for: .allEditingEvents)
    }
        
    func setTextFieldDirection() {
        let layoutDirection = LayoutTools.getCurrentLayoutDirection(for: self)
        if layoutDirection == .rightToLeft {
            textField.textAlignment = .right
        }
    }
    
    func showIsEmptyErrorMessage() {
        showErrorMessage(errorMessage: "Enter ".localized + name.localized)
    }
    
    func showErrorMessage(errorMessage: String) {
        errorLabel.text = errorMessage
    }
    
    @objc func hideErrorMessage() {
        errorLabel.text = ""
    }
}
