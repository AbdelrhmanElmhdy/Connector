//
//  SerializationTools.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 10/07/2022.
//

import Foundation

struct SerializationTools {
    static func encodeToJson<T: Encodable>(_ object: T) -> Data? {
        return try? JSONEncoder().encode(object)
    }
    
    static func encodeToJsonString<T: Encodable>(_ object: T) -> String? {
        let jsonObject = encodeToJson(object)
        
        guard let jsonObject = jsonObject else {
            return nil
        }

        return String(data: jsonObject, encoding: .utf8)
    }
}
