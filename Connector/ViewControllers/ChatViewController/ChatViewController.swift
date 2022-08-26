//
//  ChatViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/06/2022.
//

import UIKit
import CoreData

let plainTextMessageCellReuseIdentifier = "plainTextMessageCellReuseIdentifier"

class ChatViewController: UIViewController {
    // MARK: Properties
    
    let chatRoom: ChatRoom
        
    lazy var fetchedResultsController: NSFetchedResultsController<Message> = {
        let request = Message.fetchRequest()
        
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Message.roomId), chatRoom.id!)
        request.predicate = predicate
        
        let dateSort = NSSortDescriptor(key: "sentDateUnixTimeStamp", ascending: false)
        request.sortDescriptors = [dateSort]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: CoreDataManager.context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    var user: User {
        return UserDefaultsManager.user!
    }
    
    var numberOfMessages: Int {
        fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.keyboardDismissMode = .interactive
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        // Flip the table view on its vertical axis to make scrolling start from bottom to top
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        // Handle the top and bottom of the flipped table view to account for
        // message composer view and nav bar
        tableView.contentInset.bottom = tableViewTopContentInset
        tableView.contentInset.top = tableViewBottomContentInset
        
        tableView.register(PlainTextMessageTableViewCell.self,
                           forCellReuseIdentifier: plainTextMessageCellReuseIdentifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var messageComposerView: MessageComposerView = {
        let inputField = MessageComposerView()
        
        inputField.inputFieldContainer.sendBtn.addTarget(self,
                                                         action: #selector(didPressSendButton),
                                                         for: .touchUpInside)
        
        inputField.translatesAutoresizingMaskIntoConstraints = false
        return inputField
    }()
    
    private var tableViewTopContentInset = LayoutConstants.safeAreaInsets.top
    
    private var tableViewBottomContentInset: CGFloat = {
        let tableViewMarginFromComposerView: CGFloat = 25
        return ChatInputFieldContainer.minHeight + MessageComposerView.verticalPadding - LayoutConstants.safeAreaInsets.top + LayoutConstants.safeAreaInsets.bottom + tableViewMarginFromComposerView
    }()
    
    private lazy var tableViewBottomAnchorConstraint = tableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
    private lazy var messageComposerBottomAnchorConstraint = messageComposerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
    
    
    // MARK: Initializers
    
    
    init(chatRoom: ChatRoom) {
        self.chatRoom = chatRoom
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = chatRoom.chatName
        
        performFetch()
        setupSubviews()
        setupKeyboardDismisserGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make nav bar always translucent even when no content is beneath it, to fix the
        // side effect of reversing the table view.
        forceNavBarToAlwaysBeTranslucent()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // When the transition animation is over force the nav bar to always be compact so when
        // the reversed table view is over-scrolled to bottom the nav bar doesn't expand.
        forceNavBarToAlwaysBeCompact()
    }
    
    override func viewDidLayoutSubviews() {
        // Make both messageComposerView and tableView stretch to the bottom of the display.
        tableViewBottomAnchorConstraint.constant = view.safeAreaInsets.bottom
        messageComposerBottomAnchorConstraint.constant = view.safeAreaInsets.bottom
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
        resetNavBarConfiguration() // To remove the effects from the global nav bar.
    }
    
    
    // MARK: View Setups
    
    
    func setupSubviews() {
        setupTableView()
        setupMessageComposerView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewBottomAnchorConstraint,
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
        
    func setupMessageComposerView() {
        view.addSubview(messageComposerView)
        
        NSLayoutConstraint.activate([
            messageComposerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageComposerBottomAnchorConstraint,
            messageComposerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageComposerView.heightAnchor.constraint(greaterThanOrEqualToConstant: ChatInputFieldContainer.minHeight + MessageComposerView.verticalPadding),
        ])
    }
    
    
    // MARK: Actions
    
    
    @objc func didPressSendButton() {
        let messageText = messageComposerView.text
        
        // Generate the message object and attach it to current chat room.
        let message = Message(senderId: user.id!, roomId: chatRoom.id!, type: .text, text: messageText)
        message.room = chatRoom
        
        chatRoom.lastMessageTimeStamp = message.sentDateUnixTimeStamp
        chatRoom.setLastMessageLabel(message: message)
        
        resetInputField()
        
        do {
            try ChatMessagesManager.shared.sendMessage(message, chatRoomIsInitialized: chatRoom.isInitialized)
        } catch {
            // TODO: display error to the user
            ErrorManager.reportError(error)
        }
    }
    
    
    // MARK: Convenience
    
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
            
            // Scroll to bottom after fetch is complete and cells have been laid out
            DispatchQueue.main.async {
                self.scrollBottom()
            }
        } catch {
            ErrorManager.reportError(error)
        }
    }
    
    func scrollBottom() {
        guard numberOfMessages > 0 else { return }

        let lastIndex = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: lastIndex, at: .bottom, animated: false)
    }
    
    func forceNavBarToAlwaysBeTranslucent() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    func forceNavBarToAlwaysBeCompact() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.showsLargeContentViewer = false
    }
    
    func resetNavBarConfiguration() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    func resetInputField() {
        messageComposerView.text = ""
    }
}
