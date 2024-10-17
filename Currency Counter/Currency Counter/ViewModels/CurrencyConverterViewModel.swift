//
//  CurrencyConverterViewModel.swift
//  Currency Counter
//
//  Created by Dmytro Vakulinskyi on 17.10.2024.
//

import Combine
import SwiftUI

class CurrencyConverterViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var convertedAmount: String = ""
    
    private var networkService: NetworkService
    private var cancellable: AnyCancellable?
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func convertCurrency() {
        guard let amountDouble = Double(amount) else { return }
        
        cancellable = networkService.convertCurrency(amount: amountDouble)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Conversion failed: \(error.localizedDescription)")
                    self.convertedAmount = "Conversion failed"
                }
            }, receiveValue: { response in
                if response.success {
                    self.convertedAmount = String(format: "%.2f", response.result)
                }
            })
    }
}
