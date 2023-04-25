//
//  ListRootView.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/14.
//

import SwiftUI

struct PokemonRootView: View {
    
    @EnvironmentObject var store: Store
    
    var pokemonBinding: Binding<AppState.PokemonList> {
        $store.appState.pokemonList
    }
    
    
    @State var title = "Loading....."
    
    var body: some View {
        NavigationView {
                
                if store.appState.pokemonList.pokemons == nil {
                    Text(title)
                        .onAppear(perform: loadData)
                } else {
                    PokemonList()
                        .navigationBarTitle("宝可梦列表")
                }
            
        }
    }
    
    private func loadData() {
        self.store.dispatch(.loadPokemons(state: .refresh))
    }
    
    private func loadMoreData() {
        self.store.dispatch(.loadPokemons(state: .more))
    }
}

struct PokemonRootView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonRootView()
            .environmentObject(Store())
    }
}
