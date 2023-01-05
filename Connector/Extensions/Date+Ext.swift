//
//  Date+Ext.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 25/08/2022.
//

import Foundation

extension Date {
	func getLocalizedRelativeShortFormat(timeStyleWhenDayHasPassed: DateFormatter.Style = .none) -> String {
		let relativeDateFormatter = DateFormatter()
		
		if Calendar.current.isDateInToday(self) {
			relativeDateFormatter.timeStyle = .short
			relativeDateFormatter.dateStyle = .none
		} else {
			relativeDateFormatter.timeStyle = timeStyleWhenDayHasPassed
			relativeDateFormatter.dateStyle = .short
		}
		
		relativeDateFormatter.locale = .current
		relativeDateFormatter.doesRelativeDateFormatting = true
		return relativeDateFormatter.string(from: self)
	}
}
