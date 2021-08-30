//
//  ShopfrontApp.swift
//  Shared
//
//  Created by denpazakura on 27/08/2021.
//

import SwiftUI

@main
struct ShopfrontApp: App {
    var body: some Scene {
        WindowGroup {
            FruitListView(viewModel: FruitListViewModel())
        }
    }
}
