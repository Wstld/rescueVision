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
                    .foregroundColor(.textColor)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                if value != nil {
                Text(value!)
                    .font(.title2)
                    .foregroundColor(.textColor)
            }
            }
            .padding(.top,10)
            .padding([.leading,.trailing],40)
                HorizontalLine(color: .textColor)
                    .padding([.leading,.trailing],10)
                    .padding(.top,-1)
            }.frame(minWidth: UIScreen.main.bounds.width, maxWidth: UIScreen.main.bounds.width)
    }
}


