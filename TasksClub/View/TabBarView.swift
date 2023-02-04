//
//  TabBarView.swift
//  TasksClub
//
//  Created by Trinhqhuy on 09/06/2022.
//

import SwiftUI
import SystemConfiguration

struct ViewTabBar: View {
    let connectivity = SCNetworkReachabilityCreateWithName(nil, "https://tasksclub.com") //MARK: KIỂM TRA KẾT NỐI MẠNG
    @State var lanchScreen: Bool = false
    @ObservedObject var internetConnection = InternetConnetion()
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack{
            if self.lanchScreen {
                VStack{
                   
                    Image("nointernet")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(contentMode: .fit)
                    Text("Không có kết nối internet")
                        .font(.title)
                        .cornerRadius(5)
                }
            }else{
                TabBarView()
            }
           
        }
        .onReceive(timer, perform: { _ in //MARK: CHẠY HÀM MỖI GIÂY ĐỂ KIỂM TRA KẾT NỐI MẠNG
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                var flgs = SCNetworkReachabilityFlags()
                SCNetworkReachabilityGetFlags(self.connectivity!, &flgs)
                
                if self.internetConnection.NetWorkReachable(to: flgs) {
                    self.lanchScreen = false
                }else{
                    lanchScreen = true
                }
            }
        })
    }
}
class InternetConnetion : ObservableObject {
    func NetWorkReachable(to flags: SCNetworkReachabilityFlags) -> Bool {
        let reachable = flags.contains(.reachable)
        let nConnection = flags.contains(.connectionRequired)
        let cConnectionAutomatically = flags.contains(.connectionOnDemand) ||
        flags.contains(.connectionOnTraffic)
        let cConnetionWithInternetion = cConnectionAutomatically &&
        !flags.contains(.interventionRequired)
        
        return reachable && (!nConnection || cConnetionWithInternetion)
    }
}
struct TabBarView: View {
    @StateObject var listsviewmodel = ListsViewModel()
    @StateObject var tasksviewmodel = TasksViewModel()
    
    @State var CurrentTab = "Trang Chủ"
    init(){
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
       
            TabView(selection: $CurrentTab){
                HomeView()
                    .tag("Trang Chủ")
                    .opacity(CurrentTab == "Trang Chủ" ? 1 : 0)
                ListsView()
                    .tag("Công Việc")
                    .opacity(CurrentTab == "Công Việc" ? 1 : 0)
                StatsView()
                    .tag("Thống Kê")
                    .opacity(CurrentTab == "Thống Kê" ? 1 : 0)
                Account()
                    .tag("Tài Khoản")
                    .opacity(CurrentTab == "Tài Khoản" ? 1 : 0)
            }
            .overlay(
                TabBar(CurrentTab: $CurrentTab), alignment: .bottom
            )
            .environmentObject(listsviewmodel)
            .environmentObject(tasksviewmodel)
            
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

struct TabBar: View {
    @Binding var CurrentTab: String
    var edges = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first?.safeAreaInsets
    @Namespace var animation
    var body: some View {
        HStack(spacing: 0){
            ForEach(tabs, id: \.self) {tab in
                TabBarItem(title: tab, CurrentTab: $CurrentTab, animation: animation)
                if tab != tabs.last{
                    Spacer(minLength: 0)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .padding()
        .frame(height: 60)
        .padding(.bottom,edges!.bottom == 0 ? 0 : 5)
        .background(.ultraThinMaterial)
        
    }
}
struct TabBarItem: View {
    var title: String
    @Binding var CurrentTab: String
    var animation : Namespace.ID
    var body: some View {
        Button(action: {
            withAnimation{CurrentTab = title}
        }){
            VStack(spacing: 0){
                
                //MARK: TOP INDICATOR
                
                //MARK: CUSTOM SHAPE
                
                //MARK: SLIDE IN AND OUT ANIMATION
                ZStack{
                    CustomShape()
                        .fill(Color.clear)
                        .frame(width: 45, height: 6)
                    
                    if CurrentTab == title{
                        CustomShape()
                            .fill(Color("Blue1"))
                            .frame(width: 45, height: 6)
                            .matchedGeometryEffect(id: "Tab_Chage", in: animation)
                    }
                }
                .padding(.bottom,15)
                Image(title)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(CurrentTab == title ? Color("Blue1") : Color.init("Blue2"))
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.init("Blue1").opacity(CurrentTab == title ? 1 : 0.4))
            }
        }

    }
}
struct CustomShape : Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        return Path(path.cgPath)
    }
}

//MARK: IMAGE TAB
var tabs = ["Trang Chủ","Công Việc","Thống Kê","Tài Khoản"]
