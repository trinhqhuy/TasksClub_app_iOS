//
//  ChartView.swift
//  TasksClub
//
//  Created by Trinhqhuy on 13/06/2022.
//

import SwiftUI

struct ChartView: View {
    @EnvironmentObject var taskmodel : TasksViewModel
    let timer = Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()
    let dataTag = [
        
        TagChartModel(colorShape: "Gray", TagName: "Việc chưa hoàn thành"),
        TagChartModel(colorShape: "Blue1", TagName: "Việc đã hoàn thành"),
        TagChartModel(colorShape: "Green", TagName: "Việc quá hạn"),
    ]
    var body: some View {
           VStack(spacing: 25) {
              
              
               if self.taskmodel.StatsArray.count == 0 {
                   EmptyTaskView(ImageName: "person10", TextContent: "Hãy thêm công việc")
                       .frame(maxWidth: 280)
               } else {
                   PieChartWithLabelView(sizes: self.taskmodel.StatsArray,
                                         labelOffset: 70)
                       .frame(width: 280, height: 280)
                   ForEach(self.dataTag, id: \.self) {tag in
                       TagChartView(colorShape: tag.colorShape, TagName: tag.TagName)
                   }
               }
                 
               
               Spacer()
           }
          
           .onAppear {
               self.taskmodel.StatsChartView()
           }
           .onReceive(timer) { _ in
               self.taskmodel.StatsChartView()
           }
       }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
struct TagChartModel: Hashable {
    var colorShape: String
    var TagName: String
}
struct TagChartView: View {
    @State var colorShape: String = ""
    @State var TagName: String = ""
    var body: some View {
       
            HStack {
                Image(systemName: "chart.pie.fill")
                    .foregroundColor(Color.init(colorShape))
                Text(TagName)
            }
           
        
    }
}
struct PieChartWithLabelView: View {
    var sizes: [Int]
   
    var labelOffset : Double
    var labelSize: Double = 20.0

    let angleOffset = 90.0
    let colors = [
        Color.init("Gray"),
        Color.init("Green"),
        Color.init("Blue1")
    ]

    var body: some View {
        let convertedData = sizes.map { Double($0)/1}
        let total = convertedData.reduce(0, +)
        let sortedSizes = sizes.sorted(by: >)
        let angles = convertedData.sorted(by: >).map { $0 * 360.0 / total }
        var sum = 0.0
        let runningAngles = angles.map { (sum += $0, sum).1 }

        ZStack {
            ForEach(0..<runningAngles.count, id: \.self) { i in
                let startAngle = i==0 ? 0.0 : runningAngles[i-1]
                SectorView(
                    startAngle: Angle(degrees: startAngle - angleOffset),
                    endAngle: Angle(degrees: runningAngles[i] - angleOffset),
                    value: sortedSizes[i],
                    color: colors[i % colors.count],
                    labelOffset: labelOffset,
                    labelSize: labelSize)
            }
        }
    }
}
struct SectorView: View {
    var startAngle: Angle
    var endAngle: Angle
    var value: Int
    var color: Color
    var labelOffset: Double
    var labelSize: Double = 20.0

    var labelPoint: CGPoint {
        let midAngleRad = startAngle.radians + (endAngle.radians - startAngle.radians)/2.0
        return CGPoint(x: labelOffset * cos(midAngleRad),
                       y: labelOffset * sin(midAngleRad))
    }

    var body: some View {
        VStack {
            Sector(
                startAngle: startAngle,
                endAngle: endAngle
            )
            .fill(color)
            .overlay(
                Text("\(value)")
                    .font(.system(size: CGFloat(labelSize),
                                  weight:.bold,
                                  design: .rounded))
                    .padding(4)
                    .foregroundColor(.white)
                    .background(Color(.black).opacity(0.3))
                    .cornerRadius(5)
                    .offset(x: labelPoint.x, y: labelPoint.y)
            )
        }
    }
}
struct Sector: Shape {
    var startAngle: Angle
    var endAngle: Angle

    func path(in rect: CGRect) -> Path {
        // centre of the containing rect
        let c = CGPoint(x: rect.width/2.0, y: rect.height/2.0)
        // radius of a circle that will fit in the rect
        let r = Double(min(rect.width,rect.height)) * 0.9 / 2.0
        var path = Path()
        path.move(to: c)
        path.addArc(center: c,
                    radius: CGFloat(r),
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
        )
        path.closeSubpath()
        return path
    }
}
