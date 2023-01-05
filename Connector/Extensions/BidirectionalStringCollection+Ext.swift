//
//  ChatRoomViewModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 22/03/2022.
//

import Foundation

extension BidirectionalCollection where Element: StringProtocol {
	
	/// Joins the array of string values as a sentence by separating the elements with commas and an "and" before the trailing element
	/// - Returns: String containing the elements of the array joined with commas and a trailing "and"
	public func joinedAsSentence() -> String {
		let comma = ",".localized + " "
		let and = " " + "and".localized + " "
		
		guard let last = last else { return "" }
		
		if count <= 2 {
			return joined(separator: and)
		}
		
		return dropLast().joined(separator: comma) + and + last
	}
}
