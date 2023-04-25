//
//  MainTab.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/14.
//

import SwiftUI

struct MainTab: View {
    
    
    @EnvironmentObject var store: Store
    
    var bindingPokemon: Binding<AppState.PokemonList> {
        $store.appState.pokemonList
    }
    
    var settingPokemon: AppState.PokemonList {
        store.appState.pokemonList
    }
    
    var body: some View {
        TabView(selection: $store.appState.mainTab.selection) {
            PokemonRootView().tabItem {
                Image(systemName: "list.bullet.below.rectangle")
                Text("列表")
            }
            .tag(AppState.MainTab.Index.list)
            
            SettingRootView().tabItem {
                Image(systemName: "gear")
                Text("设置")
            }
            .tag(AppState.MainTab.Index.settings)
        }
        .edgesIgnoringSafeArea(.top)
        .overlaySheet(
            isPresented: bindingPokemon.selectionState.panelPresented) {
                if settingPokemon.selectionState.selectedPanelIndex != nil && settingPokemon.pokemons != nil {
                    PokemonInfoPanel(model: store.appState.pokemonList.pokemons![store.appState.pokemonList.selectionState.selectedPanelIndex!]!)
                }
            }
            .alert(item: Binding.constant(store.appState.mainTab.aError)) { aError in
                Alert(title: Text(aError.localizedDescripition))
            }
    }
}

struct PokemonInfoPanelOverlay: View {
    let model: PokemonViewModel
    
    var body: some View {
        VStack {
            Spacer()
            PokemonInfoPanel(model: model)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
            .environmentObject(Store())
    }
}
