//
//  KeychainManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import Foundation

protocol KeychainManager: AnyObject {
    
    var currentUserId: String { get set }
    var accessToken: String { get set }
    
}
