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
            guard let viewModel = viewModel else { return }
            personImageView.source = viewModel.thumbnailImageUrl
            nameLabel.text = viewModel.name
        }
    }
    
    let personImageView: RemoteImageView = {
        let imageView = RemoteImageView(isRound: true)
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
        contentView.addSubview(personImageView)
        NSLayoutConstraint.activate([
            personImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            personImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            personImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            personImageView.widthAnchor.constraint(equalTo: personImageView.heightAnchor),
        ])
    }
    
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
        ])
    }

}
