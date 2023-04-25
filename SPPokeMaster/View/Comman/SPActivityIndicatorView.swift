//
//  SPActivityIndicatorView.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/19.
//

import SwiftUI

struct SPActivityIndicatorView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.backgroundColor = .red
        indicatorView.startAnimating()
        return indicatorView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct SPActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        SPActivityIndicatorView()
    }
}
