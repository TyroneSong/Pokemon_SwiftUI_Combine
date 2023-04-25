//
//  Store.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/14.
//

import Foundation
import Combine

class Store: ObservableObject {
    
    @Published var appState = AppState()
    
    var disposeBag = [AnyCancellable]()
    
    init() {
        setupObservers()
    }
    
    func setupObservers() {
        appState.settings.checker.isEmailValid.sink { isValid in
            self.dispatch(.emailValid(valid: isValid))
        }.store(in: &disposeBag)
        
        appState.settings.checker.isVerifyPassword.sink { isVerify in
            self.dispatch(.verifyPassword(verify: isVerify))
        }.store(in: &disposeBag)
    }
    
    static func reduce(
        state: AppState,
        action: AppAction
    ) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?
        
        switch action {
        case .showError(let aError):
            appState.mainTab.aError = aError
            
        case .accountBehaviorButton(let isValid):
            appState.settings.isValid = isValid
            
        case .login(let email, let password):
            guard !appState.settings.loginRequesting else {
                break
            }
            
            appState.settings.loginRequesting = true
            
            appCommand = LoginAppCommand(email: email, password: password)
            
        case .accountBehaviorDone(let result):
            appState.settings.loginRequesting = false
            appState.settings.registerRequesting = false
            
            switch result {
            case .success(let user):
                appState.settings.loginUser = user
            case .failure(let error):
                appState.settings.loginError = error
            }
            
        case .emailValid(let valid):
            appState.settings.isEmailValid = valid
            
        case .verifyPassword(let verify):
            appState.settings.passwordVerify = verify
            
        case .register(let email, let password, let verity):
//            appState.settings.checker.isVerifyPassword
            appState.settings.registerRequesting = true
            appCommand = RegisterAppCommand(email: email, password: password, verifyword: verity)
            
        case.registerDone(let result):
            appState.settings.registerRequesting = false
            switch result {
            case .success(let user):
                appState.settings.loginUser = user
            case .failure(let error):
                appState.mainTab.aError = error
            }
            
        case .logout:
            appState.settings.loginUser = nil
            appCommand = LogoutCommand()
            
        case .changeSort(let sort):
            appState.settings.sorting = sort
            
        case .loadPokemons(let state):
            
            if appState.pokemonList.loadingPokemons ||
                appState.pokemonList.loadingPokemonsMore {
//                break
            }
            appState.pokemonList.pokemonsLoadingError = nil
            
            switch state {
            case .refresh:
                appState.pokemonList.loadingPokemons = true
                appCommand = LoadPokemonCommand(more: false)
            case .more:
                appState.pokemonList.loadingPokemonsMore = true
                appCommand = LoadPokemonCommand(more: true)
            case .none: break
            }
            
        case .loadPokemonsDone(let result):
            appState.pokemonList.loadingPokemons = false
            appState.pokemonList.loadingPokemonsMore = false
            switch result {
            case .success(let result):
                let models = result.0
                let isMore = result.1
                let pokemonVMs = Dictionary(uniqueKeysWithValues: models.map { ($0.id, $0) } )
                if isMore == true {
                    _ = models.map {
                        appState.pokemonList.pokemons![$0.id] = $0
                    }
                } else {
                    appState.pokemonList.pokemons = pokemonVMs
                }
            case .failure(let error):
                appState.pokemonList.pokemonsLoadingError = error
            }
            
        case .loadAbilities(let pokemon):
            appState.pokemonList.loadingAbility = true
            appCommand = LoadAbilityCommand(pokemon: pokemon)
            
        case .loadAbilitiesDone(let result):
            switch result {
            case .success(let res):
                var abilities = appState.pokemonList.abilities ?? [:]
                abilities[res.0.id] = res.1
                appState.pokemonList.abilities = abilities
            case .failure(let error):
                print(error)
            }
        case .toggleListSelection(let index):
            let expanding = appState.pokemonList.selectionState.expandingIndex
            if expanding == index {
                appState.pokemonList.selectionState.expandingIndex = nil
                appState.pokemonList.selectionState.panelPresented = false
            } else {
                appState.pokemonList.selectionState.expandingIndex = index
                appState.pokemonList.selectionState.selectedPanelIndex = index
            }
            
        case .togglePanelPresenting(let presenting):
            appState.pokemonList.selectionState.panelPresented = presenting
            
        case .toggleFavorite(let index):
            guard let loginUser = appState.settings.loginUser else {
                appState.pokemonList.favoriteError = .requirestLogin
                break
            }
            
            var newFavorites = loginUser.favoritePokemonIDs
            if newFavorites.contains(index) {
                newFavorites.remove(index)
            } else {
                newFavorites.insert(index)
            }
            appState.settings.loginUser?.favoritePokemonIDs = newFavorites
            
        case .closeSafariView:
            appState.pokemonList.isSFViewAction = false
            
        case .clearCache:
            appState.pokemonList.pokemons = nil
            appState.pokemonList.abilities = nil
            appCommand = ClearCacheCommand()
            
        case .switchTab(let index):
            appState.mainTab.selection = index
        }
        
        
        return (appState, appCommand)
    }
    
    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[ACTION]: \(action)")
        #endif
        
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        
        if let command = result.1 {
            #if DEBUG
            print("[COMMAND]: \(command)")
            #endif
            
            command.execute(in: self)
        }
    }
}
