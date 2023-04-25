//
//  PokemonList.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/13.
//

import SwiftUI

struct PokemonList: View {
    
    @EnvironmentObject var store: Store
    
    
    
    var expandeIdx: Int {
        
        guard let idx = store.appState.pokemonList.selectionState.expandingIndex else {
            return -1
        }
        return idx
    }
    
    var body: some View {
        ScrollView {
            ForEach(store.appState.pokemonList.allPokemonsByID) { pokemon in
                
                if let user = store.appState.settings.loginUser, store.appState.settings.showFavoriteOnly && !user.favoritePokemonIDs.contains(pokemon.id) {
                    EmptyView()
                } else {
                    PokemonInfoRow(model: pokemon, expanded:  expandeIdx == pokemon.pokemon.id)
                        .onTapGesture {
                            self.store.dispatch(
                                .toggleListSelection(index: pokemon.id)
                            )
                            
                            self.store.dispatch(
                                .loadAbilities(pokemon: pokemon.pokemon)
                            )
                        }
                }
            }
            
            Button("More") {
                store.dispatch(.loadPokemons(state: .more))
            }
            
        }
    }
    
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList()
            .environmentObject(Store())
    }
}
