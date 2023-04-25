//
//  TriangleArrow.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/18.
//

import SwiftUI

struct TriangleArrow: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            path.addArc(
                center: CGPoint(x: -rect.width / 5, y: rect.height / 2),
                radius: rect.width / 2,
                startAngle: .degrees(-45),
                endAngle: .degrees(45),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
            path.closeSubpath()
        }
    }
}

struct FlowRectangle: View {
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.red)
                    .frame(height: 0.3 * proxy.size.height)
                
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 0.4 * proxy.size.width)
                    
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: 0.4 * proxy.size.height)
                        Rectangle()
                            .fill(Color.yellow)
                            .frame(height: 0.3 * proxy.size.height)
                    }
                    .frame(width: 0.6 * proxy.size.width)
                }
            }
        }
    }
}

struct FlowRectangle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FlowRectangle()
            
            Rectangle()
                .frame(width: 200, height: 500)

        }
    }
}
