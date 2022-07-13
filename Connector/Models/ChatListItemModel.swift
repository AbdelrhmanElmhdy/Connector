//
//  ChatListItemModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/06/2022.
//

import Foundation
import UIKit

struct ChatListItemModel {
    let chatId: UUID
    let chatName: String
    let lastMessage: String
    let chatImage: UIImage
    let chatDate: Date
}
