//
//  Observer.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 10/07/2022.
//

import Foundation

protocol Observer: AnyObject {
    func update(event: ChatMessagesManager.Event?)
}
