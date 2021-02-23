//
//  InfoListRow.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-16.
//

import SwiftUI

struct ItemListRow: View {
    var title:String
    var value:String?
    var body: some View {
            VStack{
            HStack{
                Text(title)
                    .font(.title2)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                if value != nil {
                Text(value!)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            }
            .padding(.top,10)
            .padding([.leading,.trailing],40)
                HorizontalLine(color: .white)
                    .padding([.leading,.trailing],10)
                    .padding(.top,-1)
            }.frame(minWidth: UIScreen.main.bounds.width, maxWidth: UIScreen.main.bounds.width)
    }
}


