//
//  PlainTextMessageTableViewCell.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 09/06/2022.
//

import UIKit

class PlainTextMessageTableViewCell: MessageTableViewCell {

    var textMessageLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override  func handleViewModelUpdate(_ viewModel: Message) {
        super.handleViewModelUpdate(viewModel)
        textMessageLabel.text = viewModel.text
        setChatBubbleWidthConstraint()
    }
    
    override  func setupSubviews() {
        super.setupSubviews()
        setupTextMessageLabel()
    }

    func setupTextMessageLabel() {
        messageContentView.addSubview(textMessageLabel)
        
        NSLayoutConstraint.activate([
            textMessageLabel.topAnchor.constraint(equalTo: messageContentView.topAnchor),
            textMessageLabel.leadingAnchor.constraint(equalTo: messageContentView.leadingAnchor),
            textMessageLabel.bottomAnchor.constraint(equalTo: messageContentView.bottomAnchor),
            textMessageLabel.trailingAnchor.constraint(equalTo: messageContentView.trailingAnchor),
        ])
    }
    
    private func setChatBubbleWidthConstraint() {
        let labelIntrinsicContentWidth = textMessageLabel.intrinsicContentSize.width
        
//        if labelIntrinsicContentWidth > 200 {
//            NSLayoutConstraint.deactivate([chatBubbleWidthAnchorConstraint])
//        } else {
        print("textMessageLabel.text", textMessageLabel.text)
        print("labelIntrinsicContentWidth", labelIntrinsicContentWidth)
            chatBubbleWidthAnchorConstraint.constant = labelIntrinsicContentWidth + chatBubbleLeadingPadding + chatBubbleTrailingPadding
//        }
    }
    
}
