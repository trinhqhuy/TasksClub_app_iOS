//
//  Onboard.swift
//  TasksClub
//
//  Created by Trinhqhuy on 23/06/2022.
//


import SwiftUI

struct Onboard: View {
    @AppStorage("currentPage") var currentPage = 1
    var body: some View {
        if currentPage > totalPages{
            //MARK: HOME PAGE
            AccountView()
        }
        else{
            WalkthoughSreen()
        }
    }
}

struct IntroHome_Previews: PreviewProvider {
    static var previews: some View {
        Onboard()
    }
}


struct WalkthoughSreen: View {
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        ZStack{
            
            if currentPage == 1 {
                ScreenView(image: "Walking", detail: "", bgColor: Color("Blue2"))
                    .transition(.scale)
            }
            if currentPage == 2{
                ScreenView(image: "everyone1", detail: "", bgColor: Color("Blue2"))
                    .transition(.scale)
            }
            if currentPage == 3{
                ScreenView(image: "Walking1", detail: "", bgColor: Color("Blue2"))
                    .transition(.scale)
            }
            
        }
        .overlay(
            //MARK: BUTTON
            
            Button(action: {
                withAnimation(.easeInOut){
                    if currentPage < totalPages{
                        currentPage += 1
                    }else{
                        currentPage = 4
                    }
                }
            }, label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                    //MARK: VÒNG TRÒN QÚA TRÌNH
                    .overlay(
                        ZStack{
                            Circle()
                                .stroke(Color.black.opacity(0.04), lineWidth: 4)
                                .padding(-15)
                            Circle()
                                .trim(from: 0, to: CGFloat(currentPage) / CGFloat(totalPages))
                                .stroke(Color.white, lineWidth: 4)
                                .rotationEffect(.init(degrees: -90))
                        }
                        .padding(-15)
                        
                    )
            })
            .padding(.bottom,20)
            .frame(width: 50, height: 50)
            .padding()
            .offset(x: 0, y: -50)
            
            
            ,alignment: .bottom
            
        )
        
    }
    
}

struct ScreenView: View {
    var image: String
    
    var detail: String
    var bgColor: Color
    @AppStorage("currentPage") var currentPage = 1
    var body: some View {
        VStack(spacing: 20){
            HStack{
                //MARK: SHOW IT
                if currentPage == 1 {
                    Text("Chào Bạn")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.semibold)
                        .kerning(1.4)
                }else{
                    //MARK: BACK BUTTON
                    Button(action: {
                        withAnimation(.easeInOut){
                            currentPage -= 1
                        }
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            
                    })
                }
                
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut){
                        currentPage = 4
                    }
                }, label: {
                    Text("Bỏ qua")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .kerning(1.2)
                })
            }
            .foregroundColor(.black)
            .padding()
            
            VStack{
                
                HStack{
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .padding()
                .padding(.top, 100)
                HStack{
                    Text("Ứng dụng tasksclub giúp quản lý công việc của bạn dễ dàng và thuận tiện hơn.")
                        
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .kerning(1.3)
                        .multilineTextAlignment(.center)
                    //MARK: MINIMUM SPACING WHEN PHONE IS REDUCING
                    Spacer(minLength: 0)
                }.padding()
                
                Spacer()
            }
            
        }
        
        .background(bgColor.cornerRadius(10).ignoresSafeArea())
    }
}
//total page

var totalPages = 3

