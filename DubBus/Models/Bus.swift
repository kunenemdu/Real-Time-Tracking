//
//  Bus.swift
//  DubBus
//
//

import Foundation
import CoreLocation

struct Bus: Identifiable {
    let id: String
    let routeNumber: String
    let coordinate: CLLocationCoordinate2D
}

struct BusStop: Identifiable, Codable {
    let stopID: String
    let stopCode: Int
    let name: String
    let latitude: Double
    let longitude: Double

    var id: String { stopID }

    enum CodingKeys: String, CodingKey {
        case stopID = "stop_id"
        case stopCode = "stop_code"
        case name = "stop_name"
        case latitude = "stop_lat"
        case longitude = "stop_lon"
    }

    // Custom initializer to handle the "Index 112" mismatch
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try to decode stopID as a String; if it fails, decode as Int and convert to String
        if let stringID = try? container.decode(String.self, forKey: .stopID) {
            self.stopID = stringID
        } else if let intID = try? container.decode(Int.self, forKey: .stopID) {
            self.stopID = String(intID)
        } else {
            throw DecodingError.typeMismatch(String.self, .init(codingPath: [CodingKeys.stopID], debugDescription: "stop_id is neither String nor Int"))
        }

        // Standard decoding for others
        self.stopCode = try container.decode(Int.self, forKey: .stopCode)
        self.name = try container.decode(String.self, forKey: .name)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
