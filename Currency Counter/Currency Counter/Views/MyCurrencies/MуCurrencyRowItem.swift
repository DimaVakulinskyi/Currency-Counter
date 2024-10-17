//
//  MуCurrencyRowItem.swift
//  Currency Counter
//
//  Created by Dmytro Vakulinskyi on 17.10.2024.
//

import SwiftUI

struct MуCurrencyRowItem: View {
    let currency: Currency
    
    var body: some View {
        HStack(spacing: 20) {
            Text(currency.code)
                .foregroundStyle(Color.black)
                .font(.headline)
            Text(String(format: "%.4f", currency.rate))
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(Color.white)
    }
}
