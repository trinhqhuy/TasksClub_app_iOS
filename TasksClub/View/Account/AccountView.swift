//
//  AccountView.swift
//  TasksClub
//
//  Created by Trinhqhuy on 09/06/2022.
//

import SwiftUI

struct AccountView: View {
    @StateObject var userviewmodel = UserViewModel()
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var height : CGFloat = 0
    
    var body: some View {
       
                VStack{
                    if self.status == true {
                        ViewTabBar()
                    }else{
                        NavigationView {
                            ZStack{
                                NavigationLink(destination: SignUpView(show: self.$show), isActive: self.$show) {
                                    Text("")
                                }
                                .hidden()
                                LoginView(show: self.$show)
                            }
                            .navigationTitle("")
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                            .background(Color.init("WhiteBlue").ignoresSafeArea(.all))
                        }
                       
                       
                    }
                }
                .onAppear {
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                        self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    }
                    
                
            }
        
        .environmentObject(userviewmodel)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}

struct Account: View {
    @State private var iconWidth: Double = 0
    @State private var showingAlert = false
    @State private var showingSheet = false
    @EnvironmentObject var usermodel : UserViewModel
    @State private var ModelUser: InfomationUser? = nil
    var body: some View {
        NavigationView{
                VStack{
                    List{
                        Section(header: Text("")) {
                            ForEach(self.usermodel.InfomationUserArray, id: \.self){ info in
                                HStack{
                                    Spacer()
                                    Image(info.avatar)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150, alignment: .center)
                                        .cornerRadius(20)
                                    Spacer()
                                }
                                HStack{
                                        Image(systemName: "tag.fill")
                                            .sync(with: $iconWidth)
                                            .frame(width: iconWidth)
                                            .foregroundColor(Color.init("Blue1"))
                                    Text("Tên người dùng:")
                                        
                                    Spacer()
                                    Text(info.name)
                                        .foregroundColor(Color.black)
                                    }
                                
                                HStack{
                                    Image(systemName: "envelope")
                                        .sync(with: $iconWidth)
                                        .frame(width: iconWidth)
                                        .foregroundColor(Color.init("Blue1"))
                                Text("Email")
                                    
                                Spacer()
                                    Text(info.email)
                                        .foregroundColor(Color.black)
                                }
                                Button {
                                    self.ModelUser = info
                                } label: {
                                    HStack{
                                        Text("Sửa thông tin")
                                        .foregroundColor(Color.init("Blue1"))
                                    }
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.init("Blue2"))
                                    .cornerRadius(10)
                                    .shadow(color: Color.init("Blue1").opacity(0.3), radius: 10, x: 0.0, y: 10)
                                    .padding(.vertical, 5)
                                }
                                .padding(.horizontal, 5)
                                .sheet(item: self.$ModelUser) { model in
                                    EditInfo(avatarapi: model.avatar, username: model.name)
                                }
                                Button {
                                    showingAlert.toggle()
                                } label: {
                                    HStack{
                                        Text("Đăng xuất")
                                        .foregroundColor(Color.white)
                                    }
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.init("Blue1"))
                                    .cornerRadius(10)
                                    .shadow(color: Color.init("Blue1").opacity(0.3), radius: 10, x: 0.0, y: 10)
                                    .padding(.vertical, 5)
                                }
                                .padding(.horizontal, 5)
                                .alert(isPresented: $showingAlert) {
                                    Alert(title: Text("Cảnh báo!"), message: Text("Bạn có chắc bạn muốn đăng xuất"),

                                          primaryButton: .default(Text("Huỷ"), action: {

                                             }),
                                          secondaryButton: .destructive(Text("Có"), action: {
                                                 UserDefaults.standard.removeObject(forKey: "token")
                                                 UserDefaults.standard.set(false, forKey: "status")
                                                 NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                                                      })
                                    )
                                }
                            }
                        }
                        
                    }
                    .listStyle(.insetGrouped)
                    .onPreferenceChange(SymbolWidthPreferenceKey.self) { iconWidth = $0 }
                    .onAppear {
                        self.usermodel.GetInfomationUser()
                    }
                    .refreshable {
                        self.usermodel.GetInfomationUser()
                    }
                }
                
                .navigationTitle("Tài khoản")
                .onAppear {
                    UINavigationBarAppearance()
                        .setColor(title: .white, background: .init(named: "Blue1"))
                }
//
              
                
            
        }
    }
}
struct EditInfo: View {
   
    @EnvironmentObject var usermodel : UserViewModel
    @State var avatarapi = String()
    @Environment(\.presentationMode) var presentationMode
    @State var User = UserDefaults.standard.string(forKey: "UserName") ?? ""
    @State private var emailString  : String = ""
    @State  var email : String = ""
    @State private var isEmailValid : Bool   = true
    @State var showAlert = false
    @State private var showingAlert = false
    @State var messageshow = ""
    @State var newpassword = ""
    @State var username = ""
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    VStack{
                        HStack{
                            Text("tên người dùng")
                                .textCase(.uppercase)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                                Spacer()
                        }
                        HStack{
                            Text("người dùng")
                                .textCase(.uppercase)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                                Spacer()
                            Text(username)
                                .foregroundColor(Color.init("Blue1"))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.init("WhiteBlue1"))
                        .cornerRadius(10)
                        //MARK: TEXTFIELD
                        HStack{
                            Text("email")
                                .textCase(.uppercase)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                                Spacer()
                            
                        }
                        TextField("Email dự phòng", text: self.$email)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.init("WhiteBlue1"))
                            .cornerRadius(10)
                        
                        HStack{
                            Text("avatar")
                                .textCase(.uppercase)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                                Spacer()
                        }
                        HStack{
                            Text("Chọn 1 avatar")
                                .foregroundColor(Color.gray)
                                .font(.subheadline)
                            Button {
                                self.avatarapi = chooseRandomAvatar()
                            } label: {
                                Image(systemName: "shuffle.circle.fill")
                                    .foregroundColor(Color.init("Blue1"))
                            }
                            Spacer()
                            Image(avatarapi)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 33, height: 33 )
                                .cornerRadius(50)
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.init("WhiteBlue1"))
                        .cornerRadius(10)
                        HStack{
                            Text("mật khẩu mới")
                                .textCase(.uppercase)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                                Spacer()
                        }
                        SecureField("Nhập mật khẩu mới tại đây...", text: self.$newpassword)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.init("WhiteBlue1"))
                                .cornerRadius(10)
                            Button(action: {
                                let newinfo: UpdateUser = UpdateUser(avatar: avatarapi, password: newpassword, email: email)
                                self.usermodel.UpdateInfo(user: newinfo)
                              
                                self.showingAlert = true
                            }, label: {
                                HStack{
                                    Text("Lưu")
                                    .foregroundColor(Color.white)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.init("Blue1"))
                                .cornerRadius(10)
                                .shadow(color: Color.init("Blue1").opacity(0.3), radius: 10, x: 0.0, y: 10)
                                .padding()
                            })
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("Thông báo!"), message: Text(self.usermodel.ResponseMessage), dismissButton: .default(Text("Đóng")))
                            }
                            
                            
                               
                        
                    }.padding()
                    Spacer()
            }
            .navigationTitle("Sửa thông tin")
            .onAppear {
                UINavigationBarAppearance()
                    .setColor(title: .white, background: .init(named: "Blue1"))
            }
            .toolbar {
                Button{
                  
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.white)
                        .font(.headline)
                }
            }
            }
        }
    }
    var IntAvatar = ["0","1", "2", "3", "4", "5", "6" ,"7", "8","9", "10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    func chooseRandomAvatar() -> String {
        let array = IntAvatar

        let result = array.randomElement()!

        return result
    }
   
}
