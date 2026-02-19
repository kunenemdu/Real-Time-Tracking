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
    @Published var allStops: [BusStop] = []
    @Published var nearestStops: [BusStop] = []
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
        self.allStops = loadBusStops()
        print(allStops.count)
    }
    
    // load all stops from json
    func loadBusStops() -> [BusStop] {
        // 1. Find the file in the Xcode project
        guard let url = Bundle.main.url(forResource: "stops", withExtension: "json") else {
            print("JSON file not found.")
            return []
        }
        
        do {
            // 2. Load the data from the file
            let data = try Data(contentsOf: url)
            
            // 3. Decode the JSON into an array of BusStop
            let decoder = JSONDecoder()
            do {
                let stops = try decoder.decode([BusStop].self, from: data)
                print("Successfully loaded \(stops.count) stops.")
                return stops
            } catch DecodingError.typeMismatch(let type, let context) {
                print("Type Mismatch: Expected \(type) at \(context.codingPath)")
            } catch {
                print("General Error: \(error)")
            }
            return []
            
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
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
          
}
