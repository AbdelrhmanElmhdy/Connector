//
//  ContentView.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 17/04/2022.
//
 
import Foundation

struct Router<EndPoint: Endpoint> {
    
    func request(_ endpoint: EndPoint, completion: @escaping (_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void) {
        do {
            let request = try self.buildRequest(from: endpoint)
            print(request.url)
            
            URLSession.shared.dataTask(with: request, completionHandler: completion).resume()                                
        } catch {
            completion(nil, nil, error)
        }
    }
    
    fileprivate func buildRequest(from endpoint: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: endpoint.url, timeoutInterval: 10.0)
        
        // Set the http method
        request.httpMethod = endpoint.httpMethod.rawValue
        
        // Set the body parameters
        if let bodyParameters = endpoint.bodyParameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
        }
        
        // Set the headers
        if let headers = endpoint.headers {
            setRequestHeaders(headers, for: &request)
        }
        
        return request
    }
    
    fileprivate func setRequestHeaders(_ headers: HTTPHeaders, for request: inout URLRequest) {
        for (headerField, value) in headers {
            request.setValue(value, forHTTPHeaderField: headerField)
        }
    }
    
}
