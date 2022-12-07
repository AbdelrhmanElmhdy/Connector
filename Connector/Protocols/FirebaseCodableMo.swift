//
//  FirebaseCodable.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 24/08/2022.
//

import Foundation
import CoreData
import FirebaseFirestore

typealias FirebaseData = [String : Any]

protocol FirebaseCodableMo: NSManagedObject {
    init?(document: DocumentSnapshot?, context: NSManagedObjectContext)
    
    func encodeToFirebaseData() -> FirebaseData
}
