//
//  PokemonInfoRow.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/13.
//

import SwiftUI
import Kingfisher

struct PokemonInfoRow: View {
    
    let model: PokemonViewModel
    
    @EnvironmentObject var store: Store
    
    /// 扩展
    let expanded: Bool
    
    var isFav: Bool {
        (store.appState.settings.loginUser?.isFavoritePokemon(id: model.id) == true)
    }
        
    var body: some View {
        VStack {
            HStack {
                // 图片，名字
                KFImage(model.iconImageURL)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(model.name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    if store.appState.settings.showEnglishName {
                        Text(model.nameEN)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.top, 12)
            
            Spacer()
            
            HStack(spacing: expanded ? 20 : -30) {
                // 操作按钮
                Spacer()
                Button(action: {
                    if store.appState.settings.loginUser != nil {
                        self.store.dispatch(.toggleFavorite(index: model.id))
                    } else {
                        self.store.dispatch(.showError(aError: .requirestLogin))
                    }
                    
                }) {
                    
                    Image(systemName: isFav ? "star.fill" : "star")
                        .modifier(ToolButtonModifier())
                }
                Button(action: {
                    let target = !self.store.appState.pokemonList.selectionState.panelPresented
                    self.store.dispatch(.togglePanelPresenting(preseeting: target))
                }) {
                    Image(systemName: "chart.bar")
                        .modifier(ToolButtonModifier())
                }
                
               

                NavigationLink(isActive: expanded ? $store.appState.pokemonList.isSFViewAction :
                        .constant(false)
                ) {
                    SafariView(url: model.detailPageURL) {
                        self.store.dispatch(.togglePanelPresenting(preseeting: false))
                    } onFinished: {
                        self.store.dispatch(.closeSafariView)
                    }
                    .navigationBarTitle(Text(model.name), displayMode: .inline)

                        
                } label: {
                    Image(systemName: "info.circle")
                        .modifier(ToolButtonModifier())
                }

            }
            .padding(.bottom, 12)
            .opacity(expanded ? 1.0 : 0.0)
            .frame(maxHeight: expanded ? .infinity : 0)
        }
        .frame(height: expanded ? 120 : 80)
        .padding(.leading, 23)
        .padding(.trailing, 15)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(model.color, style: StrokeStyle(lineWidth: 4))
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, model.color]),
                            startPoint: .leading,
                            endPoint: .trailing)
                )
            }
        )
        .padding(.horizontal)
        .animation(
            .spring(
                response: 0.55,
                dampingFraction: 0.425,
                blendDuration: 0
            )
        )
    }
}

struct ToolButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
    }
}

struct PokemonInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PokemonInfoRow(model: PokemonViewModel.sample(id: 1), expanded: false)
            PokemonInfoRow(model: PokemonViewModel.sample(id: 21), expanded: true)
            PokemonInfoRow(model: PokemonViewModel.sample(id: 25), expanded: false)
        }
        .environmentObject(Store())
    }
}
