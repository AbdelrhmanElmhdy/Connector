//
//  SwiftUIPreview.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 25/12/2022.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

let deviceNames: [String] = [
	"iPhone 14 Pro Max",
	"iPhone SE (3rd generation)"
]

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
	let viewController: ViewController
	
	init(_ builder: @escaping () -> ViewController) {
		viewController = builder()
	}
	
	// MARK: - UIViewControllerRepresentable
	func makeUIViewController(context: Context) -> ViewController {
		viewController
	}
	
	func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>) {
		return
	}
}
#endif
