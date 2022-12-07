//
//  AuthNetworkServicesProtocol.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 03/10/2022.
//

import Foundation
import FirebaseAuth
protocol AuthNetworkServicesProtocol {
    init(firebaseManager: FirebaseManager)
    
    func login(email: String, password: String, completion: @escaping (_ userID: String?, Error?) -> Void)
    func signup(user: User, password: String, completion: @escaping (_ userID: String?, Error?) -> Void)
    func signOut() throws
}
