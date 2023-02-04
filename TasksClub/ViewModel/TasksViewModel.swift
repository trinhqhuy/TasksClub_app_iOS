//
//  TasksViewModel.swift
//  TasksClub
//
//  Created by Trinhqhuy on 10/06/2022.
//

import Foundation
import SwiftUI

class TasksViewModel: ObservableObject {
    @Published var TaskModelUnFinishArray = [TaskItem]()
    @Published var TaskModelFinishedArray = [TaskItem]()
    @Published var AvatarStackArray = [AvatarStack]()
    @Published var UserModelSearchArray = [UserModelSearch]()
    @Published var HomeTaskArray = [HomeTask]()
    @Published var StatsStarTaskArray = [StatsStarModel]()
    @Published var StatsTaskArray = [StatsStarModel]()
    @Published var StatsArray : [Int] = []
    @Published var isLoading = true
    @Published var isEmpty: Bool = false
    @Published var ResponseMessage = ""
    @Published var OwnGroupArray = [OwnGroup]()
    @Published var InfoListArray = [NumberModel]()
    @Published var InfoListHTArray = [NumberModel]()
    @Published var InfoListCHTArray = [NumberModel]()
    @Published var InfoListStarArray = [NumberModel]()
    @Published var InfoManagerMemberArray = [InfoManagerMember]()
    let urlString = "https://tasksclub.com"
    var token = UserDefaults.standard.string(forKey: "token") ?? ""
//     var token = "83e6d03"
    @Published var isSeached : String!
    init() { self.isSeached = "" }
    let secondsToDelay = 2.0
    func FetchTasksView(id: String) {
        if let url = URL(string: urlString+"/all/"+token+"/"+id){
            let session = URLSession(configuration: .default)
            //let task =
            session.dataTask(with: url) {(data,respose,error) in
                if (error != nil)
                {
                    print(error!)
                }
                if let safeData = data {
                    self.parseJSONTasksUnFinish(TasksModelFetch: safeData)
                    self.parseJSONTasksFinished(TasksModelFetch: safeData)
                    self.parseJSONAvatarStack(TasksModelFetch: safeData)
                }
            }.resume() // start task
        }
    }
    
    func parseJSONTasksUnFinish(TasksModelFetch: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode(TasksModel.self, from: TasksModelFetch)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.TaskModelUnFinishArray = decodeData.first
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    func parseJSONTasksFinished(TasksModelFetch: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode(TasksModel.self, from: TasksModelFetch)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.TaskModelFinishedArray = decodeData.second
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    func parseJSONAvatarStack(TasksModelFetch: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode(TasksModel.self, from: TasksModelFetch)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.AvatarStackArray = decodeData.third
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    func FetchInfoList(id: String) {
        guard let url: URL = URL(string: urlString+"/infolist/"+token+"/"+id)else{
            print("invalid URL")
            return
        }
            var urlRequest: URLRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            // check if response is okay
                
                if (error != nil)
                {
                    print(error!)
                }
                if let safeData = data {
                    self.parseJSONOwnGroup(ListsModelFetch: safeData)
                    self.parseJSONInfoList(ListsModelFetch: safeData)
                    self.parseJSONInfoHTList(ListsModelFetch: safeData)
                    self.parseJSONInfoCHTList(ListsModelFetch: safeData)
                    self.parseJSONInfoStarList(ListsModelFetch: safeData)
                    self.parseJSONInfoManagerMemberArray(ListsModelFetch: safeData)
                }
            }).resume() // start task
        }
    func parseJSONOwnGroup(ListsModelFetch: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode(InfoGroupModel.self, from: ListsModelFetch)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.OwnGroupArray = decodeData.first
               
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    func parseJSONInfoList(ListsModelFetch: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode(InfoGroupModel.self, from: ListsModelFetch)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.InfoListArray = decodeData.second
               
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    func parseJSONInfoHTList(ListsModelFetch: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode(InfoGroupModel.self, from: ListsModelFetch)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.InfoListHTArray = decodeData.third
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    func parseJSONInfoCHTList(ListsModelFetch: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode(InfoGroupModel.self, from: ListsModelFetch)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.InfoListCHTArray = decodeData.four
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    func parseJSONInfoStarList(ListsModelFetch: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode(InfoGroupModel.self, from: ListsModelFetch)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.InfoListStarArray = decodeData.five
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    func parseJSONInfoManagerMemberArray(ListsModelFetch: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode(InfoGroupModel.self, from: ListsModelFetch)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.InfoManagerMemberArray = decodeData.six
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    func UpdateTask(item: TaskItem, make: String) {
        var request = URLRequest(url: URL(string: urlString+"/taskupdateios")!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "tokensession": token,
            "idlist": item.id_list,
            "id": item.id,
            "make": make,
        ]
        // covert diectionary to json
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        request.httpBody =  jsonData
        
        let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession.init(configuration: config)
           session.dataTask(with: request){(data,res,err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            guard let _ = data else {return}
            if err == nil,let response = res as? HTTPURLResponse {
                if response.statusCode == 200
                {
                    return
                }
            }
         
        }.resume()
    }
    func AddTask(item: TaskItem) {
        var request = URLRequest(url: URL(string: urlString+"/addtask")!)
        request.httpMethod  = "POST"
       
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "tokensession": token,
            "idlist": item.id_list,
            "content": item.content,
            "datefinish": item.datefinish
        ]
        // covert diectionary to json
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        request.httpBody =  jsonData
        
        let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession.init(configuration: config)
           session.dataTask(with: request){(data,res,err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            guard let _ = data else {return}
            if err == nil,let response = res as? HTTPURLResponse {
                if response.statusCode == 200
                {
                    let decoder = JSONDecoder()
                    do{
                        let decodeData = try decoder.decode(ResponseArray.self, from: data!)
                        DispatchQueue.main.async {
                                self.ResponseMessage = decodeData.message
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
         
        }.resume()
    }
    func SearchMember(name: String) {
        if let url = URL(string: urlString+"/searchuser/"+token+"/"+name){
            let session = URLSession(configuration: .default)
            //let task =
            session.dataTask(with: url) {(data,respose,error) in
                if (error != nil)
                {
                    print(error!)
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodeData =  try decoder.decode([UserModelSearch].self, from: safeData)
            //            print(decodeData.data[0])
                        
                        DispatchQueue.main.async {
                            self.UserModelSearchArray = decodeData
                        }
                        
                    }
                    catch{
                        print("error parse JSON \(error)")
                    }
                }
            }.resume() // start task
        }
    }
    func AddMember(iduser: String, idlist: String) {
        var request = URLRequest(url: URL(string: urlString+"/adduser")!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "tokensession": token,
            "iduser": iduser,
            "idlist": idlist,
        ]
        // covert diectionary to json
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        request.httpBody =  jsonData
        
        let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession.init(configuration: config)
           session.dataTask(with: request){(data,res,err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            guard let _ = data else {return}
            if err == nil,let response = res as? HTTPURLResponse {
                if response.statusCode == 200
                {
                    let decoder = JSONDecoder()
                    do{
                        let decodeData = try decoder.decode(ResponseArray.self, from: data!)
                        DispatchQueue.main.async {
                            if decodeData.error == true {
                                self.isSeached = "2"
                            }else {
                                self.isSeached = "3"
                            }
                                self.ResponseMessage = decodeData.message
                           
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.secondsToDelay) {
                                self.isSeached = ""
                            }
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
         
        }.resume()
    }
    func HomeTaskView() {
        if let url = URL(string: urlString+"/hometasks/"+token){
            let session = URLSession(configuration: .default)
            //let task =
            session.dataTask(with: url) {(data,respose,error) in
                if (error != nil)
                {
                    print(error!)
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodeData =  try decoder.decode(HomeTaskModel.self, from: safeData)
            //            print(decodeData.data[0])
                        
                        DispatchQueue.main.async {
                            self.HomeTaskArray = decodeData.first
                        }
                        
                    }
                    catch{
                        print("error parse JSON \(error)")
                    }
                }
            }.resume() // start task
        }
    }
    func StatsChartView() {
        if let url = URL(string: urlString+"/stats/"+token){
            let session = URLSession(configuration: .default)
            //let task =
            session.dataTask(with: url) {(data,respose,error) in
                if (error != nil)
                {
                    print(error!)
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodeData =  try decoder.decode(StatsModel.self, from: safeData)
                        
                        DispatchQueue.main.async {
                            self.StatsStarTaskArray = decodeData.four
                            self.StatsTaskArray = decodeData.five
                            if decodeData.six.count + decodeData.seven.count + decodeData.eight.count == 0 {
                                self.StatsArray = []
                            } else {
                                self.StatsArray = [decodeData.six.count, decodeData.seven.count , decodeData.eight.count]
                            }
                        }
                        
                    }
                    catch{
                        print("error parse JSON \(error)")
                    }
                }
            }.resume() // start task
        }
    }
    func KickMember(iduser: String, idlist: String) {
        var request = URLRequest(url: URL(string: urlString+"/kickuser")!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "tokensession": token,
            "iduser": iduser,
            "idlist": idlist,
        ]
        // covert diectionary to json
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        request.httpBody =  jsonData
        
        let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession.init(configuration: config)
           session.dataTask(with: request){(data,res,err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            guard let _ = data else {return}
            if err == nil,let response = res as? HTTPURLResponse {
                if response.statusCode == 200
                {
                    let decoder = JSONDecoder()
                    do{
                        let decodeData = try decoder.decode(ResponseArray.self, from: data!)
                        DispatchQueue.main.async {
                            
                                self.ResponseMessage = decodeData.message
                           
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.secondsToDelay) {
                                self.ResponseMessage = ""
                            }
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
         
        }.resume()
    }
}
