//
//  VideoFocusRect.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-18.
//

import SwiftUI

struct VideoFocusRect: View {
    var size:CGFloat
    var animatableData:CGFloat{
        get{
            size
        }
        set{
            self.size = newValue
        }
    }
    var color:Color
    var body: some View {
        GeometryReader { geo in
            VStack{
            FocusRect()
                .stroke(color,style:StrokeStyle(lineWidth: 5.0, lineCap: .round))
                .frame(width: size, height: size)
               
                ZStack{
                    Text("focus on object")
                        .foregroundColor(.white)
                }.offset(y:geo.size.height - geo.size.height - 40)
            }.position(x: geo.size.width/2, y: geo.size.height/2)
            
        }
    }
}

struct FocusRect:Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY + rect.midY/2))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - rect.midX/2, y: rect.maxY))
        path.move(to: CGPoint(x: rect.midX + rect.midX/2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY + rect.midY/2))
        path.move(to: CGPoint(x: rect.maxX, y: rect.midY - rect.midY/2))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + rect.midX/2, y: rect.minY))
        path.move(to: CGPoint(x: rect.midX - rect.midX/2,y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY - rect.midY/2))
        

        return path
    }
}

struct VideoFocusRect_Previews: PreviewProvider {
    static var previews: some View {
        VideoFocusRect(size:200,color: .red)
    }
}
