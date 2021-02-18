//
//  ContentView.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-13.
//

import SwiftUI
import CoreData


struct ContentView: View {
    
    //Core data implementation. (move to Viewmodel?)
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    var tools: FetchedResults<Tool>
    
    //Offset value for info menu
    @State private var offsetValHeigth:CGFloat = UIScreen.main.bounds.height/1.5
    @State private var offsetValWidth:CGFloat = 0
    
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
                    SwipeInfoMenu(identifiedObject: viewModel.idObj) //should come from viewmodel.
                        .ignoresSafeArea()
                        .cornerRadius(20)
                }
                .shadow(radius: 4 )
                .offset(x:offsetValWidth,y:offsetValHeigth)
                .gesture(DragGesture()
                            .onChanged({(value) in
                                //swipe sideways.
                                if value.translation.width > 50 || value.translation.width < -50{
                                    withAnimation(.linear(duration: 2)){
                                        offsetValWidth = value.translation.width
                                    }
                                }
                                //Swipe up&down
                                if value.translation.height > 0 {
                                    self.offsetValHeigth = value.translation.height
                                }else{
                                    //change offset on drag. upward. If block for stop draging at top.
                                    //value.translation.height negative count upward.
                                    if (self.offsetValHeigth > 50){
                                        let temp = UIScreen.main.bounds.height/1.5
                                        //start value temp(284) + value(-1)...(-269)
                                        self.offsetValHeigth = temp + value.translation.height
                                    }
                                }
                                
                            })
                            .onEnded({(value) in
                                //enought sidways will toggle objectrecognition and kill info menu
                                if value.translation.width > 130 || value.translation.width < -130 {
                                    viewModel.camera.toggleOutput()
                                    offsetValWidth = 0
                                    offsetValHeigth = 50
                                }
                                //not enough will take it back to center of screen.
                                if value.translation.width >=  0 && value.translation.width < 130 || value.translation.width <=  0 && value.translation.width > -130 {
                                    offsetValWidth = 0
                                }
                                //same control as above but for up&down
                                if value.translation.height > 0{
                                    if value.translation.height > 100 {
                                        self.offsetValHeigth = UIScreen.main.bounds.height/1.5
                                    }else {
                                        self.offsetValHeigth = 50
                                    }
                                }else{
                                    if value.translation.height < -100 {
                                        self.offsetValHeigth = 50
                                    }else {
                                        self.offsetValHeigth = UIScreen.main.bounds.height/1.5
                                    }
                                }
                                
                            })).animation(.spring()).background(Color.clear)
          
                
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
