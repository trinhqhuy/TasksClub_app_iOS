//
//  AddMember.swift
//  TasksClub
//
//  Created by Trinhqhuy on 12/06/2022.
//

import SwiftUI

struct AddMember: View {
    @Environment(\.presentationMode) var presentationMode
    @State var SearchTextField: String = ""
    @EnvironmentObject var taskmodel : TasksViewModel
    @FocusState var keyboardFocused: Bool
    @State var idlist: String = ""
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack{
                        Text("TÌM THÀNH VIÊN")
                            .foregroundColor(Color.gray)
                            .font(.caption)
                            Spacer()
                    }
                    TextField("", text: self.$SearchTextField)
                        .focused($keyboardFocused)
                           .task {
                               keyboardFocused = true
                           }
                        .foregroundColor(Color.black)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.init("WhiteBlue1"))
                        .cornerRadius(10)
                        .onChange(of: SearchTextField) { newValue in
                            self.taskmodel.SearchMember(name: SearchTextField)
                        }
                }
                if self.SearchTextField == "" {
                    
                } else {
                    if self.taskmodel.UserModelSearchArray.count == 0 {
                       
                            EmptySearchView(image: "error", text: "Không tìm thấy tài khoản")
                        
                    } else {
                        if taskmodel.isSeached == "" {
                            VStack {
                                ForEach(self.taskmodel.UserModelSearchArray) { user in
                                    UserItem(idlist: idlist, id: user.id, name: user.name, avatar: user.avatar)
                                }
                            }
                        } else if taskmodel.isSeached == "2" {
                            EmptySearchView(image: "done", text: self.taskmodel.ResponseMessage)
                        } else if taskmodel.isSeached == "3" {
                            EmptySearchView(image: "same", text: self.taskmodel.ResponseMessage)
                        }
                       
                    }
                }
            }.padding()
                .navigationTitle("Thêm thành viên")
                .navigationBarItems(
                    trailing:
                        HStack{
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color.white)
                                    .font(.headline)
                            }
                        }
                    )
                .background(Color.init("WhiteBlue"))
                .ignoresSafeArea(.keyboard)
        }
        
    }
}

struct AddMember_Previews: PreviewProvider {
    static var previews: some View {
        AddMember()
    }
}

struct UserItem: View {
    @State var idlist: String = ""
    @State var id: String = ""
    @State var name: String = ""
    @State var avatar: String = ""
    @EnvironmentObject var taskmodel : TasksViewModel
    var body: some View {
        HStack {
            Image(avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33 )
                .cornerRadius(50)
            Text(name)
                .foregroundColor(Color.black)
            Spacer()
            Button {
                self.taskmodel.AddMember(iduser: id, idlist: idlist)
            } label: {
                Text("Thêm")
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 8)
                    .background(Color.init("Blue1"))
                    .cornerRadius(5)
            }

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init("WhiteBlue1"))
        .cornerRadius(10)
    }
}
struct EmptySearchView: View {
    @State var image: String = ""
    @State var text: String = ""
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            Text(text)
                .foregroundColor(Color.black)
        }
    }
}
