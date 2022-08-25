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
    
    var chatBubbleImageView: UIImageView = {
        let imageView = UIImageView()
                        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var messageContentView = UIView()
    
    var dateTimeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 11)
        label.textColor = .init(red: 230, green: 230, blue: 230)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    lazy var chatBubbleLeadingAnchorConstraint: NSLayoutConstraint = chatBubbleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
    
    lazy var chatBubbleTrailingAnchorConstraint: NSLayoutConstraint = chatBubbleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
    
    lazy var messageContentViewLeadingAnchorConstraint: NSLayoutConstraint = messageContentView.leadingAnchor.constraint(equalTo: chatBubbleImageView.leadingAnchor)
        
    lazy var messageContentViewTrailingAnchorConstraint: NSLayoutConstraint = messageContentView.trailingAnchor.constraint(equalTo: chatBubbleImageView.trailingAnchor)
    
    let chatBubbleStartPadding: CGFloat = 20
    let chatBubbleEndPadding: CGFloat = 13
        
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
        setChatBubbleConstraints(isMessageReceived: viewModel.isIncoming)
        setMessageContentViewConstraintConstants(isMessageReceived: viewModel.isIncoming)
        dateTimeLabel.text = viewModel.sentDate?.getLocalizedRelativeShortFormat(timeStyleWhenDayHasPassed: .short)
    }
    
    func setupSubviews() {
        setupChatBubbleImageView()
        setupMessageContentView()
        setupDateTimeLabel()
    }
    
    private func setupChatBubbleImageView() {
        addSubview(chatBubbleImageView)
                
        NSLayoutConstraint.activate([
            chatBubbleImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            chatBubbleImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            chatBubbleImageView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.9),
        ])
    }
    
    private func setupMessageContentView() {
        messageContentView.translatesAutoresizingMaskIntoConstraints = false
        chatBubbleImageView.addSubview(messageContentView)
        
        NSLayoutConstraint.activate([
            messageContentView.topAnchor.constraint(equalTo: chatBubbleImageView.topAnchor, constant: 6),
            messageContentView.bottomAnchor.constraint(equalTo: chatBubbleImageView.bottomAnchor, constant: -6),
            messageContentViewLeadingAnchorConstraint,
            messageContentViewTrailingAnchorConstraint,
        ])
    
    }
    
    private func setupDateTimeLabel() {
        messageContentView.addSubview(dateTimeLabel)
        
        NSLayoutConstraint.activate([
            dateTimeLabel.bottomAnchor.constraint(equalTo: messageContentView.bottomAnchor, constant: -1),
            dateTimeLabel.rightAnchor.constraint(equalTo: messageContentView.rightAnchor),
            dateTimeLabel.heightAnchor.constraint(equalToConstant: dateTimeLabel.font.pointSize),
            dateTimeLabel.widthAnchor.constraint(lessThanOrEqualTo: messageContentView.widthAnchor),
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
    
    private func setChatBubbleConstraints(isMessageReceived: Bool) {
        let deactivatedConstraint = isMessageReceived ? chatBubbleTrailingAnchorConstraint : chatBubbleLeadingAnchorConstraint
        
        let activatedConstraint = isMessageReceived ? chatBubbleLeadingAnchorConstraint : chatBubbleTrailingAnchorConstraint
        
        NSLayoutConstraint.deactivate([deactivatedConstraint])
        NSLayoutConstraint.activate([activatedConstraint])
    }
    
    private func setMessageContentViewConstraintConstants(isMessageReceived: Bool) {
        let leadingAnchorConstant: CGFloat = isMessageReceived ? chatBubbleStartPadding : chatBubbleEndPadding
        let trailingAnchorConstant: CGFloat = isMessageReceived ? -chatBubbleEndPadding : -chatBubbleStartPadding
        
        messageContentViewLeadingAnchorConstraint.constant = leadingAnchorConstant
        messageContentViewTrailingAnchorConstraint.constant = trailingAnchorConstant
    }        
}
