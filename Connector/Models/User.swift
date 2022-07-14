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
    var firstName: String
    var lastName: String
    var username: String
    var email: String
    var chatRoomIds: [UUID]
    var imageUrl: URL?
    var thumbnailImageUrl: URL?
}

extension User {
    init(id: UUID) {
        self.id = id
        firstName = ""
        lastName = ""
        username = ""
        email = ""
        chatRoomIds = []
        imageUrl = nil
        thumbnailImageUrl = nil
    }
}
