//
//  AppAction.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/14.
//

import Foundation

/// Action
enum AppAction {
    
    // Settings
    case accountBehaviorButton(enabled: Bool)
    case accountBehaviorDone(result: Result<User, AppError>)
    
    case emailValid(valid: Bool)
    case register(email: String, password: String, verifyWord: String)
    case registerDone(Result<User,AppError>)
    case verifyPassword(verify: Bool)
    case login(email: String, password: String)
    case logout
    case clearCache
    
    case changeSort(type: AppState.Settings.Sorting)
    
    // PokemonList
    case toggleListSelection(index: Int?)
    case togglePanelPresenting(preseeting: Bool)
    
    case toggleFavorite(index: Int)
    
    case closeSafariView
    
    case loadPokemons(state: AppState.PokemonList.RefreshState)
    case loadPokemonsDone(result: Result<([PokemonViewModel], Bool), AppError>)
    
    // 技能开始加载
    case loadAbilities(pokemon: Pokemon)
    // 技能加载结束
    case loadAbilitiesDone(result: Result<(Pokemon, [AbilityViewModel]), AppError>)
    
    case showError(aError: AppError)
    
    
    case switchTab(index: AppState.MainTab.Index)
}
