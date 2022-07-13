//
//  String + Ext.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 17/04/2022.
//

import Foundation

public typealias Parameters = [String:Any]
public typealias HTTPHeaders = [String:String]

protocol Endpoint {
    var baseUrl: URL { get }
    var path: String { get }
    var url: URL { get }
    var httpMethod: HTTPMethod { get }
    var bodyParameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
}

extension Endpoint {
    var url: URL {
        URL(string: path, relativeTo: baseUrl)!
    }
}
