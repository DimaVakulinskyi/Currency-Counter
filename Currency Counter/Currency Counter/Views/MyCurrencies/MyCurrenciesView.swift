//
//  MyCurrenciesView.swift
//  Currency Counter
//
//  Created by Dmytro Vakulinskyi on 15.10.2024.
//

import SwiftUI

struct MyCurrenciesView: View {
    @EnvironmentObject var favouriteCurrencyService: FavouriteCurrencyService
    
    @ObservedObject private var localCurrencyService = LocalCurrencyService()
    @ObservedObject private var viewModel = CurrencyViewModel(networkService: NetworkService())
    
    @Binding var searchText: String
    
    @State private var swipeToDeleteOffset: [String: CGFloat] = [:]
    
    var body: some View {
        VStack {
            if favouriteCurrencyService.selectedCurrencyCodes.isEmpty {
                Text("No currencies selected.")
                    .foregroundColor(.gray)
                    .padding()
            } else if localCurrencyService.currencyCode != nil {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(viewModel.currencies.filter { searchText.isEmpty ? true : favouriteCurrencyService.selectedCurrencyCodes.contains($0.code) && $0.code.localizedCaseInsensitiveContains(searchText) }) { currency in
                            ZStack {
                                HStack {
                                    Spacer()
                                    Image(systemName: "trash")
                                        .foregroundColor(.white)
                                        .padding(.trailing)
                                }
                                .frame(height: 60)
                                .background(Color.red)
                                
                                MуCurrencyRowItem(currency: currency)
                                    .background(Color.white)
                                    .offset(x: swipeToDeleteOffset[currency.code] ?? 0)
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                
                                                if value.translation.width < 0 {
                                                    swipeToDeleteOffset[currency.code] = max(value.translation.width, -120)
                                                }
                                            }
                                            .onEnded { value in
                                                if value.translation.width < -100 {
                                                    withAnimation {
                                                        deleteCurrency(currency)
                                                    }
                                                } else {
                                                    withAnimation {
                                                        swipeToDeleteOffset[currency.code] = 0
                                                    }
                                                }
                                            }
                                    )
                            }
                            .frame(height: 60)
                            Divider()
                        }
                    }
                }
            }
        }
        .mainNavigationBar(title: "My Currencies", searchText: $searchText)
        .onAppear {
            if !favouriteCurrencyService.selectedCurrencyCodes.isEmpty, let currency = localCurrencyService.currencyCode {
                viewModel.fetchCurrencies(sourceCurrency: currency, selectedCurrencies: favouriteCurrencyService.selectedCurrencyCodes)
            }
        }
    }
    
    func deleteCurrency(_ currency: Currency) {
        favouriteCurrencyService.selectedCurrencyCodes.removeAll { $0 == currency.code }
        if let currencyCode = localCurrencyService.currencyCode {
            viewModel.fetchCurrencies(sourceCurrency: currencyCode, selectedCurrencies: favouriteCurrencyService.selectedCurrencyCodes)
        }
    }
}
