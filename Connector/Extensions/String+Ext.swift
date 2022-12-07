//
//  String + Ext.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 17/04/2022.
//

import Foundation

extension String {
    var localized: String { NSLocalizedString(self, comment: "") }
        
    var isEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    var includesOneUpperCaseLetter: Bool {
        return NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: self)
    }
    
    var includesOneLowerCaseLetter: Bool {
        return NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: self)
    }
    
    var includesOneDigit: Bool {
        return NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: self)
    }
    
}
