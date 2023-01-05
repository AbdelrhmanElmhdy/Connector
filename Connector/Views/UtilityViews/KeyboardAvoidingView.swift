//
//  KeyboardAvoidingView.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/12/2022.
//

import UIKit

/// Exposes a  property called keyboardAvoidanceLayoutGuide that can be used as a guide to anchor the top most container view
/// the keyboardAvoidanceLayoutGuide avoids the keyboard only if it covers the first responder view and it avoids the view only with by the needed margin
/// to keep the first responder visible with a comfortable margin
class KeyboardAvoidingView: UIView {
	
	private struct TextInputData {
		let container: UIView
		var globalFrame: CGRect? = nil
		let nextInput: UIView?
	}
	
	let keyboardAvoidanceLayoutGuide = UILayoutGuide()
	
	private var textInputsData: [ UIView :  TextInputData ] = [:]
	private var keyboardHeightConstraint: NSLayoutConstraint!
	
	/// UITextInputs or UIViews that contains a UITextInputs.
	var textInputContainers: [UIView] {
		return []
	}
	
	init() {
		super.init(frame: .zero)
		
		let textInputs = textInputContainers.map { getTextInput(form: $0) as? UIView }
		
		for (index, textInput) in textInputs.enumerated() {
			guard let textInput = textInput else { continue }
			
			let isLastInputContainer = index == textInputContainers.count - 1
			let nextInput = isLastInputContainer ? nil : textInputs[index + 1]
			
			self.textInputsData[textInput] = TextInputData(container: textInputContainers[index], nextInput: nextInput)
		}
		
		setupKeyboardPlaceHolderView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func didMoveToWindow() {
		super.didMoveToWindow()
		if window != nil {
			NotificationCenter.default.addObserver(
				self,
				selector: #selector(keyboardWillShowOrHide),
				name: UIResponder.keyboardWillChangeFrameNotification,
				object: nil
			)
		} else {
			NotificationCenter.default.removeObserver(self)
		}
	}
	
	override func layoutSubviews() {
		DispatchQueue.main.async {
			for input in self.textInputsData.keys {
				guard self.textInputsData[input]?.globalFrame == nil else { continue }
				let containerGlobalFrame = self.textInputsData[input]?.container.globalFrame
				self.textInputsData[input]?.globalFrame = containerGlobalFrame
			}
		}
	}
	
	private func getTextInput(form view: UIView) -> UITextInput? {
		if let view = view as? UITextInput { return view }
		let textInput = view.enumeratedSubviews.filter { $0 is UITextInput }.first as? UITextInput
		return textInput
	}
	
	private func setupKeyboardPlaceHolderView() {
		addLayoutGuide(keyboardAvoidanceLayoutGuide)
		
		keyboardHeightConstraint = keyboardAvoidanceLayoutGuide.heightAnchor.constraint(equalToConstant: 0)
		
		NSLayoutConstraint.activate([
			keyboardAvoidanceLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
			keyboardAvoidanceLayoutGuide.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
			keyboardAvoidanceLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
			keyboardHeightConstraint,
		])
	}
	
	@objc private func keyboardWillShowOrHide(notification: NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		guard let firstResponder = firstResponder else { return }
		let firstResponderGlobalFrame = textInputsData[firstResponder]?.globalFrame ?? firstResponder.globalFrame
		guard let firstResponderGlobalFrame = firstResponderGlobalFrame else { return }
		
		let nextInputGlobalFrame: CGRect?
		if let nextInput = textInputsData[firstResponder]?.nextInput {
			let nextInputData = textInputsData[nextInput]
			nextInputGlobalFrame = nextInputData?.globalFrame
		} else {
			nextInputGlobalFrame = nil
		}
		
		let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
		let endFrameY = endFrame?.origin.y ?? 0
		let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
		let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
		let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
		let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
		
		let padding: CGFloat = 25
		
		let avoidableMaxY = (nextInputGlobalFrame?.maxY ?? firstResponderGlobalFrame.maxY + 60 ) + padding
		
		if endFrameY >= avoidableMaxY {
			self.keyboardHeightConstraint.constant = 0.0
		} else {
			self.keyboardHeightConstraint.constant = avoidableMaxY - endFrameY + safeAreaInsets.top
		}
		
		UIView.animate(
			withDuration: max(duration, 0.3),
			delay: TimeInterval(0),
			options: animationCurve,
			animations: { self.layoutIfNeeded() },
			completion: nil
		)
	}
}
