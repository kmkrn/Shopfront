//
//  FruitListView.swift
//  Shopfront
//
//  Created by denpazakura on 27/08/2021.
//

import Combine
import SwiftUI

struct FruitListView: View {
    @ObservedObject var viewModel: FruitListViewModel
    @State private var isExpanded: Bool = false
    
    var body: some View {
        NavigationView {
            content
        }
        .onAppear { self.viewModel.send(event: .onAppear) }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return Color.clear.eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded(let items):
            return list(of: items).eraseToAnyView()
        }
    }
    
    private func list(of fruits: [FruitListViewModel.FruitListItem]) -> some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(spacing: 8) {                    
                    ForEach(0..<fruits.count) { i in
                        ShopfrontCardView(item: fruits[i], style: .minimalistic)
                    }
                    
                }
                
            }
            .padding([.top, .horizontal])
        }
    }
}
