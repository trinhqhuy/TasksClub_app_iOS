//
//  StartsStarTaskView.swift
//  TasksClub
//
//  Created by Trinhqhuy on 13/06/2022.
//

import SwiftUI

struct StartsStarTaskView: View {
    @EnvironmentObject var taskmodel : TasksViewModel
    let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
    @State private var InfoArray: StatsStarModel? = nil
    var body: some View {
        VStack {
            HStack{
                Text("Công việc đánh dấu đã hoàn thành")
                    .textCase(.uppercase)
                    .foregroundColor(Color.init("Blue1"))
                    .padding(.leading)
                    .font(.footnote)
                Spacer()
            }
               
                    if self.taskmodel.StatsStarTaskArray.count == 0 {
                        EmptyTaskView(ImageName: "person9", TextContent: "Hãy đánh dấu công việc")
                    } else {
                        ForEach(self.taskmodel.StatsStarTaskArray){ task in
                            VStack {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color.init("Red"))
                                    Text(task.content)
                                    Spacer()
                                    Button {
                                        self.InfoArray = task
                                    } label: {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(Color.init("Blue1"))
                                    }

                                }
                            }.padding()
                                .background(Color.init("White"))
                                .cornerRadius(5)
                                .padding(.horizontal)
                                .listRowSeparatorTint(.clear)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                
                        }
                        .sheet(item: self.$InfoArray) { task in
                           InfoTask(content: task.content, namelist: task.namelist, dateadd: task.dateadd, datefinish: task.datefinish, finish: task.finish, star: task.star)
                       }
                    }
          
            
            
        }
        .onAppear {
            self.taskmodel.StatsChartView()
        }
        .onReceive(timer) { _ in
            self.taskmodel.StatsChartView()
        }
    }
}

struct StartsStarTaskView_Previews: PreviewProvider {
    static var previews: some View {
        StartsStarTaskView()
    }
}
