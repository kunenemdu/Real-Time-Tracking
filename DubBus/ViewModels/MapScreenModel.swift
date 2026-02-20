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
        print("checking location services")
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            
        } else {
            print("location services off")
        }
    }
    
    func checkLocationAuthorization () {
        print("checking location authorization")
        //guard let locationManager = locationManager else { return }
        
        // If we already have a location or are already authorized,
        // maybe we don't need to re-trigger the heavy setup.
        guard locationManager.authorizationStatus != .authorizedWhenInUse else {
            locationManager.startUpdatingLocation()
            return
        }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("not determined")
            locationManager.requestWhenInUseAuthorization()
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
