//
//  TaskModel.swift
//  TasksClub
//
//  Created by Trinhqhuy on 10/06/2022.
//

import Foundation

struct TasksModel: Decodable {
    let first : [TaskItem]
    let second : [TaskItem]
    let third: [AvatarStack]
}
struct TaskItem: Identifiable, Equatable, Hashable, Decodable {
    var id: String
    var id_list: String
    var id_user: String
    var namelist: String
    var content: String
    var finish : String
    var star : String
    var datefinish: String
    var dateadd: String
}
struct AvatarStack: Equatable, Decodable, Hashable {
    var avatar: String
    var name: String
}
struct ResponseArray: Decodable {
    var message: String
    var error: Bool
}
struct HomeTaskModel: Decodable {
    let first : [HomeTask]
}
struct HomeTask : Equatable, Decodable, Hashable{
    var content: String
    var icon: String
    var color: String
}
struct StatsModel: Decodable {
//    let first : [StatsTask]
//    let second : [StatsTask]
//    let third : [StatsTask]
    let four: [StatsStarModel]
    let five: [StatsStarModel]
    let six: [StatsTask]
    let seven: [StatsTask]
    let eight: [StatsTask]
}
struct StatsTask: Decodable {
    var star: String
}
struct StatsStarModel: Identifiable, Equatable, Hashable, Decodable {
    var id: String
    var id_list: String
    var id_user: String
    var name : String
    var icon: String
    var color: String
    var namelist: String
    var content: String
    var finish : String
    var star : String
    var datefinish: String
    var dateadd: String
}
