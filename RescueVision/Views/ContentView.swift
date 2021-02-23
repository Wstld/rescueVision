//
//  ContentView.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-13.
//

import SwiftUI
import CoreData


struct ContentView: View {
    
    //swipedirections
    @State private var isSideSwiping:Bool = false
    @State private var isSwiping:Bool = false
    
    //infomenu state
    @State var menuIsExposed:Bool = false
    
    //Core data implementation. (move to Viewmodel?)
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    var tools: FetchedResults<Tool>
    
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
                VideoFocusRect(size: focusRectSize, color: .red)
                    .padding(.bottom,0)
                    .onAppear(perform: {
                        withAnimation(.linear(duration:0.5)){
                            self.focusRectSize = focusRectFullSize
                        }
                        viewModel.firebaseModel.uploadJSONtoFireBase(objects: ModelJsonData().invetoryList)
                       
                    })
                    if viewModel.loadingObject{
                        VStack{
                        Text("loading object")
                            .foregroundColor(.white)
                        ActivitySpinner()
                            .frame(width: 80, height: 80, alignment: .center)
                        }.offset(y: UIScreen.main.bounds.height/3)
                    }
                
            }
            .offset(y:geo.size.height - geo.size.height - 100)
            
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
                                    viewModel.camera.toggleOutput()
                                    offsetValWidth = 0
                                    offsetValHeigth = lowestOffestValue
                                    menuIsExposed = false
                                }
                                //not enough will take it back to center of screen.
                                if value.translation.width >=  0 && value.translation.width < 130 || value.translation.width <=  0 && value.translation.width > -130 {
                                    offsetValWidth = 0
                                    menuIsExposed = true
                                }
                                //same control as above but for up&down
                                if value.translation.height > 0{
                                    if value.translation.height > 100 {
                                        self.offsetValHeigth = lowestOffestValue
                                        self.menuIsExposed = false
                                    }else {
                                        self.offsetValHeigth = 50
                                    }
                                }else{
                                    if value.translation.height < -100 {
                                        self.offsetValHeigth = 50
                                        self.menuIsExposed = true
                                    }else {
                                        self.offsetValHeigth = lowestOffestValue
                                    }
                                }
                                
                            })).animation(.spring()).background(Color.clear).onAppear(perform: {
                                print(lowestOffestValue)
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
