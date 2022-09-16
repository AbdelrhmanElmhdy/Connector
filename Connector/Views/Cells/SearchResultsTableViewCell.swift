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
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    lazy var rootHStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [personImageView, nameLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
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
        setupRootHStack()
        setupPersonImageView()
        setupNameLabel()
    }
        
    private func setupRootHStack() {
        contentView.addSubview(rootHStack)
        
        NSLayoutConstraint.activate([
            rootHStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            rootHStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            rootHStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            rootHStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    private func setupPersonImageView() {
        personImageView.widthAnchor.constraint(equalTo: personImageView.heightAnchor).isActive = true
    }
    
    private func setupNameLabel() {
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

}
