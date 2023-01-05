//
//  MessagesDataSource.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/12/2022.
//

import Foundation
import UIKit
import CoreData

class MessagesDataSource: NSObject, UITableViewDataSource {
	
	let fetchController: NSFetchedResultsController<Message>
	
	init(fetchController: NSFetchedResultsController<Message>) {
		self.fetchController = fetchController
	}
	
	// MARK: Data source
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return fetchController.sections?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchController.sections?[section].numberOfObjects ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let message = fetchController.object(at: indexPath)
		let cell: MessageTableViewCell
		
		switch message.messageType {
		case .text:
			cell = tableView.dequeueReusableCell(withIdentifier: plainTextMessageCellReuseIdentifier, for: indexPath) as! PlainTextMessageTableViewCell
		default:
			cell = tableView.dequeueReusableCell(withIdentifier: plainTextMessageCellReuseIdentifier, for: indexPath) as! PlainTextMessageTableViewCell
		}
		
		cell.transform = CGAffineTransform(scaleX: 1, y: -1)
		
		cell.model = message
		
		return cell
	}
	
}
