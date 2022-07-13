//
//  ChatViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/06/2022.
//

import UIKit

let plainTextMessageCellReuseIdentifier = "plainTextMessageCellReuseIdentifier"
class ChatViewController: UIViewController, Observer {
    let user = UserDefaultsManager.user!
    
    lazy var messages: [Message] = []
    
    var roomId: UUID!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let chatInputFieldContainer: ChatInputFieldContainer = {
        let inputField = ChatInputFieldContainer(frame: .zero)
        
        inputField.layer.borderColor = UIColor.systemGray2.cgColor
        inputField.layer.borderWidth = 1
        inputField.sendBtn.addTarget(self, action: #selector(handleSendBtnTap), for: .touchUpInside)
        
        inputField.translatesAutoresizingMaskIntoConstraints = false
        return inputField
    }()
    
    init(chatId: UUID) {
        super.init(nibName: nil, bundle: nil)
        
        self.roomId = chatId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        ChatMessagesManager.shared.addObserver(self)
        
        tableView.register(PlainTextMessageTableViewCell.self,
                           forCellReuseIdentifier: plainTextMessageCellReuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600        
        
        setupSubviews()
        update()
    }
    
    func update(event: ChatMessagesManager.Event? = nil) {
        do {
            messages = try CoreDataManager.retrieveMessages(forRoomId: roomId)
            tableView.reloadData()
        } catch {
            // TODO: Display error to the user
            ErrorManager.reportError(error)
        }        
    }
    
    func setupSubviews() {
        setupTableView()
        setupChatInputFieldContainer()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
        
    func setupChatInputFieldContainer() {
        view.addSubview(chatInputFieldContainer)
        
        NSLayoutConstraint.activate([
            chatInputFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            chatInputFieldContainer.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -15),
            chatInputFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            chatInputFieldContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: ChatInputFieldContainer.minHeight),
            chatInputFieldContainer.heightAnchor.constraint(lessThanOrEqualToConstant: ChatInputFieldContainer.maxHeight),
        ])
                
        chatInputFieldContainer.layer.cornerRadius = ChatInputFieldContainer.minHeight / 2
    }
            
    func generateStubMessages() -> [Message] {
        let message1 = Message(context: CoreDataManager.context)
        message1.id = UUID()
        message1.senderId = UUID()
        message1.roomId = roomId
        message1.type = 0
        message1.text = "Hey"
        
        let message2 = Message(context: CoreDataManager.context)
        message2.id = UUID()
        message2.senderId = UUID()
        message2.roomId = roomId
        message2.type = 0
        message2.text = "Hi there!"
        
        let message3 = Message(context: CoreDataManager.context)
        message3.id = UUID()
        message3.senderId = UUID()
        message3.roomId = roomId
        message3.type = 0
        message3.text = "How is everything going?"
        
        
        let message4 = Message(context: CoreDataManager.context)
        message4.id = UUID()
        message4.senderId = UUID()
        message4.roomId = roomId
        message4.type = 0
        message4.text = "every thing is going great! and yesterday at work a gave a presentation about the new building iv'e been designing and both the client and my manager seemed to really love it.. some of my colleagues say that i may get my self a promotion soon if i continue up the good work! 🤩🤩"
        
        return [message1, message2, message3, message4]
    }
    
    // MARK: Event Handlers
    
    @objc func handleSendBtnTap() {
        let messageText = chatInputFieldContainer.inputField.text
        let message = Message(senderId: user.id, roomId: roomId, type: .text, text: messageText)
        
        chatInputFieldContainer.inputField.text = ""
        
        do {
            try ChatMessagesManager.shared.sendMessage(message)
        } catch {
            // TODO: display error the user
            ErrorManager.reportError(error)
        }
        
    }

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell: MessageTableViewCell!
        
        switch message.messageType {
        case .text:
            cell = tableView.dequeueReusableCell(withIdentifier: plainTextMessageCellReuseIdentifier, for: indexPath) as! PlainTextMessageTableViewCell
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: plainTextMessageCellReuseIdentifier, for: indexPath) as! PlainTextMessageTableViewCell
        }
        
        cell.viewModel = message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
