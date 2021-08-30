//
//  CardView.swift
//  Shopfront (iOS)
//
//  Created by denpazakura on 27/08/2021.
//

import SwiftUI

struct ShopfrontCardView: View {
    private var item: FruitListViewModel.FruitListItem
    private let style: CardStyle
    
    @State var isExpanded = false
    @State private var isFullScreen = false
    
    init(item: FruitListViewModel.FruitListItem,
         style: CardStyle) {
        self.item = item
        self.style = style
    }
    
    var body: some View {
        VStack {
            ZStack {
                Image(item.filename)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: isExpanded ? UIScreen.main.bounds.height : 300, alignment: .leading)
                    .clipped()
                HStack {
                    if(isExpanded) {
                       Spacer()
                    }
                    
                    VStack(alignment: .leading) {
                        Text(verbatim: item.title)
                        Text("Profile")
                            .font(.system(size: 15, weight: .light, design: .monospaced))
                            .onTapGesture {
                                guard let url = item.url, UIApplication.shared.canOpenURL(url) else { return }
                                UIApplication.shared.open(url)
                            }
                    }
                    .layoutPriority(100)
                    Spacer()
                }
                .padding()
            }
        }
        .frame(height: isExpanded ? UIScreen.main.bounds.height : 300)
        .onTapGesture {
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                isExpanded.toggle()
            }
        }
        .cardStyle(style: style)
    }
}

private extension View {
    func cardStyle(style: CardStyle) -> some View {
        switch style {
        case .minimalistic:
            return AnyView(modifier(CardModifierMinimal()))
        case .roundedCorners:
            return AnyView(modifier(CardModifierRounded()))
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ShopfrontCardView(item: FruitListViewModel.FruitListItem.init(image: UnsplashImage(filename: "birgith-roosipuu-nectarines",
                                                                                           creator: "Birgith Roosipuu",
                                                                                           unsplash_url: " https://unsplash.com/photos/jFvhaeH1dJk")), style:  .minimalistic)
    }
}
