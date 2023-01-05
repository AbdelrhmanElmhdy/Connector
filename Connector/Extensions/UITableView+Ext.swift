//
//  UITableView+Ext.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 06/12/2022.
//

import UIKit

extension UITableView {
	
	func setEmptyMessage(_ message: String) {
		let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
		messageLabel.text = message
		messageLabel.textColor = .systemGray2
		messageLabel.numberOfLines = 0
		messageLabel.textAlignment = .center
		messageLabel.font = .systemFont(ofSize: 22, weight: .medium)
		messageLabel.sizeToFit()
		
		self.backgroundView = messageLabel
		self.separatorStyle = .none
	}
	
	func restore() {
		self.backgroundView = nil
		self.separatorStyle = .singleLine
	}
	
}
