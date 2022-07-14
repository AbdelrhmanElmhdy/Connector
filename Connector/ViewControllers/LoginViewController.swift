//
//  LoginViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 13/07/2022.
//

import UIKit

class LoginViewController: AuthViewController {

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
    
    // MARK: Event Handlers
    
    override func handleAuthenticationBtnTap() {
        let username = usernameTextFieldView.text
        let password = passwordTextFieldView.text
        
        // Validate all fields have been provided.
        var allFieldsProvided = true
        if (username ?? "").isEmpty {
            usernameTextFieldView.showIsEmptyErrorMessage()
            allFieldsProvided = false
        }
        
        if (password ?? "").isEmpty {
            passwordTextFieldView.showIsEmptyErrorMessage()
            allFieldsProvided = false
        }
        
        guard allFieldsProvided else { return }
        
        view.isUserInteractionEnabled = false
        authenticationBtn.isLoading = true
                
        NetworkManager.login(username: username!, password: password!) { token, user, error in
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                self.authenticationBtn.isLoading = false
                
                if let error = error {
                    print(error)
                    let alertPopup = AlertPopup()
                    alertPopup.presentAsError(withMessage: "Incorrect username or password".localized)
                    return
                }
                
                guard let user = user, let token = token else { return }
                
                KeychainManager.accessToken = token
                UserDefaultsManager.user = user
                UserDefaultsManager.isLoggedIn = true
                
                
                self.navigateToMainTabBarController()
            }
        }
    }
    
    func handleLoginResponse() {
        
    }
        
    override func handleOtherAuthMethodBtnTap() {
        navigateToSignupScreen()
    }
        
    // MARK: Tools
    
    override func getTextFieldsStackArrangedSubviews() -> [UIView] {
        let arrangedSubviews = [usernameTextFieldView, passwordTextFieldView]
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
