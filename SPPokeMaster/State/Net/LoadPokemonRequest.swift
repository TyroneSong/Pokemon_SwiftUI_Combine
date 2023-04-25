//
//  LoadPokemonRequest.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/17.
//

import Foundation
import Combine

struct LoadPokemonRequest {
    
    static let size = 20
    static var page = 0
    
    
    static func publisherMore(isMore: Bool = true) -> AnyPublisher<[PokemonViewModel], AppError> {
        if isMore {
            page += 1
        } else {
            page = 0
        }
        return ((page * size + 1) ... (page * size + size) ).map {
            LoadPokemonRequest(id: $0).publisher
        }
        .zipAll
    }
    
    
    static var all: AnyPublisher<[PokemonViewModel], AppError> {
        (1 ... 20).map {
            LoadPokemonRequest(id: $0).publisher
        }
        .zipAll
    }
    
    static var more: AnyPublisher<[PokemonViewModel], AppError> {
        page += 1
        return ((page * size + 1) ... (page * size + 20) ).map {
            LoadPokemonRequest(id: $0).publisher
        }
        .zipAll
    }
    
    let id: Int
    
    var publisher: AnyPublisher<PokemonViewModel, AppError> {
        pokemonPublisher(id)
            .flatMap { self.speciesPublisher($0) }
            .map { PokemonViewModel(pokemon: $0, species: $1) }
            .mapError { AppError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func pokemonPublisher(_ id: Int) -> AnyPublisher<Pokemon, Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!)
            .map { $0.data }
            .decode(type: Pokemon.self, decoder: appDecoder)
            .eraseToAnyPublisher()
            
    }
    
    func speciesPublisher(_ pokemon: Pokemon) -> AnyPublisher<(Pokemon, PokemonSpecies), Error> {
        URLSession.shared
            .dataTaskPublisher(for: pokemon.species.url)
            .map { $0.data }
            .decode(type: PokemonSpecies.self, decoder: appDecoder)
            .map { (pokemon, $0) }
            .eraseToAnyPublisher()
    }
    
    
}


extension Array where Element: Publisher {
    var zipAll: AnyPublisher<[Element.Output], Element.Failure> {
        let initial = Just([Element.Output]())
            .setFailureType(to: Element.Failure.self)
            .eraseToAnyPublisher()
        return reduce(initial) { result, publisher in
            result.zip(publisher) { $0 + [$1] }.eraseToAnyPublisher()
        }
    }
}
