//
//  ChatRoomView.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/12/2022.
//

import UIKit

class ChatRoomView: UIView {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        
        
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
        composerView.translatesAutoresizingMaskIntoConstraints = false
        return composerView
    }()
    
    private var tableViewTopContentInset: CGFloat {
        let tableViewMarginFromNavBar: CGFloat = 15
        return safeAreaInsets.top - safeAreaInsets.bottom + tableViewMarginFromNavBar
    }
    
    private var tableViewBottomContentInset: CGFloat {
        let tableViewMarginFromComposerView: CGFloat = 15
        return -safeAreaInsets.top + messageComposerView.frame.height + tableViewMarginFromComposerView
    }
    
    private lazy var tableViewBottomAnchorConstraint = tableView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor)
    private lazy var messageComposerBottomAnchorConstraint = messageComposerView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor)
    
    init() {
        super.init(frame: .zero)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Handle the top and bottom of the flipped table view to account for
        // message composer view and nav bar
        tableView.contentInset.bottom = tableViewTopContentInset
        tableView.contentInset.top = tableViewBottomContentInset
        
        // Make both messageComposerView and tableView stretch to the bottom of the display.
        tableViewBottomAnchorConstraint.constant = safeAreaInsets.bottom
        messageComposerBottomAnchorConstraint.constant = safeAreaInsets.bottom
    }
    
    func setupSubviews() {
        setupTableView()
        setupMessageComposerView()
    }
    
    func setupTableView() {
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableViewBottomAnchorConstraint,
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
        
    func setupMessageComposerView() {
        addSubview(messageComposerView)
        
        NSLayoutConstraint.activate([
            messageComposerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageComposerBottomAnchorConstraint,
            messageComposerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageComposerView.heightAnchor.constraint(greaterThanOrEqualToConstant: ChatInputFieldContainer.minHeight + MessageComposerView.verticalPadding),
        ])
    }

}
