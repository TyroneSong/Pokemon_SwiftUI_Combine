//
//  AppCommand.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/14.
//

import Foundation
import Combine

protocol AppCommand {
    func execute(in store: Store)
}

struct LoginAppCommand: AppCommand {
    let email: String
    let password: String
    
    func execute(in store: Store) {
        
        LoginRequest(
            email: email,
            password: password
        )
        .publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure = complete {
                        store.dispatch(.accountBehaviorDone(result: .failure(.passwordWrong)))
                    }
                }, receiveValue: { user in
                    store.dispatch(.accountBehaviorDone(result: .success(user)))
                }
            )
            .store(in: &store.disposeBag)
    }
}


struct WriteUserAppCommand: AppCommand {
    let user: User
    func execute(in store: Store) {
        try? FileHelper.writeJSON(user, to: .documentDirectory, fileName: "user.json")
    }
}

struct LoadPokemonCommand: AppCommand {
    
    let more: Bool
    
    func execute(in store: Store) {
        
        LoadPokemonRequest.publisherMore()
            .sink(receiveCompletion: { complete in
                if case .failure(let error) = complete {
                    store.dispatch(.loadPokemonsDone(result: .failure(error)))
                }
            }, receiveValue: { value in
                store.dispatch(.loadPokemonsDone(result: .success((value, more))))
            })
            .store(in: &store.disposeBag)
    }
}


struct LoadAbilityCommand: AppCommand {
    let pokemon: Pokemon
    func execute(in store: Store) {
        LoadAbilityRequest().publisher(pokemon)
            .sink { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.loadAbilitiesDone(result: .failure(error as! AppError)))
                }
            } receiveValue: { abilities in
                store.dispatch(.loadAbilitiesDone(result: .success((pokemon,abilities))))
            }
            .store(in: &store.disposeBag)

    }
}


struct RegisterAppCommand: AppCommand {
    
    var email: String
    var password: String
    var verifyword: String
    
    func execute(in store: Store) {
        
        // 1. 验证密码
        
        // 2. 进行注册
        RegisterRequest(email: email).publisher
            .sink { complete in
                
            } receiveValue: { user in
                
            }
            .store(in: &store.disposeBag)

    }
}

struct LogoutCommand: AppCommand {
    
    func execute(in store: Store) {
        try? FileHelper.delete(from: .documentDirectory, fileName: "user.json")
    }
}


struct ClearCacheCommand: AppCommand {
    
    func execute(in store: Store) {
        store.dispatch(.loadPokemons(state: .refresh))
    }
}

