//
//  StatsView.swift
//  TasksClub
//
//  Created by Trinhqhuy on 09/06/2022.
//

import SwiftUI

struct StatsView: View {
    @State var selected = 0
    @EnvironmentObject var taskmodel : TasksViewModel
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    TabBarStatsView(selected: self.$selected)
                        .padding()
                    if self.selected == 0 {
                        HStack {
                            Text("THỐNG KÊ CÔNG VIỆC")
                                .foregroundColor(Color.init("Blue1"))
                                .font(.caption)
                                .padding()
                           
                        }
                       ChartView()
                       
                    } else if self.selected == 1 {
                        StartsStarTaskView()
                    } else if self.selected == 2 {
                        StartsTaskView()
                    }
                    Spacer()
                }
               
                .padding(.bottom, 100)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            .navigationTitle("Thống kê")
            .onAppear {
                UINavigationBarAppearance()
                    .setColor(title: .white, background: .init(named: "Blue1"))
            }
          
            .background(Color.init("Gray3"))
        }
    }
    
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
struct TabBarStatsView : View {
    @Binding var selected : Int
    var body: some View{
        HStack{
            Button(action: {
                self.selected = 0
            }) {
                Image(systemName: "chart.pie.fill")
                    .padding(.vertical, 8)
                    .padding(.horizontal,15)
                    .background(self.selected == 0 ? Color.white : Color.clear)
                    .clipShape(Rectangle())
                    .cornerRadius(7)
            }
            .foregroundColor(self.selected == 0 ? .init("Blue1") : .init("Blue5"))
            Button(action: {
                self.selected = 1
            }) {
                Image(systemName: "star.leadinghalf.filled")
                    .padding(.vertical, 8)
                    .padding(.horizontal,15)
                    .background(self.selected == 1 ? Color.white : Color.clear)
                    .clipShape(Rectangle())
                    .cornerRadius(7)
            }
            .foregroundColor(self.selected == 1 ? .init("Blue1") : .init("Blue5"))
            Button(action: {
                self.selected = 2
            }) {
                Image(systemName: "rectangle.stack.fill")
                    .padding(.vertical, 8)
                    .padding(.horizontal,15)
                    .background(self.selected == 2 ? Color.white : Color.clear)
                    .clipShape(Rectangle())
                    .cornerRadius(7)
            }
            .foregroundColor(self.selected == 2 ? .init("Blue1") : .init("Blue5"))
        }
        .padding(7)
        .background(Color.init("WhiteBlue1"))
        .clipShape(Rectangle())
        .cornerRadius(7)
    }
}
