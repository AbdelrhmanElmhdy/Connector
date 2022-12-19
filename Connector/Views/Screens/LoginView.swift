//
//  LoginView.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/12/2022.
//

import UIKit

class LoginView: AuthView {
    
    lazy var emailTextFieldView = createEmailTextField()
    lazy var passwordTextFieldView = createPasswordTextField(name: "Password".localized)
    
    override var textFieldViews: [TextFieldView] {
        return [emailTextFieldView, passwordTextFieldView]
    }
    
    var loginButton: PrimaryButton { authenticationButton }
    var createAccountButton: UIButton { otherAuthMethodButton }
    var createAccountLabel: UILabel { otherAuthMethodLabel }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        // Configure labels and button titles
        loginButton.setTitle("Login".localized, for: .normal)
        createAccountLabel.text = "Not an existing user?".localized
        createAccountButton.setTitle("Create an account".localized, for: .normal)
    }
    
}
