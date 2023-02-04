//
//  ListsView.swift
//  TasksClub
//
//  Created by Trinhqhuy on 09/06/2022.
//

import SwiftUI

struct ListsView: View {
    enum ActiveSheet: Hashable {
      case first
      case second
      case third
    }
    @EnvironmentObject var listmodel : ListsViewModel
    @State private var _activeSheet: ActiveSheet?
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State var number = 1
    var body: some View {
        NavigationView {
            VStack {
                List{
                    Section {
                    if listmodel.ListsModelArray.count == 0 {
                        EmptyTaskView(ImageName: "Walking1", TextContent: "Hiện tại bạn chưa có nhóm hoặc danh sách")
                            
                    } else {
                    ListForView()
                    }
                } header: {
                    Text("Danh sách của bạn")
                        .foregroundColor(Color.init("Blue1"))
                } footer: {
                    Text("")
                        .padding(.bottom, 100)
                }  .onAppear {
                    self.listmodel.FetchLists()
                    self.listmodel.GetNotification()
                }
                .onReceive(timer) { _ in
                    self.listmodel.FetchLists()
                    self.listmodel.GetNotification()
                }
                }
                .listStyle(.insetGrouped)
                .refreshable {
                    self.listmodel.FetchLists()
                    self.listmodel.GetNotification()
                }
                
                
            }
          
            .navigationTitle("Công Việc")
            .onAppear {
                UINavigationBarAppearance()
                    .setColor(title: .white, background: .init(named: "Blue1"))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self._activeSheet = .third
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self._activeSheet = .second
                    } label: {
                        Image(systemName: "bell")
                            .foregroundColor(Color.white)
                            .clipShape(Circle())
                            .overlay {
                                if self.listmodel.NotificationModelArray.count != 0 {
                                    Text("\(self.listmodel.NotificationModelArray.count)").padding(7).background(Color.red).clipShape(Circle())
                                        .foregroundColor(Color.white).offset(x: 10, y: -10)
                                
                                }
                            }
                       
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self._activeSheet = .first
                    } label: {
                        Image(systemName: "folder.badge.plus")
                            .foregroundColor(Color.white)
                    }
                }
               
                
            }
            .sheet(tag: .first, selection: $_activeSheet) {
                AddListView()
            }
            .sheet(tag: .second, selection: $_activeSheet) {
                NotificationView()
            }
            .sheet(tag: .third, selection: $_activeSheet) {
                SearchGroupView()
            }
        }
        
    }
}

struct ListsView_Previews: PreviewProvider {
    static var previews: some View {
        ListsView()
    }
}
struct ListForView: View {
    @EnvironmentObject var listmodel : ListsViewModel
    @State private var ModelEdit: ListModel? = nil
    @State private var ModelDelete: ListModel? = nil
    let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
     @State private var showingAlert = false
    @State private var iconWidth: Double = 0
    var body: some View {
       
            
                ForEach(listmodel.ListsModelArray){ list in
                    NavigationLink(destination:
                            TasksView(id: list.id, namelist: list.name)
                                .navigationBarBackButtonHidden(true)
                                .navigationBarHidden(true)
                    ) {
                        HStack{
                            Image(systemName: list.icon)
                                .sync(with: $iconWidth)
                                .frame(width: iconWidth)
                                .foregroundColor(Color.init("\(list.color)List"))
                                .background(
                                    Circle()
                                        .fill(Color.init("\(list.color)Background"))
                                        .frame(width: 30, height: 30)
                                )
                                .shadow(color: Color.init("\(list.color)List").opacity(0.3), radius: 5, x: 0.0, y: 5)
                                .padding(4)
                            Text(list.name)
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            self.ModelEdit = list
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                        .tint(Color.init("Orange"))
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            showingAlert = true
                            self.ModelDelete = list
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(Color.init("Red"))
                    }
                }
                .sheet(item: self.$ModelEdit) { model in
                    EditListView(Content: model.name, id: model.id, Icon: model.icon)
                }
                .alert("Cảnh báo!",
                      isPresented: $showingAlert,

                       presenting: ModelDelete,

                        actions: { model in
                            Button("Có", role: .destructive, action: {
                                self.listmodel.DeleteList(item: model)
                            })
                    Button("Huỷ", role: .cancel, action: {})

                        }, message: { model in
                            Text("Bạn có chắc là bạn muốn xoá danh sách này")
                })
            .onPreferenceChange(SymbolWidthPreferenceKey.self) { iconWidth = $0 }
            
    }
}
struct NotificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var iconWidth: Double = 0
    @EnvironmentObject var listmodel : ListsViewModel
    var body: some View {
        NavigationView {
           
            ScrollView {
                HStack{
                    Text("THÔNG BÁO CỦA BẠN")
                        .foregroundColor(Color.init("Blue1"))
                        .font(.caption)
                        Spacer()
                }.padding()
                    if listmodel.NotificationModelArray.count == 0 {
                        EmptyTaskView(ImageName: "Walking1", TextContent: "Không có thông báo")
                            
                    } else {
                        ForEach(self.listmodel.NotificationModelArray) { noti in
                            NotificationItem(icon: noti.icon, namelist: noti.name, notification: noti.notification, id_member: noti.id_member, color: noti.color)
                        }
                    }
                }
               
                .listStyle(.insetGrouped)
                .onAppear(perform: {
                    self.listmodel.GetNotification()
                })
            .navigationTitle("Thông báo")
            .background(Color.init("WhiteBlue"))
            .ignoresSafeArea(.keyboard)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                Button {
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
struct NotificationItem: View {
    @State private var iconWidth: Double = 0
    @EnvironmentObject var listmodel : ListsViewModel
    @State var icon : String = ""
    @State var namelist: String = ""
    @State var notification: String = ""
    @State var id_member: String = ""
    @State var color: String = ""
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .sync(with: $iconWidth)
                .frame(width: iconWidth)
                .foregroundColor(Color.init("\(color)List"))
                .background(
                    Circle()
                        .fill(Color.init("\(color)Background"))
                        .frame(width: 30, height: 30)
                )
                .shadow(color: Color.init("\(color)List").opacity(0.3), radius: 5, x: 0.0, y: 5)
                .padding(4)
            Text("\(notification == "2" ? "Có người yêu cầu vào nhóm" : "Bạn có lời mời vào nhóm") \(namelist)")
                .foregroundColor(Color.black)
            Spacer()
            Menu {
                Button {
                    if notification == "2" {
                        self.listmodel.allowJoin(idinvite: id_member)
                    }else {
                        self.listmodel.allowGroup(idinvite: id_member)
                    }
                } label: {
                    Text(notification == "2" ? "Cho phép" : "Chấp nhận")
                       
                }
                Button {
                    self.listmodel.denyGroup(idinvite: id_member)
                } label: {
                    Text("Từ chối")
                       
                }
            } label: {
                Image(systemName: "ellipsis")
            }

        }.onPreferenceChange(SymbolWidthPreferenceKey.self) { iconWidth = $0 }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init("WhiteBlue1"))
        .cornerRadius(10)
        .padding()
    }
}
struct SearchGroupView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var SearchTextField: String = ""
    @EnvironmentObject var listmodel : ListsViewModel
    @FocusState var keyboardFocused: Bool
    @State var idlist: String = ""
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack{
                        Text("TÌM NHÓM")
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
                            self.listmodel.SearchGroup(namelist: SearchTextField)
                        }
                }
                if self.SearchTextField == "" {
                    
                } else {
                    if self.listmodel.SearchListsModelArray.count == 0 {
                       
                            EmptySearchView(image: "error", text: "Không tìm thấy nhóm")
                        
                    } else {
                        if listmodel.isAdded == "" {
                            VStack {
                                ForEach(self.listmodel.SearchListsModelArray) { list in
                                    SearchGroupItem(icon: list.icon, namelist: list.name, color: list.color, idlist: list.id, idown: list.id_user)
                                }
                            }
                        } else if listmodel.isAdded == "2" {
                            EmptySearchView(image: "done", text: self.listmodel.ResponseMessage)
                        } else if listmodel.isAdded == "3" {
                            EmptySearchView(image: "same", text: self.listmodel.ResponseMessage)
                        }
                       
                       
                    }
                }
            }.padding()
                .navigationTitle("Tìm Nhóm")
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
struct SearchGroupItem: View {
    @State private var iconWidth: Double = 0
    @EnvironmentObject var listmodel : ListsViewModel
    @State var icon : String = ""
    @State var namelist: String = ""
    @State var color: String = ""
    @State var idlist: String = ""
    @State var idown: String = ""
    var body: some View {
        HStack {
            Image(systemName: icon)
                .sync(with: $iconWidth)
                .frame(width: iconWidth)
                .foregroundColor(Color.init("\(color)List"))
                .background(
                    Circle()
                        .fill(Color.init("\(color)Background"))
                        .frame(width: 30, height: 30)
                )
                .shadow(color: Color.init("\(color)List").opacity(0.3), radius: 5, x: 0.0, y: 5)
                .padding(4)
            Text(namelist)
                .foregroundColor(Color.black)
            Spacer()
            Button {
                self.listmodel.joinGroup(idown: idown, idlist: idlist)
            } label: {
                Text("Vào nhóm")
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 8)
                    .background(Color.init("Blue1"))
                    .cornerRadius(5)
            }

        }.onPreferenceChange(SymbolWidthPreferenceKey.self) { iconWidth = $0 }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init("WhiteBlue1"))
        .cornerRadius(10)
        .padding()
    }
}
