//
//  LoadAbilityRequest.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/17.
//

import Foundation
import Combine

struct LoadAbilityRequest {
    
    func publisher(_ pokemon: Pokemon) -> AnyPublisher<[AbilityViewModel], Error> {
        
        pokemon.abilities.map { abilityEntry in
            abilityPublisher(abilityEntry.ability.url)
        }
        .zipAll
    }
    
    func abilityPublisher(_ url: URL) -> AnyPublisher<AbilityViewModel, Error> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Ability.self, decoder: appDecoder)
            // Ability  -> AbilityViewModel
            .map { AbilityViewModel(ability: $0 )}
            .eraseToAnyPublisher()
            
    }
}
