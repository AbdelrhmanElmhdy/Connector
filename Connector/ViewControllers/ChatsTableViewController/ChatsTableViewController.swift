//
//  ChatsTableViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/06/2022.
//

import UIKit
import CoreData

let chatCellReuseIdentifier = "chatCellReuseIdentifier"

class ChatsTableViewController: UITableViewController {
    // MARK: Properties
    
    unowned var coordinator: Chatting
    let viewModel: ChatsTableViewModel
    
    private lazy var fetchControllerDelegate = FetchedResultsControllerDelegate(tableView: tableView)
    private lazy var dataSource = ChatRoomsDataSource(fetchController: fetchController)
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsTableViewController())
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Chats".localized
        
        return searchController
    }()
    
    lazy var fetchController: NSFetchedResultsController<ChatRoom> = {
        let fetchRequest = ChatRoom.fetchRequest()
        fetchRequest.relationshipKeyPathsForPrefetching = ["participants"]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastMessageTimeStamp", ascending: false)]
        
        let fetchController = viewModel.createChatRoomsFetchController(fetchRequest: fetchRequest)
        return fetchController
    }()
    
    // MARK: Initialization
    
    init(coordinator: Chatting, viewModel: ChatsTableViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chats".localized
        navigationItem.searchController = searchController
        
        fetchController.delegate = fetchControllerDelegate
        tableView.dataSource = dataSource
        tableView.rowHeight = 85
        
        
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: chatCellReuseIdentifier)
        
        do {
            try fetchController.performFetch()
            try viewModel.startListeningForIncomingMessages()
        } catch {
            ErrorManager.shared.presentError(error, reportError: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
    // MARK: Convenience
    
    func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatRoom = fetchController.object(at: indexPath)
        coordinator.chatIn(chatRoom)
    }
}
