//
//  BusViewModel.swift
//  DubBus
//
//


import Foundation
import Combine

class BusViewModel: ObservableObject {
    
    @Published var buses: [Bus] = []
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

}
