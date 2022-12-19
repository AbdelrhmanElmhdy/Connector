//
//  SignupView.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/12/2022.
//

import UIKit

class SignupView: AuthView {
    
    var signupViewModel: SignupViewModel {
        viewModel as! SignupViewModel
    }
    
    lazy var firstNameTextFieldView = createNameTextField(name: "First Name".localized)
    lazy var lastNameTextFieldView = createNameTextField(name: "Last Name".localized)
    lazy var emailTextFieldView = createEmailTextField()
    lazy var usernameTextFieldView = createUsernameTextField()
    lazy var passwordTextFieldView = createPasswordTextField(name: "Password".localized,
                                                             validators: [signupViewModel.passwordComplexityValidator])
    
    lazy var confirmPasswordTextFieldView: TextFieldView = {
        let textField = createPasswordTextField(name: "Confirm Password".localized,
                                                validators: [signupViewModel.passwordConfirmationMatchingValidator])
        textField.nameAsNoun = "Password Confirmation".localized
        return textField
    }()
    
    override var textFieldViews: [TextFieldView] {
        return [firstNameTextFieldView, lastNameTextFieldView, emailTextFieldView, usernameTextFieldView, passwordTextFieldView, confirmPasswordTextFieldView]
    }
        
    var signupButton: PrimaryButton { authenticationButton }
    var loginButton: UIButton { otherAuthMethodButton }
    var loginLabel: UILabel { otherAuthMethodLabel }
    
    init(viewModel: SignupViewModel) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        // Configure labels and button titles.
        signupButton.setTitle("Create Account".localized, for: .normal)
        loginLabel.text = "Already have an account?".localized
        loginButton.setTitle("Login".localized, for: .normal)
    }
    
}
