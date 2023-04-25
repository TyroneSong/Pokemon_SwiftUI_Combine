//
//  RegisterRequest.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/17.
//

import Foundation
import Combine

struct RegisterRequest {
    
    var email: String
    
    var publisher: AnyPublisher<User, AppError> {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                let user = User(email: email, favoritePokemonIDs: [])
                if user.email.count > 3 {
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
