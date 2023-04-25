//
//  AppState.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/14.
//

import Foundation
import Combine


struct AppState {
    
    var settings = Settings()
    
    var pokemonList = PokemonList()
    
    var mainTab = MainTab()
}

// MARK: - Settings
extension AppState {
    
    struct Settings {
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?
        
        var loginRequesting = false
        var loginError: AppError?
        
        var isEmailValid: Bool = false
        var passwordVerify: Bool = false
        
        var isValid: Bool = false
        
        var registerRequesting = false
        
        enum AccountBehavior: CaseIterable {
            case register, login
        }
        
        enum Sorting: CaseIterable {
            case id, name, color, favorite
        }
        
        @UserDefaultStorage(key: "showEnglishName")
        var showEnglishName
        
        var sorting = Sorting.id
        
        @UserDefaultStorage(key: "showFavoriteOnly")
        var showFavoriteOnly
        
        class AccountChecker {
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            
            var isEmailValid: AnyPublisher<Bool, Never> {
                let remoteVerify = $email
                    .debounce(
                        for: .milliseconds(500),
                        scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .flatMap { email -> AnyPublisher<Bool, Never> in
                        let validEmail = email.isValidEmailAddress
                        let canSkip = self.accountBehavior == .login
                        
                        switch (validEmail, canSkip) {
                        case (false, _ ):
                            return Just(false).eraseToAnyPublisher()
                        case (true, false):
                            return EmailCheckingRequest(email: email)
                                .publisher
                                .eraseToAnyPublisher()
                        case (true, true):
                            return Just(true).eraseToAnyPublisher()
                        }
                    }
                
                let emailLocalValid = $email.map { $0.isValidEmailAddress }
                
                let canSkipRemoteVerify = $accountBehavior.map { $0 == .login }
                
                return Publishers.CombineLatest3(
                    emailLocalValid, canSkipRemoteVerify, remoteVerify
                )
                .map { $0 && ($1 || $2) }
                .eraseToAnyPublisher()
            }

            
            @Published var password = ""
            @Published var verifyPasword = ""
                        
            var isVerifyPassword: AnyPublisher<Bool, Never> {
                let isVerify = (password.count > 0 && verifyPasword.count > 0 && (password == verifyPasword))
                return Just(isVerify)
                    .eraseToAnyPublisher()
            }
            
        }
        
        var checker = AccountChecker()
    }
}

// MARK: - PokemonList
extension AppState {
    
    struct PokemonList {
        
        enum RefreshState {
            case refresh, more, none
        }
        
        @FileStorage(directory: .cachesDirectory, fileName: "pokemons.json")
        var pokemons: [Int: PokemonViewModel]?
        
        var pokemonsLoadingError: AppError?
        var loadingPokemons = false
        var loadingPokemonsMore = false
        
        var allPokemonsByID: [PokemonViewModel] {
            guard let pokemons = pokemons?.values else {
                return []
            }
            return pokemons.sorted { $0.id < $1.id }
        }
        
        var allFavirity: [PokemonViewModel] {
            (pokemons?.filter({ dic in
                guard let user = AppState().settings.loginUser else {
                    return false
                }
                return user.favoritePokemonIDs.contains(dic.key)
            }).map({ dic in
                dic.value
            })) ?? []
        }
        
        
        /// 按 ID 缓存所有 AbilityViewModel
        var abilities:[Int: [AbilityViewModel]]?
        
        var loadingAbility = false
        
        /// 返回 `Pokemon` 的所有 AbilityViewModel
        func abilityViewModels(for pokemon: Pokemon) -> [AbilityViewModel]? {
            guard abilities != nil else {
                return nil
            }
            return abilities![pokemon.id]
        }
        
        
        class SelectionState {
            var panelPresented = false
            
            var selectedPanelIndex: Int?
            
            var expandingIndex: Int?
        }
        
        var selectionState = SelectionState()
        
        /// 按 ID 缓存所有 扩展
        var expandeds:[Int: Bool] = [Int: Bool]()
        
        
        var favoriteError: AppError?
        
        var isSFViewAction = false
        
    }
}

extension AppState {
    
    struct MainTab {
        enum Index: Hashable {
            case list, settings
        }
        
        var selection: Index = .list
        
        var aError: AppError?
    }
}
