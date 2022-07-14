//
//  NetworkManager.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 17/04/2022.
//

import Foundation
import SocketIO

struct NetworkManager {
    static let router = Router<API>()
    
    static let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(false), .compress])
    static let socket = manager.defaultSocket
            
    static func initializeSocketConnection() {
        socket.connect()
    }
    
    static func deinitializeSocketConnection() {
        socket.disconnect()
    }
    
    static func listenForIncomingMessages(completionHandler: @escaping (_ message: [Message]) -> Void) {
        socket.on(SocketEvent.newMessage.rawValue) { data, ack in
            guard let messagesString = data as? String else { return }
            guard let messageData = messagesString.data(using: .utf8, allowLossyConversion: false) else { return }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.userInfo[CodingUserInfoKey.managedObjectContext] = CoreDataManager.context
            
            guard let messages = try? jsonDecoder.decode([Message].self, from: messageData) else { return }
            
            completionHandler(messages)
        }
    }
    
    static func sendMessage(message: Message, completionHandler: @escaping () -> Void) {
        guard let stringJsonMessage = SerializationTools.encodeToJsonString(message) else {
            ErrorManager.reportError(NetworkError.encodingFailed)
            return
        }
        socket.emit(SocketEvent.newMessage.rawValue, stringJsonMessage, completion: completionHandler)
    }
    
    // MARK: Fetcher Methods
        
    static func login(username: String, password: String, completion: @escaping(_ token: String?, _ user: User?, _ error: Error?) -> Void) {
        router.request(.login(username: username, password: password)) { data, response, error in
            if let error = error {
                ErrorManager.reportError(error)
                completion(nil, nil, error)
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(nil, nil, NetworkError.httpResponseError(statusCode: response.statusCode))
                return
            }
            
            // Decode data as LoginAndSignupResponseModel
            guard let data = data else {
                completion(nil, nil, NetworkError.decodingFailed)
                return
            }

            print(String(data: data, encoding: .utf8)!)
            
            do {
                let result = try JSONDecoder().decode(LoginAndSignupApiResponseModel.self, from: data)
                completion(result.accessToken, result.user, nil)
            } catch {
                completion(nil, nil, error)
            }
            
        }
        
    }
    
    static func signup(firstName: String,
                       lastName: String,
                       username: String,
                       email: String,
                       password: String,
                       completion: @escaping(_ token: String?, _ user: User?, _ error: Error?) -> Void) {
        router.request(.signup(firstName: firstName, lastName: lastName, email: email, username: username, password: password)) { data, response, error in
            if let error = error {
                ErrorManager.reportError(error)
                completion(nil, nil, error)
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(nil, nil, NetworkError.httpResponseError(statusCode: response.statusCode))
                return
            }
            
            // Decode data as LoginAndSignupResponseModel
            guard let data = data else {
                completion(nil, nil, NetworkError.decodingFailed)
                return
            }

            print(String(data: data, encoding: .utf8)!)
            
            do {
                let result = try JSONDecoder().decode(LoginAndSignupApiResponseModel.self, from: data)
                completion(result.accessToken, result.user, nil)
            } catch {
                completion(nil, nil, error)
            }
            
        }
        
    }
    
    static func searchUsersByUserName(username: String, completion: @escaping (_ users: [User]?, _ error: Error?) -> Void) {
        router.request(.searchUsers(username: username)) { data, response, error in
            if let error = error {
                print("is error here?")
                ErrorManager.reportError(error)
                completion(nil, error)
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(nil, NetworkError.httpResponseError(statusCode: response.statusCode))
                return
            }
            
            // Decode data as LoginAndSignupResponseModel
            guard let data = data else {
                completion(nil, NetworkError.decodingFailed)
                return
            }

            print(String(data: data, encoding: .utf8)!)
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(users, nil)
            } catch {
                completion(nil, error)
            }
            
        }
    }
    
}
