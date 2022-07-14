//
//  SearchResultsTableViewCell.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 14/07/2022.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    var viewModel: User? {
        didSet {
//            guard let viewModel = viewModel else { return }
//            chatImageView.image = viewModel.chatImage
//            chatNameLabel.text = viewModel.chatName
//            let relativeDateFormatter = DateFormatter()
//            if Calendar.current.isDateInToday(viewModel.chatDate) {
//                relativeDateFormatter.timeStyle = .short
//                relativeDateFormatter.dateStyle = .none
//            } else {
//                relativeDateFormatter.timeStyle = .none
//                relativeDateFormatter.dateStyle = .medium
//            }
//            relativeDateFormatter.locale = .current
//            relativeDateFormatter.doesRelativeDateFormatting = true
//            timeAndDateLabel.text = relativeDateFormatter.string(from: viewModel.chatDate)
//
//            lastMessageLabel.text = viewModel.lastMessage
        }
    }
    
    let chatImageView: RoundImageView = {
        let imageView = RoundImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
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
        setupNameLabel()
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
    
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: chatImageView.trailingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
        ])
    }

}
