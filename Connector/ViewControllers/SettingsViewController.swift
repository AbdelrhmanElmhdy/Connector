//
//  SettingsViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/06/2022.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    let logoutBtn: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setTitle("Logout".localized, for: .normal)
        btn.addTarget(SettingsViewController.self, action: #selector(logout), for: .touchUpInside)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground        
    }
    
    func setupLogoutBtn() {
        view.addSubview(logoutBtn)
        
        NSLayoutConstraint.activate([
            logoutBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoutBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            logoutBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            logoutBtn.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
            (UIApplication.shared.delegate as? AppDelegate)?.dropEntity(entityName: "User")
            (UIApplication.shared.delegate as? AppDelegate)?.dropEntity(entityName: "ChatRoom")
            (UIApplication.shared.delegate as? AppDelegate)?.dropEntity(entityName: "Message")
            (UIApplication.shared.delegate as? AppDelegate)?.dropEntity(entityName: "Location")
            (UIApplication.shared.delegate as? AppDelegate)?.dropEntity(entityName: "Contact")
            UserDefaultsManager.user = nil
            UserDefaultsManager.isLoggedIn = false
            
            (navigationController?.tabBarController as? RootTabBarViewController)?.presentAuthenticationStack()
        } catch {
            ErrorManager.reportError(error)
        }
    }

}
