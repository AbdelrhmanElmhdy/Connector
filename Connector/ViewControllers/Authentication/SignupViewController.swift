//
//  SignupViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import UIKit

class SignupViewController: AuthViewController {

    override func viewDidLoad() {
        logoHeight = max(LayoutConstants.screenHeight * 0.2, 200)
        
        super.viewDidLoad()
        
        authenticationBtn.setTitle("Create Account".localized, for: .normal)
        otherAuthMethodLabel.text = "Already have an account?".localized
        otherAuthMethodBtn.setTitle("Login".localized, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: Event Handlers
    
    override func didPressAuthenticationButton() {
        
        let firstName = firstNameTextFieldView.text
        let lastName = lastNameTextFieldView.text
        let email = emailTextFieldView.text
        let username = usernameTextFieldView.text
        let password = passwordTextFieldView.text
        let passwordConfirmation = confirmPasswordTextFieldView.text
        
        // Validate all fields have been provided.
        var allFieldsProvided = true
        
        if (firstName ?? "").isEmpty {
            firstNameTextFieldView.showIsEmptyErrorMessage()
            allFieldsProvided = false
        }
        if (lastName ?? "").isEmpty {
            lastNameTextFieldView.showIsEmptyErrorMessage()
            allFieldsProvided = false
        }
        if !(email ?? "").isEmail {
            emailTextFieldView.showErrorMessage(errorMessage: "Invalid email address".localized)
            allFieldsProvided = false
        }
        if (username ?? "").isEmpty {
            usernameTextFieldView.showIsEmptyErrorMessage()
            allFieldsProvided = false
        }
        if (password ?? "").isEmpty {
            passwordTextFieldView.showIsEmptyErrorMessage()
            allFieldsProvided = false
        }
        if (passwordConfirmation ?? "").isEmpty {
            confirmPasswordTextFieldView.showIsEmptyErrorMessage()
            allFieldsProvided = false
        }
        
        guard allFieldsProvided else { return }
        
        guard (passwordConfirmation == password) else {
            confirmPasswordTextFieldView.showErrorMessage(errorMessage: "Passwords don't match".localized)
            return
        }
        
        view.isUserInteractionEnabled = false
        authenticationBtn.isLoading = true
                
        NetworkManager.signup(firstName: firstName!, lastName: lastName!, username: username!, email: email!, password: password!, completion: handleUserSignupCompletion)
        
    }
        
    override func didPressOtherAuthMethodButton() {
        navigateToSignupScreen()
    }
        
    // MARK: Convenience
    
    func handleUserSignupCompletion(user: User?, error: Error?) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            self.authenticationBtn.isLoading = false
            
            if let error = error {
                print(error)
                let alertPopup = AlertPopup()
                alertPopup.presentAsError(withMessage: "Incorrect username or password".localized)
                return
            }
            
            guard let user = user else { return }
            
            UserDefaultsManager.user = user
            UserDefaultsManager.isLoggedIn = true
            
            self.navigateToMainTabBarController()
        }
    }
    
    override func getTextFieldsStackArrangedSubviews() -> [UIView] {
        let arrangedSubviews = [firstNameTextFieldView, lastNameTextFieldView, emailTextFieldView, usernameTextFieldView, passwordTextFieldView, confirmPasswordTextFieldView]
        return arrangedSubviews
    }
    
    func navigateToSignupScreen() {
        if previousViewController is LoginViewController {
            navigationController?.popViewController(animated: true)
            return
        }
        
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }

}
