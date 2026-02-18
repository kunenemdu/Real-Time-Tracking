//
//  GTFSRService.swift
//  DubBus
//
//


import Foundation
import CoreLocation

class GTFSRService {
    
    private let apiKey = "7b0bb4bd55db4795866890f524c2170f"
    
    func fetchVehiclePositions(completion: @escaping ([Bus]) -> Void) {
        
        guard let url = URL(string: "https://api.nationaltransport.ie/gtfsr/v2/Vehicles?format=json") else {
            completion([])
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(GTFSRResponse.self, from: data)
                
                print("Entities count:", decoded.entity.count)
                
                let buses = decoded.entity.compactMap { entity -> Bus? in
                    
                    guard let vehicle = entity.vehicle,
                          let position = vehicle.position,
                          let lat = position.latitude,
                          let lon = position.longitude else {
                        return nil
                    }
                    
                    return Bus(
                        id: vehicle.vehicle?.id ?? entity.id,
                        routeNumber: vehicle.trip?.routeId ?? "N/A",
                        coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    )
                }
                
                print("Parsed buses:", buses.count)

                
                completion(buses)
                
            } catch {
                print("JSON Decode Error:", error)
                completion([])
            }
            
        }.resume()
    }
}
