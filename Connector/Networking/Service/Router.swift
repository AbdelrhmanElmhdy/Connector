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
            guard var urlComponents = URLComponents(url: endpoint.url, resolvingAgainstBaseURL: false) else {
                throw NetworkError.invalidUrl(url: endpoint.url.absoluteString)
            }
            urlComponents.queryItems = generateURLQueryItems(parameters: bodyParameters)
            guard let query = urlComponents.url?.query else { throw NetworkError.parametersError }
            request.httpBody = Data(query.utf8)
        }
        
        // Set the headers
        if let headers = endpoint.headers {
            setRequestHeaders(headers, for: &request)
        }
        
        return request
    }
    
    fileprivate func generateURLQueryItems(parameters: Parameters) -> [URLQueryItem] {
        let queryItems: [URLQueryItem] = parameters.map { name, value in
            URLQueryItem(name: name, value: String(describing: value))
        }
        
        return queryItems
    }
    
    fileprivate func setRequestHeaders(_ headers: HTTPHeaders, for request: inout URLRequest) {
        for (headerField, value) in headers {
            request.setValue(value, forHTTPHeaderField: headerField)
        }
    }
    
}
