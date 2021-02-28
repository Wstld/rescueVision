//
//  ContentView.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-13.
//

import SwiftUI
import CoreData


struct ContentView: View {
    @State var rotatePhoneIcon:Bool = false
    
    //swipedirections
    @State private var isSideSwiping:Bool = false
    @State private var isSwiping:Bool = false
    
    //infomenu state
    @State var menuIsExposed:Bool = false
    
    
    //Offset value for info menu
    @State private var offsetValHeigth:CGFloat = UIScreen.main.bounds.height - 140
    @State private var offsetValWidth:CGFloat = 0
    private let lowestOffestValue:CGFloat = UIScreen.main.bounds.height - 140
    
    //FocusRect sizing
    @State private var focusRectSize:CGFloat = 10
    private var focusRectFullSize = UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width - UIScreen.main.bounds.width * 0.2 : UIScreen.main.bounds.height - UIScreen.main.bounds.height * 0.2
    
    //Reference to viewmodel.
    @EnvironmentObject var viewModel:ObjectDetectionViewModel
    
    
    var body: some View {
        GeometryReader{ geo in
            
            CameraView().onAppear(perform: {
                viewModel.camera.setupVision()
            })
            
            ZStack{
                VideoFocusRect(size: focusRectSize, color: viewModel.showInfo ? .red : .green)
                    .onAppear(perform: {
                        withAnimation(.linear(duration:0.5)){
                            self.focusRectSize = focusRectFullSize
                        }
                        viewModel.firebaseModel.uploadJSONtoFireBase(objects: ModelJsonData().invetoryList)
                       
                    })
                //show loading
                VStack{
                    if viewModel.loadingObject{
                        
                        Text("loading object")
                            .foregroundColor(.white)
                        ActivitySpinner()
                            .frame(width: 80, height: 80, alignment: .center)
                        
                    }
                // show turn phone when not loading or not showing info
                    if !viewModel.loadingObject && !viewModel.showInfo{
                        Spacer(minLength: UIScreen.main.bounds.height/3 * 2)
                            Image(systemName: "iphone.homebutton")
                                .rotationEffect(.degrees(rotatePhoneIcon ? -90 : 0))
                                .padding(.top,15)
                                .font(Font.system(.title))
                                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true))
                                .onAppear(perform: {
                                    rotatePhoneIcon = true
                                })
                                .onDisappear(perform: {
                                    rotatePhoneIcon = false
                                })
                        Spacer()
                    }
                    
                }
                
            }
            
            
            //  Info menu appears on identified .
            
            if viewModel.showInfo {
                ZStack() {
                    SwipeInfoMenu(identifiedObject: viewModel.idObj,menuIsExposed: $menuIsExposed)
                        .ignoresSafeArea()
                        .cornerRadius(20)
                }
                .shadow(radius: 4 )
                .offset(x:offsetValWidth,y:offsetValHeigth)
                .gesture(DragGesture()
                            .onChanged({(value) in
                                //swipe sideways.
                                if !isSwiping {
                                if value.translation.width > 50 || value.translation.width < -50{
                                    self.isSideSwiping = true
                                    withAnimation(.linear(duration: 2)){
                                        offsetValWidth = value.translation.width
                                    }
                                }
                            }
                                //Swipe up&down
                                if !isSideSwiping {
                                if value.translation.height > 0 {
                                    //if menu is at at top.
                                    self.isSwiping = true
                                    self.offsetValHeigth = value.translation.height
                                }else{
                                    //change offset on drag. upward. If block prevents overdrag at top.
                                    //value.translation.height negative count upward.
                                    if (self.offsetValHeigth > 50){
                                        self.isSwiping = true
                                        let temp = UIScreen.main.bounds.height/1.5
                                        //start value temp(444) + value(-1)...(-269)
                                        self.offsetValHeigth = temp + value.translation.height
                                    }
                                }
                                }
                            })
                            .onEnded({(value) in
                                //reset swipevalues
                                self.isSwiping = false
                                self.isSideSwiping = false
                                //enought sidways will toggle objectrecognition and kill info menu
                                if value.translation.width > 130 || value.translation.width < -130 {
                                    menuIsExposed = false
                                    offsetValWidth = 0
                                    offsetValHeigth = lowestOffestValue

                                    viewModel.camera.toggleOutput()
                                                                       
                                }
                                //not enough will take it back to center of screen.
                                if value.translation.width >=  0 && value.translation.width < 130 || value.translation.width <=  0 && value.translation.width > -130 {
                                    offsetValWidth = 0
                                    menuIsExposed = true
                                }
                                //same control as above but for up&down
                                if value.translation.height > 0{
                                    if value.translation.height > 100 {
                                        offsetValHeigth = lowestOffestValue
                                        menuIsExposed = false
                                    }else {
                                        offsetValHeigth = 50
                                        menuIsExposed = true
                                    }
                                }else{
                                    if value.translation.height < -100 {
                                        offsetValHeigth = 50
                                        menuIsExposed = true
                                    }else {
                                        offsetValHeigth = lowestOffestValue
                                        menuIsExposed = false
                                        
                                    }
                                }
                                
                            }))
                .animation(.spring()).background(Color.clear)
                .onDisappear(perform: {
                    //reset info menu position for next apperance
                    offsetValHeigth = lowestOffestValue
                    offsetValWidth = 0
                })
          
                
            }
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
        }
        
    }
}
