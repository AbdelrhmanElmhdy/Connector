//
//  AuthView.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/12/2022.
//

import UIKit

class AuthView: KeyboardAvoidingView {
    
    let viewModel: AuthViewModel
    
    var textFieldViews: [TextFieldView] {
        return []
    }
    
    var textFields: [UITextField] {
        return textFieldViews.map { $0.textField }
    }
    
    let scrollView = UIScrollView()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "AuthScreenAppIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var textFieldsStackView: UIStackView = {
        let arrangedSubviews = textFieldViews
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5

        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var authenticationButton: PrimaryButton = {
        let button = PrimaryButton(theme: .accent)
        return button
    }()
    
    let otherAuthMethodLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.textColor = .gray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var otherAuthMethodButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitleColor(.accent, for: .normal)
        
        return button
    }()
    
    lazy var otherAuthMethodLabelAndButtonHorizontalStack: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [otherAuthMethodLabel, otherAuthMethodButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = 3
        return stackView
    }()
    
    lazy var rootStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [logoImageView, textFieldsStackView, authenticationButton, otherAuthMethodLabelAndButtonHorizontalStack])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.setCustomSpacing(15, after: logoImageView)
        stackView.setCustomSpacing(30, after: textFieldsStackView)
        stackView.setCustomSpacing(10, after: authenticationButton)
        return stackView
    }()
    
    // MARK: Initialization
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init()
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Setups
    
    func setupSubviews() {
        setupScrollView()
        setupRootStackView()
        setupImageView()
        setupTextFieldsStackView()
        setupAuthenticationButton()
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset.bottom = 20
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: keyboardAvoidanceLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
        ])
    }
    
    private func setupRootStackView() {
        scrollView.addSubview(rootStackView)
        
        // Try to Make the height of the stack view not exceed 85% of the height of the scroll view
        let optionalHeightConstraint = rootStackView.heightAnchor.constraint(lessThanOrEqualTo: scrollView.heightAnchor, multiplier: 0.85)
        optionalHeightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            rootStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            rootStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            optionalHeightConstraint,
        ])
        
    }
    
    private func setupImageView() {
        // Make the image view's height compress to as low as 200 to try to satisfy the root
        // stack view's optional height constraint
        logoImageView.setContentCompressionResistancePriority(.defaultLow - 1, for: .vertical)
        logoImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    }
    
    private func setupTextFieldsStackView() {
        NSLayoutConstraint.activate([
            textFieldsStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
        ])
    }
    
    private func setupAuthenticationButton() {
        NSLayoutConstraint.activate([
            authenticationButton.heightAnchor.constraint(equalToConstant: 50),
            authenticationButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.75),
        ])
    }
    
    // MARK: Convenience
    
    func createAuthTextField(name: String, icon: UIImage?, validators: [Validatable.Validator] = []) -> TextFieldView {
        
        let icon = icon?.withTintColor(.accentForLightGrayForDark).withRenderingMode(.alwaysOriginal)
        let textFieldView = TextFieldView(name: name,
                                          icon: icon,
                                          validators: [viewModel.nonEmptyFieldValidator] + validators)
        
        textFieldView.backgroundColor = .tertiarySystemGroupedBackground
        textFieldView.cornerRadius = 8
        
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldView
    }
    
    func createNameTextField(name: String) -> TextFieldView {
        let icon = UIImage(systemName: "person.circle.fill")
        return createAuthTextField(name: name, icon: icon, validators: [])
    }
    
    func createUsernameTextField() -> TextFieldView {
        let name = "Username".localized
        let icon = UIImage(systemName: "person.circle.fill")
        
        let usernameTextFieldView = createAuthTextField(name: name, icon: icon, validators: [])
        usernameTextFieldView.textField.textContentType = .username
        
        return usernameTextFieldView
    }
    
    func createEmailTextField() -> TextFieldView {
        let name = "Email".localized
        let icon = UIImage(systemName: "envelope.circle.fill")
        let validators = [viewModel.emailValidator]
        
        let emailTextFieldView = createAuthTextField(name: name, icon: icon, validators: validators)
        emailTextFieldView.textField.textContentType = .emailAddress
        emailTextFieldView.textField.keyboardType = .emailAddress
        
        return emailTextFieldView
    }
    
    func createPasswordTextField(name: String, validators: [Validatable.Validator] = []) -> TextFieldView {
        let icon = UIImage(systemName: "lock.circle.fill")
        
        let passwordTextFieldView = createAuthTextField(name: name, icon: icon, validators: validators)
        passwordTextFieldView.textField.textContentType = .password
        passwordTextFieldView.textField.isSecureTextEntry = true
        
        return passwordTextFieldView
    }
    
}
