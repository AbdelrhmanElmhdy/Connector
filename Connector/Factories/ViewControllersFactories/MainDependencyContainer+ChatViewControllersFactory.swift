//
//  MainDependencyContainer+ChatViewControllersFactory.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import Foundation

extension MainDependencyContainer: ChatViewControllersFactory {
    func createChatsTableViewController(for coordinator: Chatting) -> ChatsTableViewController {
        let viewModel = ChatsTableViewModel(userService: userService,
                                            chatRoomService: chatRoomService,
                                            chatMessageService: chatMessageService)
        
        let viewController = ChatsTableViewController(coordinator: coordinator, viewModel: viewModel)
        return viewController
    }
    
    func createChatRoomViewController(for coordinator: Coordinator, chatRoom: ChatRoom) -> ChatRoomViewController {
        let viewModel = ChatRoomViewModel(chatMessageService: chatMessageService, userService: userService)
        let view = ChatRoomView()
        let viewController = ChatRoomViewController(coordinator: coordinator, chatRoom: chatRoom, viewModel: viewModel, view: view)
        return viewController
    }
}
