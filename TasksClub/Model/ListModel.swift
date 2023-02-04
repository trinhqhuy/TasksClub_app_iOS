//
//  ListModel.swift
//  TasksClub
//
//  Created by Trinhqhuy on 09/06/2022.
//

import Foundation

struct ListModel: Identifiable, Equatable, Hashable, Decodable {
    var id: String
    var id_user: String
    var name: String
    var icon: String
    var color: String
}
struct NotificationModel: Identifiable, Equatable, Hashable, Decodable {
    var id_member: String
    var id_list: String
    var id_user: String
    var notification: String
    var idjoin: String
    var intive_member: String
    var id : String
    var name: String
    var icon: String
    var color: String
}
struct InfoGroupModel: Decodable {
    var first: [OwnGroup]
    var second: [NumberModel]
    var third: [NumberModel]//da HT
    var four: [NumberModel]// chua HT
    var five: [NumberModel]// star
    var six : [InfoManagerMember]
}
struct NumberModel: Equatable, Hashable, Decodable {
    var number: String
}
struct InfoManagerMember: Identifiable, Equatable, Hashable, Decodable {
    var id: String
    var avatar: String
    var name: String
}
struct OwnGroup: Equatable, Hashable, Decodable {
    var id_user: String
}
