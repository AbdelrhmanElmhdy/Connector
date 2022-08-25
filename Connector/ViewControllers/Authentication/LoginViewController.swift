//
//  LoginViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import UIKit

class LoginViewController: AuthViewController {
    
    // MARK: Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticationBtn.setTitle("Login".localized, for: .normal)
        otherAuthMethodLabel.text = "Not an existing user?".localized
        otherAuthMethodBtn.setTitle("Create an account".localized, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: Actions
    
    override func didPressAuthenticationButton() {
        let email = emailTextFieldView.text
        let password = passwordTextFieldView.text
        
        // Validate all fields have been provided.
        var allFieldsProvided = true
        
        if !(email ?? "").isEmail {
            emailTextFieldView.showErrorMessage(errorMessage: "Invalid email address".localized)
            allFieldsProvided = false
        }
        if (password ?? "").isEmpty {
            passwordTextFieldView.showIsEmptyErrorMessage()
            allFieldsProvided = false
        }
        
        guard allFieldsProvided else { return }
        
        view.isUserInteractionEnabled = false
        authenticationBtn.isLoading = true
                
        NetworkManager.login(email: email!, password: password!, completion: handleUserLoginCompletion)
    }
    
    override func didPressOtherAuthMethodButton() {
        navigateToSignupScreen()
    }
        
    // MARK: Convenience
    
    func handleUserLoginCompletion(user: User?, error: Error?) {
       DispatchQueue.main.async {
           self.view.isUserInteractionEnabled = true
           self.authenticationBtn.isLoading = false
           
           if let error = error {
               ErrorManager.reportError(error)
               
               let alertPopup = AlertPopup()
               alertPopup.presentAsError(withMessage: "Incorrect email or password".localized)
               
               return
           }
           
           guard let user = user else { return }
           
           UserDefaultsManager.user = user
           UserDefaultsManager.isLoggedIn = true
           
           self.navigateToMainTabBarController()
       }
    }
    
    override func getTextFieldsStackArrangedSubviews() -> [UIView] {
        let arrangedSubviews = [emailTextFieldView, passwordTextFieldView]
        return arrangedSubviews
    }
        
    func navigateToSignupScreen() {
        if previousViewController is SignupViewController {
            navigationController?.popViewController(animated: true)
            return
        }
        
        navigationController?.pushViewController(SignupViewController(), animated: true)
    }
    
}
