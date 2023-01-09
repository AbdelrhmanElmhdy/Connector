//
//  ChatsTableViewController+Actions.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 25/08/2022.
//

import UIKit
import CoreData


extension ChatsTableViewController: SearchResultsControllerDelegate {
	
	func didSearch(for searchText: String, in searchController: UISearchController) {
		if searchText.hasPrefix("@") {
			let username = searchText.replacingOccurrences(of: "@", with: "")
			guard username.count > 1 else { return }
			
			viewModel.searchForUsers(by: username) { [weak self] users, error in
				guard let self = self, let users = users, !users.isEmpty else {
					return
				}
				
				let usersObjectIDs: [NSManagedObjectID]
				
				do { usersObjectIDs = try self.viewModel.prepareToMoveUsersToDifferentThread(users: users) }
				catch { ErrorManager.shared.presentError(error, reportError: true); return; }
				
				DispatchQueue.main.async {
					if let error = error {
						ErrorManager.shared.presentError(error, reportError: true)
						return
					}
					
					guard let users = self.viewModel.getExistingUsers(withObjectIDs: usersObjectIDs) else { return }
					
					(searchController.searchResultsController as? SearchResultsTableViewController)?.people = users
				}
			}
		}
	}
	
	func didSelectPerson(person selectedPerson: User) {
		let currentUser: User
		do { currentUser = try viewModel.getCurrentUser() }
		catch { ErrorManager.shared.presentNoCurrentUserError(error: error, reportError: true); return; }
		
		let chatRoomParticipants = [currentUser, selectedPerson]
		let chatRoomParticipantsIds = chatRoomParticipants.map { $0.id }
		
		let chatRoom = viewModel.getExistingChatRoom(chatRoomParticipantsIds) ?? viewModel.createNewChatRoom(withParticipants: chatRoomParticipants)
		
		guard let chatRoom = chatRoom else {
			ErrorManager.shared.presentError(UnwrappingError.failedToUnwrapChatRoom(), reportError: true)
			return
		}
		
		coordinator.chat(in: chatRoom)
	}
	
}
