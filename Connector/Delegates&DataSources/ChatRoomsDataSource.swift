//
//  ChatRoomsDataSource.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/12/2022.
//

import Foundation
import UIKit
import CoreData

class ChatRoomsDataSource: NSObject, UITableViewDataSource {
    
    let fetchController: NSFetchedResultsController<ChatRoom>
    
    init(fetchController: NSFetchedResultsController<ChatRoom>) {
        self.fetchController = fetchController
    }
    
    // MARK: Data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfFetchedObjects = fetchController.fetchedObjects?.count ?? 0
        
        if numberOfFetchedObjects == 0 {
            tableView.setEmptyMessage("Your chats will appear here".localized)
            tableView.isScrollEnabled = false
        } else {
            tableView.restore()
            tableView.isScrollEnabled = true
        }

        return numberOfFetchedObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: chatCellReuseIdentifier, for: indexPath) as! ChatTableViewCell
        
        let chatRoom = fetchController.object(at: indexPath)
        cell.model = chatRoom
        
        return cell
    }
    
}
