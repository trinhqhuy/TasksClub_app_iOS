//
//  UserModel.swift
//  TasksClub
//
//  Created by Trinhqhuy on 12/06/2022.
//

import Foundation

struct UserModelSearch: Identifiable, Equatable, Hashable, Decodable {
    var id: String
    var name: String
    var avatar: String
}
struct UserResponseModel: Equatable, Hashable, Decodable {
    var error: Bool
    var message: String
    var token: String
}
struct UserSendLoginModel : Decodable {
    var username: String
    var password: String
}
struct UserSendSignUpModel: Decodable {
    var username: String
    var email: String
    var password: String
    var repassword: String
    
}
struct InfomationUser: Identifiable, Equatable, Hashable, Decodable {
    var id: String
    var name: String
    var email: String
    var avatar: String
}
struct UpdateUser: Decodable {
    var avatar: String
    var password: String
    var email: String
}
