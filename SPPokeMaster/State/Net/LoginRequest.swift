//
//  LoginRequest.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/14.
//

import Foundation
import SwiftUI
import Combine

struct LoginRequest {
    let email: String
    let password: String
    
    var publisher: AnyPublisher<User, AppError> {
        Future { promise in
            // 异步线程有问题，暂时注释了。
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                if self.password == "p" {
                    let user = User(email: self.email, favoritePokemonIDs: [])
                    promise(.success(user))
                } else {
                    promise(.failure(.passwordWrong))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
