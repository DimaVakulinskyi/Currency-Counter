//
//  CurrencyViewModel.swift
//  Currency Counter
//
//  Created by Dmytro Vakulinskyi on 16.10.2024.
//

import Foundation
import Combine

class CurrencyViewModel: ObservableObject {
    @Published var currencies: [Currency] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchCurrencies(sourceCurrency: String, selectedCurrencies: [String]? = nil) {
        networkService.fetchCurrencies(source: sourceCurrency, currencies: selectedCurrencies)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching currencies: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.currencies = response.quotes.map { key, value in
                    let currencyCode = String(key.dropFirst(sourceCurrency.count))
                    return Currency(code: currencyCode, rate: value)
                }
            })
            .store(in: &cancellables)
    }
}
