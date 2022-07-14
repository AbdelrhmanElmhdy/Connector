//
//  AuthenticationViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import UIKit

class AuthViewController: UIViewController {
        
    let scrollView = UIScrollView()
    
    let appIcon = UIImageView(image: UIImage(named: "AuthScreenAppIcon"))
        
    lazy var firstNameTextFieldView = makeAuthTextField(name: "First Name".localized, icon: UIImage(systemName: "person.circle.fill"))
    
    lazy var lastNameTextFieldView = makeAuthTextField(name: "Last Name".localized, icon: UIImage(systemName: "person.circle.fill"))
    
    lazy var emailTextFieldView: TextFieldView = {
       let textFieldView = makeAuthTextField(name: "Email".localized, icon: UIImage(systemName: "envelope.circle.fill"))
        
        textFieldView.textField.keyboardType = .emailAddress
        textFieldView.textField.textContentType = .emailAddress

        return textFieldView
    }()
    
    lazy var usernameTextFieldView = makeAuthTextField(name: "Username".localized, icon: UIImage(systemName: "person.circle.fill"))
    
    lazy var passwordTextFieldView = makePasswordTextField(name: "Password".localized, icon: UIImage(systemName: "lock.circle.fill"))
    
    
    lazy var confirmPasswordTextFieldView = makePasswordTextField(name: "Confirm Password".localized, icon: UIImage(systemName: "lock.circle.fill"))
    
    var logoHeight: CGFloat = LayoutConstants.screenHeight * 0.3
    
    lazy var textFieldsStackView: UIStackView = {
        let arrangedSubviews = getTextFieldsStackArrangedSubviews()
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2

        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let authenticationBtn = PrimaryBtn(theme: .accent)
    
    let otherAuthMethodLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        return label
    }()
    
    lazy var otherAuthMethodBtn: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitleColor(.accent, for: .normal)
        button.addTarget(self, action: #selector(handleOtherAuthMethodBtnTap), for: .touchUpInside)
        
        return button
    }()
    
    lazy var otherAuthMethodLabelAndBtnHorizontalStack : UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [otherAuthMethodLabel, otherAuthMethodBtn])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
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
        setupAppIcon()
        setupTextFieldsStackView()
        setupAuthenticationBtn()
        setupOtherAuthMethodLabelAndBtnHorizontalStack()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
        ])
    }
    
    func setupAppIcon() {
        scrollView.addSubview(appIcon)
        appIcon.translatesAutoresizingMaskIntoConstraints = false
        
        appIcon.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            appIcon.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            appIcon.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            appIcon.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            appIcon.heightAnchor.constraint(equalToConstant: logoHeight),
        ])
    }
        
    func setupTextFieldsStackView() {
        scrollView.addSubview(textFieldsStackView)
        
        let textFieldHeight: CGFloat = 67
        let stackViewHeight = textFieldsStackView.calculateHeightBasedOn(arrangedSubviewHeight: textFieldHeight)
        
        NSLayoutConstraint.activate([
            textFieldsStackView.topAnchor.constraint(equalTo: appIcon.bottomAnchor, constant: 15),
            textFieldsStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            textFieldsStackView.heightAnchor.constraint(equalToConstant: stackViewHeight),
            textFieldsStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
        ])
    }
    
    func setupAuthenticationBtn() {
        scrollView.addSubview(authenticationBtn)
        authenticationBtn.translatesAutoresizingMaskIntoConstraints = false
        
        authenticationBtn.addTarget(self, action: #selector(handleAuthenticationBtnTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            authenticationBtn.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 30),
            authenticationBtn.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            authenticationBtn.heightAnchor.constraint(equalToConstant: 50),
            authenticationBtn.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.75),
        ])
    }
    
    func setupOtherAuthMethodLabelAndBtnHorizontalStack() {
        scrollView.addSubview(otherAuthMethodLabelAndBtnHorizontalStack)
        
        NSLayoutConstraint.activate([
            otherAuthMethodLabelAndBtnHorizontalStack.topAnchor.constraint(equalTo: authenticationBtn.bottomAnchor, constant: 10),
            otherAuthMethodLabelAndBtnHorizontalStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            otherAuthMethodLabelAndBtnHorizontalStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            otherAuthMethodLabelAndBtnHorizontalStack.widthAnchor.constraint(lessThanOrEqualTo: scrollView.widthAnchor),
            otherAuthMethodLabelAndBtnHorizontalStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 18),
        ])
    }
    /// Abstract
    @objc func handleAuthenticationBtnTap() {}
    
    /// Abstract
    @objc func handleOtherAuthMethodBtnTap() {}
    
    
    
    // MARK: Tools
    
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
