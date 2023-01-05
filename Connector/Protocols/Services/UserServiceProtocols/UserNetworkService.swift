//
//  UserNetworkService.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 02/12/2022.
//

import Foundation
import CoreData

protocol UserNetworkService: AutoMockable {  
	func setUserData(user: User)
	
	func fetchUser(withId uid: String, backgroundMOC: NSManagedObjectContext, completion: @escaping (_ user: User?, _ error: Error?) -> Void)
	
	func searchForUsers(withUsernameSimilarTo username: String,
											backgroundMOC: NSManagedObjectContext,
											handler: @escaping (_ users: [User]?, _ error: Error?) -> Void)
	
	func cancelUserSearch()
}
