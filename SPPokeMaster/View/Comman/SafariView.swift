//
//  SafariView.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/18.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    let onInitialized: () -> Void
    
    let onFinished: () -> Void
    
    
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = SFSafariViewController(url: url)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
//    func makeUIViewController(
//        context: UIViewControllerRepresentableContext<SafariView>
//    ) -> some SFSafariViewController {
//        let controller = SFSafariViewController(url: url)
//        return controller
//    }
    
//    func updateUIViewController(
//        _ uiViewController: SFSafariViewController,
//        context: UIViewControllerRepresentableContext<SafariView>
//    ) {
//
//    }
    
    
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        let parent: SafariView
        
        init(_ parent: SafariView) {
            self.parent = parent
            parent.onInitialized()
        }
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            parent.onFinished()
        }
    }
    
    
}

