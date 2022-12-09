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
    
    let coordinator: Coordinator
    let viewModel: ChatRoomViewModel
    let chatRoom: ChatRoom
    var subscriptions = Set<AnyCancellable>()
    
    private lazy var fetchControllerDelegate = TableViewFetchedResultsControllerDelegate(tableView: controlledView.tableView)
    private lazy var dataSource = MessagesDataSource(fetchController: fetchedResultsController)
    
    let controlledView: ChatRoomView
            
    lazy var fetchedResultsController: NSFetchedResultsController<Message> = {
        let fetchRequest = Message.fetchRequest()
        
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Message.roomId), chatRoom.id!)
        fetchRequest.predicate = predicate
        
        let dateSort = NSSortDescriptor(key: "sentDateUnixTimeStamp", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        let fetchedResultsController = viewModel.createMessagesFetchController(fetchRequest: fetchRequest)
        return fetchedResultsController
    }()
    
    var scrollViewLowestYOffset: CGFloat = 0
    
    var numberOfMessages: Int {
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
        
        controlledView.messageComposerView.inputFieldContainer.sendBtn.addTarget(self,
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
    
    @objc func didPressSendButton() {
        let currentUser: User
        
        do { currentUser = try viewModel.getCurrentUser() }
        catch { ErrorManager.shared.presentNoCurrentUserError(error: error, reportError: true); return; }
        
        // Generate the message object and attach it to the current chat room.
        let message = viewModel.createMessage(in: chatRoom,
                                              senderId: currentUser.id,
                                              roomId: chatRoom.id!,
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
    
    func setupBindings() {
        controlledView.messageComposerView.inputFieldContainer.inputField
            .createBidirectionalBinding(with: viewModel.$messageText,
                                        keyPath: \ChatRoomViewModel.messageText,
                                        for: viewModel,
                                        storeIn: &subscriptions)
        
        viewModel.$messageText
            .receive(on: DispatchQueue.main)
            .map { !$0.isEmpty }
            .assign(to: \.isEnabled, on: controlledView.messageComposerView.inputFieldContainer.sendBtn)
            .store(in: &subscriptions)
    }
    
    func performFetch() {
        do { try fetchedResultsController.performFetch() }
        catch { ErrorManager.shared.presentError(error, reportError: true) }
    }
    
    func scrollToBottom(animated: Bool = false) {
        // Scroll to bottom after fetch is complete and cells have been laid out
        guard numberOfMessages > 0 else { return }
        let lastIndex = IndexPath(row: 0, section: 0)

        DispatchQueue.main.async {
            self.controlledView.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: animated)
            self.scrollViewLowestYOffset = self.controlledView.tableView.contentOffset.y
        }
    }
    
    func forceNavBarToAlwaysBeTranslucent() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    func forceNavBarToAlwaysBeCompact() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func resetNavBarConfiguration() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    func resetInputField() {
        viewModel.messageText = ""
    }
}

extension ChatRoomViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
