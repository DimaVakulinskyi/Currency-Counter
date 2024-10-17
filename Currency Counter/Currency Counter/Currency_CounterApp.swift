//
//  Currency_CounterApp.swift
//  Currency Counter
//
//  Created by Dmytro Vakulinskyi on 15.10.2024.
//

import SwiftUI

@main
struct Currency_CounterApp: App {
    @StateObject private var favouriteCurrencyService = FavouriteCurrencyService()
    
    init() {
        setupTabBarAppearance()
    }
    
    private func setupTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color.primaryColor)
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.selected.iconColor = UIColor(Color.lightBlue)
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.lightBlue)]
        itemAppearance.normal.iconColor = UIColor(Color.lightGray)
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Color.lightGray)]
        
        tabBarAppearance.stackedLayoutAppearance = itemAppearance
        tabBarAppearance.inlineLayoutAppearance = itemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(favouriteCurrencyService)
                .preferredColorScheme(.light)
        }
    }
}
