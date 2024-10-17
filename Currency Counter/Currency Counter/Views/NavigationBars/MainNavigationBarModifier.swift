//
//  MainNavigationBarModifier.swift
//  Currency Counter
//
//  Created by Dmytro Vakulinskyi on 16.10.2024.
//

import SwiftUI

struct MainNavigationBarModifier: ViewModifier {
    let title: String
    @Binding var searchText: String
    @State private var isSearching = false
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            HStack {
                if !isSearching {
                    Text(title)
                        .font(.title)
                        .foregroundStyle(Color.white)
                } else {
                    HStack {
                        TextField("Search", text: $searchText)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            isSearching = false
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color.lightGray)
                        }
                    }
                }
                
                Spacer()
                
                if !isSearching {
                    Button(action: {
                        isSearching = true
                    }) {
                        Image(systemName: "magnifyingglass")
                            .tint(Color.lightGray)
                    }
                }
            }
            .padding()
            .background(Color.primaryColor)
            
            content
        }
        .navigationBarHidden(true)
    }
}

extension View {
    func mainNavigationBar(title: String, searchText: Binding<String>) -> some View {
        self.modifier(MainNavigationBarModifier(title: title, searchText: searchText))
    }
}
