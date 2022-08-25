//
//  ChatsTableViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/06/2022.
//

import UIKit
import CoreData

fileprivate let chatCellReuseIdentifier = "chatCellReuseIdentifier"

class ChatsTableViewController: UITableViewController {
    // MARK: Properties
    
    var user: User? {
        UserDefaultsManager.user
    }
    
    lazy var fetchController: NSFetchedResultsController<ChatRoom> = {
        let fetchRequest = ChatRoom.fetchRequest()
        
        fetchRequest.relationshipKeyPathsForPrefetching = ["participants"]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastMessageTimeStamp", ascending: false)]
        
        let fetchController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                managedObjectContext: CoreDataManager.context,
                                                sectionNameKeyPath: nil,
                                                cacheName: nil)
        fetchController.delegate = self
        
        return fetchController
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: chatCellReuseIdentifier)
        
        do {
            try fetchController.performFetch()
        } catch {
            ErrorManager.reportError(error)
        }
    }
    
    // MARK: Data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: chatCellReuseIdentifier, for: indexPath) as! ChatTableViewCell

        let chatRoom = fetchController.object(at: indexPath)
        cell.viewModel = chatRoom

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatRoom = fetchController.object(at: indexPath)
        
        let chatViewController = ChatViewController(chatRoom: chatRoom)
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}
