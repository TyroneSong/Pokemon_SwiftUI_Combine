//
//  RadarView.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/18.
//

import SwiftUI

struct RadarView: View {
    
    let values: [Int]
    let max: Int
    let color: Color
    
    @State var progress: CGFloat = 0
    
    
    let scale = 0.9
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                ZStack(alignment: .center) {
                    Hexagon(values: values, max: max, progress: self.progress)
                        .fill(color)
                        .animation(.linear(duration: progress != 0 ? 1 : 0))
                    
                    
                    Hexagon(values: values.map { _ in max }, max: max, progress: self.progress)
                        .stroke(color, style: StrokeStyle(lineWidth: 1, dash: [6,3]))
                        .foregroundColor(color.opacity(0.5))
                        .animation(.linear(duration: progress != 0 ? 1 : 0))
                    
                }
                .frame(
                    width: min(proxy.size.width, proxy.size.height) * scale,
                    height: min(proxy.size.width, proxy.size.height) * scale
                )
            }
            .onAppear {
                showAnimation()
            }
        }
    }
    
    func showAnimation()  {
        self.progress = 1
    }
    
}


struct Hexagon: Shape {
    
    let values: [Int]
    let titles: [String]? = nil
    let max: Int
    var progress: CGFloat
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            guard values.count > 2 else { return }
            
            let points = self.points(in: rect)
            path.move(to: points.first!)
            
            for p in points.dropFirst() {
                path.addLine(to: p)
            }
            path.closeSubpath()
        }
        .trimmedPath(from: 0, to: progress)
    }
    
    /// 三角函数计算 将 values 转换为 rect 中的坐标点
    func points(in rect: CGRect) -> [CGPoint] {
        
        var result = [CGPoint]()
        // 中心点
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        // 当前角度
        var currentAngle = -CGFloat.pi / 2
        // 两个角之间的弧度
        let angleAdjustment = .pi * 2 / CGFloat(values.count)
        // 半径
        let radii = min(rect.size.width, rect.size.height)
        
        for value in values {
            let sinAngle = sin(currentAngle)
            let cosAngle = cos(currentAngle)
            
            let v = radii * (CGFloat(value) / CGFloat(max * 2))
            
            let point = CGPoint(x: center.x + v * cosAngle, y: center.y + v * sinAngle)
            result.append(point)
            
            currentAngle += angleAdjustment
        }
        
        return result
    }
    
    var animatableData: CGFloat {
        set { progress = newValue }
        get { progress }
    }
}

struct RadarView_Previews: PreviewProvider {
    static var previews: some View {
        RadarView(values: [6, 5, 7, 5, 1, 10], max: 10, color: Color.red)
    }
}


