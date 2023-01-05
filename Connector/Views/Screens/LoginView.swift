//
//  LoginView.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/12/2022.
//

import UIKit

class LoginView: AuthView {
	
	lazy var emailTextFieldView = createEmailTextField()
	lazy var passwordTextFieldView = createPasswordTextField(name: .ui.password)
	
	override var textFieldViews: [TextFieldView] {
		return [emailTextFieldView, passwordTextFieldView]
	}
	
	var loginButton: PrimaryButton { authenticationButton }
	var createAccountButton: UIButton { otherAuthMethodButton }
	var notExistingUserLabel: UILabel { otherAuthMethodLabel }
	
	override func setupSubviews() {
		super.setupSubviews()
		
		// Configure labels and button titles
		loginButton.setTitle(.ui.login, for: .normal)
		notExistingUserLabel.text = .ui.notExistingUserLabel
		createAccountButton.setTitle(.ui.createAccountSuggestionBtnTitle, for: .normal)
	}
	
}
