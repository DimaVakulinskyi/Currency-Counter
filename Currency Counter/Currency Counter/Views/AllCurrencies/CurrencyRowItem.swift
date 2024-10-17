//
//  CurrencyRowItem.swift
//  Currency Counter
//
//  Created by Dmytro Vakulinskyi on 17.10.2024.
//

import SwiftUI

struct CurrencyRowItem: View {
    let currency: Currency
    let isFavourite: Bool
    let toggleSelection: () -> Void
    
    var body: some View {
        HStack {
            Text(currency.code)
                .font(.headline)
                .foregroundStyle(Color.black)
            Text(String(format: "%.4f", currency.rate))
                .foregroundColor(.secondary)
            Spacer()
            Button(action: toggleSelection) {
                Text(isFavourite ? "Remove" : "Add")
                    .foregroundColor(.white)
                    .frame(width: 80, height: 40)
                    .background(isFavourite ? Color.lightGray : Color.primaryColor)
                    .cornerRadius(8)
            }
        }
        .frame(height: 60)
    }
}
