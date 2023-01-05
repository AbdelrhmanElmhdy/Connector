//
//  UIImage+Ext.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 03/01/2023.
//

import UIKit

extension UIImage {
	
	// MARK: Bundle
	static let accountIcon = UIImage(named: .images.accountIcon)!
	static let authScreenAppIcon = UIImage(named: .images.authScreenAppIcon)!
	static let chatBubbleIncoming = UIImage(named: .images.chatBubbleIncoming)!
	static let chatBubbleOutgoing = UIImage(named: .images.chatBubbleOutgoing)!
	static let generalSettingsIcon = UIImage(named: .images.generalSettingsIcon)!
	static let notificationsIcon = UIImage(named: .images.notificationsIcon)!
	static let soundsIcon = UIImage(named: .images.soundsIcon)!
	static let error = UIImage(named: .images.error)
	
	static let userIcon = UIImage(systemName: "person.circle.fill")!
	static let emailIcon = UIImage(systemName: "envelope.circle.fill")!
	static let passwordIcon = UIImage(systemName: "lock.circle.fill")!
	static let cancel = UIImage(systemName: "xmark")!
	static let message = UIImage(systemName: "message.fill")!
	static let phone = UIImage(systemName: "phone.fill")!
	static let gear = UIImage(systemName: "gear")!
	
	static let sendButton = UIImage(systemName: "arrow.up")!
		.withTintColor(.white)
		.withRenderingMode(.alwaysOriginal)
	
	static let profilePicturePlaceHolder = UIImage(systemName: "person.fill")!
		.withTintColor(.systemGray2)
		.withRenderingMode(.alwaysOriginal)
}
