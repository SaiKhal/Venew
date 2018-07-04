//
//  LocationService.swift
//  Venew
//
//  Created by Masai Young on 7/2/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

final class LocationService {
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    // MARK: - Outputs
    let userLocation: Driver<CLLocation>
    let authorized: Driver<Bool>
    let areaName: Driver<String>
    
    init() {
        locationManager.distanceFilter = 20
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        userLocation = locationManager.rx.didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .filterEmpty()
            .map { $0.last! }
        
        areaName = userLocation
            .asObservable()
            .debug()
            .flatMapLatest(geocoder.placemark)
            .debug()
            .map { $0.locality ?? "No locaility given" }
            .asDriver(onErrorJustReturn: "Driver Error (areaName): Could not find city name")
        
        
        authorized = locationManager.rx.didChangeAuthorizationStatus
            .startWith(CLLocationManager.authorizationStatus())
            .asDriver(onErrorJustReturn: .notDetermined)
            .map { $0 == .authorizedWhenInUse ? true : false }
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension CLGeocoder {
    func placemark(location: CLLocation) -> Observable<CLPlacemark> {
        
        return Observable.create { observer in
            
            self.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
                if error != nil {
                    print(error!)
                    observer.onError(error!)
                }
                
                if let placemarks = placemarks, !placemarks.isEmpty {
                    observer.onNext(placemarks.first!)
                    observer.onCompleted()
                }
            })
            
            return Disposables.create()
        }
        
    }
}
