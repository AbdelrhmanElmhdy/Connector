//
//  ChatRoomViewController+TableViewDelegate.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 25/08/2022.
//

import UIKit
import CoreData

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfMessages
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = fetchedResultsController.object(at: indexPath)
        let cell: MessageTableViewCell!
        
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
