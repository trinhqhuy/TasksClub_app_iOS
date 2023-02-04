//
//  UserViewModel.swift
//  TasksClub
//
//  Created by Trinhqhuy on 15/06/2022.
//

import Foundation
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var message: String = ""
    @Published var InfomationUserArray = [InfomationUser]()
    @Published var ResponseMessage = ""
    init() { self.message = "" }
    let urlString = "https://tasksclub.com"
    var token = UserDefaults.standard.string(forKey: "token") ?? ""
    func Login(user: UserSendLoginModel) {
        self.message = ""
        var request = URLRequest(url: URL(string: urlString+"/loginapi")!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "username": user.username,
            "password": user.password,
        ]
        // covert diectionary to json
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        request.httpBody =  jsonData
        
        let session = URLSession.init(configuration: .default)
           session.dataTask(with: request){(data,res,err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            guard let _ = data else {return}
            if err == nil,let response = res as? HTTPURLResponse {
                
                    let decoder = JSONDecoder()
                    do{
                        
                        if response.statusCode == 200
                        {
                            let decodeData = try decoder.decode(UserResponseModel.self, from: data!)
                            DispatchQueue.main.async {
                                if decodeData.error == true {
                                    UserDefaults.standard.set(decodeData.token.lowercased(), forKey: "token")
                                    UserDefaults.standard.set(true, forKey: "status")
                                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                                }else {
                                    UserDefaults.standard.set(false, forKey: "status")
                                }
                                self.message = decodeData.message
                            }
                        }else {
                            let decodeData = try decoder.decode(ResponseArray.self, from: data!)
                            DispatchQueue.main.async {
                                    UserDefaults.standard.set(false, forKey: "status")
                                    self.message = decodeData.message
                            }
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                
            }
         
        }.resume()
    }
    func SignUp(user: UserSendSignUpModel) {
        self.message = ""
        var request = URLRequest(url: URL(string: urlString+"/signupapi")!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "username": user.username,
            "password": user.password,
            "email": user.email,
            "repassword": user.repassword
        ]
        // covert diectionary to json
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        request.httpBody =  jsonData
        
        let session = URLSession.init(configuration: .default)
           session.dataTask(with: request){(data,res,err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            guard let _ = data else {return}
            if err == nil,let response = res as? HTTPURLResponse {
                
                    let decoder = JSONDecoder()
                    do{
                        
                        if response.statusCode == 200
                        {
                            let decodeData = try decoder.decode(ResponseArray.self, from: data!)
                            DispatchQueue.main.async {
                               
                                self.message = decodeData.message
                            }
                        }else {
                            let decodeData = try decoder.decode(ResponseArray.self, from: data!)
                            DispatchQueue.main.async {
                                   
                                    self.message = decodeData.message
                            }
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                
            }
         
        }.resume()
    }
    func GetInfomationUser() {
        if let url = URL(string: urlString+"/infouser/"+token){
            let session = URLSession(configuration: .default)
            //let task =
            session.dataTask(with: url) {(data,respose,error) in
                if (error != nil)
                {
                    print(error!)
                }
                if let safeData = data {
                    self.parseJSONInfomationUser(Infomation: safeData)
                }
            }.resume() // start task
        }
    }
    
    func parseJSONInfomationUser(Infomation: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode([InfomationUser].self, from: Infomation)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.InfomationUserArray = decodeData
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    func UpdateInfo(user: UpdateUser) {
        self.ResponseMessage = ""
        var request = URLRequest(url: URL(string: urlString+"/updateinfo")!)
        request.httpMethod  = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: [String: Any] = [
            "tokensession": token,
            "avatar": user.avatar,
            "password": user.password,
            "email": user.email,
        ]
        // covert diectionary to json
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        request.httpBody =  jsonData
        
        let session = URLSession.init(configuration: .default)
           session.dataTask(with: request){(data,res,err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            guard let _ = data else {return}
            if err == nil,let response = res as? HTTPURLResponse {
                
                    let decoder = JSONDecoder()
                    do{
                        
                        if response.statusCode == 200
                        {
                            let decodeData = try decoder.decode(ResponseArray.self, from: data!)
                            DispatchQueue.main.async {
                               
                                self.ResponseMessage = decodeData.message
                            }
                        }else {
                            let decodeData = try decoder.decode(ResponseArray.self, from: data!)
                            DispatchQueue.main.async {
                                   
                                    self.ResponseMessage = decodeData.message
                            }
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                
            }
         
        }.resume()
    }
}
