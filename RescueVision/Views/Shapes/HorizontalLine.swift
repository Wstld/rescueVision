//
//  HorizontalLine.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-16.
//

import SwiftUI

struct HorizontalLine: View {
    private let height: CGFloat = 1.0
    var color:Color
    var body: some View {
        LineShape().fill(self.color).frame(minWidth: 0, maxWidth: .infinity, minHeight: height, maxHeight: height)
    }
}

struct HorizontalLine_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalLine(color: .black)
    }
}

struct LineShape: Shape {
    func path(in rect: CGRect) -> Path {
        let fill = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        var path = Path()
        path.addRoundedRect(in: fill, cornerSize: CGSize(width: 2, height: 2))
        
        return path
    }
}
