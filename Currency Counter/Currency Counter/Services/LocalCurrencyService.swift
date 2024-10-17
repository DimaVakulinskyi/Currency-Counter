//
//  LocalCurrencyService.swift
//  Currency Counter
//
//  Created by Dmytro Vakulinskyi on 16.10.2024.
//

import CoreLocation
import Combine
import SwiftUI

class LocalCurrencyService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationService = CLLocationManager()
    @Published var error: Error?
    @Published var authorizationStatus: CLAuthorizationStatus
    
    @AppStorage("currencyCode") private var storedCurrencyCode: String?
    
    @Published var currencyCode: String? {
        didSet {
            storedCurrencyCode = currencyCode
        }
    }

    override init() {
        self.authorizationStatus = locationService.authorizationStatus
        super.init()
        locationService.delegate = self
        locationService.desiredAccuracy = kCLLocationAccuracyBest
        
        if let savedCurrencyCode = storedCurrencyCode {
            currencyCode = savedCurrencyCode
        }
    }

    func requestLocationPermission() {
        if storedCurrencyCode == nil {
            if authorizationStatus == .notDetermined {
                locationService.requestWhenInUseAuthorization()
            } else if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
                locationService.startUpdatingLocation()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first, storedCurrencyCode == nil else {
            locationService.stopUpdatingLocation()
            return
        }
        performReverseGeocoding(for: location)
    }

    private func performReverseGeocoding(for location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.error = error
                }
                return
            }
            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    self?.currencyCode = self?.currencyCode(for: placemark.isoCountryCode)
                    self?.locationService.stopUpdatingLocation()
                }
            }
        }
    }

    private func currencyCode(for countryCode: String?) -> String? {
        guard let countryCode = countryCode else { return nil }
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: countryCode]))
        return locale.currency?.identifier
    }
}
