//
//  MessageTableViewCell.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/06/2022.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    var viewModel: Message? {
        didSet {
            guard let viewModel = viewModel else { return }
            handleViewModelUpdate(viewModel)
        }
    }
    
    var chatBubbleImageView: UIImageView = UIImageView()
    var messageContentView = UIView()
    
    var dateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .init(red: 230, green: 230, blue: 230)
        return label
    }()
    
    lazy var rootVStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [messageContentView, dateTimeLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 3
        
        stackView.layoutMargins = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
    var chatBubbleLeadingAnchorConstraint: NSLayoutConstraint!
    var chatBubbleTrailingAnchorConstraint: NSLayoutConstraint!
    var rootVStackLeadingAnchorConstraint: NSLayoutConstraint!
    var rootVStackTrailingAnchorConstraint: NSLayoutConstraint!
    
    private let chatBubbleStartPadding: CGFloat = 20
    private let chatBubbleEndPadding: CGFloat = 13
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleViewModelUpdate(_ viewModel: Message) {
        setChatBubbleImage(isMessageIncoming: viewModel.isIncoming)
        setChatBubbleHorizontalEdgesConstraints(isMessageReceived: viewModel.isIncoming)
        setRootVStackHorizontalConstraintConstants(isMessageReceived: viewModel.isIncoming)
        dateTimeLabel.text = viewModel.sentDate?.getLocalizedRelativeShortFormat(timeStyleWhenDayHasPassed: .short)
    }
    
    func setupSubviews() {
        setupChatBubbleImageView()
        setupRootStackView()
    }
    
    private func setupChatBubbleImageView() {
        contentView.addSubview(chatBubbleImageView)
        chatBubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalMargin: CGFloat = 15
        
        chatBubbleLeadingAnchorConstraint = chatBubbleImageView
            .leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: horizontalMargin)
        
        chatBubbleTrailingAnchorConstraint = chatBubbleImageView
            .trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -horizontalMargin)
        
        NSLayoutConstraint.activate([
            chatBubbleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            chatBubbleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            chatBubbleImageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.9),
        ])
    }
    
    private func setupRootStackView() {
        chatBubbleImageView.addSubview(rootVStack)
        
        rootVStackLeadingAnchorConstraint = rootVStack.leadingAnchor.constraint(equalTo: chatBubbleImageView.leadingAnchor)
        
        rootVStackTrailingAnchorConstraint = rootVStack.trailingAnchor.constraint(equalTo: chatBubbleImageView.trailingAnchor)
        
        NSLayoutConstraint.activate([
            rootVStack.topAnchor.constraint(equalTo: chatBubbleImageView.topAnchor),
            rootVStackLeadingAnchorConstraint,
            rootVStack.bottomAnchor.constraint(equalTo: chatBubbleImageView.bottomAnchor),
            rootVStackTrailingAnchorConstraint,
        ])
    }
            
    private func setChatBubbleImage(isMessageIncoming: Bool) {
        let chatBubbleImage = UIImage(named: isMessageIncoming ? "chat_bubble_incoming" : "chat_bubble_outgoing")
        
        chatBubbleImageView.image = chatBubbleImage?
            .resizableImage(
                withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                resizingMode: .stretch
            )
            .withRenderingMode(.alwaysTemplate)
        
        chatBubbleImageView.tintColor = isMessageIncoming ? .systemGray2 : .systemBlue
    }
    
    private func setChatBubbleHorizontalEdgesConstraints(isMessageReceived: Bool) {
        let deactivatedConstraint: NSLayoutConstraint = isMessageReceived
            ? chatBubbleTrailingAnchorConstraint
            : chatBubbleLeadingAnchorConstraint
        
        let activatedConstraint: NSLayoutConstraint = isMessageReceived
            ? chatBubbleLeadingAnchorConstraint
            : chatBubbleTrailingAnchorConstraint
        
        NSLayoutConstraint.deactivate([deactivatedConstraint])
        NSLayoutConstraint.activate([activatedConstraint])
    }
    
    private func setRootVStackHorizontalConstraintConstants(isMessageReceived: Bool) {
        let leadingAnchorConstant: CGFloat = isMessageReceived ? chatBubbleStartPadding : chatBubbleEndPadding
        let trailingAnchorConstant: CGFloat = isMessageReceived ? -chatBubbleEndPadding : -chatBubbleStartPadding

        rootVStackLeadingAnchorConstraint.constant = leadingAnchorConstant
        rootVStackTrailingAnchorConstraint.constant = trailingAnchorConstant
    }
}
