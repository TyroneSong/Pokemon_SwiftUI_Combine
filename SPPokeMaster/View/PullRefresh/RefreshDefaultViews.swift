//
//  RefreshDefaultViews.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/20.
//

import SwiftUI

class ListState: ObservableObject {
    
    @Published private(set) var noMore: Bool
    
    init() {
        self.noMore = false
    }
    
    func setNoMore(_ newNoMore: Bool) {
        noMore = newNoMore
    }
}

struct RefreshDefaultHeader: View {
    
    @Environment(\.headerRefreshData) private var headerRefreshData
    
    var body: some View {
        let state = headerRefreshData.refreshState
        
        switch state {
        case .invalid:
            invalidView
        case .stopped:
            stoppedView
        case .triggered:
            triggeredView
        case .loading:
            loadingView
        }
    }
    
    var invalidView: some View {
        Spacer()
            .padding()
            .frame(height: 60)
    }
    
    var stoppedView: some View {
        
        VStack(spacing: 0) {
            Image("cat")
                .resizable()
                .frame(width: 40, height: 40)
                .rotationEffect(.init(degrees:  headerRefreshData.progress * 540))
            Spacer()
                .frame(height: 5)
            Text("下拉刷新")
                .font(.system(size: 18))
                .padding()
                .frame(height: 20)
        }
    }
    
    var triggeredView: some View {
        
        VStack(spacing: 0) {
            Image("cat")
                .resizable()
                .frame(width: 40, height: 40)
                .rotationEffect(.init(degrees:  headerRefreshData.progress * 540))
            Spacer()
                .frame(height: 5)
            Text("松手加载")
                .font(.system(size: 18))
                .padding()
                .frame(height: 20)
        }
    }
    
    var loadingView: some View {
        ProgressView("加载中....")
            .padding()
            .frame(height: 60)
    }
}

struct RefreshDefaultFooter: View {
    
    @Environment(\.footerRefreshData) private var footerRefreshData
    @EnvironmentObject private var listState: ListState
    
    var body: some View {
        let state = footerRefreshData.refreshState
        
        switch state {
        case .invalid:
            invalidView
        case .stopped:
            stoppedView
        case .triggered:
            triggeredView
        case .loading:
            loadingView
        }
    }
    
    var invalidView: some View {
        Spacer()
            .padding()
            .frame(height: 60)
    }
    
    var stoppedView: some View {
        
        VStack(spacing: 0) {
            Image(systemName: "arrow.counterclockwise")
                .resizable()
                .frame(width: 40, height: 40)
                .transformEffect(CGAffineTransform(translationX: CGFloat(footerRefreshData.progress - 0.5) * 200, y: CGFloat(10.0 * sin(footerRefreshData.progress * 31.416))))
            Spacer()
                .frame(height: 5)
            Text(listState.noMore ? "没有更多了" : "上拉加载更多")
                .font(.system(size: 18))
                .padding()
                .frame(height: 20)
        }
    }
    
    var triggeredView: some View {
        
        VStack(spacing: 0) {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .transformEffect(CGAffineTransform(translationX: CGFloat(footerRefreshData.progress - 0.5) * 200, y: CGFloat(10.0 * sin(footerRefreshData.progress * 31.416))))
            Spacer()
                .frame(height: 5)
            Text("松手加载")
                .font(.system(size: 18))
                .padding()
                .frame(height: 20)
        }
    }
    
    var loadingView: some View {
        ProgressView("加载中....")
            .padding()
            .frame(height: 60)
    }
}

struct SPProgressViewStyle: ProgressViewStyle {
    
    var strokeColor = Color.pink
    var strokeWidth = 10.0
    
    func makeBody(configuration: Configuration) -> some View {
        let degrees = configuration.fractionCompleted ?? 0
        
        return ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(degrees))
                .stroke(strokeColor, style: .init(lineWidth: CGFloat(strokeWidth), lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
    
    
}


struct CustomizeProgressViewStyle: ProgressViewStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        let degrees = configuration.fractionCompleted ?? 0
        let percent = Int(configuration.fractionCompleted ?? 100)
        
        return VStack {
            MyCircle(startAngle: .degrees(1), endAngle: .degrees(degrees))
                .frame(width: 200, height: 200)
                .padding(50)
            Text("Task \(percent)% Complete")
        }
    }
}

struct MyCircle: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        return path.strokedPath(.init(lineWidth: 100, dash: [5,3], dashPhase: 10))
    }
}
