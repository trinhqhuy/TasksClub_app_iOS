//
//  LoginView.swift
//  TasksClub
//
//  Created by Trinhqhuy on 15/06/2022.
//

import SwiftUI

struct LoginView: View {
    @Binding var show: Bool
    @State var username = ""
    @State var password = ""
    @State var visible = false
    @State var showAlert = false
    @EnvironmentObject var usermodel : UserViewModel
    var body: some View{
        ScrollView{
            ZStack(alignment: .topTrailing){
               
                    VStack{
                        HStack(alignment: .top, spacing: 0){
                            Image("Walking")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, alignment: .center)
                                }
                        HStack{
                            Text("Chào mừng đến với Tasksclub.")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top, 35)
                            Spacer()
                        }
                        HStack {
                            Text("Tên đăng nhập")
                                .font(.callout)
                                .fontWeight(.bold)
                                .padding(.top, 25)
                            Spacer()
                        }
                        TextField("", text: self.$username)
                            .padding()
                            .background(Color.init("Blue3"))
                            .cornerRadius(10)
                            .padding(.top, 5)
                        HStack {
                        Text("Mật khẩu")
                            .font(.callout)
                            .fontWeight(.bold)
                            .padding(.top, 25)
                            Spacer()
                        }
                        HStack(spacing: 15){
                            VStack{
                                if self.visible{
                                    TextField("", text: self.$password)
                                }else{
                                    SecureField("", text: self.$password)
                                }
                            }
                            Button {
                                self.visible.toggle()
                            } label: {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(Color.init("Blue1"))
                            }
                        }
                        .padding()
                        .background(Color.init("Blue3"))
                        .cornerRadius(10)
                        .padding(.top, 5)
                        
                        HStack{
                            Spacer()
                           
                            Link("Quên mật khẩu", destination: URL(string: "https://tasksclub.com/forgetpassword")!)
                                .font(.subheadline)
                                .foregroundColor(Color.init("Green"))
                        }
                        .padding(.top, 20)
                        Button {
                            let user: UserSendLoginModel = UserSendLoginModel(username: self.username, password: self.password)
                            self.usermodel.Login(user: user)
                            self.showAlert = true
                        } label: {
                            Text("Đăng Nhập")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(self.username == "" || self.password == "" ? Color.gray : Color.init("Blue1"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                        .shadow(color: self.username == "" || self.password == "" ? Color.gray.opacity(0.5) : Color.init("Blue1").opacity(0.5), radius: 10, x: 0, y: 10)
                        .disabled(self.username == "" || self.password == "")
                        .alert(isPresented: $showAlert, content: {
                            Alert(title: Text("Thông báo !"), message: Text(self.usermodel.message), dismissButton: .default(Text("Đóng")))
                        })
                    }
                    .padding(.horizontal, 25)
               
                Button(action: {
                    self.show.toggle()
                }, label: {
                    Text("Đăng Ký")
                        .fontWeight(.bold)
                        .foregroundColor(Color.init("Blue1"))
                })
                .padding()
            }//
            .padding(.bottom, 50)
        }
        
    }
}


