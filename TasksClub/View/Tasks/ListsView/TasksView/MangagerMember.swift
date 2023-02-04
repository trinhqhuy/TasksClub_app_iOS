//
//  MangagerMember.swift
//  TasksClub
//
//  Created by Trinhqhuy on 25/06/2022.
//

import SwiftUI

struct MangagerMember: View {
    @Environment(\.presentationMode) var presentationMode
    @State var idlist: String = ""
    @EnvironmentObject var taskmodel : TasksViewModel
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text(self.taskmodel.ResponseMessage)
                        .foregroundColor(Color.init("Red"))
                    VStack {
                        ForEach(self.taskmodel.InfoManagerMemberArray) { user in
                            ManagerMemberItem(idlist: idlist, id: user.id, name: user.name, avatar: user.avatar)
                        }
                    }.onAppear {
                        self.taskmodel.FetchInfoList(id: idlist)
                    }
                }.padding()
            }.navigationTitle("Quản lý thành viên")
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

struct MangagerMember_Previews: PreviewProvider {
    static var previews: some View {
        MangagerMember()
    }
}
struct ManagerMemberItem: View {
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
            ForEach(self.taskmodel.OwnGroupArray, id: \.self) { own in
                if id == own.id_user {
                    
                } else {
                    Button {
                       
                        self.taskmodel.KickMember(iduser: id, idlist: idlist)
                    } label: {
                        Text("Xoá thành viên")
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 8)
                            .background(Color.init("Red"))
                            .cornerRadius(5)
                    }
                }
            }

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init("WhiteBlue1"))
        .cornerRadius(10)
    }
}
