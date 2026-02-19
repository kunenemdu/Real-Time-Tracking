//
//  MapViewModel.swift
//  DubBus
//
//

import CoreLocation
import MapKit
import SwiftUI
import Combine


final class MapScreenModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager
    
    // Center the camera on user immediately
    @Published var position: MapCameraPosition = .camera(
        MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 53.2875, longitude: -6.3664), distance: 2000))
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
    }
    
    func checkLocationEnabled () {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            
        } else {
            print("location services off")
        }
    }
    
    private func checkLocationAuthorization () {
        //guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            print("not determined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways, .authorizedWhenInUse:
            position = .camera(
                MapCamera(centerCoordinate:
                            CLLocationCoordinate2D(
                                latitude: locationManager.location!.coordinate.latitude,
                                longitude: locationManager.location!.coordinate.longitude),
                          distance: 2000))
            print("authorised when in use")
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
