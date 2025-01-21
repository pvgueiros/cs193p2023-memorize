//
//  Pie.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 24/10/24.
//

import SwiftUI
import CoreGraphics

struct Pie: Shape {
    var startAngle: Angle = Angle.zero
    let endAngle: Angle
    var clockwise = true
    
    func path(in rect: CGRect) -> Path {
        let startAngle = startAngle - .degrees(90)
        let endAngle = endAngle - .degrees(90)
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let startPoint = CGPoint(
            x: center.x + radius * cos(startAngle.radians),
            y: center.x + radius * sin(startAngle.radians)
        )
        
        var path = Path()
        
        path.move(to: center)
        path.addLine(to: startPoint)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: !clockwise
        )
        path.addLine(to: center)
        
        return path
    }
}
