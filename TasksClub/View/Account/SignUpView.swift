//
//  SignUpView.swift
//  TasksClub
//
//  Created by Trinhqhuy on 15/06/2022.
//

import SwiftUI

struct SignUpView: View {
    @Binding var show : Bool
    @State var username = ""
    @State var password = ""
    @State var repassword = ""
    @State var visible = false
    @State var revisible = false
    @State var showAlert = false
    @State  var email : String = ""
    @EnvironmentObject var usermodel : UserViewModel
    var body: some View{
        ScrollView{
            ZStack(alignment: .topLeading){
                
                VStack {
                    VStack {
                        HStack(alignment: .top, spacing: 0){
                            Image("Walking1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, alignment: .center)
                                }
                        HStack{
                            Text("Chào mừng đến với Tasksclub.")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top, 30)
                            Spacer()
                        }
                    }
                    VStack {
                        HStack {
                            Text("Tên đăng nhập")
                                .font(.callout)
                                .fontWeight(.bold)
                                .padding(.top, 20)
                            Spacer()
                        }
                        TextField("", text: self.$username)
                            .padding()
                            .background(Color.init("Blue3"))
                            .cornerRadius(10)
                        HStack {
                            Text("Email")
                                .font(.callout)
                                .fontWeight(.bold)
                                .padding(.top, 20)
                            Spacer()
                        }
                        TextField("", text: self.$email)
                            .padding()
                            .background(Color.init("Blue3"))
                            .cornerRadius(10)
                        HStack {
                        Text("Mật khẩu")
                            .font(.callout)
                            .fontWeight(.bold)
                            .padding(.top, 20)
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
                        HStack {
                        Text("Nhập lại mật khẩu")
                            .font(.callout)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                            Spacer()
                        }
                        HStack(spacing: 15){
                            VStack{
                                if self.revisible{
                                    TextField("", text: self.$repassword)
                                }else{
                                    SecureField("", text: self.$repassword)
                                }
                            }
                            Button {
                                self.revisible.toggle()
                            } label: {
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(Color.init("Blue1"))
                            }
                        }
                        .padding()
                        .background(Color.init("Blue3"))
                        .cornerRadius(10)
                        
                    }
                    Button {
                        let user: UserSendSignUpModel = UserSendSignUpModel(username: self.username, email: self.email, password: self.password, repassword: self.repassword)
                        self.usermodel.SignUp(user: user)
                        self.showAlert = true
                    } label: {
                        Text("Đăng Ký")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .background(self.username == "" || self.password == "" || self.repassword == "" || self.email == "" ? Color.gray : Color.init("Blue1"))
                    .cornerRadius(10)
                    .padding(.top, 25)
                    .shadow(color: self.username == "" || self.password == "" || self.repassword == "" || self.email == "" ? Color.gray.opacity(0.5) : Color.init("Blue1").opacity(0.5), radius: 10, x: 0, y: 10)
                    .disabled(self.username == "" || self.password == "" || self.repassword == "" || self.email == "")
                    .alert(isPresented: $showAlert, content: {
                        Alert(title: Text("Thông báo !"), message: Text(self.usermodel.message), dismissButton: .default(Text("Đóng")))
                    })
                }
                .padding(.horizontal, 25)
                
                Button(action: {
                    self.show.toggle()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(Color.init("Blue1"))
                })
                .padding()
            }
            .padding(.bottom, 50)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
            
        }.background(Color.init("WhiteBlue").ignoresSafeArea(.all))
    }
}

