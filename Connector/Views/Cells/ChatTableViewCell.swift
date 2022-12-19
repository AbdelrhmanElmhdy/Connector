//
//  ChatTableViewCell.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/06/2022.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
        
    var model: ChatRoom? {
        didSet {
            guard let model = model else { return }
            
            chatImageView.source = model.chatThumbnailImageURL
            chatNameLabel.text = model.chatName
            timeAndDateLabel.text = model.lastMessageDate?.getLocalizedRelativeShortFormat()
            lastMessageLabel.text = model.lastMessageLabel
        }
    }
    
    let chatImageView: RemoteImageView = {
        let imageView = RemoteImageView(isRound: true)
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let chatNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.minimumScaleFactor = 0.8
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
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    lazy var headerHStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [chatNameLabel, timeAndDateLabel])
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        chatNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return stackView
    }()
    
    lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerHStack, lastMessageLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var rootHStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [chatImageView, vStack])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
        
    override func awakeFromNib() {
        super.awakeFromNib()
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
        setupRootHStack()
        setChatImageViewSquareAspectRatio()
    }
        
    private func setupRootHStack() {
        contentView.addSubview(rootHStack)
        NSLayoutConstraint.activate([
            rootHStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            rootHStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            rootHStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            rootHStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
        ])
    }
    
    private func setChatImageViewSquareAspectRatio() {
        chatImageView.widthAnchor.constraint(equalTo: chatImageView.heightAnchor).isActive = true
    }

}
