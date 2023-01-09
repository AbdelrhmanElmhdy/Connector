//
//  ChatsTableViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/06/2022.
//

import CoreData
import UIKit
import Combine

let chatCellReuseIdentifier = "chatCellReuseIdentifier"

class ChatsTableViewController: UITableViewController {
	// MARK: Properties
	
	unowned var coordinator: Chatting
	let viewModel: ChatsTableViewModel
	
	private lazy var searchController: UISearchController = {
		let searchResultsController = SearchResultsTableViewController()
		searchResultsController.delegate = self
		
		let searchController = UISearchController(searchResultsController: searchResultsController)
		
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = .ui.chatsSearchBarPlaceholder
		
		return searchController
	}()
	
	private lazy var fetchController: NSFetchedResultsController<ChatRoom> = {
		let fetchRequest = ChatRoom.fetchRequest()
		fetchRequest.relationshipKeyPathsForPrefetching = ["participants"]
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastMessageTimeStamp", ascending: false)]
		
		let fetchController = viewModel.createChatRoomsFetchController(fetchRequest: fetchRequest)
		return fetchController
	}()
	
	private lazy var fetchControllerDelegate = TableViewFetchedResultsControllerDelegate(tableView: tableView)
	private lazy var dataSource = ChatRoomsDataSource(fetchController: fetchController)
	
	private var subscriptions = Set<AnyCancellable>()
	
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
		
		title = .ui.chats
		
		bindSearchTextField()
		
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
	
	// MARK: TableView Delegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let chatRoom = fetchController.object(at: indexPath)
		coordinator.chat(in: chatRoom)
	}
	
	// MARK: Convenience
	
	private func configureNavBar() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .always
	}
	
	private func bindSearchTextField() {
		searchController.searchBar.searchTextField.textPublisher
			.debounce(for: 0.5, scheduler: RunLoop.main)
			.compactMap { $0 }
			.sink(receiveValue: {[weak self] text in
				guard let self = self else { return }
				self.didSearch(for: text, in: self.searchController)
			})
			.store(in: &subscriptions)
	}
}

// MARK: Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ChatsTableViewController_Preview: PreviewProvider {
	static var previews: some View {
		ForEach(deviceNames, id: \.self) { deviceName in
			UIViewControllerPreview {
				AppDelegate.shared.viewControllerFactory.createChatsTableViewController(for: ChatsCoordinatorMock())
			}.previewDevice(PreviewDevice(rawValue: deviceName))
				.previewDisplayName(deviceName)
		}
	}
}
#endif
