//
//  ChatsTableViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/06/2022.
//

import UIKit
import SocketIO

let profilePic = UIImage(named: "profilePic")!

let roomId = UUID()

class ChatsTableViewController: UITableViewController {
        
    var chatListItemModels: [ChatListItemModel] = [
        ChatListItemModel(chatId: roomId, chatName: "Abdelrhman", lastMessage: "Hi!", chatImage: profilePic, chatDate: Date()),
        
        ChatListItemModel(chatId: UUID(), chatName: "Mahdy", lastMessage: "Hyd?", chatImage: profilePic, chatDate: Date().addingTimeInterval(-4 * 24 * 60 * 60)),
        
        ChatListItemModel(chatId: UUID(), chatName: "Mahdy", lastMessage: "Hyd?", chatImage: profilePic, chatDate: Date().addingTimeInterval(-1 * 13 * 60 * 60)),
        ChatListItemModel(chatId: UUID(), chatName: "Abdelrhman", lastMessage: "Ready?", chatImage: profilePic, chatDate: Date()),
        
        ChatListItemModel(chatId: UUID(), chatName: "Mahdy", lastMessage: "Hyd?", chatImage: profilePic, chatDate: Date().addingTimeInterval(-4 * 24 * 60 * 60)),
        
        ChatListItemModel(chatId: UUID(), chatName: "Mahdy", lastMessage: "Hyd?", chatImage: profilePic, chatDate: Date().addingTimeInterval(-1 * 13 * 60 * 60)),
        ChatListItemModel(chatId: UUID(), chatName: "Abdelrhman", lastMessage: "Ready?", chatImage: profilePic, chatDate: Date()),
        
        ChatListItemModel(chatId: UUID(), chatName: "Mahdy", lastMessage: "Hyd?", chatImage: profilePic, chatDate: Date().addingTimeInterval(-4 * 24 * 60 * 60)),
        
        ChatListItemModel(chatId: UUID(), chatName: "Mahdy", lastMessage: "Hyd?", chatImage: profilePic, chatDate: Date().addingTimeInterval(-1 * 13 * 60 * 60)),
    ]
    
    var filteredChatListItemModels: [ChatListItemModel] = []
    var currentlyShownChatListItemModels: [ChatListItemModel] {
        return isFiltering ? filteredChatListItemModels : chatListItemModels
    }
        
    var isFiltering = false
    
    private let chatCellReuseIdentifier = "chatCellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chatRoom = ChatRoom(context: CoreDataManager.context)
        chatRoom.id = roomId
        chatRoom.messages = []
        chatRoom.participantsIDs = [UserDefaultsManager.user!.id, UUID()]
        
        try! CoreDataManager.context.save()
        
        chatListItemModels = chatListItemModels.sorted { $0.chatDate > $1.chatDate }
        tableView.reloadData()
                
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: chatCellReuseIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentlyShownChatListItemModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: chatCellReuseIdentifier, for: indexPath) as! ChatTableViewCell

        cell.viewModel = currentlyShownChatListItemModels[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatId = currentlyShownChatListItemModels[indexPath.row].chatId
        
        let chatViewController = ChatViewController(chatId: chatId)
        
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}


extension ChatsTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText.hasPrefix("@") {
            let username = searchText.replacingOccurrences(of: "@", with: "")
                        
            NetworkManager.searchUsersByUserName(username: username) { users, error in
                if let error = error {
                    ErrorManager.reportError(error)
                    return
                }
                
                print(users)
            }
        }

        
        filteredChatListItemModels = chatListItemModels.filter { $0.chatName.lowercased().contains(searchText.lowercased())
        }
        
        isFiltering = true
        
        tableView.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        isFiltering = false
        tableView.reloadData()
    }
}
