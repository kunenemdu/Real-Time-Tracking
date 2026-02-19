//
//  BusViewModel.swift
//  DubBus
//
//


import Foundation
import Combine
import MapKit

class BusViewModel: ObservableObject {
    
    @Published var buses: [Bus] = []
    var foundStops: [BusStop] = []
    private var timer: Timer?
    
    private let service = GTFSRService()
    
    func loadBuses() {
        service.fetchVehiclePositions { [weak self] buses in
            DispatchQueue.main.async {
                self?.buses = buses
            }
        }
    }
    
    func startLiveUpdates() {
        loadBuses()
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { _ in
            self.loadBuses()
        }
    }
    
    init() {
    }

    //closest stops to user
    func updateVisibleStops(near userLocation: CLLocation, allLoadedStops: [BusStop]) -> [BusStop] {
        let sorted = allLoadedStops.sorted {
            let loc1 = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
            let loc2 = CLLocation(latitude: $1.latitude, longitude: $1.longitude)
            return loc1.distance(from: userLocation) < loc2.distance(from: userLocation)
        }
        
        // Return only the 10 closest stops to prevent texture lag
        return Array(sorted.prefix(10))
    }
    
    func searchStops (named query: String, from allStops: [BusStop]){
        self.foundStops = allStops.filter { stop in
            stop.name.localizedCaseInsensitiveContains(query) ||
            String(stop.stopCode).contains(query)
        }
    }
          
}
