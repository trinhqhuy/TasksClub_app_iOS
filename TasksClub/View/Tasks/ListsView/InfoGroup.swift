//
//  infomation.swift
//  TasksClub
//
//  Created by Trinhqhuy on 23/06/2022.
//

import SwiftUI

struct InfoGroup: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var taskmodel : TasksViewModel
    @State var idlist = ""
    var body: some View {
        NavigationView{
            VStack{
                if #available(iOS 15.0, *) {
                List{
                    Section(header: Text("Thành viên nhóm")) {
                    
                        ForEach(self.taskmodel.InfoListArray, id: \.self) { info in
                            HStack{
                                    Image(systemName: "person.2.fill")
                                        .foregroundColor(Color.init("Blue"))
                                Text("\(info.number)")
                                Text("Thành viên")
                                }
                               
                        }
                    }
                    .headerProminence(.increased)
                    
                        Section(header: Text("Nhiệm vụ")) {
                           ForEach(self.taskmodel.InfoListHTArray, id: \.self) { info in
                               HStack{
                                   Image(systemName: "circle.fill")
                                       .foregroundColor(Color.init("Blue"))
                               Text("\(info.number)")
                               Text("đã hoàn thành")

                               }
                           }
                            ForEach(self.taskmodel.InfoListCHTArray, id: \.self) { info in
                                HStack{
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color.init("Blue"))
                                Text("\(info.number)")
                                Text("Chưa hoàn thành")

                                }
                            }
                            ForEach(self.taskmodel.InfoListStarArray, id: \.self) { info in
                                HStack{
                                    Image(systemName: "star.circle.fill")
                                        .foregroundColor(Color.init("Red"))
                                Text("\(info.number)")
                                Text("đánh dấu")

                                }
                            }
                        } .headerProminence(.increased)
                    
                }.listStyle(.insetGrouped)
                        .onAppear {
                            self.taskmodel.FetchInfoList(id: idlist)
                        }
                } else {
                    // Fallback on earlier versions
                }
            }
            .navigationTitle("Thông tin nhóm")
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

struct infomation_Previews: PreviewProvider {
    static var previews: some View {
        InfoGroup()
    }
}
struct InfoTask: View {
    @Environment(\.presentationMode) var presentationMode
    @State var content = String()
    @State var namelist = String()
    @State var dateadd = String()
    @State var datefinish = String()
    @State var finish = String()
    @State var star = String()
    
    var body: some View {
        NavigationView{
            VStack{
                if #available(iOS 15.0, *) {
                List{
                    Section(header: Text("Chi tiết")) {
                    HStack{
                            Image(systemName: "tag.square.fill")
                                .foregroundColor(Color.init("Blue1"))
                       
                        Text("Tên công việc:")
                            
                        Spacer()
                        Text("\(content)")
                            
                        }
                        HStack{
                                Image(systemName: "lineweight")
                                    .foregroundColor(Color.init("Red"))
                           
                            Text("Danh sách:")
                                
                            Spacer()
                            Text("\(namelist)")
                                
                            }
                    HStack{
                            Image(systemName: "calendar.badge.plus")
                                .foregroundColor(Color.init("Blue1"))
                        
                        Text("Ngày thêm:")
                            
                        Spacer()
                        Text("\(dateadd)")
                            
                    }
                        HStack{
                                Image(systemName: "calendar")
                                    .foregroundColor(Color.init("Green"))
                            
                            Text("Ngày thực hiện:")
                                
                            Spacer()
                            Text("\(datefinish)")
                                
                        }
                        
                    }
                    .headerProminence(.increased)
                    
                        Section(header: Text("Trạng thái")) {
                            HStack{
                                Image(systemName: finish == "0" ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                                    .foregroundColor(finish == "0" ? Color.init("Orange") : Color.init("Blue1"))
                                Text("Tình trạng")
                                Spacer()
                                Text(finish == "0" ? "Chưa hoàn thành" : "Đã hoàn thành")
                                
                            }
                            HStack{
                                Image(systemName: star == "0" ? "pin.slash.fill" : "pin.fill")
                                    .foregroundColor(star == "0" ? Color.init("Orange") : Color.init("Red"))
                                Text("Ghim")
                                Spacer()
                                Text(star == "0" ? "Chưa ghim" : "Đã ghim")
                                
                            }
                        } .headerProminence(.increased)
                    
                }.listStyle(.insetGrouped)
                } else {
                    // Fallback on earlier versions
                }
            }
            .navigationTitle("Thông tin")
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
