//
//  ConverterNavigationBarModifier.swift
//  Currency Counter
//
//  Created by Dmytro Vakulinskyi on 17.10.2024.
//

import SwiftUI

struct ConverterNavigationBarModifier: ViewModifier {
    let title: String
    @Environment(\.presentationMode) var presentationMode
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(title)
                    .font(.title2)
                    .foregroundStyle(Color.white)
                
                Spacer()
            }
            .padding()
            .background(Color.primaryColor)
            
            content
        }
        .navigationBarHidden(true)
    }
}

extension View {
    func converterNavigationModifier(title: String) -> some View {
        self.modifier(ConverterNavigationBarModifier(title: title))
    }
}
