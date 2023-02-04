//
//  TasksView.swift
//  TasksClub
//
//  Created by Trinhqhuy on 09/06/2022.
//

import SwiftUI
import UserNotifications
import Foundation

struct TasksView: View {
    enum ActiveSheet: Hashable {
      case first
      case second
      case third
      case four
      case five
    }
    @Environment(\.presentationMode) var presentationMode
    @State var id : String = ""
    @State var namelist : String = ""
    @EnvironmentObject var taskmodel : TasksViewModel
    @EnvironmentObject var listmodel : ListsViewModel
    @State var isLoading = true
    @State private var showingSheet = false
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State private var _activeSheet: ActiveSheet?
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.title3)
                            .foregroundColor(Color.white)
                    }
                    Spacer()
                    VStack{
                        AvatarStackView()
                           
                            Text("\(namelist)")
                                .font(.title3)
                                .foregroundColor(Color.white)
                                
                    } .overlay {
                        if self.isLoading == true {
                            VStack {
                                ProgressView()
                                    .scaleEffect(1, anchor: .center)
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color.init("WhiteBlue")))
                                   
                                    
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                                .background(Color.init("Blue1"))
                        }
                    }
                    
                    Spacer()
                    Menu {
                        Button {
                            self._activeSheet = .third
                        } label: {
                            Text("Thông tin nhóm")
                            Image(systemName: "info.circle")
                        }
                        Button {
                            self._activeSheet = .second
                        } label: {
                            Text("Thêm thành viên")
                            Image(systemName: "person.badge.plus")
                        }
                        Button {
                            self._activeSheet = .five
                        } label: {
                            Text("Quản lý thành viên")
                            Image(systemName: "gear")
                        }
                        Button {
                            self.listmodel.leavelist(idlist: id)
                            self.showingAlert = true
                        } label: {
                            Text("Rời nhóm")
                            Image(systemName: "arrowshape.turn.up.backward")
                        }

                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title3)
                            .foregroundColor(Color.white)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Thông báo!"), message: Text(self.listmodel.ResponseMessage), dismissButton: .default(Text("Đóng")))
                    }
                    .sheet(tag: .second, selection: $_activeSheet) {
                        AddMember(idlist: id)
                    }
                    .sheet(tag: .five, selection: $_activeSheet) {
                        MangagerMember(idlist: id)
                    }
                }
                .padding(.horizontal)
                Spacer()
                Form {
                    
                    TasksUnfinish(id: id)
                    TasksFinished(id: id)
                }
                .floatingActionButton(color: Color.init("Blue2"),image: Image(systemName: "plus").foregroundColor(.white), shadow: Color.init("Blue1")) {
                    self._activeSheet = .first
                    }
                .sheet(tag: .first, selection: $_activeSheet) {
                    AddTaskView(NameList: namelist, idList: id)
                }
                .sheet(tag: .third, selection: $_activeSheet) {
                    InfoGroup(idlist: id)
                }
                .listStyle(.insetGrouped)
                .overlay {
                    if self.isLoading == true {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.5, anchor: .center)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.init("Blue1")))
                               
                                
                        } .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.init("WhiteBlue"))
                           
                    }
                }
                .onAppear {
                    LoadingView()
                }
                .onReceive(timer) { _ in
                    self.taskmodel.FetchTasksView(id: id)
                }
            }
            .navigationBarHidden(true)
            .background(Color("Blue1").ignoresSafeArea())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
    }
    
    func LoadingView(){
        let secondsToDelay = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
            self.isLoading = false
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}

struct TasksUnfinish: View {
    let urlString = "https://tasksclub.com"
    var token = UserDefaults.standard.string(forKey: "token") ?? ""
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State var id: String = ""
    @EnvironmentObject var taskmodel : TasksViewModel
    @State var idLoad: String = ""
    @State var isNotification = false
    @State private var ShowNotificationSheet: Bool = false
    @State private var InfoArray: TaskItem? = nil
    @State private var showingSheet = 0
    @State var models = [TaskItem]()
    var body: some View {
        Section {
            List {
                CheckView
            }
        } header: {
            Text("Chưa Hoàn thành - \(taskmodel.TaskModelUnFinishArray.count)")
                .foregroundColor(Color.init("Blue1"))
        } footer: {
            
        }
        .onAppear(perform: {
            FetchTasksView()
        })
        .onReceive(timer) { _ in
            FetchTasksView()
        }
    
    }
    func FetchTasksView() {
        if let url = URL(string: urlString+"/all/"+token+"/"+id){
            let session = URLSession(configuration: .default)
            //let task =
            session.dataTask(with: url) {(data,respose,error) in
                if (error != nil)
                {
                    print(error!)
                }
                if let safeData = data {
                    self.parseJSONTasksUnFinish(TasksModelFetch: safeData)
                   
                }
            }.resume() // start task
        }
    }
    
    func parseJSONTasksUnFinish(TasksModelFetch: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode(TasksModel.self, from: TasksModelFetch)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.models = decodeData.first
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    @ViewBuilder var CheckView: some View {
        if self.taskmodel.TaskModelUnFinishArray.count == 0 {
            EmptyTaskView(ImageName: "everyone", TextContent: "Hãy thêm công việc")
        }else{
            ForEach(models){task in
                HStack {
                    SendValue(item: task, content: AnyView(Image(systemName: "circle")))
                    Text(task.content)
                    
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        idLoad = task.id
                        LoadingView()
                        if task.star == "1" {
                            ButtonSwipeAction(item: task, actionSwipe: 3)
                        } else {
                            ButtonSwipeAction(item: task, actionSwipe: 4)
                        }
                    } label: {
                        Image(systemName: task.star == "0" ? "star.fill" : "star.slash.fill")
                    }.tint(Color.init("Orange"))
                    
                    Button {
                        self.showingSheet = 1
                        self.InfoArray = task
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }.tint(Color.init("Yellow"))
                    Button {
                        self.InfoArray = task
                    } label: {
                        Image(systemName: "info.circle")
                            
                    }.tint(Color.init("Blue1"))

                }
                
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button {
                        idLoad = task.id
                        LoadingView()
                        ButtonSwipeAction(item: task, actionSwipe: 5)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(Color.init("Red"))
                    Button {
                       ShowNotificationSheet = true
                    } label: {
                        Image(systemName: "bell.circle.fill")
                    }
                    .tint(Color.init("tealList"))
                   
                } .sheet(item: self.$InfoArray) { task in
                    if self.showingSheet == 1 {
                        
                            EditTaskView(Content: task.content)
                        
                    }else {
                        InfoTask(content: task.content, namelist: task.namelist, dateadd: task.dateadd, datefinish: task.datefinish, finish: task.finish, star: task.star)
                    }
                }
                
                .sheet(isPresented: $ShowNotificationSheet) {
                    NotificationSheetView(idtask: task.id, content: task.content)
                }
            }
           
        }
    }
    @ViewBuilder
    func SendValue(item: TaskItem, content: AnyView) -> some View {
        VStack {
            content
                .foregroundColor(item.star == "1" ? Color.init("Red") : Color.init("Blue1"))
                .onTapGesture {
                    idLoad = item.id
                    LoadingView()
                    self.taskmodel.UpdateTask(item: item, make: "1")
                    
                }
        }
        .overlay {
            if idLoad == item.id {
                VStack{
                    ProgressView()
                        .scaleEffect(1, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: item.star == "1" ? Color.init("Red") : Color.init("Blue1")))
                }.background(Color.white)
                }
        }
        
    }
    func ButtonSwipeAction(item: TaskItem, actionSwipe: Int){
       
            if actionSwipe == 4 {
                self.taskmodel.UpdateTask(item: item, make: "4")
            } else if actionSwipe == 3 {
                self.taskmodel.UpdateTask(item: item, make: "3")
            } else {
                self.taskmodel.UpdateTask(item: item, make: "5")
            }
        
    }
    func LoadingView(){
        let secondsToDelay = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
            idLoad = ""
        }
    }
}
struct NotificationSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var idtask: String = ""
    @AppStorage("isPosition") var isPosition: Bool = false
    @State var selectedTime = Date.now
    @State var content: String = ""
    @State var isErrorTime = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if self.isPosition == false {
                    Button {
                        
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                self.isPosition = true
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "bell.circle.fill")
                            Text("Cấp quyền thông báo")
                        }
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .background(Color.init("Blue1"))
                    .cornerRadius(10)
                    .padding(.top, 25)
                    .shadow(color: Color.init("Blue1").opacity(0.5), radius: 10, x: 0, y: 10)
                        
                       
                    } else {
                        HStack {
                            DatePicker(
                                selection: self.$selectedTime,
                                in: Date()..., displayedComponents: .hourAndMinute,
                                label: {
                                    Text("Thời gian")
                                        .foregroundColor(Color.init("Blue1"))
                                })
                                .padding()
                                .background(Color.init("WhiteBlue1"))
                                .cornerRadius(10)
                                .onChange(of: self.selectedTime) { newValue in
                                    submit(timeNotification: self.selectedTime, Content: content)
                                }
                        }.padding()
                            .alert(isPresented: $isErrorTime) {
                                Alert(title: Text("Thông báo!"), message: Text("Thời gian bạn chọn ở quá khứ"), dismissButton: .default(Text("Đóng")))
                            }
                    }
                }
            }
            .navigationTitle("Thêm thông báo")
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
    func submit(timeNotification: Date, Content: String) {
        let timenow = Date.now
        let hournow = Calendar.current.component(.hour, from: timenow)
        let minutenow = Calendar.current.component(.minute, from: timenow)
        let hour = Calendar.current.component(.hour, from: timeNotification)
        let minute = Calendar.current.component(.minute, from: timeNotification)
       
        let hournow1 = ((hournow + 11) % 12 + 1)
        let hour1 = ((hour + 11) % 12 + 1)
        let counthour = (hour1 - hournow1)*3600
        let countminites = (minute - minutenow)*60
        let counttime = counthour + countminites
        if timeNotification < timenow {
            self.isErrorTime = true
        } else {
            
            let content = UNMutableNotificationContent()
            content.title = "Nhiệm vụ cần hoàn thành"
            content.subtitle = "\(Content)"
            content.sound = UNNotificationSound.default

            // show this notification five seconds from now
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(counttime), repeats: false)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            // add our notification request
            UNUserNotificationCenter.current().add(request)
           
        }
    }
    func getDate(d: String, t: String) -> Date? {
        let str = d + t
        let formatter = DateFormatter()
        formatter.dateFormat = "y-M-dHH:mm"
        let date = formatter.date(from: str)
        return date
    }
}

struct TasksFinished: View {
    let urlString = "https://tasksclub.com"
    var token = UserDefaults.standard.string(forKey: "token") ?? ""
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State var idLoad: String = ""
    @State var id: String = ""
    @EnvironmentObject var taskmodel : TasksViewModel
    @State private var InfoArray: TaskItem? = nil
    @State var models = [TaskItem]()
    var body: some View {
        Section {
            List {
            ForEach(models){task in
                
                HStack{
                    SendValue(item: task, content: AnyView(Image(systemName: "checkmark.circle.fill")))
                    Text(task.content)
                        .strikethrough()
                    
                }.swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        idLoad = task.id
                        LoadingView()
                        if task.star == "1" {
                            ButtonSwipeAction(item: task, actionSwipe: 3)
                        } else {
                            ButtonSwipeAction(item: task, actionSwipe: 4)
                        }
                    } label: {
                        Image(systemName: task.star == "0" ? "star.fill" : "star.slash.fill")
                    }.tint(Color.init("Orange"))
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }.tint(Color.init("Yellow"))
                    Button {
                        self.InfoArray = task
                    } label: {
                        Image(systemName: "info.circle.fill")
                            
                    }.tint(Color.init("Blue1"))

                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button {
                        idLoad = task.id
                        LoadingView()
                        ButtonSwipeAction(item: task, actionSwipe: 5)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(Color.init("Red"))
                }
            }
            }
            
        } header: {
            Text("Đã hoàn thành -  \(taskmodel.TaskModelFinishedArray.count)")
                .foregroundColor(Color.init("Blue1"))
        } footer: {
            Text("")
                .padding(.bottom, 100)
        }
        .sheet(item: self.$InfoArray) { task in
            InfoTask(content: task.content, namelist: task.namelist, dateadd: task.dateadd, datefinish: task.datefinish, finish: task.finish, star: task.star)
        }
        .onAppear(perform: {
            FetchTasksView()
        })
        .onReceive(timer) { _ in
            FetchTasksView()
        }
    }
    func FetchTasksView() {
        if let url = URL(string: urlString+"/all/"+token+"/"+id){
            let session = URLSession(configuration: .default)
            //let task =
            session.dataTask(with: url) {(data,respose,error) in
                if (error != nil)
                {
                    print(error!)
                }
                if let safeData = data {
                    self.parseJSONTasksFinished(TasksModelFetch: safeData)
                   
                }
            }.resume() // start task
        }
    }
    
    func parseJSONTasksFinished(TasksModelFetch: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData =  try decoder.decode(TasksModel.self, from: TasksModelFetch)
//            print(decodeData.data[0])
            
            DispatchQueue.main.async {
                self.models = decodeData.second
            }
            
        }
        catch{
            print("error parse JSON \(error)")
        }
    }
    @ViewBuilder
    func SendValue(item: TaskItem, content: AnyView) -> some View {
        VStack {
            content
                .foregroundColor(item.star == "1" ? Color.init("Red") : Color.init("Blue1"))
                .onTapGesture {
                    idLoad = item.id
                    LoadingView()
                    self.taskmodel.UpdateTask(item: item, make: "0")
                    
                }
        }
        .overlay {
            if idLoad == item.id {
                VStack{
                    ProgressView()
                        .scaleEffect(1, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: item.star == "1" ? Color.init("Red") : Color.init("Blue1")))
                }.background(Color.white)
                }
        }
        
    }
    func ButtonSwipeAction(item: TaskItem, actionSwipe: Int){
       
            if actionSwipe == 4 {
                self.taskmodel.UpdateTask(item: item, make: "4")
            } else if actionSwipe == 3 {
                self.taskmodel.UpdateTask(item: item, make: "3")
            } else {
                self.taskmodel.UpdateTask(item: item, make: "5")
            }
        
    }
    func LoadingView(){
        let secondsToDelay = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
            idLoad = ""
        }
    }
}
struct EmptyTaskView: View {
    @State var ImageName: String = ""
    @State var TextContent: String = ""
    var body: some View {
        VStack{
            Image(ImageName)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(contentMode: .fit)
            Text(TextContent)
                .font(.headline)
                .cornerRadius(5)
                .padding()
                Spacer()
        }
    }
}
struct FloatingActionButton<ImageView: View>: ViewModifier {
  let color: Color // background color of the FAB
  let image: ImageView // image shown in the FAB
  let action: () -> Void
  let shadow: Color
  private let size: CGFloat = 60 // size of the FAB circle
  private let margin: CGFloat = 75 // distance from screen edges

  func body(content: Content) -> some View {
    GeometryReader { geo in
      ZStack {
        Color.clear // allows the ZStack to fill the entire screen
        content
        button(geo)
      }
    }
  }

  @ViewBuilder private func button(_ geo: GeometryProxy) -> some View {
    image
      .imageScale(.large)
      .frame(width: size, height: size)
      .background(Circle().fill(color))
      .shadow(color: shadow.opacity(0.3), radius: 5, x: 0.0, y: 5)
      
      .onTapGesture(perform: action)
      .offset(x: (geo.size.width - size) / 2 - 20,
              y: (geo.size.height - size) / 2 - margin)
  }
}
struct EnumeratedForEach<ItemType, ContentView: View>: View {
    let data: [ItemType]
    let content: (Int, ItemType) -> ContentView
    
    init(_ data: [ItemType], @ViewBuilder content: @escaping (Int, ItemType) -> ContentView) {
        self.data = data
        self.content = content
    }
    
    var body: some View {
        ForEach(Array(self.data.enumerated()), id: \.offset) { idx, item in
            self.content(idx, item)
        }
    }
}
struct AvatarStackView: View {
    @EnvironmentObject var taskmodel : TasksViewModel
    var body: some View {
        ZStack {
            if taskmodel.AvatarStackArray.count == 1 {
                ForEach(taskmodel.AvatarStackArray, id: \.self) { item in
                    Image(item.avatar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 33, height: 33 )
                        .cornerRadius(50)
                }
            }else if taskmodel.AvatarStackArray.count == 2 {
                EnumeratedForEach(taskmodel.AvatarStackArray) { idx, item in
                    AvatarStackItems(idx: idx, item: item.avatar, action: 2)
                }
            } else if taskmodel.AvatarStackArray.count == 3 {
                EnumeratedForEach(taskmodel.AvatarStackArray) { idx, item in
                    AvatarStackItems(idx: idx, item: item.avatar, action: 3)
                }
            } else {
                EnumeratedForEach(taskmodel.AvatarStackArray) { idx, item in
                    AvatarStackItems(idx: idx, item: item.avatar, action: 4, number: taskmodel.AvatarStackArray.count)
                }
            }

        }
    }
}
struct AvatarStackItems: View {
    @State var idx : Int
    @State var value : CGFloat = 0
    @State var item = ""
    @State var action : Int
    @State var number : Int = 0
    var body: some View {
        ZStack{
            if action == 2 {
                ImageStack2(content: AnyView(
                 Image(item)
                     .resizable()
                     .scaledToFit()
                     .frame(width: 33, height: 33 )
                     .cornerRadius(50)
                 ))
            } else if action == 3 {
                ImageStack3(content: AnyView(
                 Image(item)
                     .resizable()
                     .scaledToFit()
                     .frame(width: 33, height: 33 )
                     .cornerRadius(50)
                 ))
            } else {
                ImageStack4(number: number)
            }
        }
    }
    @ViewBuilder
    func ImageStack3(content: AnyView) -> some View {
        if idx == 0 {
            content
                .offset(
                    x: 25
                )
        } else if idx == 2 {
            content
                .offset(
                    x: -25
                )
        }else {
           content
                
        }
    }
    @ViewBuilder
    func ImageStack2(content: AnyView) -> some View {
        if idx == 0 {
            content
                .offset(
                    x: 10
                )
        } else if idx == 1 {
            content
                .offset(
                    x: -10
                )
        }
    }
    @ViewBuilder
    func ImageStack4(number: Int) -> some View {
        if idx == 0 {
            Image(item)
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33 )
                .cornerRadius(50)
                .offset(
                    x: -30
                )
        } else if idx == 1 {
            Image(item)
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33 )
                .cornerRadius(50)
                .offset(
                    x: -10
                )
        } else if idx == 2 {
            Image(item)
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33 )
                .cornerRadius(50)
                .offset(
                    x: 10
                )
        } else if idx == 3{
            Text("\(number - 3)+")
                .foregroundColor(Color.white)
                .background(Circle().fill(Color.init("Blue4")).frame(width: 33, height: 33 ))
                .offset(
                    x: 30
                )
        }
    }
}

