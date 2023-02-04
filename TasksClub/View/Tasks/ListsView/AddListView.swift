//
//  AddListView.swift
//  TasksClub
//
//  Created by Trinhqhuy on 12/06/2022.
//

import SwiftUI

struct AddListView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    @State var Content: String = ""
    @FocusState var keyboardFocused: Bool
    @State var Icon: String = "folder"
    @State var ColorList: String = ""
    var IconItems = [
          "book",
          "bookmark",
          "sunset",
          "moon",
          "heart",
          "flag",
          "bell",
          "tag",
          "eye",
          "bag",
          "camera",
          "lock",
          "key",
          "pin",
          "clock",
          "alarm",
          "gift",
          "lightbulb",
          "cart",
          "cloud",
          "keyboard",
          "map",
        ]
    var ColorItems = [
          "red",
          "green",
          "blue",
          "teal",
          "yellow",
          "pink",
          "freshblue",
        ]
    @EnvironmentObject var listmodel : ListsViewModel
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    HStack{
                        Text("TÊN DANH SÁCH")
                            .foregroundColor(Color.gray)
                            .font(.caption)
                            Spacer()
                    }
                    //MARK: TEXTFIELD
                    TextField("", text: self.$Content)
                        .focused($keyboardFocused)
                           .onAppear {
                             
                                   keyboardFocused = true
                               
                           }
                        .foregroundColor(Color.black)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.init("WhiteBlue1"))
                        .cornerRadius(10)
                        
                    HStack{
                        Text("ICON DANH SÁCH")
                            .foregroundColor(Color.gray)
                            .font(.caption)
                            Spacer()
                    }
                    HStack{
                        Text("Chọn 1 icon")
                            .foregroundColor(Color.gray)
                            .font(.subheadline)
                        Button {
                            self.Icon = chooseRandomImage()
                        } label: {
                            Image(systemName: "shuffle.circle.fill")
                                .foregroundColor(Color.init("Blue1"))
                        }
                        Spacer()
                        Image(systemName: "\(Icon).fill")
                            .foregroundColor(Color.init("Red"))
                        Spacer()
                    }
                    .padding()
                    .background(Color.init("WhiteBlue1"))
                    .cornerRadius(10)
                    Button(action: {
                        self.ColorList = chooseRandomColor()
                        let listArray: ListModel = ListModel(id: "", id_user: "", name: Content, icon: self.Icon, color: self.ColorList)
                        self.listmodel.AddList(item: listArray)
                        showingAlert = true
                    }, label: {
                        HStack{
                            Text("Thêm")
                                .foregroundColor(Color.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(self.Content == "" ? Color.gray : Color.init("Blue1"))
                        .cornerRadius(10)
                        .shadow(color: self.Content == "" ? Color.gray : Color.init("Blue1").opacity(0.3), radius: 10, x: 0.0, y: 10)
                        .padding()
                    })
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Thông báo!"), message: Text(self.listmodel.ResponseMessage), dismissButton: .default(Text("Đóng"), action: {
                            self.Content = ""
                        }))
                    }
                        .disabled(self.Content == "")
                }
            }
            .padding()
            .navigationTitle("Thêm danh sách")
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
    func chooseRandomImage() -> String {
        let array = IconItems

        let result = array.randomElement()!

        return result
    }
    func chooseRandomColor() -> String {
        let array = ColorItems

        let result = array.randomElement()!

        return result
    }
}

struct AddListView_Previews: PreviewProvider {
    static var previews: some View {
        AddListView()
    }
}
