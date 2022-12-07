//
//  DependencyContainer.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 26/11/2022.
//

import Foundation

protocol DependencyContainer {
    var userNetworkServices: UserNetworkServicesProtocol { get set }
    var userServices: UserServicesProtocol { get set }
    
    var authNetworkServices: AuthNetworkServicesProtocol { get set }
    var authServices: AuthServicesProtocol { get set }
    
    var chatRoomServices: ChatRoomServicesProtocol { get set }
    
    var chatMessageNetworkServices: ChatMessageNetworkServicesProtocol { get set }
    var chatMessageServices: ChatMessageServicesProtocol { get set }
}
