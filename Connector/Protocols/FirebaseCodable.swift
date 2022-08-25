//
//  FirebaseCodable.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 24/08/2022.
//

import Foundation
import CoreData
import FirebaseFirestore

protocol FirebaseCodable: AnyObject {
    init(context: NSManagedObjectContext, document: DocumentSnapshot)
    
    func encodeToDictionary() -> [String: Any?]
}
