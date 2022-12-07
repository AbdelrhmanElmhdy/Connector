//
//  UIButton+Ext.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 06/12/2022.
//

import UIKit

extension UIButton {
    open override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: 0.4) {
                self.alpha = self.isEnabled ? 1.0 : 0.5
            }
        }
    }
}
