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
		
		label.font = .systemFont(ofSize: 16)
		label.textColor = .white
		label.numberOfLines = 0
		
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override func handleModelUpdate(_ viewModel: Message) {
		super.handleModelUpdate(viewModel)
		textMessageLabel.text = viewModel.text
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
			textMessageLabel.bottomAnchor.constraint(equalTo: dateTimeLabel.topAnchor, constant: -1),
			textMessageLabel.trailingAnchor.constraint(equalTo: messageContentView.trailingAnchor),
		])
	}
}
