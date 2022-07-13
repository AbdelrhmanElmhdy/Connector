//
//  UserModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 18/04/2022.
//

import Foundation
import UIKit

struct User: Codable {
    var id: UUID
    var name: String
    var username: String
    var email: String
    // TODO: declare a thumbnail image url
    var imageUrl: String
}

extension User {
    init(id: UUID) {
        self.id = id
        name = "test2"
        username = "test2"
        email = "test"
        imageUrl = "test"
    }
}
