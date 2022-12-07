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
    
    var scrollViewLowestYOffset: CGFloat = 0
    var viewHasLaidOutSubviews = false
        
    var numberOfMessages: Int {
        fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
        
    lazy var fetchedResultsController: NSFetchedResultsController<Message> = {
        let fetchRequest = Message.fetchRequest()
        
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Message.roomId), chatRoom.id!)
        fetchRequest.predicate = predicate
        
        let dateSort = NSSortDescriptor(key: "sentDateUnixTimeStamp", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        let fetchedResultsController = viewModel.createMessagesFetchController(fetchRequest: fetchRequest)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.keyboardDismissMode = .interactive
        tableView.rowHeight = UITableView.automaticDimension
        
        // Flip the table view on its vertical axis to make scrolling start from bottom to top
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        tableView.register(PlainTextMessageTableViewCell.self,
                           forCellReuseIdentifier: plainTextMessageCellReuseIdentifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var messageComposerView: MessageComposerView = {
        let composerView = MessageComposerView()
        
        composerView.inputFieldContainer.sendBtn.addTarget(self,
                                                         action: #selector(didPressSendButton),
                                                         for: .touchUpInside)
        composerView.translatesAutoresizingMaskIntoConstraints = false
        return composerView
    }()
    
    private var tableViewTopContentInset: CGFloat {
        let tableViewMarginFromNavBar: CGFloat = 15
        return view.safeAreaInsets.top - view.safeAreaInsets.bottom + tableViewMarginFromNavBar
    }
    
    private var tableViewBottomContentInset: CGFloat {
        let tableViewMarginFromComposerView: CGFloat = 15
        return -view.safeAreaInsets.top + messageComposerView.frame.height + tableViewMarginFromComposerView
    }
    
    private lazy var tableViewBottomAnchorConstraint = tableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
    private lazy var messageComposerBottomAnchorConstraint = messageComposerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
    
    // MARK: Initialization
    
    init(coordinator: Coordinator, chatRoom: ChatRoom, viewModel: ChatRoomViewModel) {
        self.coordinator = coordinator
        self.chatRoom = chatRoom
        self.viewModel = viewModel

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupSubviews()
        performFetch()
        scrollToBottom()
        setupKeyboardDismisserGestureRecognizer()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make nav bar always translucent even when no content is beneath it, to fix the
        // side effect of reversing the table view.
        title = chatRoom.chatName
        forceNavBarToAlwaysBeTranslucent()
        forceNavBarToAlwaysBeCompact()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        guard !viewHasLaidOutSubviews else { return }
        viewHasLaidOutSubviews = true
        
        // Handle the top and bottom of the flipped table view to account for
        // message composer view and nav bar
        tableView.contentInset.bottom = tableViewTopContentInset
        tableView.contentInset.top = tableViewBottomContentInset
        
        // Make both messageComposerView and tableView stretch to the bottom of the display.
        tableViewBottomAnchorConstraint.constant = view.safeAreaInsets.bottom
        messageComposerBottomAnchorConstraint.constant = view.safeAreaInsets.bottom
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        messageComposerView.inputFieldContainer.inputField
            .createBidirectionalBinding(with: viewModel.$messageText,
                                        keyPath: \ChatRoomViewModel.messageText,
                                        for: viewModel,
                                        storeIn: &subscriptions)
        
        viewModel.$messageText
            .receive(on: DispatchQueue.main)
            .map { !$0.isEmpty }
            .assign(to: \.isEnabled, on: messageComposerView.inputFieldContainer.sendBtn)
            .store(in: &subscriptions)
    }
    
    func performFetch() {
        do { try fetchedResultsController.performFetch() }
        catch { ErrorManager.shared.reportError(error) }
    }
    
    func scrollToBottom(animated: Bool = false) {
        // Scroll to bottom after fetch is complete and cells have been laid out
        guard numberOfMessages > 0 else { return }
        let lastIndex = IndexPath(row: 0, section: 0)

        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: animated)
            self.scrollViewLowestYOffset = self.tableView.contentOffset.y
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
        
        if messageComposerView.viewWithTag(UIView.cascadingViewTag)?.alpha != alphaGreaterThanZero {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.messageComposerView.viewWithTag(UIView.cascadingViewTag)?.alpha = alphaGreaterThanZero
            }
        }
    }
}
