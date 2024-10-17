//
//  NetworkService.swift
//  Currency Counter
//
//  Created by Dmytro Vakulinskyi on 15.10.2024.
//

import Foundation
import Combine

class NetworkService: ObservableObject {
    private let accessKey: String
    private let baseURL = "https://api.exchangerate.host/live"
    
    init() {
        if let url = Bundle.main.url(forResource: "Config", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let config = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
           let key = config["CurrencyAccessKey"] as? String {
            accessKey = key
        } else {
            fatalError("CurrencyAccessKey not found in Config.plist")
        }
    }
    
    func fetchCurrencies(source: String, currencies: [String]? = nil) -> AnyPublisher<CurrencyResponse, Error> {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "access_key", value: accessKey),
            URLQueryItem(name: "source", value: source),
        ]
        
        if let currencies = currencies, !currencies.isEmpty {
            let currenciesString = currencies.joined(separator: ",")
            components.queryItems?.append(URLQueryItem(name: "currencies", value: currenciesString))
        }
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        print("Request URL: \(url)")
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: CurrencyResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func convertCurrency(amount: Double) -> AnyPublisher<ConvertResponse, Error> {
        let baseURL = "https://api.exchangerate.host/convert"
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "from", value: "EUR"),
            URLQueryItem(name: "to", value: "USD"),
            URLQueryItem(name: "amount", value: String(amount)),
            URLQueryItem(name: "access_key", value: accessKey)
        ]
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        print("Convert URL: \(url)")
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: ConvertResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
