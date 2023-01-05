//
//  ViewAndViewModelBinder.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/12/2022.
//

import UIKit
import Combine

class ViewAndViewModelBinder<View: UIView, ViewModel: AnyObject> {
	let view: View
	let viewModel: ViewModel
	
	var subscriptions: Set<AnyCancellable> = []
	
	init(view: View, viewModel: ViewModel) {
		self.view = view
		self.viewModel = viewModel
	}
	
	// Abstract
	func setupBindings() {
		
	}
	
	func removeBindings() {
		subscriptions.removeAll()
	}
	
	deinit {
		removeBindings()
	}
}

