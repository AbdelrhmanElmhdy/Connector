//
//  ExpectsOutcome.swift
//  ConnectorUITests
//
//  Created by Abdelrhman Elmahdy on 04/01/2023.
//

import XCTest

/// Expects and asserts the occurrence of outcomes of specific outcome type
protocol ExpectsOutcomes {
	associatedtype ExpectedOutcome: Outcome
	var app: XCUIApplication! { get set }
	
	func expect(staticText expectedText: String, timeout: TimeInterval?)
	func expect(_ expectedOutcomes: ExpectedOutcome..., timeout: TimeInterval?)
	func expectAny(of expectedOutcomes: ExpectedOutcome..., timeout: TimeInterval?)
}

extension ExpectsOutcomes {
	/// Asserts the app contains static text.
	/// - Parameters:
	///   - expectedText: The static text that's expected to be displayed in order for the test to pass.
	///   - timeout: The amount of time to wait for the static text to exist.
	func expect(staticText expectedText: String, timeout: TimeInterval? = nil) {
		XCTAssertTrue(app.contains(expectedText, waitFor: timeout))
	}
	
	/// Asserts that all the expected outcomes did occur.
	/// - Parameters:
	///   - expectedOutcomes: The outcomes that are expected to occur in order for the test to pass.
	///   - timeout: The amount of time to wait for the all outcomes' didOccur property to become true.
	func expect(_ expectedOutcomes: ExpectedOutcome..., timeout: TimeInterval? = nil) {
		let allExpectedOutcomesDidOccur = waitForAll(of: expectedOutcomes, timeout: timeout)
		XCTAssertTrue(allExpectedOutcomesDidOccur)
	}
	
	/// Asserts that any of the expected outcomes did occur.
	/// - Parameters:
	///   - expectedOutcomes: The outcomes that are expected to occur in order for the test to pass.
	///   - timeout: The amount of time to wait for the any of the outcomes' didOccur property to become true.
	func expectAny(of expectedOutcomes: ExpectedOutcome..., timeout: TimeInterval? = nil) {
		let allExpectedOutcomesDidOccur = waitForAny(of: expectedOutcomes, timeout: timeout)
		XCTAssertTrue(allExpectedOutcomesDidOccur)
	}
	
	@discardableResult
	private func waitForAll(of expectedOutcomes: [ExpectedOutcome], timeout: TimeInterval?) -> Bool {
		waitFor(resolver: expectedOutcomes.resolveAll(in: app), timeout: timeout)
	}
	
	@discardableResult
	private func waitForAny(of expectedOutcomes: [ExpectedOutcome], timeout: TimeInterval?) -> Bool {
		waitFor(resolver: expectedOutcomes.resolveAny(in: app), timeout: timeout)
	}
	
	@discardableResult
	private func waitFor(resolver: @autoclosure () -> Bool, timeout: TimeInterval?) -> Bool {
		let startTime = Date()
		guard let timeout = timeout else { return resolver() }
		
		while Date().timeIntervalSince(startTime) < timeout {
			let didOccur = resolver()
			if didOccur { return true }
			Thread.sleep(forTimeInterval: 0.1)
		}
		
		return false
	}
}
