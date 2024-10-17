//
//  FavouriteCurrencyService.swift
//  Currency Counter
//
//  Created by Dmytro Vakulinskyi on 16.10.2024.
//

import Foundation

class FavouriteCurrencyService: ObservableObject {
    @Published var selectedCurrencyCodes: [String] = [] {
        didSet {
            saveSelectedCurrencies()
        }
    }
    
    private let userDefaultsKey = "SelectedCurrencyCodes"
    
    init() {
        loadSelectedCurrencies()
    }
    
    private func saveSelectedCurrencies() {
        UserDefaults.standard.set(selectedCurrencyCodes, forKey: userDefaultsKey)
    }
    
    private func loadSelectedCurrencies() {
        if let savedCurrencies = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] {
            selectedCurrencyCodes = savedCurrencies
        } else {
            selectedCurrencyCodes = []
        }
    }
}
