//
//  CurrencyConverterView.swift
//  Currency Counter
//
//  Created by Dmytro Vakulinskyi on 17.10.2024.
//

import SwiftUI

struct CurrencyConverterView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = CurrencyConverterViewModel(networkService: NetworkService())
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image("currency-euro")
                    .resizable()
                    .frame(width: 40, height: 40)
                Text("EUR")
                    .font(.headline)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    TextField("Amount", text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                        .padding(.bottom, 5)
                        .multilineTextAlignment(.trailing)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                }
                .frame(width: 100)
            }
            .frame(height: 60)
            .padding(.horizontal)
            
            HStack(spacing: 12) {
                Image("currency-dollar")
                    .resizable()
                    .frame(width: 40, height: 40)
                Text("USD")
                    .font(.headline)
                
                Spacer()
                
                if !viewModel.convertedAmount.isEmpty {
                    Text(viewModel.convertedAmount)
                        .font(.headline)
                        .multilineTextAlignment(.trailing)
                }
            }
            .frame(height: 60)
            .padding(.horizontal)
            
            Button(action: {
                viewModel.convertCurrency()
            }) {
                Text("Convert")
                    .foregroundStyle(.black)
                    .font(.headline)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding(.top, 20)
        .converterNavigationModifier(title: "Currency Converter")
    }
}
