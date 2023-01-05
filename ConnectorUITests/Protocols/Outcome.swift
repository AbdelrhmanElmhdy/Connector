//
//  Outcome.swift
//  ConnectorUITests
//
//  Created by Abdelrhman Elmahdy on 04/01/2023.
//

import XCTest

/// A verifiable state that may or may not occur.
protocol Outcome {
	
	/// Verifies the outcome did occur or not.
	/// - Parameter container: The container in which the outcome should occur in.
	/// - Returns: `true` if the outcome has occurred. `false` if the outcome has not yet occurred.
	func didOccur(in container: XCUIElement) -> Bool
}

extension BidirectionalCollection where Element: Outcome {
	
	/// Checks the didOccur values of all the outcomes and returns their boolean product.
	/// - Parameter container: The container in which the outcome should occur in.
	/// - Returns: `true` if all outcomes did occur, `false` if at least one outcome did not occur.
	func resolveAll(in container: XCUIElement) -> Bool {
		self.map { $0.didOccur(in: container) }.reduce(true) { $0 && $1 }
	}
	
	/// Checks the didOccur values of all the outcomes and returns their boolean summation.
	/// - Parameter container: The container in which the outcome should occur in.
	/// - Returns: `true` if any of the outcomes did occur. `false` if none of the outcomes did occur.
	func resolveAny(in container: XCUIElement) -> Bool {
		self.map { $0.didOccur(in: container) }.reduce(true) { $0 || $1 }
	}
}
