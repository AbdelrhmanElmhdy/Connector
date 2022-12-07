//
//  AuthenticationViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import UIKit
import Combine

protocol KeyboardAvoiding: UIViewController {
    func test()
}

extension KeyboardAvoiding {
    func test() {
        
    }
}

class AuthViewController: KeyboardAvoidingViewController {
    
    // MARK: Properties
        
    let viewModel: AuthViewModel
    
    var subscriptions = Set<AnyCancellable>()
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
                                             icon: UIImage(systemName: "envelope.circle.fill"),
                                             validators: [
                                                viewModel.emailValidator
                                             ])
        
        textFieldView.textField.keyboardType = .emailAddress
        textFieldView.textField.textContentType = .emailAddress

        return textFieldView
    }()
    
    lazy var usernameTextFieldView = makeAuthTextField(name: "Username".localized,
                                                       icon: UIImage(systemName: "person.circle.fill"))
    
    lazy var passwordTextFieldView = makePasswordTextField(name: "Password".localized,
                                                           icon: UIImage(systemName: "lock.circle.fill"),
                                                           validators: [
                                                            viewModel.passwordMinimumLengthValidator,
                                                            viewModel.passwordComplexityValidator
                                                           ])
    
    
    lazy var confirmPasswordTextFieldView: TextFieldView = {
        let textField = makePasswordTextField(name: "Confirm Password".localized,
                                              icon: UIImage(systemName: "lock.circle.fill"))
        textField.nameAsNoun = "Password Confirmation".localized
        return textField
    }()
    
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
    
    // MARK: Initialization
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupSubviews()
        configureTextFields(inStackView: textFieldsStackView)
        setupBindings()
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
    
    func makeAuthTextField(name: String,
                           icon: UIImage?,
                           validators: [Validatable.Validator] = []) -> TextFieldView {
        
        let icon = icon?.withTintColor(.accentForLightGrayForDark).withRenderingMode(.alwaysOriginal)
        let textFieldView = TextFieldView(name: name,
                                          icon: icon,
                                          validators: [viewModel.nonEmptyFieldValidator] + validators)
        
        textFieldView.backgroundColor = .tertiarySystemGroupedBackground
        textFieldView.cornerRadius = 8
        
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldView
    }
    
    func makePasswordTextField(name: String, icon: UIImage?, validators: [Validatable.Validator] = []) -> TextFieldView {
        let passwordTextFieldView = makeAuthTextField(name: name, icon: icon, validators: validators)
        passwordTextFieldView.textField.textContentType = .password
        passwordTextFieldView.textField.isSecureTextEntry = true
        
        return passwordTextFieldView
    }
    
    func configureTextFields(inStackView stackView: UIStackView) {
        for (index, arrangedSubview) in stackView.arrangedSubviews.enumerated() {
            guard let textFieldView = arrangedSubview as? TextFieldView else { return }
            textFieldView.textField.delegate = self
            textFieldView.textField.tag = index
            
            let isLastTextField = index == stackView.arrangedSubviews.count - 1
            textFieldView.textField.returnKeyType = isLastTextField ? .continue :  .next
        }
    }
    
    /// Abstract
    func getTextFieldsStackArrangedSubviews() -> [UIView] { [] }
    
    func setupBindings() {
        firstNameTextFieldView.textField.createBidirectionalBinding(with: viewModel.$firstName,
                                                                    keyPath: \AuthViewModel.firstName,
                                                                    for: viewModel,
                                                                    storeIn: &subscriptions)
        
        lastNameTextFieldView.textField.createBidirectionalBinding(with: viewModel.$lastName,
                                                                   keyPath: \AuthViewModel.lastName,
                                                                   for: viewModel,
                                                                   storeIn: &subscriptions)
        
        usernameTextFieldView.textField.createBidirectionalBinding(with: viewModel.$username,
                                                                   keyPath: \AuthViewModel.username,
                                                                   for: viewModel,
                                                                   storeIn: &subscriptions)
                
        emailTextFieldView.textField.createBidirectionalBinding(with: viewModel.$email,
                                                                keyPath: \AuthViewModel.email,
                                                                for: viewModel,
                                                                storeIn: &subscriptions)
        
        passwordTextFieldView.textField.createBidirectionalBinding(with: viewModel.$password,
                                                                   keyPath: \AuthViewModel.password,
                                                                   for: viewModel,
                                                                   storeIn: &subscriptions)
        
        confirmPasswordTextFieldView.textField.createBidirectionalBinding(with: viewModel.$passwordConfirmation,
                                                                   keyPath: \AuthViewModel.passwordConfirmation,
                                                                   for: viewModel,
                                                                   storeIn: &subscriptions)
    }
    
}

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        focusOnNextTextFieldOnPressReturn(from: textField)
        return false
    }
    
}
