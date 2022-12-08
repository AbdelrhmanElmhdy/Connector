//
//  KeyboardAvoidingView.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 07/12/2022.
//

import UIKit

class KeyboardAvoidingView: UIView {

    public let keyboardAvoidanceLayoutGuide = UILayoutGuide()
    
    private var keyboardHeightConstraint: NSLayoutConstraint!
    private var firstResponderGlobalFrame: CGRect?
    
    init() {
        super.init(frame: .zero)
        setupKeyboardPlaceHolderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillShowOrHide),
                                                   name: UIResponder.keyboardWillChangeFrameNotification,
                                                   object: nil)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
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
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if let firstResponder = firstResponder {
            firstResponderGlobalFrame = firstResponder.globalFrame
        }
                        
        guard let firstResponderGlobalFrame = firstResponderGlobalFrame else { return }
        
        let padding = firstResponderGlobalFrame.height > 80 ? 50 : firstResponderGlobalFrame.height + 35
        
        let firstResponderMaxYWithPadding = firstResponderGlobalFrame.maxY + padding + keyboardHeightConstraint.constant
                
        if endFrameY >= firstResponderMaxYWithPadding {
            self.keyboardHeightConstraint.constant = 0.0
        } else {
            self.keyboardHeightConstraint.constant = firstResponderMaxYWithPadding - endFrameY
        }
        
        UIView.animate(
            withDuration: max(duration, 0.3),
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.layoutIfNeeded() },
            completion: nil)
    }
}
