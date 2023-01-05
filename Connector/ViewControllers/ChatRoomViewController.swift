//
//  ChatRoomViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/06/2022.
//

import UIKit
import CoreData
import Combine

let plainTextMessageCellReuseIdentifier = "plainTextMessageCellReuseIdentifier"

class ChatRoomViewController: UIViewController {
	// MARK: Properties
	
	fileprivate let controlledView: ChatRoomView
	private let viewModel: ChatRoomViewModel
	private let chatRoom: ChatRoom
	private unowned var coordinator: Coordinator
	
	private var subscriptions = Set<AnyCancellable>()
	
	private lazy var fetchControllerDelegate = TableViewFetchedResultsControllerDelegate(tableView: controlledView.tableView)
	private lazy var dataSource = MessagesDataSource(fetchController: fetchedResultsController)
	
	
	
	private lazy var fetchedResultsController: NSFetchedResultsController<Message> = {
		let fetchRequest = Message.fetchRequest()
		
		let predicate = NSPredicate(format: "%K == %@", #keyPath(Message.roomId), chatRoom.id)
		fetchRequest.predicate = predicate
		
		let dateSort = NSSortDescriptor(key: "sentDateUnixTimeStamp", ascending: false)
		fetchRequest.sortDescriptors = [dateSort]
		
		let fetchedResultsController = viewModel.createMessagesFetchController(fetchRequest: fetchRequest)
		return fetchedResultsController
	}()
	
	fileprivate var scrollViewLowestYOffset: CGFloat = 0
	
	private var numberOfMessages: Int {
		fetchedResultsController.sections?.first?.numberOfObjects ?? 0
	}
	
	// MARK: Initialization
	
	init(coordinator: Coordinator, chatRoom: ChatRoom, viewModel: ChatRoomViewModel, view: ChatRoomView) {
		self.coordinator = coordinator
		self.chatRoom = chatRoom
		self.viewModel = viewModel
		self.controlledView = view
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: De-Initialization
	
	deinit {
		subscriptions.removeAll()
	}
	
	// MARK: Life Cycle
	
	override func loadView() {
		view = controlledView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		fetchedResultsController.delegate = fetchControllerDelegate
		controlledView.tableView.dataSource = dataSource
		controlledView.tableView.delegate = self
		
		controlledView.messageComposerView.inputFieldContainer.sendButton.addTarget(self,
																																								action: #selector(didPressSendButton),
																																								for: .touchUpInside)
		
		setupBindings()
		performFetch()
		scrollToBottom()
		setupKeyboardDismisserGestureRecognizer()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Make nav bar always translucent even when no content is beneath it, to fix the
		// side effect of reversing the table view.
		title = chatRoom.chatName
		forceNavBarToAlwaysBeTranslucent()
		forceNavBarToAlwaysBeCompact()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		resetNavBarConfiguration() // To remove the effects from the global nav bar.
	}
	
	// MARK: Actions
	
	@objc private func didPressSendButton() {
		let currentUser: User
		
		do { currentUser = try viewModel.getCurrentUser() }
		catch { ErrorManager.shared.presentNoCurrentUserError(error: error, reportError: true); return; }
		
		// Generate the message object and attach it to the current chat room.
		let message = viewModel.createMessage(in: chatRoom,
																					senderId: currentUser.id,
																					roomId: chatRoom.id,
																					type: .text,
																					text: viewModel.messageText)
		
		resetInputField()
		
		do {
			try viewModel.sendMessage(message: message)
		} catch {
			ErrorManager.shared.presentSomethingWentWrongError(originalError: error, reportError: true)
			viewModel.deleteMessage(message)
		}
		
		scrollToBottom(animated: true)
	}
	
	// MARK: Convenience
	
	private func setupBindings() {
		controlledView.messageComposerView.inputFieldContainer.inputField
			.createBidirectionalBinding(with: viewModel.$messageText,
																	keyPath: \ChatRoomViewModel.messageText,
																	for: viewModel,
																	storeIn: &subscriptions)
		
		viewModel.$messageText
			.receive(on: DispatchQueue.main)
			.map { !$0.isEmpty }
			.assign(to: \.isEnabled, on: controlledView.messageComposerView.inputFieldContainer.sendButton)
			.store(in: &subscriptions)
	}
	
	private func performFetch() {
		do { try fetchedResultsController.performFetch() }
		catch { ErrorManager.shared.presentError(error, reportError: true) }
	}
	
	private func scrollToBottom(animated: Bool = false) {
		// Scroll to bottom after fetch is complete and cells have been laid out
		guard numberOfMessages > 0 else { return }
		let lastIndex = IndexPath(row: 0, section: 0)
		
		DispatchQueue.main.async {
			self.controlledView.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: animated)
			self.scrollViewLowestYOffset = self.controlledView.tableView.contentOffset.y
		}
	}
	
	private func forceNavBarToAlwaysBeTranslucent() {
		let navigationBarAppearance = UINavigationBarAppearance()
		navigationBarAppearance.configureWithDefaultBackground()
		navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
	}
	
	private func forceNavBarToAlwaysBeCompact() {
		navigationItem.largeTitleDisplayMode = .never
	}
	
	private func resetNavBarConfiguration() {
		let navigationBarAppearance = UINavigationBarAppearance()
		navigationBarAppearance.configureWithTransparentBackground()
		navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
	}
	
	private func resetInputField() {
		viewModel.messageText = ""
	}
}

extension ChatRoomViewController: UITableViewDelegate, UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// Remove the blur from the message composer view when the table view is scrolled all the way to the bottom.
		let threshHoldLength: CGFloat = 15
		let maximumAlphaThreshHold = scrollViewLowestYOffset + threshHoldLength
		
		let alpha: CGFloat = (-scrollView.contentOffset.y - abs(maximumAlphaThreshHold)) / threshHoldLength
		let alphaLessThanOne = CGFloat.minimum(1, alpha)
		let minimumAlpha = self.traitCollection.userInterfaceStyle == .dark ? 0.65 : 0.25
		let alphaGreaterThanZero = CGFloat.maximum(alphaLessThanOne, minimumAlpha)
		
		if controlledView.messageComposerView.viewWithTag(UIView.cascadingViewTag)?.alpha != alphaGreaterThanZero {
			UIView.animate(withDuration: 0.2) { [weak self] in
				self?.controlledView.messageComposerView.viewWithTag(UIView.cascadingViewTag)?.alpha = alphaGreaterThanZero
			}
		}
	}
}
