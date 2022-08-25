//
//  ChatTableViewCell.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/06/2022.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
        
    var viewModel: ChatRoom? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            chatImageView.source = viewModel.chatThumbnailImageURL
            chatNameLabel.text = viewModel.chatName
            timeAndDateLabel.text = viewModel.lastMessageDate?.getLocalizedRelativeShortFormat()
            lastMessageLabel.text = viewModel.lastMessageLabel
        }
    }
    
    let chatImageView: RemoteImageView = {
        let imageView = RemoteImageView(isRound: true)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerHStack, lastMessageLabel])
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var headerHStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [chatNameLabel, timeAndDateLabel])
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    let chatNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        return label
    }()
    
    let timeAndDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupSubviews() {
        setupChatImageView()
        setupVStack()
    }
    
    private func setupChatImageView() {
        contentView.addSubview(chatImageView)
        NSLayoutConstraint.activate([
            chatImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            chatImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            chatImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            chatImageView.widthAnchor.constraint(equalTo: chatImageView.heightAnchor),
        ])
    }
    
    private func setupVStack() {
        contentView.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: chatImageView.topAnchor),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            vStack.leadingAnchor.constraint(equalTo: chatImageView.trailingAnchor, constant: 15),
        ])
    }

}
