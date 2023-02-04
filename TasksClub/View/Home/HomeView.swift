//
//  HomeView.swift
//  TasksClub
//
//  Created by Trinhqhuy on 09/06/2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var taskmodel : TasksViewModel
    let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
    var body: some View {
        NavigationView{
            VStack{
                List {
                    Section {
                        if self.taskmodel.HomeTaskArray.count == 0 {
                            EmptyTaskView(ImageName: "person9", TextContent: "Hãy đánh dấu công việc")
                        } else {
                            ForEach(self.taskmodel.HomeTaskArray, id: \.self){ task in
                                TaskHomeItem(content: task.content, icon: task.icon, ColorList: task.color)
                            }
                        }
                } header: {
                    Text("NHIỆM VỤ ĐÃ ĐÁNH DẤU")
                        .foregroundColor(Color.init("Blue1"))
                } footer: {
                    Text("")
                        .padding(.bottom, 60)
                }
                } .listStyle(.insetGrouped)
                .onAppear {
                    self.taskmodel.HomeTaskView()
                }
                .onReceive(timer) { _ in
                    self.taskmodel.HomeTaskView()
                }
                
            }
            .navigationTitle("Tổng hợp")
            .onAppear {
                UINavigationBarAppearance()
                    .setColor(title: .white, background: .init(named: "Blue1"))
            }
//            .padding(.bottom, 60)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
struct TaskHomeItem: View {
    @State var content: String
    @State var icon: String
    @State var ColorList: String
    @State private var iconWidth: Double = 0
    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                    .sync(with: $iconWidth)
                    .frame(width: iconWidth)
                    .foregroundColor(Color.init("\(ColorList)List"))
                    .background(
                        Circle()
                            .fill(Color.init("\(ColorList)Background"))
                            .frame(width: 35, height: 35)
                    )
                    .shadow(color: Color.init("\(ColorList)List").opacity(0.3), radius: 5, x: 0.0, y: 5)
                    .padding(8)
                Text(content)
                    
                Spacer()
               

            }
            .padding(6)
            .onPreferenceChange(SymbolWidthPreferenceKey.self) { iconWidth = $0 }
        }
        .padding()
        .background(Color.init("White"))
        .overlay(
             Rectangle()
                 .fill(Color.init("Blue1"))
                 .mask(
                HStack {
                    Rectangle().frame(width: 7)
                    Spacer()
                })
          )
        .cornerRadius(5)
        .shadow(color: Color.init("Blue1").opacity(0.1), radius: 7.5, x: 0.0, y: 7.5)
        .padding(.vertical)
        .listRowSeparatorTint(.clear)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
