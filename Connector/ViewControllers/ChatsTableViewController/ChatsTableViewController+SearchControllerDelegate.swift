//
//  ChatsTableViewController+TableViewDelegate+DataSource.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 25/08/2022.
//

import UIKit


extension ChatsTableViewController: UISearchControllerDelegate, UISearchResultsUpdating, SearchResultsControllerDelegate {
    func didSelectPerson(person: User) {
        let chatRoom = (try? CoreDataManager.fetchChatRoom(withParticipantsIDs: [person.id!])) ?? ChatRoom(participantsIDs: [user!.id!, person.id!])
        chatRoom.participants = [person]
        
        let chatViewController = ChatViewController(chatRoom: chatRoom)
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        (searchController.searchResultsController as? SearchResultsTableViewController)?.delegate = self
        
        if searchText.hasPrefix("@") {
            let username = searchText.replacingOccurrences(of: "@", with: "")
            guard username.count > 1 else { return }
                        
            NetworkManager.searchUsersByUserName(username: username) { users, error in
                
                let usersDescriptions = users!.map { $0.objectID }
                
                DispatchQueue.main.async {
                    if let error = error {
                        ErrorManager.reportError(error)
                        return
                    }
                    
                    let users = usersDescriptions.map { objectId in
                        return CoreDataManager.context.object(with: objectId) as! User
                    }
                    
                    (searchController.searchResultsController as? SearchResultsTableViewController)?.people = users
                }
                
            }
        }
    }
}
