//
//  UserStubsFactory.swift
//  ConnectorTests
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import Foundation
import CoreData
import Fakery
@testable import Connector

struct UserStubsFactory {
    let context: NSManagedObjectContext
    let faker: Faker
    
    init(context: NSManagedObjectContext, faker: Faker) {
        self.context = context
        self.faker = faker
    }
    
    func create(_ desiredNumberOfUsers: Int) -> [User] {
        var users = Array<User>()
        
        for _ in 0...desiredNumberOfUsers {
            let user = User(context: context)
            user.id = UUID().uuidString
            user.firstName = faker.name.firstName()
            user.lastName = faker.name.lastName()
            user.username = faker.internet.username().lowercased()
            user.email = faker.internet.email()
            
            users.append(user)
        }
        
        return users
    }
}
