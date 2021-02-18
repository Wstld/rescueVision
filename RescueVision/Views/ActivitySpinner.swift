//
//  ActivitySpinner.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-02-16.
//

import SwiftUI

struct ActivitySpinner: View {
    @State var isAnimating:Bool = false
    var body: some View {
        ZStack{
            Color.gray.opacity(0.6)
            
            Circle()
                .trim(from: 0.2, to: 1)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .frame(width: 40, height: 40, alignment: .center)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 1)
                        .repeatForever(autoreverses: false)
                )
        }
        .frame(width: 80, height: 80)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.white.opacity(0.3), radius: 5, x: 0, y: 5)
        .shadow(color: Color.black.opacity(0.7), radius: 4, x: 0, y: 2)
        .onAppear(perform: {
            isAnimating = true
        })
    }
}

struct ActivitySpinner_Previews: PreviewProvider {
    static var previews: some View {
        ActivitySpinner()
    }
}
