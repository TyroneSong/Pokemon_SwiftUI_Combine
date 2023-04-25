//
//  PokemonInfoPanel.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/13.
//

import SwiftUI
import Kingfisher

/// 宝可梦 信息面板
struct PokemonInfoPanel: View {
    
    @EnvironmentObject var store: Store
    
    let model: PokemonViewModel
    
    let imageSize: CGFloat = 68
    
    var body: some View {
        
        ZStack(alignment: .top) {
           
            VStack(spacing: 20) {
                topIndicator
                Group {
                    Header(model: model)
                    pokemonDescription
                }.animation(nil)
                Divider()
                HStack(spacing: 20) {
                    AbilityList(model: model, abilityModels: store.appState.pokemonList.abilityViewModels(for: model.pokemon))
                    RadarView(
                        values: model.pokemon.stats.map { $0.baseStat },
                        max: 120,
                        color: model.color
                    )
                    .frame(width: 100, height: 100)
                }
            }
            .padding(
                EdgeInsets(top: 12, leading: 30, bottom: 30, trailing: 30)
            )
            .blurBackground(style: .systemMaterial)
            .cornerRadius(20)
            .fixedSize(horizontal: false, vertical: true)
            
            KFImage(model.iconImageURL)
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .alignmentGuide(VerticalAlignment.top) { d in
                    d[.bottom] - imageSize / 2
                }
                .alignmentGuide(HorizontalAlignment.center) { d in
                    d[.trailing] * 2
                }
        }
        .onAppear {
            
        }
    }
    
    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }
    
    var pokemonDescription: some View {
        Text(model.descriptionText)
            .font(.callout)
            .foregroundColor(Color(hex: 0x666666))
            .fixedSize(horizontal: false, vertical: true)
    }
}

extension PokemonInfoPanel {
    struct Header: View {
        
        let model: PokemonViewModel
        
        var body: some View {
            HStack(spacing: 18) {
                
                nameSpecies
                    .offset(x: -20)
                verticalDivider
                VStack(spacing: 12) {
                    bodyStatus
                    typeInfo
                }
            }
        }
        
        var nameSpecies: some View {
            
            VStack(alignment: .center) {
                
                Spacer()
                
                VStack(alignment: .center) {
                    
                    Text(model.name)
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(model.color)
                    
                    
                    VStack(alignment: .trailing) {
                        Text(model.nameEN)
                            .font(.system(size: 13))
                            .fontWeight(.bold)
                            .foregroundColor(model.color)
                        
                        Text(model.genus)
                            .font(.system(size: 13))
                            .fontWeight(.bold)
                            .foregroundColor(Color.gray)
                    }
                    .alignmentGuide(HorizontalAlignment.center) { d in
                        d[.leading]
                    }
                }
                .fixedSize()
                .alignmentGuide(HorizontalAlignment.center) { d in
                    d[.leading]
                }
                
                
                
            }
        }
        
        var verticalDivider: some View {
            RoundedRectangle(cornerRadius: 1)
                .frame(width: 1, height: 44)
                .background(Color(hex: 0x000000, alpha: 0.1))
        }
        
        var bodyStatus: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("身高")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Text(model.height)
                        .font(.system(size: 11))
                        .foregroundColor(model.color)
                }
                
                HStack {
                    Text("身高")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Text(model.weight)
                        .font(.system(size: 11))
                        .foregroundColor(model.color)
                }
            }
        }
        
        var typeInfo: some View {
            HStack {
                if model.types.count == 0 {
                    EmptyView()
                } else if model.types.count == 1 {
                    PokemonInfoType(title: model.types[0].name, color: model.types[0].color)
                } else {
                    PokemonInfoType(title: model.types[0].name, color: model.types[0].color)
                    PokemonInfoType(title: model.types[1].name, color: model.types[1].color)
                    
                }
            }
        }
    }
}

struct PokemonInfoType: View {
    let title: String
    let color: Color
    
    
    var body: some View {
        Text(title)
            .font(.system(size: 12))
            .foregroundColor(.white)
            .frame(width: 36, height: 14)
            .cornerRadius(7)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
            )

    }
}

extension PokemonInfoPanel {
    
    struct AbilityList: View {
        let model: PokemonViewModel
        let abilityModels: [AbilityViewModel]?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("技能")
                    .font(.headline)
                    .fontWeight(.bold)
                
                if abilityModels != nil {
                    ForEach(abilityModels!) { ability in
                        Text(ability.name)
                            .font(.subheadline)
                            .foregroundColor(self.model.color)
                        Text(ability.descriptionText)
                            .font(.footnote)
                            .foregroundColor(Color(hex: 0xAAAAAA))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct PokemonInfoPanel_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                PokemonInfoPanel(model: PokemonViewModel.sample(id: 1))
                    .environmentObject(Store())
            }
        }
    }
}
