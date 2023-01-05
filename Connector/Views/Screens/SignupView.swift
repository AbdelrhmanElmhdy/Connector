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
	
	lazy var firstNameTextFieldView = createNameTextField(name: .ui.firstNameTextFieldPlaceholder)
	lazy var lastNameTextFieldView = createNameTextField(name: .ui.lastNameTextFieldPlaceholder)
	lazy var emailTextFieldView = createEmailTextField()
	lazy var usernameTextFieldView = createUsernameTextField()
	lazy var passwordTextFieldView = createPasswordTextField(name: .ui.password,
																													 validators: [
																														signupViewModel.passwordMinimumLengthValidator,
																														signupViewModel.passwordComplexityValidator
																													 ])
	
	lazy var confirmPasswordTextFieldView: TextFieldView = {
		let textField = createPasswordTextField(name: .ui.confirmPasswordTextFieldPlaceholder,
																						validators: [signupViewModel.passwordConfirmationMatchingValidator])
		textField.nameAsNoun = .ui.confirmPasswordTextFieldNounName
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
		signupButton.setTitle(.ui.createAccountBtnTitle, for: .normal)
		loginLabel.text = .ui.alreadyHaveAccountLabel
		loginButton.setTitle(.ui.login, for: .normal)
	}
	
}
