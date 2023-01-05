//
//  ChatsCoordinatorMock.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 26/12/2022.
//

import UIKit

class ChatsCoordinatorMock: Coordinator, Chatting {
	var children = Array<Coordinator>()
	let navigationController = UINavigationController()
	
	func start() {
		
	}
	
	func chat(in chatRoom: ChatRoom) {
		
	}
}
