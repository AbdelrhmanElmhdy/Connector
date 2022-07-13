//
//  ErrorsManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 19/04/2022.
//

import Foundation

struct ErrorManager {
    /// - Stub
    /// - Todo: report error to database
    static func reportError(_ error: Error) {
        print("ERROR: " + error.localizedDescription)
    }
}
