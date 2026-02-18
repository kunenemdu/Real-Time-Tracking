//
//  GTFSRResponse.swift
//  DubBus
//
//


import Foundation

struct GTFSRResponse: Codable {
    let entity: [FeedEntity]
}

struct FeedEntity: Codable {
    let id: String
    let vehicle: Vehicle?
}

struct Vehicle: Codable {
    let trip: Trip?
    let vehicle: VehicleDescriptor?
    let position: Position?
}

struct Trip: Codable {
    let routeId: String?
    
    enum CodingKeys: String, CodingKey {
        case routeId = "route_id"
    }
}

struct VehicleDescriptor: Codable {
    let id: String?
}

struct Position: Codable {
    let latitude: Double?
    let longitude: Double?
    let bearing: Double?
}
