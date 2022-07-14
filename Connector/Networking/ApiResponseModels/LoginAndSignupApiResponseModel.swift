//
//  LoginAndSignupResponseModel.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 18/04/2022.
//

struct LoginAndSignupApiResponseModel : Decodable {
    var accessToken: String
    var user: User
}
