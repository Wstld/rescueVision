//
//  SwipeInfoMenu.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-13.
//

import SwiftUI
import AVKit

struct SwipeInfoMenu: View {
    var screenWidth = UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
    
    var identifiedObject:InventoryItem
    @Binding var menuIsExposed:Bool
    //improvments = sepparate logic from InventoryItem for multipurpose.
    var body: some View {
            VStack(spacing:0){
       
                    Image(systemName: "chevron.up.circle")
                        .font(Font.system(.title))
                        .padding(2)
                        .rotationEffect(.degrees(menuIsExposed ? 180 : 0))
                        .animation(.easeInOut)
            
                
                Text(identifiedObject.name)
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.leading,40)
                    .frame(width: screenWidth, height: 70, alignment: .leading)
                    .background(Color.init(UIColor.gray))//add gradient?
                HorizontalLine(color: .white)
                
                //show inventory.
                ScrollView(){
                    if identifiedObject.contains != nil {
                    VStack(spacing:3){
                        Text("Innehåll")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top,15)
                            .padding(.bottom,10)
                            .padding(.leading,25)
                            .foregroundColor(.white)
                            .frame(width: screenWidth, alignment: .leading)
                        HorizontalLine(color: .white)
                        ScrollView{
                            VStack{
                                ForEach(identifiedObject.contains!,id:\.self){ section in
                                    if section.sectionName != nil {
                                    Text("\(section.sectionName!)")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .padding(.top,15)
                                        .padding(.bottom,10)
                                        .padding(.leading,25)
                                        .foregroundColor(.white)
                                        .frame(width: screenWidth, alignment: .leading)
                                    }
                                    ForEach(section.sectionItems, id:\.self){ item in
                                        ItemListRow(title: item.name , value: String(item.amount))
                                        
                                    }
                                   
                                }
                            }
                            .padding(.top,15)
                            
                        }
                        .frame(width: screenWidth, height: screenWidth/2)
                        .padding(.bottom,15)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.init(UIColor.darkGray), Color.init(UIColor.gray),Color.init(UIColor.darkGray)]), startPoint: .top, endPoint: .bottom).shadow(radius: 5))
                    }
                    }
                        
                      //show data.
                            VStack(spacing:3){
                                Text("Data")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.top,15)
                                    .padding(.bottom,10)
                                    .padding(.leading,25)
                                    .foregroundColor(.white)
                                    .frame(width: screenWidth, alignment: .leading)
                                HorizontalLine(color: .white)
                                ScrollView{
                                    VStack{
                                        ForEach(identifiedObject.properties,id:\.self){ prop in
                                            ItemListRow(title: prop.text, value:"\( String(prop.value) + prop.unit)")
                                        }
                                    }
                                    .padding(.top,15)
                                    
                                }
                                .frame(width: screenWidth, height: screenWidth/3)
                                .padding(.bottom,15)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.init(UIColor.darkGray), Color.init(UIColor.gray),Color.init(UIColor.darkGray)]), startPoint: .top, endPoint: .bottom).shadow(radius: 5))
                            }
            
                       //show video
                        VStack{
                            VideoView(videoURL: Bundle.main.url(forResource: "video.MOV", withExtension: nil)!)
                                .frame(width: screenWidth - 15, height: screenWidth - 15)
                                .cornerRadius(5)
                        }
                        
                        //show info
                        VStack{
                            Text("Information")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.top,15)
                                .padding(.bottom,10)
                                .padding(.leading,25)
                                .foregroundColor(.white)
                                .frame(width: screenWidth, alignment: .leading)
                            HorizontalLine(color: .white)
                            
                            if (identifiedObject.info?.warning) != nil {
                                Text("Varning:")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.top,15)
                                    .padding(.bottom,10)
                                    .padding(.leading,25)
                                    .foregroundColor(.white)
                                    .frame(width: screenWidth, alignment: .leading)
                               
                                ForEach((identifiedObject.info!
                                            .warning), id: \.self){ text in
                                    ItemListRow(title: text, value: nil)                                }
                            }
                            if (identifiedObject.info?.help) != nil {
                                Text("Tips:")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.top,15)
                                    .padding(.bottom,10)
                                    .padding(.leading,25)
                                    .foregroundColor(.white)
                                    .frame(width: screenWidth, alignment: .leading)
                               
                                ForEach((identifiedObject.info!.help), id: \.self){ text in
                                    ItemListRow(title: text, value: nil)                                }
                            }
                        }
                        .padding(.top,15)
                        .padding(.bottom,60)
                        .background(Color.init(UIColor.darkGray).shadow(radius: 3))
                    
                }
                
                
            }
            .background(Color.init(UIColor.darkGray))
            
            }
    
    }

struct SwipeInfoMenu_Previews: PreviewProvider {
    static var previews: some View {
        let data = ModelJsonData().invetoryList[10]
        Group {
//            SwipeInfoMenu(identifiedObject:data)
        }
    }
}


