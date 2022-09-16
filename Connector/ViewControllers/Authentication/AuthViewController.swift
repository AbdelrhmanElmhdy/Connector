//
//  AuthenticationViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import UIKit

class AuthViewController: KeyboardAvoidingViewController {
    
    // MARK: Properties
    
    
    let scrollView = UIScrollView()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "AuthScreenAppIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
        
    lazy var firstNameTextFieldView = makeAuthTextField(name: "First Name".localized,
                                                        icon: UIImage(systemName: "person.circle.fill"))
    
    lazy var lastNameTextFieldView = makeAuthTextField(name: "Last Name".localized,
                                                       icon: UIImage(systemName: "person.circle.fill"))
    
    lazy var emailTextFieldView: TextFieldView = {
       let textFieldView = makeAuthTextField(name: "Email".localized,
                                             icon: UIImage(systemName: "envelope.circle.fill"))
        
        textFieldView.textField.keyboardType = .emailAddress
        textFieldView.textField.textContentType = .emailAddress

        return textFieldView
    }()
    
    lazy var usernameTextFieldView = makeAuthTextField(name: "Username".localized,
                                                       icon: UIImage(systemName: "person.circle.fill"))
    
    lazy var passwordTextFieldView = makePasswordTextField(name: "Password".localized,
                                                           icon: UIImage(systemName: "lock.circle.fill"))
    
    
    lazy var confirmPasswordTextFieldView = makePasswordTextField(name: "Confirm Password".localized,
                                                                  icon: UIImage(systemName: "lock.circle.fill"))
    
    lazy var textFieldsStackView: UIStackView = {
        let arrangedSubviews = getTextFieldsStackArrangedSubviews()
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5

        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var authenticationBtn: PrimaryBtn = {
        let button = PrimaryBtn(theme: .accent)
        button.addTarget(self, action: #selector(didPressAuthenticationButton), for: .touchUpInside)
        return button
    }()
    
    let otherAuthMethodLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.textColor = .gray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var otherAuthMethodBtn: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitleColor(.accent, for: .normal)
        button.addTarget(self, action: #selector(didPressOtherAuthMethodButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var otherAuthMethodLabelAndBtnHorizontalStack: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [otherAuthMethodLabel, otherAuthMethodBtn])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = 3
        return stackView
    }()
    
    lazy var rootStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [logoImageView, textFieldsStackView, authenticationBtn, otherAuthMethodLabelAndBtnHorizontalStack])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.setCustomSpacing(15, after: logoImageView)
        stackView.setCustomSpacing(30, after: textFieldsStackView)
        stackView.setCustomSpacing(10, after: authenticationBtn)
        return stackView
    }()
    
    
    // MARK: Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupSubviews()
    }
    
    
    // MARK: View Setups
    
    
    func setupSubviews() {
        setupScrollView()
        setupRootStackView()
        setupImageView()
        setupTextFieldsStackView()
        setupAuthenticationBtn()
    }
                
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset.bottom = 20
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
        ])
    }
        
    func setupRootStackView() {
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
        
    func setupTextFieldsStackView() {
        NSLayoutConstraint.activate([
            textFieldsStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
        ])
    }
    
    func setupAuthenticationBtn() {
        NSLayoutConstraint.activate([
            authenticationBtn.heightAnchor.constraint(equalToConstant: 50),
            authenticationBtn.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.75),
        ])
    }
    
    
    // MARK: Actions
    
    
    /// Abstract
    @objc func didPressAuthenticationButton() {}
    
    /// Abstract
    @objc func didPressOtherAuthMethodButton() {}
    
    
    // MARK: Convenience
    
    
    func makeAuthTextField(name: String, icon: UIImage?) -> TextFieldView {
        let textFieldView = TextFieldView(name: name, icon: icon?.withTintColor(.accentForLightGrayForDark).withRenderingMode(.alwaysOriginal))
        
        textFieldView.backgroundColor = .tertiarySystemGroupedBackground
        textFieldView.cornerRadius = 8
        
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldView
    }
    
    func makePasswordTextField(name: String, icon: UIImage?) -> TextFieldView {
        let passwordTextFieldView = makeAuthTextField(name: name, icon: icon)
        passwordTextFieldView.textField.textContentType = .password
        passwordTextFieldView.textField.isSecureTextEntry = true
        
        return passwordTextFieldView
    }
    
    /// Abstract
    func getTextFieldsStackArrangedSubviews() -> [UIView] { [] }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func navigateToMainTabBarController() {
        dismiss(animated: true)
    }
}
