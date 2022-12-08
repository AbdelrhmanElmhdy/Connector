//
//  LoginView.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/12/2022.
//

import UIKit

class LoginView: AuthView {
    
    override var textFields: [TextFieldView] {
        return [emailTextFieldView, passwordTextFieldView]
    }
    
    var loginButton: UIButton { authenticationBtn }
    var createAccountButton: UIButton { otherAuthMethodBtn }
    var createAccountLabel: UILabel { otherAuthMethodLabel }
        
    override func setupSubviews() {
        super.setupSubviews()
        
        // Remove the password field complexity validator.
        passwordTextFieldView.validators = [viewModel.nonEmptyFieldValidator]
        
        // Configure labels and button titles
        loginButton.setTitle("Login".localized, for: .normal)
        createAccountLabel.text = "Not an existing user?".localized
        createAccountButton.setTitle("Create an account".localized, for: .normal)
    }
    
}
