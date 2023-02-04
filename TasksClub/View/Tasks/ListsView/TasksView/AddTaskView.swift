//
//  AddTasks.swift
//  TasksClub
//
//  Created by Trinhqhuy on 12/06/2022.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var Content: String = ""
    @State var NameList: String = ""
    @State var DateFinish = Date()
    @State private var showingAlert = false
    @State var idList: String = ""
    @EnvironmentObject var taskmodel : TasksViewModel
    @FocusState var keyboardFocused: Bool
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    HStack{
                        Text("TÊN CÔNG VIỆC")
                            .foregroundColor(Color.gray)
                            .font(.caption)
                            Spacer()
                    }
                    //MARK: TEXTFIELD
                    TextField("Thêm công việc tại đây...", text: self.$Content)
                        .focused($keyboardFocused)
                           .onAppear {
                               DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                   keyboardFocused = true
                               }
                           }
                        .foregroundColor(Color.black)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.init("WhiteBlue1"))
                        .cornerRadius(10)
                        
                    HStack{
                        Text("TÊN DANH SÁCH")
                            .foregroundColor(Color.gray)
                            .font(.caption)
                            Spacer()
                    }
                    HStack{
                        Text("Danh sách")
                            .foregroundColor(Color.gray)
                            .font(.subheadline)
                        Spacer()
                        Text("\(NameList)")
                            .foregroundColor(Color.init("Red"))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.init("WhiteBlue1"))
                    .cornerRadius(10)
                    HStack{
                        Text("NGÀY THỰC HIỆN")
                            .foregroundColor(Color.gray)
                            .font(.caption)
                            Spacer()
                    }
                    HStack{
                        Text("Thực hiện vào")
                            .foregroundColor(Color.gray)
                            .font(.subheadline)
                        DatePicker("", selection: self.$DateFinish, in: Date()..., displayedComponents: .date)
                    }
                    .padding()
                    .background(Color.init("WhiteBlue1"))
                    .cornerRadius(10)
                    Button(action: {
                        let task: TaskItem = TaskItem(id: "", id_list: idList, id_user: "", namelist: "", content: Content, finish: "", star: "", datefinish: "\(DateFinish)", dateadd: "")
                        self.taskmodel.AddTask(item: task)
                        self.showingAlert = true
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
                        Alert(title: Text("Thông báo!"), message: Text(self.taskmodel.ResponseMessage), dismissButton: .default(Text("Đóng"), action: {
                            self.Content = ""
                        }))
                    }
                        .disabled(self.Content == "")
                }
            }
            .padding()
            .navigationTitle("Thêm công việc")
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

struct AddTasks_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
