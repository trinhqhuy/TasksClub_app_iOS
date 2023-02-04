//
//  ListsViewModel.swift
//  TasksClub
//
//  Created by Trinhqhuy on 09/06/2022.
//

import Foundation
import SwiftUI

class ListsViewModel: ObservableObject{
    @Published var ListsModelArray = [ListModel]()
    @Published var SearchListsModelArray = [ListModel]()
    @Published var NotificationModelArray = [NotificationModel]()
    let secondsToDelay = 3.0
    @Published var ResponseMessage = ""
    @Published var isAdded = ""
    let urlString = "https://tasksclub.com"
    var token = UserDefaults.standard.string(forKey: "token") ?? ""
    init() { self.isAdded = "" }
    func FetchLists() {
        guard let url: URL = URL(string: urlString+"/alllists/"+token)else{
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
                    self.parseJSON(ListsModelFetch: safeData)
                }
            }).resume() // start task
        }
    
    func parseJSON(ListsModelFetch: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode([ListModel].self, from: ListsModelFetch)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.ListsModelArray = decodeData
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    
    func AddList(item: ListModel) {
        var request = URLRequest(url: URL(string: urlString+"/addlist")!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "tokensession": token,
            "content": item.name,
            "icon": item.icon,
            "color": item.color,
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
    func EditList(item: ListModel) {
        var request = URLRequest(url: URL(string: urlString+"/updatelist")!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "tokensession": token,
            "content": item.name,
            "listid": item.id,
            "icon": item.icon,
            "color": item.color,
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
    func DeleteList(item: ListModel) {
        var request = URLRequest(url: URL(string: urlString+"/deletelist")!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "tokensession": token,
            "idlist": item.id,
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
    func GetNotification() {
        guard let url: URL = URL(string: urlString+"/notification/"+token)else{
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
                    self.parseJSONNotification(NotificationFetchModel: safeData)
                }
            }).resume() // start task
        }
    
    func parseJSONNotification(NotificationFetchModel: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode([NotificationModel].self, from: NotificationFetchModel)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.NotificationModelArray = decodeData
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    func allowGroup(idinvite: String) {
        var request = URLRequest(url: URL(string: urlString+"/actionlist")!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "tokensession": token,
                "idinvite": idinvite,
                "do": 1,
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
                                self.isAdded = ""
                            }
                        }
                       
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
         
        }.resume()
    }
    func allowJoin(idinvite: String) {
        var request = URLRequest(url: URL(string: urlString+"/actionlist")!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "tokensession": token,
                "idinvite": idinvite,
                "do": 3,
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
                                self.isAdded = ""
                            }
                        }
                       
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
         
        }.resume()
    }
    func denyGroup(idinvite: String) {
        var request = URLRequest(url: URL(string: urlString+"/actionlist")!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "tokensession": token,
                "idinvite": idinvite,
                "do": 2,
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
                                self.isAdded = ""
                            }
                        }
                       
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
         
        }.resume()
    }
    func SearchGroup(namelist: String) {
        guard let url: URL = URL(string: urlString+"/searchgroup/"+token+"/"+namelist.urlEncoded!)else{
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
                    self.parseJSONSearchGroup(SearchGroupFetchModel: safeData)
                }
            }).resume() // start task
        }
    
    func parseJSONSearchGroup(SearchGroupFetchModel: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode([ListModel].self, from: SearchGroupFetchModel)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.SearchListsModelArray = decodeData
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    func joinGroup(idown: String, idlist: String) {
        var request = URLRequest(url: URL(string: urlString+"/joingroup")!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "tokensession": token,
            "idown": idown,
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
                                self.isAdded = "2"
                            }else {
                                self.isAdded = "3"
                            }
                                self.ResponseMessage = decodeData.message
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.secondsToDelay) {
                                self.isAdded = ""
                            }
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
         
        }.resume()
    }
    func leavelist(idlist: String) {
        self.ResponseMessage = ""
        var request = URLRequest(url: URL(string: urlString+"/leavelist")!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "tokensession": token,
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
                           
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
         
        }.resume()
    }
}
