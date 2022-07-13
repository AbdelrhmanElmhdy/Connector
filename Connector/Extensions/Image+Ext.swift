//
//  Image+Ext.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 19/04/2022.
//

import Foundation
import UIKit
import SwiftUI

extension Image {
    init?(data: Data) {
        guard let uiImage = UIImage(data: data) else { return nil }
        self.init(uiImage: uiImage)
    }
}
