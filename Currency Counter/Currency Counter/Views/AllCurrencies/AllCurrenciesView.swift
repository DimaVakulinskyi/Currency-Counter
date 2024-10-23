//
//  AllCurrenciesView.swift
//  Currency Counter
//
//  Created by Dmytro Vakulinskyi on 15.10.2024.
//

import SwiftUI

struct AllCurrenciesView: View {
    @StateObject private var localCurrencyService = LocalCurrencyService()
    @StateObject private var viewModel = CurrencyViewModel(networkService: NetworkService())
    
    @EnvironmentObject var favouriteCurrencyService: FavouriteCurrencyService
    
    @Binding var searchText: String
    
    @State private var selectedCurrency: Currency?
    @State private var showFullScreen = false
    
    var body: some View {
        VStack {
            if localCurrencyService.currencyCode != nil {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(viewModel.currencies.filter { searchText.isEmpty ? true : $0.code.localizedCaseInsensitiveContains(searchText) }) { currency in
                            CurrencyRowItem(
                                currency: currency,
                                isFavourite: favouriteCurrencyService.selectedCurrencyCodes.contains(currency.code),
                                toggleSelection: {
                                    toggleCurrencySelection(currency.code)
                                }
                            )
                            .onTapGesture {
                                selectedCurrency = currency
                                showFullScreen = true
                            }
                            Divider()
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                ProgressView("Loading currencies...")
                    .padding()
            }
        }
        .frame(maxHeight: .infinity)
        .fullScreenCover(isPresented: $showFullScreen) {
            CurrencyConverterView()
        }
        .mainNavigationBar(title: "All Currencies", searchText: $searchText)
        .onAppear {
            localCurrencyService.requestLocationPermission()
            if let currency = localCurrencyService.currencyCode {
                viewModel.fetchCurrencies(sourceCurrency: currency)
            }
        }
    }
    
    func toggleCurrencySelection(_ code: String) {
        if let index = favouriteCurrencyService.selectedCurrencyCodes.firstIndex(of: code) {
            favouriteCurrencyService.selectedCurrencyCodes.remove(at: index)
        } else {
            favouriteCurrencyService.selectedCurrencyCodes.append(code)
        }
    }
}
