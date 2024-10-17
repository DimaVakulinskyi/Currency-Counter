//
//  RootView.swift
//  Currency Counter
//
//  Created by Dmytro Vakulinskyi on 15.10.2024.
//

import SwiftUI

struct RootView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        TabView {
            AllCurrenciesView(searchText: $searchText)
                .tabItem {
                    Label("All currencies", image: "currency-coin-dollar")
                }
            MyCurrenciesView(searchText: $searchText)
                .tabItem {
                    Label("My currencies", image: "wallet-01")
                }
        }
    }
}
