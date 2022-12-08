//
//  SignupView.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/12/2022.
//

import UIKit

class SignupView: AuthView {
    
    override var textFields: [TextFieldView] {
        return [firstNameTextFieldView, lastNameTextFieldView, emailTextFieldView, usernameTextFieldView, passwordTextFieldView, confirmPasswordTextFieldView]
    }
    
    var signupButton: UIButton { authenticationBtn }
    var loginButton: UIButton { otherAuthMethodBtn }
    var loginLabel: UILabel { otherAuthMethodLabel }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        // Configure labels and button titles.
        signupButton.setTitle("Create Account".localized, for: .normal)
        loginLabel.text = "Already have an account?".localized
        loginButton.setTitle("Login".localized, for: .normal)
    }
    
}
