//
//  DataHandler.swift
//  DubBus
//
//


import Foundation
import SwiftData

@MainActor
class DataHandler {
    static func seedStopsIfEmpty(context: ModelContext) {
        // Check if database already has stops
        let descriptor = FetchDescriptor<BusStop>()
        guard let count = try? context.fetchCount(descriptor), count == 0 else { return }

        // 1. Locate JSON
        guard let url = Bundle.main.url(forResource: "stops", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return }

        // 2. Decode using a temporary Decodable struct (since @Model is tricky to decode directly)
        struct RawStop: Decodable {
            let stop_code: Int
            let stop_name: String
            let stop_lat: Double
            let stop_lon: Double
        }

        do {
            let decoded = try JSONDecoder().decode([RawStop].self, from: data)
            
            // 3. Insert into SwiftData
            for rs in decoded {
                let newStop = BusStop(stopCode: rs.stop_code,
                                      name: rs.stop_name, 
                                      latitude: rs.stop_lat, 
                                      longitude: rs.stop_lon)
                context.insert(newStop)
            }
            try context.save()
        } catch {
            print("Failed to seed database: \(error)")
        }
    }
}
