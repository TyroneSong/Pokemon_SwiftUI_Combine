//
//  CustomCircleView.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/19.
//

import SwiftUI

struct CustomCircleView: View {
    
    let colors: [Color] = [.red, .blue, .green, .yellow]
    
    var body: some View {
        GeometryReader { proxy in
            
            let w = 0.33 * proxy.size.width
            let h = 0.33 * proxy.size.height
            
            let radii = min(w, h)
            
            VStack {
                
                VStack(spacing: 0) {
                    Circle()
                        .fill(Color.red)
                        .frame(height: radii)
                    HStack(spacing: 0) {
                        Circle()
                            .fill(Color.blue)
                            .frame(height: radii)
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: w, height: h)
                        Circle()
                            .fill(Color.yellow)
                            .frame(height: radii)
                    }
                    Circle()
                        .fill(Color.green)
                        .frame(height: radii)
                }
                
                
                
                
                
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: w, height: h)
                    ForEach((0 ..< colors.count)) { index in
                        
                        if index  % 2 == 0 {
                            Circle()
                                .fill(colors[index])
                                .frame(width: w, height: h)
                                .alignmentGuide(VerticalAlignment.center) { d in
                                    switch index {
                                    case 0: return d[.bottom] + radii / 2
                                    case 2: return d[.top] - radii / 2
                                    default:
                                        return 0
                                    }
                                }
                        } else {
                            Circle()
                                .fill(colors[index])
                                .frame(width: w, height: h)
                                .alignmentGuide(HorizontalAlignment.center) { d in
                                    switch index {
                                    case 1: return d[.trailing] + radii / 2
                                    case 3: return d[.leading] - radii / 2
                                    default:
                                        return 0
                                    }
                                }
                        }
                        
                    }
                }
            }
            
            
            
        }
    }
}

struct CustomCircleView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCircleView()
            .frame(width: 300, height: 100)
    }
}
